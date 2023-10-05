```python
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"
```

# 1 File input and output
One of the most important tools in Python is the ability to read files from your computer and write new files or update existing files. I am going to go through a few simple examples of how to read and write data using Python.
## 1.1 Reading a file
Reading a file requires the opening of a file handle and then use of one of the several file read methods:
### 1.1.1 The read() method
This method will read the entire contents of the filehandle into a variable. You can limit the amount read by feeding the method a number as an argument. Consider the following example, which will read the first 11 bytes from the file:


```python
edgar=open('company20194.idx','r')
print(edgar.read(1000))
edgar.close()
```

    Description:           Master Index of EDGAR Dissemination Feed by Company Name
    Last Data Received:    December 31, 2019
    Comments:              webmaster@sec.gov
    Anonymous FTP:         ftp://ftp.sec.gov/edgar/
     
     
     
     
    Company Name                                                  Form Type   CIK         Date Filed  File Name
    ---------------------------------------------------------------------------------------------------------------------------------------------
    024, Inc.                                                     D           1793747     2019-11-12  edgar/data/1793747/0001793747-19-000001.txt         
    1 800 FLOWERS COM INC                                         10-Q        1084869     2019-11-08  edgar/data/1084869/0001437749-19-022111.txt         
    1 800 FLOWERS COM INC                                         4           1084869     2019-11-01  edgar/data/1084869/0001437749-19-021279.txt         
    1 800 FLOWERS COM INC                                         4           10848


### 1.1.2 The readline() method
You can read also read entire lines of the file using **readline()**. Each time the method is invoked, it will return a subsequent line from the file


```python
edgar=open('company20194.idx','r')
print("Line 1: ", edgar.readline())
print("Line 2: ", edgar.readline())
print("Line 3: ", edgar.readline())
edgar.close()
```

    Line 1:  Description:           Master Index of EDGAR Dissemination Feed by Company Name
    
    Line 2:  Last Data Received:    December 31, 2019
    
    Line 3:  Comments:              webmaster@sec.gov
    


### 1.1.3 The readlines() method
You can also read the lines of the file into a list such that each element of the list contains a different line.


```python
edgar=open('company20194.idx','r')
x=edgar.readlines()
print(len(x))
for line in range(10):
    print(x[line])
edgar.close()
```

    205966
    Description:           Master Index of EDGAR Dissemination Feed by Company Name
    
    Last Data Received:    December 31, 2019
    
    Comments:              webmaster@sec.gov
    
    Anonymous FTP:         ftp://ftp.sec.gov/edgar/
    
     
    
     
    
     
    
     
    
    Company Name                                                  Form Type   CIK         Date Filed  File Name
    
    ---------------------------------------------------------------------------------------------------------------------------------------------
    


### 1.1.4 Reading lines with a for loop
You can also read lines one-by-one withe a **for** loop. Notice the **enumerate** function that is used in the loop declaration. This is a convenient way to create a line counter.


```python
edgar=open('company20194.idx','r')
for (c, line) in enumerate(edgar,1):
    if c<11:
        print(line)
edgar.close()
```

    Description:           Master Index of EDGAR Dissemination Feed by Company Name
    
    Last Data Received:    December 31, 2019
    
    Comments:              webmaster@sec.gov
    
    Anonymous FTP:         ftp://ftp.sec.gov/edgar/
    
     
    
     
    
     
    
     
    
    Company Name                                                  Form Type   CIK         Date Filed  File Name
    
    ---------------------------------------------------------------------------------------------------------------------------------------------
    


### 1.1.5 Using the with statement to avoid the need to close filehandles
When you open a filehandle, it needs to be closed. This can be somewhat annoying. A covenient workaround is the use of the **with** statement.


```python
with open('company20194.idx','r') as edgar:
    for (c, line) in enumerate(edgar,1):
        if c<11:
            print(line)
```

    Description:           Master Index of EDGAR Dissemination Feed by Company Name
    
    Last Data Received:    December 31, 2019
    
    Comments:              webmaster@sec.gov
    
    Anonymous FTP:         ftp://ftp.sec.gov/edgar/
    
     
    
     
    
     
    
     
    
    Company Name                                                  Form Type   CIK         Date Filed  File Name
    
    ---------------------------------------------------------------------------------------------------------------------------------------------
    


## 1.2 Writing to a file
Writing text to a file is very similar to reading a file. One difference is that when you open the filehandle for writing, you will need to specify either 'w' or 'a' instead of 'r' depending on whether you would like to overwrite an existing file or append to a file if it exists.


```python
with open('output.txt', 'w') as fileout:
    fileout.write('This is how we write to a file.\n')
    
with open('output.txt', 'a') as f2:
    f2.write('Now we are appending another line to the file.\n')
```




    32






    47



# 2 Getting WRDS data with Python
Since the WRDS Cloud now houses its datasets in PostgreSQL format rather than a pile of .sas7bdat files, it is very convenient to pull some data from WRDS for either analysis or as part of some other task that you might have in mind. We will spend just a few minutes with the **wrds** module before moving into some more details about **pandas** and ways of looking at numerical data within Python. I encourage you to play around with Python and data analysis. See if you can use it for any tasks that might have been done in SAS or Stata. 


```python
import wrds
db = wrds.Connection(wrds_username='sbonsall')


#The step below creates a file on your computer so that you do not 
#need to enter your password in the future when using the WRDS
#module. Quite convenient!

#db.create_pgpass_file()
```

    Loading library list...
    Done



```python
# Listing the WRDS libraries
db.list_libraries()
```




    ['wrds_lib_internal',
     'ppubsamp_d4d_new',
     'ktmine',
     'revere',
     'levin',
     'lspd',
     'lspdsamp',
     'contrib_char_returns_new',
     'taq',
     'secsamp_all_new',
     'compd',
     'compgd',
     'preqsamp_all_new',
     'compbd',
     'compsegd',
     'crspa',
     'infogroup_business_academic',
     'ciq_ratings',
     'reprisk',
     'crspsamp',
     'optionm',
     'dmef',
     'doe',
     'taqmsamp',
     'rpnasamp',
     'secsamp',
     'snlsamp',
     'taqmsec',
     'sustsamp',
     'taqsamp',
     'risk_directors',
     'toyo',
     'trsdcgs',
     'trws',
     'twoiq',
     'wcai',
     'wqa',
     'wrdsapps',
     'wrdsrpts',
     'comscore',
     'comp_execucomp',
     'risk_governance',
     'wappsamp',
     'infogroup_business_academic_new',
     'govpxsmp',
     'hbsamp',
     'hfrsamp',
     'lvnsamp',
     'aha',
     'bank',
     'blab',
     'bvd',
     'compmcur',
     'ftsesamp',
     'ginsight',
     'gmi',
     'hbase',
     'ifgr',
     'ims',
     'cisdm',
     'issm',
     'nastraq',
     'pacap',
     'ppublica',
     'public',
     'rent',
     'snl',
     'sprat',
     'sustain',
     'sdcsamp',
     'centris',
     'emdb',
     'eureka',
     'evts',
     'govpx',
     'gsi',
     'block_all_new',
     'compdcur',
     'crsp_q_ziman',
     'etfgsamp',
     'fisd',
     'infogroupsamp_residential',
     'ktmine_patents_samp',
     'factset',
     'compg',
     'compm',
     'boardsmp',
     'compb',
     'compseg',
     'infogroupsamp_business',
     'ims_obp_trial',
     'ifgrsamp',
     'imssamp',
     'twoiqsmp',
     'zacksamp',
     'ravenpack_trial',
     'iri',
     'ktsamp',
     'snlsamp_fig',
     'contrib_general_new',
     'crspq',
     'crsp_a_indexes',
     'tr_insiders',
     'csmar',
     'ibescorp',
     'risk',
     'tr_tass',
     'compa',
     'crsp_a_ccm',
     'crsp_q_mutualfunds',
     'compsnap',
     'ahasamp',
     'block',
     'comp_snapshot',
     'phlx',
     'ppubsamp',
     'pwt',
     'repsamp',
     'audit_audit_comp',
     'boardex_trial',
     'optionmsamp_europe',
     'optionmsamp_us',
     'omtrial',
     'hfr',
     'zacks',
     'trown',
     'fisd_naic',
     'tr_dealscan',
     'fisdsamp',
     'crsp_a_stock',
     'crsp_a_treasuries',
     'iss_incentive_lab_europe',
     'ftse',
     'fjc_litigation',
     'fisd_fisd',
     'comph',
     'iss_incentive_lab',
     'crsp_a_ziman',
     'ciq_common',
     'etfg_samp',
     'ciq',
     'comp_bank',
     'comp_segments_hist',
     'wrdssec',
     'tr_ibes',
     'tr_13f',
     'aha_sample',
     'msfanly',
     'calcbench_trial',
     'ciqsamp_common',
     'ciqsamp_transcripts',
     'compsamp_snapshot',
     'contrib_char_returns',
     'contrib_general',
     'eurekahedge_sample',
     'factsamp_revere',
     'fjc_linking',
     'cboe',
     'ff',
     'ibes',
     'hbase_sample',
     'hfrsamp_hfrdb',
     'macrofin_comm_trade',
     'mrktsamp_cds',
     'mrktsamp_cdx',
     'mrktsamp_msf',
     'ppubsamp_d4d',
     'clrvtsmp',
     'compsamp',
     'contrib',
     'djones',
     'fssamp',
     'macrofin',
     'reprisk_sample',
     'frb',
     'tfn',
     'mrktsamp',
     'msrb',
     'msrbsamp',
     'risksamp',
     'snapsamp',
     'totalq',
     'trace',
     'trsamp',
     'trace_enhanced',
     'trace_standard',
     'msfinst',
     'tr_mutualfunds',
     'twoiq_samp',
     'wrdssec_midas',
     'audit',
     'bvdsamp',
     'calcbnch',
     'ciqsamp',
     'cisdmsmp',
     'clrvt',
     'etfg',
     'rpna',
     'tass',
     'execcomp',
     'crspm',
     'boardex',
     'crsp',
     'dealscan',
     'mfl',
     'otc',
     'kld',
     'comp_bank_daily',
     'comp_segments_hist_daily',
     'ibeskpi',
     'markit',
     'sdc',
     'otc_endofday',
     'tr_ibes_guidance',
     'comp']




