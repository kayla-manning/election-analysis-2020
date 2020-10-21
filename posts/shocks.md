# Shocks and Elections: COVID-19
## October 24, 2020

# **DRAFT**

### What the Literature Says about Shocks

The media loves a good "October Surprise," and 2020 has had its fair share of newsworthy events. COVID-19 consistently remains the defining issue of the 2020, despite other scandals ranging from [tax avoidance](https://www.nytimes.com/interactive/2020/09/27/us/donald-trump-taxes.html) by the president, [misleading the public](https://www.nytimes.com/2020/09/09/us/politics/woodward-trump-book-virus.html) on the state of COVID-19, and accusations of suspicious [emails](https://www.vox.com/2020/10/14/21515776/hunter-biden-emails-giuliani). How will the shock of COVID-19 translate into electoral outcomes?

It certainly sounds interesting to think that shark attacks[^achen] led to Woodrow Wilson's defeat in the 1916 election, but most sensational headlines come from flawed statistics.[^fowler] Voter behavior punishing incumbents for natural events seems irrational, however, that may not be the case if voters can attribute damage to the party in power. For example, voters punish incumbents for economic damage resulting from tornadoes[^healy] rather than death counts. In this case, the incumbent does have the power to issue a disaster declaration and attempt to minimize economic damage. With this considered, it appears that voters respond to how the incumbent *handles* such shocks rather than blaming the incumbent for the occurrence of the events.


### The Impact of COVID-19 on the 2020 Election

The [economic numbers](economy.md) of 2020 undoubtedly reflect the damage of COVID; incorporating economic data into predictions helps to account for some of the pandemic-related fallout. However, voters' emotional responses to events may exist independent of economic circumstances. In this situation, polls should capture how voters process non-economic responses to current events. Examining COVID-19 metrics, for example, shows that the COVID death count and increases in positive test counts have fairly strong, negative correlations with Donald Trump's approval ratings:[^metrics]

![covid](../figures/shocks/covid_polls.jpg)

Not surprisingly, public opinion about Donald Trump's handling of the COVID-19 crisis has a moderately strong, positive correlation with his overall polling numbers and the Biden's poll numbers have a negative correlation with Trump's COVID approval:

![covid_approval](../figures/shocks/covid_approval.jpg)

COVID metrics and COVID-specific approval follow the same trends as variables already included in my models, and incorporating correlated variables is redundant. Because of this, I will use polls and economic metrics as a proxy for the impact of COVID and other shocks on the electorate.

### Modeling with Economic Numbers and Polls, by State

A few minor tweaks to [last week's](turnout.md) imperfect model strengthened it significantly. As I mentioned in the previous post, fitting a separate model for each state left each model extremely susceptible to overfitting and poor out-of-sample performance. To fix this, I made the following changes:

* I fit separate models for 3 different categories of states: likely blue states, likely red states, and battleground states,[^categories] with the thinking that voters exhibit similar behavior in elections within their state's group. With this method, I used each state as an individual observation of an election, which drastically increased the observed outcomes from which I constructed the model.

* With parsimony in mind, I cut out several predictor variables from last week's model.[^parsimony] This new model predicts the voter turnout for each party using state polling numbers from 2 weeks out, the candidate's incumbency status, the interaction between incumbency and polls, national Q1 GDP growth, the previous election's Democratic vote margin in that state, and the change in that state's Black population.

I maintained the underlying binomial logistic structure as last week, and I varied the turnout as I did before. This method yielded much closer and more reasonable predictions for each state:

![map](../figures/shocks/margin_map.jpg)

| Candidate | Electoral Votes | Two-Party Popular Vote |
|-----------|-----------------|------------------------|
| Biden     | 350[^DC]        | 0.528                  |
| Trump     | 214             | 0.423                  |

The above map shows the win margin and displays the closeness of the race in each state. For a better look at predicted state-by-state outcomes, [this map](../figures/shocks/winner_map.jpg) displays the predicted winner for each state without regard to closeness and [this table](../figures/shocks/state_pv_table.html) lists the predicted two-party popular vote shares for each state.

### Looking Ahead

With less than two weeks remaining until Election Day, my next post will be my final election prediction. For this post, I used the model to make a preliminary prediction as part of the discussion about how the polling numbers and economic data fit into COVID-19. Over the course of the next week, I will continue to modify this model and will update with the new polling numbers. My final prediction will go into further depth about my reasoning behind constructing the model, its strength and external validity, and uncertainty surrounding the prediction.

------------------------------------------------------------------

[^achen]: [Achen and Bartels, 2017] Achen, C. H. and Bartels, L. M. (2017). Democracy for realists: Why elections do not produce responsive government, volume 4. Princeton University

[^fowler]: [Fowler and Hall, 2018] Fowler, A. and Hall, A. B. (2018). Do Shark Attacks Influence Presidential Elections? Reassessing a Prominent Finding on Voter Competence. The Journal of Politics, 80(4):1423–1437.

[^healy]: [Healy et al., 2010] Healy, A., Malhotra, N., et al. (2010). Random events, economic losses, and retrospective voting: Implications for democratic competence.Quarterly Journal of Political Science, 5(2):193–208.

[^metrics]: It is important to note that the deaths plot shows the absolute count of deaths in the United States, which increase day-by-day. Plotting the number of deaths on the x-axis essentially shows how the poll numbers have traveled over time. In this case, the death count in March looks quite different from the death count in August, even if COVID-19 is relatively more tame in the latter. In contrast, the increase in the number of positive tests is a more relative number that varies each day but you can observe similar counts months apart. The strong negative correlation between the increase in positive test results and Trump's poll numbers shows that the polls are associated with the increase in positive results, which serve as a proxy for the severity of the pandemic, rather than serving as a simple function of time. 

[^categories]: I followed the [New York Time's classification](https://www.nytimes.com/interactive/2020/us/elections/election-states-biden-trump.html) of states when selecting which states to include in each model.

[^parsimony]: I removed correlated variables from the model and kept predictors that clearly assessed the fundamentals, polls, previous outcomes, and demographics.

[^DC]: The model did not include DC, but I added it to the electoral count since it consistently votes blue in presidential elections.


