# Final Prediction
## November 1, 2020

### Model Formula

$$\hat{y} ~ avg_state_poll * incumbent + gdp_growth_qt + prev_dem_margin + black_change$$

### Model Description and Justification

#### Variables

##### State-Level Polls

A single nationwide race does not determine the winner of the presidential election, but rather, 50 state-level races combine to decide the winner. For that reason, this model makes use of state-level polling rather than nationwide polling. Donald Trump appears to fare better in state-level polls compared to nationwide polls, which makes this model predict a closer race than if it included national polls.

**INCLUDE POLLS FROM LAST SEVERAL WEEKS TO ACCOUNT FOR HIGHER EARLY VOTING NUMBERS AND HERDING? ALSO GIVES MORE SAMPLES FOR STATES THAT MAY BE LACKING IN POLLS IN A GIVEN WEEK (NATE SILVER DISCUSSES LOWER-THAN-IDEAL NUMBER OF POLLS FOR NE, NV, ETC.)**

##### Incumbency

Incumbent candidates benefit from structural advantages, including but not limited to increased media coverage, widespread name recognition, an early start to campaigning, and more. This model incorporates incumbency status to help capture the effect of incumbency status on vote share. On top the incumbency alone, how do the polls behave for incumbent candidates compared to non-incumbent candidates? An interaction term with state-level polling accounts for the possibility of varied poll behavior between incumbent candidates and than non-incumbent candidates.

##### Q1 GDP

Data suggests that voters focus on the election-year economy at the polls as opposed to economic performance over the entire term of the incumbent.[^healy-2014] Assuming that a similar trend will hold for 2020, Donald Trump will likely face some punishment at the polls for the economy's historic lows over the course of the COVID-19 pandemic. However, focusing solely on the [Q2 economic numbers](../figures/economy/q2gdp.jp) completely disregards the [economic prosperity](https://www.bbc.com/news/world-45827430) prior to the pandemic. To balance between the highs and the lows, this model incorporates 2020 Q1 GDP growth. This metric is slightly negative due to the onset of the pandemic in the US in the final weeks of the quarter, but it is nowhere near as low as the Q2 metric. This metric more accurately reflects how I anticipate voters to assess the economy at the polls: not great, but not hopeless beyond return.

##### Previous Democratic Vote Margin

Past elections serve as one of the best predictors for current elections, especially at the state-level. Incorporating each state's previous Democratic vote margin considers recent voting behavior.

##### Change in the Black Population

Demographics serve as strong predictors for voting behaviors, so incorporating the change in each state's Black population accounts for changing demographics in the voting population. [Black voters](https://www.pewresearch.org/fact-tank/2020/10/21/key-facts-about-black-eligible-voters-in-2020-battleground-states/) in particular lean Democratic, so this variable captures potential shifts in the partisan leaning within each state.

#### Data

* 2020 state-level polls: FiveThirtyEight
* National GDP growth: US Bureau of Economic Analysis, Department of Commerce

#### Sample Size

**combined data only goes back to 1992, but each state counts as an individual observation, so the blue model has 105 observations, the battleground model has 112 observations, and the red model has 133 observations**

### Coefficients

#### Interpretation of Coefficients

### Model Validation

#### In-Sample

#### Out-of-Sample

### Prediction and Graphics

NOTE THAT THIS MODEL ASSUMES DC WILL GO TO BIDEN AND IT CONSIDERS MAINE AND NEBRASKA AS WINNER-TAKE-ALL


#### Uncertainty Around Prediction

#### Prediction Discussion

REASONABLE TO EXPECT VOTERS TO "COME HOME" AS ELECTION NEARS, SO HIGHER-THAN-EXPECTED TRUMP NUMBERS SEEM VALID


------------------------------------------------------------------


[^healy-2014]: [Healy and Lenz, 2014] Healy, A. and Lenz, G. S. (2014). Substituting the End for the Whole: Why Voters Respond Primarily to the Election-Year Economy. American journal of political science, 58(1):31–47.



