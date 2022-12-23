SELECT Room.Number
FROM Stay
INNER JOIN Room ON Room.Number = Stay.Room
WHERE Room.Type = 'double' AND Stay.End IS NULL
GROUP BY Room.Number
HAVING COUNT(*) = 1