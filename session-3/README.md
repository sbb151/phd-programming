# Session 3 notes

## Stata next steps

- Set up a path for today's session.

```stata
global path "PLACE YOUR PATH HERE"
```

### Sorting and "n" subscripting

Stata allows you to conduct operations based on the relative position of an observation within what is called a "by group." Suppose we wanted to download some Compustat data but only wanted to keep quarters where there was a single observation for a given company in a given fiscal quarter that was associated with a single earnings announcement date.

How would we accomplish this?

```stata
#delimit ;

odbc load, clear dsn(wrds) exec("
	select gvkey, datadate, rdq, atq, niq
	from comp.fundq
	where
		date_part('year',datadate) between 2011 and 2015 and
		datafmt='STD' and indfmt='INDL' and consol='C' and popsrc='D'");

#delimit cr
```
- Check for duplicates by gvkey-datadate

```stata
duplicates report gvkey datadate
```

  | copies | observations    |   surplus|
  |--------|----------------|-----------|
 |       1 |       231994     |        0|
  |      2 |          408      |     204|
  
  
- To keep a unique set of gvkey-datadate pairs, code the following:

```stata
bysort gvkey datadate: keep if _N==1
```

- Check for duplicates by gvkey-rdq

```stata
duplicates report gvkey rdq
```

Duplicates in terms of gvkey-rdq:

 |  copies | observations  |     surplus|
----------|--------------|------------|
  |      1 |       168184 |            0|
 |       2 |         2788  |        1394|
  |      3 |         1938   |       1292|
   |     4 |         1932    |      1449|
   |     5 |         1340     |     1072|
   |     6 |         1326      |    1105|
   |     7 |         5005       |   4290|
   |     8 |         2936        |  2569|
   |     9 |         2772|          2464|
   |    10 |         2440 |         2196|
   |    11 |         1540  |        1400|
   |    12 |         1248   |       1144|
   |    13 |          832   |        768|
   |    14 |          798   |        741|
   |    15 |         1425   |       1330|
   |    16 |         1360   |       1275|
   |    17 |         1003   |        944|
   |    18 |         1368   |       1292|
   |    19 |         1843   |       1746|
   |    20 |        29700   |      28215|
   |    21 |          147   |        140|
   |    22 |           22   |         21|
   |    23 |           23   |         22|
   |    24 |           24   |         23|
   
```stata
bysort gvkey rdq: keep if _N==1
```

`_N` refers to the total count of observations in a given "by group." These groups are defined before the colon and after the command `bysort` which can be abbreviated to `bys` if you want.

Let's do something else useful. Let's calculate some cash flow from operations at the quarterly level.

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	select gvkey, datadate, fyearq, fqtr, oancfy
	from comp.fundq
	where
		date_part('year',datadate) between 2011 and 2015 and
		datafmt='STD' and indfmt='INDL' and consol='C' and popsrc='D' and
		not (fyearq is null or fqtr is null)");

#delimit cr

browse

bys gvkey fyearq fqtr: keep if _N==1

bysort gvkey fyearq (fqtr): generate cash_from_operations=oancfy-oancfy[_n-1] if fqtr==fqtr[_n-1]+1

browse
```
- Adjust for 1st quarter

```stata
replace cash_from_operations=oancfy if fqtr==1
```

### Fun with dates

Dates in Stata are relatively easier to work with. If a variable is a date, we can format it so that when we browse the data, it is in a visually appealing format. The basic format is `%td`.

```stata
format datadate %td // It's actually already in this format
```
- What if we want the date to show up as YYYY-MM-DD?

```stata
format datadate %tdCY-N-D
browse
```

- What about M/D/Y?

```stata
format datadate %tdN/D/CY
browse
```

- What about showing it like February 17, 2021?

```stata
format datadate %tdM_d,_CY
browse
```

- You can extract a bunch of components from the dates and store them in new variables

```stata
gen year=year(datadate)
gen month=month(datadate)
gen day=day(datadate)
gen dow=dow(datadate) // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
gen quarter=quarter(datadate)
browse
```

### Creating a business calendar

Perhaps the most important date related function is that of creating a business calendar so we can track market trading days and not mess up event time around a particular date.

We need to load data from CRSP to help us identify trading days.

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	select date 
	from crsp.dsi");

#delimit cr

cd "$path"
bcal create trading, replace from(date) dateformat(dmy) center(01jan1960) maxgap(15)
```

- Let's use this business calendar to generate the (-1,+1) window around some earnings announcements for calculating cumulative abnormal returns (CAR).

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	select 
		distinct gvkey, rdq 
	from 
		comp.fundq
	where 
		rdq is not null and
		extract(year from rdq) between 2013 and 2018");

#delimit cr
```

- Expand each observation by 3 so that we can eventually have three days

```stata
expand 3
```
The `expand` command creates "n" copies of each observation in the dataset.

- Create the business date

```stata
gen rdq_b=bofd("trading", rdq)

count if missing(rdq_b)
```
  5,055
  
  Apparently 5,055 earnings announcement dates in the dataset fell outside of actual trading days.
  
- Drop if earnings announcement not on a business date

```stata
drop if missing(rdq_b)
```

- Create the three-day event window dates

```stata
bysort gvkey rdq: gen date_b=rdq_b+(_n-2)
```
Notice the "_n" subcripting that references the relative position of an observation within a "by group."

```stata
format rdq_b date_b %tbtrading
browse
```
|gvkey|	rdq|	rdq_b|	date_b|
|---|------|-------|---------|
|001004|	30mar2015|	30mar2015|	27mar2015|
|001004|	30mar2015|	30mar2015|	30mar2015|
|001004	|30mar2015	|30mar2015	|31mar2015|

- If we want to merge this data with CRSP stock returns, we will have to convert the business dates back into regular calendar dates.

```stata
gen date=dofb(date_b, "trading")
format date %td
browse
```

### Creating lead and lag variables

Somtimes you will want to create a lead or lag variable and want to ensure that the variable is exactly n periods behind or ahead of the current observation.

How do you accomplish this?

We can use the time-series setup feature.

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	select 
		distinct gvkey, rdq, fyearq, fqtr, niq, atq
	from 
		comp.fundq
	where 
		rdq is not null and
		extract(year from rdq) between 2013 and 2018 and
		fyearq*fqtr*niq*atq is not null and
		datafmt='STD' and indfmt='INDL' and consol='C' and popsrc='D'");

#delimit cr
```

