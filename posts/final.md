# Final Prediction
## November 1, 2020

### Overview

This model predicts a narrow Joe Biden victory with far less certainty than other predictions. While this forecast predicts that Joe Biden will win the popular vote by a fairly sizable margin of **INSERT PERCENT HERE**, the forecast predicts that Biden will squeak by with an Electoral College majority of **INSERT ELECTORAL COUNT HERE**. In a total of $100,000$ simulations, Joe Biden won the Electoral College **INSERT PERCENT HERE** of the time, Donald Trump won the Electoral College **INSERT PERCENT HERE** of the time, and neither candidate received 270 votes **INSERT PERCENT HERE** of the time.

#### Model Description and Methodology

This forecast uses a binomial logistic model to predict the probability that each member of the state's voting-eligible population will vote for either party using a combination of polling, economic, demographic, and incumbency data:[^data]

$$\hat{y} ~ avg_state_poll + incumbent + q1_gdp_growth + prev_dem_margin + black_change + age20_change + age65_change$$

To gauge public opinion, the model includes average state-level polls[^survey-monkey] in the final 4 weeks before the election. Election-year Q1 GDP growth captures the state of the economy, and the incumbency term accounts for the [incumbency](../posts/incumbency.md) advantage. Since past elections serve as excellent predictors for future elections, the forecast includes a term for the state's previous difference between Democratic and Republican two-party vote share. Lastly, demographic variables for the change in the state's Black population, age 20-30 population, and age 65+ population captures the impact of shifting demographics on election outcomes. See the Appendix for a more in-depth discussion about the inclusion of each of these variables and a visualization of each model's [coefficients](../figures/final/coeff_table.html).

