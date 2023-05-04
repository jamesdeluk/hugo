---
title: Mental Maths Tricks
summary: A bunch of tricks to speed up mental calculations. Really useful!
date: 2023-03-08
lastmod: 2023-03-13
categories: ["Cognition and Learning"]
tags: ["Maths"]
# math: false
---
## Maths practise game

I made a little Python script to test myself.

Find it here: [Maths game](https://www.jamesgibbins.com/posts/maths-game/)

## A comment on notation

I've used square brackets to represent place values - in other words, [5][4] = 54 - _not_ multiplication. Note if the there is a value in the brackets which is more than one digit, it (somtimes) adds onto the previous bracket - in other words, [5][11] = [6][1] = 61. Check the examples to see which ones this applies to.

## General

- Go left to right (not right to left, as we're normally talk).

- Speak aloud to aid memory.

## Addition

1234 + 567

= 1234 + 500 + 60 + 7

= 1734 + 60 + 7

= 1794 + 7

= 1801

## Multiplication

### Special situations

**6 × #x** = #x (if x = 2, 4, 6, 8, 0)

---

**11 ×** AB = A[A+B]B

**11 ×** ABC = A[A+B][B+C]C

etc

---

**AB × AC** (when **B+C=10**) = [A×(A+1)][B×C]

e.g. 14 × 16 = [1 × 2][4 × 6] = [2][24] = 224

{{<br>}}

Note when B=C=5:

A5 × A5 = [A×(A+1)]25

e.g. 35 × 35

= [3 × 4][5 × 5] = 1225

---

**AB × CD** (where **CD = E×F**) = AB × E × F

e.g. 14 × 16 = 14 × 4 × 4 = 56 × 4 = 224

{{<br>}}

### Criss-cross method (my favourite!)

**AB × CD = [A×C][A×D+B×C][B×D]**

≡ 100(A×C) + 10(A×D + B×C) + BD

e.g. 12 × 34

= 100(1×3) + 10(1×4 + 2×3) + (2×4)

≡ 300 + 100 + 8

= 408

{{<br>}}

**ABC × DEF = [A×D][A×E+D×B][A×F+B×E+D×C][B×F+E×C][C×F]**

= 10000(A×D) + 1000(A×E + D×B) + 100 (A×F + B×E + D×C) + 10(B×F + E×C) + (C×F)

e.g. 123 × 456

= 10000(1×4) + 1000(1×5 + 4×2) + 100(1×6 + 2×5 + 4×3) + 10(2×6 + 5×3) + (3×6)

= 10000(4) + 1000(13) + 100(28) + 10(27) + (18)

= 40000 + 13000 + 2800 + 270 + 18

= 56088

{{<br>}}

### Bases method (similar size, or squaring)

When AB=base+E and CD=base+F:

**base(AB+F) + E×F**

{{<br>}}

e.g. 12 × 34 with base 10

= 10(12+24) + 2×24

= 360 + 48

= 408

e.g. 12 × 34 with base 20

= 20(12+14) + -8×14

= 520 - 112

= 408

{{<br>}}

**If squaring**

e.g. 13^2, base 10:

= 10(13+0) + 3^2

= 169

{{<br>}}

**Alternative squaring method based on bases**

e.g 69^2, base 60:

69 = 60 + 9

69 + 9 = 78

78 × 60 = 4680

9^2 = 81

69^2 = 4680 + 81 = 4761

{{<br>}}

### 100 minus method (if close to 100)

**AB × CD = [100-((100-AB)+(100-CD))][(100-AB)×(100-CD)]**

{{<br>}}

e.g. 12 × 34

= [100-((100-12)+(100-34))][(100-12)×(100-34)]

= [100-(88+66)][88×66]

= [100-154][88×66]

= [-54][5808]

= 408

{{<br>}}

e.g. 88 × 66

= [100-((100-88)+(100-66))][(100-88)×(100-66)]

= [100-(12+24)][12×34]

= [54][408]

= 5808

## Division

### Divide by

**3** → Decimal multiple of 0.333

e.g. 77 / 3 = 25.666…

{{<br>}}

**5** → Decimal = final digit of dividend × 2 / 10

e.g. 1234 / 5 = _something_.8

{{<br>}}

**6** → Decimal multiple of 0.5 × 0.333

e.g. 77 / 6 = 12.833

where 0.833 = 0.333 × 2.5

{{<br>}}

**9** → x / 9 = 0.xxx

e.g. 5 / 9 = 0.555…

{{<br>}}

**7** → Repeating pattern to memorise

1 / 7 = 0.142857142857

2 / 7 = 0.2857142857

3 / 7 = 0.42857142857

{{<br>}}

**11** → Multiples of 0.09… recurring

e.g. 4 / 11 = 0.4545…

{{<br>}}

### Divisible by

**2**: last digit multiple of 2

**4**: last two digits divisible by 4 (or 00)

**8**: last three digits divisible by 8 (or 000)

{{<br>}}

**3**: sum of digits divisibly by 3

**9**: sum of digits divisible by 9

{{<br>}}

**5**: final digit 0 or 5

{{<br>}}

**6**: divisible by 2 + divisible by 3

**12**: divisible by 3 + divisible by 4

{{<br>}}

**11**: (sum odd position numbers - sum even position numbers) divisible by 11 (or 0)

{{<br>}}

## Square Rooting

| Number | Square |
|--------|--------|
| 1      | 1      |
| 2      | 4      |
| 3      | 9      |
| 4      | 16     |
| 5      | 25     |
| 6      | 36     |
| 7      | 49     |
| 8      | 64     |
| 9      | 81     |
| 10     | 100    |

### If a perfect square

e.g. √1849

Final digit = 9

... so final digit of answer is 3 (3^2=9) or 7 (7^2=49) [see table above]

Nearest square below 18 = 4 (4^2=16) [see table above]

4 × (4+1) = 20

(always n × (n+1))

20 > 18, so 3 not 7

(if < it would have been 7 not 3>)

√1849 = [4][3] = 43

### If an imperfect square

e.g. √87

√81 = 9 (closest but under)

9 × 2 = 18 (double)

87 - 81 = 6 (difference)

= 9 + (6/18)

= 9.333

{{<br>}}

√138

√121 = 11

11 × 2 = 22

138 - 121 =17

= 11 + (17/22)

~=11.75

## Other tricks

### Halve and Double

160 × 350

= 80×2 × 700/2

= 80 × 700

= 56000

### Final digit = 5 (or .5)

36 × 25

= (36/4) × (4×25)

= 9 × 100

= 900

### Breaking up

68 × 35

= 68 × (10+25)

= (68×10) + (68×25)

= 680 + (17×4×25)

= 680 + (17×100)

= 2380

## Cases

![I Got An Offer tricks](/img/mental-maths-tricks-1.png)

## Links

[https://www.youtube.com/@mathOgenius/videos](https://www.youtube.com/@mathOgenius/videos)