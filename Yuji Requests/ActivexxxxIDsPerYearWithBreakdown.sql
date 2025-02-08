/* I included those WCA IDs from other countries that competed in a specific country */

SELECT 
    comp_year AS competition_year, 
    id_year AS issued_year, 
    COUNT(DISTINCT personId) AS active_ids
FROM (
    SELECT 
        RIGHT(c.id, 4) AS comp_year, 
        LEFT(r.personId, 4) AS id_year, 
        r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        c.countryId = ':country'
) AS subquery
GROUP BY 
    comp_year, id_year
ORDER BY 
    competition_year ASC, issued_year ASC;
