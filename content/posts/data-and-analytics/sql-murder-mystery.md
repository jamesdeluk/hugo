---
title: SQL Murder Mystery Solution and Walkthrough
date: 2024-12-05
tags: ["Data Science", "Data Analysis", "SQL"]
hero: images/posts/data-science/sql-murder-mystery/hero.png
---
I recently heard of SQL Murder Mystery ([https://mystery.knightlab.com/](https://mystery.knightlab.com/)), a website that uses gamification to learn/practise SQL skills. There’s been a murder, and by searching the SQL database you can find out whodunit. Seemed like a fun challenge.

Here’s the prompt:

> A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a **murder** that occurred sometime on **Jan.15, 2018** and that it took place in **SQL City**. Start by retrieving the corresponding crime scene report from the police department’s database.
>

As the challenge recommended, I used SQLiteStudio.

First step, search the `crime_scene_report` table to find the report, based on the date, type, and location:

```sql
SELECT *
FROM crime_scene_report
WHERE date = 20180115 AND type = 'murder' AND city = 'SQL City'
```

| date | type | description | city |
| --- | --- | --- | --- |
| 20180115 | murder | Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave". | SQL City |

We have two addresses. The `person` table has addresses:

```sql
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1
```

| id | name | license_id | address_number | address_street_name | ssn |
| --- | --- | --- | --- | --- | --- |
| 14887 | Morty Schapiro | 118009 | 4919 | Northwestern Dr | 111564949 |

```sql
SELECT *
FROM person
WHERE address_street_name = 'Franklin Ave' AND name LIKE 'Annabel%'
```

| id | name | license_id | address_number | address_street_name | ssn |
| --- | --- | --- | --- | --- | --- |
| 16371 | Annabel Miller | 490173 | 103 | Franklin Ave | 318771143 |

Now we have two people. Let’s check what they have to say in the `interview` table:

```sql
SELECT *
FROM interview
WHERE person_id = 14887 OR person_id = 16371
```

| person_id | transcript |
| --- | --- |
| 14887 | I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W". |
| 16371 | I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th. |

Gym details! There are two gym-related tables. First, `get_fit_now_member`:

```sql
SELECT *
FROM get_fit_now_member
WHERE membership_status = 'gold' AND id LIKE '48Z%'
```

| id | person_id | name | membership_start_date | membership_status |
| --- | --- | --- | --- | --- |
| 48Z7A | 28819 | Joe Germuska | 20160305 | gold |
| 48Z55 | 67318 | Jeremy Bowers | 20160101 | gold |

Two potential suspects. Who checked in on the 9th?

```sql
SELECT *
FROM get_fit_now_check_in
WHERE check_in_date = 20180109 AND membership_id LIKE '48Z%'
```

| membership_id | check_in_date | check_in_time | check_out_time |
| --- | --- | --- | --- |
| 48Z7A | 20180109 | 1600 | 1730 |
| 48Z55 | 20180109 | 1530 | 1700 |

Both of them, so that doesn’t help. What about the plate info mentioned in one of the interviews?

```sql
SELECT *
FROM drivers_license
WHERE plate_number LIKE '%H42W%'
```

| id | age | height | eye_color | hair_color | gender | plate_number | car_make | car_model |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 183779 | 21 | 65 | blue | blonde | female | H42W0X | Toyota | Prius |
| 423327 | 30 | 70 | brown | brown | male | 0H42W2 | Chevrolet | Spark LS |
| 664760 | 21 | 71 | black | black | male | 4H42WR | Nissan | Altima |

The interview implies it's a male, so still two options. This gives us their licence numbers though, which we can look up in `person`:

```sql
SELECT *
FROM person
WHERE license_id = '423327' OR license_id = '664760'
```

| id | name | license_id | address_number | address_street_name | ssn |
| --- | --- | --- | --- | --- | --- |
| 51739 | Tushar Chandra | 664760 | 312 | Phi St | 137882671 |
| 67318 | Jeremy Bowers | 423327 | 530 | Washington Pl, Apt 3A | 871539279 |

One of those names is one we’ve seen before in our initial list of suspects:

```sql
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
SELECT value FROM solution;
```

> Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.
>

Let’s see what Jeremy had to say:

```sql
SELECT *
FROM interview
WHERE person_id = '67318'
```

| person_id | transcript |
| --- | --- |
| 67318 | I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017. |

Let’s look her up in the `drviers_license` table:

```sql
SELECT *
FROM drivers_license
WHERE gender = 'female' AND height BETWEEN '65' AND '67' AND hair_color is 'red' AND car_make = 'Tesla' AND car_model = 'Model S'
```

| id | age | height | eye_color | hair_color | gender | plate_number | car_make | car_model |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 202298 | 68 | 66 | green | red | female | 500123 | Tesla | Model S |
| 291182 | 65 | 66 | blue | red | female | 08CM64 | Tesla | Model S |
| 918773 | 48 | 65 | black | red | female | 917UU3 | Tesla | Model S |

That gives us three possibilities. What about the event? Got to love social media:

```sql
SELECT person_id, COUNT(person_id)
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert' AND date LIKE '201712%'
GROUP BY person_id
HAVING COUNT(person_id) = 3
```

| person_id | COUNT(person_id) |
| --- | --- |
| 24556 | 3 |
| 99716 | 3 |

Two possibilities. Who are these people?

```sql
SELECT *
FROM person
WHERE id = '24556' OR id = '99716'
```

| id | name | license_id | address_number | address_street_name | ssn |
| --- | --- | --- | --- | --- | --- |
| 24556 | Bryan Pardo | 101191 | 703 | Machine Ln | 816663882 |
| 99716 | Miranda Priestly | 202298 | 1883 | Golden Ave | 987756388 |

One of those licence IDs was one in the table above!

```sql
INSERT INTO solution VALUES (1, 'Miranda Priestly');
SELECT value FROM solution;
```

> Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
>

When posing the second challenge, it did ask to do it in no more than 2 queries. Initially, I didn’t. Why? Complex is not necessarily faster or better - I would prefer to do 10 small queries, learning through each, rather than taking the time to create and debug a more complicated one. That said, we can get the answer in one easily enough:

```sql
SELECT p.name
FROM drivers_license d
    JOIN person p ON d.id = p.license_id
    JOIN facebook_event_checkin f ON p.id = f.person_id
WHERE d.gender = 'female' AND d.height BETWEEN '65' AND '67' AND d.hair_color is 'red' AND d.car_make = 'Tesla' AND d.car_model = 'Model S' AND f.event_name = 'SQL Symphony Concert' AND f.date LIKE '201712%'
GROUP BY person_id
HAVING COUNT(person_id) = 3
```

| name |
| --- |
| Miranda Priestly |

So there we have it! Bad Miranda.

![Miranda_Priestly](/images/posts/data-and-analytics/sql-murder-mystery/Miranda_Priestly.png)

Image source: [Wikipedia](https://en.wikipedia.org/wiki/File:Miranda_Priestly.png)
