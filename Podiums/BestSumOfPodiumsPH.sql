SELECT 
    eventid, 
    competitionid, 
    wca_statistics_time_format(sum_value, eventid, 'average') AS "sum", 
    wca_statistics_time_format(first_place_time, eventid, 'average') AS "1st_place_time", 
    wca_statistics_time_format(second_place_time, eventid, 'average') AS "2nd_place_time", 
    wca_statistics_time_format(third_place_time, eventid, 'average') AS "3rd_place_time"
FROM 
(
    SELECT 
        competitionid, 
        eventid, 
        SUM(CASE WHEN eventid IN ('333bf', '444bf', '555bf') THEN best ELSE average END) AS sum_value,
        FIRST_VALUE(CASE WHEN pos = 1 THEN best ELSE average END) OVER (PARTITION BY eventid ORDER BY SUM(CASE WHEN eventid IN ('333bf', '444bf', '555bf') THEN best ELSE average END) ASC) AS first_place_time,
        FIRST_VALUE(CASE WHEN pos = 2 THEN best ELSE average END) OVER (PARTITION BY eventid ORDER BY SUM(CASE WHEN eventid IN ('333bf', '444bf', '555bf') THEN best ELSE average END) ASC) AS second_place_time,
        FIRST_VALUE(CASE WHEN pos = 3 THEN best ELSE average END) OVER (PARTITION BY eventid ORDER BY SUM(CASE WHEN eventid IN ('333bf', '444bf', '555bf') THEN best ELSE average END) ASC) AS third_place_time,
        RANK() OVER (PARTITION BY eventid ORDER BY SUM(CASE WHEN eventid IN ('333bf', '444bf', '555bf') THEN best ELSE average END) ASC) AS "rank"
    FROM Results
    WHERE 
        competitionid IN (SELECT id FROM Competitions WHERE countryid = 'Philippines')
        AND pos < 4
        AND roundtypeid IN ('c', 'f')
        AND eventid NOT IN ('333mbf', '333mbo')
    GROUP BY competitionid, eventid
    HAVING 
        (
            (eventid IN ('333bf', '444bf', '555bf') AND COUNT(CASE WHEN best <= 0 THEN 1 END) = 0) 
            OR COUNT(CASE WHEN average <= 0 THEN 1 END) = 0
        )
        AND COUNT(*) = 3
) a
JOIN Events e ON a.eventid = e.id
WHERE a.rank = 1
ORDER BY e.rank;
