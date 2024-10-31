---
title: "Introduction to Corporate Finance (Columbia Business School)"
date: 2023-07-19
tags: ["Finance","Corporate Finance","Business","M&A","edX"]
---
# Introduction to Corporate Finance

https://learning.edx.org/course/course-v1:ColumbiaX+CORPFIN1x+1T2023/home

## Basic Finance Concepts

### Rate of Return

\\[Rate\,of\,return_{annual}=\frac{Return - initial\,investment}{Initial\,investment}=\frac{Gain}{Initial\,investment}\\]

Ex: Invest £100k, return £50k

\\[Rate\,of\,return_{annual}=\frac{50-100}{100}=-50\%\\]

### Future Value

\\[Future\,value=Present\,value\times(1+rate\,of\,return)\\]

### Compounding Future Value

\\[FV_{t\,years}=PV\times(1+r)^t\\]

Ex: Invest £100k, RoR = 10%

\\[FV_2=£100k\times(1+0.10)^2=£121k\\]

### Present Value

\\[PV=\frac{FV}{(1+r)^t}\\]

Ex: £150k return in 2 years at 10% RoR

\\[PV=\frac{£150k}{(1+0.10)^2}=£124k\\]

Opportunity cost of capital = alternative investment RoR

\\[PV=\frac{C_1}{(1+r)^1}+\frac{C_2}{(1+r)^2}+\frac{C_3}{(1+r)^3}+...\\]

Ex: Return of £110 in 1 year, £121 in 2 years, cost of capital = 10%

\\[PV=\frac{£110k}{(1+0.1)^1}+\frac{£121k}{(1+0.1)^2}=£200k\\]

Ex: Returns=£0.2m,£0.3m,£0.35m; Exit value=£1.8m; CoC=15%

\\[PV=\frac{£0.2m}{(1+0.15)^1}+\frac{£0.3m}{(1+0.15)^2}+\frac{£1.8m+£0.35m}{(1+0.15)^2}=£1.81m \\]

So pay ≤ £1.81m and profit.

Excel: `=NPV(r,C₁:Cₙ)` (note doesn’t include initial investment)

### Net Present Value

\\[NPV=C_0+\frac{C_1}{(1+r)^1}+\frac{C_2}{(1+r)^2}+\frac{C_3}{(1+r)^3}+...\\]

C**₀** will be negative

Excel: `=C₀ + NPV(r,C₁:Cₙ)` (note initial investment must be added)

Ex: Pay £50k today, C₁=£55k, discount rate 10%

\\[NPV=-£50k+\frac{£55k}{(1+0.1)}=0\\]

Ex: Buy for £1.7m; Returns=£0.2m,£0.3m,£0.35m; Exit value=£1.8m; CoC=15%

\\[NPV=-£1.7m+\frac{£0.2m}{(1+0.15)^1}+\frac{£0.3m}{(1+0.15)^2}+\frac{£1.8m+£0.35m}{(1+0.15)^2}=£0.11m \\]

Creates £0.11m in value → invest!

Ex: Buy for £1.6m; Returns=£0.2m,£0.3m,£0.35m; Exit value=£1.8m; CoC=25%

\\[NPV=-£1.6m+\frac{£0.2m}{(1+0.25)^1}+\frac{£0.3m}{(1+0.25)^2}+\frac{£1.8m+£0.35m}{(1+0.25)^2}=-£0.15m \\]

Negative → don’t invest!

Note cashflows may depend on owner → new owner = higher Cs?

### Special Cash Flow Cases: Perpetuity

Same C every year

\\[PV=\frac{C}{r}\\]

\\[C=\frac{PV}{r}\\]

Ex: Give me your home, I’ll give you 12k per year forever, 8% discount rate, what is the home valued at?

\\[PV=\frac{£12k}{0.08}=£150k\\]

### Special Cash Flow Cases: Growing Perpetuity

Annual growth: C, C(1+g), C(1+g)², …

\\[PV=\frac{C}{r-g}\\]

Ex: g=1%; Cs=£12000,£12120,£12241.20, …

\\[PV=\frac{£12k}{0.08-0.01}=£171k\\]

### Special Cash Flow Cases: Annuity

T periods

\\[PV=\frac{C}{r}[1-\frac{1}{(1+r)^t}]\\]

\\[C=\frac{PV\times r}{1-\frac{1}{(1+r)^t}}\\]

Ex: C=£1m, T=10 years, r=10%

