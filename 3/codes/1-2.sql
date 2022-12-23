-- This one works in sql server
SELECT TOP 1 Name, Cost FROM Procedure ORDER BY Cost
-- This one works in postgres
SELECT Name, Cost FROM Procedure WHERE Cost = (SELECT Min(Cost) FROM Procedure)
