---
name: ml-pipelines
description: Guides building ML pipelines in CARTO Workflows when the user wants to train a model, predict, classify, forecast, or do regression. Triggers on machine learning, ML, prediction, classification, regression, forecasting, churn, predict, train model, BigQuery ML, Snowflake ML, BQML, ARIMA, time series prediction.
---

Use this skill to design ML training, evaluation, and prediction pipelines in CARTO Workflows.

**Prerequisites**: Load `build-carto-workflow` for the full workflow development process.

## Instructions

### Step 1: Identify the ML Task

Determine which pipeline mode applies:

| Mode | Goal | Key Components |
|---|---|---|
| **Classification** | Predict a categorical label (e.g. churn yes/no) | `createclassificationmodel` -> `evaluate` -> `globalexplain` -> `predict` |
| **Regression** | Predict a continuous value (e.g. speed, revenue) | `createregressionmodel` -> `evaluate` -> `globalexplain` -> `predict` |
| **Forecasting** | Predict future values of a time series | `createforecastmodel`/`createforecastingmodel` -> `evaluateforecast` -> `explainforecast`/`featureimportanceforecast` -> `forecast` |

### Step 2: Determine the Provider

| Decision | BigQuery ML | Snowflake ML |
|---|---|---|
| Model type selection | Explicit: `LOGISTIC_REG`, `RANDOM_FOREST_CLASSIFIER`, `BOOSTED_TREE_CLASSIFIER`, `RANDOM_FOREST_REGRESSOR`, `BOOSTED_TREE_REGRESSOR` | Auto-selected by the platform |
| Data split | `AUTO_SPLIT`, `RANDOM`, `CUSTOM`, `SEQ`, `NO_SPLIT` | `SPLIT` with `test_fraction`, or `NO_SPLIT` |
| Evaluation | Single generic `evaluate` component (set `is_forecast` flag for forecast models) | Separate typed components: `evaluateclassification`, `evaluateregression`, `evaluateforecast` |
| Explain | `globalexplain`, `explainpredict` | `featureimportanceclassification`, `featureimportanceregression`, `featureimportanceforecast` |
| Column casing | As-is | Uppercased (e.g. `CUSTOMER_ID`, `CHURN_LABEL`) |

### Step 3: Build the Universal Pipeline

Follow this sequence for every ML workflow:

1. **Load** -- Read source table(s)
2. **Filter/Prepare** -- Drop GEOGRAPHY/geom column, filter nulls from the target variable, split train/test data
3. **Train** -- Use the appropriate `create*model` component with `model_fqn`, `unique_identifier_column`/`id_column`, and `input_label_column`/`target_column`
4. **Evaluate** -- Feed the held-out test set (not the training set) to the Evaluate component
5. **Explain** -- Run Global Explain or Feature Importance to understand model drivers
6. **Predict/Forecast** -- Apply the trained model to new data
7. **Save** -- Persist results with `native.saveastable`

**Success**: The workflow contains all 7 stages, the GEOGRAPHY column is excluded from training, and evaluation uses held-out data only.

### Step 4: Forecasting-Specific Parameters

When building a forecasting pipeline, set these additional parameters on the `createforecastmodel` component:

- `ts_id_column` -- Column identifying individual time series (e.g. `Location`)
- `ts_timestamp_column` -- Column with timestamps (e.g. `Date`)
- `ts_data_column` -- Target values to forecast (e.g. `Revenue`)
- `data_frequency` -- `AUTO_FREQUENCY`, `DAILY`, `WEEKLY`, `MONTHLY`, etc.
- `model_type` -- `ARIMA_PLUS` (single/multi-series) or `ARIMA_PLUS_XREG` (with external regressors, single series only)
- `horizon` -- Number of future time points to predict
- `holiday_region` -- (BQ only) e.g. `US`, `EU`

On Snowflake, exogenous variables are supported via the forecasting component's input configuration.

### Step 5: Import Model (Skip Training)

For pre-trained ONNX models, use the `importmodel` + `predict` path. This skips training entirely and goes straight to inference.

## Gotchas

- **Always drop the GEOGRAPHY/geom column before training.** ML components do not support spatial types on either platform. On Snowflake, re-join the geometry column post-prediction using the ID column.
- **Split data BEFORE training for classification/regression.** Do not rely on `WHERE RAND() < 0.7` in separate SQL statements -- `RAND()` re-evaluates on each call, causing rows to appear in both train and test sets (data leakage). Use the built-in `AUTO_SPLIT`/`SPLIT` option, or materialize the split into a temp table first.
- **Never evaluate on training data.** Wire the held-out test set (the `unmatch` output of the Where filter, or the built-in split) to the Evaluate component.
- **Forecasting uses temporal split, not random split.** Filter by date (e.g. `Date < '2018-01-01'`) to create the training window. The forecast horizon covers the future period.
- **BQ evaluation is generic; SF evaluation is typed.** On BigQuery, one `evaluate` component handles all model types (use the `is_forecast` flag for forecast models). On Snowflake, use `evaluateclassification`, `evaluateregression`, or `evaluateforecast` respectively.
- **Snowflake uppercases column names.** Always reference columns in uppercase in SF workflows (e.g. `CUSTOMER_ID` not `customer_id`).
- **Model FQN must be a valid fully-qualified table name** in the target warehouse (e.g. `project.dataset.model_name` for BQ, `db.schema.model_name` for SF).

## Reference Templates

| Template | Provider | Mode | Path |
|---|---|---|---|
| BQ Classification (churn) | BigQuery | Classification | [bq_ml_create_classification_model.sql](bq_ml_create_classification_model.sql) |
| SF Classification (churn) | Snowflake | Classification | [sf_ml_classification.sql](sf_ml_classification.sql) |
| BQ Forecast (hotel revenue) | BigQuery | Forecasting | [bq_ml_forecast.sql](bq_ml_forecast.sql) |

Additional examples available in the project root:

| File | Provider | Mode |
|---|---|---|
| `bq_ml_create_regression_model.sql` | BigQuery | Regression |
| `bq_ml_import.sql` | BigQuery | Import (ONNX) |
| `sf_ml_forecasting.sql` | Snowflake | Forecasting |

## Common Variations

| Variation | How to Handle |
|---|---|
| User wants churn prediction | Classification mode. Use `createclassificationmodel` with the churn label as `input_label_column`/`target_column`. |
| User wants to predict a numeric value (speed, price, revenue) | Regression mode. Use `createregressionmodel`. Same pipeline as classification but with continuous target. |
| User wants time series forecasting | Forecasting mode. Filter by date for train/test split, configure `ts_id_column`, `ts_timestamp_column`, `data_frequency`, and `horizon`. |
| User has a pre-trained model (ONNX) | Use `importmodel` -> `predict`. No training components needed. |
| User needs to re-attach geometry after prediction | On Snowflake: save GEOM + ID to a side table before dropping, then Join post-prediction on the ID column. |
| User asks about model explainability | Add `globalexplain` (BQ) or `featureimportance*` (SF) after training, and optionally `explainpredict` for per-row attributions (BQ only). |
