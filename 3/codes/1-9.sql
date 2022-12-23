CREATE VIEW answer AS
SELECT Patient.Name, SUM(Procedure.Cost) as Spent
FROM Patient
INNER JOIN Undergoes ON Undergoes.Patient = Patient.Ssn
INNER JOIN Procedure ON Procedure.Code = Undergoes.Procedure
GROUP BY Patient.ID