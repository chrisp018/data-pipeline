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

CREATE TABLE enrich_source_sql_stream_001 AS
  SELECT cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) as session_id,
  WINDOWSTART as EVENT_TS,
  count(*) as events,
  client_event as client_event
  FROM SOURCE_SQL_STREAM_001 window SESSION (30 second) GROUP BY user_id, device_id EMIT CHANGES;






CREATE STREAM enrich_source_sql_stream_001 AS
  SELECT
  UCASE(cast(user_id as VARCHAR) || '_' || SUBSTRING(device_id,1,3)
  || cast( UNIX_TIMESTAMP(STEP(client_timestamp by interval '30' second ))/1000 as VARCHAR)) as session_id,
  client_event as client_event,
  FROM SOURCE_SQL_STREAM_001;
)

CREATE STREAM enrich_source_sql_stream_001 AS 
  SELECT cast(user_id as VARCHAR) + '_' + SUBSTRING(device_id,1,3) as session_id,
  client_event as client_event 
  FROM SOURCE_SQL_STREAM_001;

CREATE STREAM enrich_source_sql_stream_001 AS 
  cast( UNIX_TIMESTAMP(STEP(client_timestamp by interval 30 second ))/1000 as VARCHAR) as session_id,
  client_event as client_event 
  FROM SOURCE_SQL_STREAM_001;

CREATE STREAM source_sql_stream_001 (
  user_id BIGINT,
  device_id VARCHAR,
  client_event VARCHAR, 
  client_timestamp VARCHAR) 
  WITH (
    VALUE_FORMAT='JSON', 
    KAFKA_TOPIC='SOURCE_SQL_STREAM_001'
    );
---------------------------------------------------------------------------------------------------
-- Build materialized stream views:
---------------------------------------------------------------------------------------------------
-- Table of events per minute for each user:
CREATE TABLE event_per_min AS
  SELECT
    user_id as k1,
    AS_VALUE(user_id) as user_id,
    WINDOWSTART as EVENT_TS,
    count(*) AS events
  FROM source_sql_stream_001 window TUMBLING (size 60 second)
  GROUP BY user_id;

-- Table counts number of events within the session
CREATE TABLE CLICK_USER_SESSIONS AS
  SELECT
    -- Make the Session ID using user_ID+device_ID and Timestamp
    UCASE(CAST("user_id" as VARCHAR)|| '_' ||SUBSTRING("device_id",1,3)
    || "client_timestamp" as session_id,
    "user_id",
    "device_id",
    -- Count the number of client events , clicks on this session
    COUNT("client_event") events,
    FROM SOURCE_SQL_STREAM_001 window SESSION (30 second)
    GROUP BY session_id


-- Create the PUMP
CREATE OR REPLACE PUMP "WINDOW_PUMP_SEC" AS INSERT INTO "DESTINATION_SQL_STREAM"
-- Insert as Select 
    SELECT  STREAM
-- Make the Session ID using user_ID+device_ID and Timestamp
    UPPER(cast("user_id" as VARCHAR(3))|| '_' ||SUBSTRING("device_id",1,3)
    ||cast( UNIX_TIMESTAMP(STEP("client_timestamp" by interval '30' second))/1000 as VARCHAR(20))) as session_id,
    "user_id" , "device_id",
-- create a common rounded STEP timestamp for this session
    STEP("client_timestamp" by interval '30' second),
-- Count the number of client events , clicks on this session
    COUNT("client_event") events,
-- What was the first navigation action
    first_value("client_event") as beginnavigation,
-- what was the last navigation action    
    last_value("client_event") as endnavigation,
-- begining minute and second  
    SUBSTRING(cast(min("client_timestamp") AS VARCHAR(25)),15,19) as beginsession,
-- ending minute and second      
    SUBSTRING(cast(max("client_timestamp") AS VARCHAR(25)),15,19) as endsession,
-- session duration    
    TSDIFF(max("client_timestamp"),min("client_timestamp"))/1000 as duration_sec
-- from the source stream    
    FROM "SOURCE_SQL_STREAM_001"
-- using stagger window , with STEP to Seconds, for Seconds intervals    
    WINDOWED BY STAGGER (
                PARTITION BY "user_id", "device_id", STEP("client_timestamp" by interval '30' second) 
                RANGE INTERVAL '30' SECOND );