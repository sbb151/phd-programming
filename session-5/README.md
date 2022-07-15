
# Session 5 notes

## Setup

Set your path for this session:

```stata
global path "PLACE YOUR PATH HERE"
```

Today we are going to focus on some estimation using Stata and the various ways in which you can output your results for use in other contexts. First, we will build a dataset and then use that dataset to estimate a model.

Clear your frames before we start:

```stata
clear frames
```

## Open prepared dataset

```stata
use "$path/full_data", clear
```

Notice that you don't need to add the suffix ".dta" because Stata assumes that.

### Let's only retain observations with all variables available

```stata
```

## Calculate descriptive statistics

The command that I like to use best for creating formatted tables is `estout`.

You can install this module by typing:
```stata
ssc install estout, replace
```
Within this command, there is a ton of flexibility for getting your preferred output format.

### Let's start by simply printing some descriptive information to a file

```stata
global dv nrating
global xvars size lev intcov prof retvol beta

estpost summarize $dv $xvars, detail case quietly
```

This will print out the basic descriptive output:

```stata
esttab ., cells("count mean sd p25 p50 p75") noobs
```

What if you want to do some formatting? Code `stat(labe(x))` where `stat` is the statistic name and `x` is the new label.

```stata
esttab ., cells("count(label(Observations)) mean(label(Mean)) sd(label(Std. Dev.)) p25(label(Q1)) p50(label(Median)) p75(label(Q3))") noobs
```

There are too many decimal places. How do we fix that? Code `stat(fmt(y))` where `y` is the format.

```stata
esttab .,  cells("count(label(Observations) fmt(%10.0fc)) mean(label(Mean) fmt(3)) sd(label(Std. Dev.) fmt(3)) p25(label(Q1) fmt(3)) p50(label(Median) fmt(3)) p75(label(Q3) fmt(3))") noobs nonum 
```

What if you don't like the format of the variable names? How do you fix that? The easiest way to deal with this issue is to employ some variable labels.

```stata
label variable nrating "S&P Rating"
label variable size "Log(Total Assets)"
label variable lev "Debt-to-Assets"
label variable intcov "Interest Coverage"
label variable prof "Profit Margin"
label variable retvol "Return Volatility"
label variable beta "Beta"


esttab .,  cells("count(label(Observations) fmt(%10.0fc)) mean(label(Mean) fmt(3)) sd(label(Std. Dev.) fmt(3)) p25(label(Q1) fmt(3)) p50(label(Median) fmt(3)) p75(label(Q3) fmt(3))") noobs nonum label
```

### Let's save this table to a CSV format so we can open it in Excel

```stata
esttab . using "$path/descriptives", csv cells("count(label(Observations) fmt(0)) mean(label(Mean) fmt(3)) sd(label(Std. Dev.) fmt(3)) p25(label(Q1) fmt(3)) p50(label(Median) fmt(3)) p75(label(Q3) fmt(3))") noobs nonum label replace
```

RTF format is perfect for embedding in a Microsoft Word document.

```stata
esttab . using "$path/descriptives", rtf cells("count(label(Observations) fmt(%10.0fc)) mean(label(Mean) fmt(3)) sd(label(Std. Dev.) fmt(3)) p25(label(Q1) fmt(3)) p50(label(Median) fmt(3)) p75(label(Q3) fmt(3))") noobs nonum label
```

## Make a correlation table

Honestly, I'm not sure why you really want a correlation table, but I suppose it's a useful exercise for purposes of replication that you might undertake.

There was no single good way to create a correlation table in Stata that includes a Pearson correlation below the diagonal and a Spearman correlation above the diagonal. So I wrote my own Stata function to do just that. The .ado file in in your folder. Move it to a folder on you ADOPATH.

If you need to recall what directories those are, type:

```stata
adopath
```

To use this command, you simply invoke `makecorr` and feed it a variable list. You can add a title as an option and choose what output format you would like. 

