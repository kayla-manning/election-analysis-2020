library(RCurl)
library(tidyverse)
library(janitor)
library(lubridate)

x <- getURL("https://raw.githubusercontent.com/fivethirtyeight/data/master/pollster-ratings/pollster-ratings.csv")
poll_ratings <- read.csv(text = x) %>% 
  clean_names()
polls_2020 <- read_csv("data/polls_2020.csv") %>% 
  mutate(end_date = mdy(end_date))
polls_2016 <- read_csv("data/polls_2016.csv")
popvote <- read_csv("data/popvote_1948-2016.csv") 
economy <- read_csv("data/econ.csv") %>% 
  clean_names()
approval <- read_csv("data/q3_approval.csv")
all_polls <- read_csv("data/pollavg_1968-2016.csv")

# joining data

vote_econ <- popvote %>% 
  full_join(economy, by = "year") %>% 
  full_join(approval, by = "year") %>% 
  full_join(all_polls %>% 
              filter(weeks_left == 6) %>% 
              group_by(year,party) %>% 
              summarise(avg_support=mean(avg_support)))

#######################################################
#######################################################

# exploring pollster quality data


# visualizing 2016 polls

all_polls %>% 
  filter(year == 2016) %>% 
  ggplot(aes(poll_date, avg_support, color = party)) +
  geom_line() +
  theme_classic()

# visualizing 2020 polls

polls_2020 %>% 
  filter(answer %in% c("Trump", "Biden")) %>%
  group_by(end_date, answer) %>% 
  summarise(avg_pct = mean(pct), .groups = "drop") %>% 
  mutate(end_year = year(end_date)) %>% 
  filter(end_year == 2020) %>% 
  ggplot(aes(end_date, avg_pct, color = answer)) +
  geom_line() +
  theme_classic() +
  scale_x_date(date_breaks = "1 month",
               date_labels = "%B")

#######################################################
# TRUMP MODEL
#######################################################

# building off of model 3 from last week, replacing q3_job_approval with
# avg_support brings adjusted r-squared up to 96.6%...... is that a bad thing?

inc_mod <- vote_econ %>% 
  filter(quarter == 1,
         incumbent_party == TRUE) %>% 
  lm(pv2p ~ (gdp_growth_qt + avg_support) * incumbent, data = .)

inc_mod %>% 
  summary()

# check with out-of-sample & classification accuracy

inc_leave_one_out <- function(x) 
{
  outsamp_mod <- vote_econ %>% 
    filter(quarter == 1,
           year != x,
           incumbent_party == TRUE) %>% 
    lm(pv2p ~ (gdp_growth_qt + avg_support) * incumbent, data = .)
  
  
  outsamp_pred <- predict(outsamp_mod, vote_econ %>% 
                                filter(quarter == 1,
                                       year == x,
                                       incumbent_party == TRUE))
}

# getting list of actual pv2p to compare to OOS predicted

inc_pv2ps <- vote_econ %>% 
  filter(incumbent_party == TRUE) %>% 
  group_by(year) %>% 
  summarise(pv2p = mean(pv2p))

# making tibble comparing actual vs predicted pv2p and classification

inc_validation <- tibble(year = seq(1948, 2016, by = 4),
  predicted_pv2p = sapply(year, inc_leave_one_out)) %>%
  left_join(inc_pv2ps, by = "year") %>% 
  rename(actual_pv2p = pv2p) %>% 
  mutate(predicted_classification = ifelse(predicted_pv2p > 50, 1, 0),
          actual_classification = ifelse(actual_pv2p > 50, 1, 0),
         right_class = ifelse(predicted_classification == actual_classification, 1, 0))

inc_validation

# Trump model correctly classified past pv2p victories 77% of the time

mean(inc_validation$right_class, na.rm = TRUE)


#######################################################
# BIDEN MODEL
#######################################################

# creating a model for Biden now
# q2 GDP growth give strongest adjusted r-squared of .7975

chal_mod <- vote_econ %>% 
  filter(quarter == 2,
         incumbent_party == FALSE) %>% 
  lm(pv2p ~ gdp_growth_qt + avg_support, data = .) 

chal_mod %>% 
  summary()

# check with out-of-sample & classification accuracy

chal_leave_one_out <- function(x) 
{
  outsamp_mod <- vote_econ %>% 
    filter(quarter == 2,
           year != x,
           incumbent_party == FALSE) %>% 
    lm(pv2p ~ gdp_growth_qt + avg_support, data = .)
  
  
  outsamp_pred <- predict(outsamp_mod, vote_econ %>% 
                            filter(quarter == 2,
                                   year == x,
                                   incumbent_party == FALSE))
}

# getting list of actual pv2p to compare to OOS predicted

chal_pv2ps <- vote_econ %>% 
  filter(incumbent_party == FALSE) %>% 
  group_by(year) %>% 
  summarise(pv2p = mean(pv2p))

# making tibble comparing actual vs predicted pv2p and classification

