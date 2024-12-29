-- Just type in your WCA ID and it will show you the competitions, and how many PRs you got at that competition

SELECT
	ROW_NUMBER() OVER (ORDER BY a.start_date, a.id) "comp_number",
	CASE WHEN start_date > CURRENT_DATE() THEN true ELSE false END "upcoming",
	':WCA_ID' AS "personid",
	(SELECT name FROM Persons WHERE wca_id = ':WCA_ID' AND subid = 1) "personname",
	a.name "competition",
	a.countryid,
	a.start_date "date",
	CASE
		WHEN b.personid IS NULL
		THEN NULL
		ELSE COUNT(CASE WHEN b.best = b.pr_single THEN 1 END)+COUNT(CASE WHEN b.average = b.pr_average THEN 1 END)
		END "PRs"
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
GROUP BY a.id
ORDER BY a.start_date DESC

-- Remove the DESC from the line above to sort from first competition to last
