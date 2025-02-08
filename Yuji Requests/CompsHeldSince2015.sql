/* includes announced competitions so that's why there are 13 competitions in 2025 for Philippines as of the time of making this */

SELECT 
    YEAR(c.end_date) AS year, 
    COUNT(*) AS numComps
FROM Competitions c
WHERE 
    c.countryId = ':country'
    AND c.end_date >= '2015-01-01'
GROUP BY 
    YEAR(c.end_date)
ORDER BY 
    year;
