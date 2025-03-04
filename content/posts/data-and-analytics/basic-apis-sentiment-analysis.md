---
title: "Basic APIs: Sentiment Analysis with Flask, Docker, and AWS"
date: 2025-01-08
tags: ['Data Science', 'Sentiment Analysis', 'APIs', 'Docker', 'Flask', 'AWS', 'Cloud', 'Python']
hero: /images/posts/data-and-analytics/basic-apis-sentiment-analysis/basa1.png
---
The repo for this project can be found here: <https://github.com/jamesdeluk/data-projects/tree/main/basic-apis/sentiment-analysis>

## The goal

Send (POST) a word or phrase to an online API, and get a sentiment (positive or negative) and score as a response.

## Step 1: Build the Python script

First we need the script that can take a word or phrase as an input and return a sentiment.

```python
import json
from textblob import TextBlob

def analyse(data):
    text = data.get('text', '')

    if not text:
        return json.dumps({'error': 'No text provided'}), 400

    blob = TextBlob(text)
    sentiment_score = blob.sentiment.polarity

    return json.dumps({
        'input': text,
        'sentiment_score': sentiment_score,
        'sentiment': (
            'positive' if sentiment_score > 0 else
            'negative' if sentiment_score < 0 else
            'neutral'
        )
    })
```

The API will be JSON-based, so this script is also. The function takes some text and uses `TextBlob` to give it a sentiment score between 1 (positive) and -1 (negative), which it returns, also in JSON form.

### Testing

```python
analyse({'text': "Happy New Year!"})
```

Returns:

```json
{'input': 'Happy New Year!', 'sentiment': 'positive', 'sentiment_score': 0.48522727272727273}
```

## Step 2: Make the Flask app

Flask is normally only for development purposes, but it’s quick and easy, so for this project I thought I’d use it.

```python
from flask import Flask, request, jsonify
from textblob import TextBlob

app = Flask(__name__)

@app.route("/")
def home():
    return {"health_check": "OK"}

@app.route('/analyse', methods=['POST'])
def analyse():
    data = request.json
    text = data.get('text', '')

    if not text:
        return jsonify({'error': 'No text provided'}), 400

    blob = TextBlob(text)
    sentiment_score = blob.sentiment.polarity

    return jsonify({
        'input': text,
        'sentiment_score': sentiment_score,
        'sentiment': (
            'positive' if sentiment_score > 0 else
            'negative' if sentiment_score < 0 else
            'neutral'
        )
    })

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=False)
```

The `analyse` function is mostly the same, except it uses `jsonify` from within Flask instead of the `json` library, as is required for Flask apps, and the data is taken from the request, not as an argument. It’s linked to the `/analyse` endpoint. The `/` endpoint is a simple health check, and is mostly for testing. The `app = Flask(__name__)`  is required for the Flask app to work. The main guard (`if __name__ == '__main__':`) tells the interpreter what to do when the script is run, running the app on `0.0.0.0`, which means all network interfaces (which includes `localhost`, a.k.a. `127.0.0.1`, a.k.a. the machine the script is being run from), and on port 5000 (the default for Flask apps), without debugging (change to `True` if needed). Save it as `app.py`.

### Testing

You can start the app by simply running the Python file:

```sh
python app.py
```

My terminal showed:

```console
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.1.101:5000
```

Now, to make a request. We can use Python’s `requests` library for this:

```python
import requests

url = "http://127.0.0.1:5000/analyse"
data = {"text": "Happy New Year!!"}

response = requests.post(url, json=data)

if response.status_code == 200:
    print(response.json())
else:
    print("Error:", response.status_code, response.text)
```

POST the data as JSON to the URL, and check the response.

```json
{'input': 'Happy New Year!!', 'sentiment': 'positive', 'sentiment_score': 0.506534090909091}
```

One more exclamation mark is ~0.02 more positive.

## Step 3: Containerise with Docker

Docker will package the app and it’s dependencies (e.g. Python, Flask, TextBlob) into a portable container so it runs consistently across different platforms and environments, such as AWS. You need Docker Desktop installed, running, and signed in.

### Prep

First, create the requirements file. Given this app is so simple, it’s easy to do manually. `requirements.txt` contains the Python packages used:

```text
Flask
textblob
```

Next, create the `Dockerfile` (no file extension):

```docker
FROM python:3.13.1-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY app.py .

CMD ["python", "app.py"]
```

The first line tells it to use Python 3.13.1, the latest stable version available at the time of writing. `slim` is a minimal version of Python that takes up less space, and is fine for this simple app. The second line sets the working directory - where I’ll be copying files to - to be a folder call `app`, in the root of the container’s filesystem. The third and fourth line copy and install the requirements (`.` represents the current directly, which is the working directory, which is `/app`). The fifth line copies the app itself to this directory. The final line tells Docker how to run the app when it’s initialised; similar to running on our system, it’s equivalent to `python app.py`.

These files are all in the same directory.

### Build

Now to build:

```sh
docker build -t jamesdeluk/sentiment-analysis-flask .
```

