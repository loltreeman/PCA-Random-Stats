WITH ConsistentResults AS (
  SELECT
    competitionId AS Competition,
    personId AS WCAID,
    personName AS Name,
    value1 AS solve1,
    value2 AS solve2,
    value3 AS solve3,
    value4 AS solve4,
    value5 AS solve5,
    average,
    best,
    CASE 
      WHEN (value1 >= value2 AND value1 >= value3 AND value1 >= value4 AND value1 >= value5)
           OR value1 < 0 THEN
           SQRT(
             ( POW(value2 - average, 2)
             + POW(value3 - average, 2)
             + POW(value4 - average, 2)
             + POW(value5 - average, 2)
             - POW(best - average, 2) ) / 3
           )
      WHEN (value2 >= value1 AND value2 >= value3 AND value2 >= value4 AND value2 >= value5)
           OR value2 < 0 THEN
           SQRT(
             ( POW(value1 - average, 2)
             + POW(value3 - average, 2)
             + POW(value4 - average, 2)
             + POW(value5 - average, 2)
             - POW(best - average, 2) ) / 3
           )
      WHEN (value3 >= value1 AND value3 >= value2 AND value3 >= value4 AND value3 >= value5)
           OR value3 < 0 THEN
           SQRT(
             ( POW(value1 - average, 2)
             + POW(value2 - average, 2)
             + POW(value4 - average, 2)
             + POW(value5 - average, 2)
             - POW(best - average, 2) ) / 3
           )
      WHEN (value4 >= value1 AND value4 >= value2 AND value4 >= value3 AND value4 >= value5)
           OR value4 < 0 THEN
           SQRT(
             ( POW(value1 - average, 2)
             + POW(value2 - average, 2)
             + POW(value3 - average, 2)
             + POW(value5 - average, 2)
             - POW(best - average, 2) ) / 3
           )
      WHEN (value5 >= value1 AND value5 >= value2 AND value5 >= value3 AND value5 >= value4)
           OR value5 < 0 THEN
           SQRT(
             ( POW(value1 - average, 2)
             + POW(value2 - average, 2)
             + POW(value3 - average, 2)
             + POW(value4 - average, 2)
             - POW(best - average, 2) ) / 3
           )
      ELSE NULL
    END AS std
  FROM Results
  WHERE eventId = '333'
    AND average > 0
    AND countryId = 'Philippines'
)
SELECT 
  Competition,
  WCAID,
  Name,
  solve1,
  solve2,
  solve3,
  solve4,
  solve5,
  average,
  std
FROM ConsistentResults
ORDER BY std DESC;
