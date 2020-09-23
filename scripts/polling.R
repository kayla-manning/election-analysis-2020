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
  left_join(economy, by = "year") %>% 
  left_join(approval, by = "year") %>% 
  full_join(all_polls %>% 
              filter(weeks_left == 6) %>% 
              group_by(year,party) %>% 
              summarise(avg_support=mean(avg_support)))

#######################################################
#######################################################

# exploring pollster quality data

poll_ratings %>% 
  mutate(misses_outside_moe = str_remove(misses_outside_moe, "%") %>% as.numeric(),
         races_called_correctly = str_remove(races_called_correctly, "%") %>% as.numeric()) %>% 
  ggplot(aes(races_called_correctly, misses_outside_moe)) +
  geom_point()


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

# check with out-of-sample & classification accuracy

inc_mod <- vote_econ %>% 
  filter(quarter == 1,
         incumbent_party == TRUE) %>% 
  lm(pv2p ~ (gdp_growth_qt + avg_support) * incumbent, data = .)

inc_mod %>% 
  summary()

leave_one_out <- function(x) 
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


pv2ps <- vote_econ %>% 
  filter(incumbent_party == TRUE) %>% 
  group_by(year) %>% 
  summarise(pv2p = mean(pv2p))


trump_validation <- tibble(year = seq(1948, 2016, by = 4),
  predicted_pv2p = sapply(year, leave_one_out)) %>%
  left_join(pv2ps, by = "year") %>% 
  rename(actual_pv2p = pv2p) %>% 
  mutate(predicted_classification = ifelse(predicted_pv2p > 50, 1, 0),
          actual_classification = ifelse(actual_pv2p > 50, 1, 0),
         right_class = ifelse(predicted_classification == actual_classification, 1, 0))

# Trump model correctly classified past pv victories 77% of the time

mean(trump_validation$right_class, na.rm = TRUE)


#######################################################
# BIDEN MODEL
#######################################################

# creating a model for Biden now
# q2 GDP growth give strongest adjusted r-squared

vote_econ %>% 
  filter(quarter == 2,
         incumbent_party == FALSE) %>% 
  lm(pv2p ~ gdp_growth_qt + avg_support, data = .) %>% 
  summary()


# do I need to make a separate model for incumbent and challenger? removing
# incumbent_party filter weakens the model significantly. also, where do I get
# the 2020 poll numbers for Trump and Biden?

# 538 updating poll average




# how do I build a model off of individual polls from 2016 and 2020? don't I
# want more than a sample size of 1 previous election?

# think about how you would weight 2020 polls based on their performance in 2016

