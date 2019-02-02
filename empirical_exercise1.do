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
sum `i'
svy: mean `i'
}

tab rotation month


//  2 Compute Monthly Averages
gen mean_hours = hours
gen mean_wages = wage

gen med_hours = hours
gen med_wages = wage


collapse (mean) mean_hours mean_wages (median) med_hours med_wages [pweight = weight], by(month)

gen lg_mean_wages = log(mean_wages)
histogram mean_wages, normal
histogram lg_mean_wages, normal
/*
month	mean_hours	mean_wages	med_hours	med_wages
january	38.63593	1069.665	40	780
february	38.5434	1082.045	40	796
march	39.27905	1090.507	40	807.69
april	39.06295	1073.614	40	769.23
may	39.00831	1067.592	40	799.6
june	38.0636	1077.343	40	769.23
july	39.18089	1033.437	40	769.23
august	39.53587	1087.038	40	780
september	38.92412	1077.609	40	800
october	39.03193	1033.859	40	766
november	39.17056	1081.151	40	840
*/
