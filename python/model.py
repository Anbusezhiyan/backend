# train_delay_model.py
import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error

# Load dataset
df = pd.read_csv("vessel_delay_data.csv")

FEATURES = [
    "speed_knots",
    "cargo_tons",
    "weather_index",
    "port_congestion"
]

X = df[FEATURES]
y = df["delay_hours"]

# Train / test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train model
model = RandomForestRegressor(
    n_estimators=300,
    max_depth=10,
    random_state=42
)
model.fit(X_train, y_train)

# Evaluate
preds = model.predict(X_test)
mae = mean_absolute_error(y_test, preds)
print(f"MAE: {mae:.2f} hours")

# Save model
joblib.dump(model, "delay_model.pkl")
print("Model saved as delay_model.pkl")