```python
# Listing the tables within a 
db.list_tables('rpna')
```




    ['rp_equities',
     'rp_global_macro',
     'pr_global_macro',
     'pr_equities',
     'web_equities',
     'web_global_macro',
     'rp_equities_2000',
     'rp_equities_2001',
     'rp_equities_2002',
     'rp_equities_2003',
     'rp_equities_2004',
     'rp_equities_2005',
     'rp_equities_2006',
     'rp_equities_2007',
     'rp_equities_2008',
     'rp_equities_2009',
     'rp_equities_2010',
     'rp_equities_2011',
     'rp_equities_2012',
     'rp_equities_2013',
     'rp_equities_2014',
     'rp_equities_2015',
     'rp_equities_2016',
     'rp_equities_2017',
     'rp_equities_2018',
     'rp_equities_2019',
     'rp_global_macro_2000',
     'rp_global_macro_2001',
     'rp_global_macro_2002',
     'rp_global_macro_2003',
     'rp_global_macro_2004',
     'rp_global_macro_2005',
     'rp_global_macro_2006',
     'rp_global_macro_2007',
     'rp_global_macro_2008',
     'rp_global_macro_2009',
     'rp_global_macro_2010',
     'rp_global_macro_2011',
     'rp_global_macro_2012',
     'rp_global_macro_2013',
     'rp_global_macro_2014',
     'rp_global_macro_2015',
     'rp_global_macro_2016',
     'rp_global_macro_2017',
     'rp_global_macro_2018',
     'rp_global_macro_2019',
     'pr_equities_2000',
     'pr_equities_2001',
     'pr_equities_2002',
     'pr_equities_2003',
     'pr_equities_2004',
     'pr_equities_2005',
     'pr_equities_2006',
     'pr_equities_2007',
     'pr_equities_2008',
     'pr_equities_2009',
     'pr_equities_2010',
     'pr_equities_2011',
     'pr_equities_2012',
     'pr_equities_2013',
     'pr_equities_2014',
     'pr_equities_2015',
     'pr_equities_2016',
     'pr_equities_2017',
     'pr_equities_2018',
     'pr_equities_2019',
     'pr_global_macro_2000',
     'pr_global_macro_2001',
     'pr_global_macro_2002',
     'pr_global_macro_2003',
     'pr_global_macro_2004',
     'pr_global_macro_2005',
     'pr_global_macro_2006',
     'pr_global_macro_2007',
     'pr_global_macro_2008',
     'pr_global_macro_2009',
     'pr_global_macro_2010',
     'pr_global_macro_2011',
     'pr_global_macro_2012',
     'pr_global_macro_2013',
     'pr_global_macro_2014',
     'pr_global_macro_2015',
     'pr_global_macro_2016',
     'pr_global_macro_2017',
     'pr_global_macro_2018',
     'pr_global_macro_2019',
     'web_equities_2000',
     'web_equities_2001',
     'web_equities_2002',
     'web_equities_2003',
     'web_equities_2004',
     'web_equities_2005',
     'web_equities_2006',
     'web_equities_2007',
     'web_equities_2008',
     'web_equities_2009',
     'web_equities_2010',
     'web_equities_2011',
     'web_equities_2012',
     'web_equities_2013',
     'web_equities_2014',
     'web_equities_2015',
     'web_equities_2016',
     'web_equities_2017',
     'web_equities_2018',
     'web_equities_2019',
     'web_global_macro_2000',
     'web_global_macro_2001',
     'web_global_macro_2002',
     'web_global_macro_2003',
     'web_global_macro_2004',
     'web_global_macro_2005',
     'web_global_macro_2006',
     'web_global_macro_2007',
     'web_global_macro_2008',
     'web_global_macro_2009',
     'web_global_macro_2010',
     'web_global_macro_2011',
     'web_global_macro_2012',
     'web_global_macro_2013',
     'web_global_macro_2014',
     'web_global_macro_2015',
     'web_global_macro_2016',
     'web_global_macro_2017',
     'web_global_macro_2018',
     'web_global_macro_2019',
     'dj_equities_2009',
     'dj_equities_2000',
     'dj_equities_2001',
     'dj_equities_2002',
     'dj_equities_2003',
     'dj_equities_2004',
     'dj_equities_2005',
     'dj_equities_2006',
     'dj_equities_2007',
     'dj_equities_2008',
     'dj_equities_2010',
     'dj_equities_2011',
     'dj_equities_2012',
     'dj_equities_2013',
     'dj_equities_2014',
     'dj_equities_2015',
     'dj_equities_2016',
     'dj_equities_2017',
     'dj_equities_2018',
     'dj_equities_2019',
     'dj_global_macro_2000',
     'dj_global_macro_2001',
     'dj_global_macro_2002',
     'dj_global_macro_2003',
     'dj_global_macro_2004',
     'dj_global_macro_2005',
     'dj_global_macro_2006',
     'dj_global_macro_2007',
     'dj_global_macro_2008',
     'dj_global_macro_2009',
     'dj_global_macro_2010',
     'dj_global_macro_2011',
     'dj_global_macro_2012',
     'dj_global_macro_2013',
     'dj_global_macro_2014',
     'dj_global_macro_2015',
     'dj_global_macro_2016',
     'dj_global_macro_2017',
     'dj_global_macro_2018',
     'dj_global_macro_2019',
     'dj_equities_2020',
     'dj_global_macro_2020',
     'rp_equities_2020',
     'rp_global_macro_2020',
     'pr_equities_2020',
     'pr_global_macro_2020',
     'web_equities_2020',
     'web_global_macro_2020',
     'chars',
     'ravenpack_categories',
     'rp_company_mapping',
     'rp_entity_mapping',
     'rp_source_list',
     'wrds_all_mapping',
     'wrds_company_mapping',
     'wrds_company_names',
     'wrds_entity_mapping',
     'wrds_rp_provider_list',
     'wrds_rp_source_list']




```python
# You can also describe the contents of a table

db.describe_table(library='comp', table='adsprate')
```

    Approximately 3023650 rows in comp.adsprate.





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
      <th>nullable</th>
      <th>type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>gvkey</td>
      <td>True</td>
      <td>VARCHAR(6)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>splticrm</td>
      <td>True</td>
      <td>VARCHAR(10)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>spsdrm</td>
      <td>True</td>
      <td>VARCHAR(10)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>spsticrm</td>
      <td>True</td>
      <td>VARCHAR(10)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>datadate</td>
      <td>True</td>
      <td>DATE</td>
    </tr>
  </tbody>
</table>
</div>




```python
#There are two ways of querying data from WRDS. 
#The first is get_table and the second is raw_sql.

## get_table

ratings=db.get_table(library='comp',table='adsprate', columns=['gvkey','datadate','splticrm'])


```


```python
ratings[ratings['gvkey']=='001690']
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>57079</th>
      <td>001690</td>
      <td>1986-10-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>57080</th>
      <td>001690</td>
      <td>1986-11-30</td>
      <td>None</td>
    </tr>
    <tr>
      <th>57081</th>
      <td>001690</td>
      <td>1986-12-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>57082</th>
      <td>001690</td>
      <td>1987-01-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>57083</th>
      <td>001690</td>
      <td>1987-02-28</td>
      <td>None</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>57439</th>
      <td>001690</td>
      <td>2016-10-31</td>
      <td>AA+</td>
    </tr>
    <tr>
      <th>57440</th>
      <td>001690</td>
      <td>2016-11-30</td>
      <td>AA+</td>
    </tr>
    <tr>
      <th>57441</th>
      <td>001690</td>
      <td>2016-12-31</td>
      <td>AA+</td>
    </tr>
    <tr>
      <th>57442</th>
      <td>001690</td>
      <td>2017-01-31</td>
      <td>AA+</td>
    </tr>
    <tr>
      <th>57443</th>
      <td>001690</td>
      <td>2017-02-28</td>
      <td>AA+</td>
    </tr>
  </tbody>
</table>
<p>365 rows × 3 columns</p>
</div>




```python
## raw_sql

