/* This will show the year and count of new WCA IDs since 2015 */

SELECT 
    RIGHT(c.id, 4) AS year,
    COUNT(DISTINCT r.personId) AS new_ids
FROM 
    Results r
JOIN 
    Competitions c ON r.competitionId = c.id
WHERE 
    c.countryId = ':country' AND 
    RIGHT(c.id, 4) >= '2015' AND 
    LEFT(r.personId, 4) = RIGHT(c.id, 4)
GROUP BY 
    RIGHT(c.id, 4)
ORDER BY 
    year ASC;