- Drop quarters with duplicates 

```stata
bys gvkey fyearq fqtr: keep if _N==1
```

- Make a variable for the fiscal quarter (new function)

```stata
gen qtr=yq(fyearq,fqtr)
```

- Set up data as time series. First we need to create a numeric version of "gvkey."

```stata
encode gvkey, generate(id)

tsset id qtr
```

- Generate ROA variable and then both a lead and a lag

```stata
gen roa=niq/atq

gen lead_roa=f.roa
gen lag_roa=l.roa

gen lag2_roa=l2.roa

browse
```

### Reshaping data

When you obtain data from a service like Thomson One or DataStream, it may be in a format that is not conducive to analysis without a little bit of help. We will demonstrate this idea on the Fama-French size and book-to-market returns that we used last week when discussing the importing of data.

```stata
import delimited using "$path/25_Portfolios_5x5_Daily.CSV", clear rowr(19:24305) varn(19)

rename * ret=

tostring retv1, replace

gen date=date(retv1, "YMD")
format date %td
order date

drop retv1

reshape long ret, i(date) j(portfolio) str

replace portfolio=subinstr(portfolio,"small", "me1", .)
replace portfolio=subinstr(portfolio,"big", "me5", .)
replace portfolio=subinstr(portfolio,"lobm", "bm1", .)
replace portfolio=subinstr(portfolio,"hibm", "bm5", .)

gen me=real(substr(portfolio,3,1))
gen bm=real(substr(portfolio,6,1))

drop portfolio
```

### Data frames

Stata has the ability house multiple datasets in memory at once for quick retrieval and joining. The name of the structure is a data frame. You first need to initialize the frame using either:

- `mkf [newname]`
- `frame create [newname]`

You can also create frames from other frames using:

- `frame put`
- `frame copy`

When you open Stata, the data in memory is in the "default" frame.

Let's build some frames.

- CRSP/Compustat linking table

```stata
mkf cclink

frame cclink {
	
	#delimit ;
odbc load, clear dsn(wrds) exec("
	select 
		gvkey, lpermno as permno, linkdt, coalesce(linkenddt,current_date) as linkenddt
	from 
		crsp.ccmxpf_lnkhist
	where
		linkprim in ('P','C') and linktype in ('LC','LU','LS')");

#delimit cr
}

cwf cclink
browse
```

- Earnings announcement dates from 2011–2015

```stata
mkf eadates

frame eadates {
		#delimit ;
odbc load, clear dsn(wrds) exec("
	select 
		distinct gvkey, rdq
	from 
		comp.fundq
	where
		extract(year from rdq) between 2011 and 2015");

#delimit cr
}

cwf eadates
browse
```

- Compustat "Names" table

```stata
mkf names

frame names {
		#delimit ;
odbc load, clear dsn(wrds) exec("
	select 
		*
	from 
		comp.names");

#delimit cr
}

cwf names
browse
```

- Let's link the SIC code of the company to the earnings data

```stata
frame eadates: frlink m:1 gvkey, frame(names)
frame eadates: frget cik, from(names)

cwf eadates
browse
```

What about the COMP-CRSP link? Unfortunately, we cannot conduct a many-to-many join of frames in Stata. Fortunately, we can save the file to our folder and then use the `joinby` command.

```stata
frame cclink: save "$path/ccmlink", replace

cwf eadates
joinby gvkey using "$path/ccmlink", unmatched(master)
browse
```

- If we need stock market data, we will want to delete any with a missing PERMNO

```stata
drop if _merge==1
```

When merging data, Stata provides the result of the merge by observation, which is stored in the `_merge()` variable. Here are the types of results

- `_merge==1`: key variables only exists in the "master" data (left table if you like SQL)
- `_merge==2`: key variables only exists in the "using" data (right table)
- `_merge==3`: key variables exist in both datasets (tables)

We also need to retain only valid CRSP-COMPUSTAT links

```stata
keep if inrange(rdq,linkdt,linkenddt)
```

Congratulations! You have done you first (of many) merges.

Stata also has another version of merge, which will be useful at some point

One-to-one merge on specified key variables:

- `merge 1:1 varlist using filename [, options]`


Many-to-one merge on specified key variables:

- `merge m:1 varlist using filename [, options]`


One-to-many merge on specified key variables:

- `merge 1:m varlist using filename [, options]`
  
## Practice exercise

Calculate earnings surprise for all available firm-quarters over the 2015–2019 period.

In accounting studies, we typically measure earnings surprise as follows:

$\frac{EPS_{Actual}-EPS_{Consensus}}{Price_{Beg}}$

You will need IBES and CRSP data for this exercise and, likely, some of the WRDS user manuals to help with variable definitions. A consensus forecast is usually defined as the mean of analysts' forecasts made is a window prior to the earnings announcement (often days -90 to -1).

[Upload](https://drive.google.com/drive/folders/1NVDveZQzQcM6P0whKrPJ5cTK0J4xvOlo?usp=sharing) your code when you are finished.

