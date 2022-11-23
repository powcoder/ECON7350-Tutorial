
clear
capture log close
set more off
cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 7"
log using tutorial7log.log, replace

import delimited cwb, clear
gen t = _n
tsset t

** 1 **
* (a) *
tsline y
corrgram y, lag(20)

* (b) *
dfuller y, trend lags(2) reg
reg D.y L.y t L.D.y L2.D.y
test (L.y = 0) (t = 0)
dfuller y, drift lags(2) reg
dfuller y, nocon lags(2) reg

* (c) *
gen lr = log(y/L.y)
tsline lr
corrgram lr, lag(20)
dfuller lr, trend lags(2) reg
dfuller lr, drift lags(2) reg
dfuller lr, nocon lags(2) reg 

* choose ARMA(1,1)
arima lr, arima(1,0,0)
estat ic
arima lr, arima(0,0,1)
estat ic
arima lr, arima(1,0,1)
estat ic
arima lr, arima(1,0,2)
estat ic

* (d) *
quietly arima lr, arima(1,0,1)
predict ehat, res
gen ehat2 = ehat^2
tsline ehat2
corrgram ehat2, lag(20)
corrgram ehat, lag(20)

* (e) *
reg ehat2 L.ehat2
dis e(N)*e(r2) > invchi2(1, 0.95)
reg ehat2 L.ehat2 L2.ehat2
dis e(N)*e(r2) > invchi2(2, 0.95)
reg ehat2 L.ehat2 L2.ehat2 L3.ehat2
dis e(N)*e(r2) > invchi2(3, 0.95)
reg ehat2 L.ehat2 L2.ehat2 L3.ehat2 L4.ehat2
dis e(N)*e(r2) > invchi2(4, 0.95)

* (f) *
* choose ARMA(1,1)-GARCH(1,1)
arch lr, arima(1,0,1) arch(1) 
estat ic
arch lr, arima(1,0,1) arch(1,2) 
estat ic
arch lr, arima(1,0,1) arch(1) garch(1)
estat ic
arch lr, arima(1,0,1) arch(1,2) garch(1)
estat ic
arch lr, arima(1,0,1) arch(1) garch(1,2)
estat ic

* (g) *
* one-step ahead forecasting
arch lr, arima(1,0,1) arch(1) garch(1)
predict hhat, var

* do forecasting manually
predict e, res
dis 5.53*10^(-6) + 0.0978173*0.0035363^2 + 0.8633969*0.0001274


** 2 **

import delimited exrates_daily, clear
gen t = _n
tsset t
keep t aust

* (a) *
tsline aust
corrgram aust, lag(20)

* (b) *
dfuller aust, trend lags(2) reg
reg D.aust L.aust t L.D.aust L2.D.aust
test (L.aust = 0) (t = 0)
dfuller aust, drift lags(2) reg
dfuller aust, nocon lags(2) reg

* (c) *
gen lraust = log(aust/L.aust)
tsline lraust
corrgram lraust, lag(20)
dfuller lraust, trend lags(2) reg
dfuller lraust, drift lags(2) reg
dfuller lraust, nocon lags(2) reg 

* choose ARMA(1,1)
arima lraust, arima(1,0,0)
estat ic
arima lraust, arima(0,0,1)
estat ic
arima lraust, arima(1,0,1)
estat ic
arima lraust, arima(1,0,2)
estat ic

* (d) *
quietly arima lraust, arima(1,0,1)
predict ehat, res
gen ehat2 = ehat^2
tsline ehat2
corrgram ehat2, lag(20)
corrgram ehat, lag(20)

* (e) *
reg ehat2 L.ehat2
dis e(N)*e(r2) > invchi2(1, 0.95)
reg ehat2 L.ehat2 L2.ehat2
dis e(N)*e(r2) > invchi2(2, 0.95)
reg ehat2 L.ehat2 L2.ehat2 L3.ehat2
dis e(N)*e(r2) > invchi2(3, 0.95)
reg ehat2 L.ehat2 L3.ehat2 L3.ehat2 L4.ehat2
dis e(N)*e(r2) > invchi2(4, 0.95)

* (f) *
* choose ARMA(1,1)-GARCH(1,1)
quietly arch lraust, arima(1,0,1) arch(1) 
estat ic
quietly arch lraust, arima(1,0,1) arch(1,2) 
estat ic
quietly arch lraust, arima(1,0,1) arch(1) garch(1)
estat ic
quietly arch lraust, arima(1,0,1) arch(1,2) garch(1)
estat ic
quietly arch lraust, arima(1,0,1) arch(1) garch(1,2)
estat ic

arch lraust, arima(1,0,1) arch(1) garch(1)

log close
