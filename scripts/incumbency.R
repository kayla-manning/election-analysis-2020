#######################################################
# SET-UP
#######################################################

library(tidyverse)
library(usmap)
library(janitor)
library(readxl)
library(broom)

# funding data at state & county level

grants_state <- read_csv("data/fedgrants_bystate_1988-2008.csv")
grants_county <- read_csv("data/fedgrants_bycounty_1988-2008.csv")

# loading in Census population data with HHS COVID numbers to find spending per
# capita

state_pops_2000s <- read_excel("data/state_pops_2000s.xls", skip = 3) %>% 
  clean_names() %>% 
  rename(state = x1) %>% 
  mutate(state = gsub("\\.", "", state),
         state = state.abb[match(state, state.name)]) %>% 
  drop_na(state) %>% 
  pivot_longer(3:12, names_to = "year", values_to = "population") %>% 
  mutate(year = gsub("x", "", year),
         year = as.numeric(year)) %>% 
  select(state, year, population)

state_populations <- read_excel("data/state_populations.xlsx", skip = 3) %>% 
  clean_names() %>% 
  rename(state = x1) %>% 
  drop_na(census) %>% 
  mutate(state = gsub("\\.", "", state),
         state = state.abb[match(state, state.name)]) %>% 
  drop_na(state) %>% 
  pivot_longer(4:13, names_to = "year", values_to = "population") %>% 
  mutate(year = gsub("x", "", year),
         year = as.numeric(year)) %>% 
  select(state, year, population) %>% 
  bind_rows(state_pops_2000s)

# covid funding from HHS

covid_funding <- read_csv("data/covid_funding.csv", skip = 1) %>% 
  clean_names() %>% 
  mutate(award_amount = gsub("\\$", "", award_amount),
         award_amount = as.numeric(gsub(",", "", award_amount)),
         sign = ifelse(str_detect(award_amount, "-"), -1, 1),
         award_amount = gsub("-", "", award_amount) %>% as.numeric(),
         award_amount = award_amount * sign) %>% 
  select(-sign) %>% 
  left_join(state_populations %>% filter(year == 2019), by = "state") %>% 
  rename(covid_award = award_amount,
         pop_2019 = population)

# data for last week's "both model"

economy <- read_csv("data/econ.csv") %>% 
  clean_names()
approval <- read_csv("data/q3_approval.csv")
all_polls <- read_csv("data/pollavg_1968-2016.csv")
popvote_state <- read_csv("data/popvote_bystate_1948-2016.csv")

vote_econ <- popvote %>% 
  full_join(economy, by = "year") %>% 
  full_join(approval, by = "year") %>% 
  full_join(all_polls %>% 
              filter(weeks_left == 6) %>% 
              group_by(year,party) %>% 
              summarise(avg_support = mean(avg_support)))

# data for time-for-change model (from lab)

popvote_df <- read_csv("data/popvote_1948-2016.csv")
pvstate_df <- read_csv("data/popvote_bystate_1948-2016.csv")
economy_df <- read_csv("data/econ.csv")
approval_df <- read_csv("data/approval_gallup_1941-2020.csv")
pollstate_df <- read_csv("data/pollavg_bystate_1968-2016.csv")
fedgrants_df <- read_csv("data/fedgrants_bystate_1988-2008.csv")

#######################################################
# VISUALIZING COVID-19 SPENDING
#######################################################

# wanting to look at spending in election vs non-election years
# getting data ready

x <- grants_state %>% 
  mutate(term_year = case_when(
    year %% 4 == 0 ~ 4,
    year %% 4 == 1 ~ 1,
    year %% 4 == 2 ~ 2,
    year %% 4 == 3 ~ 3),
    term_year = as_factor(term_year),
    swing_core = case_when(
      str_detect(state_year_type, "core") ~ "core",
      str_detect(state_year_type, "swing") ~ "swing")) %>% 
  left_join(state_populations, by = c("state_abb" = "state", "year"))

# barplot with the average overall spending for each term year for swing/core
# states... federal spending in 4th year of term is through the roof for core
# states

