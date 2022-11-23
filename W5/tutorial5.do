
clear
capture log close
set more off
cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 5"
log using tutorial5.log, replace

import delimited usdata, clear

encode obs, gen(t)
tsset t

*** 1 ***
** (a) **
tsline ffr

** (b) **
dfuller ffr, trend lags(2) reg
dfuller ffr, drift lags(2) reg
dfuller ffr, nocon lags(2) reg

** (c) **
gen Dffr = D.ffr
corrgram Dffr, lag(20)

sum ffr
gen dmffr = ffr - 0.05705
corrgram ffr, lag(20)
corrgram gdp, lag(20)

reg Dffr t L.ffr L.Dffr L2.Dffr
test (L.ffr = 0) (t = 0) 

test (L.ffr = 0) (t = 0) (_cons=0)

reg Dffr L.ffr L.Dffr L2.Dffr
test _cons=0
test L.ffr=0

** (d) **
* arima(1,1,1), arima(2,1,1), arima(1,1,2)
dfuller Dffr, drift lags(2) reg
dfuller Dffr, nocon lags(2) reg

** (e) **
* choose arima(1,1,1)
arima ffr, arima(1, 1, 1)
estat ic
predict ehat1, res
corrgram ehat1, lag(20)

arima ffr, arima(2, 1, 1)
estat ic
predict ehat2, res
corrgram ehat2, lag(20)

arima ffr, arima(1, 1, 2)
estat ic
predict ehat3, res
corrgram ehat3, lag(20)


*** 2 ***
** (a) **
tsline gdp

** (b) **
dfuller gdp, trend lags(2) reg
dfuller gdp, drift lags(2) reg
dfuller gdp, nocon lags(2) reg

gen Dgdp = D.gdp
gen Lgdp = L.gdp
reg Dgdp t Lgdp
* phi3 test 
test (t=0) (Lgdp=0)

* phi2 test
test (t=0) (Lgdp=0) (_cons=0)

** (c) **
corrgram Dgdp, lag(20)

** (d) **
* arima(0,1,1), arima(0,1,2), arima(1,1,2)
* no need to test equation 1
dfuller Dgdp, drift lags(2) reg
dfuller Dgdp, nocon lags(2) reg

** (e) **
* choose arima(0,1,2)
arima gdp, arima(0, 1, 1)
estat ic
predict ehat4, res
corrgram ehat4, lag(20)

arima gdp, arima(0, 1, 2)
estat ic
predict ehat5, res
corrgram ehat5, lag(20)

arima gdp, arima(1, 1, 2)
estat ic
predict ehat6, res
corrgram ehat6, lag(20)


*** 3 ***
** (a) **
tsline cpi

** (b) **
dfuller cpi, trend lags(2) reg
dfuller cpi, drift lags(2) reg
dfuller cpi, nocon lags(2) reg

** (c) **
gen Dcpi = D.cpi
corrgram Dcpi, lag(20)

** (d) **
* arima(0,2,2), arima(1,2,2), arima(2,2,2)
dfuller Dcpi, drift lags(2) reg
dfuller Dcpi, nocon lags(2) reg
corrgram D2.cpi, lag(20)

** (e) **
* choose arima(2,2,2)
arima cpi, arima(0, 2, 2)
estat ic
predict ehat7, res
corrgram ehat7, lag(20)

arima cpi, arima(1, 2, 2)
estat ic
predict ehat8, res
corrgram ehat8, lag(20)

arima cpi, arima(2, 2, 2)
estat ic
predict ehat9, res
corrgram ehat9, lag(20)

log close
