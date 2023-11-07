# Lesson 4: Extracting data from the web
We have, thus far, focused on some of the Python fundamentals. Today, we will put some of that to work and build a script that will scrape the Stanford Securities Class Action Clearinghouse database. This database houses a significant amount of information about federal securities class action lawsuits and has been used as a primary data source in numerous accounting and finance studies.
## 1 How do we pull in web content?
There are several ways to import web content into Python strings or lists, but probably the easiest to use is the **requests** library. You will need to import this library from **pip** before executing any commands in this lesson.
### 1.1 Making a request
The first task involved with making a request is assigning a URL to a Python object. Let's try this with my faculty page on the Smeal website.


```python
import requests

page=requests.get("https://directory.smeal.psu.edu/sbb151")
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

## 3 Extracting federal class action lawsuits
### 3.1 Import some Python modules
We are going to need some Python modules to help us out. Let's go ahead and import them now.


```python
import requests
from bs4 import BeautifulSoup
import re
from math import ceil
import csv
```

### 3.2 Determine the number of pages to scrape
One of the annoying aspects of the SCAC website is that when you go to the filings page, it returns the results in a number of pages. Let's take a look at the [filings](http://securities.stanford.edu/filings.html) page. 

Forunately, with a little bit of Python magic, we can figure out the number of pages of results, and then work through them one-at-a-time.


```python
scac = "http://securities.stanford.edu/filings.html"
page = requests.get(scac)
print(page.text)
```

We can observe the total filings count on the first page and SCAC provides 20 hits per page of results. Thus, we can extract the total number of filings, divide by twenty, and apply a ceiling integer function to provide the total number of pages that we need to scrape.

To get the total filings count, it appears that we need to search witin a &lt;h4&gt; tag.


```python
soup = BeautifulSoup(page.text, 'html.parser')
heading = soup.find_all('h4')[-1].get_text()
print(heading)
total_record_num = re.findall(r'\d+', heading)[0]
total_page_num = ceil(int(total_record_num) / 20)

print("Total number of filings: ",total_record_num)
print("Pages to scrape: ",total_page_num)
```

### 3.2 Webscrape all pages within SCAC
I am first going to set up a list with the headers of the columns that I am going to print to a CSV file with all of the class action lawsuits.


```python
container = [("filing_name", "filing_date", "district_court", "exchange", "ticker")]
```

Next, I am going to start with page number 1 and work until the last page that we calculated in *total_page_num*. We need to figure out the URL for each returned page so that we can "get" the URL through **requests**.


```python
i = 1
while i <= total_page_num:
    
    ## 1. The URL can be built as follows:
    url = scac + "?page=" + repr(i)
    #print(url)
    
    ## 2. Next, we will extract the URL with requests and parse the text with BeautifulSoup so that we can search the tag structure to get what we are looking for.
    page = requests.get(url)
    soup = BeautifulSoup(page.text, 'html.parser')
    
    ## 3. Extract the table containing the lawsuit data
    table = soup.find('table', class_ = 'table table-bordered table-striped table-hover')
    
    ## 4. Extract the body of the table
    tbody = table.find('tbody')
    
    ## 5. Loop through each row of the table and then define a tuple with the elements representing the filing name, filing date, district court, stock exchange of the defendant, and the ticker symbol of the defendant
    for row in tbody.find_all('tr'):
        #print(row)
        caseinfo=re.search(r'<tr.*?onclick="window\.location=\'(.+?)\'"',str(row),re.I|re.S)
        print(caseinfo.group(1))
        url2='http://securities.stanford.edu/'+caseinfo.group(1)
        page2=requests.get(url2)
        columns = row.find_all('td')
        c1 = re.sub(r'[\t\n]', '', columns[0].get_text()).strip()
        c2 = re.sub(r'[\t\n]', '', columns[1].get_text()).strip()
        c3 = re.sub(r'[\t\n]', '', columns[2].get_text()).strip()
        c4 = re.sub(r'[\t\n]', '', columns[3].get_text()).strip()
        c5 = re.sub(r'[\t\n]', '', columns[4].get_text()).strip()
        
        ## 6. Append the tuple with the data to our container list
        container.append((c1, c2, c3, c4, c5))
        
    ## 7. Increment the counter so that we can move on the the next page of results
    i = i + 1
```

### 3.3 Write to a CSV file
Let's now export the data in *container* to a CSV file using the **csv** module.


```python
with open('scac.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(container)
```


```python

```
