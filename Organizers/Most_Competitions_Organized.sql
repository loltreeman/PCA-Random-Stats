SELECT 
    u.name AS "Organizer",
    u.wca_id AS "WCA ID",
    COUNT(c.id) AS "Competitions Organized",
    MIN(c.start_date) AS "First Organized",
    GROUP_CONCAT(c.name ORDER BY c.start_date SEPARATOR '; ') AS "Competition Names",
    GROUP_CONCAT(DISTINCT CONCAT(c.cityName, ', ', c.countryid) ORDER BY c.start_date SEPARATOR '; ') AS "Locations"
FROM 
    competition_organizers co
JOIN 
    users u ON u.id = co.organizer_id
JOIN 
    Competitions c ON c.id = co.competition_id
WHERE 
    c.countryid = 'Philippines'
GROUP BY 
    u.id, u.name, u.wca_id
ORDER BY 
    COUNT(c.id) DESC;