```stata
makecorr $dv $xvars using "$path/correlation", csv
```

## Estimate a regression

We can save estimation results in `estout` for future reference using `eststo` as a prefix.

```stata
eststo nofe: regress nrating size lev intcov prof retvol beta, vce(cluster gvkey)
estadd local yfe "No"
estadd local firmfe "No"
```

Suppose we want to include year fixed effects in our model (indicators for each year in the sample minus an excluded base year). How would we accompish this?

One was to do this explicitly in a regression is to use factor variables. You can make a variable an expanded factor variable by place `i.` as a prefix when you specificy the `varlist` in the  estimation command.

```stata
gen y=year(datadate)

eststo yesfe: reghdfe nrating size lev intcov prof retvol beta, a(y) vce(cluster gvkey)
estadd local yfe "Yes"
estadd local firmfe "No"
```

If you want to include a high-dimensional set of fixed effects in a regression, you will want to use a different command from "regress." Two options include `xtreg` and `reghdfe`. If you want to use the latter, you will need to type the following first:

```stata
ssc install reghdfe, replace
```

```stata
eststo firmfe: reghdfe nrating size lev intcov prof retvol beta, a(gvkey y) vce(cluster gvkey)
estadd local firmfe "Yes"
estadd local yfe "Yes"
```

We will save the output to a RTF that we can open in Word.

```stata
esttab nofe yesfe firmfe using "$path/rating_model", replace rtf nocon stats(yfe firmfe N r2_a , fmt(0 0 %10.0fc 3 )  label("Year Fixed Effects" "Firm Fixed Effects" "Observations" "R-squared")) b(4) nonote label title("Determinants of firm-level credit ratings")
```

## Visualization using Stata

You can visualize your data in Stata very flexibly. We will go through a basic exercise of trying to graph some cumulative abnormal returns around earnings announcements based on the sign of the earnings surprise.

### Obtain earnings announcements from I/B/E/S

```stata
capture confirm new frame eadates
if !_rc mkf eadates

frame eadates {
	#delimit ;
	odbc load, clear dsn(wrds) exec(
	"select 
		a.ticker, a.analys, a.fpedats, a.anndats_act, a.anndats, a.anntims, a.value, a.actual, b.permno
	from
		ibes.det_epsus as a 
	inner join crsp.stocknames as b
		on a.cusip=b.ncusip
	where
		extract(year from anndats_act) between 2001 and 2010 and
		anndats-anndats_act between -90 and -1 and
		fpi='1' and
		actual is not null and
		anndats between namedt and nameenddt");
	#delimit cr
	
	bys permno ticker fpedats analys (anndats anntims): keep if _n==_N
	collapse (mean) actual value, by(permno ticker fpedats anndats_act)
	gen esurp=actual-value
	xtile qearn=esurp, n(10)
	
}
```

### Obtain stock returns

```stata
capture confirm new frame returns
if !_rc mkf returns

frame returns {
	#delimit ;
	odbc load, clear dsn(wrds) exec(
	"select 
		a.permno, a.date, (a.ret-b.vwretd) as abret
	from
		crsp.dsf as a
	inner join crsp.dsi as b
		using(date)
	where
		date_part('year',date) between 2000 and 2011");
	#delimit cr
}
```

### Merge returns with EA information

```stata
frame eadates {
	gen date=bofd("crsp", anndats_act)
	drop if missing(date)
	expand 61
	bys permno anndats_act: gen etime=_n-31
	replace date=date+etime
	replace date=dofb(date,"crsp")
	frlink m:1 permno date, frame(returns)
	frget abret, from(returns)
	egen n=count(abret), by(permno anndats_act)
	keep if n==61
	bys permno anndats_act (date): gen car=sum(abret)
	collapse (mean) car, by(qearn etime)
	
	reshape wide car, i(etime) j(qearn)
	
	graph twoway line car* etime, scheme(sj)
	graph export "$path/car_graph.png", replace
	
}
```
