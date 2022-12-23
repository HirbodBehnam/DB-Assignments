SELECT Name
FROM Patient
WHERE Ssn IN (
        SELECT Patient
        FROM Appointment
        WHERE Prepnurse IN (
                SELECT Employeeid
                FROM Nurse
                WHERE Registered = TRUE
            )
        GROUP BY Patient
        HAVING COUNT (*) > 1
    )