In order to create individualized models without overfitting the data for each state, I grouped states into three separate categories: blue states, red states, and battleground states, as classified by the [New York Times](https://www.nytimes.com/interactive/2020/us/elections/election-states-biden-trump.html). Within each group of states, I constructed one model to predict the probability of voting Democrat and one model to predict the probability of voting Republican, yielding a total of 6 models.

With the predicted probabilities from the model, I applied each state's partisan probabilities to its total voting-eligible population, slightly varying the probabilities and the voter turnout each time.[^variation]


#### Out-of-Sample Validation

To test the validity of this model, I performed leave-one-out cross-validation by fitting a model for each state in each year, excluding that value. Then, I compared the model's predicted popular vote winner to the actual popular vote winner. This model correctly classified the winner of the statewide popular vote in 91.85%[^oos-classification] of states in elections from 1992-2016, with the following year-by-year breakdown:

| Year | Correct Classification |
|-----:|-----------------------:|
| 1992 |              0.7391304 |
| 1996 |              0.9791667 |
| 2000 |              0.9347826 |
| 2004 |              0.9767442 |
| 2008 |              0.9782609 |
| 2012 |              0.9500000 |
| 2016 |              0.8800000 |

Not surprisingly, the model performed the worse in swing states. Across all elections from 1992-2016, the model correctly classified the popular vote winner less than 80% of the time in these 4 states:

| State | Correct Classification |
|-------|-----------------------:|
| FL    |              0.5714286 |
| WI    |              0.5714286 |
| MI    |              0.7142857 |
| PA    |              0.7142857 |

In the leave-one-out validation for 2016, the model misclassified 6 states: FL, OH, NC, MI, PA, and WI. [FiveThirtyEight](https://projects.fivethirtyeight.com/2016-election-forecast/)'s 2016 forecast correctly predicted OH, but misclassified the remaining five of those six states. While this higher rate of misclassification for 2016 is moderately concerning since Donald Trump is running again, the 2020 model was fit with data for 2016.


### 2020 Prediction

When applied to the 2020 data, this model predicts a narrow Biden victory in the [Electoral College](../figures/final/winner_map.jpg), with a much larger margin in the popular vote:

| Candidate    | Electoral Votes | Two-Party Popular Vote |
|--------------|----------------:|------------------------|
| Joe Biden    |             273 | 0.5238088              |
| Donald Trump |             265 | 0.4761912              |



![margin-map](../figures/final/prediction_maps.jpg)


### Uncertainty Around Prediction

As visible in the map of Joe Biden's predicted win margin, many states will likely have close elections, and the election could easily swing further in Biden's favor if some of Trump's close states flip to blue. However, a victory for Trump is not out of reach due to the extremely close electoral count in this model. How can we quantify the uncertainty with this forecast? 

The probabilities in this section are **not** estimated vote shares; rather, these probabilities represent each candidate's chance of winning the Electoral College, nationwide popular vote, or statewide popular vote in the [battleground states](https://www.nytimes.com/interactive/2020/us/elections/election-states-biden-trump.html).

In 100,000 simulations of the election, Joe Biden won the Electoral College most frequently, but Donald Trump still won over 1 out of 3 elections:

| Biden Victory | Trump Victory | Tossup[^tossup]|
|---------------|---------------|----------|
| 0.59036       | 0.38873       | 0.02091  |

However, Donald Trump has a much smaller chance of winning the national popular vote:

![national-uncertainty](../figures/final/national_vote_dist.jpg)

Luckily for Trump, the nationwide popular vote does not matter if he can secure enough statewide popular vote victories to reach 270 Electoral College votes. While the forecast predicts a narrow Joe Biden victory, either candidate could reasonably win most of the battleground states:

![battleground-uncertainty](../figures/final/bg_vote_dist.jpg)

| State | Probability of Biden Victory | Probability of Trump Victory |
|-------|-------------------------------:|-------------------------------:|
| MI    |                      0.5413900 |                     0.45861000 |
| WI    |                      0.5451600 |                     0.45484000 |
| MN    |                      0.5451800 |                     0.45482000 |
| NV    |                      0.4189772 |                     0.58102276 |
| PA    |                      0.6068800 |                     0.39312000 |
| FL    |                      0.2843436 |                     0.71565636 |
| NC    |                      0.2615635 |                     0.73843646 |
| IA    |                      0.2278800 |                     0.77212000 |
| TX    |                      0.2118627 |                     0.78813729 |
| ME    |                      0.6374500 |                     0.36255000 |
| AZ    |                      0.1783197 |                     0.82168029 |
| GA    |                      0.1754539 |                     0.82454614 |
| OH    |                      0.0752100 |                     0.92479000 |
| NE    |                      0.0462500 |                     0.95375000 |
| NH    |                      0.8432500 |                     0.15675000 |
| NM    |                      0.9064325 |                     0.09356749 |


The three closest races in battleground states according to this model--MI, WI, and MN--all lean slightly in Joe Biden's favor according to this model. These states could easily swing in Donald Trump's favor, giving him the Electoral College victory while still losing the popular vote.


#### Model Limitations

While this forecast performed quite well in the leave-one-out cross-validation and makes reasonable predictions given what we know about states, it also has several limitations: 

* This model does not account for Washington D.C. However, D.C. has a history of voting heavily Democratic, making it [extremely likely](https://projects.fivethirtyeight.com/2020-election-forecast/district-of-columbia/) to vote Democrat in this election. For this reason, Washington D.C.'s 3 electoral votes were added to Joe Biden's tally after running the model for the 50 states.

* Due to the structure of the available data, this model treats Maine and Nebraska as winner-take-all states. However, these two states follow the [congressional district method](https://www.270towin.com/content/split-electoral-votes-maine-and-nebraska/) and could actually split their votes.

* The combined data for this model only dates back to 1992, so this model is built off of only 7 previous elections. However, each state in each election counts as an individual observation, which substantially increases the sample size relative to a nationwide model. The blue, battleground, and red models are built from 105, 112, and 133 observations in the data, respectively.

#### Conclusion

While this model predicts a narrow Democratic victory in both the Electoral College and popular vote, at **INSERT VOTES HERE** and **INSERT PERCENT HERE** respectively, the close margins, especially in battleground states, give reason for uncertainty. This forecast gives Joe Biden an approximate **INSERT WIN PERCENTAGE HERE** chance of victory, Donald Trump a **INSERT WIN PERCENTAGE HERE** chance of victory, and a **INSERT WIN PERCENTAGE HERE** chance that the House of Representatives will have to decide the election.

Due to the close margins in several battleground states, the election could swing either way. For example, if Joe Biden wins Michigan, Nevada, Texas, or any other state with a narrow victory projected for Trump, Biden could win the electoral vote by far more than the predicted **INSERT EV COUNT HERE** votes. However, if Trump wins New Hampshire, Nebraska, Pennsylvania, Wisconsin, or any other states projecting an extremely narrow Biden victory, he could easily tip the electoral scale in his favor.

All in all, the 2020 election is shaping to up to be an exciting election, which is fitting for a year with all too much excitement already.

------------------------------------------------------------------

### Appendix

#### Discussion of Variables

##### State-Level Polls

A single nationwide race does not determine the winner of the presidential election, but rather, 50 state-level races combine to decide the winner. For that reason, this model makes use of state-level polling[^survey-monkey] rather than nationwide polling. Donald Trump appears to fare better in state-level polls compared to nationwide polls, which makes this model predict a closer race than if it included national polls.

To account for the increased turnout in early voting, I included polling numbers from the last four weeks leading up to the election. This method yielded the best out-of-sample fit when compared to polling intervals ranging from last five weeks to only the last week:
1. As election day nears, two contradictory phenomena occur: polls (a) converge to the election outcome, and (b) increase in bias due to herding toward the anticipated outcome. Including the last two weeks of poll numbers allows for the accuracy due to convergence while expanding the sample in a way that does not amplify herding effects.
2. Some states do not attract much attention from pollsters, so using polls from multiple weeks increases the number of observations and reduces the likelihood of skewed polling averages due to limited sample sizes.


##### Incumbency

Incumbent candidates benefit from structural advantages, including but not limited to increased media coverage, widespread name recognition, an early start to campaigning, and more. This model incorporates incumbency status to help capture the effect of incumbency status on vote share. 

##### Q1 GDP

Data suggests that voters focus on the election-year economy at the polls as opposed to economic performance over the entire term of the incumbent.[^healy-2014] Assuming that a similar trend will hold for 2020, Donald Trump will likely face some punishment at the polls for the economy's historic lows over the course of the COVID-19 pandemic. However, focusing solely on the [Q2 economic numbers](../figures/economy/q2gdp.jp) completely disregards the [economic prosperity](https://www.bbc.com/news/world-45827430) prior to the pandemic. To balance between the highs and the lows, this model incorporates 2020 Q1 GDP growth. This metric is slightly negative due to the onset of the pandemic in the US in the final weeks of the quarter, but it is nowhere near as low as the Q2 metric. This metric more accurately reflects how I anticipate voters to assess the economy at the polls: not great, but not hopeless beyond return.

##### Previous Democratic Vote Margin

As mentioned in the main content of the post, past elections serve as one of the best predictors for current elections, especially at the state-level. Incorporating each state's previous Democratic vote margin considers recent voting behavior.

##### State-Level Demographics: Change in Black Population, Change in Age 20-30 Population, and Change in 65 and Over Population

Demographics serve as strong predictors for voting behaviors, so incorporating the change in each state's Black population accounts for changing demographics in the voting population. [Black voters](https://www.pewresearch.org/fact-tank/2020/10/21/key-facts-about-black-eligible-voters-in-2020-battleground-states/) in particular lean Democratic, so this variable captures potential shifts in the partisan leaning within each state. Also, [age](https://www.aei.org/articles/2020-will-be-a-realigning-election-led-by-young-voters/) serves as a fair predictor of voting behavior: younger voters tend to vote Democratic and older voters exhibit a greater tendency to vote Republican. While conducting leave-one-out validation for models, this combination of demographic factors yielded the highest rate of classification success.

#### Coefficients

This [table](../figures/final/coeff_table.html) displays the coefficients for each model, the below figure plots the coefficients for each model. Every coefficient was highly significant with near-zero p-values and incredibly narrow 95% confidence intervals:

![coefficients](../figures/final/model_coefficients.jpg)


#### "Coming Home"

As Election Day approaches, the predicted vote shares for each candidate from each state diverged as voters appear to "come home" to their partisan loyalties. Two weeks prior to the election, this model predicted that Trump would only win Texas by less than 0.01% of the popular vote, for example. However, it now forecasts a fairly decisive Trump victory for the blue-trending but historically red state.


------------------------------------------------------------------

[^data]: All data for this model is publicly available online. While many online sources host the data used in this model, the data for the 2020 state-level polls came from [FiveThirtyEight](https://projects.fivethirtyeight.com/polls-page/president_polls.csv), and the national GDP growth numbers came from the [US Bureau of Economic Analysis](https://www.bea.gov/data/gdp/gross-domestic-product).

[^variation]: In order to vary the voting-eligible population (VEP) and the probability of voting for each party, I drew the values from a normal distribution. For the VEP, I used a normal distribution centered at each state's VEP in 2016 and used a standard deviation of twice the standard deviation of the VEP in all years from 1980-2016, anticipating greater variation in turnout due to COVID-19. 
  To simulate fluctuations in the probability of voting for each party, I took the absolute value of a draw from a normal distribution centered at the predicted probability for 2020 with a standard deviation equivalent to that party's standard deviation of two-party popular vote within the respective state from 1992-2016.

[^oos-classification]: Not all states had enough state-level polling data to conduct the out-of-sample validation for each year; this percentage excludes NA values.

[^tossup]: This counts the proportion of times that neither candidate received at least 270 electoral votes. In the case of a [tie](https://www.270towin.com/content/electoral-college-ties/), the House of Representatives would decide the winner of the presidential election.

[^survey-monkey]: I omitted SurveyMonkey polls from my data after G. Elliot Morris spoke in class about how he does not include their polls due to bias. Also, FiveThirtyEight rates SurveyMonkey a D-, which is the lowest grade of any pollster. This data is especially problematic because SurveyMonkey byfar issues the most polls, by nearly ten times as much as the second most prolific pollster. For states that did not have enough state-level polls after omitting SurveyMonkey data, I included polls from the site.

[^healy-2014]: [Healy and Lenz, 2014] Healy, A. and Lenz, G. S. (2014). Substituting the End for the Whole: Why Voters Respond Primarily to the Election-Year Economy. American journal of political science, 58(1):31–47.



