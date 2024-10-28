---
title: "Making a website with ChatGPT: DiscussAnyPage"
date: 2024-05-21
lastmod: 2024-05-28
categories: ["Projects"]
tags: ["ChatGPT","Python","Projects","AI","LLMs"]
---
## Summary

I went from an idea to a live website using ChatGPT in only a handful of prompts and a couple of hours, writing no code myself, and only copy and pasting commands.

URL: https://discussanypage.onrender.com/

<!-- I’ve added a simple login to limit access. The username is “dapuser”, and the password is “chatgpt”. There's also a comment and new page hourly limit. -->

<!-- _NB This is different from the login required to add comments on the site._ -->

## The idea

On Saturday night, I had an idea - what if there was a way to leave a comment on any webpage? Sure, sites like Reddit and Disqus are similar, but I wanted to implemented in a different way. From any webpage, a bookmarklet or browser extension would automatically create a page on a website (I called it DiscussAnyPage, or DAP for short) where anyone can leave comments specifically for that webpage.

However, I’m not a web developer. I’ve made websites before, but it took a reasonable amount of time and effort. In this case, I just wanted to get a MVP up and running as soon as possible. So I decided to try ChatGPT.

## A single prompt

I have experience with Python, so I thought I should use that, given I can at least read the code.

My first prompt made an entire functioning website:

> How can I create a basic Python website with a simple homepage?
> 

And the response:

> Creating a Python website with Flask inside a virtual environment (venv) is a good practice to manage dependencies and isolate your project. Here’s a step-by-step guide:
> 
> **Step 1: Set Up a Virtual Environment**
> 
> 1. **Create a Project Directory**: Create and navigate into your project directory:
>    ```bash
>    mkdir my_flask_app
>    cd my_flask_app
>    ```
> 
> 2. **Create a Virtual Environment**: Use the `venv` module to create a virtual environment:
>    ```bash
>    python -m venv venv
>    ```
> 
> 3. **Activate the Virtual Environment**:
>    - On **Windows**:
>      ```bash
>      venv\Scripts\activate
>      ```
>    - On **macOS/Linux**:
>      ```bash
>      source venv/bin/activate
>      ```
> 
> **Step 2: Install Flask**
> 
> 1. **Install Flask**: With the virtual environment activated, install Flask using pip:
>    ```bash
>    pip install Flask
>    ```
> 
> **Step 3: Create the Flask Application**
> 
> 1. **Create the Application File**: Create a file named `app.py` in your project directory.
> 
> 2. **Write the Basic Flask Code**: Open `app.py` in a text editor and add the following code:
> 
>    ```python
>    from flask import Flask
> 
>    app = Flask(__name__)
> 
>    @app.route('/')
>    def home():
>        return "<h1>Welcome to My Simple Homepage</h1>"
> 
>    if __name__ == '__main__':
>        app.run(debug=True)
>    ```
> 
> **Step 4: Add HTML Templates (Optional)**
> 
> 1. **Create a Templates Directory**: Create a directory named `templates` in your project directory.
> 
> 2. **Create an HTML Template**: Create a file named `home.html` inside the `templates` directory with the following content:
> 
>    ```html
>    <!doctype html>
>    <html lang="en">
>      <head>
>        <meta charset="utf-8">
>        <title>Simple Homepage</title>
>      </head>
>      <body>
>        <h1>Welcome to My Simple Homepage</h1>
>        <p>This is a simple Flask application.</p>
>      </body>
>    </html>
>    ```
> 
> 3. **Update `app.py` to Use the Template**: Modify `app.py` to render the HTML template:
> 
>    ```python
>    from flask import Flask, render_template
> 
>    app = Flask(__name__)
> 
>    @app.route('/')
>    def home():
>        return render_template('home.html')
> 
>    if __name__ == '__main__':
>        app.run(debug=True)
>    ```
> 
> **Step 5: Run the Flask Application**
> 
> 1. **Run the Application**: With the virtual environment activated, run the Flask application:
>    ```bash
>    python app.py
>    ```
> 
> 2. **Access the Website**: Open a web browser and go to `http://127.0.0.1:5000/`. You should see the content from `home.html`.
> 
> **Step 6: Deactivate the Virtual Environment**
> 
> 1. **Deactivate**: When you’re done working in the virtual environment, you can deactivate it by running:
>    ```bash
>    deactivate
>    ```
> 
> **Summary**
> 
> - **Virtual Environment Setup**: Use `venv` to create and activate a virtual environment.
> - **Flask Installation**: Install Flask within the virtual environment.
> - **Basic Flask Application**: Create and run a simple Flask app.
> - **HTML Templates**: Use `render_template` to serve HTML templates.
> - **Virtual Environment Management**: Activate and deactivate the virtual environment as needed.
> 
> Using a virtual environment helps to manage project dependencies and avoid conflicts with other Python projects on your system.
> 

## Everything else it did

Following this, I used prompts to:

- Change control with Git
- Add functionality to the website, including (but not limited to):
    - Dynamically enable the adding of pages
    - Encode and decode URLs to base64
    - Removing tracking parameters from URLs
    - Scrape the tab title from the webpage
    - Password protect the website as a whole (now removed)
    - Require users to log in to post comments
    - Rate limit commenting and adding pages
    - Save posts in a permanent database
    - Style the website
- Host the website on Heroku (now moved to Render)
- Create a bookmarklet, a Firefox extension, and a Chrome extension, to save pages to DAP
- Solve a bunch of errors (some caused by ChatGPT, some caused by James)

Like the first prompt, some of these did a lot in a single prompt. For example, I asked it to “Make it pretty”, and in a single reply it told me to create a CSS file in a specific folder, it gave me code to copy into the CSS, it gave me the new HTML code, and then it told me how to deploy it to Heroku. Is it going to win any design awards? Definitely not. But did it work? Yes! It added a bunch of suitable classes and assigned them to the HTML components, and it all looks reasonable.

## Concluding thoughts

In total, it took under 6 hours to get to this stage, requiring approximately 110 prompts.

That said, most of this - the core website functionality and getting it online - was done in under an hour, and only a dozen or so prompts. The rest was fine-tuning, adding more features or experimenting with different ways to implement a function.

It's amazing. Next, I think I'll try an Android app...