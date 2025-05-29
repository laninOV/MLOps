import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression

mlflow.set_tracking_uri("http://mlflow:5000")
mlflow.set_experiment("iris_experiment")

X, y = load_iris(return_X_y=True)
model = LogisticRegression(max_iter=200)
model.fit(X, y)

with mlflow.start_run() as run:
    mlflow.sklearn.log_model(model, "model")
    print(f"Run ID: {run.info.run_id}")