`jamesdeluk` is my Docker username. I’m calling (”tagging”) this app `sentiment-analysis-flask`. The `.` tells Docker where to find the `Dockerfile`, which is same directory as the terminal from whence you run the command. It will do some stuff, taking a few seconds, and requiring internet access. Once it’s done, you’ll see it in Docker Desktop under Images, and you’ll see it when you run `docker images`. If you want to explore it, you can run:

```sh
docker run -it jamesdeluk/sentiment-analysis-flask sh
```

`it` stands for (kinda) interactive terminal, and `sh` is bash (the terminal). You’ll now see a `#` prompt. `pwd` will show you the working directory - `/app`, as we set in the `Dockerfile` - and `ls` shows you the files in the folder: `app.py`  and `requirements.txt`. `exit` to escape.

### Test

You run the container with:

```sh
docker run -p 5000:5000 jamesdeluk/sentiment-analysis-flask
```

Remember, Flask uses port 5000 by default. The terminal shows the now-recognisable:

```console
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://172.17.0.2:5000
Press CTRL+C to quit
```

And you can request as before. If you want to change the port on the local system, you can change the *first* 5000, e.g. `80:5000`, then sent the request to `http://127.0.0.1:80/analyse`.

### Upload

This pushes your container to Docker Hub (think GitHub, but Docker), which will enable AWS ECS to access it. Be aware, it will be public by default.

After logging in:

```sh
docker login
```

Much like with Git, you need to push:

```sh
docker push jamesdeluk/sentiment-analysis-flask
```

Once it’s done, you can see it on the website (<https://hub.docker.com/repository/docker/jamesdeluk/sentiment-analysis-flask>), and also on Docker Desktop’s Images tab.

## Step 4: Live on AWS

### Relevant URLs

These are the current URLs as of the time of writing, if you can’t find the appropriate button in the AWS management console.

1. **ECS / Clusters**: <https://us-east-1.console.aws.amazon.com/ecs/v2/clusters>
2. **Create cluster**: <https://us-east-1.console.aws.amazon.com/ecs/v2/create-cluster>
3. **Cluster URL**: https://us-east-1.console.aws.amazon.com/ecs/v2/clusters/[cluster-name]
4. **Task definitions**: <https://us-east-1.console.aws.amazon.com/ecs/v2/task-definitions>
5. **Create task definition**: <https://us-east-1.console.aws.amazon.com/ecs/v2/create-task-definition>
6. **Task definition URL**: https://us-east-1.console.aws.amazon.com/ecs/v2/task-definitions/[task-name]
7. **Run new task**: https://us-east-1.console.aws.amazon.com/ecs/v2/clusters/[cluster-name]/run-task
8. **Task URL**: https://us-east-1.console.aws.amazon.com/ecs/v2/clusters/[cluster-name]/tasks/[task-ID]
9. **Task Networking tab**: https://us-east-1.console.aws.amazon.com/ecs/v2/clusters/[cluster-name]/tasks/[task-ID]/networking

### Create the cluster

Once logged into AWS, find Elastic Container Service (ECS) (link 1). “Create cluster” on the top right (link 2) - I called mine `sentiment-analysis-flask`. All other settings I left as default. Click Create. You can find your new cluster similar to link 3.

### Create the task definition

Go into “Task definitions” (left sidebar) (link 4) from within ECS, then “Create new task definition” (top right) (link 5). I called mine `sentiment-analysis-flask-task`. Connect the Docker container: give it a name (`sentiment-analysis-flask-image`) and enter the image URI (the Docker username and image name, easily taken from the Docker Hub URL - mine is `jamesdeluk/sentiment-analysis-flask`). As the Flask app uses port 5000, under “Port mappings”, set “Container port” to 5000. Click Create. You can find your new task definition similar to link 6.

### Run the task

Go to the newly-created cluster (link 3), then under “Tasks”, “Run new task” (link 7). Under “Deployment configuration”, choose the task (`sentiment-analysis-flask-task`) as the “Family”. Under “Networking”, “Create a new security group”, picking “Customised TCP” as “Type” and 5000 as “Port range”, and “Source” as “Anywhere”. Click Create. You can find your new task definition similar to link 8.

### Testing

Open the task and get the Public IP from the Networking tab (link 9). Mine was 44.201.42.37. Visiting http://44.201.42.37:5000/ in a browser gave the `{"health_check":"OK"}`, and using the Python requests script, changing the IP as required, gives the expected response:

```json
{'input': 'Happy New Year!!!', 'sentiment': 'positive', 'sentiment_score': 0.5331676136363637}
```

## Step 5: Celebrate! And next steps

Congrats, you now have an API you can access from anywhere with internet access that will tell you the sentiment of any text! (Although I’ve now deleted mine as I don’t want unexpected AWS fees).

Next I’ll have one where a user POSTs a number of diamond criteria and the system returns a predicted price. This will use FastAPI, so port 80, and will use a trained ML model, bundled into the container, for the prediction.
