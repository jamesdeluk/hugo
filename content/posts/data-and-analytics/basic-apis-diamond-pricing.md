---
title: "Basic APIs: Diamond Pricing with FastAPI, Docker, GitHub Actions, and Azure"
date: 2025-03-06
tags: ['Data Science', 'Regression', 'Random Forest', 'APIs', 'Docker', 'FastAPI', 'Azure', 'Cloud', 'Python']
hero: /images/posts/data-and-analytics/basic-apis-diamond-pricing/edgar-soto-gb0BZGae1Nk-unsplash.jpg
---
*This has been a long time coming! [Basic APIs part one](https://www.jamesgibbins.com/basic-apis-sentiment-analysis/) was posted back in January; since then I’ve started a new job and have had some contract/freelance work, so I didn’t get around to completing this. Also, since then, I’ve moved from Windows to Mac, and started using uv instead of pyenv/pip, so things may look a little different.*

The repo for this project can be found here: [https://github.com/jamesdeluk/data-projects/tree/main/basic-apis/diamond-price](https://github.com/jamesdeluk/data-projects/tree/main/basic-apis/diamond-price)

## The goal

Send (POST) to an online API with diamond criteria, and get a predicted price as a response.

Additionally, ensure that every time the code is updated, the online API is also updated.

## Step 1: Build the ML model

First I need a script that can take the input - the diamond criteria - and predict the price of the diamond. I used a simple random forest regressor model, trained on a dataset from [Kaggle](https://www.kaggle.com/datasets/amirhosseinmirzaie/diamonds-price-dataset).

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor

# Import data
data = pd.read_csv('diamonds.csv')

# Map categorical values to ordinal numerical vallues
data['cut'] = data['cut'].map({'Ideal':1, 'Premium':2, 'Good':3, 'Very Good':4, 'Fair':5})
data['color'] = data['color'].map({'D':1, 'E':2, 'F':3, 'G':4, 'H':5, 'I':6, 'J':7})
data['clarity'] = data['clarity'].map({'I1':1, 'SI2':2, 'SI1':3, 'VS2':4, 'VS1':5, 'VVS2':6, 'VVS1':7, 'IF':8})

# Define features, target, and split
y = data['price']
X = data.drop(['price','depth','table'], axis=1)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create model
model = RandomForestRegressor(random_state=42)
model.fit(X_train, y_train)
```

### Evaluating

A quick check to see how good it is:

```python
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

y_pred = rf.predict(X_test)

mae = mean_absolute_error(y_test, y_pred)
rmse = np.sqrt(mean_squared_error(y_test, y_pred))
r2 = r2_score(y_test, y_pred)
```

MAE is £269.30, RMSE is £536.73, and R² is 0.98. Good enough for this little project, given the prices in the dataset range from £326 to £18,823. (Okay, the dataset is probably in $, but I’m British so I’m going to pretend it’s not).

### Testing

How about predicting a single diamond? I can use an input with or without feature names, and it both gives the same result (as long as the unlabelled features are in the correct order, of course):

```python
single = pd.DataFrame([{'carat':1,
                        'cut':3,
                        'color':3,
                        'clarity':3,
                        'x':3,
                        'y':3,
                        'z':3}])
# or single = [[1,3,3,3,3,3,3]]
print(rf.predict(single)[0])
```

This diamond would be £4449.79.

### Exporting

I need to save this model, to be used by the app. I used pickle, and saved it as `diamonds_rf_model.pkl`:

```python
import pickle

with open('diamonds_rf_model.pkl','wb') as f:
    pickle.dump(model, f)
```

I moved this into a new folder, `model`, to keep the project a bit cleaner.

## Step 2: Write the model inference script

I’ll also need a simple `.py` script to interact with the model:

```python
from pathlib import Path
import pickle

BASE_DIR = Path(__file__).resolve(strict=True).parent
MODEL_NAME = "diamonds_rf_model.pkl"

with open(f"{BASE_DIR}/{MODEL_NAME}", "rb") as f:
    model = pickle.load(f)

def predict(d):
    return model.predict(d)[0]
```

The `BASE_DIR` is needed to ensure the FastAPI app finds the model.

This script can be tested by adding a main guard:

```python
if __name__ == '__main__':
    details = [[1,3,3,3,3,3,3]]
    price_prediction = predict(details)
    print(f"Prediction: £{price_prediction}")
```

Now, when running the script, I get `Prediction: £4449.79`, proving it works. This main guard can be removed for the final app. Save the script as `model_inference.py`, in the same folder as the model (i.e. in `model`).

## Step 3: Make the FastAPI app

In the previous project I used Flask; it’s simple and does the job. However, FastAPI is better for production apps.

```python
from fastapi import FastAPI
from pydantic import BaseModel

from model.model_inference import predict

app = FastAPI()

class PredictPayload(BaseModel):
    carat: float
    cut: int
    color: int
    clarity: int
    x: float
    y: float
    z: float

@app.get("/")
def home():
    return {"health_check": "OK"}

@app.post("/predict")
def predict_price(payload: PredictPayload):
    criteria = [[
        payload.carat,
        payload.cut,
        payload.color,
        payload.clarity,
        payload.x,
        payload.y,
        payload.z,
    ]]
    price = predict(criteria)
    return {"input": payload, "price": price}
```

Import FastAPI, Pydantic, and our model inference script (note the script is in the `model` folder, hence `model.model_inference`). `app = FastAPI()` initiates the app (calling it `app` is the convention, although not mandatory). The `PredictPayload(BaseModel)` class defines and validates the input out model is expecting; instead of using Pydantic. `@app.get("/")` is not needed for the application, but it enables a simple health check (otherwise I’d get `{"detail":"Not Found"}`). Finally, the `@app.post("/predict")` provides the core functionality; it takes the payload, assigns it to the `criteria` variable, passes it to the `predict()` method (from the `model_inference` script), then returns both the input and the predicted price. Returning the input isn’t necessary, but it’s good practise.

Save this as `main.py`, which is the convention for FastAPI apps (although not mandatory).

### Testing

The app can be run from the command line. Change to the directory the file is in, then run:

```bash
uvicorn main:app --reload
```

`main` refers to `main.py`, and `app` refers to the `app = FastAPI()`. `--reload` ensures the app auto-reloads after the files are modified.

As an aside, I’m now using uv instead of pip/pyenv, so I had to run `uv run` before the above command.

My terminal showed:

```
INFO:     Will watch for changes in these directories: ['/[..]/app']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [56232] using StatReload
INFO:     Started server process [56234]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

By default, it uses port 8000. Going to the URL in a web browser gives the `{"health_check":"OK"}`, as hoped.

Now to make a request. I used Python’s `requests` library for this:

```python
import requests

url = "http://127.0.0.1:8000/predict"
data = {
    "carat":1,
    "cut":3,
    "color":3,
    "clarity":3,
    "x":3,
    "y":3,
    "z":3
}

response = requests.post(url, json=data)

if response.status_code == 200:
    print(response.json())
else:
    print("Error:", response.status_code, response.text)
```

POST the data as JSON to the URL, and check the response.

```json
{'input': {'carat': 1.0, 'cut': 3, 'color': 3, 'clarity': 3, 'x': 3.0, 'y': 3.0, 'z': 3.0}, 'price': 4449.79}
```

The same price as we got before - seems like it’s working.

## Step 3: Preparing for containerisation with Docker

Docker will package the app and it’s dependencies (e.g. Python, FastAPI, the pickled model) into a portable container so it runs consistently across different platforms and environments, such as Azure. Instead of doing it manually, like I did in the other project, this time I’ll use GitHub Actions to automate the process.

First, create the requirements file. Given this app is so simple, it’s easy to do manually. `requirements.txt` contains the Python packages used, and is saved in the same location as `main.py`

```
uvicorn
gunicorn
fastapi
pydantic
scikit-learn
```

Next, create the `Dockerfile` (no file extension):

```docker
FROM python:3.13.2-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
```

The first line tells it to use Python 3.13.2, the latest stable version available at the time of writing. `slim` is a minimal version of Python that takes up less space, and is fine for this simple app. The second line sets the working directory - where I’ll be copying files to - to be a folder call `app`, in the root of the container’s filesystem. The third and fourth line copy and install the requirements. The fifth line copies the other files - `main.py`, and the `model` folder including the model inference script and the pickled model - itself to this directory. The final line tells Docker how to run the app when it’s initialised; similar to running on our system, it’s equivalent to `uvicorn main:app --host 0.0.0.0 --port 80`. Instead of using the default port 8000, we’re using 80, which will simplify the online hosting. Similarly, defining host 0.0.0.0 ensures the app is accessible from any IP, which is required when hosting online.

This file is saved in the same directory as `main.py` and `requirements.txt`.

### Testing

Although I’m going to use GitHub actions, I can build and test locally:

```bash
docker build -t diamond-price-fastapi .
```

I’m calling (”tagging”) this app `diamond-price-fastapi`. As I won’t be hosting this image online, I don’t need my username as a prefix, as I did in part one. The `.` tells Docker where to find the `Dockerfile`, which is same directory as the terminal from where I run the command. It will do some stuff, taking a few seconds, and requiring internet access. Once it’s done, I’ll see it in Docker Desktop under Images, and I’ll see it when I run `docker images`. To explore it, I can run:

```bash
docker run -it diamond-price-fastapi sh
```

`it` stands for (kinda) interactive terminal, and `sh` is bash (the terminal). I now see a `#` prompt. `pwd` will show me the working directory - `/app`, as I set in the `Dockerfile` - and `ls` shows me the folder contents: `main.py`, `requirements.txt`, and the `model` folder. `exit` to escape.

I can run the container with:

```powershell
docker run -p 80:80 diamond-price-fastapi
```

The terminal shows the now-recognisable:

```powershell
INFO:     Started server process [1]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:80 (Press CTRL+C to quit)
```

And I can request as before (either to `0.0.0.0`, or `127.0.0.1`), and see the health check. Again, in this case, the `:80` is not required.

If I want it running on a different port, such as 8000, I can do `-p 8000:80` and make the request to `:8000`.

Additionally, I can view some auto-generated documentation about the app, such as the available endpoints and schemas, using the Swagger UI at http://127.0.0.1/docs, or ReDoc at http://127.0.0.1/redoc.

Stop running that with Ctrl-C, then remove the container and image. This is easiest done with:

```bash
docker container prune
docker image rm diamond-price-fastapi
```

Note `prune` removes all stopped containers, for all images, so use with care.

## Step 4: Adding GitHub Actions

As stated in the goal statement at the top of this post, if I update the app, I’d want it to update automatically, without me having to manually re-build and re-push to Docker (as I’d have to with the Flask sentiment analysis app). The best way to do this is to push any code updates to GitHub, and for GitHub to automatically rebuild the Docker image and deploy it to the hosting platform.

I’ve already initiated a Git repo for this project. The pickled model is over GitHub’s limit of 100MB, too big for “normal” GitHub, so I’ll have to use Git Large File Storage. After installing `git-lfs`, track the model:

```bash
git lfs track "[..]/app/model/diamonds_rf_model.pkl"
```

This creates a `.gitattributes` file, which will need to be committed and pushed along with the pickled model. Note Git LFS’s free tier has usage limits, so use with care.

Now create the GitHub Actions file. Create a YAML (I called mine `deploy_diamond_price_api.yml`) within `.github/workflows` in the root of the repo folder (i.e. the same level as the `.git`).

```yaml
name: Deploy diamond price API

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository (with Git LFS)
        uses: actions/checkout@v3
        with:
          lfs: true

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v2
        with:
          context: basic_apis/diamond-price/fastapi-app
          push: true
          platforms: linux/amd64,linux/arm64
          tags: jamesdeluk/diamond-price-fastapi:latest

```

The `name`s do a decent job of explaining the different parts of the code. Given I’m using large file storage, I need to ensure `with: lfs: true` is included. The `context` must be the directory of the code - `.` is fine if it is in the root of the repo (i.e. the same as the `git` folder), otherwise change it the code location (my repo root is `data-projects`, so I had to add `basic_apis/diamond-price/fastapi-app` to get to folder including the app).

GitHub will need access to my Docker account, hence the `secrets` referred to above. These are added to the GitHub repo, at Settings → Secrets and variables → Actions → Repository secrets (or, directly, a URL like this: [https://github.com/jamesdeluk/data-projects/settings/secrets/actions](https://github.com/jamesdeluk/data-projects/settings/secrets/actions). Add `DOCKER_USERNAME` and `DOCKER_PASSWORD`.

Once it’s all pushed, I can check the status of the deploy in the Actions tab of the repo (e.g. [https://github.com/jamesdeluk/data-projects/actions](https://github.com/jamesdeluk/data-projects/actions)). If all works correctly, the container will automatically be built and uploaded to Docker Hub (mine is at https://hub.docker.com/u/jamesdeluk). To test it locally:

```bash
docker pull jamesdeluk/diamond-price-fastapi
docker run -p 80:80 jamesdeluk/diamond-price-fastapi
```

And it should work as before.

Now, any time I push an update to GitHub, such as an improved model, the Docker Hub image will automatically be updated too.

## ~~Step 5: Upload to AWS~~

~~This would be the same as the previous project, so I won’t repeat it here.~~

## Step 5: Upload to Azure

Change of plan - let’s go for Azure instead of AWS this time! I’ll also do it all through the Azure CLI, instead of the web browser-based GUI I used for AWS. Also, I’ll use GitHub Actions to ensure the hosted version is automatically kept up-to-date.

The Azure CLI tools needed to be installed:

```bash
brew install azure-cli
```

Then I had to log in:

```bash
az login
```

I created a new resource group for this project (alternatively, use a pre-existing one you have):

```bash
az group create --name rg-dp-api --location uksouth
```

I also needed to add `Microsoft.Web` to my subscription.

```bash
az provider register --namespace Microsoft.Web
```

To check this is successful, I can run:

```bash
az provider list --query "[?namespace=='Microsoft.Web']" --output tabl
```

And I should get:

```bash
Namespace      RegistrationState    RegistrationPolicy
-------------  -------------------  --------------------
Microsoft.Web  Registered           RegistrationRequired
```

Next, create the app service. `F1` is the free tier. Ensure it’s `--is-linux`, as required for the Docker container:

```bash
az appservice plan create --name asp-dp-api --resource-group rg-dp-api --sku F1 --is-linux
```

Next, the webapp itself:

```bash
az webapp create --resource-group rg-dp-api --plan asp-dp-api --name diamond-price-api --container-image-name jamesdeluk/diamond-price-fastapi:latest
```

After this completes, it will print a long JSON to the terminal. Look out for `defaultHostName` near the top - this is how I can access the API. Mine was [diamond-price-api.azurewebsites.net](http://diamond-price-api.azurewebsites.net/). If I view this in the browser (port 80 is the default), I see the health check, showing it’s working! I can also do a request to `/predict` as before to get a price prediction.

### Adding Azure deployment to GitHub Actions

The app is live, but it’s not linked to GitHub Actions yet, so code updates will not filter through. To the `deploy` YAML file, under `jobs:` (so the same level as `build:`), add a new job:

```yaml
    deploy:
      needs: build
      runs-on: ubuntu-latest
      steps:
        - name: Log in to Azure
          uses: azure/login@v1
          with:
            creds: ${{ secrets.AZURE_CREDENTIALS }}

        - name: Deploy to Azure Web App
          uses: azure/webapps-deploy@v2
          with:
            app-name: "diamond-price-api"
            images: "jamesdeluk/diamond-price-fastapi:latest"
```

The `needs` line ensures it only pushes if the `build` above is successful. The secrets are added to the same area of GitHub as before. To get them, first, I need my subscription ID:

```bash
az account show --query id --output tsv
```

Then include it in:

```bash
az ad sp create-for-rbac --name "github-action-deploy" --role contributor --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/rg-dp-api --sdk-auth
```

This will print a JSON in the terminal, starting with `{ "clientId":`. Copy this *entire JSON* as the secret, with the name `AZURE_CREDENTIALS`.

Push this to GitHub, and… Nothing changes! Because I haven’t changed the app. So let’s do that. Instead of the boring health check, let’s greet the user with a different message. Change `main.py` with a new `return` JSON in the `home()` function, repush, wait for it to rebuild, and then, when I visit [diamond-price-api.azurewebsites.net](http://diamond-price-api.azurewebsites.net):

![hi.png](/images/posts/data-and-analytics/basic-apis-diamond-pricing/hi.png)

It works!