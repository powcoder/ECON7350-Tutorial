
clear
capture log close
set more off
log using tutorial1.log, replace

** Question 1 **

import delimited cps98, clear 

sum 

tab age 
tabstat age, stat(n mean sd med) 

tab female bachelor 

hist ahe, kdensity 

sum ahe if female == 1 
sum ahe if female == 0

sum if ahe > 40
sum if ahe < 3

gen ahe2 = ahe*ahe 

scatter ahe2 ahe, title("Ahe2") 
scatter ahe2 ahe, title("Ahe2") xlabel(0(2)50) ylabel(0(1000)3000)

pwcorr ahe age 
corr ahe age

pwcorr ahe age if ahe > 40
pwcorr ahe age if ahe < 3


** Question 2 **

use fultonfish, clear 

des 
codebook lprice quan lquan 

sum quan, detail 

dis abs(sqrt(111)*(6334.667 - 7200)/4040.12) 

dis 6334.667 - 1.96*4040.12/sqrt(111)
dis 6334.667 + 1.96*4040.12/sqrt(111)

scatter lprice lquan || lfit lprice lquan  
scatter lprice lquan || qfit lprice lquan

export excel using fultonfish.xlsx, replace 


** Question 3 **

import delimited gld, clear

keep date adjclose  
rename adjclose goldprice  

gen t = date(date, "YMD")  
format t %td  

tsset t  

list date goldprice if tin(01dec2004, 10dec2004)  
list date goldprice if twithin(01dec2004, 10dec2004)

encode date, gen(time) 
tsset time

list date goldprice if t <= td(10dec2004) & t >= td(01dec2004) 
list date goldprice if t < td(10dec2004) & t > td(01dec2004)

gen goldpriceL1 = L1.goldprice  
gen goldpriceL2 = L2.goldprice

gen goldpriceF1 = F1.goldprice
gen goldpriceF2 = F2.goldprice

gen goldpriceD1 = D1.goldprice
gen goldpriceD1_2 = goldprice - L.goldprice

gen goldpriceD2 = D2.goldprice
gen goldpriceD2_2 = (goldprice - goldpriceL1) - (L.goldprice - L2.goldprice)

label variable goldprice "Gold Prices"  
twoway line goldprice time, xlabel(1(800)3529, valuelabel)  

log close

