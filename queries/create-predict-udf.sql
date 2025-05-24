CREATE OR REPLACE FUNCTION predict_fraud(metadata_arr float8[], base64_img text)
RETURNS float8
AS $$
import torch
import sys
import joblib
sys.path.append('D:\\school\\asu\\courses\\cse598-data-intensive-systems-for-machine-learning\\workspace-598\\course-project\\code\\scripts')
from infer import load_model_and_scaler, predict_fraud

if 'model' not in SD:
    model_path = 'D:\\school\\asu\\courses\\cse598-data-intensive-systems-for-machine-learning\\workspace-598\\course-project\\code\\submit\\model\\model_weights.pt'
    scaler_path = 'D:\\school\\asu\\courses\\cse598-data-intensive-systems-for-machine-learning\\workspace-598\\course-project\\code\\submit\\model\\scaler.pkl'
    model, scaler = load_model_and_scaler(model_path, scaler_path)
    SD['model'] = model
    SD['scaler'] = scaler

model = SD['model']
scaler = SD['scaler']

score = predict_fraud(metadata_arr, base64_img, model, scaler)
return score
$$ LANGUAGE plpython3u;