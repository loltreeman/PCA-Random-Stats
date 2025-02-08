/* Number of rounds held per event in country, year; you can input any country */

SELECT 
    RIGHT(c.id, 4) AS Year,
    r.eventId AS Event, 
    COUNT(DISTINCT r.roundTypeId) AS RoundsHeld
FROM 
    Results r
JOIN 
    Competitions c ON r.competitionId = c.id
WHERE 
    c.countryId = ":country"
GROUP BY 
    RIGHT(c.id, 4), r.eventId
ORDER BY 
    Year ASC, Event ASC;
