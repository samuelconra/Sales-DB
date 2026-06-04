-- Source rows for dim_branch: flatten branch -> state -> country.
SELECT
    b.branch_id,
    b.name        AS branch_name,
    b.address,
    s.key         AS state_code,
    s.name        AS state_name,
    c.key         AS country_code,
    c.name        AS country_name
FROM branches b
JOIN states    s ON s.state_id   = b.state_id
JOIN countries c ON c.country_id = s.country_id
ORDER BY b.branch_id;
