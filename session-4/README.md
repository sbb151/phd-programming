# Session 4 notes

## Setup

Set your path for this session:

```stata
global path "PLACE YOUR PATH HERE"
```
Let's finish our discussion of merging from last time. How can we attach the initial credit rating onto a dataset that contains a bond identifier, the offering date of the bond, the issue amount, and the yield to maturity? Let's do this only for corporate debentures. For this exercise, we will use data from Mergent FISD, which we will download from WRDS and save to our folder for today.

### Download data for session

```stata
odbc load, clear dsn(wrds) exec("SELECT * FROM fisd.fisd_issue")
save "$path/fisd_issue", replace

odbc load, clear dsn(wrds) exec("SELECT * FROM fisd.fisd_ratings")
save "$path/fisd_ratings", replace
```

A command that you can use to see what variables are in a dataset and the storage type of each variables is called `describe`. Let's use `describe` to view the contents of the "fisd_issue.dta" and "fisd_ratings.dta" datasets.

```stata
describe using "$path/fisd_issue"

/*

Contains data                                 
  obs:       457,255                          12 Aug 2020 15:22
 vars:            66                          
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
issue_id        double  %10.0g                
issuer_id       double  %10.0g                
prospectus_issuer_name
                str64   %64s                  
issuer_cusip    str6    %9s                   
issue_cusip     str3    %9s                   
issue_name      str64   %64s                  
maturity        double  %td                   
security_level  str4    %9s                   
security_pledge str1    %9s                   
enhancement     str1    %9s                   
coupon_type     str1    %9s                   
convertible     str1    %9s                   
mtn             str1    %9s                   
asset_backed    str1    %9s                   
yankee          str1    %9s                   
canadian        str1    %9s                   
oid             str1    %9s                   
foreign_currency
                str1    %9s                   
slob            str1    %9s                   
issue_offered_global
                str1    %9s                   
settlement_type str1    %9s                   
gross_spread    double  %10.0g                
selling_concession
                double  %10.0g                
reallowance     double  %10.0g                
comp_neg_exch_deal
                str4    %9s                   
rule_415_reg    str1    %9s                   
sec_reg_type1   str4    %9s                   
sec_reg_type2   str4    %9s                   
rule_144a       str1    %9s                   
treasury_spread double  %10.0g                
treasury_maturity
                str18   %18s                  
offering_amt    double  %10.0g                
offering_date   double  %td                   
offering_price  double  %10.0g                
offering_yield  double  %10.0g                
delivery_date   double  %td                   
unit_deal       str1    %9s                   
form_of_own     str4    %9s                   
denomination    str9    %9s                   
principal_amt   double  %10.0g                
covenants       str1    %9s                   
defeased        str1    %9s                   
defeasance_type str1    %9s                   
defeased_date   double  %td                   
defaulted       str1    %9s                   
tender_exch_offer
                str1    %9s                   
redeemable      str1    %9s                   
refund_protection
                str1    %9s                   
refunding_date  double  %td                   
putable         str1    %9s                   
overallotment_opt
                str1    %9s                   
announced_call  str1    %9s                   
active_issue    str1    %9s                   
dep_eligibility str4    %9s                   
private_placement
                str1    %9s                   
bond_type       str4    %9s                   
subsequent_data str1    %9s                   
press_release   str1    %9s                   
isin            str12   %12s                  
perpetual       str1    %9s                   
sedol           str1    %9s                   
exchangeable    str1    %9s                   
fungible        str1    %9s                   
registration_rights
                str1    %9s                   
preferred_security
                str1    %9s                   
complete_cusip  str9    %9s                   
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


*/

describe using "$path/fisd_ratings"

/*

Contains data                                 
  obs:     3,258,878                          12 Aug 2020 15:23
 vars:             8                          
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
issue_id        double  %10.0g                
rating_type     str3    %9s                   
rating_date     double  %td                   
rating          str8    %9s                   
rating_status   str4    %9s                   
reason          str4    %9s                   
rating_status_date
                double  %td                   
investment_grade
                str1    %9s                   
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


*/

```

### Load the rating data

```stata
use "$path/fisd_ratings", clear

keep issue_id rating_type rating_date rating
bysort issue_id rating_type (rating_date): keep if _n==1
browse

save "$path/tmp_ratings", replace
```

### Load the bond information

```stata
use "$path/fisd_issue", clear

keep if bond_type=="CDEB"
keep issue_id offering_date offering_amt offering_yield
```

### Get rid of observations with missing yields

```stata
drop if missing(offering_yield)
```

### Merge with the rating data

Check the uniqueness of the data by the "issue_id" variable.

```stata
isid issue_id

merge 1:m issue_id using "$path/tmp_ratings", nogenerate keep(3)
```

### Keep only if the rating is within 30 days of the offering date

```stata
keep if inrange(rating_date-offering_date,0,30)
```

## Summarizing data using `collapse`

You can calculate summary statistics by groups of variables using the `collapse` command in Stata. This command will perform a clauclation such as summation, minimum, maximum, or standard deviation within a group.

Below are all of the possible statistics that you can aggregate:

|Statistic|Description|
|---|---|
|mean    |	   means (default)  |
|median  |     medians  |
|p1      |     1st percentile  |
|p2      |     2nd percentile  |
|...      |    3rd-49th percentiles  |
|p50      |    50th percentile (same as median)  |
|...       |   51st-97th percentiles  |
|p98    |      98th percentile | 
|p99      |    99th percentile  |
|sd         |  standard deviations  |
|semean     |  standard error of the mean (sd/sqrt(n))  |
|sebinomial |  standard error of the mean, binomial (sqrt(p(1-p)/n)) | 
|sepoisson  |  standard error of the mean, Poisson (sqrt(mean/n)) | 
|sum      |    sums |
|rawsum    |   sums, ignoring optionally specified weight except observations with a weight of zero are excluded  |
|count   |     number of nonmissing observations|  
|percent   |   percentage of nonmissing observations  |
|max   |       maximums  |
|min    |      minimums  |
|iqr      |    interquartile range  |
|first   |     first value  |
|last     |    last value  |
|firstnm  |    first nonmissing value  |
|lastnm    |   last nonmissing value  |
		
Let's try to calculate a rolling standard deviation of monthly stock returns for the 36 months leading up to a fiscal year end for Compustat firms during the 2011-2015 period.

### Extract Compustat data with CRSP PERMNO

```stata
mkf firm_years

frame firm_years {
	#delimit ;

	odbc load, clear dsn(wrds) exec("
		select 
			a.gvkey, a.datadate, b.lpermno as permno
		from
			(select distinct gvkey, datadate from comp.funda where datadate between '2011-01-01' and '2015-12-31') as a
		left join crsp.ccmxpf_lnkhist as b
		on a.gvkey=b.gvkey
		
		where
			b.linkprim in ('C','P') and 
			b.linktype in ('LU','LC','LS') and
			a.datadate between b.linkdt and coalesce(b.linkenddt,current_date)
	
	");
	
	#delimit cr
	
}

cwf firm_years
browse
```

### Download monthly stock returns during the relevant range of time

```stata
mkf msf

frame msf {
	#delimit ;

	odbc load, clear dsn(wrds) exec("
		select 
			permno, date, ret
		from
			crsp.msf

		where
			date_part('year', date) between 2008 and 2015
	
	");
	
	#delimit cr	
	
}

cwf msf
browse
```

### Expand firm-year dataset to have 36 copies of each

```stata
frame firm_years: expand 36
```

### Create lagged months
```stata
frame firm_years: bysort gvkey datadate: gen m=mofd(datadate)-_n
frame firm_years: format m %tm

cwf firm_years
browse
```
### Add running month variable to the stock market dataset
```stata
frame msf: gen m=mofd(date)
```

### Link firm-years frame with stock frame and get the returns variable
```stata
frame firm_years {
	frlink m:1 permno m, frame(msf)
	frget ret, from(msf)
	
}

cwf firm_years

collapse (sd) retvol=ret (count) n=ret, by(gvkey datadate)

save "$path/retvol", replace
```

## Advanced summarization using `statsby`

The `collapse` command is very useful but it cannot capture more advanced staistics such as regression coefficients or $R^2$. For these more complex computations, you will want to invoke the `statsby` command.

Let's calculate some annual stock market betas using daily data over the 2011-2012 period.

```stata
mkf dsf

frame dsf {
	#delimit ;

	odbc load, clear dsn(wrds) exec("
		select 
			a.permno, a.date, a.ret, b.vwretd
		from
			crsp.dsf as a
		left join crsp.dsi as b
		using(date)

		where
			date_part('year', a.date) between 2011 and 2012
	
	");
	
	#delimit cr		
	
}

cwf dsf

gen year=year(date)


statsby beta=_b[vwretd] n=e(N), by(permno year) clear: regress ret vwretd
```

## Program control with loops

There are three different types of loops in the Stata programming language:

1. `forvalues`
2. `foreach`
3. `while`

Here are a few simple examples to illustrate each of the loop types.

### `forvalues` loop

```stata
forvalues i=1/15 {
	display "`i'"
	// Each loop value is assigned to a local macro for an iteration
}
```

### `foreach` loop

```stata
use "$path/fisd_ratings", clear
keep if rating_type=="MR"
```

We can use a foreach loop to create numeric equivalents of string-based credit ratings.

```stata
gen nrating=.

local c=1
foreach r in C Ca Caa3 Caa2 Caa1 B3 B2 B1 Ba3 Ba2 Ba1 Baa3 Baa2 Baa1 A3 A2 A1 Aa3 Aa2 Aa1 Aaa {
	replace nrating=`c' if rating=="`r'"
	local ++c
}

browse rating nrating

foreach v of varlist * {
	replace `v'=0 if missing(`v')
}
```

### while loop

```stata
local i=50

while `i'>20 {
	display "`i'"
	local --i
}
```

## Extended macro function

There are many functions that can be used in conjunction with macros (`local`, `global`). For instance, you can collect the names of the files in a directory and then loop through each of the files in a `foreach` loop as part of data processing.

```stata
local files_dta: dir "$path" files "*.dta"

foreach f of local files_dta {
	display "`f'"
}
```

## Writing your own programs

Sometimes it is going to be useful to write your own program to accomplish some task that your do repeatedly. I mentioned earlier that there is no way to conduct a `joinby` within the frames environment, a major omission in my opinion.

However, with just a bit of programming, I wrote a command that does just that.

```stata
program frjoinby
	version 16
	syntax varlist using/ [, keep(varlist) unmatched(passthru) _merge(passthru) update replace]
	qui {
		tempfile mfile
		tempname tframe
	
		if "`keep'"=="" frame `using': frame put *, into(`tframe')
		else frame `using': frame put `varlist' `keep', into(`tframe') 
		frame `tframe': save `mfile'
		joinby `varlist' using `mfile', `unmatched' `_merge' `update' `replace'
	}

end

program sortorder
	syntax varlist
	sort `varlist'
	order `varlist'

end
```

## Practice exercise

