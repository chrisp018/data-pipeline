---------------------------------------------------------------------------------------------------
-- Create sources:
---------------------------------------------------------------------------------------------------
-- stream of user clicks:
-- CREATE STREAM source_sql_stream_001 ( user_id BIGINT, device_id VARCHAR, client_event VARCHAR, client_timestamp VARCHAR) WITH ( VALUE_FORMAT='JSON',KAFKA_TOPIC='SOURCE_SQL_TOPIC_001',timestamp='client_timestamp',timestamp_format='yyyy-MM-dd''T''HH:mm:ss.SSSSSS') EMIT CHANGES;
CREATE STREAM source_sql_stream_001 (
  user_id BIGINT,
  device_id VARCHAR, 
  client_event VARCHAR, 
  client_timestamp VARCHAR EMIT CHANGES;) 
  WITH (
    VALUE_FORMAT='JSON', 
    KAFKA_TOPIC='SOURCE_SQL_TOPIC_001'
    timestamp='client_timestamp',
    timestamp_format='yyyy-MM-dd''T''HH:mm:ss.SSSSSS'
    )
  EMIT CHANGES;

DESCRIBE source_sql_stream_001 EXTENDED;
SELECT user_id, client_event FROM SOURCE_SQL_STREAM_001 EMIT CHANGES;
SET 'auto.offset.reset'='earliest';

-- Enrich click-stream with more information:
-- CREATE TABLE enrich_source_sql_stream_001 AS SELECT cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) as session_id, TIMESTAMPTOSTRING(WINDOWSTART,'yyyy-MM-dd HH:mm:ss', 'UTC') AS SESSION_START_TS, TIMESTAMPTOSTRING(WINDOWEND,'yyyy-MM-dd HH:mm:ss', 'UTC')   AS SESSION_END_TS, count(*) AS CLICK_COUNT, (WINDOWEND - WINDOWSTART)/1000 AS SESSION_LENGTH_MS FROM SOURCE_SQL_STREAM_001 window SESSION (30 second) GROUP BY cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) EMIT CHANGES;

CREATE TABLE enrich_source_sql_stream_001 AS
  SELECT cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) as session_id,
    TIMESTAMPTOSTRING(WINDOWSTART,'yyyy-MM-dd HH:mm:ss', 'UTC') AS SESSION_START_TS,
    TIMESTAMPTOSTRING(WINDOWEND,'yyyy-MM-dd HH:mm:ss', 'UTC')   AS SESSION_END_TS,
    count(*) AS CLICK_COUNT,
    WINDOWEND - WINDOWSTART AS SESSION_LENGTH_MS
  FROM SOURCE_SQL_STREAM_001 window SESSION (30 second) 
  GROUP BY cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) 
  EMIT CHANGES;
-- Create session table with more information:
CREATE TABLE dest_sql_stream_001 AS (
  SELECT session_id, session_start_ts, session_end_ts, click_count, session_length_ms 
  FROM enrich_source_sql_stream_001
)