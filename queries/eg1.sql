SELECT id, predict_fraud(
  ARRAY[1,1, 1, 3, 2, 1, 0, 0, 30.2, 1826, 64, 187], 
  (SELECT "imageData" FROM images WHERE id = 'generated_fake_2_99') 
) AS fraud_score
FROM metadata
WHERE id = 'generated_fake_2_99';
