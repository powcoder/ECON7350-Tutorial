
clear
capture log close
set more off
log using tutorial3.log, replace

** (a) **
import delimited Merck, clear

keep date adjclose  
rename adjclose y

encode date, gen(t)
tsset t

gen datevar = date(date, "YMD")  
format datevar %td  
keep if datevar <= td(31dec2012) & datevar >= td(01jan2011)
gen y2011 = datevar <= td(31dec2011) & datevar >= td(01jan2011)
gen y2012jan = datevar <= td(31jan2012) & datevar >= td(03jan2012)
drop date datevar
drop if y2011 == 0 & y2012jan == 0
des


** (b) **
gen Dy = D.y
gen r = log(y/L.y)

label variable y "Stock Prices of Merck (MRK)"  
label variable Dy "Changes in Stock Prices" 
label variable r "Log Returns" 


** (c) **
sum t
twoway line y t if y2011 == 1, xlabel(2520(105)2780, valuelabel)
twoway line Dy t if y2011 == 1, xlabel(2520(105)2780, valuelabel)


** (d) **
ac y if y2011 == 1
pac y if y2011 == 1

ac Dy if y2011 == 1
pac Dy if y2011 == 1

corrgram y if y2011 == 1
corrgram Dy if y2011 == 1


** (e)+(f) **
arima Dy if y2011 == 1, arima(1,0,1)
estat ic

arima Dy if y2011 == 1, arima(1,0,2)
estat ic

arima Dy if y2011 == 1, arima(2,0,1)
estat ic

arima Dy if y2011 == 1, arima(2,0,2)
estat ic


** (g) **
quietly arima y if y2011 == 1, arima(1,1,1)
predict ehat, res
twoway line ehat t if y2011 == 1, xlabel(2520(105)2780, valuelabel)
corrgram ehat

* critical values k = 3,...,10
forvalues k = 3(1)10 {
display invchi2(`k'-1-1, 0.95)
}

* test: compare Q-statistics with critical values, 1-reject, 0-not reject
forvalues k = 3(1)10 {
display r(q`k') > invchi2(`k'-1-1, 0.95)
}


** (h) **
predict yhat if y2012jan == 1, y
tsline y yhat if y2012jan == 1, xlabel(2768(10)2785, valuelabel)


** (i) **
twoway line y t if y2011 == 1, xlabel(2520(105)2780, valuelabel)
twoway line r t if y2011 == 1, xlabel(2520(105)2780, valuelabel)

ac r if y2011 == 1
pac r if y2011 == 1
corrgram r if y2011 == 1

arima r if y2011 == 1, arima(1,0,1)
estat ic

arima r if y2011 == 1, arima(1,0,2)
estat ic

arima r if y2011 == 1, arima(2,0,1)
estat ic

arima r if y2011 == 1, arima(2,0,2)
estat ic

quietly arima r if y2011 == 1, arima(1,0,1)
predict ehat2, res
twoway line ehat2 t if y2011 == 1, xlabel(2520(105)2780, valuelabel)
corrgram ehat2

* test: compare Q-statistics with critical values, 1-reject, 0-not reject
forvalues k = 3(1)10 {
display r(q`k') > invchi2(`k'-1-1, 0.95)
}

predict rhat, y
tsline r F.rhat if y2012jan == 1, xlabel(2768(10)2785, valuelabel)

log close
