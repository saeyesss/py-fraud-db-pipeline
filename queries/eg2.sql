SELECT m.id, m.age, m.height_numeric, m.fraudpattern, i."imageData"
FROM metadata m
JOIN images i ON m.id = i.id
WHERE m.age > 50 AND m.weight_numeric > 80
ORDER BY m.age DESC
LIMIT 10;
