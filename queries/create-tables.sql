CREATE TABLE metadata (
    id SERIAL PRIMARY KEY,
    is_fraud BOOLEAN NOT NULL,
    fraudpattern TEXT,
    gender_encoded INTEGER,
    ethnicity_encoded INTEGER,
    class_encoded INTEGER,
    hair_color_encoded INTEGER,
    eye_color_encoded INTEGER,
    is_donor BOOLEAN,
    is_veteran BOOLEAN,
    age FLOAT,
    license_validity FLOAT,
    height_numeric FLOAT,
    weight_numeric FLOAT);

CREATE TABLE images (id SERIAL PRIMARY KEY,imagedata TEXT NOT NULL);