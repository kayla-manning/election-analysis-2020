# Voter Turnout
## October 17, 2020

### Importance of Ground Game in Voter Turnout

### Turnout in 2020

Democracy cannot function as intended if voters neglect to show up at the polls. Over the years, both the size of the voting-eligible population and the percentage that cast ballots have generally[^Obama-turnout] increased::

![Figure 1](../figures/turnout/turnout_years.jpg)

Where will voter turnout in 2020 fall onto this graph? Prior to the birth of COVID-19, experts in 2019 predicted a [historic](https://www.usnews.com/news/elections/articles/2019-09-20/experts-predict-huge-turnout-in-2020) turnout of approximately 66%[^vep] for the 2020 election. However, it would be naive to assume that the same assumptions made for these forecasts over a year ago still hold in the present circumstances. Voter turnout could easily increase or decrease due to the pandemic, depending on whether voters are (a) hindered in their voting plans due to confusion over voting by mail[^vote-by-mail] and safety of in-person voting, or (b) energized to vote for the candidate that they believe can provide leadership to power our country through these turbulent times.

With zero previous elections with circumstances resembling 2020, this year's primaries are the best source of information about how voters will behave amid a global pandemic. Turnout in primaries generally pales in comparison to general election turnout, with numbers sitting around 3%-46% and 60% respectively, and this disparity is generally amplified in years with an incumbent candidate. However, the 2020 primary drew far more[ attention](https://www.nytimes.com/2020/07/21/us/politics/biden-2020.html) than expected. While most of the showing came from the Democratic side since that was the only competitive primary (and even that was short-lived), this larger-than-expected turnout could be a positive sign that COVID-19 will not drastically decrease, and may even increase, turnout come November.

Indeed, it turns out that experts still expect a [record-high turnout](https://www.theatlantic.com/politics/archive/2020/10/2020-election-turnout/616640/) in the 2020 election, with the predicted surge strengthened by the pandemic. Similar to the prediction in 2019, estimates still sit at approximately [65%](https://thehill.com/homenews/campaign/520313-experts-predict-record-election-turnout-as-more-than-66-million-ballots).

#### How [FiveThirtyEight's Forecast](https://fivethirtyeight.com/features/how-fivethirtyeights-2020-presidential-forecast-works-and-whats-different-because-of-covid-19/) Deals with Unpredictability

While COVID-19 may not definitively lower voter turnout, forecasters must still grapple with increased levels of uncertainty in turnout numbers. Nate Silver's forecast at FiveThirtyEight accounts for unpredictable voter turnout and uncertainty in Election Day results with the following factors:

* *Relative ease of voting in each state* - generally, easier voting leads to higher turnout and an increased proportion of Democratic votes.
* *Projected turnout by state* - uses population growth since 2016, changes in the relative ease of voting since 2016, and current closeness of the race, since closer-polling states tend to experience higher turnout.
* *Variability in primary turnout* - turnout in primaries was approximately 50% higher in primaries after COVID-19 came to the US than before.
    * COVID-19 made turnout in primaries more difficult to predict; voting by mail made voting easier in certain states, while difficulties with social distancing at in-person polls added a barrier for other voters.
    * States with drastic shifts in turnout between election cycles are more difficult to forecast.

With the above factors in mind, Nate Silver estimates a *50% increase in error when predicting voter turnout* and a *20% increase in error when predicting vote share* for each party. As a result of how COVID-19 may affect turnout and the voting process, FiveThirtyEight's model increased Election Day error, correlated state error, and state-specific error by 20% relative to typical values.


#### How [The Economist's Forecast](https://projects.economist.com/us-2020-forecast/president/how-this-works) Adjusts for Turnout

The Economist's discussions of turnout variability focus on polling bias rather than COVID-19. Polls conducted on all adults will inevitably include the views of people that will not vote in the general election, which introduces biases regarding voter turnout. Pollsters attempt to mend this by strategically applying weights to the responses of individuals likely to vote, but this introduces another layer of bias unique to that pollster's method. 

Over time, different pollsters will conduct surveys in the same areas, and The Economist's model compares the results of these different polls on similar populations and adjusts for the differences. 

#### Comparing FiveThirtyEight and The Economist

While polling biases certainly pose problems, FiveThirtyEight's detailed handling of COVID-specific issues seems a bit more appropriate for the current circumstances. However, this is the Economist's first statistical election prediction model, so they very well could be considering the same measures but neglected to include a lengthy description of it since they did not have any other models setting a precedent.

### Modeling Election Outcomes with Variability in Turnout

#### State-by-State Model

To simulate calculate counts for the Electoral College, I constructed a binomial logit model for each state, estimating the vote counts for each party in each state using polling support,[^polls] Q1 GDP growth, change in the Black population in the past year, change in the Hispanic population in the past year, change in the population in their 20s in the past year, the number of consecutive years that the state has voted either Democrat or Republican, and the percent margin of the Democratic vote in the previous election.

For each state, I simulated variations in turnout by drawing a random number from a normal distribution centered at the 2016 voting-eligible population (VEP) for that state with a standard deviation of 1.25 times the standard deviation in that state's VEP from 1980-2016. I multiplied the standard deviation since it is reasonable to expect more variation in turnout this year relative to previous years due to COVID-19. I simulated 1000 different elections for each state, with a different VEP number for each.

Using this method, my forecast yielded a prediction of 321 electoral votes for Biden and 214 for Trump, with Biden winning approximately 50.7% of the popular vote. This model does exclude Washington D.C., which has 3 electoral votes. Since DC reliably votes Democratic, I can comfortably build upon this model's prediction to predict that Biden will receive 324 electoral votes and Trump will receive 214.

![pred-table](../figures/turnout/pred_table.png)

![state-winners](../figures/turnout/state_winners.jpg)

This map appears to be fairly reasonable given what we know about states' tendencies to swing one way or another. However, this model could use some improvement, as several core states, such as Alaska and the Dakotas, appear to swing in the opposite direction. In future weeks, I hope to construct separate models for reliably blue states, reliably red states, and swing states. Then, I will apply those three models to the relevant states. These models will be fit with data from groups of similar states without running the risk of overfitting a single state.

#### National Model

On top of my state-by-state model, I also constructed a binomial logit model for the nationwide popular vote following a similar procedure as above. For the nationwide model, I predicted vote counts for each party using polling numbers, incumbency status, the interaction between polling and incumbency, and Q1 GDP growth. I simulated fluctuations in turnout by drawing a random number from a normal distribution of possibilities for the national VEP, and I ran 100,000 simulations.

A national model predicts that Biden will receive approximately **50.8%** of the two-party popular vote and Trump will receive the remaining **49.2%**.	Each of the individual simulations predict that Biden will win the national popular vote by 1-2% points depending on the turnout, as displayed by the below histogram:

![nation-sim](../figures/turnout/nation_sim.jpg)


### Looking Ahead

In forecasting the 2020 election, experts must grapple with uncertainty regarding COVID-19's impact on turnout. In addition to the question of turnout, however, retrospective voting raises the question of how voters may punish or reward the incumbent candidate for the handling not only of COVID-19, but also of wildfires, hurricanes, racial injustice protests, and more. Next week's post will examine the historical impact of shocks and unexpected events on presidential elections.


[^Obama-turnout]: While the aggregate trend is increasing numbers, the numbers reach their peak in 2008. Also, the numbers tend to oscillate up and down depending on whether there is an incumbent candidate, with relatively higher turnout rates in years when a sitting president is not seeking re-election.

[^vep]: Turnout percentages reported throughout this post refer to the percentage of the voting-eligible population (VEP) that casts ballots.

[^vote-by-mail]: Different states have different [regulations](https://www.nytimes.com/interactive/2020/08/11/us/politics/vote-by-mail-us-states.html) regarding voting by mail. In the presidential primaries, states that encouraged people to vote by mail experienced impressive [success](https://fivethirtyeight.com/features/there-have-been-38-statewide-elections-during-the-pandemic-heres-how-they-went/). Naturally, states that mailed every voter an absentee ballot saw the greatest share of votes cast absentee, and states that did not mail anything and required a non-COVID excuse to vote absentee had the lowest share of absentee voting.
Many Republicans [believe](https://www.nytimes.com/2020/05/25/us/vote-by-mail-coronavirus.html) that widespread absentee voting will benefit Democrats, so people may attempt to manipulate voting by mail measures to stifle the vote of certain subsets of the electorate. Fortunately, most states requiring non-COVID-19 excuses for absentee voting reliably vote Republican, most states mailing ballots to all voters reliably vote Democratic, and most swing states allow absentee voting for all but do not nudge in one way or another. While the concerns about attempts to manipulate voter turnout are certainly valid, it appears that policies enacted by states will only serve to reinforce existing voting tendencies.

[^polls]: All polling numbers used in this week come from FiveThirtyEight's updating poll average from 3 weeks out from the election.

