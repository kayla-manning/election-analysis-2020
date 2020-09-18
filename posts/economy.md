# Introduction: The Economy's Role in Elections
## September 19, 2020

#### Overview

Research suggests that voters tend to reward incumbents for short-term economic conditions, typically within 6 months to 1 year from election day.[^short-term] 

#### *Model 1* - Heterogenous Predictive Power of the Economy: Incumbency Status and Q2 GDP Growth

While the literature suggests that voters tend to reward the incumbent party for economic conditions, how does this effect vary among sitting presidents seeking re-election and same-party heirs seeking the office? The below plot appears to indicate that the relationship does differ:

![Figure 1](../figures/economy/inc_gdp_q2.jpg)

An [exploratory analysis](../figures/economy.ggpairs.jpeg) of the economic variables in the [data](../data/econ.csv)[^data] revealed that Q2 GDP growth has the highest correlation with two-party vote share for the incumbent party. After testing numerous variables with an interaction term 



Predicts Donald Trump will only win approximately 18.4% of the vote share.

#### Limitations

By mid-March, COVID-19 had reached all [50 states](https://www.cdc.gov/mmwr/volumes/69/wr/mm6915e4.htm). While Q2 economic numbers ordinarily serve as good predictors for presidential elections, real GDP decreased at an annual rate of [32.9%](https://www.bea.gov/news/2020/gross-domestic-product-2nd-quarter-2020-advance-estimate-and-annual-update) in the second quarter. The below visualization, which replicates a similar graphic from the [New York Times](https://www.nytimes.com/2020/07/30/business/economy/q2-gdp-coronavirus-economy.html), displays GDP growth in Q2 relative to the previous quarter, beginning in 1947:

![Figure 2](../figures/economy/q1gdp.jpg)

The unprecedented economic situation brought by COVID-19 makes economic data less reliable when predicting this 2020 election. On top of the unusual circumstances of 2020, forecasters must work with a limited sample size in less unusual election years as well. While the US has only held 58 presidential elections in its history, the GDP data dates back to 1947 and only accounts for 18 elections. Exploring individual subcategories, such as incumbency status in Model 1, only exacerbates this issue.

It is not reasonable to wish for a larger sample size to improve the models presented. However, adding non-economic variables to the model in future weeks will lead to a more realistic look at the outcome of the 2020 election. Even in years without such economic volatility, most election forecasters incorporated a mixture of political and economic indicators in their models.[^symposium] 




[^short-term] [Healy and Lenz, 2014] Healy, A. and Lenz, G. S. (2014). Substituting the End for the Whole: Why Voters Respond Primarily to the Election-Year Economy.American journal of political science, 58(1):31–47.

[^data] GDP growth (national): 1947-2020 (US  Bureau  of Economic Analysis, Department of Commerce)

[^symposium] [Ardoin and Gronke, 2016] Ardoin, P. and Gronke, P. (2016).PS: Political Science andPolitics: Symposium: Forecasting the 2016 American National Elections. 49(4).
