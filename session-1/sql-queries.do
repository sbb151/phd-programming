*** A little bit of SQL

/*

We will use the "odbc" command for querying data through SQL. You will want to
familiarize yourself with this command's syntax.

To execute a query, you will invoke the following code:

odbc load, clear dsn(wrds) exec("ENTER YOUR SQL STATEMENTS HERE")



One tip when you are executing SQL queries is that you may want to place
different parts of your query on different lines. The wasy to deal with this is to change the line delimiter with "#delimit ;" command.


Below we will use this method to grab a few lines of data.

*/


** Changing the line delimiter

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT permno, date, prc
	FROM crsp.dsf
	LIMIT 50");
	
#delimit cr

list in 1/15


/*
The SELECT statement

You will select the variables that you want from the SQL database using
the "SELECT" portion of the query. These variables can be existing variables
or they can even be generated from the use of functions.
*/

** To find out the available tables in a data library:

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT DISTINCT table_name
	FROM information_schema.columns
	WHERE table_schema='ibes'");
	
#delimit cr
list


** To find out the available variables in a table:

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT DISTINCT column_name
	FROM information_schema.columns
	WHERE table_schema='comp' AND table_name='funda'");
	
#delimit cr
list



#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at, revt, rect
	FROM comp.funda
	LIMIT 200");
	
#delimit cr

list in 1/15

/*
What if you only want distinct value of certain columns? You can invoke the 
DISTINCT command in your select statement:
*/

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT DISTINCT gvkey, datadate
	FROM comp.funda");
	
#delimit cr

list in 1/10

count


/*
In SQL, the WHERE keyword allows you to filter based on both text and numeric values in a table. 
There are a few different comparison operators you can use:

= equal
<> not equal
< less than
> greater than
<= less than or equal to
>= greater than or equal to

AND, NOT, OR, IN, BETWEEN
*/

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at
	FROM comp.funda
	WHERE at>100");
	
#delimit cr

list in 1/10
count

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at
	FROM comp.funda
	WHERE at>100 AND date_part('year',datadate)=2015");
	
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at
	FROM comp.funda
	WHERE at>100 AND datadate BETWEEN '2015-01-01' AND '2015-12-31'");
	
#delimit cr

list in 1/10
count

** Using a date range

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at
	FROM comp.funda
	WHERE at>100 AND date_part('year',datadate) BETWEEN 2000 AND 2005");
	
#delimit cr

list in 1/10
count



/*
We can also create variables as part of the SELECT statement: */ 


#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at, date_part('year',datadate) AS year
	FROM comp.funda
	WHERE at>100 AND date_part('year',datadate)=2015");
	
#delimit cr

list in 1/10

/*
You can also subset based on list criteria. For instance, if we only want to grab
data for AAPL, MSFT, and FB, then we could do the following:
*/


#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, tic, datafmt, indfmt, consol, popsrc, datadate, at, date_part('year', datadate) as year
	FROM comp.funda
	WHERE at>100 AND tic IN ('AAPL','MSFT','FB') AND datafmt='STD' AND indfmt='INDL' AND consol='C' AND popsrc='D'");
	
#delimit cr

list

/*
Often, you will want to perform some calculation on the data in a database. 
SQL provides a few functions, called aggregate functions, to help you out with this.
*/

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT AVG(revt) as avg_revenues, date_part('year', datadate) as year
	FROM comp.funda
	WHERE date_part('year', datadate) BETWEEN 2000 AND 2015
		AND at>1
		AND datadate IS NOT NULL
	GROUP BY year");
	
#delimit cr

list


#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT DISTINCT date_part('year', datadate) as year
	FROM comp.funda
	ORDER BY year DESC");
	
#delimit cr

list




/*
Joining data is one of the most important tasks that you will undertake using
the WRDS database. To join data, you will need to know what "key" variables exist
that are common to the databases that you wish to join. Let's take a look at some credit
rating data to explore joins.
*/

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT *
	FROM fisd.fisd_issue
	LIMIT 10");
#delimit cr

list

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT *
	FROM fisd.fisd_ratings
	LIMIT 10");
#delimit cr

list

** What is a key that we can use to join these datasets?

#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT a.issue_id, a.offering_date, a.offering_amt, b.rating_type, b.rating, b.rating_date
	FROM fisd.fisd_issue AS a
	INNER JOIN fisd.fisd_ratings AS b
	ON a.issue_id=b.issue_id
	WHERE b.rating IS NOT NULL");
#delimit cr

list in 1/20


/*
Practice exercises:

(1) Capture the average ROA by year for Compustat firms with total assets that
are greater than $10 million for the period 1990–2010.

(2) Return the number of analysts issuing EPS forecasts for Apple, Facebook, and Google during the
2011–2015 period by quarter.


*/

