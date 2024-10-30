---
title: Myopia Measurer Android App
categories: ["Projects"]
tags: ["Myopia","EndMyopia","Eyesight","Health","Android","App"]
date: 2023-03-29
---
# Android Myopia Measurer

Tl;dr: I launched an app. Get it here: [https://play.google.com/store/apps/details?id=com.myopia.measurer](https://play.google.com/store/apps/details?id=com.myopia.measurer)

## The original project

About 18 months ago (wow, time flies!) I built an Arduino-based device to measure your eyesight (read more about it [here](https://www.jamesgibbins.com/posts/arduino-myopia-measurer/)). However, it turns out taking it to the next stage - that is, PCB design and manufacturing - is prohibitively expensive (hundreds of £s). Using a breadboard-based device on a regular basis was not convenient, due to the physical size and fragility.

So, I decided to look into an Android app.

## Market research

The first step was market research, to see what was already available. There is an Android app called [endmyopia](https://play.google.com/store/apps/details?id=org.endmyopia.calc), but personally I didn’t find the measurements accurate (possibly due to my strangely shaped face), and I didn’t like the camera feature. I also found a couple of face-to-screen distance proof-of-concept projects on GitHub, which functionally were decent, but not designed to measure eyesight, and they were a few years old, so didn’t work on the latest Android operating systems. However, what if I could take aspects from both and create my own? It would also be a fun experiment in having my own app - something I’d never done before.

## Developing the app

Although I have some experience with coding, I’m not a developer. I haven’t touched Java for years, and I have zero experience with Kotlin. Instead of trying to do it myself, I thought I’d give Upwork a go.

I found a wonderful developer who was able to, as a first step, update one of the GitHub projects to work on the latest versions of Android. Perfect! I went back to the developer to add some nice UI features, such as diopter calculations, adjustable settings, an about page, etc.

## Launching the app

Once I had an MVP I was happy with, I went through the process of adding it to the Google Play Store. Not too difficult: pay the membership, do some paperwork, and upload the app. And sure enough, it was live!

## Improving the app

Over the next few months I’ve iterated to add additional features or improvements. Some I was able to do myself, looking at the existing code and reverse-engineering it using my existing knowledge. For features I knew would take me too much time to figure out myself, I returned to the developer on Upwork. There are still more features I’d like to implement, but some of these will take a lot of time (and hence money) to integrate, so they’re currently on pause.

I've also added ads, partially to learn more about how ad-based apps work, and partially to try and recoup some of the development costs. In three months I’ve recovered 3%, so… maybe within a few years I’ll be in the black.

## Feedback and comments

If you have any comments or feedback, I suggest posting on the [thread on the Endmyopia forums](https://community.endmyopia.org/t/i-made-a-myopia-measurer-android-app/19311). I do read them and implement features I can.

Also, if you want to leave a (positive) review on the Google Play Store, please do - ideally not one like this:
![Review](/images/old/myopia-measurer-app-review.png)