
clear all
capture log close /*close any log file*/
set more off
log using tutorial1log.log, replace /*creat a log file*/
use tutorial1, clear


** update and install ssc package **
/*
update query
ssc install egenmore  // install ssc package - egenmore
*/

** ask for help **
help reg
search ols
findit esttab
hsearch ols


*********************
** data management **
*********************

** know your data **
des

codebook totexp, detail/*missing value can be seen*/
sum totexp, detail/*percentile*/
sort totexp/*ascending order*/
count if totexp <= 0
list totexp if _n >= _N-9/*3064-9*/
list totexp in -10/-1/*only list the last 10*/
tabstat totexp if age == 65 | age == 75, by(age) statistics(mean n sd p50)
table age if age <= 70 & age != 67, content(mean totexp sd totexp med totexp)

gsort -educyr +age/*negative descending, positive ascending*/

** manipulate variables **
replace totexp = . if totexp <= 0
rename dupersid ID
label variable ID "observation ID"/*try command describe*/

rename female gender
label define glab 0 "male" 1 "female"/*creates the value label called foreignl that associates 0 with */
label values gender glab/*link two labels*/

bysort age: egen avg_inc = mean(income)/*get mean in one group*/
* average income for each age group

** watch missing values **
gen linc = log(income)
codebook income, detail
count if income <= 0
* 88 samples with income <= 0
drop if income <= 0

** create dummy variables **
xi i.age i.age*gender

** drop/keep variables/obs **
keep if age <= 85
keep if totexp != 0 
drop year03 _Iage_66-_Iage_90 _IageX*/*drop variable*/
keep ltotexp linc suppins phylim totchr educyr marry white hisp/*
  */ ID income injury age gender
  
** control do-file execution **

forvalues d = 0/1 {
tabulate marry phylim if gender == `d', chi2
}
* twoway cross-table

foreach t in 65 70 75 {
table marry phylim gender if age == `t'
}
* three-way cross table

preserve/*guarantee data will be stored after termination*/
collapse (mean) ltotexp linc, by(gender)/*in gender group,get mean,turn to browser*/
saveold avgdata, replace/*save stata 10 into stata 9*/
restore/*restore data now*/


***************************
** graph display of data **
***************************

hist ltotexp, bin(50) kdensity/*estimate kernel*/

kdensity ltotexp, normal

scatter ltotexp linc, by(gender marry)

graph matrix ltotexp linc age, by(gender)

graph twoway (scatter ltotexp linc if age >= 75)/*
           */(lfit ltotexp linc if age >= 75),/*
		   */ title("log health expense and log income, age>=75")/*
		   */ legend(off) 

graph export fig1.png, replace


*********************************************
** estimation and post-estimation commands **
*********************************************

reg ltotexp linc suppins phylim totchr educyr marry white hisp

predict yhat, xb/*xb means linear*/
test linc = 0
estat vce/*covariance matrix*/
estat summarize
estimates store samplereg
estimates restore samplereg
estimates clear

* save dis1data1, replace
log close
