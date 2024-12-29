-- Just fill out any WCA ID, and it will show how many PRs you got in each year you've competed

SELECT
    EXTRACT(YEAR FROM a.start_date) AS "calendar_year",
    ':WCA_ID' AS "personid",
    (SELECT name FROM Persons WHERE wca_id = ':WCA_ID' AND subid = 1) AS "personname",
    SUM(
        CASE
            WHEN b.personid IS NULL THEN 0
            ELSE COUNT(CASE WHEN b.best = b.pr_single THEN 1 END) +
                 COUNT(CASE WHEN b.average = b.pr_average THEN 1 END)
        END
    ) OVER (PARTITION BY EXTRACT(YEAR FROM a.start_date)) AS "total_PRs"
FROM Competitions a
    LEFT JOIN (
        SELECT r.*,
            MIN(CASE WHEN r.best > 0 THEN r.best ELSE NULL END) OVER (PARTITION BY r.personid, r.eventid ORDER BY c.start_date, c.id, rt.rank) AS pr_single,
            MIN(CASE WHEN r.average > 0 THEN r.average ELSE NULL END) OVER (PARTITION BY r.personid, r.eventid ORDER BY c.start_date, c.id, rt.rank) AS pr_average
        FROM Results r
            JOIN Competitions c
                ON r.competitionid = c.id
            JOIN RoundTypes rt
                ON r.roundtypeid = rt.id
        WHERE r.personid = ':WCA_ID'
    ) b
    ON a.id = b.competitionid
WHERE a.id IN (SELECT competitionid FROM Results WHERE personid = ':WCA_ID')
    OR a.id IN (
        SELECT r.competition_id
        FROM registrations r
            JOIN Competitions c
                ON r.competition_id = c.id
        WHERE r.user_id = (SELECT id FROM users WHERE wca_id = ':WCA_ID')
            AND (c.start_date > CURRENT_DATE() OR (c.results_posted_at IS NULL AND c.cancelled_at IS NULL))
            AND r.accepted_at IS NOT NULL
            AND r.deleted_at IS NULL
    )
GROUP BY EXTRACT(YEAR FROM a.start_date)
ORDER BY EXTRACT(YEAR FROM a.start_date) DESC;
