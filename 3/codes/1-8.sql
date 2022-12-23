SELECT BlockFloor, BlockCode
FROM OnCall
GROUP BY BlockFloor, BlockCode
HAVING COUNT(DISTINCT Nurse) = 2
