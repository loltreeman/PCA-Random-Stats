-- Query for most PRs for Philippine Cubers in 2024

SELECT
    EXTRACT(YEAR FROM a.start_date) AS "calendar_year",
    b.personid AS "personid",
    (SELECT name FROM Persons WHERE wca_id = b.personid AND subid = 1) AS "personname",
    SUM(
        CASE
            WHEN b.personid IS NULL THEN 0
            ELSE COUNT(CASE WHEN b.best = b.pr_single THEN 1 END) +
                 COUNT(CASE WHEN b.average = b.pr_average THEN 1 END)
        END
    ) OVER (PARTITION BY EXTRACT(YEAR FROM a.start_date), b.personid) AS "total_PRs"
FROM Competitions a
LEFT JOIN (
    SELECT r.*, 
           MIN(CASE WHEN r.best > 0 THEN r.best ELSE NULL END) OVER (PARTITION BY r.personid, r.eventid ORDER BY c.start_date, c.id, rt.rank) AS pr_single,
           MIN(CASE WHEN r.average > 0 THEN r.average ELSE NULL END) OVER (PARTITION BY r.personid, r.eventid ORDER BY c.start_date, c.id, rt.rank) AS pr_average
    FROM Results r
    JOIN Competitions c ON r.competitionid = c.id
    JOIN RoundTypes rt ON r.roundtypeid = rt.id
    WHERE r.countryId = 'Philippines'  -- You can change this to whatever country you want
) b ON a.id = b.competitionid
WHERE (EXTRACT(YEAR FROM a.start_date) = 2024)  -- This is only limited for year 2024
   AND (a.id IN (SELECT competitionid FROM Results)
        OR a.id IN (
            SELECT r.competition_id
            FROM registrations r
            JOIN Competitions c ON r.competition_id = c.id
            WHERE (c.start_date > CURRENT_DATE() OR (c.results_posted_at IS NULL AND c.cancelled_at IS NULL))
              AND r.accepted_at IS NOT NULL
              AND r.deleted_at IS NULL
        )
   )
GROUP BY EXTRACT(YEAR FROM a.start_date), b.personid
ORDER BY total_PRs DESC;
