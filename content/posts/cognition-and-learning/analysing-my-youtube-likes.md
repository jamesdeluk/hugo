---
title: "Analysing my YouTube Likes"
categories: ["Cognition and Learning", "Data Science"]
tags: ["Data Analysis","AI","LLMs","YouTube"]
date: 2023-12-27
---
Like most people, I watch a lot of YouTube. Probably too much. When I like a video, I typically Like it. I was curious, so I decided to analyse my Likes.

## Getting the data

When you download your YouTube data using Takeout (https://takeout.google.com/), it doesn’t seem to include your Likes playlist, so I had to find an alternative method.

### IFTTT

This method requires pre-planning. IFTTT has an applet, “If New liked video, then Add row to my Google Drive spreadsheet”. It does what it says. However, I only activated this in April, so I don’t have my Likes from before then. I could use this next year though.

The applet is available at https://ifttt.com/applets/utSEHs6X-if-new-liked-video-then-add-row-to-my-google-drive-spreadsheet 

### yt-dlp

This is the method I used. Your Likes are private, so you need to log in to access the playlist - the easiest way is to use cookies. I used `-----` as a separator between fields in the output for easier processing, as using commas directly may cause issues with titles including commas. Note this downloads all your Likes, not just the past year, but I wasn’t that fussed about that.

yt-dlp is available at https://github.com/yt-dlp/yt-dlp and the command I used is `yt-dlp --cookies-from-browser firefox -O "%(title)s ----- %(channel)s ----- %(id)s" "https://www.youtube.com/playlist?list=LL" > likes.txt`

## Analysing the data

### In Excel

I imported the text file into Excel, with title/channel/id as the columns, then created a pivot table with channels as rows and count of titles as values.

At the time of processing, I had Liked 2278 videos from 1030 unique channels, so a mean of two videos per channel.

My most-Liked channels were Half as Interesting, Donut, Learn Korean with GO! Billy Korean, Economics Explained, and thejuicemedia. These made up about 10% of all my Likes.

19 channels made up the top 25% of my likes.

Although the data doesn’t include a category/theme, a quick skim shows I Like topics including vehicles, engineering, the Korean language, economics and politics, and general knowledge.

### With AI/LLMs

I create a custom bot using Poe (https://poe.com/create_bot), with the list of video titles as a Knowledge Base (KB). For this to work best, the video titles need to be related to the content and not clickbait, as it has no other context than the titles.

Note this bot doesn’t have web access, otherwise I’d have given it the YouTube video IDs and it could have extracted the data itself. 

According to the bot (”analyse themes in the attached knowledge base”), the main themes are Travel and Culture, Motorsports, Science and Technology, Language and Education, and Miscellaneous.

It thinks my MBTI might be ENTP. I’m actually ENTJ; querying the P-J difference, the variety in videos suggests less structure and planning than would be expected for a J.

For a job, it thinks I should be a content creator (the only real explanation being I like things and watch content on them).

I changed the KB to be the list of channels (copied from the Excel pivot table), and asked for new channel recommendations (I had to specifically state not to include those in the KB, as initially that’s what it did). Some I knew of (The Armchair Historian), some a bit strange (The Beer Farmers), and some that I might actually start following (Primitive Technology).

I asked a few other questions of both datasets but nothing that exciting showed up. Probably PEBKAC.