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


-- If you want the Gold, Silver, Bronze breakdown

SELECT
    r.PersonName,
    e.name AS Event,
    COUNT(CASE WHEN r.pos = 1 THEN 1 ELSE NULL END) AS Gold,
    COUNT(CASE WHEN r.pos = 2 THEN 1 ELSE NULL END) AS Silver,
    COUNT(CASE WHEN r.pos = 3 THEN 1 ELSE NULL END) AS Bronze
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
