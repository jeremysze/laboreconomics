
/****************************************************************************
* File name: empirical_exercise4.do
* Author(s): Sze, J.
* Date: 2/26/2019
* Description: 
* Answers to empirical exercise 4 for Labor Economics
*
* Inputs: 
* ..\input_data\Small CPS, 2018.dta" 
* 
* Outputs:
* 
***************************************************************************/
log using "..\log\empirical_exercise4", replace

use "..\input_data\Small CPS, 2018", clear

describe

gen rwage_hourly = rwage/hours
label variable rwage_hourly "Real hourly wages"
gen occupation_wt = 1
label variable occupation_wt "Occupation weights"


// Copy variable labels before collapse
 foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
		}
 }
collapse (mean) rwage_hourly hours (sum) occupation_wt ///
[pweight = weight], by(occupation)

// Attach the saved labels after collapse
 foreach v of var * {
	label var `v' "`l`v''"
 }
 
regress hours rwage_hourly [pweight = occupation_wt]
predict yhat

twoway scatter hours rwage_hourly [w=occupation_wt], msymbol(circle_hollow) ///
|| line yhat rwage_hourly 
graph export "..\outputs\ee4_wages_occupation.pdf",as(pdf) replace

twoway scatter hours rwage_hourly, mlabel(occupation) mlabsize(vsmall)  msize(vsmall) /// 
|| line yhat rwage_hourly
 
rvfplot
graph export "..\outputs\ee4_wages_occupation_residualplots.pdf",as(pdf) replace

gen lg_hours = log(hours)
label variable lg_hours "Log of hours"
gen lg_rwage_hourly = log(rwage_hourly)
label variable lg_rwage_hourly "Log of hourly real wages"

regress lg_hours lg_rwage_hourly [pweight = occupation_wt]
predict yhat2

twoway scatter lg_hours lg_rwage_hourly [w=occupation_wt], msymbol(circle_hollow) ///
|| line yhat2 lg_rwage_hourly 
graph export "..\outputs\ee4_lgwages_occupation.pdf",as(pdf) replace

rvfplot
graph export "..\outputs\ee4_lgwages_occupation_residualplots.pdf",as(pdf) replace

// How are the workweek and the hourly real wage related across occupations?
// There are occupations with higher real wages and higher work weeks. Higher wages are associated with higher workweeks

use "..\input_data\Small CPS, 2018", clear
gen rwage_hourly = rwage/hours
label variable rwage_hourly "Real hourly wages"
gen education_wt = 1
label variable education_wt "Education weights"

// Copy variable labels before collapse
 foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
		}
 }
 
// collapse to mean by grade
collapse (mean) rwage_hourly hours (sum) education_wt ///
[pweight = weight], by(grade)

// Attach the saved labels after collapse
 foreach v of var * {
	label var `v' "`l`v''"
 }
 
regress hours rwage_hourly [pweight = education_wt]
predict yhat

twoway scatter hours rwage_hourly [w=education_wt], msymbol(circle_hollow) ///
|| line yhat rwage_hourly ///
|| scatter hours rwage_hourly, mlabel(grade) mlabsize(vsmall)  msize(vsmall)  mcolor(none) mlabcolor(black)
graph export "..\outputs\ee4_wages_education.pdf",as(pdf) replace

rvfplot
graph export "..\outputs\ee4_wages_education_residualplots.pdf",as(pdf) replace

gen lg_hours = log(hours)
label variable lg_hours "Log of hours"
gen lg_rwage_hourly = log(rwage_hourly)
label variable lg_rwage_hourly "Log of hourly real wages"

regress lg_hours lg_rwage_hourly [pweight = education_wt]
predict yhat2

twoway scatter lg_hours lg_rwage_hourly [w=education_wt], msymbol(circle_hollow) ///
|| line yhat2 lg_rwage_hourly ///
|| scatter lg_hours lg_rwage_hourly, mlabel(grade) mlabsize(vsmall)  msize(vsmall)  mcolor(none) mlabcolor(black)
graph export "..\outputs\ee4_lgwages_education.pdf",as(pdf) replace

rvfplot
graph export "..\outputs\ee4_lgwages_education_residualplots.pdf",as(pdf) replace
//  How are the workweek and the hourly real wage related across grades?
/* This scatter plot also appear to show that the higher the education level, the longer the work week.*/
// The residual plot appears to show two groups of points. One grouping at the top and one grouping at the bottom.
// There might be other factors that are omitted. 