\\[PV=\frac{£1m}{0.10}[1-\frac{1}{(1+0.10)^{10}}]=£6.14m\\]

Ex: Borrow £1m, repay over 10 years, interest 10%

\\[C=\frac{£1m\times 0.10}{1-\frac{1}{(1+0.10)^{10}}}=£162,745\\]

Ex: C₁~C₄=0, C₅=44k, perpetuity at g=2%, r=10%

\\[PV_4=\frac{£44k}{0.10-0.02}=£550k\newline PV_0=\frac{PV_4}{(1+0.1)^4}=£376k\\]

## Capital Budgeting

### The NPV Rule

If NPV is positive, invest in the project

NPV includes C₀, so even if NPV < C₀, still invest

Pick the project(s) with the highest NPV(s) (see also Profitability Index later)

### The IRR Rule

IRR is a profitability measure that is not informative about the scale of the project. NPV captures the scale of the project.

Note IRR =/= cost of capital

\\[C_0+\frac{C_1}{(1+IRR)^1}+\frac{C_2}{(1+IRR)^2}+\frac{C_3}{(1+IRR)^3}+...=0\\]

Excel: `=IRR(C₀:Cₙ)`

If IRR > CoC, invest in the project

If NPV and IRR contradict, NPV rule > IRR rule

Multiple IRRs may exist

- Ex: C₀=-100, C₁=230, C₂=-132; IRR=10% and/or 20%
- Hint: If signs switch multiple times, may have multiple IRRs

No IRRs may exist

- Ex: C₀=100, C₁=-300, C₂=230
- In this case, for any r, NPV is +ve, so invest

Ex 1

- Cost of Capital = 5%
- Project L(ending): C₀=-10m, C₁=11m → NPV +ve ✔️; IRR 10% ✔️ → invest
- Project B(orrowing): C₀=10m, C₁=-11m → NPV -ve ❌; IRR 10% ✔️ → don’t invest
- In this case, interest rate for L/B is 10% (i.e IRR), and alternative (CoC) is 5%

Ex 2

- CoC = 25%
- Small budget: C₀=-50m, C₀=80m; IRR = 60% ✔️✔️; NPV = 14m ✔️
- Large budget: C₀=-120m, C₀=180m; IRR = 50% ✔️; NPV = 24m ✔️✔️
- NPV > IRR, so invest in large budget

Ex 3

- CoC = 10%
- Long term: C₀=-100m, C₁=0, C₂=144m; IRR=20%; NPV=19
- Short term: C₀=-100m, C₁=121m, C₂=0; IRR=21%; NPV=10
- NPV > IRR, so invest in long term
- IRR is over single period, NPV is over all periods
- What about investing the $121M for an extra year? Ie. Invest the $121M  revenue from the first period, with the same IRR 21% for the short-term project. Which project is more attractive now? → Short term

### Profitability Index

\\[PI=\frac{NPV}{C_0}\\]

Prioritise project(s) with highest PI

### The Payback Rule

Payback period: how long to break even (i.e. when C₀ ≥ C₁ + C₂ + … + Cₙ)

Cut-off period: how long is allowed to break even

Invest if payback period < cut-off period

## Bonds

### Bond Basics

**********************Terminology**********************

- Face Value: final payment
- Maturity Date: when the face value is payable
- Coupon: regular payment, often annual but not always, can be zero (zero coupon bond)

\\[Coupon=\frac{Coupon\,rate \times face\,value}{Number\,of\,payments\,per\,year}\\]

- Bond certificate: states the above

Price expressed per $100 of value

**Markets**

- Primary Market: Issuer issues bonds
- Secondary Market: bonds are traded without Issuer

**US Bonds**

- T(reasury) bills: maturity ≤ 1 year (zero coupon)
- T(reasury) notes: maturity 1~10 years
- T(reasury) bonds: maturity > 10 years

**Ex:**

Buy $1000 (i.e. $100 x 10) face value bond (maturity = 1/1/2023; annual coupon rate = 3.7%) on secondary market today (1/1/2020) at $107.94

Bond price = $107.94 x 10 = $1079.40

Coupon = 3.7% x 100 / 1 = $37

Returns: $37 (1/1/2021) + $37 (1/1/2022) + $1037 (1/1/2023)

### Yield and Price

Yield (y) = annual return

Aka risk-free rate

\\[1079.40+\frac{37}{(1+IRR)^1}+\frac{37}{(1+IRR)^2}+\frac{1037}{(1+IRR)^3}=0\\]

