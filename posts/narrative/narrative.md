## Summarize Narrative, why it's important to test in the context of various election-related variables we discussed this semester

As I previous justified in my [blog post](https://kayla-manning.github.io/gov1347/posts/shocks.html) for electoral shocks and COVID-19, polling numbers and economic metrics served as proxies for the impact of COVID-19 in my model. Given the importance of economic fundamentals in determining election winners, a Trump 2020 victory does not seem out of reach in the absence of the pandemic and resulting economic crash. The terrific economy, paired with Trump's incumbent advantage could have reasonably carried him to another 4 years in the White House. While reasonable, how likely was this scenario? In an alternate universe without the economic downturn and with zero retribution for COVID-19, how would Trump have fared in the 2020 election?

Obviously, this narrative warrants some exploration since a Trump victory would very likely alter the course of the next four years. While a Trump win in the nationwide popular vote would have been surprising, given his fairly large loss in 2016, the Electoral College is what truly matters. Donald Trump won Arizona, Georgia, and Wisconsin in 2016 but failed to secure victories in these states in 2020. These states not only share their red-to-blue flip in common, but they were also hit fairly hard by the pandemic. Had Trump won these states and all else remained the same, the Electoral College would have tied and the race would have gone to the House. Several paths existed for a Trump electoral victory. Is COVID-19 to blame for Trump's loss, or would Biden still have defeated the incumbent president in a COVID-free world?

## Describe and justify a testable implication of this narrative

The 1918 Spanish influenza pandemic provides the only comparable situation to that which we face in 2020. Previous research on the 1918 midterms and 1920 general election suggests that the pandemic had negligible in any electoral impact.[^achen-bartels-flu] However, times were extremely different a century ago. Relative to the magnitude of the pandemic, the Spanish flu received little public attention, which contrasts greatly with how COVID-19 has dominated nearly every facet of life in 2020. So, while it may not make sense to automatically extend the conclusions from the 1918 pandemic to that of 2020, we can use similar methodology to take a preliminary look at COVID's electoral impact. 

In *Democracy For Realists*, Achen and Bartels examined whether the states and cities hit hardest by the pandemic responded differently at the polls.[^achen-bartels-flu] While they focused on gubernatorial races during the 1918 midterms, I plan on applying the underlying structure of their analysis to the 2020 presidential race. Similar to Achen and Bartels, I plan on running a simple regression that maps Donald Trump's 2020 vote share from his 2016 vote share and COVID cases and/or deaths.

## Describe the data collected

- COVID deaths
- pre-COVID polls?

## Regression Results



## New Model Results

Taking an interest in the results of the regression, I decided to take a more nuanced look at the implications of these findings. The regressions take very crude measures of COVID numbers and previous vote share, without considering possible confounding variables. My previous election model used a mixture of demographic variables, economic metrics, incumbency status, and polling numbers to produce a probabilistic forecast for the 2020 election. While the forecast did not match the election results exactly, it did match the outcomes fairly closely, so it would not hurt to examine what happens without any measured impact of COVID-19.

COVID-19 bled into the polling and economic data used for the predictions, so I took steps to try to erase or minimize any impact of COVID-19 on these metrics:

* I treated the election as if Trump was running for re-election off of his 2019 economy by using 2019's Q1 GDP in the prediction. 
* For polling, crafted my predictions with all state-level polls from more than 15 weeks[^poll-weeks] out from the election, as opposed to focusing on the 4 weeks prior to the election.

I used a very similar[^model-changes] model equation to that from my [final forecast](https://kayla-manning.github.io/gov1347/posts/final.html). In this hypothetical, pandemic-free world, Trump lost both the Electoral College and the national two-party popular vote by an even larger margin than what panned out on the actual election day:

*insert table of results here and map*


## Describe results of test and whether it supports the narrative... include graphics

While these tests were imperfect measures, they certainly do indicate that coronavirus is unlikely the reason that Trump lost. In fact, COVID-19 may have helped Trump. While I cannot conclude that COVID-19 caused Trump to perform better in the 2020 election, these preliminary measures do indicate that there is a positive association between COVID numbers and Donald Trump's vote share.

-----------------------

[^achen-bartels-flu]: [Achen and Bartels, 2017] Achen, C. H. and Bartels, L. M. (2017). Democracy for realists: Why elections do not produce responsive government

[^poll-weeks]: While this includes some data from after COVID-19 came to the United States, I had to expand the window of time in order to get a large enough sample size for the model to run for each state.

[^model-changes]: I added an interaction term to the model from my original forecast for this iteration. In retrospect, it did not make sense to not include it in the first place since the state of the economy likely has opposite effects for incumbent and non-incumbent candidates.

