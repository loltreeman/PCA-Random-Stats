-- Average average of all 3x3 finalists per year in competitors in Philippines split into the competitions for that year, in comps where 3x3 was held more than 1 round

SELECT year, competitionId, AVG(avg_of_mean) AS avg_avg_mean
FROM (
    SELECT YEAR(c.end_date) AS year, r.competitionId, AVG(r.average) / 100 AS avg_of_mean
    FROM Results r
    JOIN Competitions c ON r.competitionId = c.id
    WHERE r.eventId = "333"
      AND r.roundTypeId IN ("c", "f")
      AND r.average > 0
      AND c.countryId = "Philippines"  
      AND r.competitionId IN (
          SELECT competitionId
          FROM Results
          WHERE eventId = "333"
          GROUP BY competitionId
          HAVING COUNT(DISTINCT roundTypeId) > 1
      )
    GROUP BY r.competitionId, YEAR(c.end_date)
) AS subquery
GROUP BY year, competitionId
ORDER BY year, competitionId;

-- Average average of all 3x3 finalists per year in competitors in Philippines, in comps where 3x3 was held more than 1 round
SELECT year, AVG(avg_of_mean) AS avg_avg_mean
FROM (
    SELECT YEAR(c.end_date) AS year, AVG(r.average) / 100 AS avg_of_mean
    FROM Results r
    JOIN Competitions c ON r.competitionId = c.id
    WHERE r.eventId = "333"
      AND r.roundTypeId IN ("c", "f")
      AND r.average > 0
      AND c.countryId = "Philippines"
      AND r.competitionId IN (
          SELECT competitionId
          FROM Results
          WHERE eventId = "333"
          GROUP BY competitionId
          HAVING COUNT(DISTINCT roundTypeId) > 1
      )
    GROUP BY YEAR(c.end_date)
) AS subquery
GROUP BY year
ORDER BY year;
