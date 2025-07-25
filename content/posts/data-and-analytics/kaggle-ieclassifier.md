---
title: "Kaggle: Predict the Introverts from the Extroverts"
date: 2025-07-25
tags: ['Data Science', 'Classification', 'Clustering', 'Python']
hero: /images/posts/heroes/kaggle-ieclassifier.png
---
*I’ve spent the last few months (and continue to spend them) working for an EV startup - as such, I've had a lot less time for personal projects such as this.*

The Kaggle notebook for this project can be found here: [https://www.kaggle.com/code/jamesdeluk/ieclassifier](https://www.kaggle.com/code/jamesdeluk/ieclassifier)

It's a quick and dirty one, not particularly tidy - I just felt the urge to have a play. Don't judge me.

## Intro

A simple challenge from Kaggle's Playground series, called *Predict the Introverts from the Extroverts*. It can be found here: [https://www.kaggle.com/competitions/playground-series-s5e7](https://www.kaggle.com/competitions/playground-series-s5e7)

The data consists of 7 features - `Time_spent_Alone`, `Stage_fear`, `Social_event_attendance`, `Going_outside`, `Drained_after_socializing`, `Friends_circle_size`, `Post_frequency` - and you have to build a model to predict whether the person is an introvert or an extrovert - `Personality`.

## Exploratory data analysis

Start with the obvious - `describe()`, `isnull().sum()`, `duplicated().sum()`, histograms for distributions. All columns are either floats or binaries (represented as the strings `Yes` or `No`). No obvious outliers, no duplicates, lots of missing data, slightly skewed features but not excessively so, ~1:3 target imbalance. Some are highly correlated (stage fear and drained after socialising are 0.99), so it could be wise to drop one to avoid multicollinearity. Similar for the train and test data, suggesting the trained model should be suitable for the test data.

## Basic classifiers

I'll start with the bare minimum processing and most basic models - logistic regressor and XGBClassifier - and see what I get.

First, for both testing and training, drop the NaNs, as the models can't handle them, and I'll map the "Yes"/"No" to 1/0 ("Extrovert"/"Introvert" to 1/0 also for the training data) so they're numeric, as needed for the models. Also, drop the useless (for modelling purposes) `id` column. I did this using a simple function I wrote:

```
df_train_processed = process_data(df_train_raw)
df_test_processed = process_data(df_test_raw)
```

Second, prep the data. X is the df without 'Personality', y is 'Personality'. `train_test_split` to get what's needed for training and valication.

```python
X = df_train_processed.drop(columns=['Personality'])
y = df_train_processed['Personality']
X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
```

Third, the models. Make and fit the logreg on `X_train` and `y_train`, predict on `X_val`, then get the accuracy score using `y_val`.

```python
clf = LogisticRegression(random_state=42)
clf.fit(X_train, y_train)
pred = clf.predict(X_val)
print("Validation Accuracy:", accuracy_score(y_val, pred))
```

I got `Validation Accuracy: 0.957801766437684` - not bad at all!

I also gave an XGBClassifier a go:

```python
clif = XGBClassifier(eval_metric='logloss', random_state=42)
clif.fit(X_train, y_train)
pred = clif.predict(X_val)
print("Validation Accuracy:", accuracy_score(y_val, pred))
```

`Validation Accuracy: 0.9533856722276742` - fractionally worse.

Out of interest:

```python
pd.DataFrame({
    'feature': X_1.columns,
    'importance': xgb_clf_1.feature_importances_
}).sort_values(by='importance', ascending=False)
```

| feature | importance |
|---------|------------|
| Stage_fear | 0.958404 |
| Drained_after_socializing | 0.032015 |
| Time_spent_Alone | 0.002194 |
| Social_event_attendance | 0.001947 |
| Friends_circle_size | 0.001926 |
| Going_outside | 0.001808 |
| Post_frequency | 0.001707 |

One feature is almost the entire importance - if you have stage fear, you'll be an introvert. Typically a single feature having such high importance is not ideal.

Finally, enter the competition. Add the prediction to the test data, then join with the original data to bring the previously-dropped `id` column back, which is needed for the submission. Once the CSV is created, save the notebook, and submit the CSV to the competition.

```python
df_test_processed['Personality'] = clf.predict(df_test_processed)
submission = df_test[['id']].join(df_test['Personality'].map({1:'Extrovert',0:'Introvert'}))
submission.to_csv('submission.csv', index=None)
```

And I got...

**0.509311**

Not good. But not unexpected. A quick look at what I submitted makes it obvious:

| id | Personality |
|----|-------------|
| 18524 | NaN |
| 18525 | NaN |
| 18526 | Extrovert |
| 18527 | Extrovert |
| 18528 | Introvert |

Because I dropped the NaNs, a huge number of my predictions were also NaN - which is clearly incorrect.

## Filling NaNs

OK, let's fix the NaN issue.

First, a simple method - fill each NaN with the column mean. To my processing function, I added:

```python
df = df.fillna(df.mean())
```

This has the downside of making the column no longer binary (i.e. I can't map back to "Yes"/"No" as the mean will be a float between 0 and 1), but I'll try it anyway. I left everything else the same, and got:

`Validation Accuracy: 0.968421052631579`

Fractionally higher than before. Yet when I submitted, I got a score of:

**0.973279**

Much better. Almost perfect! In the world, I'm not sure if I'd concern myself with trying to improve the score, unless a cost-benefit analysis suggested it was truly required.

Interestingly, the XGB feature importances changed:

| feature | importance |
|---------|------------|
| Drained_after_socializing | 0.908120 |
| Stage_fear | 0.076074 |
| Time_spent_Alone | 0.004059 |
| Social_event_attendance | 0.003073 |
| Going_outside | 0.003043 |
| Post_frequency | 0.002830 |
| Friends_circle_size | 0.002800 |

Notably, drained after socialising and stage fear are both the binary highly-correlated Yes/No features. Probably would make sense to drop one.

## Pipelinification

```python
X = df_train.drop(columns=['id','Personality'])
y = df_train['Personality']
X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)

num_cols = ['Time_spent_Alone','Social_event_attendance','Going_outside','Friends_circle_size','Post_frequency']
cat_cols = ['Stage_fear','Drained_after_socializing']

numeric_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='median', add_indicator=True)),
    ('scaler', StandardScaler()),
])

categorical_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='constant', fill_value='__missing__')),
    ('onehot', OneHotEncoder(handle_unknown='ignore')),
])

preprocessor = ColumnTransformer([
    ('num', numeric_transformer, num_cols),
    ('cat', categorical_transformer, cat_cols),
], remainder='drop')

pipe = Pipeline([
    ('pre', preprocessor),
    ('clf', LogisticRegression(random_state=42)),
])

pipe.fit(X_train, y_train)
pred = pipe.predict(X_val)
print("Validation Accuracy:", accuracy_score(y_val, pred))
```

This avoids the `process_data()` function, hence why `X` and `y` are redefined, and `id` is explicitly dropped. The pipeline makes it easier to ensure the train and test data are treated equally. For the numeric columns, it imputes them with the median value (I tried mean too), and scales them (which can help with model convergence). For the categorical columns, it fills NaNs with `__missing__`, and one-hot encodes them (which is why I don't need the manual `map()`ing). Then it runs it through a logreg (again, I also tried XGB).

`Validation Accuracy: 0.9668016194331984`

Same ballpark. The submission score went up marginally, to:

**0.974089**

## More statistical imputation

Instead of the mean/median, I thought I'd try two numeric methods to impute missing values: K-nearest neighbours, and MICE (Multivariate Imputation by Chained Equations). As these are numeric, for the categorical columns, I'll again have to map them to 1/0 before putting them through the pipeline.

```python
numeric_transformer = Pipeline([
    ('imputer', KNNImputer(n_neighbors=5, weights="distance")),
    ('scaler', StandardScaler()),
])

categorical_transformer = Pipeline([
    ('imputer', KNNImputer(n_neighbors=5, weights="distance")),
    ('threshold', ThresholdToBinary(threshold=0.5)),
])
```

Note the `ThresholdToBinary()`, which is:

```python
from sklearn.base import BaseEstimator, TransformerMixin

class ThresholdToBinary(BaseEstimator, TransformerMixin):
    def __init__(self, threshold=0.5):
        self.threshold = threshold

    def fit(self, X, y=None):
        return self

    def transform(self, X):
        return (X > self.threshold).astype(int)
```

This converts the KNN output (potentially a float between 0 and 1) to a binary 0/1.

The rest of the pipeline is the same as before. And the result:

`Validation Accuracy: 0.9668016194331984`

Yup, the same.

For MICE, I use `('imputer', IterativeImputer(max_iter=1000, random_state=42))`

But, again, `Validation Accuracy: 0.9668016194331984`. Score? The same.

## Something different: clustering

I was curious to see what would happen if, instead of predicting with a classifier, I used a clustering algorithm to group them into two clusters. It uses the preprocessor from before, meaning it needs the pre-mapped data. Then, instead of a `clf`, it uses a `clusterer`, which I set to 2 clusters. Then, fit against the manually processed data (no split), assign it to a column in the data, then add the original training data `Personality` values.

```python
pipe = Pipeline([
    ('pre', preprocessor),
    ('clusterer', KMeans(n_clusters=2, random_state=42))
])

pipe.fit(X_4)
X_4['Cluster'] = kmeans_pipe.named_steps['clusterer'].labels_
df_train_cluster = X_4.join(y_4)
df_train_cluster[['Cluster','Personality']]
```

Some interesting results:

| Cluster | Personality |
|---------|-------------|
| 0 | 1 |
| 0 | 1 |
| 1 | 0 |
| 0 | 1 |
| 0 | 1 |

The clustering has mostly given the same as the `Personality` target (just inverted, as the clustering doesn't know which is 0 and which is 1). Perhaps that's good enough?

Another quick check:

`df_train_cluster[['Cluster','Personality']].value_counts()`

| Cluster | Personality | Count | % |
|---------|-------------|-------| --- |
| 0 | 1 | 13423 | 0.724628 |
| 1 | 0 | 4518 | 0.243900 |
| 0 | 0 | 307 | 0.016573 |
| 1 | 1 | 276 | 0.014900 |

So for ~18000 the clustering matched the actual value in the training data, although in about 3% it was wrong - an 'accuracy' of 0.968528 (similar to the classifier algos). After inverting the mapping, i.e. `.map({0:'Extrovert',1:'Introvert'})`, I submitted, and got a score of:

**0.974089**

Surprisingly, exactly the same as the classifier!

## Summary

All my models got >0.97, which is decent. For reference, in the competition, the current best score is 0.977327, so only a marginal improvement. I'm happy to leave it here.