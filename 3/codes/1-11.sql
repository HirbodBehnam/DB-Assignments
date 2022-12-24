SELECT Blockfloor, Blockcode, string_agg(Nurse, ', ') AS nurses
FROM On_call
GROUP BY Blockfloor, Blockcode
UNION
SELECT Blockfloor, Blockcode, '' AS nurses
FROM Block
WHERE (Blockfloor, Blockcode) NOT IN (
        SELECT Blockfloor, Blockcod FROM On_call
    )