IRR = 1%

\\[Bond\,price=\frac{Coupon}{(1+y)^1}+\frac{Coupon}{(1+y)^2}+...+\frac{Coupon+Face\,value}{(1+y)^T}\\]

Yield is variable (depends on bond price); coupon is fixed (as per bond certificate)

Bond price up, yield down (and vice versa)

Higher coupon will have higher bond price for the same yield

Yield > coupon rate (over face value): trading at a premium; yield < coupon rate: trading at a discount (under face value)

### STRIPS

\\[y_T=(\frac{100}{P})^\frac{1}{T}-1\\]

Ex: Price = 94.38; Years to maturity = 5

\\[y_T=(\frac{100}{94.38})^\frac{1}{5}-1=1.16\%\\]

### Yield Curve and Valuation

| Maturity | 1 | 2 | 3 |
| --- | --- | --- | --- |
| Price ($) | 98.52 | 96.12 | 93.00 |
| Yield | 1.50% | 2.00% | 2.45% |
| Year | 1 | 2 | 3 |
| Cash flow ($) | 4 | 4 | 104 |

\\[PV=\frac{4}{(1+0.015)^1}+\frac{4}{(1+0.02)^2}+\frac{104}{(1+0.025)^3}=104.51\\]

Ex: The yield of 1yr, 2yr, 3yr STRIP are 1%, 2%, 3%. Calculate the price of the coupon bond with face value of 100, coupon rate of 5%, annual payments, and maturity of 3 years.

\\[Price=\frac{5}{(1+0.01)^1}+\frac{5}{(1+0.02)^2}+\frac{100+5}{(1+0.03)^3}=105.85\\]

r = risk-free rate + risk premium

## Stocks

### Stock Prices

Revenue/dividents/earnings per share

\\[P_{year\,0}=\frac{DIV_{year\,1}+P_{year\,1}}{1+r_E}\\]

DIV should be easily obtainable based on previous dividends (i.e. previous year x growth)

r_E = opportunity cost of equity capital = cost of equity

\\[P_0=\frac{DIV_1}{1+r_E}+\frac{DIV_2}{(1+r_E)^2}+...+\frac{DIV_T}{(1+r_E)^T}+\frac{P_T}{(1+r_E)^T}\\]

Gordon (Constant Dividend) Growth Model 

\\[P_n=\frac{DIV_{n+1}}{r_E-g}\\]

\\[DIV_2=DIV_1(1+g)\\]

Ex: Stock pays $5 dividend per share annual forever. 5% cost of equity. Price = 5/(0.05) = $100

Ex: Dividend of $2.80 last period, expected growth 3%. 6.5% CoE. Price today? \\(\frac{2.8 \times 1.03}{0.063-0.03}=82.40\\)

\\[DIV_n=(1-b)EPS_n\\]

Retention ratio = b = profits kept to reinvest

RIR = Reinvesment rate of return

\\[g= b \times RIR\\]

Q: Firm A pays out 20% of its earnings as dividends and Firm B pays out 30% of its earnings as dividends. Both firms have the same return on investment. Which firm has higher growth rate? → Firm A retains more for investment and therefore has a higher growth rate than Firm B

| Company | A | B | C |
| --- | --- | --- | --- |
| EPS | 10 | 10 | 10 |
| r_E | 10% | 10% | 10% |
| b | 0 | 40% | 40% |
| RIR | N/A | 10% | 15% |
| DIV (calculated) | 10 | 6 | 6 |
| g (calculated) | 0% | 4% | 6% |
| P (calculated) | 100 | 100 | 150 |

If RIR < r_E, investing destroys value → better to pay higher dividends for shareholders to invest.

### Stock Returns

\\[r=\frac{P_1+DIV_1-P_0}{P_0}\\]

| Company | A | B | C |
| --- | --- | --- | --- |
| P₀ (from above) | 100 | 100 | 150 |
| r_E (provided) | 10% | 10% | 10% |
| g (from above) | 0% | 4% | 6% |
| DIV₁ (from above) | 10 | 6 | 6 |
| DIV₂ (calculated) | 10 | 6.24 | 6.36 |
| P₁ (calculated) | 100 | 104 | 105 |
| r (calculated) | 10% | 10% | 10% |

Firm C has higher dividend in future but more expensive today → return is priced in (hence r = r_E)

When the price is determined by the PV formula, the IRR equals the cost of capital.