prices=db.raw_sql("select permno, date, ret from crsp.dsf where date_part('year',date)=2019 limit 100")
prices
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>permno</th>
      <th>date</th>
      <th>ret</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>87487.0</td>
      <td>2019-01-02</td>
      <td>0.030948</td>
    </tr>
    <tr>
      <th>1</th>
      <td>87487.0</td>
      <td>2019-01-03</td>
      <td>-0.011257</td>
    </tr>
    <tr>
      <th>2</th>
      <td>87487.0</td>
      <td>2019-01-04</td>
      <td>0.068311</td>
    </tr>
    <tr>
      <th>3</th>
      <td>87487.0</td>
      <td>2019-01-07</td>
      <td>0.012433</td>
    </tr>
    <tr>
      <th>4</th>
      <td>87487.0</td>
      <td>2019-01-08</td>
      <td>0.047368</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>95</th>
      <td>87487.0</td>
      <td>2019-05-20</td>
      <td>-0.006356</td>
    </tr>
    <tr>
      <th>96</th>
      <td>87487.0</td>
      <td>2019-05-21</td>
      <td>0.012793</td>
    </tr>
    <tr>
      <th>97</th>
      <td>87487.0</td>
      <td>2019-05-22</td>
      <td>-0.023158</td>
    </tr>
    <tr>
      <th>98</th>
      <td>87487.0</td>
      <td>2019-05-23</td>
      <td>0.032328</td>
    </tr>
    <tr>
      <th>99</th>
      <td>87487.0</td>
      <td>2019-05-24</td>
      <td>0.030107</td>
    </tr>
  </tbody>
</table>
<p>100 rows × 3 columns</p>
</div>




```python
prices2=db.raw_sql("select permno, date, ret from crsp.dsf where date_part('year',date)=2019")  
db.close()
```

# 3 Working with tabular data: The Pandas package
Text analysis typically involves unstructured and structured data. Un- structured data is data that is not organized in a pre-defined manner, such as a 10-K or an image. A 10-K is unstructured since each company organizes its 10-K differently. Much of this paper deals with unstruc- tured text data. However, researchers performing text analysis will also work with structured data such as SAS and Stata datasets, Excel files, and CSV files corresponding to Compustat, IBES, and CRSP data. Structured data is organized into pre-defined columns, each of which contains a specific type of data, and rows, each of which contains an observation.
## 3.1 Required import statements
The most common method of importing the Pandas library is with this call to the **import** statement. It is common practice to use the alias pd for Pandas, and we recommend the reader to do the same.


```python
import pandas as pd
```

The Pandas library is built on top of a numerical analysis library called NumPy, and most Pandas users frequently call NumPy functions to manipulate data. Therefore, most users include the following import statements at the top of their notebooks. We recommend the reader to do the same.


```python
import numpy as np
```

