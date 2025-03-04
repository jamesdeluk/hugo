---
title: Spotify Wrapped DIY
date: 2024-12-18
tags: ["Data Analysis"]
hero: /images/posts/data-and-analytics/spotify-wrapped-diy/swdiy6.png
---
I was a bit disappointed with my Spotify Wrapped this year, and it seems [I wasn’t the only one](https://thehustle.co/news/did-spotify-wrapped-miss-the-mark-this-year). The insights weren’t as interesting, the graphics weren’t as exciting, and some of it seemed irrelevant. Plus, of course, you only get one a year.

So I thought I’d create my own.

The code isn’t pretty; it's something quick and dirty thrown together over a couple of hours. You can see it on my GitHub: [https://github.com/jamesdeluk/data-projects/tree/main/spotify-wrapped-diy](https://github.com/jamesdeluk/data-projects/tree/main/spotify-wrapped-diy)

You can use it with your own data if you want. You can request your extended streaming history from Spotify here: [https://www.spotify.com/us/account/privacy/](https://www.spotify.com/us/account/privacy/) You’ll get a .zip file with some JSON files. You need the ones starting `Streaming_History_Audio_` in the same directory as the Jupyter notebook.

## Overall

How much data do I have?

```text
Unique values per column
ts                : 27328
track_name        : 17869
album_artist_name : 10395
album_album_name  : 15571
```

27,328 records (technically, that many timestamps), including 17,869 unique songs by 10,395 artists across 15,571 albums.

Total play time is 4419630185ms - so just over 51 days.

## All time

### Artists

Top artists of all time? Everyone’s favourite, a pie chart:

![Pie chart artists all time](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy0.png)

Just joking.

![Bar chart artists all time](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy1.png)

Fairly varied. Lots of electronic (trance, drum and bass), but also some K-pop (my background music), world music, classical, rock, meditation/spiritual stuff too.

### Tracks

Same for tracks. Pie!

![Pie chart tracks all time](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy2.png)

Not pie:

![Bar chart tracks all time](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy3.png)

For a long period, Stillness was my meditation track, hence the high count.

In case you’re wondering about the weird font, it’s because of that katakana (Japanese writing) - many fonts don’t seem to support those characters, so it was easiest to pick the default Japanese one.

### Play time

What about play time per year? This has the total overall per year (in hours), and the total for my single favourite artist or track in that year (in minutes).

![Play time line chart all time](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy4.png)

I didn’t use Spotify much until 2023. In 2021 I listened to my favourite artist as a higher percentage of my total listens than in other years; 2020 was the opposite. 2024 isn’t actually over yet so the drop might not be as severe as expected, but with only another 2 weeks to go (1/26th of a year), I doubt I’ll exceed 2023.

For the actual details:

| Year | Album artist | Minutes played |  | Track - Artist | Minutes played |
| --- | --- | --- | --- | --- | --- |
| 2011 | LL COOL J | 1.513817 |  | Phenomenon - LL COOL J | 1.513817 |
| 2014 | Tarentel | 6.403333 |  | Two Sides of Myself Part One - Tarentel | 6.403333 |
| 2015 | Leo de la Rosa | 23.57783 |  | El Amor Es Sentir - Jesus Mondejar | 9.921667 |
| 2016 | Hans Zimmer | 41.90555 |  | Free Bird - Lynyrd Skynyrd | 18.6311 |
| 2017 | Camo & Krooked | 120.9462 |  | Embargo - DC Breaks | 24.89222 |
| 2018 | AURORA | 124.9981 |  | Night - Doublepoint Remix - Ludovico Einaudi | 29.0031 |
| 2019 | Iron Maiden | 112.9008 |  | Rime of the Ancient Mariner - 2015 Remaster - Iron Maiden | 13.64488 |
| 2020 | Pink Floyd | 39.94393 |  | Stir It Up - Bob Marley & The Wailers | 21.99707 |
| 2021 | No Brain | 192.7333 |  | In front of city hall at the subway station - Kwak Jin Eon | 19.99727 |
| 2022 | Snatam Kaur | 29.60448 |  | Aad Guray Nameh (Protection) - Snatam Kaur | 10.71622 |
| 2023 | Cory Allen | 403.7173 |  | Stillness - Cory Allen | 236.202 |
| 2024 | Putumayo | 246.4021 |  | Too Sweet - Hozier | 37.84817 |

Quite varied I’d say.

### Skips

Who do I skip?

![Line chart skips all time](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy5.png)

A lot of my most-skipped are also the ones I listened to the most - so it’s not because I don’t like them, it’s just that I wasn’t in the mood for them at that time. Sometimes I don’t want peaceful classical music, or angry rock music, or trippy ayahuasca music.

## 2024 Wrapped

And finally, my “Wrapped”.

### Top artists

![Bar chart artists 2024](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy6.png)

Most of them were also in my top 50 in 2023, but some are new.

```text
Top 50 artists in 2024 but not in 2023: Kyau & Albert, Ambience Mastery, RÜFÜS DU SOL, Enya, KhoMha, Federico Aubele, Cosmic Gate, Aly & Fila, Christopher Galovan, Arctic Monkeys, Eximinds, Miles Davis, The Blizzard, Ali Wilson, LiSA, Maduk, Mat Zo, IU, Amy Winehouse, Tiësto, Eugenio Tokarev, Die Antwoord, Lange, Gibran Alcocer, deadmau5, Masakatsu Takagi, KISS OF LIFE, Poranguí, Mrs. GREEN APPLE, Etherwood, Friction, Nick Phoenix, Underworld (33)

Top 50 artists in 2023 but not in 2024: Cory Allen, Cannons, Rise Against, Red Velvet, Paramore, STAYC, Lindsey Stirling, ONE OK ROCK, (G)I-DLE, BLACKPINK, Ellie Goulding, Sleep Token, Parov Stelar, Daft Punk, Muse, RADWIMPS, Foo Fighters, X-Ray Dog, M83, PianoDeuss, Russkaja, BIBI, Slipknot, Andrew Bayer, NMIXX, Bob Moses, Celldweller, Pendulum, Derek Fiechter, Biting Elbows, BICEP, The Heavy, OFFICIAL HIGE DANDISM (33)
```

### Play time per day

![Line chart play time 2024](/images/posts/data-and-analytics/spotify-wrapped-diy/swdiy7.png)

I average just under an hour and a half of play time per day. Some days I listened to nothing. My peak was on the 13th March (not a Friday), with almost 6 hours. It wasn’t a few songs on repeat - it was 72 songs, the average being under 5 minutes in length, mostly a combination of jazz and trance.

## Conclusion

And there was have it. My quick personal Wrapped analysis. Lots more I could have done - if you can think of anything else that might be interesting, let me know! One thing missing is comparing myself to others; potentially I could get this data from the API, but it's not my priority right now.
