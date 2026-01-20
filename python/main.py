from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any
import pandas as pd
import numpy as np
import joblib
import os

app = FastAPI(title="AI Logistics Optimization API")


# ==============================
# Helpers
# ==============================

def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )
    return df


# ==============================
# Load AI Model
# ==============================

MODEL_PATH = "delay_model.pkl"
if not os.path.exists(MODEL_PATH):
    raise RuntimeError("delay_model.pkl not found. Train the model first.")

delay_model = joblib.load(MODEL_PATH)


# ==============================
# Load & Normalize CSVs
# ==============================

ports_df = normalize_columns(pd.read_csv("ports_data.csv"))
plants_df = normalize_columns(pd.read_csv("plants_data.csv"))
costs_df = normalize_columns(pd.read_csv("costs_data.csv"))

# Build TOTAL COST from components
REQUIRED_COST_COLS = {"route_id", "port_fee", "handling_fee", "fuel_cost"}
if not REQUIRED_COST_COLS.issubset(costs_df.columns):
    raise RuntimeError(
        f"costs_data.csv must contain {REQUIRED_COST_COLS}, "
        f"found {set(costs_df.columns)}"
    )

costs_df["total_cost"] = (
    costs_df["port_fee"]
    + costs_df["handling_fee"]
    + costs_df["fuel_cost"]
)


# ==============================
# Schemas
# ==============================

class PredictDelayRequest(BaseModel):
    vessel_id: int
    speed_knots: float
    cargo_tons: float
    weather_index: float
    port_congestion: float


class OptimizationRequest(BaseModel):
    vessels: List[Dict[str, Any]]


# ==============================
# AI Prediction Endpoint
# ==============================

@app.post("/predict-delay")
def predict_delay(request: PredictDelayRequest):
    try:
        X = np.array([[
            request.speed_knots,
            request.cargo_tons,
            request.weather_index,
            request.port_congestion
        ]])

        delay = float(delay_model.predict(X)[0])

        return {
            "vessel_id": request.vessel_id,
            "predicted_delay_hours": round(delay, 2)
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ==============================
# Optimization Endpoint
# ==============================

@app.post("/run-optimization")
def run_optimization(request: OptimizationRequest):
    """
    Optimization logic:
    - Each vessel selects the cheapest available route
    - Routes are mapped to ports & plants by route_id
    """

    schedule = []
    total_cost = 0.0

    for vessel in request.vessels:
        vessel_id = vessel.get("id")
        route_id = vessel.get("route_id")

        if route_id is None:
            continue

        route_cost = costs_df[costs_df["route_id"] == route_id]
        if route_cost.empty:
            continue

        best = route_cost.iloc[0]

        port = ports_df[ports_df["route_id"] == route_id].iloc[0]
        plant = plants_df[plants_df["route_id"] == route_id].iloc[0]

        schedule.append({
            "vessel_id": vessel_id,
            "route_id": route_id,
            "port_id": int(port["id"]),
            "port_name": port.get("name", ""),
            "plant_id": int(plant["id"]),
            "plant_name": plant.get("name", ""),
            "total_cost": float(best["total_cost"])
        })

        total_cost += float(best["total_cost"])

    return {
        "optimal_schedule": schedule,
        "total_cost": round(total_cost, 2),
        "status": "success"
    }


# ==============================
# Run Server
# ==============================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
