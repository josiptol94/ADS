-- DQ shema

CREATE TABLE "dq.dq_checks" (
	"check_name" varchar(255) NOT NULL UNIQUE,
	"dq_metric" varchar(50) NOT NULL,
	"dq_metric_type" varchar(15) NOT NULL DEFAULT 'prcnt',
	"source_table_name" varchar(255) NOT NULL,
	"target_table_name" varchar(255) NOT NULL,
	"source_field_name" varchar(255) NOT NULL,
	"target_field_name" varchar(255) NOT NULL,
	"status" varchar(2) NOT NULL DEFAULT 'Y',
	"run_dynamic" varchar(2) NOT NULL DEFAULT 'D',
	"check_sql" TEXT(5000) NOT NULL,
	"last_run" TIMESTAMP NOT NULL,
	"comment" TEXT NOT NULL
) WITH (
  OIDS=FALSE
);



CREATE TABLE "dq.dq_results" (
	"check_ts_start" TIMESTAMP NOT NULL,
	"check_ts_end" TIMESTAMP NOT NULL,
	"check_name" varchar(255) NOT NULL,
	"check_result" varchar(255) NOT NULL,
	"check_dump" TEXT(5000) NOT NULL,
	"execution_time" TIME NOT NULL
) WITH (
  OIDS=FALSE
);




ALTER TABLE "dq_results" ADD CONSTRAINT "dq_results_fk0" FOREIGN KEY ("check_name") REFERENCES "dq_checks"("check_name");




--Upit uniqueness

SELECT
    SUM(cnt) - COUNT(*) AS number_of_duplicates
FROM (
     SELECT event_name,
            user_pseudo_id,
            event_timestamp,
            COUNT(*) as cnt
     FROM events
     WHERE event_date = toString(toYYYYMMDD(date_sub(day,2,now()))) AND
           update_date <= (SELECT MAX(update_date) as max_update_date FROM events WHERE event_date = toString(toYYYYMMDD(date_sub(day,2,now()))) )
     GROUP BY event_name, user_pseudo_id, event_timestamp
     HAVING cnt > 1
 );