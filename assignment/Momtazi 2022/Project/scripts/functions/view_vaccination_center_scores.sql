CREATE OR REPLACE FUNCTION view_vaccination_center_scores(page int)
RETURNS TABLE (
	vaccination_center varchar,
	score text
)
LANGUAGE 'plpgsql'
AS $$
#variable_conflict use_column
BEGIN

	RETURN QUERY
		(
			SELECT vaccination_center_name AS vaccination_center, ROUND(AVG(score), 1)::text AS score
			FROM administrations
			WHERE score IS NOT NULL
			GROUP BY vaccination_center_name
			ORDER BY score DESC
		)
		UNION ALL
		(
			SELECT name, 'No Score'
			FROM vaccination_centers
			WHERE name NOT IN (SELECT vaccination_center_name FROM administrations)
		)
		UNION ALL
		(
			SELECT vaccination_center_name AS vaccination_center, 'No Score'
			FROM administrations
			WHERE score IS NULL
			GROUP BY vaccination_center_name
		)
		LIMIT 5 OFFSET (0);
END;
$$;