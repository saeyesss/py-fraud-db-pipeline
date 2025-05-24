SELECT 
    ethnicity_encoded AS ethnicity,
    
    -- Actual fraud count based on ground truth
    COUNT(CASE WHEN is_fraud = TRUE THEN 1 ELSE NULL END) AS actual_fraud_count,
    
    -- Actual non-fraud count based on ground truth
    COUNT(CASE WHEN is_fraud = FALSE THEN 1 ELSE NULL END) AS actual_non_fraud_count,
    
    -- Predicted fraud count based on the model's prediction
    COUNT(CASE WHEN predict_fraud(
        ARRAY[ fraudpattern, gender_encoded, ethnicity_encoded, class_encoded, 
              hair_color_encoded, eye_color_encoded, is_donor, is_veteran, age, 
              license_validity, height_numeric, weight_numeric],
        (SELECT "imageData" FROM images WHERE id = metadata.id)
    ) >= 0.5 THEN 1 ELSE NULL END) AS predicted_fraud_count,
    
    -- Predicted non-fraud count based on the model's prediction
    COUNT(CASE WHEN predict_fraud(
        ARRAY[ fraudpattern, gender_encoded, ethnicity_encoded, class_encoded, 
              hair_color_encoded, eye_color_encoded, is_donor, is_veteran, age, 
              license_validity, height_numeric, weight_numeric],
        (SELECT "imageData" FROM images WHERE id = metadata.id)
    ) < 0.5 THEN 1 ELSE NULL END) AS predicted_non_fraud_count

FROM metadata
GROUP BY ethnicity_encoded
ORDER BY ethnicity_encoded;
