with a as (select distinct user_id, event_timestamp, isPlaying
           from events
           where event_date = '20220528'
             and event_name = 'audio_livestream'
             and event_timestamp between '1653766500000000' and '1653773700000000'
             and user_id not in (select user_id
                                 from events
                                 where event_date = '20220528'
                                   and event_name = 'audio_livestream'
                                 group by user_id
                                 having count(*) = 1)
           order by user_id, event_timestamp asc),
     b as (select user_id,
                  neighbor(user_id, -1)         user_id_prev,
                  event_timestamp,
                  neighbor(event_timestamp, -1) event_timestamp_prev,
                  isPlaying
           from a
           order by user_id, event_timestamp asc),
     c as (select *
           from b
           where user_id_prev = user_id
             and isPlaying = 0
           order by user_id, event_timestamp asc),
     d as (select user_id, (event_timestamp - event_timestamp_prev) as delta
           from c)
select avg(delta)/1000000
from d


-- Dio oko problema sa razlicitim countom ukupno distinct id-a i grupirano po zemlji 

select user_pseudo_id, count(distinct(geo_country)) as cnt
    from events
    where event_date='20220528' and event_name='audio_livestream'
        group by user_pseudo_id
        having cnt > 1

select user_pseudo_id, geo_country, isPlaying
    from events
    where event_date='20220528' and event_name='audio_livestream'
    and user_pseudo_id ='862346f151cba2c8348b5fa337c169d5'