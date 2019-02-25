
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

gen employed_female = (empstat == 2 & female == 1)
label variable employed_female "Employed and female"

gen employed_male = (empstat == 2 & female == 0)
label variable employed_male "Employed and male"

gen employed_race_1 = (empstat == 2 & race == 1)
label variable employed_race_1 "Employed and white"

gen employed_race_2 = (empstat == 2 & race == 2)
label variable employed_race_2 "Employed and black"

gen employed_race_3 = (empstat == 2 & race == 3)
label variable employed_race_3 "Employed and indian"

gen employed_race_4 = (empstat == 2 & race == 4)
label variable employed_race_4 "Employed and asian/PacIslander"

gen employed_race_5 = (empstat == 2 & race == 5)
label variable employed_race_5 "Employed and other"

gen participation = (empstat == 2 | empstat == 3)
label variable participation "Participation: looking for employment or employed"

gen participation_female = (empstat == 2 | empstat == 3) & (female == 1)
label variable participation_female "Participation: looking for employment or employed and female"

gen participation_male = (empstat == 2 | empstat == 3) & (female == 0)
label variable participation_male "Participation: looking for employment or employed and male"

gen participation_race_1 = (empstat == 2 | empstat == 3) & (race == 1)
label variable participation_race_1 "Participation: looking for employment or employed and white"

gen participation_race_2 = (empstat == 2 | empstat == 3) & (race == 2)
label variable participation_race_2 "Participation: looking for employment or employed and black"

gen participation_race_3 = (empstat == 2 | empstat == 3) & (race == 3)
label variable participation_race_3 "Participation: looking for employment or employed and indian"

gen participation_race_4 = (empstat == 2 | empstat == 3) & (race == 4)
label variable participation_race_4 "Participation: looking for employment or employed and asian/PacIslander"

gen participation_race_5 = (empstat == 2 | empstat == 3) & (race == 5)
label variable participation_race_5 "Participation: looking for employment or employed and other"

codebook hours
// 25,224 missing
replace hours = 0 if mi(hours)

gen hours_female = hours if (female == 1)
label variable hours_female "hours and female"

gen hours_male = hours if (female == 0)
label variable hours_male "hours and male"

gen hours_race_1 = hours if (race == 1)
label variable hours_race_1 "hours and white"

gen hours_race_2 = hours if (race == 2)
label variable hours_race_2 "hours and black"

gen hours_race_3 = hours if (race == 3)
label variable hours_race_3 "hours and indian"

gen hours_race_4 = hours if (race == 4)
label variable hours_race_4 "hours and asian/PacIslander"

gen hours_race_5 = hours if (race == 5)
label variable hours_race_5 "hours and other"


sum pweight
// The weights for each observation represents the number of individuals that this observation represent. 

preserve
collapse (rawsum) pweight, by(year)
list
restore

global continous_var age  grade
global binary_var male female race_* hispanic married veteran
global employment_var employed_female employed_male employed_race_1 employed_race_2 employed_race_3 employed_race_4 employed_race_5 
global participation_var participation participation_female participation_male participation_race_1 participation_race_2 participation_race_3 participation_race_4 participation_race_5
global hours_var hours hours_female hours_male hours_race_1 hours_race_2 hours_race_3 hours_race_4 hours_race_5
gen pweight2 = 1


// Copy variable labels before collapse
 foreach v of var * {
 	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
		}
 }

collapse (mean) employed participation $continous_var $hours_var ///
(sum) $binary_var $employment_var $participation_var ///
(rawsum) pweight2 [pweight = pweight] , by(year)

// Attach the saved labels after collapse
 foreach v of var * {
	label var `v' "`l`v''"
 }
 
twoway line employed year || line participation year
graph export "..\outputs\ee3_participation_employment_rates_year.pdf",as(pdf) replace

line hours year if year > 1988
graph export "..\outputs\ee3_hours_year.pdf",as(pdf) replace
// From 1976 to 1988, hours of work was not recorded

gen employment_rate_female = employed_female/female
gen employment_rate_male = employed_male/male
gen participation_rate_female = participation_female/female
gen participation_rate_male = participation_male/male

twoway line participation_rate_female employment_rate_female year || line participation_rate_male employment_rate_male year
graph export "..\outputs\ee3_participation_employment_rates_year_gender.pdf",as(pdf) replace

twoway line hours_female year if year > 1988 || line hours_male year if year > 1988
graph export "..\outputs\ee3_hours_year_gender.pdf",as(pdf) replace

gen employment_rate_white = employed_race_1/race_1
gen employment_rate_black = employed_race_2/race_2
gen employment_rate_indian = employed_race_3/race_3
gen employment_rate_asianpacisld = employed_race_4/race_4
gen employment_rate_other = employed_race_5/race_5

gen participation_rate_white = participation_race_1/race_1
gen participation_rate_black = participation_race_2/race_2
gen participation_rate_indian = participation_race_3/race_3
gen participation_rate_asianpacisld = participation_race_4/race_4
gen participation_rate_other = participation_race_5/race_5


twoway line employment_rate_white employment_rate_black year
graph export "..\outputs\ee3_participation_employment_rates_year_race.pdf",as(pdf) replace

twoway line hours_race_1 hours_race_2 hours_race_3 hours_race_4 hours_race_5 year if year > 1988
graph export "..\outputs\ee3_hours_year_race.pdf",as(pdf) replace
