SELECT Patient.Name,
    Physician.Name
FROM Appointment
WHERE Appointment.Patient IN(
        SELECT Patient
        FROM Appointment
        WHERE Prepnurse IN (
                SELECT Employeeid
                FROM Nurse
                WHERE Registered = TRUE
            )
        GROUP BY Patient
        HAVING COUNT(*) > 1
    )
    AND Appointment.Prepnurse IN (
        SELECT Employeeid
        FROM Nurse
        WHERE Registered = TRUE
    )
INNER JOIN Patient ON Patient.Ssn = Appointment.Patient
INNER JOIN Physician ON Physician.Emloyeeid = Appointment.Physician