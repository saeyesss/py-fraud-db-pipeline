SELECT 
    age, 
    height_numeric, 
    predict_fraud(
        ARRAY[fraudpattern, gender_encoded, ethnicity_encoded, class_encoded, 
              hair_color_encoded, eye_color_encoded, is_donor, is_veteran, age, 
              license_validity, height_numeric, weight_numeric],
        (SELECT "imageData" FROM images WHERE id = metadata.id)
    ) AS fraud_score
FROM metadata
WHERE age IS NOT NULL AND height_numeric IS NOT NULL
ORDER BY fraud_score DESC;
