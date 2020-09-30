#######################################################
# SET-UP
#######################################################

library(tidyverse)
library(usmap)
library(janitor)
library(readxl)

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
    breaks = c(60, 80, 100, 120, 140, 160),
    labels = c(60, 80, 100, 120, 140, 160)
  ) +
  theme_void() +
  labs(title = "COVID-19 Grants Per Capita in Swing States")

plot_usmap(data = state_covid, values = "covid_pc_spending", labels = TRUE,
           include = core_2008) +
  scale_fill_gradient(
    high = "red3",
    low = "white",
    name = "COVID Spending Per Capita"
  ) +
  theme_void() +
  labs(title = "COVID-19 Grants Per Capita in Core States")

# per capita spending for swing/core states

x %>% 
  inner_join(state_covid, by = c("state_abb" = "state")) %>% 
  group_by(swing_core, term_year) %>% 
  summarise(avg_covid_pc_spending = mean(covid_pc_spending)) %>% 
  drop_na(swing_core) %>% 
  ggplot(aes(term_year, avg_covid_pc_spending)) +
  geom_col(fill = "red3") +
  facet_wrap(~ swing_core)


#######################################################
# VUPDATING MODEL
#######################################################

