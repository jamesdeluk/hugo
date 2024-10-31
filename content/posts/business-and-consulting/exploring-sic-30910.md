---
title: "Exploring SIC 30910"
date: 2023-05-17
tags: ["Business","Entrepreneurship","Data Analysis","Industry Analysis","Market Research","Growth","Electric Vehicles","Motorbikes"]
---
In a [previous post](https://www.jamesgibbins.com/posts/investigating-uk-companies/) I investigated a few companies using Companies House and the Office for National Statistics. In particular, I looked into the ONS data for electric vehicles, primarily based on SIC code 30910 (manufacture of motorcycles).

ONS provides big-picture data - overall numbers of companies by size, revenue, location, etc. In this post I search for data on Companies House, which is more small-picture - information about individual companies. Fortunately Companies House has a great search feature, along with a CSV export, to make life much easier!

## Are they still around?

As of today, there are 407 companies with the SIC code 30910.

Of these, 218 are still active, 188 are dissolved, and 1 is in liquidation.

![Untitled](/images/old/exploring30910-0.png)

## When did they start?

Most companies have been incorporated recently. In fact, the median incorporation date is 15 January 2020 - about three and a half years ago. The trend is pretty similar regardless of whether the company is still active or not. Only 16 companies are still active and over 20 years old.

![Untitled](/images/old/exploring30910-1.png)

![Untitled](/images/old/exploring30910-2.png)

![Untitled](/images/old/exploring30910-3.png)

## Who’s been around the longest?

I did some quick online searching into the 16 who are over 20 years old to find out what they seem to do (`info`) column:

| company_name | registered_office_address | company_number | incorporation_date | info |
| --- | --- | --- | --- | --- |
| A. HARTILL & SON (MOTOR CYCLES) LIMITED | Granville House 2 Tettenhall Road Wolverhampton WV1 4SB | 526790 | 11/12/1953 | MOT and servicing |
| WATSONIAN SIDECARS LIMITED | Unit 72 Northwick Business Centre Blockley Moreton-In-Marsh GL56 9RF | 902898 | 06/04/1967 | Sidecar manufacturer |
| BUSHFIELD LIMITED | 5 South Parade Summertown Oxford OX2 7JL | 1181242 | 19/08/1974 | Nothing inc. street view |
| D.V. GODDEN ENGINEERING LIMITED | Unit 4 Diamond Works Maidstone Road Nettlestead Maidstone ME18 5HP | 1255975 | 27/04/1976 | Limited website, motorbike equipment machine shop, unsure if still active |
| TRIUMPH MOTORCYCLES LIMITED | Ashby Road Measham Swadlincote DE12 7JP | 1735844 | 30/06/1983 | Triumph! |
| TRIUMPH DESIGNS LIMITED | Ashby Road Measham Swadlincote DE12 7JP | 1749908 | 05/09/1983 | Triumph! |
| WATSONIAN SQUIRE LIMITED | Unit 72 Northwick Business Centre Blockley Moreton-In-Marsh GL56 9RF | 2319399 | 18/11/1988 | Sidecar manufacturer |
| JOHN ALFRED PRESTWICH INDUSTRIES LIMITED | Tatt Barn High Street Yalding ME18 6HS | 2584862 | 22/02/1991 | Wikipedia says defunct 1964, street view is house |
| RCV ENGINES LIMITED | 4 Telford Road Ferndown Industrial Estate Wimborne BH21 7QL | 3338081 | 21/03/1997 | Engine manufacturer |
| FABER MARKETING LIMITED | Tara St Breward Bodmin Cornwall PL30 4NX | 3471384 | 26/11/1997 | Motorbike frame manufacturer |
| COTTON MOTORCYCLES LIMITED | 24 Cornwall Road Dorchester DT1 1RX | 3660741 | 03/11/1998 | Wikipedia says defunct 1980, street view is accountants |
| E. COTTON MOTORCYCLES LIMITED | 24 Cornwall Road Dorchester DT1 1RX | 3660737 | 03/11/1998 | Wikipedia says defunct 1980, street view is accountants |
| RICARDO STRATEGIC CONSULTING LIMITED | Shoreham Technical Centre Old Shoreham Road Shoreham-By-Sea BN43 5FG | 3696451 | 18/01/1999 | Large engineering public company covering many sectors, >£350m revenue |
| BOWEN MOTO LIMITED | Gray Friars 29 Priestfields Rochester ME1 3AB | 4039574 | 24/07/2000 | Sales and servicing |
| NORTH MOOR ENGINEERING LIMITED | Cummins Young 39 Westgate Thirsk YO7 1QR | 4129888 | 22/12/2000 | Limited website, motorcycle sports, unsure if still active |
| RICKMAN MOTORCYCLES LIMITED | 701 Stonehouse Park Sperry Way Stonehouse GL10 3UT | 4534679 | 13/09/2002 | Motorbike frames and parts |

Some don’t seem to exist any more - perhaps they’re just kept registered to keep the name.

Some are small-scale manufacturers of specialist parts (frames, sidecars, etc).

Some are sales/servicing.

There are three that stand out:

1. Triumph, the well-known motorcycle brand, with revenues of ~£500m.
2. RCV Engines, a manufacturer of a unique kind of engine, and now seems to focus on the UAV (drone) market.
3. Ricardo Strategic Consulting, which is now a general engineering consultancy, a public company with a market cap of ~£350m. According to their website, the company was originally founded in 1915 as engine manufacturer Engine Patents Ltd.

## What do they do?

Natures are how Companies House describes the SICs. Companies can have multiple SICs (up to four), so although I searched for 30910, others appeared in the data.

Focussing on the companies still active, we can see over half of the companies have more than one nature:

![Untitled](/images/old/exploring30910-4.png)

This has been growing over time:

![Untitled](/images/old/exploring30910-5.png)

The most common natures in conjunction with 30910 are 45400 (Sale, maintenance and repair of motorcycles and related parts and accessories), 29100 (Manufacture of motor vehicles), and 30920 (Manufacture of bicycles and invalid carriages):

![Untitled](/images/old/exploring30910-6.png)

## Where are they?

About 20% were in London:

![Untitled](/images/old/exploring30910-7.png)

This was the same for active companies (18:82) and dissolved companies (19:81).

Plotting all the postcodes on a map gives us a pretty good spread across the country:

![Untitled](/images/old/exploring30910-8.png)

This is for active and dissolved companies, but splitting them still has a similar result. Interestingly my part of the country seems to be a bit of a dead zone!

## Summary

There appears to be a boom in new motorcycle manufacturers in the UK - most started in the last three years. There was a particular jump in 2021, possibly due to COVID, although more than half of those have already been dissolved. However, most 30920s are still active, which is abnormal - when considering all companies, Companies House has an ratio of active to dissolved of ~48:52. That said, of the ~110,000,000 companies on Companies House, motorcycle manufacturers are a tiny share. Of the companies that have been around since the 21st century, many seem to exist in name only, or have branched out, or are very small - the only household name is Triumph. Overall, motorcycle manufacturing is a niche industry in the UK, possibly because motorcycle riding is also relatively niche - cars outsell cars [~30 to 1](https://www.statista.com/statistics/312594/motorcycle-and-car-registrations-in-the-united-kingdom/) in the UK, and according to [Bennetts](https://www.bennetts.co.uk/bikesocial/news-and-views/features/bikes/where-was-your-triumph-motorcycle-made), 85% of Triumph bikes are exported.

This might go to explain why there is a trend towards multiple natures - most commonly motorcycle services and manufacturing of other similar vehicles. Although approximately half have only the single nature, the second highest quantity is four. Whether there are any corporate advantages for having multiple SIC codes I don’t know. It might be companies trying to offer more services to survive and thrive - 8x more 29100 than 30920, and 15x more 45400.

Unsurprisingly given it’s manufacturing, the vast majority are based outside London. Slightly more dissolved companies were based on London than still active ones, but this appears insignificant. Otherwise they’re spread out relatively well, suggesting no particularly good areas - although the peripheries (Scotland, Wales, Westcountry) does have fewer.

All considered, there was nothing that shocked me about this data. I was surprised that there are over 200 active companies, given the only British brand anyone really knows is Triumph (Norton, BSA, and Lee Enfield are now all owned by Indian corporations). The recent growth has also been pretty surprising too - I’d be curious to see if this is in every industry, or if motorcycle manufacturers are an outlier, and if the latter, what has caused this. Maybe in the years to come more British brands will join Triumph - hopefully making [electric bikes](https://www.jamesgibbins.com/posts/electric-motorcycles-in-the-uk/)!