x %>% 
  drop_na(swing_core) %>% 
  mutate(pc_spending = grant_mil / population * 10^6) %>% 
  group_by(swing_core, term_year) %>% 
  summarise(avg_pc_spending = mean(pc_spending, na.rm = TRUE), .groups = "drop") %>% 
  ggplot(aes(swing_core, avg_pc_spending, fill = term_year)) +
  geom_col(position = "dodge") +
  theme_classic() +
  scale_fill_brewer(palette = "Reds") +
  labs(title = "Comparing Federal Grant Spending in Core and Swing States",
       x = "Type of State",
       y = "Average Per Capita Federal Grant Spending ($)",
       fill = "Year of Term") +
  scale_x_discrete(labels = c("Core", "Swing")) 

x %>% 
  drop_na(swing_core) %>% 
  mutate(pc_spending = grant_mil / population) %>% 
  arrange(desc(pc_spending)) %>% 
  select(state_abb, year, elxn_year, swing_core, pc_spending, population, grant_mil, term_year)


# want to make a heat map of spending in states

spending_2008 <- x %>% 
  filter(year == 2008) %>% 
  group_by(state_abb) %>% 
  summarise(avg_spending = mean(grant_mil)) %>% 
  ungroup() %>%  
  select(state_abb, avg_spending) %>% 
  rename(state = state_abb)

plot_usmap(spending_2008, regions = "states",
           values = "avg_spending", labels = TRUE) +
  scale_fill_gradient2(
    high = "blue", 
    mid = "white",
    low = "red",
    breaks = c(-0.1,-0.05,0.05,0.1), 
    limits = c(-0.15,0.15),
    name = "Change in Proportion \nof Democratic Votes"
  ) +
  theme_void() +
  labs(title = "Electoral Swing from 2012 to 2016")

# heat map of covid spending... load in correct data

state_covid <- covid_funding %>% 
  group_by(state, pop_2019) %>% 
  summarise(total_spending = sum(covid_award)) %>%
  drop_na(state) %>% 
  mutate(covid_pc_spending = total_spending / pop_2019) %>% 
  filter(state != "AK")

plot_usmap(data = state_covid, values = "covid_pc_spending", labels = TRUE) +
  scale_fill_gradient(
    high = "red3",
    low = "white",
    name = "COVID Spending Per Capita"
  ) +
  theme_void() +
  labs(title = "COVID-19 Awards by State")

# isolating core vs swing states

states_type_2008 <- x %>% 
  filter(year == 2008) %>% 
  select(state_abb, swing_core) %>% 
  drop_na(swing_core)

swing_2008 <- states_type_2008 %>% 
  filter(swing_core == "swing") %>% 
  pull(state_abb)

core_2008 <- states_type_2008 %>% 
  filter(swing_core == "core",
         state_abb != "AK") %>% 
  pull(state_abb)

plot_usmap(data = state_covid, values = "covid_pc_spending", labels = TRUE,
           include = swing_2008) +
  scale_fill_gradient(
    high = "red3",
    low = "white",
    name = "COVID Spending Per Capita",
    limits = c(40, 170)
  ) +
  theme_void() +
  labs(title = "COVID-19 Grants Per Capita in Swing States")

plot_usmap(data = state_covid, values = "covid_pc_spending", labels = TRUE,
           include = core_2008) +
  scale_fill_gradient(
    high = "red3",
    low = "white",
    name = "COVID Spending Per Capita",
    limits = c(40, 170)
  ) +
  theme_void() +
  labs(title = "COVID-19 Grants Per Capita in Core States")

# per capita spending for swing/core states

x %>% 
  inner_join(state_covid, by = c("state_abb" = "state")) %>% 
  group_by(swing_core) %>% 
  summarise(avg_covid_pc_spending = mean(covid_pc_spending),
            se = sd(covid_pc_spending) / sqrt(n()),
            conf_low = avg_covid_pc_spending - 1.96 * se,
            conf_high = avg_covid_pc_spending + 1.96 * se) %>% 
  drop_na(swing_core) %>% 
  ggplot(aes(swing_core, avg_covid_pc_spending)) +
  geom_col(position = "dodge", fill = "red3") +
  geom_errorbar(aes(ymin = conf_low, ymax = conf_high), width = 0.2) +
  theme_classic() +
  labs(title = "Comparing COVID-19 Grants in Core and Swing States",
       x = "Type of State",
       y = "Average Per Capita Federal Grant Spending ($)",
       fill = "Year of Term") +
  scale_x_discrete(labels = c("Core", "Swing")) +
  coord_flip()
  


