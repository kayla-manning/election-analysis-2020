# loading packages that I need for this model

library(tidyverse)
library(janitor)
library(GGally)
library(broom)
library(purrr)

# uploading data from Canvas

economy <- read_csv("data/econ.csv") %>% 
  clean_names()
local <- read_csv("data/local.csv") %>% 
  clean_names()
popvote <- read_csv("data/popvote_1948-2016.csv")
popvote_state <- read_csv("data/popvote_bystate_1948-2016.csv") %>% 
  clean_names()

# joining national data together & state data together

national <- economy %>% 
  left_join(popvote, by = "year")

incumbents <- national %>% 
  select(year, party, incumbent, incumbent_party, gdp_growth_qt, quarter)

state <- local %>% 
  left_join(popvote_state, by = c("year", "state_and_area" = "state")) %>% 
  filter(!str_detect(state_and_area, "County|city")) %>% 
  select(-1) %>% 
  pivot_longer(cols = c(d_pv2p, r_pv2p), names_to = "party", values_to = "pv2p") %>% 
  mutate(party = recode(party, "d_pv2p" = "democrat", "r_pv2p" = "republican"),
         quarter = case_when(month %in% c("01", "02", "03") ~ 1,
                             month %in% c("04", "05", "06") ~ 2,
                             month %in% c("07", "08", "09") ~ 3,
                             month %in% c("10", "11", "12") ~ 4)) %>% 
  full_join(incumbents, by = c("year", "party", "quarter"), suffix = c("_state", "_national")) %>% 
  rename(state = state_and_area) %>% 
  drop_na(state)


# creating a linear model with Q1 and Q2 RDI and GDP
# adjusted r-squared of 0.5 and all predictors have p-value ~0.3

national %>% 
  drop_na(candidate) %>% 
  select(year, quarter, candidate, incumbent, incumbent_party, gdp_growth_qt, gdp_growth_yr, rdi_growth, unemployment, pv2p, ) %>% 
  mutate(quarter = paste("q", quarter, sep = "")) %>% 
  pivot_wider(names_from = quarter, values_from = 6:9) %>% 
  group_by(year, candidate) %>% 
  summarise_all(., ~ mean(., na.rm = TRUE)) %>% 
  filter(incumbent_party == TRUE,
         incumbent == TRUE) %>% 
  lm(pv2p ~ gdp_growth_qt_q2 + rdi_growth_q2 + unemployment_q2, data = .) %>% 
  glance()



# exploring variables that might be good predictors
# Q2 gdp_growth_qt, gdp_growth_yr, and rdi_growth have the strongest correlation with incumbent vote share

national %>% 
  filter(incumbent_party == TRUE,
         quarter == 2) %>% 
  select(pv2p, gdp_growth_qt, gdp_growth_yr, rdi_growth, inflation, unemployment) %>% 
  ggpairs()


# making a model mapping incumbent vote share by Q2 gdp_growth_yr and rdi_growth, has adjusted r-squared of 0.506
# but none of the predictors are significant?

national %>% 
  filter(quarter == 2,
         incumbent == TRUE) %>% 
  lm(pv2p ~ gdp_growth_qt + rdi_growth, data = .) %>% 
  glance()

national %>% 
  filter(quarter == 2,
         incumbent == TRUE) %>% 
  ggplot(aes(rdi_growth, pv2p)) +
  geom_point() +
  theme_classic()

#############################################################################################################

# example from lab only has an adjusted r-squared of 28.4% but at least it's
# significant. adding incumbent and incumbent party to the mix shows that
# sitting presidents do better

# adjusted r-squared of 0.383

int_gdp_q2_mod <- national %>% 
  filter(quarter == 2,
         incumbent_party == TRUE) %>% 
  lm(pv2p ~ gdp_growth_qt * incumbent, data = .)

q2_2020_gdp <- national %>% 
  filter(year == 2020,
         quarter == 2) %>% 
  pull(gdp_growth_qt)

predict(int_gdp_q2_mod, tibble(gdp_growth_qt = q2_2020_gdp,
                               incumbent = TRUE))

# going to make a model excluding 2016 and then test the fit

outsamp_inc_mod <- national %>% 
  filter(quarter == 2,
         year != 2016) %>% 
  lm(pv2p ~ gdp_growth_qt * (incumbent + incumbent_party), data = .)


outsamp_inc_pred <- predict(outsamp_inc_mod, national %>% 
                              filter(quarter == 2,
                                     year == 2016))

outsamp_inc_pred - national %>% filter(year == 2016, quarter == 2) %>% pull(pv2p)

# graphing pv2p ~ gdp_growth_qt, faceting by incumbent and incumbent party

