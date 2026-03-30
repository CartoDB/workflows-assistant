-- Example from the CARTO Workflows template repository
CREATE OR REPLACE PROCEDURE
  `cartodb-on-gcp-pm-team.workflows_temp.wfproc_038a17df087b8c28`(
)
BEGIN
  /*
   {"versionId":"37f0d05b29a89cbe","paramsId":"97d170e1550eee4a","isImmutable":true,"diagramJson":"{\"tags\":[],\"edges\":[{\"id\":\"d9945c50-eed7-4bd9-be5d-a20c487d62a9\",\"source\":\"b24fddac-c033-4220-8da5-ad7b144ef1bd\",\"target\":\"db972456-740a-4a13-b377-b5254cfd3931\",\"animated\":false,\"selected\":false,\"sourceHandle\":\"unmatch\",\"targetHandle\":\"input_table\"},{\"id\":\"366fe0c6-acd7-4659-aff0-262b8ab44a57\",\"source\":\"ebc42760-1504-405d-bf61-6f61841d9251\",\"target\":\"8aea7967-00e3-4b24-9262-5541cb9f5069\",\"animated\":false,\"selected\":false,\"sourceHandle\":\"output_table\",\"targetHandle\":\"model_table\"},{\"id\":\"66864fb2-1b41-4ea4-bed3-94af5e245b7f\",\"source\":\"f5cff6e9-8a64-47b7-9bef-ffd6c72dff56\",\"target\":\"b24fddac-c033-4220-8da5-ad7b144ef1bd\",\"animated\":false,\"selected\":false,\"sourceHandle\":\"out\",\"targetHandle\":\"source\"},{\"id\":\"52bbfe3b-1743-44d0-82d3-72a6d5b18c02\",\"source\":\"ebc42760-1504-405d-bf61-6f61841d9251\",\"target\":\"5da57e8c-727b-4afe-b10e-ae826d35f753\",\"animated\":false,\"selected\":false,\"sourceHandle\":\"output_table\",\"targetHandle\":\"model_table\"},{\"id\":\"63600573-9a40-4f75-a7ba-8f960f4c4694\",\"source\":\"ebc42760-1504-405d-bf61-6f61841d9251\",\"target\":\"db972456-740a-4a13-b377-b5254cfd3931\",\"animated\":false,\"selected\":false,\"sourceHandle\":\"output_table\",\"targetHandle\":\"model_table\"},{\"id\":\"6bdea9d0-2df6-4756-8081-9aa33d8d91ba\",\"source\":\"ebc42760-1504-405d-bf61-6f61841d9251\",\"target\":\"4d3cae09-5049-4e44-b00d-f81d725e3093\",\"animated\":false,\"selected\":false,\"sourceHandle\":\"output_table\",\"targetHandle\":\"model_table\"},{\"id\":\"e90c1c51-4ea0-4db1-996d-02cca1fa6886result-ebc42760-1504-405d-bf61-6f61841d9251input_table\",\"source\":\"e90c1c51-4ea0-4db1-996d-02cca1fa6886\",\"target\":\"ebc42760-1504-405d-bf61-6f61841d9251\",\"animated\":false,\"className\":\"\",\"sourceHandle\":\"result\",\"targetHandle\":\"input_table\"},{\"id\":\"0d0bace0-fa5c-46e3-a32a-e04236654edc\",\"source\":\"e918176c-f2f6-4b16-95b6-9de1ae72d7e2\",\"target\":\"e90c1c51-4ea0-4db1-996d-02cca1fa6886\",\"animated\":false,\"sourceHandle\":\"match\",\"targetHandle\":\"source\"},{\"id\":\"aee3412a-a53f-45f9-b04e-a64f8ee3861f\",\"source\":\"e918176c-f2f6-4b16-95b6-9de1ae72d7e2\",\"target\":\"4d3cae09-5049-4e44-b00d-f81d725e3093\",\"animated\":false,\"sourceHandle\":\"unmatch\",\"targetHandle\":\"input_table\"},{\"id\":\"00abace0-9f31-4193-aa2d-b9a34aedb3b0\",\"source\":\"e918176c-f2f6-4b16-95b6-9de1ae72d7e2\",\"target\":\"5da57e8c-727b-4afe-b10e-ae826d35f753\",\"animated\":false,\"sourceHandle\":\"unmatch\",\"targetHandle\":\"input_table\"},{\"id\":\"72c0356d-5548-4c3b-a529-c69746212a26\",\"source\":\"b24fddac-c033-4220-8da5-ad7b144ef1bd\",\"target\":\"e918176c-f2f6-4b16-95b6-9de1ae72d7e2\",\"animated\":false,\"sourceHandle\":\"match\",\"targetHandle\":\"source\"}],\"nodes\":[{\"id\":\"b24fddac-c033-4220-8da5-ad7b144ef1bd\",\"data\":{\"name\":\"native.where\",\"inputs\":[{\"name\":\"source\",\"type\":\"Table\",\"title\":\"Source table\",\"description\":\"Source table\"},{\"name\":\"expression\",\"type\":\"StringSql\",\"title\":\"Filter expression\",\"placeholder\":\"E.g.: area > 1000 AND area < 3000\",\"description\":\"Filter expression\",\"value\":\"churn_label IS NOT NULL\"}],\"version\":\"1\",\"label\":\"Where\"},\"type\":\"generic\",\"width\":64,\"height\":64,\"zIndex\":2,\"dragging\":false,\"position\":{\"x\":272,\"y\":624},\"selected\":false,\"positionAbsolute\":{\"x\":272,\"y\":624}},{\"id\":\"db972456-740a-4a13-b377-b5254cfd3931\",\"data\":{\"name\":\"predict\",\"inputs\":[{\"name\":\"model_table\",\"title\":\"Model\",\"description\":\"The trained model to use.\",\"type\":\"Table\"},{\"name\":\"input_table\",\"title\":\"Input table\",\"description\":\"The input data table.\",\"type\":\"Table\"},{\"name\":\"keep_columns\",\"title\":\"Keep input columns\",\"description\":\"Whether to keep all input columns in the output or not.\",\"type\":\"Boolean\",\"default\":true,\"value\":true},{\"name\":\"id_column\",\"title\":\"ID column\",\"description\":\"Column to use as the unique identifier for the model.\",\"type\":\"Column\",\"parent\":\"input_table\",\"noDefault\":true,\"showIf\":[{\"parameter\":\"keep_columns\",\"value\":false}]}],\"version\":\"1\",\"label\":\"Predict\"},\"type\":\"generic\",\"width\":64,\"height\":64,\"zIndex\":2,\"dragging\":false,\"position\":{\"x\":1280,\"y\":992},\"selected\":false,\"positionAbsolute\":{\"x\":1280,\"y\":992}}]}"}
  */
  DECLARE __outputtable STRING;
  DECLARE __outputtablefqn STRING;
  SET __outputtable = 'wfproc_038a17df087b8c28_out_' || SUBSTRING(TO_HEX(MD5('')), 1, 16);
  SET __outputtablefqn = 'cartodb-on-gcp-pm-team.workflows_temp.wfproc_038a17df087b8c28_out_' || SUBSTRING(TO_HEX(MD5('')), 1, 16);
  BEGIN
    BEGIN
    CREATE TEMPORARY TABLE `WORKFLOW_038a17df087b8c28_c9e429d6b6a47020_match`
    AS
      SELECT *
      FROM `cartobq.docs.telco_churn_ca_template`
      WHERE churn_label IS NOT NULL;
    CREATE TEMPORARY TABLE `WORKFLOW_038a17df087b8c28_c9e429d6b6a47020_unmatch`
    AS
      SELECT *
      FROM `cartobq.docs.telco_churn_ca_template`
      WHERE NOT churn_label IS NOT NULL;
    END;
    BEGIN
    CREATE TEMPORARY TABLE `WORKFLOW_038a17df087b8c28_f82530f6cc9ae212_match`
    AS
      SELECT *
      FROM `WORKFLOW_038a17df087b8c28_c9e429d6b6a47020_match`
      WHERE RAND() < 0.7;
    CREATE TEMPORARY TABLE `WORKFLOW_038a17df087b8c28_f82530f6cc9ae212_unmatch`
    AS
      SELECT *
      FROM `WORKFLOW_038a17df087b8c28_c9e429d6b6a47020_match`
      WHERE NOT RAND() < 0.7;
    END;
    BEGIN
    CREATE TEMPORARY TABLE `WORKFLOW_038a17df087b8c28_d2c0f4a30a6a1490_result`
    AS
      SELECT * EXCEPT (geom)
      FROM `WORKFLOW_038a17df087b8c28_f82530f6cc9ae212_match`;
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_createclassificationmodel_62852545(
      'WORKFLOW_038a17df087b8c28_d2c0f4a30a6a1490_result',
      '''cartobq.docs.telco_churn_ca_predicted''',
      'customer_id',
      'churn_label',
      'LOGISTIC_REG',
      true,
      null,
      null,
      null,
      null,
      null,
      null,
      'NO_SPLIT',
      null,
      null,
      null,
      'WORKFLOW_038a17df087b8c28_c178f9e56c659e1c_output_table',
      false,
      '{}'
    );
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_globalexplain_35582525(
      'WORKFLOW_038a17df087b8c28_c178f9e56c659e1c_output_table',
      false,
      'WORKFLOW_038a17df087b8c28_17c2502aeee4c67d_output_table',
      false,
      '{}'
    );
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_evaluate_79172253(
      'WORKFLOW_038a17df087b8c28_c178f9e56c659e1c_output_table',
      'WORKFLOW_038a17df087b8c28_f82530f6cc9ae212_unmatch',
      false,
      null,
      null,
      null,
      'WORKFLOW_038a17df087b8c28_c3cd905528819cc6_output_table',
      false,
      '{}'
    );
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_explainpredict_20570986(
      'WORKFLOW_038a17df087b8c28_c178f9e56c659e1c_output_table',
      'WORKFLOW_038a17df087b8c28_f82530f6cc9ae212_unmatch',
      3,
      'WORKFLOW_038a17df087b8c28_b0149dce895e4aff_output_table',
      false,
      '{}'
    );
    END;
    BEGIN
    CALL `cartodb-on-gcp-pm-team.workflows_temp`.__proc_predict_74702755(
      'WORKFLOW_038a17df087b8c28_c178f9e56c659e1c_output_table',
      'WORKFLOW_038a17df087b8c28_c9e429d6b6a47020_unmatch',
      true,
      null,
      'WORKFLOW_038a17df087b8c28_99b1c999e9ac6ab2_output_table',
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