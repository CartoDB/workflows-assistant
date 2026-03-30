-- Example from the CARTO Workflows template repository
CREATE OR REPLACE PROCEDURE
  `cartodb-on-gcp-pm-team.workflows_temp.wfproc_f2d82bd349c7b954`(
)
BEGIN
  /*
   {"versionId":"cf9c2f4cf344758e","paramsId":"97d170e1550eee4a","isImmutable":true,"diagramJson":"{\"tags\":[],\"edges\":[],\"nodes\":[],\"title\":\"BigQuery ML - Forecast Pipeline\",\"useCache\":true,\"viewport\":{},\"description\":\"\",\"thumbnailUrl\":\"\",\"schemaVersion\":\"1.0.0\",\"connectionProvider\":\"bigquery\"}"}
  */
  DECLARE __outputtable STRING;
  DECLARE __outputtablefqn STRING;
  SET __outputtable = 'wfproc_f2d82bd349c7b954_out_' || SUBSTRING(TO_HEX(MD5('')), 1, 16);
  SET __outputtablefqn = 'cartodb-on-gcp-pm-team.workflows_temp.wfproc_f2d82bd349c7b954_out_' || SUBSTRING(TO_HEX(MD5('')), 1, 16);
  BEGIN
    BEGIN
    CREATE TEMPORARY TABLE `WORKFLOW_f2d82bd349c7b954_2354fb965b7cbcd5_match`
    AS
      SELECT *
      FROM `cartobq.docs.hotel_sales_usa`
      WHERE
        Date < CAST ('2018-01-01' AS date);
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_createforecastmodel_13968708(
      'WORKFLOW_f2d82bd349c7b954_2354fb965b7cbcd5_match',
      null,
      '''cartobq.docs.forecast_template_model''',
      'ARIMA_PLUS',
      'Location',
      'Date',
      'Revenue',
      true,
      null,
      null,
      null,
      'DAILY',
      '''US''',
      false,
      'WORKFLOW_f2d82bd349c7b954_90c981ec72f28f52_model_output_table',
      false,
      '{}'
    );
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_forecast_75350871(
      'WORKFLOW_f2d82bd349c7b954_90c981ec72f28f52_model_output_table',
      null,
      'ARIMA_PLUS',
      60,
      0.95,
      'WORKFLOW_f2d82bd349c7b954_950aee5ce7ceaae0_output_table',
      false,
      '{}'
    );
    END;
    BEGIN
    DROP TABLE IF EXISTS `cartobq.docs.hotel_sales_usa_predictions_2018`;
    CREATE TABLE IF NOT EXISTS `cartobq.docs.hotel_sales_usa_predictions_2018`
    AS
      SELECT * FROM `WORKFLOW_f2d82bd349c7b954_950aee5ce7ceaae0_output_table`;
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_evaluateforecast_693440(
      'WORKFLOW_f2d82bd349c7b954_90c981ec72f28f52_model_output_table',
      false,
      'WORKFLOW_f2d82bd349c7b954_4cdf60304107c4ab_output_table',
      false,
      '{}'
    );
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_explainforecast_35506911(
      'WORKFLOW_f2d82bd349c7b954_90c981ec72f28f52_model_output_table',
      null,
      'ARIMA_PLUS',
      60,
      0.95,
      'WORKFLOW_f2d82bd349c7b954_3e6c2319d85362cb_output_table',
      false,
      '{}'
    );
    END;
    EXECUTE IMMEDIATE
    REPLACE(
      '''DROP TABLE IF EXISTS `##TABLENAME##`''',
      '##TABLENAME##',
      __outputtablefqn
    );
    EXECUTE IMMEDIATE
    REPLACE(
      '''CREATE TABLE `##TABLENAME##`
      OPTIONS (
        expiration_timestamp = TIMESTAMP_ADD(
          CURRENT_TIMESTAMP(), INTERVAL 30 DAY
        )
      )
      AS
        SELECT 1 as dummy''',
      '##TABLENAME##',
      __outputtablefqn
    );
  END;
END;