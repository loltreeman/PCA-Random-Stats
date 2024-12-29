-- Type in your WCA ID and it will show you how many podiums you have for each event in total

SELECT
    r.PersonName,
    e.name AS Event,
    COUNT(CASE 
        WHEN r.pos IN (1, 2, 3) THEN 1 
        ELSE NULL 
    END) AS TotalPodiums
FROM Results r
    INNER JOIN Competitions c
        ON r.competitionid = c.id
    INNER JOIN Events e
        ON r.eventid = e.id
WHERE personid = ':WCA_ID'
    AND roundtypeid IN ('c', 'f')
    AND pos <= 3
    AND best > 0
GROUP BY e.name, r.PersonName
ORDER BY e.rank, r.PersonName;
