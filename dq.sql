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