chal_validation <- tibble(year = seq(1948, 2016, by = 4),
                           predicted_pv2p = sapply(year, chal_leave_one_out)) %>%
  left_join(chal_pv2ps, by = "year") %>% 
  rename(actual_pv2p = pv2p) %>% 
  mutate(predicted_classification = ifelse(predicted_pv2p > 50, 1, 0),
         actual_classification = ifelse(actual_pv2p > 50, 1, 0),
         right_class = ifelse(predicted_classification == actual_classification, 1, 0))

chal_validation

# Biden model correctly classified past pv2p victories 69% of the time

mean(chal_validation$right_class, na.rm = TRUE)

#######################################################
# PREDICTIONS
#######################################################

# 538 updating poll average from lab

{
  poll_2020_url <- "https://projects.fivethirtyeight.com/2020-general-data/presidential_poll_averages_2020.csv"
  poll_2020_df <- read_csv(poll_2020_url)
  
  elxnday_2020 <- as.Date("11/3/2020", "%m/%d/%Y")
  dnc_2020 <- as.Date("8/20/2020", "%m/%d/%Y")
  rnc_2020 <- as.Date("8/27/2020", "%m/%d/%Y")
  
  colnames(poll_2020_df) <- c("year","state","poll_date","candidate_name","avg_support","avg_support_adj")
  
  poll_2020_df <- poll_2020_df %>%
    mutate(party = case_when(candidate_name == "Donald Trump" ~ "republican",
                             candidate_name == "Joseph R. Biden Jr." ~ "democrat"),
           poll_date = as.Date(poll_date, "%m/%d/%Y"),
           days_left = round(difftime(elxnday_2020, poll_date, unit="days")),
           weeks_left = round(difftime(elxnday_2020, poll_date, unit="weeks")),
           before_convention = case_when(poll_date < dnc_2020 & party == "democrat" ~ TRUE,
                                         poll_date < rnc_2020 & party == "republican" ~ TRUE,
                                         TRUE ~ FALSE)) %>%
    filter(!is.na(party)) %>%
    filter(state == "National")
}

# predicting Trump with incumbent model first... predicts 46.122%

trump_q1_gdp <- vote_econ %>% 
  filter(quarter == 1,
         year == 2020) %>% 
  pull(gdp_growth_qt)

trump_poll <- poll_2020_df %>% 
  filter(weeks_left == 6,
         party == "republican") %>% 
  pull(avg_support) %>% 
  mean()

predict(inc_mod, tibble(incumbent = TRUE, 
                        gdp_growth_qt = trump_q1_gdp, 
                        avg_support = trump_poll))

# now onto Biden... predicts 58.179%

biden_poll <- poll_2020_df %>% 
  filter(weeks_left == 6,
         party == "democrat") %>% 
  pull(avg_support) %>% 
  mean()

predict(chal_mod, tibble(gdp_growth_qt = trump_q1_gdp,
                         avg_support = biden_poll))



#######################################################
# WEIGHTED POLL MODEL
#######################################################

# going to compare 2016 polls to actual popular vote and then weight based on
# that

pv_2016 <- vote_econ %>% 
  filter(year == 2016) %>% 
  select(candidate, pv) %>% 
  mutate(candidate = case_when(candidate == "Clinton, Hillary" ~ "clinton",
                               candidate == "Trump, Donald J." ~ "trump")) %>% 
  group_by(candidate) %>% 
  summarise(pv = mean(pv)) %>% 
  pivot_wider(names_from = candidate, names_prefix = "pv_", values_from = pv)

polls_2016 <- polls_2016 %>% 
  mutate(createddate = mdy(createddate)) %>% 
  bind_cols(pv_2016) %>% 
  mutate(adj_error_clinton = adjpoll_clinton - pv_clinton,
         adj_error_trump = adjpoll_trump - pv_trump)

sept_errors <- polls_2016 %>% 
  mutate(month = month(createddate)) %>% 
  filter(month == 9,
         state == "U.S.") %>% 
  group_by(pollster) %>% 
  summarise(clinton = mean(adj_error_clinton),
            trump = mean(adj_error_trump)) %>%
  pivot_longer(2:3, names_to = "candidate") %>% 
  mutate(pollster = as_factor(pollster) %>% fct_reorder(value))

sept_errors %>% 
  mutate(positive = ifelse(value > 0, 1, 0) %>% as_factor()) %>% 
  ggplot(aes(pollster, value, fill = positive)) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(limits = c(-6, 6)) +
  facet_wrap(~ candidate) +
  geom_hline(yintercept = 0) +
  theme_classic() +
  scale_fill_manual(values = c("red3", "blue")) +
  theme(legend.position = "none") +
  labs(title = "Error in September 2016 Polls",
       x = "Pollster",
       y = "Average Error (Predicted - Actual)")
  
  

# how do I build a model off of individual polls from 2016 and 2020? don't I
# want more than a sample size of 1 previous election?

# think about how you would weight 2020 polls based on their performance in 2016

