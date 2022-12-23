CREATE VIEW answer AS
SELECT Patient.Name, COUNT(*) AS Appointment_Count
FROM Patient
INNER JOIN Appointment ON Appointment.Patient = Patient.Ssn
HAVING Appointment_Count > 0