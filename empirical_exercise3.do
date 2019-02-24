
/****************************************************************************
* File name: empirical_exercise3.do
* Author(s): Sze, J.
* Date: 2/21/2019
* Description: 
* Answers to empirical exercise 3 for Labor Economics
*
* Inputs: 
* ..\input_data\Small CPS, 1976-2018.dta" 
* 
* Outputs:
* 
***************************************************************************/

use "..\input_data\Small CPS, 1976-2018.dta", clear

describe

list age female race in 1/5

list age female race in 1/5,nolabel

sum age female hispanic married 
sum age female hispanic married [aweight = pweight]

tab1 race region metro

tab year female 
tab year race 
tab year empstat 

tab race
tab race, gen(race_)
des race_*

tab hispanic
tab hispanic,nolabel
recode hispanic (2=1)
label define hispanic_ 0 "Not Hispanic" 1 "Hispanic:Mexican/other"
label values hispanic hispanic_

tab class empstat,m
codebook class empstat
tab empstat
tab empstat, nolabel
* NILF : not in the labor force 
* the labor force is made up of the employed 
* and the unemployed. The remainder—those who have no job and are not 
* looking for one—are counted as not in the labor force.

* The labor force participation rate. This measure is the number of people in the labor force as a percentage of the civilian noninstitutional population 16 years old and over. In other words, it is the percentage of the population that is either working or actively seeking work.

gen employed = (empstat == 2)
label variable employed "Employed"

gen participation = (empstat == 2 | empstat == 3)
label variable participation "Participation: looking for employment or employed"

codebook hours
// 25,224 missing
replace hours = 0 if mi(hours)

sum pweight
// The weights for each observation represents the number of individuals that this observation represent. 

preserve
collapse (rawsum) pweight, by(year)
list
restore

global continous_var age hours grade
global binary_var female race_* hispanic married veteran employed participation
gen pweight2 = 1

preserve
// Copy variable labels before collapse
 foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
		}
 }

collapse (mean) $continous_var $binary_var ///
(rawsum) pweight2 [pweight = pweight] , by(year)

// Attach the saved labels after collapse
 foreach v of var * {
	label var `v' "`l`v''"
 }
 
twoway line employed year || line participation year
graph export "..\outputs\ee3_participation_employment_rates_year.pdf",as(pdf) replace

line hours year
graph export "..\outputs\ee3_hours_year.pdf",as(pdf) replace
graph close
// From 1976 to 1988, hours of work was not recorded
restore

global continous_var age hours grade
global binary_var race_* hispanic married veteran employed participation

preserve
// Copy variable labels before collapse
 foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
		}
 }

collapse (mean) $continous_var $binary_var ///
(rawsum) pweight2 [pweight = pweight] , by(female)

// Attach the saved labels after collapse
 foreach v of var * {
	label var `v' "`l`v''"
 }
 
twoway line employed female || line participation female
graph export "..\outputs\ee3_participation_employment_rates_female.pdf",as(pdf) replace

line hours female
graph export "..\outputs\ee3_hours_female.pdf",as(pdf) replace
graph close
// From 1976 to 1988, hours of work was not recorded
restore

