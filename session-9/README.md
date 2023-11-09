# Lesson 4: Extracting data from the web
We have, thus far, focused on some of the Python fundamentals. Today, we will put some of that to work and build a script that will scrape the NYU Law School Securities Enforcement Empirical Database. This database houses a significant amount of information about SEC enforcements against individuals and companies.
## 1 How do we pull in web content?
There are several ways to import web content into Python strings or lists, but probably the easiest to use is the **requests** library. You will need to import this library from **pip** before executing any commands in this lesson.
### 1.1 Making a request
The first task involved with making a request is assigning a URL to a Python object. Let's try this with my faculty page on the Smeal website.


```python
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

page=requests.get("https://directory.smeal.psu.edu/sbb151", verify=False)
```

To see whether the web page loaded without error, we can call the **status_code** method:


```python
page.status_code
```

A status code of "200" means everything is okay. You have probably seen the staus code "403 Forbidden" from a website at times. That is another possible code you could get. If you get anything but "200", you will need to investigate further. Error handling comes in handy


```python
if page.status_code==200:
    print("Everything is good!")
```

### 1.2 The content of the page
You can extract the content of the page by using the **text** attribute.


```python
print(page.text)
```

## 2 Making sense of the HTML content
As you can see from my Smeal directory web page above, extracting the actual text of the HTML code is only step one of the process for scraping web content. We need some way to "look" through the code and find what we are interested in collecting. Fortunately, Python has the **BeautifulSoup** module for parsing the HTML code. Let's dif into **BeautifulSoup**.


```python
from bs4 import BeautifulSoup
```

### 2.1 Read the HTML content into a BeautifulSoup object
We can read the text of the website into a BeautifulSoup object but also should specifiy the parser. I often use the "html5lib" because it is very lenient in interpreting the HTML code that it sees. The "html5lib" parser claims to parse pages the same way a web browser does, which is quite useful.


```python
soup=BeautifulSoup(page.text,'html5lib')

print(soup)
```

It looks like out "soup" object contains the same information as when we simply printed "page.text". However, BeautifulSoup has combed through the code and given use the ability to search!

### 2.2 Tags
BeautifulSoup captures the HTML tags for every tag in the code. You can access them as attributes of the main BeautifulSoup object. For instance, let's print the first "link" tag. Those looks like &lt;a&gt; in HTML.


```python
print(soup.a)
```

If you want to capture all of a given tag, you can easily loop through the tags using a **for** loop and the **find_all** method in BeautifulSoup:


```python
links=soup.find_all('a')
for link in links:
    print(link)
```

There are quite a few links in my directory page! What if we want to extract my bio entry? How would we do that? Well, we will need to scan the code to find the biography and see if there are any tags that might be of interest.

From my inspection, the biography is housed in a &lt;div&gt; tag with the additional attrribute of id="biography". That should be easy to extract with both of those identifiers.


```python
#print(soup.find(id='biography'))
print(soup.find(id='biography').p.get_text())
```

Easy, right? Let's turn our attention to getting some lawsuit data!

## 3 Extracting SEC enforcement data
### 3.1 Import some Python modules
We are going to need some Python modules to help us out. Let's go ahead and import them now.


```python
import requests
from bs4 import BeautifulSoup
import re
from math import ceil
import csv
```

### 3.2 Looking at the SEED data
Let's take a look at the [filings](https://research.seed.law.nyu.edu/Search/Results) page. 


```python
seed = "https://research.seed.law.nyu.edu/Search/Results"
page = requests.get(seed)
print(page.text)
```

All the data we want to extract is housed in an HTML table. We can use BeautifulSoup to extract elements of the table and build a Pandas dataframe that we can use for subsequent analysis.


```python
soup = BeautifulSoup(page.text, 'html5lib')
table = soup.find('table')
print(table)

```

### Extract 3.2 SEED data


```python
## 1. We will extract the body of the table with the results

tbody=table.find('tbody')

## 2. Next, we will loop through each row and save the data into a dictionary
data=[]
for i, row in enumerate(tbody.find_all('tr')):
    rdata=[]
    if i==0:
        for cell in row.find_all('th'):
            rdata.append(cell.a.get_text())
    else:
        for cell in row.find_all('td'):
            rdata.append(cell.get_text().strip())
    data.append(rdata)

print(data)



```

### 3.3 Convert to a Pandas dataframe
Let's now take our list of data and convert it into a Pandas dataframe.


```python
import pandas as pd

df=pd.DataFrame(data[1:], columns=data[0])
print(df)
```

### Export data to Excel

Now, we will export our dataframe to Excel so that we can use it in the future.


```python
df.to_excel('SEED_data.xlsx', index=False)
```