# facet labels for incumbent party
incumbent_party_labs <- c("Incumbent Party", "Non-Incumbent Party")
names(incumbent_party_labs) <- (c(TRUE, FALSE))

# facet labels for incumbent candidate
incumbent_labs <- c("Incumbent Candidate", "Non-Incumbent Candidate")
names(incumbent_labs) <- (c(TRUE, FALSE))

national %>% 
  drop_na(incumbent, incumbent_party) %>% 
  filter(quarter == 2,
         !(incumbent == TRUE & incumbent_party == FALSE)) %>% 
  ggplot(aes(gdp_growth_qt, pv2p)) +
  geom_point() +
  facet_wrap(~ incumbent_party + incumbent,
             labeller = labeller(incumbent_party = incumbent_party_labs,
                                 incumbent = incumbent_labs)) +
  xlim(c(-2.5, 2.5)) +
  geom_smooth(method = "lm", se = 0, color = "red3") +
  theme_classic() +
  labs(title = "Relationship Between Incumbency and Q2 GDP Growth with Two-Party Vote Share",
       x = "Q2 GDP Growth",
       y = "Two-Party Popular Vote Share")

ggsave("figures/economy/inc_gdp_q2.jpg")

# plotting the residuals of the model.. clear pattern in the plot indicates that
# this model is not a good fit

national %>% 
  filter(quarter == 2) %>% 
  lm(pv2p ~ gdp_growth_qt * (incumbent + incumbent_party), data = .) %>% 
  augment() %>% 
  ggplot(aes(pv2p, .resid)) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red") +
  theme_classic() +
  labs(title = "Residuals of Modeling Incumbency and Q2 GDP Growth with Two-Party Vote Share",
       x = "Two-Party Popular Vote Share",
       y = "Residuals")

#############################################################################################################

# trying to do a state-by-state regression



# wrote a function to leave out whichever year is input

leave_out_one <- function(x) {

# building model without a year

state_mod <- state %>% 
  filter(year != x,
         incumbent_party == TRUE,
         quarter == 2) %>% 
  group_by(state) %>% 
  nest(.) %>% 
  mutate(mod = map(data, ~lm(pv2p ~ unemployed_prce + incumbent + gdp_growth_qt, data = .)),
         reg_results = map(mod, ~tidy(.))) %>% 
  unnest(reg_results) %>% 
  pivot_wider(names_from = term, values_from = estimate) %>% 
  group_by(state) %>% 
  summarise(intercept = mean(`(Intercept)`, na.rm = TRUE),
            unemployed_prce = mean(unemployed_prce, na.rm = TRUE),
            incumbentTRUE = mean(incumbentTRUE, na.rm = TRUE),
            gdp_growth_qt = mean(gdp_growth_qt, na.rm = TRUE))

# getting just that year's data so I can predict with model

state_votes <- state %>% 
  filter(year == x,
         incumbent_party == TRUE,
         quarter == 2) %>% 
  group_by(state) %>% 
  summarise(pv2p = mean(pv2p)) %>% 
  select(state, pv2p)

outsamp_state <- state %>% 
  filter(year == x,
         incumbent_party == TRUE,
         quarter == 2) %>% 
  group_by(state) %>% 
  summarise(unemployed_prce = mean(unemployed_prce),
            incumbent = mean(incumbent),
            gdp_growth_qt = mean(gdp_growth_qt)) %>% 
  inner_join(state_mod, by = "state", suffix = c("_16", "_mod")) %>% 
  mutate(predict_pv2p = intercept + unemployed_prce_16 * unemployed_prce_mod + 
           incumbent * incumbentTRUE + gdp_growth_qt_16 * gdp_growth_qt_mod) %>% 
  inner_join(state_votes, by = "state") %>% 
  mutate(residual = pv2p - predict_pv2p)

outsamp_state %>% 
  ggplot(aes(pv2p, residual)) +
  geom_point() +
  theme_classic() +
  labs(title = "Residuals of Out-of-Sample Predictions",
       x = "Two-Party Incumbent Vote Share",
       y = "Residual")


}


#############################################################################################################


# replicating NYT q2 graph

national %>% 
  filter(quarter == 2) %>% 
  mutate(negative = as_factor(ifelse(gdp_growth_qt < 0, 1, 0))) %>% 
  ggplot(aes(year, gdp_growth_qt, fill = negative)) +
  geom_col() +
  theme_classic() +
  scale_fill_manual(values = c("gray", "red3")) +
  labs(title = "Q2 2020 Marks a Historic Drop in GDP",
       x = "Year",
       y = "Q2 GDP Growth from Previous Quarter") +
  theme(legend.position = "none")

ggsave("figures/economy/q2gdp.jpg")


