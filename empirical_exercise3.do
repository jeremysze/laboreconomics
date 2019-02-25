
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

gen male = (female == 0)
label variable male "Male = 1"

gen employed = (empstat == 2)
label variable employed "Employed"

gen participation = (empstat == 2 | empstat == 3)
label variable participation "Participation: looking for employment or employed"

sum pweight
// The weights for each observation represents the number of individuals that this observation represent. 

tab grade

preserve
collapse (rawsum) pweight, by(year)
list
restore

global continous_var age 
global binary_var race_* hispanic married veteran 
gen pweight2 = 1
 


//Collapse by year
preserve
collapse (mean) employed participation hours $continous_var $binary_var ///
(rawsum) pweight2 [pweight = pweight] , by(year)

twoway line employed year || line participation year
graph export "..\outputs\ee3_participation_employment_rates_year.pdf",as(pdf) replace

line hours year if year > 1988
graph export "..\outputs\ee3_hours_year.pdf",as(pdf) replace
// From 1976 to 1988, hours of work was not recorded
restore

//Collapse by year and gender
preserve
collapse (mean) employed participation hours $continous_var $binary_var ///
(rawsum) pweight2 [pweight = pweight] , by(year female)

twoway line participation employed year if female == 1 || line participation employed year if female == 0, ///
legend(label(1 "Participation rate female") label(2 "Employment rate female") label( 3 "Participation rate male") label( 4 " Employment rate male"))
graph export "..\outputs\ee3_participation_employment_rates_year_gender.pdf",as(pdf) replace

twoway line hours year if female == 1 & year >= 1989 || line hours year if female == 0 & year >= 1989, ///
legend(label(1 "Hours female") label(2 "Hours male") )
graph export "..\outputs\ee3_hours_year_gender.pdf",as(pdf) replace
restore

//Collapse by year and race
preserve
collapse (mean) employed participation hours $continous_var $binary_var ///
(rawsum) pweight2 [pweight = pweight] , by(year race)

twoway line employed year if race == 1 || line employed year if race == 2, ///
legend(label(1 "Employment rate white") label(2 "Employment rate black") )
graph export "..\outputs\ee3_participation_employment_rates_year_race.pdf",as(pdf) replace

twoway line hours year if race == 1 & year >= 1989|| line hours year if race == 2 & year >= 1989, ///
legend(label(1 "Hours white") label(2 "Hours black") )
graph export "..\outputs\ee3_hours_year_race.pdf",as(pdf) replace
restore


//Collapse by year and grade
preserve
gen schooling = .
replace schooling = 1 if grade == 12
replace schooling = 2 if (grade >= 13 & grade <= 16)
replace schooling = 3 if grade > 16
label define schooling_ 1 "High school" 2 "College" 3 "Graduate"
label values schooling schooling_
drop if mi(schooling)

collapse (mean) employed participation hours $continous_var $binary_var ///
(rawsum) pweight2 [pweight = pweight] , by(year schooling)

twoway line employed year if schooling == 1 ///
|| line employed year if schooling == 2 ///
|| line employed year if schooling == 3, ///
legend(label(1 "Employment rate Highschool") label(2 "Employment rate College") label(3 "Employment rate Graduate") )
graph export "..\outputs\ee3_participation_employment_rates_year_schooling.pdf",as(pdf) replace

twoway line hours year if schooling == 1 & year >= 1989 ///
|| line hours year if schooling == 2 & year >= 1989 ///
|| line hours year if schooling == 3 & year >= 1989, ///
legend(label(1 "Hours Highschool") label(2 "Hours College") label(3 "Hours Graduate") )
graph export "..\outputs\ee3_hours_year_schooling.pdf",as(pdf) replace
restore
