/*
Day 2: Some Stata basics with data

Sometimes you will want to retain a record of the screen output from running your do files. How would you go about
doing this? Well, Stata has a "log" command that will allow you to save window output. Let's give it a try.

First, let's set a path for where you want the file to show up. Set it up in any directory on your computer.
*/

global path "/Volumes/HD1/Google Drive/Programming Course/Day 3"
local path "/Volumes/HD1/Google Drive/Programming Course/Day 3"


log using "$path/test_log.txt", replace text
log off

display "Hello, World!"
log on
log close

/*
Importing data

Stata has the ability to import many different types of datasets including SAS files, fixed-width text files,
delimited text files, and Excel files. We will try a few of these formats below:
*/



// Basic Excel file 

import excel using "`path'/US_Policy_Uncertainty_Data.xlsx", clear

browse

// How do we get the date columns to show up as numeric?

import excel using "$path/US_Policy_Uncertainty_Data.xlsx", clear firstrow

browse

// The year still isn't converting. What's going on?

import excel using "$path/US_Policy_Uncertainty_Data.xlsx", clear first cellrange(:D404)

browse

destring Year, replace // Replaces the imported string as an integer


// Basic comma separated files

import delimited using "$path/25_Portfolios_5x5_Daily.CSV", clear

browse

// It looks like we have some work to do. Open the file in Excel to assess how we can import the value-weighted returns

import delimited using "$path/25_Portfolios_5x5_Daily.CSV", clear rowrange(19:24305) 

browse


// Let's make the first row of the import be the names of the variables

import delimited using "$path/25_Portfolios_5x5_Daily.CSV", clear rowrange(19:24305) varnames(19)

browse

// We need to rename "v1" as date since the underlying CSV file did not assign the date field a names

rename v1 date

browse

tostring date, replace

generate date2=date(date, "YMD")

format date2 %td
order date date2

// Fixed-width data. Let's try to import an EDGAR index file 

infix 11 first 1 lines str companyname 1-62 str form_type 63-74 str cik 75-86 str file_date 87-96 str file_path 99-141  using "$path/company20204.idx", clear

browse

/*
Now let's turn our attention to some basic tasks within Stata for data manipulation. Let's first grab some
Compusta data from WRDS.
*/

#delimit ;

odbc load, clear dsn(wrds) exec("
	select gvkey, datadate, datafmt, indfmt, consol, popsrc, at, revt, ni, dltt, dlc
	from comp.funda");
	
#delimit cr

browse

// Keep only unique firm-year obsservations

// &, |, !, ~, ==, >=, >, <=, <

keep if datafmt=="STD" & indfmt=="INDL" & consol=="C" & popsrc=="D"

browse

// Drop observations where there is missing numeric data. We can use the missing() function for this task.

drop if missing(at,revt,ni,dltt,dlc)


// Calculate leverage and profit margin ratios

generate leverage=(dltt+dlc)/at 
generate profit_margin=ni/revt

// Stata is case-sensitive so the following would be unique variables:

gen Leverage=(dltt+dlc)/at 
gen Profit_Margin=ni/revt

// As is the following:

gen LEVERAGE=(dltt+dlc)/at 
gen PROFIT_MARGIN=ni/revt 


/*
The main function for creating variables in Stata is "generate" which can be abbreviated to "gen" when used in code.
You can use various functions and mathematical operators to define what you want.

There is also an "extended" generate command called "egen" which allows some helpful operations. Suppose
that you want calculate a year-adjusted profitability measure. How could you do that?
*/

gen year=year(datadate)

egen avg_profit_by_year=mean(profit_margin), by(year)
gen adj_profit=profit_margin-avg_profit_by_year

// How might you subset your data to only include observations falling within a certain date range?

keep if inrange(datadate,td(01jan2000),td(31dec2009))

/* The "inrange" function is super useful for subsetting. Use it early and often in your code.
you can also subset on a function called "inlist" which we will use later. We will talk about dates more
later, but Stata processes dates based on a particular numering convention where "0" corresponds to
January 1, 1960. So to feed state a more meaniful code, you can wrap a text string like "31mar1982" in
the function td() to get Stata to convert the string to the proper date number.

You can also use functions of variables in the inrange() function. Try the following:
*/

keep if inrange(month(datadate),10,12)

// Now we only have fiscal year end dates from October, November, and December!

/* Let's try exporting our data to Excel. Suppose we only want to export 
the following variables: gvkey, datadate, and adj_profit. How do we do this?
*/

export excel gvkey datadate adj_profit using "$path/adj-profit.xlsx", replace

/* What if we want to create a tab-separated file with only observations from 2008 and the variables
gvkey, datadate, and leverage?
*/

export delimited gvkey datadate leverage using "$path/lev.txt" if year(datadate)==2008, replace delimiter(tab)

/*
GROUP EXERCISE:

Calculate the consensus (mean) EPS forecast for U.S. I/B/E/S covered firms from 2001–2005 using only forecasts made within 90 days of the earnings announcement date
and then create a variable that captures an analyst's optimism/pessimism relative to the mean forecast. Create an indicator variable for being optimistic and a separate 
variable for being pessimistic.

When finished, export the company's ticker, fiscal period end date, analyst code, optimism indicator, and pessimism indicator to an Excel file
called "analyst-vs-consensus.xlsx"

*/


#delimit ;

odbc load, clear dsn(wrds) exec("
	select *
	from ibes.det_epsus
	where date_part('year', fpedats) between 2001 and 2005");

#delimit cr 

browse


// Only include quarterly forecasts of quarter t+1

keep if fpi=="6"

keep if inrange(anndats-anndats_act,-90,-1)


gen dahead=anndats-anndats_act

egen nearest_forecast=max(dahead), by(ticker fpedats analys )

keep if dahead==nearest_forecast

duplicates tag ticker fpedats analys, gen(dup)
drop if dup>0


egen consensus=mean(value), by(ticker fpedats)

gen optimism=value-consensus

gen ind_opt=optimism>0
gen ind_pes=optimism<0

export excel ticker fpedats analys ind_opt ind_pes using "$path/analyst-vs-consensus.xlsx", replace

