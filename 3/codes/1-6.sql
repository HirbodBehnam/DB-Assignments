SELECT Physician.Name, Procedure.Name
FROM Physician
INNER JOIN Trained_in ON Trained_in.Phyiscian = Physician.Emloyeeid
INNER JOIN Undergoes ON Undergoes.Physician = Physician.Emloyeeid
INNER JOIN Procedure ON Procedure.Code = Undergoes.Procedure
WHERE Trained_in.Treatment != Undergoes.Procedure