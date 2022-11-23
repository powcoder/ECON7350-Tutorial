
clear
capture log close
set more off
cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"
log using tutorial4.log, replace

* first install package "ardl"

import delimited wealth, clear

encode obs, gen(t)
tsset t

** (a) **
twoway line ct t, xlabel(1(50)200, valuelabel)
twoway line at t, xlabel(1(50)200, valuelabel)
twoway line yt t, xlabel(1(50)200, valuelabel)

corrgram ct, lag(20)
corrgram at, lag(20)
corrgram yt, lag(20)


** (b) **
forvalues p = 1(1)2 {
forvalues q = 1(1)2 {
forvalues m = 1(1)2 {
quietly ardl ct at yt, lags(`p' `q' `m') tr(t) 
display "For ARDL model with (p,q,m) = " "(`p',`q',`m')"
estat ic
}
}
}

ardl ct at yt, maxlags(2 2 2) tr(t) bic
estat ic


** (c) **
ardl ct at yt, lags(1 2 2) tr(t) ec1


log close
