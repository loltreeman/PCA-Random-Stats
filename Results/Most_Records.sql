/* This is cumulative so NR, CR, WR is counted */

SELECT
	personId, 
	personName, 
	SUM(IF(regionalSingleRecord IS NOT NULL,1,0)) + SUM(IF(regionalAverageRecord IS NOT NULL,1,0)) as Records
FROM 
	Results
WHERE 
	((regionalSingleRecord IS NOT NULL) OR (regionalAverageRecord IS NOT NULL)) AND
	countryId = 'Philippines'
GROUP BY 
	personId
ORDER BY 
	3 DESC
