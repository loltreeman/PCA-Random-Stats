SELECT 
  r.person_name AS competitor_name,
  YEAR(c.start_date) AS year,
  COUNT(DISTINCT r.competition_id) AS competitions_attended
FROM results r
JOIN competitions c ON r.competition_id = c.id
WHERE c.start_date IS NOT NULL
  AND r.country_id = 'Philippines'
GROUP BY r.person_name, YEAR(c.start_date)
ORDER BY r.person_name, year;
