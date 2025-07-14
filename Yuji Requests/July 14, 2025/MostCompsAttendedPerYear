SELECT 
  yd.year,
  yd.person_name AS competitor_name,
  yd.competitions_attended
FROM (
  SELECT 
    r.person_name,
    YEAR(c.start_date) AS year,
    COUNT(DISTINCT r.competition_id) AS competitions_attended
  FROM results r
  JOIN competitions c ON r.competition_id = c.id
  WHERE c.start_date IS NOT NULL
    AND r.country_id = 'Philippines'
  GROUP BY r.person_name, YEAR(c.start_date)
) AS yd
JOIN (
  SELECT 
    year,
    MAX(competitions_attended) AS max_competitions
  FROM (
    SELECT 
      YEAR(c.start_date) AS year,
      r.person_name,
      COUNT(DISTINCT r.competition_id) AS competitions_attended
    FROM results r
    JOIN competitions c ON r.competition_id = c.id
    WHERE c.start_date IS NOT NULL
      AND r.country_id = 'Philippines'
    GROUP BY r.person_name, YEAR(c.start_date)
  ) AS inner_counts
  GROUP BY year
) AS max_per_year
  ON yd.year = max_per_year.year
  AND yd.competitions_attended = max_per_year.max_competitions
ORDER BY yd.year;
