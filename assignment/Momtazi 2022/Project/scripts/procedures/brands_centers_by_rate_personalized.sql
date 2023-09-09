CREATE OR REPLACE FUNCTION brands_centers_by_rate_personalized(_token varchar)
RETURNS TABLE (
	brand_name varchar,
	vaccination_center_name varchar,
	score bigint
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
	_username varchar;
BEGIN
	-- Check if username exists
	SELECT username from sessions WHERE token = _token INTO _username;
	IF _username IS NULL THEN RAISE 'Invalid token'; END IF;
RETURN QUERY	
	WITH vaccinations AS (
		SELECT administrations.*, vials.brand_name
		FROM administrations
		INNER JOIN vials
			ON vials.serial_number = administrations.vial_serial_number
		INNER JOIN brands
			ON brands.name = vials.brand_name
		WHERE administrations.administrated_to = _username
	), brand_center AS (
		SELECT vaccinations.brand_name, vaccinations.vaccination_center_name, SUM(vaccinations.score) AS score, ROW_NUMBER() OVER (PARTITION BY vaccinations.brand_name, vaccinations.vaccination_center_name ORDER BY vaccinations.brand_name, SUM(vaccinations.score)) AS r
		FROM vaccinations
		GROUP BY (vaccinations.brand_name, vaccinations.vaccination_center_name)
		ORDER BY vaccinations.brand_name, score
	)
	SELECT brand_center.brand_name, brand_center.vaccination_center_name, brand_center.score
	FROM brand_center
	WHERE brand_center.r <= 3;
END;
$$;