/****************************************************************************
* File name: empirical_exercise1.do
* Author(s): 
* Date: 
* Description: 
* 
*
* Inputs: 
* ..\input_data\Small CPS, 2018.dta" 
* 
* Outputs:
* 
***************************************************************************/

use "..\input_data\Small CPS, 2018.dta",clear

// 1 Explore the data
codebook  idcode
	// 11,000 unique ids

describe 
histogram age
graph close
sum age
tab1 age female race hispanic married veteran region state metro size grade public union topcode

tab female union
tab female public
tab female grade


list in 1/5

sum weight
// no negative values

svyset [pweight = weight]

sum age
svy: mean age

sum female
svy: mean female

global list age female  married veteran hours rwage wage hours
foreach i of global list {
di _newline(2) "`i'"
mean `i'
svy: mean `i'
}

tab rotation month


//  2 Compute Monthly Averages

forvalues i = 1/11 {
di _newline(2) "month `i'"
mean wage if month == `i'
svy: mean wage if month == `i'
mean hours if month == `i'
svy: mean hours if month == `i'
}

preserve

gen mean_hours = hours
gen mean_wages = wage
gen p50_hours = hours
gen p50_wages = wage
gen p90_wages = wage
gen p10_wages = wage


collapse (mean) mean_hours mean_wages ///
(p50) p50_hours p50_wages ///
(p10) p10_wages ///
(p90) p90_wages ///
[pweight = weight], by(month)

gen lg_mean_wages = log(mean_wages)
histogram mean_wages, normal
histogram lg_mean_wages, normal

