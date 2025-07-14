SELECT 
  yd.year,
  yd.delegate_name,
  yd.competitions_delegated
FROM (
  SELECT 
    u.name AS delegate_name,
    YEAR(c.start_date) AS year,
    COUNT(DISTINCT cd.competition_id) AS competitions_delegated
  FROM competition_delegates cd
  JOIN users u ON cd.delegate_id = u.id
  JOIN competitions c ON cd.competition_id = c.id
  WHERE c.start_date IS NOT NULL
    AND c.country_id = 'Philippines'
  GROUP BY u.name, YEAR(c.start_date)
) AS yd
JOIN (
  SELECT 
    year,
    MAX(competitions_delegated) AS max_delegated
  FROM (
    SELECT 
      u.name,
      YEAR(c.start_date) AS year,
      COUNT(DISTINCT cd.competition_id) AS competitions_delegated
    FROM competition_delegates cd
    JOIN users u ON cd.delegate_id = u.id
    JOIN competitions c ON cd.competition_id = c.id
    WHERE c.start_date IS NOT NULL
      AND c.country_id = 'Philippines'
    GROUP BY u.name, YEAR(c.start_date)
  ) AS inner_counts
  GROUP BY year
) AS max_per_year
  ON yd.year = max_per_year.year
  AND yd.competitions_delegated = max_per_year.max_delegated
ORDER BY yd.year;
