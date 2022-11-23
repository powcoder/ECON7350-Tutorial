**** ECON7350 Tutotial 1 ****

****************       Question 1       *******************

* Import cps98.cvs

import delimited "/Users/apple/Desktop/ECON7350/ECON7350 Tutorial/W1/cps98.csv", clear

sum

* avg ahe = 13.95815; sd ahe = 6.904507.
* avg age = 29.71088; min age = 25, max age = 34.

count if female == 0
* 3461 male workers took the survey.

tab age 
* mode = 30 years old (with 643 freq.).

tabstat age, stat(n mean sd med)
* median = 30 years old (p50 = 30).

hist ahe
hist ahe, kdensity
* kdensity: a way to insert a line at mean(x) using -twoway.

sum ahe if female == 1
* avg ahe female = 12.76118.

sum ahe if female == 0
* avg ahe male =  14.80547.

sum if ahe > 40
count if ahe > 40 & female == 1
count if ahe > 40 & female == 0
count if ahe > 40 & bachelor == 1
count if ahe > 40 & bachelor == 0
* the top earners' obs: 25.
* the top earners' age: mean = 30.24, min = 25, max = 24.
* the top earners' gender: 5 female and 20 male.
* the top earners' education level: 21 people has bachelor degree, 4 people don't.

sum if ahe < 3
count if ahe < 3 & female == 1
count if ahe < 3 & female == 0
count if ahe < 3 & bachelor == 1
count if ahe < 3 & bachelor == 0
* earners ahe <3 obs: 33
* earners ahe <3 age: mean =  29, min = 25, max = 34.
* earners ahe <3' gender: 13 female,  20 male.
* earners ahe <3 education level: 7 people has bachelor degree, 26 people don't.

gen ahe2 = ahe*ahe

scatter ahe2 ahe, title("Ahe2")
scatter ahe2 ahe, title("Ahe2") xlabel(0(2)50) ylabel(0(1000)3000)

* pwcorr: Display all pairwise correlation coefficients
pwcorr ahe age





*******************     Question 2    *********************
* import the data to stata
use "/Users/apple/Desktop/ECON7350/ECON7350 Tutorial/W1/fultonfish.dta", clear

* generate a data descroption (describe -- Describe data in memory or in file)
des

* using codebook to describe data contents
codebook lprice quan  lquan

* compute sample mean and standard deviation of quan (the quantity sold)
sum quan, detail
* sample mean = 6334.667; sd =  4040.12

* test the hypothesis
* (1) Null hypothesis and alternative hypothesis:
*     H0: mean = 7200
*     H1: mean != 7200

* (2) decision rule: 
*     reject null hypothesis if Z <= -Z(1/2 alpha) or Z >= Z(1/2 alpha)
*     - Z2.5 = -1.96 and Z2.5 = 1.96.

* (3) test statistic: Z test
*     test statistic Z0 =
*     = abs(squr(n)*(sample mean - mean of expectation)/std.dev of population)
      dis abs(sqrt(111)*(6334.667 - 7200)/ 4040.12)
*     test statititc Z0 = 2.2565787
*     dis = isplay strings and values of scalar expressions
*     abs = the absolute value of x

* (4) decision: reject H0 ( 2.2565787 > 1.96)

* (5) statistical conclusion: 
*     Since the result reject the null hypothesis, we have 95% of confidence to 
*     conclude that there has sufficient evidence to support that the quantity 
*     sold is not equal to 7200.

* construct the 95% confidence interval 
dis 6334.667 - 1.96*4040.12/sqrt(111)
dis 6334.667 + 1.96*4040.12/sqrt(111)

* plot lprice lquan
* lfit is an out-of-date command as of Stata 9.  lfit has been replaced with 
*     the estat gof command
* estat gof -- Pearson or Hosmer-Lemeshow goodness-of-fit test
* graph twoway qfit -- Twoway quadratic prediction plots
scatter lprice lquan || lfit lprice lquan  
scatter lprice lquan || qfit lprice lquan

* export excel to save data
export excel using "fultonfish prac.xlsx", replace


**************     Question 3    *************
import delimited "/Users/apple/Desktop/ECON7350/ECON7350 Tutorial/W1/gld.csv", clear

keep date adjclose

rename adjclose goldprice

* analysis time series data
* YMD -- year, month, day
* %td -- convenience function to make typing dates in expressions easier
*        For example, typing td(2jan1960) is equivalent to typing 1.
gen t = date(date, "YMD")
format t %td

* to declare the data as time series
* tsset -- declare data to be time-series data
tsset t 
* list gold price from Dec 1, 2004 to Dec 10, 2004
*tin(t1,t2) -- "times in", from t1 to t2
list date goldprice if tin(01dec2004, 10dec2004)
* list gold price within Dec 1, 2004 - Dec 10, 2004
* twithin(t1,t2) -- "times within", between t1 and t2
list date goldprice if twithin(01dec2004, 10dec2004)

* create a continuous time trend
encode date, gen(time)
tsset time

* generate variables with past values
gen goldpriceL1 = L1.goldprice
gen goldpriceL2 = L2.goldprice

* generate variables with future values
gen goldpriceF1 = F1.goldprice
gen goldpriceF2 = F2.goldprice

* generate vatiables to calculate the difference between current and past values
gen goldpriceD1 = D1.goldprice
gen goldpriceD1_2 = goldprice - L.goldprice

gen goldpriceD2 = D2.goldprice
gen goldpriceD2_2 = (goldprice - goldpriceL1) - (L.goldprice - L2.goldprice)

* draw time series plot
label variable goldprice "Gold Prices"
twoway line goldprice time, xlabel(1(800)3529, valuelabel)

log close

