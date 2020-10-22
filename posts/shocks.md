# Shocks and Elections: COVID-19
## October 24, 2020

# **DRAFT**

### What the Literature Says about Shocks

The media loves a good "October Surprise," and 2020 has had its fair share of newsworthy events. COVID-19 consistently remains the defining issue of 2020, despite other scandals ranging from [tax avoidance](https://www.nytimes.com/interactive/2020/09/27/us/donald-trump-taxes.html) by the president, [misleading the public](https://www.nytimes.com/2020/09/09/us/politics/woodward-trump-book-virus.html) on the state of COVID-19, and accusations of suspicious [emails](https://www.vox.com/2020/10/14/21515776/hunter-biden-emails-giuliani). How will the shock of COVID-19 translate into electoral outcomes?

It certainly sounds interesting to think that shark attacks[^achen] led to Woodrow Wilson's defeat in the 1916 election, but most sensational headlines come from flawed statistics.[^fowler] Voter behavior punishing incumbents for natural events seems irrational; however, voters can reasonably fault the incumbent for *certain results* of the such events. For example, voters punish incumbents for economic damage resulting from tornadoes[^healy] but not death counts. When focusing on economic repercussions of tornadoes, the incumbent can issue a disaster declaration and attempt to minimize economic damage. This study supports the notion that voters do in fact behave rationally and respond to how the incumbent *handles* such shocks rather than blaming the incumbent for the occurrence of the events.


### The Impact of COVID-19 on the 2020 Election

The pandemic wreaked havoc on the emotional and economic well-being of Americans. The [economic numbers](economy.md) of 2020 undoubtedly reflect the damage of COVID; incorporating economic data into predictions helps to account for some of the pandemic-related fallout. Under the assumption of rational voting behavior, voters may reasonably punish Donald Trump for his handling of the pandemic. However, voters may also feel that he mishandled less concrete aspects of the pandemic, such as his [hesitancy](https://www.bbc.com/news/world-us-canada-53378439) to wear a [mask](https://www.nytimes.com/2020/10/02/us/politics/donald-trump-masks.html) or his COVID-19 [diagnosis](https://www.npr.org/sections/latest-updates-trump-covid-19-results/2020/10/03/919898777/timeline-what-we-know-of-president-trumps-covid-19-diagnosis) late in the campaign.

Voters' emotional responses to events may exist independent of economic circumstances. In this situation, national and statewide polls should capture voters' responses to the state of the pandemic and other current events. Examining COVID-19 metrics, for example, shows that the COVID death count and increases in positive test counts have fairly strong, negative correlations with Donald Trump's approval ratings:[^metrics]

![covid](../figures/shocks/covid_polls.jpg)

Not surprisingly, public opinion regarding Donald Trump's handling of the COVID-19 crisis has a moderately strong, positive correlation with his overall polling numbers, and Biden's poll numbers have a negative correlation with Trump's COVID approval:

![covid_approval](../figures/shocks/covid_approval.jpg)

Since COVID metrics and COVID-specific approval are correlated with variables already included in my models, I will avoid redundancy by using polls and economic metrics as proxies for the impact of COVID.

### Modeling with Economic Numbers and Polls, by State

A few modifications to [last week's](turnout.md) model led to much more reasonable predictions. As I mentioned in the previous post, fitting a separate model for each state left each model extremely susceptible to overfitting and poor out-of-sample performance. To fix this, I made the following changes:

* I fit separate models for 3 different categories of states--likely blue states, likely red states, and battleground states[^categories]--with the thinking that voters within groups of states exhibit similar behavior in elections. This method uses each state in every election as an individual observation, which drastically increased the size of the sample from which I constructed the model.

* For the sake of parsimony, I omitted several predictor variables from last week's model.[^parsimony] This new model predicts each party's votes using the average of state and national polling numbers from 2 weeks out, the candidate's incumbency status, the interaction between incumbency and polls, national Q1 GDP growth, the previous election's Democratic vote margin in that state, and the change in that state's Black population.

I maintained the underlying binomial logistic structure from last week, and I varied the turnout as I did before. This method forecasts an electoral count of 305 for Biden, but the model projects many close state-wide races:

![map](../figures/shocks/margin_map.jpg)

| Candidate | Electoral Votes | Two-Party Popular Vote |
|-----------|-----------------|------------------------|
| Biden     | 305[^DC]        | 0.516                  |
| Trump     | 233             | 0.484                  |

The above map displays the closeness of the race in each state. For a better look at predicted state-by-state outcomes, [this map](../figures/shocks/winner_map.jpg) displays the predicted winner for each state without regard to closeness and [this table](../figures/shocks/state_pv_table.html) lists the predicted two-party popular vote shares for each state.

### Looking Ahead

With less than two weeks remaining until Election Day, my next post will contain a final election prediction. For this post, I used my model as part of the discussion about how the polling numbers and economic data fit into COVID-19. Throughout the next week, I will continue to modify this model and will update it with new polling numbers. My final prediction will go into further depth about my reasoning behind constructing the model, its strength and external validity, and uncertainty surrounding the prediction.

------------------------------------------------------------------

[^achen]: [Achen and Bartels, 2017] Achen, C. H. and Bartels, L. M. (2017). Democracy for realists: Why elections do not produce responsive government, volume 4. Princeton University

[^fowler]: [Fowler and Hall, 2018] Fowler, A. and Hall, A. B. (2018). Do Shark Attacks Influence Presidential Elections? Reassessing a Prominent Finding on Voter Competence. The Journal of Politics, 80(4):1423–1437.

[^healy]: [Healy et al., 2010] Healy, A., Malhotra, N., et al. (2010). Random events, economic losses, and retrospective voting: Implications for democratic competence.Quarterly Journal of Political Science, 5(2):193–208.

[^metrics]: It is important to note that the plot of death counts shows the total count of deaths in the United States, which will never decrease as time goes on. Plotting the number of deaths on the x-axis is essentially equivalent to showing time passing over the course of the pandemic. Even if COVID-19 was much worse in March than August, August would have a much higher death count than March by the nature of the data. In contrast, the increase in the number of positive tests may vary greatly each day with similar counts possible months apart. The strong negative correlation between the increase in positive test results and Trump's poll numbers shows that the polls are associated with the increase in positive results, which serve as a proxy for the severity of the pandemic, rather than serving as a simple function of time. 

[^categories]: I followed the [New York Time's classification](https://www.nytimes.com/interactive/2020/us/elections/election-states-biden-trump.html) of states when selecting which states to include in each model.

[^parsimony]: I removed correlated variables from the model and kept predictors that assessed the fundamentals, polls, previous outcomes, and demographics.

[^DC]: The model did not include DC, but I added it to the electoral count since it consistently votes blue in presidential elections.