#######################################################
# COMPARING MODELS, BOTH_MOD VS TIME-FOR-CHANGE
#######################################################

# last week's model

both_mod <- vote_econ %>% 
  filter(quarter == 1) %>% 
  lm(pv ~ gdp_growth_qt + avg_support * incumbent, data = .)

both_mod %>% 
  summary()

# OOS validation was at 80.1% proper classification last week

# making predictions with the both model
# put Biden at receiving ~51.2% and Trump ~47.6%

biden_predict <- predict(both_mod, tibble(gdp_growth_qt = trump_q1_gdp,
                                          avg_support = biden_poll,
                                          incumbent = FALSE))
biden_predict


trump_predict <- predict(both_mod, tibble(gdp_growth_qt = trump_q1_gdp,
                                          avg_support = trump_poll,
                                          incumbent = TRUE))
trump_predict

#######################################################

# time-for-change model... getting data ready

tfc_df <- popvote_df %>%
  filter(incumbent_party) %>%
  select(year, candidate, party, pv, pv2p, incumbent) %>%
  inner_join(
    approval_df %>% 
      group_by(year, president) %>% 
      slice(1) %>% 
      mutate(net_approve=approve-disapprove) %>%
      select(year, incumbent_pres=president, net_approve, poll_enddate),
    by="year"
  ) %>%
  inner_join(
    economy_df %>%
      filter(quarter == 2) %>%
      select(GDP_growth_qt, year),
    by="year"
  )

# fitting model, has adj. r-squared of 61.7%

tfc_mod <- tfc_df %>% 
  lm(pv2p ~ GDP_growth_qt + net_approve + incumbent, data = .)
tfc_mod %>% 
  summary()

tfc_mod %>% 
  tidy() %>% 
  gt() %>% 
  tab_header(title = "Time for Change Regression Output")

# evaluating OOS fit

tfc_leave_one_out <- function(x, y)
{
  outsamp_mod <- tfc_df %>% 
    filter(year != x,
           incumbent != y) %>% 
    lm(pv2p ~ GDP_growth_qt + net_approve + incumbent, data = .)
  
  outsamp_pred <- predict(outsamp_mod, tfc_df %>% 
                            filter(year == x,
                                   incumbent == y))
  outsamp_pred
}

tfc_pv2p <- tfc_df %>%  
  group_by(year, incumbent, party) %>% 
  summarise(actual_pv2p = mean(pv2p)) %>% 
  drop_na(actual_pv2p)

# making tibble comparing actual vs predicted pv and classification

tfc_validation <- tfc_pv2p %>% 
  mutate(predicted_pv2p = tfc_leave_one_out(year, incumbent)) %>%
  drop_na(predicted_pv2p) %>% 
  mutate(predicted_classification = ifelse(predicted_pv2p > 50, TRUE, FALSE),
         actual_classification = ifelse(actual_pv2p > 50, TRUE, FALSE),
         right_class = ifelse(predicted_classification == actual_classification, TRUE, FALSE))
tfc_validation %>% 
  ungroup() %>% 
  gt() %>% 
  tab_header(title = "Leave-One-Out Classification for Time-for-Change Model",
             subtitle = "") %>% 
  cols_label(year = "Year",
             incumbent = "Incumbent",
             party = "Party",
             predicted_pv2p = "Predicted Two-Party Vote Share",
             actual_pv2p = "Actual Two-Party Vote Share",
             predicted_classification = "Predicted Classification",
             actual_classification = "Actual Classification",
             right_class = "Correct Classification") %>% 
  tab_footnote(locations = cells_column_labels(columns = vars(right_class, predicted_classification)),
               footnote = c("Correctly predicted the two-party popular vote winner of 66.6% of the elections",
                            "Classified as TRUE if the predicted two-party popular vote is greater than 50% and FALSE otherwise")) 

# correctly classified 66.7% (2/3) of past elections -- important to note that
# this model works for incumbent party only

mean(tfc_validation$right_class)


