# Post-Election Model Reflection
## November 23, 2020

*You can find my final election forecast [here](https://kayla-manning.github.io/gov1347/posts/final.html)*.

### Recap

My final election prediction went against mainstream media and polling numbers, forecasting a rail-thin electoral margin for Joe Biden. While the election results surprised many people on the night of November 3, everything matched up relatively well with the forecast probabilities. In fact, my model's point prediction anticipated an even closer race in the electoral college--273 electoral votes for Biden compared to his actual **INSERT NUMBER HERE**--but a wider spread in the popular vote--52.8% compared to his actual **INSERT NUMBER HERE**.


### Accuracy and patterns (with graphics)

As I touched on in the uncertainty portion of my final prediction, this model was not intended to perfectly forecast the exact outcome. Rather, this forecast aimed to assign probabilities to certain outcomes and provide a range of possibilities. While I did give a point prediction of what I viewed as the most probable outcome, I knew that it was extremely unlikely to forecast the exact outcome.

All in all, I'm quite happy with how this model paralleled with the election outcomes. It only misclassified the winner of GA, NV, and AZ, which were three of the final states called. Even though the model predicted that Donald Trump victory was more likely in these states, the forecast predicted a close race in those states. In fact, Joe Biden won GA, NV, and AZ in 19.2%, 43.9%, and 20.5% of simulations, respectively. In my nationwide election simulations, the exact election outcome occurred in 57 out of 100,000 (0.057%) simulations. Taking a frequentist[^frequentist] approach to probability, those probabilities could have very well been correct and we just happened to observe an iteration of one of these 57 elections where each candidate won this exact cocktail of states.

With a correlation of `r corr` between the actual and the predicted two-party popular vote for each state, there is an incredibly strong correlation between the actual and predicted state-level two-party vote shares. With that said, there are a few patterns in the inaccuracies:

- On average, Joe Biden underperformed his predicted vote share by `r avg_error` percentage points relative to the forecast. As visible in the below scatterplot, Joe Biden's vote share underperformed relative to my model in the more Democratic states and overperformed in more traditionally Republican states.

- However, the model underestimated Joe Biden's performance in the only three states that were misclassified. 

Essentially, the model overestimated Joe Biden's vote share in general, but underestimated it in the states with incorrect point predictions.

The exact 2020 outcomes actually happened in `r times` of my simulations. To put that into perspective, my point prediction occurred in `r pred_times` of my simulations, which equates to `r round(pred_times / 100000, 3)`%. Forecasters cannot predict the election outcome with absolute certainty, but models provide a range of possible scenarios. This model successfully anticipated a close Electoral Race with a large popular vote margin, and the actual outcome occurred more than a handful of times in my simulations. It was not the most likely outcome, but neither is rolling any given number on a die.

### Hypotheses for inaccuracies

As with basically any other forecast model that incorporated polls, this forecast would have benefitted from improved polling accuracy. I cannot run the polls myself as a 20-year-old college student, so I have to look to other ways to improve my model. I attempted to correct for a potential polling error by applying an aggressive weighting scheme based on FiveThirtyEight's pollster grades. While that did do a good job of mitigating the impact of a liberal bias in the polls, the model predicted a more favorable outcome for Biden in the liberal states and predicted a more favorable outcome for Trump in conservative states. Looking at that trend in isolation makes it seems as if the polling weights did not have enough of an effect in liberal states but overcorrected in more conservative states. The diverging direction of the inaccuracies leads me to consider other potential causes for the inaccuracies and potential improvements for future iterations of this model.

This model neglected to pick up on the magnitude of changing views in states such as Arizona and Georgia, both of which voted for Trump in 2016 yet voted for Biden in 2020.[^good-shifts] An option to account for this in 2024, would be to include a variable that captures shifting partisanship within a state between elections. I could accomplish this through incorporating a "difference in Democratic vote share" variable, which takes the difference in the share of that state's two-party popular vote in the two previous elections For 2024, I would each state's Democratic vote share in 2016 from the Democratic vote share in 2020. Negative numbers would indicate Republican trends and positive numbers would indicate Democratic shifts, with larger absolute values indicating a shift of greater magnitude. 

### Proposed quantitative tests to assess hypotheses

To assess this hypothesis, I could reconstruct the model, following the same procedures as outlined in my [final prediction](posts/final.md). I would use the same data from 1992-2016 and include this variable that captures the state-level changes in voting patterns between elections. Once I have - constructed this new model, I could assess the fit in a number of ways:

- First and foremost, I would assess the statistical significance of the model coefficients for the partisan change.
- Then, I could assess the out-of-sample fit with a leave-one-out cross-validation and compare the classification accuracy with that of my previous model.
- If both of those steps support the strength of this new model, I could forecast the 2020 results using this year's data. To remain consistent between the two models, I would not use polls from after 3 PM EST on November 1, which is the last time I ran the previous forecast model.

Finally, I would compare this model's 2020 forecast to my previous model. If this model more accurately predicted the state-level outcomes, then I know that my 2024 should resemble this newer model. However, if my previous model performed better in the leave-one-out classification and on the 2020 data, then I would stick with my original, more parsimonious model for the future.


### How I would change the model in another iteration

Aside from the lack of a variable to capture shifting partisan alignment within states, there are several other modifications I would make to the methodology behind this model in a future iteration. I touched on many of these in greater detail in my [final prediction](posts/final.md) post, but here is a brief overview:

- This model does not include Washington D.C. in the forecast, and I manually added its 3 electoral votes after forecasting the vote shares for the 50 states. Ideally, I would find the necessary data to include D.C. in my forecast.
- Also due to a lack of data, this model treats Maine and Nebraska as winner-take-all, while they actually follow allocate electoral votes with the congressional district method. Again, future iterations would ideally include district-level data for these states.
- This model varied voter turnout and partisan probabilities independently by simply drawing from a normal distribution. A more sophisticated model in the future would introduce some correlation between geographies, demographic groups, and ideologies. Moreover, since I drew these probabilities from a normal distribution, some states could have negative probabilities if the initial probability for voting for a particular party was extremely low (e.g. voting Republican in Hawaii). I mitigated this by taking the absolute value of the probability, but this introduced some extreme variation in the model and I would absolutely need to find a better method to handle this in future iterations of this model.
- Lastly, I classified states into categories based on their 2020 ideologies. Ideally, I would re-classify each state in every election year when constructing the model. For example, this model considered Colorado as a "blue state" for all years based on its 2020 classification, but it was either a "red state" or "battleground state" in most of the previous elections in the data. In the future, I would like to set a rule for classifying each state for every election, rather than relying solely on the 2020 classification by the [New York Times](https://www.nytimes.com/interactive/2020/us/elections/electoral-college-battleground-states.html).

### Conclusion

While the election did not perfectly align with my predicted outcomes, I believe this model did an excellent job of forecasting a relatively close race in the Electoral College with a larger margin in the popular vote. Even in the states with the incorrect classification for the winner, the actual vote share predictions were not far from the actual vote shares. Despite doing a phenomenal job with this election, plan on making several improvements in future iterations of this model (assuming this country survives to see another 4 years).

---------------------------------------------------------------------

[^frequentist]: Unlike rolling a dice, we cannot experience multiple occurrences of the same election to uncover the true probability of each event. Frequentist probability describes the relative frequency of an event in many trials; conducting many simulations in my model took a frequentist approach to uncover the probability of each outcome. However, we can never really know if any of the probabilities were correct because the 2020 election only happened once (thank goodness!). Trying to say whether or not a probabilistic forecast was *correct* is like rolling a "six" on a single die and concluding that your prior probabilities of 1/6 for rolling a 6 and 5/6 for rolling anything else were incorrect because you observed the less probable outcome on a single iteration.

[^good-shifts]: However, any changes would have to keep in mind that FL, OH, WI, etc. were more conservative than most forecasts anticipated, and this model correctly anticipated the winner in these highly contentious battleground states. 

