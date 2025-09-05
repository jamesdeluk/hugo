---
title: "Visualising Random Forests"
date: 2026-09-01
tags: ['Data Science', 'Regression', 'Decision Trees', 'Random Forests', 'Hyperparameters', 'Python']
hero: /images/posts/data-and-analytics/visualising-random-forests/vrf2.png
---

## Introduction

In my [previous post](https://www.jamesgibbins.com/visualising-decision-trees/) I looked at the impact of different hyperparameters on decision trees, both their performance and how they appear visually.

The natural next step, then, is random forests, using `sklearn.ensemble.RandomForestRegressor`.

Again, I won’t go into how the random forests work, areas such as bootstrapping and feature selection and majority voting. Fundamentally, a random forest is a huge number of trees working together (hence a forest), and that’s all we care about.

I’ll use the same data (California housing dataset via scikit-learn, CC-BY) and the same general process, so if you haven’t seen my previous post, I’d suggest reading that first, as it goes over some of the functions and metrics I’m using here.

Code for this is in the same repo as before: [https://github.com/jamesdeluk/data-projects/tree/main/visualising-trees](https://github.com/jamesdeluk/data-projects/tree/main/visualising-trees) As before, all images below are created by me.

## A basic forest

First, let’s see how a basic random forest performs, i.e. `rf = RandomForestRegressor(random_state=42)`. The default model has an unlimited max depth, and 100 trees. Using the average-of-ten method, it took ~6 seconds to fit and ~0.1 seconds to predict - given it’s a forest and not a single tree, it’s not surprising it took 50 to 150 times longer than the deep decision tree. And the scores?

| Metric | max_depth=None |
| --- | --- |
| **MAE** | 0.33 |
| **MAPE** | 0.19 |
| **MSE** | 0.26 |
| **RMSE** | 0.51 |
| **R²** | 0.80 |

It predicted 0.954 for my chosen row, compared with the actual value of 0.894.

Yes, the out-of-the-box random forest performed better than the Bayes-search-tuned decision tree from my previous post!

## Visualising

There are a few ways to visualise a random forest, such as the trees, the predictions, and the errors. Feature importances can also be used to compare the individual trees in a forest.

### Individual tree plots

Fairly obviously, you can plot an individual decision tree. They can be accessed using `rf.estimators_`. For example, this is the first one:

![single tree](/images/posts/data-and-analytics/visualising-random-forests/vrf0.png)

This one has a depth of 34, 9,432 leaves, and 18,863 nodes. And this random forest has 100 similar trees!

### Individual predictions

One way I like to visualise random forests is plotting the individual predictions for each tree. For example, I can do so for my chosen row with `[tree.predict(chosen[features].values) for tree in rf.estimators_]`, and plot the results on a scatter:

![individual predictions](/images/posts/data-and-analytics/visualising-random-forests/vrf1.png)

As a reminder, the true value is 0.894. You can easily see how, while some trees were way off, the mean of all the predictions is pretty close - similar to the central limit theorem (CLT). This is my favourite way of seeing the magic of random forests.

### Individual errors

Taking this one step further, you can iterate through all the trees, have them make predictions for the entire dataset, then calculate an error statistic. In this case, for MSE:

![individual errors](/images/posts/data-and-analytics/visualising-random-forests/vrf2.png)

The mean MSE was ~0.30, so slightly higher than the overall random forest - again showing the advantage of a forest over a single tree. The best tree was number 32, with an MSE of 0.27; the worst, 74, was 0.34 - although still pretty decent. They both have depths of 34±1, with ~9400 leaves and ~18000 nodes - so, structurally, very similar.

### Feature importances

Clearly a plot with all the trees would be difficult to see, so this is the importances for the overall forest, with the best and worst tree:

![feature importances](/images/posts/data-and-analytics/visualising-random-forests/vrf3.png)

The best and worst trees still have similar importances for the different features - although the order is not necessarily the same. Median income is by far the most important factor based on this analysis.

## Hyperparameter tuning

The same hyperparameters that apply to individual decision trees do, of course, apply to random forests made up of decision trees. For comparison's sake, I created some RFs with the values I’d used in the previous post:

| Metric | max_depth=3 | ccp_alpha=0.005 | min_samples_split=10 | min_samples_leaf=10 | max_leaf_nodes=100 |
| --- | --- | --- | --- | --- | --- |
| **Time to fit (s)** | 1.43 | 25.04 | 3.84 | 3.77 | 3.32 |
| **Time to predict (s)** | 0.006 | 0.013 | 0.028 | 0.029 | 0.020 |
| **MAE** | 0.58 | 0.49 | 0.37 | 0.37 | 0.41 |
| **MAPE** | 0.37 | 0.30 | 0.22 | 0.22 | 0.25 |
| **MSE** | 0.60 | 0.45 | 0.29 | 0.30 | 0.34 |
| **RMSE** | 0.78 | 0.67 | 0.54 | 0.55 | 0.58 |
| **R²** | 0.54 | 0.66 | 0.78 | 0.77 | 0.74 |
| **Chosen prediction** | 1.208 | 1.024 | 0.935 | 0.920 | 0.969 |

The first thing we see - none performed better than the default tree (`max_depth=None`) above. This is different from the individual decision trees, where the ones with constraints performed better - again demonstrating that the power of a CLT-powered imperfect forest over one “perfect” tree. However, similar to before, `ccp_alpha` takes a long time, and shallow trees are pretty rubbish.

Beyond these, there are some hyperparameters that RFs have that DTs don’t. The most important one is `n_estimators` - in other words, the number of trees!

### n_jobs

But first, `n_jobs`. This is how many jobs to run in parallel. Doing things in parallel is typically faster than in serial/sequentially. The resulting RF will be the same, with the same error etc scores (assuming `random_state` is set), but it should be done quicker! To test this, I added `n_jobs=-1` to the default RF - in this context, `-1` means “all”.

Remember how the default one took almost 6 seconds to fit and 0.1 to predict? Parallelised, it took only 1.1 seconds, and 0.03 to predict - a 3~6x improvement. I’ll definitely be doing this from now on!

### n_estimators

OK, back to the number of trees. The default RF has 100 estimators; let’s try 1000. It took ~10 times as long (9.7 seconds to fit, 0.3 to predict, when parallelised), as one might have predicted. The scores?

| Metric | n_estimators=1000 |
| --- | --- |
| **MAE** | 0.328 |
| **MAPE** | 0.191 |
| **MSE** | 0.252 |
| **RMSE** | 0.502 |
| **R²** | 0.807 |

Very little difference; MSE and RMSE are 0.01 lower, and R² is 0.01 higher. So better, but worth the 10x time investment?

Let’s cross-validate, just to check.

Rather than use my custom loop, I’ll use `sklearn.model_selection.cross_validate`, as touched on in the previous post:

```python
cross_validate(rf, X, y, cv=RepeatedKFold(n_splits=5, n_repeats=20, random_state=42), n_jobs=-1, scoring={
    'neg_mean_absolute_error': 'neg_mean_absolute_error',
    'neg_mean_absolute_percentage_error': 'neg_mean_absolute_percentage_error',
    'neg_mean_squared_error': 'neg_mean_squared_error',
    'root_mean_squared_error': make_scorer(lambda y_true, y_pred: np.sqrt(mean_squared_error(y_true, y_pred)), greater_is_better=False),
    'r2': 'r2'
})
```

I’m using `RepeatedKFold` as the splitting strategy, which is more stable but slower than `KFold`; as the dataset isn’t that big, I’m not too concerned about the additional time it will take.

As there is no standard RMSE scorer, so I had to create one with `sklearn.metrics.make_scorer` and a lambda function.

For the decision trees, I did 1000 loops. However, given the default random forest contains 100 trees, 1000 loops would be a *lot* of trees, and therefore take a *lot* of time. I’ll try 100 (20 repeats of 5 splits) - still a lot, but thanks to parallelisation it wasn’t *too* bad - the 100 trees version took 2mins (1304 seconds of unparallelised time), and the 1000 one took 18mins (10254s!) Almost 100% CPU across all cores, and it got pretty toasty - it’s not often my MacBook fans turn on, but this maxed them out!

How do they compare? The 100-tree one:

| Metric | Mean | Std |
| --- | --- | --- |
| MAE | -0.328 | 0.006 |
| MAPE | -0.184 | 0.005 |
| MSE | -0.253 | 0.010 |
| RMSE | -0.503 | 0.009 |
| R² | 0.810 | 0.007 |

and the 1000-tree one:

| Metric | Mean | Std |
| --- | --- | --- |
| MAE | -0.325 | 0.006 |
| MAPE | -0.183 | 0.005 |
| MSE | -0.250 | 0.010 |
| RMSE | -0.500 | 0.010 |
| R² | 0.812 | 0.006 |

Very little difference - probably not worth the extra time/power.

### Bayes searching

Finally, let’s do a Bayes search. I used a wide hyperparameter range.

```python
search_spaces = {
    'n_estimators': (50, 500),
    'max_depth': (1, 100),
    'min_samples_split': (2, 100),
    'min_samples_leaf': (1, 100),
    'max_leaf_nodes': (2, 20000),
    'max_features': (0.1, 1.0, 'uniform'),
    'bootstrap': [True, False],
    'ccp_alpha': (0.0, 1.0, 'uniform'),
}
```

The only hyperparameter we haven’t seen so far is `bootstrap`; this determines whether to use the whole dataset when building a tree, or using a bootstrap-based (sample with replacement) approach. Most commonly this is set to `True`, but let’s try `False` anyway.

I did 200 iterations, which took 66 (!!) minutes. It gave:

```python
Best Parameters: OrderedDict({'bootstrap': False, 'ccp_alpha': 0.0, 'criterion': 'squared_error', 'max_depth': 39, 'max_features': 0.4863711682589259, 'max_leaf_nodes': 20000, 'min_samples_leaf': 1, 'min_samples_split': 2, 'n_estimators': 380})
```

See how `max_depth` was similar to the simple ones above, but `n_estimators` and `max_leaf_nodes` were very high (note `max_leaf_nodes` is not the actual number of leaf nodes, just the maximum allowed value; the mean number of leaves was 14,954). `min_samples_` were both the minimum - similar to before when we compared the constrained forests to the unconstrained one. Also interesting how it didn’t bootstrap.

What does that give us (the quick test, not the cross validated one)?

| Metric | Value |
| --- | --- |
| MAE | 0.313 |
| MAPE | 0.181 |
| MSE | 0.229 |
| RMSE | 0.478 |
| R² | 0.825 |

The best so far, although only just. For consistency, I also cross validated:

| Metric | Mean | Std |
| --- | --- | --- |
| MAE | -0.309 | 0.005 |
| MAPE | -0.174 | 0.005 |
| MSE | -0.227 | 0.009 |
| RMSE | -0.476 | 0.010 |
| R² | 0.830 | 0.006 |

It’s performing very well. Comparing the absolute errors for the best decision tree (the Bayes search one), the default RF, and the Bayes searched RF, gives us:

![box plot](/images/posts/data-and-analytics/visualising-random-forests/vrf4.png)

## Conclusion

In the last post, the Bayes decision tree seemed good, especially compared with the basic decision tree; now it seems terrible, with higher errors, lower R², and wider variances! So why not always use a random forest?

Well, random forests do take a lot longer to fit (and predict), and this becomes even more extreme with larger datasets. Doing thousands of tuning iterations on a forest with hundreds of trees and a dataset of millions of rows and hundreds of features… Even with parallelisation, it can take a long time. It makes it pretty clear why GPUs, which specialise in parallel processing, have become essential for machine learning. Even so, you have to ask yourself - what is good enough? Does the ~0.05 improvement in MAE actually matter for your use case?

When it comes to visualisation, as with decision trees, plotting individual trees can be a good way to get an idea of the overall structure. Additionally, plotting the individual predictions and errors is a great way to see the variance of a random forest, and get a better understanding of how they work.

But there are more tree variants! Next, gradient boosted ones.