# Session 1 notes

## SQL queries  

The basic building blocks of an SQL query are as follows:
  
```sql
SELECT
FROM
JOIN
WHERE
HAVING
GROUP BY
ORDER BY
LIMIT
```

You will generally always have `SELECT`, `FROM`, and `WHERE`. The other commands can be used to create more refined queries.

## Accessing data from WRDS in Stata

Main command:

```stata
odbc load, clear dsn("Your DSN") exec("Your query")
```

One tip when you are executing SQL queries is that you may want to place different parts of your query on different lines. The wasy to deal with this is to change the line delimiter with `#delimit ;`. To change the delimiter back to a carriage return, simply include the code `#delimit cr`. It can be used only in do-files and ado-files, which we will discuss in the next session.


Below we will use this method to grab a few lines of data.

### Changing the line delimiter

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT permno, date, prc
	FROM crsp.dsf
	LIMIT 50");
	
#delimit cr

list in 1/15
```

`list` will print the contents of your dataset to the results window of Stata. The `in` portion of the command captures what rows you want to print. If you omit `in`, then the command will print the entire dataset.

### The SELECT statement

You will select the variables that you want from the SQL database using the "SELECT" portion of the query. These variables can be existing variables or they can even be generated from the use of functions.

1. To find out the available tables in a data library:

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT DISTINCT table_name
	FROM information_schema.columns
	WHERE table_schema='ibes'");
	
#delimit cr
list
```

2. To find out the available variables in a table:

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT DISTINCT column_name
	FROM information_schema.columns
	WHERE table_schema='comp' AND table_name='funda'");
	
#delimit cr
list
```

3. If you want to limit the number of records (observations) pulled:

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at, revt, rect
	FROM comp.funda
	LIMIT 200");
	
#delimit cr

list in 1/15
```

4. What if you only want distinct value of certain columns? You can invoke the `DISTINCT` command in your select statement:

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT DISTINCT gvkey, datadate
	FROM comp.funda");
	
#delimit cr

list in 1/10

count
```

5. In SQL, the `WHERE` keyword allows you to filter based on both text and numeric values in a table. There are a few different comparison operators you can use:

`=` equal
`<>` not equal
`<` less than
`>` greater than
`<=` less than or equal to
`>=` greater than or equal to

`AND`, `NOT`, `OR`, `IN`, `BETWEEN`

```stata
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
```

`count` will print the number of observations in the dataset to the results window of Stata.

7. Using a date range

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at
	FROM comp.funda
	WHERE at>100 AND date_part('year',datadate) BETWEEN 2000 AND 2005");
	
#delimit cr

list in 1/10
count
```

8. We can also create variables as part of the `SELECT` statement:

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, datadate, at, date_part('year',datadate) AS year
	FROM comp.funda
	WHERE at>100 AND date_part('year',datadate)=2015");
	
#delimit cr

list in 1/10
```

9. You can also subset based on list criteria. For instance, if we only want to grab data for AAPL, MSFT, and FB, then we could do the following:

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT gvkey, tic, datafmt, indfmt, consol, popsrc, datadate, at, date_part('year', datadate) as year
	FROM comp.funda
	WHERE at>100 AND tic IN ('AAPL','MSFT','FB') AND datafmt='STD' AND indfmt='INDL' AND consol='C' AND popsrc='D'");
	
#delimit cr

list
```

10. Often, you will want to perform some calculation on the data in a database.  SQL provides a few functions, called aggregate functions, to help you out with this.

```stata
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
```

11. Joining data is one of the most important tasks that you will undertake using the WRDS database. To join data, you will need to know what "key" variables exist that are common to the databases that you wish to join. Let's take a look at some credit rating data to explore joins.

```stata
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
```

What is a key that we can use to join these datasets?

```stata
#delimit ;
odbc load, clear dsn(wrds) exec("
	SELECT a.issue_id, a.offering_date, a.offering_amt, b.rating_type, b.rating, b.rating_date
	FROM fisd.fisd_issue AS a
	INNER JOIN fisd.fisd_ratings AS b
	ON a.issue_id=b.issue_id
	WHERE b.rating IS NOT NULL");
#delimit cr

list in 1/20
```

## Practice exercises

1. Capture the average ROA by year for Compustat firms with total assets that are greater than \$10 million for the period 1990–2010.
2. Return the number of analysts issuing EPS forecasts for Apple, Facebook, and Google during the 2011–2015 period by quarter.

[Upload](https://drive.google.com/drive/folders/14UP1iOKSqlmglw_gHWguwcmvnL801kHO?usp=sharing) your code before our next class on July 6.
