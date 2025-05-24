import torch
import torch.nn as nn
import torchvision.models as models
import joblib
import io
import base64
from PIL import Image

class CNNModel(nn.Module):
    def __init__(self, metadata_dim, dropout=0.5):
        super().__init__()
        # EfficientNet backbone
        self.image_backbone = models.efficientnet_b3(weights='DEFAULT')

        # get no of features from backbone
        num_backbone_features = self.image_backbone.classifier[1].in_features
        # replace the original classifier to get raw features
        self.image_backbone.classifier = nn.Identity()

        # metadata processing
        self.metadata_subnet = nn.Sequential(
            nn.Linear(metadata_dim, 128),
            nn.BatchNorm1d(128),
            nn.ReLU(),
            nn.Dropout(dropout)
        )

        # classificateion head
        self.classifier = nn.Sequential(
            nn.Linear(num_backbone_features + 128, 256),
            nn.BatchNorm1d(256),
            nn.ReLU(),
            nn.Dropout(dropout),
            nn.Linear(256, 1),
            nn.Sigmoid()
        )

    def forward(self, metadata, image):
        image_features = self.image_backbone(image) # batch_size, x no_backbone_features
        metadata_features = self.metadata_subnet(metadata) # batch_size x 128
        combined = torch.cat([image_features, metadata_features], dim=1) # concatenate both streams
        return self.classifier(combined) # do classification
    
def base64_to_tensor(base64_str):
    image_bytes = base64.b64decode(base64_str)
    image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    transform = models.EfficientNet_B3_Weights.DEFAULT.transforms()
    return transform(image).unsqueeze(0)

def load_model_and_scaler(model_path, scaler_path):
    checkpoint = torch.load(model_path, map_location=torch.device('cpu'))
    model = CNNModel(metadata_dim=checkpoint['input_metadata_size'])
    model.load_state_dict(checkpoint['model_state_dict'])
    model.eval()    
    scaler = joblib.load(scaler_path)
    return model, scaler

def predict_fraud(metadata_arr, base64_img, model, scaler):

    scaled_metadata = scaler.transform([metadata_arr])
    metadata_tensor = torch.tensor(scaled_metadata, dtype=torch.float32)
    image_tensor = base64_to_tensor(base64_img)
    with torch.no_grad():
        output = model(metadata_tensor, image_tensor)
    return float(output.item()) # our score 