## 3.2 Importing and exporting data
In this section, we introduce Pandas’ capabilities for importing data from Excel, CSV, Stata, and SAS formats. We provide sample code and explanation for common use cases. Pandas provides powerful and flexible import capabilities and supports many other data formats. Consult the [official documentation](https://pandas.pydata.org/docs/user_guide/io.html) for use cases not covered here.

All Pandas functions for importing data begin with **read_**, e.g. **pd.read_excel**, **pd.read_sas**, etc. The options for these functions are fairly standardized so the learning curve flattens after the user gains proficiency with one import function.
### 3.2.1 Importing data from Excel
Use the function **pd.read_excel** to import data from an Excel file. If the Excel file contains only one worksheet with well-formatted data (i.e., one contiguous block of data with header row and no blank lines at the top of the worksheet) then **pd.read_excel** requires only one argument, the path to the file.


```python
import numpy as np
import pandas as pd

df=pd.read_excel('Categorical_EPU_Data.xlsx')
```

Notice that the pd.read_excel function assumed that the first row contained column names and automatically used them as column labels in the DataFrame. You can preview the DataFram by typing its name (**df**) into a code cell.


```python
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Date</th>
      <th>1. Economic Policy Uncertainty</th>
      <th>2. Monetary policy</th>
      <th>Fiscal Policy (Taxes OR Spending)</th>
      <th>3. Taxes</th>
      <th>4. Government spending</th>
      <th>5. Health care</th>
      <th>6. National security</th>
      <th>7. Entitlement programs</th>
      <th>8. Regulation</th>
      <th>Financial Regulation</th>
      <th>9. Trade policy</th>
      <th>10. Sovereign debt, currency crises</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1985-01-01</td>
      <td>213.678835</td>
      <td>270.469228</td>
      <td>292.614556</td>
      <td>295.790786</td>
      <td>394.099747</td>
      <td>107.848241</td>
      <td>179.699854</td>
      <td>258.346221</td>
      <td>129.632820</td>
      <td>113.247177</td>
      <td>88.182852</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1985-02-01</td>
      <td>155.426022</td>
      <td>219.835677</td>
      <td>164.235536</td>
      <td>139.125596</td>
      <td>225.032780</td>
      <td>36.733030</td>
      <td>124.859498</td>
      <td>82.492997</td>
      <td>55.191052</td>
      <td>0.000000</td>
      <td>45.052521</td>
      <td>129.210224</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1985-03-01</td>
      <td>121.137375</td>
      <td>119.034522</td>
      <td>108.828815</td>
      <td>115.714342</td>
      <td>102.026340</td>
      <td>31.642944</td>
      <td>63.269264</td>
      <td>113.699141</td>
      <td>85.577836</td>
      <td>149.521522</td>
      <td>77.619208</td>
      <td>111.305596</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1985-04-01</td>
      <td>104.982353</td>
      <td>122.044760</td>
      <td>104.737331</td>
      <td>85.760217</td>
      <td>138.080529</td>
      <td>38.066636</td>
      <td>85.627432</td>
      <td>51.292760</td>
      <td>60.054521</td>
      <td>44.968804</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1985-05-01</td>
      <td>115.736778</td>
      <td>107.573580</td>
      <td>134.839967</td>
      <td>132.177769</td>
      <td>167.568909</td>
      <td>54.705931</td>
      <td>109.383122</td>
      <td>98.284429</td>
      <td>65.756140</td>
      <td>129.250207</td>
      <td>67.096018</td>
      <td>96.215388</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>398</th>
      <td>2018-03-01</td>
      <td>70.949700</td>
      <td>27.382046</td>
      <td>80.343315</td>
      <td>90.853825</td>
      <td>34.977241</td>
      <td>65.432448</td>
      <td>95.712855</td>
      <td>42.536581</td>
      <td>84.858496</td>
      <td>62.379657</td>
      <td>342.126663</td>
      <td>24.227560</td>
    </tr>
    <tr>
      <th>399</th>
      <td>2018-04-01</td>
      <td>84.527300</td>
      <td>30.688176</td>
      <td>96.291803</td>
      <td>107.118919</td>
      <td>34.141700</td>
      <td>103.495758</td>
      <td>132.415849</td>
      <td>91.895209</td>
      <td>110.558840</td>
      <td>101.766720</td>
      <td>279.552742</td>
      <td>44.191207</td>
    </tr>
    <tr>
      <th>400</th>
      <td>2018-05-01</td>
      <td>84.422401</td>
      <td>29.949787</td>
      <td>91.738551</td>
      <td>100.697529</td>
      <td>22.147036</td>
      <td>117.341815</td>
      <td>102.661424</td>
      <td>111.835199</td>
      <td>105.267006</td>
      <td>67.618538</td>
      <td>197.975014</td>
      <td>42.282276</td>
    </tr>
    <tr>
      <th>401</th>
      <td>2018-06-01</td>
      <td>100.570703</td>
      <td>29.374332</td>
      <td>112.038643</td>
      <td>118.412623</td>
      <td>46.773636</td>
      <td>99.891954</td>
      <td>156.477491</td>
      <td>48.867181</td>
      <td>92.919965</td>
      <td>57.123037</td>
      <td>318.385555</td>
      <td>93.998359</td>
    </tr>
    <tr>
      <th>402</th>
      <td>2018-07-01</td>
      <td>94.154529</td>
      <td>64.152077</td>
      <td>107.272366</td>
      <td>113.164986</td>
      <td>57.604112</td>
      <td>73.695676</td>
      <td>163.873994</td>
      <td>52.158096</td>
      <td>87.239533</td>
      <td>56.279940</td>
      <td>531.364008</td>
      <td>78.553979</td>
    </tr>
  </tbody>
</table>
<p>403 rows × 13 columns</p>
</div>



One word of caution: attempting to use **pd.read_excel** on a file that is open in Excel will throw an error. To be able to read the file in Pandas, we need to close the file in Excel and try again.
#### Using pd.read_excel with an Excel Workbook Containing Multiple Worksheets
Excel workbooks often contain multiple worksheets. By default, the function **pd.read_excel** will read data from the first worksheet in the workbook. To read a different worksheet, use the optional keyword argument sheet_name. This argument accepts the following values:
- A case-sensitive string containing the name of the worksheet.
- A zero-based integer index of the worksheet. 0 means the first
worksheet, 1 means the second worksheet, and so on.

#### Using pd.read_excel When the Header Row is Missing
By default, **read_excel** assumes that the first row of data contains column **names**. If these column names are missing, pass the keyword argument **header=None**. Provide column names by passing a list to the optional keyword argument names.
#### Skipping Rows and Blank Lines
Many Excel users place blank lines and text above the data in a worksheet. To handle this use case, use the optional keyword argument skiprows when calling **pd.read_excel**. To skip the first n lines of the file, use **skiprows=n**. Alternatively, to skip specific rows, pass a list of row numbers; unlike Excel, skiprows assumes row numbers begin at zero.


```python
df2=pd.read_excel('Categorical_EPU_Data.xlsx', header=None, skiprows=1, names=['date','epu','monetary_policy','fiscal_policy','taxes','gov_spending','health_care','national_security','entitlement_programs','regulation','financial_regulation','trade_policy','sov_debt_curr_crises'])
df2.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>epu</th>
      <th>monetary_policy</th>
      <th>fiscal_policy</th>
      <th>taxes</th>
      <th>gov_spending</th>
      <th>health_care</th>
      <th>national_security</th>
      <th>entitlement_programs</th>
      <th>regulation</th>
      <th>financial_regulation</th>
      <th>trade_policy</th>
      <th>sov_debt_curr_crises</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1985-01-01</td>
      <td>213.678835</td>
      <td>270.469228</td>
      <td>292.614556</td>
      <td>295.790786</td>
      <td>394.099747</td>
      <td>107.848241</td>
      <td>179.699854</td>
      <td>258.346221</td>
      <td>129.632820</td>
      <td>113.247177</td>
      <td>88.182852</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1985-02-01</td>
      <td>155.426022</td>
      <td>219.835677</td>
      <td>164.235536</td>
      <td>139.125596</td>
      <td>225.032780</td>
      <td>36.733030</td>
      <td>124.859498</td>
      <td>82.492997</td>
      <td>55.191052</td>
      <td>0.000000</td>
      <td>45.052521</td>
      <td>129.210224</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1985-03-01</td>
      <td>121.137375</td>
      <td>119.034522</td>
      <td>108.828815</td>
      <td>115.714342</td>
      <td>102.026340</td>
      <td>31.642944</td>
      <td>63.269264</td>
      <td>113.699141</td>
      <td>85.577836</td>
      <td>149.521522</td>
      <td>77.619208</td>
      <td>111.305596</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1985-04-01</td>
      <td>104.982353</td>
      <td>122.044760</td>
      <td>104.737331</td>
      <td>85.760217</td>
      <td>138.080529</td>
      <td>38.066636</td>
      <td>85.627432</td>
      <td>51.292760</td>
      <td>60.054521</td>
      <td>44.968804</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1985-05-01</td>
      <td>115.736778</td>
      <td>107.573580</td>
      <td>134.839967</td>
      <td>132.177769</td>
      <td>167.568909</td>
      <td>54.705931</td>
      <td>109.383122</td>
      <td>98.284429</td>
      <td>65.756140</td>
      <td>129.250207</td>
      <td>67.096018</td>
      <td>96.215388</td>
    </tr>
  </tbody>
</table>
</div>



#### Getting Help for pd.read_excel
The official documentation page for pd.read_excel is located here. Alternatively, type **help(pd.read_excel)** into a Jupyter notebook cell and execute the cell.
### 3.2.2 Importing data from a CSV file
CSV stands for “comma separated value.” A CSV file is a text file that uses commas to separate, or delimit, values. CSV format is commonly used to store small-to-medium sized data files because it can be used to transfer data between different software (e.g., SAS and Stata), and because all major operating systems support it.

By convention, the first row of a CSV file contains the column names. The Pandas function **pd.read_csv** is similar to **pd.read_excel**. The two functions accept many of the same arguments, such as **skiprows** and **names**. However, since CSV files are a text files. Some issues commonly arise when importing financial data in CSV format. In the remainder of this section, we demonstrate how to handle two of these issues: parsing date columns.


```python
import numpy as np
import pandas as pd

df3=pd.read_csv('EarningsNews.csv')
df3.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>RP_ENTITY_ID</th>
      <th>ISIN</th>
      <th>date</th>
      <th>firm</th>
      <th>press</th>
      <th>permno</th>
      <th>gvkey</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>18JAN2001</td>
      <td>2.0</td>
      <td>1.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>1</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>22JUL2003</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>2</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>17JUL2002</td>
      <td>3.0</td>
      <td>NaN</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>3</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>10MAR2006</td>
      <td>NaN</td>
      <td>1.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>4</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>24JUL2009</td>
      <td>4.0</td>
      <td>2.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
  </tbody>
</table>
</div>




```python
df3.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 299733 entries, 0 to 299732
    Data columns (total 7 columns):
     #   Column        Non-Null Count   Dtype  
    ---  ------        --------------   -----  
     0   RP_ENTITY_ID  299733 non-null  object 
     1   ISIN          299733 non-null  object 
     2   date          299733 non-null  object 
     3   firm          278710 non-null  float64
     4   press         109990 non-null  float64
     5   permno        299733 non-null  int64  
     6   gvkey         299733 non-null  int64  
    dtypes: float64(2), int64(2), object(3)
    memory usage: 16.0+ MB


#### Parsing Dates
The **pd.read_csv** function can parse dates. Simply tell the function which columns contain dates through the parse_dates keyword ar- gument, and Pandas usually imports the dates correctly.

To import the *date* field from our CSV file, we can use the following modification to our code:


```python
df4=pd.read_csv('EarningsNews.csv', parse_dates=['date'], dayfirst=True)
df4.info()
df4.head()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 299733 entries, 0 to 299732
    Data columns (total 7 columns):
     #   Column        Non-Null Count   Dtype         
    ---  ------        --------------   -----         
     0   RP_ENTITY_ID  299733 non-null  object        
     1   ISIN          299733 non-null  object        
     2   date          299733 non-null  datetime64[ns]
     3   firm          278710 non-null  float64       
     4   press         109990 non-null  float64       
     5   permno        299733 non-null  int64         
     6   gvkey         299733 non-null  int64         
    dtypes: datetime64[ns](1), float64(2), int64(2), object(2)
    memory usage: 16.0+ MB





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>RP_ENTITY_ID</th>
      <th>ISIN</th>
      <th>date</th>
      <th>firm</th>
      <th>press</th>
      <th>permno</th>
      <th>gvkey</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>2001-01-18</td>
      <td>2.0</td>
      <td>1.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>1</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>2003-07-22</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>2</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>2002-07-17</td>
      <td>3.0</td>
      <td>NaN</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>3</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>2006-03-10</td>
      <td>NaN</td>
      <td>1.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
    <tr>
      <th>4</th>
      <td>164D72</td>
      <td>AN8068571086</td>
      <td>2009-07-24</td>
      <td>4.0</td>
      <td>2.0</td>
      <td>14277</td>
      <td>9465</td>
    </tr>
  </tbody>
</table>
</div>



#### Getting Help for pd.read_csv
The official documentation page for **pd.read_csv** is located [here](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html). Alternatively, type **help(pd.read_csv)** into a Jupyter notebook cell and execute the cell.
### 3.2.3 Importing Data from Stata
Use the function **pd.read_stata** to read Stata .dta files. At the time of this writing, **pd.read_stata** supports Stata versions 10–14. If your Stata file was written by a later version of Stata, either save it to an earlier version or save it to Excel or CSV.
### 3.2.4 Importing Data from SAS
Use the function **pd.read_sas** to read SAS files. This function can read SAS xport (.XPT) files and SAS7BDAT files. In our experience, this function can be finicky. If you have a valid SAS license and SAS installation on your computer and plan to regularly pass data between SAS and Python, we highly recommend the package **SASPy**. This package was written by The SAS Institute and is officially supported.
### 3.2.5 Exporting Data
Every **read_** function discussed in this paper has a corresponding **write_** function. It is therefore straightforward to save data to a desired format.
## 3.3 Viewing Data in Pandas
Researchers working with Pandas in Jupyter Notebooks have several options for viewing data. To view an entire DataFrame (or Series), simply type the name of the variable into a cell and run the cell. The data will be shown underneath the cell. If the DataFrame has many rows, Jupyter will show the top and bottom rows. Pandas users typically only need to view a few rows at a time. This is accomplished using the head and tail commands. For example, if the variable df stores a DataFrame, **df.head()** will display the first 5 rows of that DataFrame, and **df.tail()** will display the last 5 rows. To specify the number of rows to display, pass an optional argument to head or tail. Thus, **df.head(3)** will display the first 3 rows of *df*.

Use DataFrame’s sample method to view randomly selected rows. **df.sample()** will display one randomly chosen row and **df.sample(n)** will display n randomly chosen rows.
## 3.4 Selecting and Filtering Data

This chapter demonstrates the basics of selecting and filtering data in Pandas DataFrames. By selecting, we mean choosing a subset (usually columns) of a DataFrame. By filtering, we mean choosing a subset of rows with values that meet certain criteria. Pandas provides many features for selecting and filtering data and there are often multiple ways to do the same thing. We will only scratch the surface of Pandas’ capabilities.
### 3.4.1 Selecting Columns of a DataFrame
To select a subset of columns, you can call the frame with a list argument inside square brackets:


```python
ratings.head()
ratings[['gvkey','datadate']]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
      <td>None</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
      <td>None</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
</div>






<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3023647</th>
      <td>316056</td>
      <td>2016-10-31</td>
    </tr>
    <tr>
      <th>3023648</th>
      <td>316056</td>
      <td>2016-11-30</td>
    </tr>
    <tr>
      <th>3023649</th>
      <td>316056</td>
      <td>2016-12-31</td>
    </tr>
    <tr>
      <th>3023650</th>
      <td>316056</td>
      <td>2017-01-31</td>
    </tr>
    <tr>
      <th>3023651</th>
      <td>316056</td>
      <td>2017-02-28</td>
    </tr>
  </tbody>
</table>
<p>3023652 rows × 2 columns</p>
</div>



### 3.4.2 Filtering a DataFrame
Filtering is the process of extracting rows of a dataset that meet certain criteria. The main idea behind filtering in Pandas is to pass a Boolean series to a DataFrame; only rows for which the Boolean Series is true are kept in the filtered DataFrame.


```python
ratings['datadate']=pd.to_datetime(ratings['datadate'],format='%Y-%m-%d')
ratings_00s=ratings[(ratings['datadate'].dt.year>=2000) & (ratings['datadate'].dt.year<=2009)].copy()
ratings_00s.sort_values('datadate')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1167305</th>
      <td>014947</td>
      <td>2000-01-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2178158</th>
      <td>065348</td>
      <td>2000-01-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>315652</th>
      <td>004783</td>
      <td>2000-01-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>784717</th>
      <td>010301</td>
      <td>2000-01-31</td>
      <td>BBB</td>
    </tr>
    <tr>
      <th>1295753</th>
      <td>017678</td>
      <td>2000-01-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2396894</th>
      <td>116826</td>
      <td>2009-12-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>409103</th>
      <td>005899</td>
      <td>2009-12-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2396667</th>
      <td>116791</td>
      <td>2009-12-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2330291</th>
      <td>108823</td>
      <td>2009-12-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>3023098</th>
      <td>291721</td>
      <td>2009-12-31</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
<p>1290140 rows × 3 columns</p>
</div>



## 3.5 Creating new columns
Each column of a DataFrame is a Series. Therefore, creating a new column implies creating a Series. Typically, new columns are created as transformations of existing columns. However, sometimes new columns contain single values.
### 3.5.1 Creating a column from a scalar value
Pandas makes it very easy to create a new column that contains a single, repeated value. Simply assign that value to a column of the DataFrame that does not already exist.


```python
ratings['newcol']=1
ratings
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
      <th>newcol</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
      <td>None</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
      <td>None</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
      <td>None</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
      <td>None</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
      <td>None</td>
      <td>1</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3023647</th>
      <td>316056</td>
      <td>2016-10-31</td>
      <td>BBB-</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3023648</th>
      <td>316056</td>
      <td>2016-11-30</td>
      <td>BBB-</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3023649</th>
      <td>316056</td>
      <td>2016-12-31</td>
      <td>BBB-</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3023650</th>
      <td>316056</td>
      <td>2017-01-31</td>
      <td>BBB-</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3023651</th>
      <td>316056</td>
      <td>2017-02-28</td>
      <td>BBB-</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
<p>3023652 rows × 4 columns</p>
</div>



This code tells Pandas to first create a DataFrame containing a single column. The second line of code references a column named 'newcol' in DataFrame *ratings*. Since that column does not exist, Pandas will create it. When Pandas sees a single, scalar value assigned to a Series, it automatically adds that value to every row of the DataFrame.

To summarize, to create a new column in a DataFrame containing
a single, repeated value:

- Type the DataFrame name followed by square brackets.

- Inside the square brackets, type the name of the new column as a string.

- After the brackets, type an equals sign and then the desired value.

### 3.5.2 Creating a column as a transformation of an existing column
Column transformations are very common. Examples of column trans- formation are to (1) strip whitespace from all values in a column, (2) convert a string column to uppercase, and (3) perform a mathematical operation on every value in a column. In this section, we provide sample code that implements these examples. Often, when cleaning data like this, it is desirable to do so “in place” (i.e., instead of creating a new column, replace data in an existing column with transformed data).

We will extract the year from 'datadate' in the *ratings* DataFrame and add it to the DataFrame:


```python
ratings['year']=ratings['datadate'].dt.year
ratings
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
      <th>newcol</th>
      <th>year</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
      <td>None</td>
      <td>1</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
      <td>None</td>
      <td>1</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
      <td>None</td>
      <td>1</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
      <td>None</td>
      <td>1</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
      <td>None</td>
      <td>1</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3023647</th>
      <td>316056</td>
      <td>2016-10-31</td>
      <td>BBB-</td>
      <td>1</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023648</th>
      <td>316056</td>
      <td>2016-11-30</td>
      <td>BBB-</td>
      <td>1</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023649</th>
      <td>316056</td>
      <td>2016-12-31</td>
      <td>BBB-</td>
      <td>1</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023650</th>
      <td>316056</td>
      <td>2017-01-31</td>
      <td>BBB-</td>
      <td>1</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>3023651</th>
      <td>316056</td>
      <td>2017-02-28</td>
      <td>BBB-</td>
      <td>1</td>
      <td>2017</td>
    </tr>
  </tbody>
</table>
<p>3023652 rows × 5 columns</p>
</div>



## 3.6 Dropping and renaming columns
### 3.6.1 Dropping columns
Use the aptly named drop method to drop columns from a Pandas DataFrame. Pass a list of unwanted column names to the columns keyword argument. For example, if we wanted to drop the 'newcol' column from the *ratings* DataFrame, we could do the following:


```python
ratings.drop(columns=['newcol'], inplace=True)
ratings
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
      <th>year</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3023647</th>
      <td>316056</td>
      <td>2016-10-31</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023648</th>
      <td>316056</td>
      <td>2016-11-30</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023649</th>
      <td>316056</td>
      <td>2016-12-31</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023650</th>
      <td>316056</td>
      <td>2017-01-31</td>
      <td>BBB-</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>3023651</th>
      <td>316056</td>
      <td>2017-02-28</td>
      <td>BBB-</td>
      <td>2017</td>
    </tr>
  </tbody>
</table>
<p>3023652 rows × 4 columns</p>
</div>



Notice the keyword argument inplace. By default, the drop method returns a new DataFrame. To force drop to operate in place, this argument is needed. An alternative method for dropping columns in place is to reassign the result to the existing DataFrame. For example:


```python
ratings2=ratings.drop(columns=['year'])
ratings2
ratings
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
      <td>None</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
      <td>None</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
      <td>None</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3023647</th>
      <td>316056</td>
      <td>2016-10-31</td>
      <td>BBB-</td>
    </tr>
    <tr>
      <th>3023648</th>
      <td>316056</td>
      <td>2016-11-30</td>
      <td>BBB-</td>
    </tr>
    <tr>
      <th>3023649</th>
      <td>316056</td>
      <td>2016-12-31</td>
      <td>BBB-</td>
    </tr>
    <tr>
      <th>3023650</th>
      <td>316056</td>
      <td>2017-01-31</td>
      <td>BBB-</td>
    </tr>
    <tr>
      <th>3023651</th>
      <td>316056</td>
      <td>2017-02-28</td>
      <td>BBB-</td>
    </tr>
  </tbody>
</table>
<p>3023652 rows × 3 columns</p>
</div>






<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>splticrm</th>
      <th>year</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3023647</th>
      <td>316056</td>
      <td>2016-10-31</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023648</th>
      <td>316056</td>
      <td>2016-11-30</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023649</th>
      <td>316056</td>
      <td>2016-12-31</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023650</th>
      <td>316056</td>
      <td>2017-01-31</td>
      <td>BBB-</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>3023651</th>
      <td>316056</td>
      <td>2017-02-28</td>
      <td>BBB-</td>
      <td>2017</td>
    </tr>
  </tbody>
</table>
<p>3023652 rows × 4 columns</p>
</div>



### 3.6.2 Renaming columns
The **rename** method works similarly to the **drop** method demonstrated above. However, instead of passing a list to the **columns** keyword argument, rename requires a *dictionary*. Each key in the dictionary must be the name of an existing column; the corresponding value is the new name for that column. This should be clear from the following example.

We will change the names of the 'datadate' and 'splticrm' variables in the ratings DataFrame:


```python
ratings.rename(columns={'datadate':'rating_date','splticrm':'rating'}, inplace=True)
ratings
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>rating_date</th>
      <th>rating</th>
      <th>year</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001003</td>
      <td>2004-06-30</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001003</td>
      <td>2004-07-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001003</td>
      <td>2004-08-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001003</td>
      <td>2004-09-30</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001003</td>
      <td>2004-10-31</td>
      <td>None</td>
      <td>2004</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3023647</th>
      <td>316056</td>
      <td>2016-10-31</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023648</th>
      <td>316056</td>
      <td>2016-11-30</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023649</th>
      <td>316056</td>
      <td>2016-12-31</td>
      <td>BBB-</td>
      <td>2016</td>
    </tr>
    <tr>
      <th>3023650</th>
      <td>316056</td>
      <td>2017-01-31</td>
      <td>BBB-</td>
      <td>2017</td>
    </tr>
    <tr>
      <th>3023651</th>
      <td>316056</td>
      <td>2017-02-28</td>
      <td>BBB-</td>
      <td>2017</td>
    </tr>
  </tbody>
</table>
<p>3023652 rows × 4 columns</p>
</div>



## 3.7 Sorting data
To sort data in a DataFrm, use the **sort_values** method. Use the following keyword arguments to achieve the desired result:

- **by**: pass a list of column names by which to sort

- **ascending**: Use **True** (**False**) to sort all columns in ascending (descending) order. Alternatively, pass a list of Booleans to specify the sort order for each column named in the by argument.

- **inplace**: Use **True** to sort in-place. If this argument is omitted or set to **False**, then **sort_values** will return a new, sorted DataFrame.

Let's sort the *ratings* DataFrame by year and rating.


```python
sorted_ratings=ratings.sort_values(by=['year','rating'], ascending=[True,False])
sorted_ratings[(sorted_ratings['year']==2000) & (sorted_ratings['rating'].notna())]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>rating_date</th>
      <th>rating</th>
      <th>year</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1722827</th>
      <td>028888</td>
      <td>2000-01-31</td>
      <td>SD</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>1722828</th>
      <td>028888</td>
      <td>2000-02-29</td>
      <td>SD</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>1722829</th>
      <td>028888</td>
      <td>2000-03-31</td>
      <td>SD</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>1722830</th>
      <td>028888</td>
      <td>2000-04-30</td>
      <td>SD</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>1722831</th>
      <td>028888</td>
      <td>2000-05-31</td>
      <td>SD</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3001373</th>
      <td>220940</td>
      <td>2000-10-31</td>
      <td>A</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>3001374</th>
      <td>220940</td>
      <td>2000-11-30</td>
      <td>A</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>3001375</th>
      <td>220940</td>
      <td>2000-12-31</td>
      <td>A</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>3006133</th>
      <td>224817</td>
      <td>2000-11-30</td>
      <td>A</td>
      <td>2000</td>
    </tr>
    <tr>
      <th>3006134</th>
      <td>224817</td>
      <td>2000-12-31</td>
      <td>A</td>
      <td>2000</td>
    </tr>
  </tbody>
</table>
<p>27459 rows × 4 columns</p>
</div>



## 3.8 Summarizing data
You can easily use the Pandas package to get summary statistics for your data. Summary statistics can be applied using various methods and can be applied to groups of variables. For instance, we can collapse the EPU data that we imported earlier to the annual level.


```python
df2['year']=df2['date'].dt.year
df2
## Only retain 'EPU'
annual_epu=df2.groupby('year')['epu'].mean()
annual_epu

## Retain all variables at the annual level
annual=df2.groupby('year').mean()
annual
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>epu</th>
      <th>monetary_policy</th>
      <th>fiscal_policy</th>
      <th>taxes</th>
      <th>gov_spending</th>
      <th>health_care</th>
      <th>national_security</th>
      <th>entitlement_programs</th>
      <th>regulation</th>
      <th>financial_regulation</th>
      <th>trade_policy</th>
      <th>sov_debt_curr_crises</th>
      <th>year</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1985-01-01</td>
      <td>213.678835</td>
      <td>270.469228</td>
      <td>292.614556</td>
      <td>295.790786</td>
      <td>394.099747</td>
      <td>107.848241</td>
      <td>179.699854</td>
      <td>258.346221</td>
      <td>129.632820</td>
      <td>113.247177</td>
      <td>88.182852</td>
      <td>0.000000</td>
      <td>1985</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1985-02-01</td>
      <td>155.426022</td>
      <td>219.835677</td>
      <td>164.235536</td>
      <td>139.125596</td>
      <td>225.032780</td>
      <td>36.733030</td>
      <td>124.859498</td>
      <td>82.492997</td>
      <td>55.191052</td>
      <td>0.000000</td>
      <td>45.052521</td>
      <td>129.210224</td>
      <td>1985</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1985-03-01</td>
      <td>121.137375</td>
      <td>119.034522</td>
      <td>108.828815</td>
      <td>115.714342</td>
      <td>102.026340</td>
      <td>31.642944</td>
      <td>63.269264</td>
      <td>113.699141</td>
      <td>85.577836</td>
      <td>149.521522</td>
      <td>77.619208</td>
      <td>111.305596</td>
      <td>1985</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1985-04-01</td>
      <td>104.982353</td>
      <td>122.044760</td>
      <td>104.737331</td>
      <td>85.760217</td>
      <td>138.080529</td>
      <td>38.066636</td>
      <td>85.627432</td>
      <td>51.292760</td>
      <td>60.054521</td>
      <td>44.968804</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>1985</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1985-05-01</td>
      <td>115.736778</td>
      <td>107.573580</td>
      <td>134.839967</td>
      <td>132.177769</td>
      <td>167.568909</td>
      <td>54.705931</td>
      <td>109.383122</td>
      <td>98.284429</td>
      <td>65.756140</td>
      <td>129.250207</td>
      <td>67.096018</td>
      <td>96.215388</td>
      <td>1985</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>398</th>
      <td>2018-03-01</td>
      <td>70.949700</td>
      <td>27.382046</td>
      <td>80.343315</td>
      <td>90.853825</td>
      <td>34.977241</td>
      <td>65.432448</td>
      <td>95.712855</td>
      <td>42.536581</td>
      <td>84.858496</td>
      <td>62.379657</td>
      <td>342.126663</td>
      <td>24.227560</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>399</th>
      <td>2018-04-01</td>
      <td>84.527300</td>
      <td>30.688176</td>
      <td>96.291803</td>
      <td>107.118919</td>
      <td>34.141700</td>
      <td>103.495758</td>
      <td>132.415849</td>
      <td>91.895209</td>
      <td>110.558840</td>
      <td>101.766720</td>
      <td>279.552742</td>
      <td>44.191207</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>400</th>
      <td>2018-05-01</td>
      <td>84.422401</td>
      <td>29.949787</td>
      <td>91.738551</td>
      <td>100.697529</td>
      <td>22.147036</td>
      <td>117.341815</td>
      <td>102.661424</td>
      <td>111.835199</td>
      <td>105.267006</td>
      <td>67.618538</td>
      <td>197.975014</td>
      <td>42.282276</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>401</th>
      <td>2018-06-01</td>
      <td>100.570703</td>
      <td>29.374332</td>
      <td>112.038643</td>
      <td>118.412623</td>
      <td>46.773636</td>
      <td>99.891954</td>
      <td>156.477491</td>
      <td>48.867181</td>
      <td>92.919965</td>
      <td>57.123037</td>
      <td>318.385555</td>
      <td>93.998359</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>402</th>
      <td>2018-07-01</td>
      <td>94.154529</td>
      <td>64.152077</td>
      <td>107.272366</td>
      <td>113.164986</td>
      <td>57.604112</td>
      <td>73.695676</td>
      <td>163.873994</td>
      <td>52.158096</td>
      <td>87.239533</td>
      <td>56.279940</td>
      <td>531.364008</td>
      <td>78.553979</td>
      <td>2018</td>
    </tr>
  </tbody>
</table>
<p>403 rows × 14 columns</p>
</div>






    year
    1985    126.191508
    1986    128.878619
    1987    112.466545
    1988    103.178799
    1989     87.786837
    1990    132.537502
    1991    135.245365
    1992    137.698789
    1993    117.951010
    1994     91.609789
    1995     88.094065
    1996     74.291739
    1997     65.517280
    1998     90.064893
    1999     59.311176
    2000     71.730036
    2001    129.112825
    2002    111.425528
    2003    114.130102
    2004     71.183726
    2005     59.735664
    2006     56.062118
    2007     58.549745
    2008    124.360158
    2009    118.635289
    2010    134.250892
    2011    132.762859
    2012    134.025010
    2013    108.351731
    2014     64.768412
    2015     64.988918
    2016     77.750079
    2017     92.594753
    2018     88.995013
    Name: epu, dtype: float64






<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>epu</th>
      <th>monetary_policy</th>
      <th>fiscal_policy</th>
      <th>taxes</th>
      <th>gov_spending</th>
      <th>health_care</th>
      <th>national_security</th>
      <th>entitlement_programs</th>
      <th>regulation</th>
      <th>financial_regulation</th>
      <th>trade_policy</th>
      <th>sov_debt_curr_crises</th>
    </tr>
    <tr>
      <th>year</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1985</th>
      <td>126.191508</td>
      <td>137.195482</td>
      <td>141.111016</td>
      <td>131.740702</td>
      <td>181.966016</td>
      <td>37.587383</td>
      <td>112.272421</td>
      <td>96.017917</td>
      <td>76.219819</td>
      <td>60.485116</td>
      <td>68.595956</td>
      <td>95.019768</td>
    </tr>
    <tr>
      <th>1986</th>
      <td>128.878619</td>
      <td>128.437649</td>
      <td>156.533631</td>
      <td>151.850726</td>
      <td>187.936036</td>
      <td>53.255540</td>
      <td>111.394843</td>
      <td>60.815620</td>
      <td>102.508627</td>
      <td>96.688842</td>
      <td>92.759661</td>
      <td>96.220849</td>
    </tr>
    <tr>
      <th>1987</th>
      <td>112.466545</td>
      <td>129.799471</td>
      <td>118.039189</td>
      <td>100.283102</td>
      <td>177.730991</td>
      <td>48.055401</td>
      <td>97.020168</td>
      <td>70.063269</td>
      <td>103.220243</td>
      <td>159.557261</td>
      <td>95.685350</td>
      <td>131.219446</td>
    </tr>
    <tr>
      <th>1988</th>
      <td>103.178799</td>
      <td>107.505636</td>
      <td>99.872102</td>
      <td>89.998131</td>
      <td>129.300827</td>
      <td>58.055240</td>
      <td>88.010151</td>
      <td>62.321515</td>
      <td>88.561240</td>
      <td>94.678232</td>
      <td>103.590925</td>
      <td>117.640820</td>
    </tr>
    <tr>
      <th>1989</th>
      <td>87.786837</td>
      <td>79.191911</td>
      <td>72.521176</td>
      <td>67.116664</td>
      <td>80.988643</td>
      <td>39.929499</td>
      <td>88.777918</td>
      <td>46.268189</td>
      <td>90.768883</td>
      <td>113.246425</td>
      <td>79.869901</td>
      <td>67.724564</td>
    </tr>
    <tr>
      <th>1990</th>
      <td>132.537502</td>
      <td>113.218285</td>
      <td>129.411066</td>
      <td>111.488883</td>
      <td>180.471488</td>
      <td>69.436001</td>
      <td>175.806815</td>
      <td>76.855311</td>
      <td>134.555526</td>
      <td>173.286566</td>
      <td>128.238024</td>
      <td>67.751414</td>
    </tr>
    <tr>
      <th>1991</th>
      <td>135.245365</td>
      <td>138.273711</td>
      <td>118.009239</td>
      <td>114.774158</td>
      <td>131.037045</td>
      <td>108.001126</td>
      <td>203.767793</td>
      <td>119.979031</td>
      <td>135.842623</td>
      <td>209.996253</td>
      <td>92.689565</td>
      <td>25.490750</td>
    </tr>
    <tr>
      <th>1992</th>
      <td>137.698789</td>
      <td>125.138739</td>
      <td>141.435030</td>
      <td>137.858078</td>
      <td>153.446085</td>
      <td>136.965037</td>
      <td>143.720635</td>
      <td>104.080275</td>
      <td>118.494080</td>
      <td>83.073189</td>
      <td>201.641538</td>
      <td>210.311074</td>
    </tr>
    <tr>
      <th>1993</th>
      <td>117.951010</td>
      <td>84.128190</td>
      <td>128.261884</td>
      <td>132.943570</td>
      <td>117.987301</td>
      <td>201.301687</td>
      <td>102.374561</td>
      <td>135.306245</td>
      <td>132.674589</td>
      <td>46.048860</td>
      <td>407.887560</td>
      <td>101.863643</td>
    </tr>
    <tr>
      <th>1994</th>
      <td>91.609789</td>
      <td>93.769323</td>
      <td>64.811242</td>
      <td>64.828009</td>
      <td>59.755001</td>
      <td>114.804677</td>
      <td>88.192446</td>
      <td>78.156423</td>
      <td>83.009785</td>
      <td>28.128924</td>
      <td>281.453477</td>
      <td>62.553126</td>
    </tr>
    <tr>
      <th>1995</th>
      <td>88.094065</td>
      <td>93.923413</td>
      <td>85.396267</td>
      <td>74.751874</td>
      <td>117.566783</td>
      <td>91.157483</td>
      <td>66.867825</td>
      <td>128.319507</td>
      <td>98.372427</td>
      <td>39.107498</td>
      <td>145.853940</td>
      <td>136.816414</td>
    </tr>
    <tr>
      <th>1996</th>
      <td>74.291739</td>
      <td>63.636118</td>
      <td>74.706357</td>
      <td>72.977090</td>
      <td>83.379854</td>
      <td>91.558754</td>
      <td>58.826896</td>
      <td>109.499467</td>
      <td>85.194941</td>
      <td>21.387997</td>
      <td>83.678472</td>
      <td>17.011394</td>
    </tr>
    <tr>
      <th>1997</th>
      <td>65.517280</td>
      <td>53.161779</td>
      <td>54.155832</td>
      <td>55.824895</td>
      <td>42.699348</td>
      <td>53.743844</td>
      <td>47.667159</td>
      <td>77.990187</td>
      <td>69.003301</td>
      <td>28.040851</td>
      <td>90.475524</td>
      <td>149.320742</td>
    </tr>
    <tr>
      <th>1998</th>
      <td>90.064893</td>
      <td>112.609855</td>
      <td>71.703833</td>
      <td>75.226888</td>
      <td>55.267990</td>
      <td>63.526505</td>
      <td>61.190383</td>
      <td>103.460553</td>
      <td>65.115594</td>
      <td>33.771738</td>
      <td>69.786170</td>
      <td>653.372608</td>
    </tr>
    <tr>
      <th>1999</th>
      <td>59.311176</td>
      <td>65.567052</td>
      <td>50.087238</td>
      <td>52.981339</td>
      <td>43.132095</td>
      <td>62.941889</td>
      <td>46.653423</td>
      <td>85.965111</td>
      <td>51.801850</td>
      <td>28.137340</td>
      <td>80.136478</td>
      <td>110.524373</td>
    </tr>
    <tr>
      <th>2000</th>
      <td>71.730036</td>
      <td>92.503242</td>
      <td>56.703639</td>
      <td>61.449579</td>
      <td>36.857734</td>
      <td>75.725200</td>
      <td>51.989152</td>
      <td>86.364536</td>
      <td>85.561955</td>
      <td>38.119270</td>
      <td>100.673806</td>
      <td>68.818603</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>129.112825</td>
      <td>168.620139</td>
      <td>136.633304</td>
      <td>147.085518</td>
      <td>111.348554</td>
      <td>123.206909</td>
      <td>154.184775</td>
      <td>167.100904</td>
      <td>108.643836</td>
      <td>98.529951</td>
      <td>78.038185</td>
      <td>66.577386</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>111.425528</td>
      <td>120.529318</td>
      <td>105.858480</td>
      <td>112.890461</td>
      <td>89.786182</td>
      <td>118.358328</td>
      <td>171.040631</td>
      <td>153.803015</td>
      <td>109.675629</td>
      <td>168.778396</td>
      <td>44.516195</td>
      <td>35.939760</td>
    </tr>
    <tr>
      <th>2003</th>
      <td>114.130102</td>
      <td>118.001774</td>
      <td>143.147875</td>
      <td>152.568285</td>
      <td>131.367486</td>
      <td>133.532801</td>
      <td>228.008733</td>
      <td>129.312406</td>
      <td>101.390304</td>
      <td>111.206460</td>
      <td>59.938760</td>
      <td>41.429293</td>
    </tr>
    <tr>
      <th>2004</th>
      <td>71.183726</td>
      <td>75.477985</td>
      <td>77.717946</td>
      <td>83.142919</td>
      <td>51.740696</td>
      <td>114.659218</td>
      <td>102.105863</td>
      <td>86.859410</td>
      <td>68.248054</td>
      <td>43.561024</td>
      <td>42.625011</td>
      <td>17.723845</td>
    </tr>
    <tr>
      <th>2005</th>
      <td>59.735664</td>
      <td>63.318912</td>
      <td>50.991161</td>
      <td>53.481881</td>
      <td>33.438233</td>
      <td>61.831307</td>
      <td>57.342220</td>
      <td>75.822117</td>
      <td>51.764901</td>
      <td>41.139144</td>
      <td>47.387875</td>
      <td>35.973187</td>
    </tr>
    <tr>
      <th>2006</th>
      <td>56.062118</td>
      <td>67.144805</td>
      <td>41.704436</td>
      <td>44.596847</td>
      <td>20.891127</td>
      <td>60.544246</td>
      <td>51.379567</td>
      <td>46.515409</td>
      <td>57.024431</td>
      <td>36.020435</td>
      <td>31.306692</td>
      <td>17.028871</td>
    </tr>
    <tr>
      <th>2007</th>
      <td>58.549745</td>
      <td>76.042813</td>
      <td>43.863816</td>
      <td>46.980571</td>
      <td>23.862679</td>
      <td>56.492421</td>
      <td>42.475329</td>
      <td>41.732210</td>
      <td>59.679282</td>
      <td>64.254230</td>
      <td>30.932383</td>
      <td>12.744261</td>
    </tr>
    <tr>
      <th>2008</th>
      <td>124.360158</td>
      <td>124.330091</td>
      <td>123.791227</td>
      <td>133.426468</td>
      <td>77.212817</td>
      <td>139.587605</td>
      <td>105.693908</td>
      <td>108.176005</td>
      <td>160.626741</td>
      <td>284.417268</td>
      <td>51.679376</td>
      <td>39.848048</td>
    </tr>
    <tr>
      <th>2009</th>
      <td>118.635289</td>
      <td>74.021113</td>
      <td>132.196940</td>
      <td>138.422204</td>
      <td>108.963252</td>
      <td>196.458168</td>
      <td>61.974125</td>
      <td>140.274769</td>
      <td>150.700390</td>
      <td>231.591040</td>
      <td>32.272260</td>
      <td>18.423448</td>
    </tr>
    <tr>
      <th>2010</th>
      <td>134.250892</td>
      <td>94.453193</td>
      <td>181.336074</td>
      <td>191.311158</td>
      <td>171.865734</td>
      <td>289.283732</td>
      <td>81.262261</td>
      <td>208.940600</td>
      <td>211.340949</td>
      <td>266.747689</td>
      <td>58.286916</td>
      <td>202.652314</td>
    </tr>
    <tr>
      <th>2011</th>
      <td>132.762859</td>
      <td>93.557703</td>
      <td>181.702400</td>
      <td>171.749846</td>
      <td>243.792319</td>
      <td>246.051002</td>
      <td>78.650152</td>
      <td>224.847461</td>
      <td>183.354314</td>
      <td>197.696014</td>
      <td>61.376157</td>
      <td>372.753348</td>
    </tr>
    <tr>
      <th>2012</th>
      <td>134.025010</td>
      <td>93.361646</td>
      <td>202.975881</td>
      <td>210.338319</td>
      <td>223.724614</td>
      <td>282.381018</td>
      <td>80.857174</td>
      <td>245.770172</td>
      <td>158.061595</td>
      <td>190.051015</td>
      <td>45.745213</td>
      <td>393.331329</td>
    </tr>
    <tr>
      <th>2013</th>
      <td>108.351731</td>
      <td>76.453770</td>
      <td>140.621057</td>
      <td>126.143515</td>
      <td>202.942906</td>
      <td>221.982342</td>
      <td>72.360742</td>
      <td>199.004012</td>
      <td>115.266144</td>
      <td>106.154707</td>
      <td>38.981598</td>
      <td>82.698819</td>
    </tr>
    <tr>
      <th>2014</th>
      <td>64.768412</td>
      <td>39.491825</td>
      <td>66.890580</td>
      <td>68.105052</td>
      <td>47.312178</td>
      <td>119.766379</td>
      <td>43.347034</td>
      <td>95.661591</td>
      <td>104.838119</td>
      <td>75.819679</td>
      <td>42.238835</td>
      <td>34.621312</td>
    </tr>
    <tr>
      <th>2015</th>
      <td>64.988918</td>
      <td>51.105649</td>
      <td>56.982612</td>
      <td>59.942810</td>
      <td>39.563770</td>
      <td>75.674399</td>
      <td>46.961296</td>
      <td>65.099868</td>
      <td>91.069209</td>
      <td>68.967804</td>
      <td>35.905746</td>
      <td>59.516949</td>
    </tr>
    <tr>
      <th>2016</th>
      <td>77.750079</td>
      <td>74.342477</td>
      <td>76.329388</td>
      <td>80.286553</td>
      <td>53.376349</td>
      <td>109.515914</td>
      <td>63.665969</td>
      <td>63.850828</td>
      <td>107.806743</td>
      <td>90.797887</td>
      <td>94.291755</td>
      <td>101.543657</td>
    </tr>
    <tr>
      <th>2017</th>
      <td>92.594753</td>
      <td>46.216154</td>
      <td>111.241996</td>
      <td>119.460985</td>
      <td>77.858554</td>
      <td>190.853164</td>
      <td>72.928377</td>
      <td>124.301321</td>
      <td>117.107861</td>
      <td>81.220246</td>
      <td>123.838598</td>
      <td>32.540313</td>
    </tr>
    <tr>
      <th>2018</th>
      <td>88.995013</td>
      <td>36.674642</td>
      <td>102.982559</td>
      <td>112.556243</td>
      <td>45.809578</td>
      <td>105.754299</td>
      <td>113.567777</td>
      <td>82.450525</td>
      <td>98.694487</td>
      <td>55.555059</td>
      <td>284.595405</td>
      <td>45.822929</td>
    </tr>
  </tbody>
</table>
</div>



## 3.9 Merging data
Just like in Stata, SAS, and SQL, the Pandas module in Python can merge different DataFrames and Series together in a database-style approach.

Let's try to merge the credit rating data with a few variables from the Compustat annual file.


```python
db=wrds.Connection(wrds_username='sbonsall')

comp=db.raw_sql("select gvkey, datadate, at from comp.funda where date_part('year',datadate) between 2000 and 2010 and indfmt='INDL' and consol='C' and datafmt='STD'")

db.close()
```

    Loading library list...
    Done



```python
comp['datadate']=pd.to_datetime(comp['datadate'],format='%Y-%m-%d')
comp.info()
ratings.info()
merged=pd.merge(comp,ratings, left_on=['gvkey','datadate'], right_on=['gvkey','rating_date'],indicator=True, validate='1:1')
merged
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 122301 entries, 0 to 122300
    Data columns (total 3 columns):
     #   Column    Non-Null Count   Dtype         
    ---  ------    --------------   -----         
     0   gvkey     122301 non-null  object        
     1   datadate  122301 non-null  datetime64[ns]
     2   at        107018 non-null  float64       
    dtypes: datetime64[ns](1), float64(1), object(1)
    memory usage: 2.8+ MB
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 3023652 entries, 0 to 3023651
    Data columns (total 4 columns):
     #   Column       Dtype         
    ---  ------       -----         
     0   gvkey        object        
     1   rating_date  datetime64[ns]
     2   rating       object        
     3   year         int64         
    dtypes: datetime64[ns](1), int64(1), object(2)
    memory usage: 92.3+ MB





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gvkey</th>
      <th>datadate</th>
      <th>at</th>
      <th>rating_date</th>
      <th>rating</th>
      <th>year</th>
      <th>_merge</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>001004</td>
      <td>2002-05-31</td>
      <td>710.199</td>
      <td>2002-05-31</td>
      <td>BBB-</td>
      <td>2002</td>
      <td>both</td>
    </tr>
    <tr>
      <th>1</th>
      <td>001004</td>
      <td>2000-05-31</td>
      <td>740.998</td>
      <td>2000-05-31</td>
      <td>BBB</td>
      <td>2000</td>
      <td>both</td>
    </tr>
    <tr>
      <th>2</th>
      <td>001004</td>
      <td>2001-05-31</td>
      <td>701.854</td>
      <td>2001-05-31</td>
      <td>BBB</td>
      <td>2001</td>
      <td>both</td>
    </tr>
    <tr>
      <th>3</th>
      <td>001004</td>
      <td>2003-05-31</td>
      <td>686.621</td>
      <td>2003-05-31</td>
      <td>BB-</td>
      <td>2003</td>
      <td>both</td>
    </tr>
    <tr>
      <th>4</th>
      <td>001004</td>
      <td>2008-05-31</td>
      <td>1362.010</td>
      <td>2008-05-31</td>
      <td>BB</td>
      <td>2008</td>
      <td>both</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>97835</th>
      <td>287882</td>
      <td>2009-12-31</td>
      <td>27379.730</td>
      <td>2009-12-31</td>
      <td>BB+</td>
      <td>2009</td>
      <td>both</td>
    </tr>
    <tr>
      <th>97836</th>
      <td>287882</td>
      <td>2010-12-31</td>
      <td>35258.049</td>
      <td>2010-12-31</td>
      <td>BB+</td>
      <td>2010</td>
      <td>both</td>
    </tr>
    <tr>
      <th>97837</th>
      <td>291721</td>
      <td>2008-12-31</td>
      <td>104.344</td>
      <td>2008-12-31</td>
      <td>None</td>
      <td>2008</td>
      <td>both</td>
    </tr>
    <tr>
      <th>97838</th>
      <td>291721</td>
      <td>2009-12-31</td>
      <td>90.254</td>
      <td>2009-12-31</td>
      <td>None</td>
      <td>2009</td>
      <td>both</td>
    </tr>
    <tr>
      <th>97839</th>
      <td>291721</td>
      <td>2010-12-31</td>
      <td>124.520</td>
      <td>2010-12-31</td>
      <td>None</td>
      <td>2010</td>
      <td>both</td>
    </tr>
  </tbody>
</table>
<p>97840 rows × 7 columns</p>
</div>



## 3.10 Visualization
You can do a lot with graphs in Pandas and Python. The main module for plotting is called **matplotlib**. We will load that and then see how to graph. Obviously, you will have to play around with plotting for a while to a hang of all the available features.


```python
import matplotlib.pyplot as plt
df.info()
df.plot(x='Date')
plt.ylabel('Index Level')
plt.legend(loc='right', bbox_to_anchor=(1.7, 0.5))
plt.title('Policy Uncertainty Over Time')
plt.savefig('epu.png',dpi=400, bbox_inches='tight')
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 403 entries, 0 to 402
    Data columns (total 13 columns):
     #   Column                               Non-Null Count  Dtype         
    ---  ------                               --------------  -----         
     0   Date                                 403 non-null    datetime64[ns]
     1   1. Economic Policy Uncertainty       403 non-null    float64       
     2   2. Monetary policy                   403 non-null    float64       
     3   Fiscal Policy (Taxes OR Spending)    403 non-null    float64       
     4   3. Taxes                             403 non-null    float64       
     5   4. Government spending               403 non-null    float64       
     6   5. Health care                       403 non-null    float64       
     7   6. National security                 403 non-null    float64       
     8   7. Entitlement programs              403 non-null    float64       
     9   8. Regulation                        403 non-null    float64       
     10  Financial Regulation                 403 non-null    float64       
     11  9. Trade policy                      403 non-null    float64       
     12  10. Sovereign debt, currency crises  403 non-null    float64       
    dtypes: datetime64[ns](1), float64(12)
    memory usage: 41.1 KB





    <matplotlib.axes._subplots.AxesSubplot at 0x1297d7090>






    Text(0, 0.5, 'Index Level')






    <matplotlib.legend.Legend at 0x1296beed0>






    Text(0.5, 1.0, 'Policy Uncertainty Over Time')




    
![png](Lesson%202_files/Lesson%202_59_5.png)
    

