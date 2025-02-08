/* NRs broken per year, per event, single and average */

SELECT 
    YEAR(c.end_date) AS year,
    t.eventId,
    t.singleOrAverage,
    COUNT(t.personId) AS NRs
FROM (
    SELECT 
        r.personId,
        r.eventId,
        'Single' AS singleOrAverage,
        r.competitionId
    FROM RanksSingle rs
    JOIN Results r ON rs.personId = r.personId AND rs.eventId = r.eventId
    JOIN Persons p ON r.personId = p.wca_id
    WHERE 
        rs.countryRank = 1 
        AND rs.eventId NOT IN ('magic', 'mmagic', '333ft', '333mbo')
        AND p.countryId = ':country'  
    
    UNION ALL
    
    SELECT 
        r.personId,
        r.eventId,
        'Average' AS singleOrAverage,
        r.competitionId
    FROM RanksAverage ra
    JOIN Results r ON ra.personId = r.personId AND ra.eventId = r.eventId
    JOIN Persons p ON r.personId = p.wca_id
    WHERE 
        ra.countryRank = 1 
        AND ra.eventId NOT IN ('magic', 'mmagic', '333ft', '333mbo')
        AND p.countryId = ':country'  
) t
JOIN Competitions c ON t.competitionId = c.id
WHERE 
    c.end_date BETWEEN '2007-01-01' AND CURDATE()
GROUP BY 
    YEAR(c.end_date), t.eventId, t.singleOrAverage
ORDER BY 
    year, t.eventId, t.singleOrAverage;
