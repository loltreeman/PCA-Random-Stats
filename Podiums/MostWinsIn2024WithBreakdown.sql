SELECT 
    personName, 
    SUM(IF(pos = 1, 1, 0)) AS golds, 
    SUM(IF(pos = 2, 1, 0)) AS silvers, 
    SUM(IF(pos = 3, 1, 0)) AS bronzes, 
    COUNT(*) AS total
FROM Results r
JOIN Competitions c ON r.competitionId = c.id
WHERE 
    r.countryId = 'Philippines' 
    AND r.roundTypeId IN ('c', 'f') 
    AND r.best > 0 
    AND r.pos <= 3 
    AND EXTRACT(YEAR FROM c.start_date) = 2024
GROUP BY personName
ORDER BY golds DESC
