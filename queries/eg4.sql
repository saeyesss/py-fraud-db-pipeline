SELECT 
    fraudpattern, 
    AVG(predict_fraud(
            ARRAY[fraudpattern, gender_encoded, ethnicity_encoded, class_encoded, 
                  hair_color_encoded, eye_color_encoded, is_donor, is_veteran, age, 
                  license_validity, height_numeric, weight_numeric],
            (SELECT "imageData" FROM images WHERE id = metadata.id)
        )) AS avg_fraud_score
FROM metadata
GROUP BY fraudpattern
HAVING COUNT(*) > 10
ORDER BY avg_fraud_score DESC;
