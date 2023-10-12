# Regular expressions
## 1 Looking for patterns in text
The heart of text analysis is finding patterns in text. These patterns may be individual words, numbers, symbols, and many more. 

A *Regular Expression*, or *Regex*, is a sequence of characters that define a text search pattern. Regular expressions are useful in a wide variety of text processing tasks including identifying specific words, phrases, entity names, numbers, url links in text, splitting text into sentences, grouping sentences into categories, etc. For example, we can use regular expressions to identify positive and negative words in a document to subsequently determine its tone, to classify sentences in a document as forward-looking or risk-related, or to classify documents into categories depending if certain conditions are met.

In Python, the **re** module provides regular expression support. Some commonly used functions from this module include:

- **re.search(pattern, string)** scans through a string, looking or the first location where the regex **pattern** matches; output is a **Match** object if there is a match, or **None** otherwise;

- **re.findall(pattern, string)** finds all substrings where the regex **pattern** matches and returns them as a list;

- **re.split(pattern, string)** splits a string at every match of the regex pattern and returns a list of strings. For example, one can retrieve the individual words in a sentence by splitting at the spaces;

- **re.sub(pattern, repl, string)** finds all matches of pattern in string and replaces them with **repl**.

Regular expression patterns can be specified in either single and double quotation marks, '' and "". It is a good practice to insert the letter "r" before Regex patterns in Python’s re operations (e.g., **re.search(r'pattern', string)**). Prefixing with "r" indicates that backslashes \ should be treated literally and not as escape characters in Python. In other words, the "r" prefix indicates that the string is a "raw string." For example, the following code that demonstrates how to match a basic regex r"OI" in a sentence.


```python
# loads Python's regular expressions module
import re
text = "OI for FY 2019 was 12.4 billion, up more than eight percent from OI in FY 2018."

# returns a Match object of the first match, # if it exists
x1 = re.search(r"OI", text)

# finds all matches of "OI"
x2 = re.findall(r"OI", text) # splits text at ","
x3 = re.split(r",", text)

# replaces "OI" with "Operating Income"
x4 = re.sub(r"OI", "Operating Income", text)

print(f'Result of re.search:\n{x1}\n') 
print(f'Result of re.findall:\n{x2}\n') 
print(f'Result of re.split:\n{x3}\n') 
print(f'Result of re.sub:\n{x4}')
```

To perform case-insensitive Regex matching, we can either specify IGNORECASE flag in a **re** function or convert the input string to lower case using string’s **lower()** method:


```python
x1 = re.findall(r'MD&A', "This year's MD&a Section is located... Please refer to our md&A section on page ...", re.IGNORECASE)
x2 = re.findall(r'md&a', "This year's MD&a Section is located... Please refer to our md&A section on page ...".lower())

print(x1) 
print(x2)
```

Additional information on Regex in Python is available on the following websites:

- http://www.regular-expressions.info/

- https://docs.python.org/3/howto/regex.html

- https://docs.python.org/3.4/library/re.html

- https://www.w3schools.com/python/python_regex.asp

Also, there are many interactive websites online that allow users to test their regular expressions for correctness. For instance, https://regex101.com/ allows to perform regex testing on sample texts; it also provides useful explanations for what each regex element captures.

I suggest using these Rege tests before running a large-scale Python analysis just to make sure you get the results that you want; the content and format of textual documents are extremely unstructured.
## 2 Characters and character sets
### 2.1 Special characters
There are several special purpose characters in regular expressions: .^$*+?\{\}\[\]\|()

For a special character to be treated literally, we have to add a backslash (\) before that character. For example, \$ indicates the dollar sign and \\ indicates the backslash. For example:

- Regex r"\\\\$4.99" will match \\$4.99 in "Apple's Earnings per Share for the three months ended in December 2019 was \\$4.99," whereas Regex r"\\$4.99" will return no matches.

- Regex r"S-1\\A" will match S-1\A in "Form S-1\A," whereas Regex r"S-1\A" will return no matches.

### 2.2 Charcter sets in Regex
*Character Sets* provide means to match any single character in a given set of characters. To specify a character set, we use square brackets, \[ and \]. For example, regex '10-[KQ]' has a character set '\[KQ\]' and will match both ‘10-K’ and ‘10-Q’ in a string.

A hyphen can be used inside character sets to indicate a range of characters:

- **\[a-z\]** matches any lowercase letter between 'a' and 'z';

- **\[A-Z\]** matches any uppercase letter between 'A' and 'Z';

- **\[a-zA-Z\]** matches any letter in the English alphabet (both upper- and lowercase);

- **\[0-9\]** matches a single digit between 0 and 9;

*Negated Character Sets* are used to match any single character except a character from a specified character set. Negated character sets are enclosed in **\[^ \]**. For example, **\[^a-z\]** matches anything as long as it is not a lowercase letter in the a-z range.

*Common Character Sets* have shorthand notations. For instance:

- **.** matches any character except a newline (i.e., **\[^\n\]**);

- **\d** matches a digit character (i.e., **\[0-9\]**);

- **\D** matches a non-digit character (i.e., **\[^0-9\]**); 

- **\w** matches a word character (including digits and underscores) (i.e., **\[a-zA-Z0-9_\]**);

- **\W** matches a non-word character (i.e., **\[^a-zA-Z0-9_\]**);

- **\s** matches a whitespace, new line, tab, carriage return, etc. (i.e., **\[ \f\n\r\t\v\]**);

- **\S** matches everything, but a whitespace (i.e., **\[^ \f\n\r\t\v\]**).

For example:


```python
text = "This project has increased our revenues by more than 70% in FY 2019."

# returns all single digit matches
x1 = re.findall(r'[0-9]', text)

# returns all non-word characters, also excludes # spaces , periods , and commas
x2 = re.findall(r'[^a-zA-Z \.,]', text)

# returns all two-digit numbers followed by "%" 
x3 = re.findall(r'\d\d%', text)

print(x1)
print(x2)
print(x3)
```

### 2.3 Anchors and boundaries in Regex
In addition to matching word and non-word characters in text, Regex can match specific positions in text. This becomes very useful when we want to match single words or word phrases in text, identify sentences and further classify them, etc. In textual analysis tasks, we commonly use these Regex anchors and boundaries:

- **^** matches the beginning of a string or line (when it is not inside \[ \]);
- **\\$** matches the end of a string or line;
- **\A** matches the beginning of a string;
- **\Z** matches the end of a string;
- **\b** matches a word boundary and allows “whole word only” searches in the form of '**\bword\b**';
- **\B** matches anything but a word boundary.

For example:

- Regex **r"^inf"** will match ‘inf’ in “information retrieval,” but not in “retrieval of information”;

- Regex **r"\bhigh\b"** will match ‘high’ in “high income,” but not in “higher income”;

- Regex **r"\bhigh\B"** will match ‘high’ in “higher income,” but not in “high income”.

### 2.4 Quantifiers in Regex
Quantifiers allow to specify whether a Regex element can be matched zero, one, or many times. Quantifiers are always placed after Regex elements. To process text documents, we commonly use the following quantifiers:

- **+** matches an item one or more times;
- ***** matches an item zero or more times;
- **{n}** matches an item exactly n times;
- **{k,n}** matches an item at least k times and at most n times; • ? matches an item zero or one time.

For example:

- Regex **r"^\w+\b"** will match ‘high’ in “high income” and ‘low’ in “low income”;

- Regex **r"\b19\d{2}\b"** will match any integer number between 1900 and 1999;

- Regex **r"\b\d{2,3}\b"** will match all two- and three-digit numbers in text.

### 2.5 Groups in Regex
Elements of Regex can be grouped together by enclosing them into parentheses, ( ). By default, groups are also captured in addition to the whole regular expression. That is, a regex **Match** object will store the textual value of the complete match as well as textual values of patterns specified in groups. To turn off group capturing, we need to specify ?: after the left parenthesis, i.e., (?: ). Groups are useful for recording specific values in the match and not the whole match. In other words, groups can be thought of as regex sub-patterns. For example:

- Regex **r"Total Assets = (\\\\$\[\d,\\.\]+)\b"** will match the text “Total Assets = ”, followed by a group capturing the dollar sign \\$, one or more numbers \d, allowing for commas , and periods \., and a word boundary \b. Applying this regex pattern to the string “Total Assets = \\$10,000,000” will result in two matches: 

    - Full match: ‘Total Assets = \\$10,000,000’
    
    - Group match : ‘\\$10,000,000’

- Regex **r"Email: (\[\w\\.-\]+@\[\w\\.-\]+.edu)"** will match the text “Email: ”, followed by a group capturing either an alphanumeric, ‘.’ , or ‘-’ character \[\w\.-\] (matched one or many times as in- dicated by ‘+’), followed by the at symbol @, followed again by alphanumeric, ‘.’ , or ‘-’ characters (matched one or many times), and ending with ‘.edu’. Applying this regex to string “Email: abc@ABC.edu” will result in two matches: 
    
    - Full match: ‘Email: abc@ABC.edu’

    - Group match : ‘abc@ABC.edu’
    
It is possible to specify alternative patterns in Regex using the “or” operator, denoted by |. For example, regex **'Form (10-K|10-Q)'** will match both ‘Form 10-K’ and ‘Form 10-Q’ in text.

Finally, it is possible to reuse previous group matches in the same regex. This is called backreferencing. To reference the text matched by the nth group, we use \n notation in a regex expression. For instance, regex **r"\b(\w+)\s\1\b"** would capture repeated words in text (e.g., “we we”, “in in”, “above above”, etc.); element \b(\w+)\s captures a word followed by space \s. The pattern \1 followed by the boundary \b captures the result of the first (and only) group, making sure that the second match is not a prefix or beginning of a longer word.


```python
string1="Email:sbb151@psu.edu Email: sam.bonsall@gmail.com"

m=re.findall(r"Email: ?([\w\.-]+@[\w\.-]+\.(?:edu|com|net|gov|org))",string1)

print(m)

```

### 2.6 Lookahead and lookbehind in Regex
It is possible to check whether a regex item is followed by a certain pattern without including that pattern in the resulting match. *Positive lookahead*, denoted by **(?=pattern)**, checks whether a regex item is followed by a given pattern. *Negative lookahead*, denoted by **(?!pattern)**, checks whether a regex item is not followed by a given pattern.


*Lookbehind* checks whether a regex item is preceded (or not) by a certain pattern without including that pattern in the output match. Positive lookbehind, denoted by **(?<=pattern)**, checks whether a regex item is preceded by a given pattern. Negative lookbehind, denoted by **(?<!pattern)**, checks whether a regex item is not preceded by a given pattern.

For example:

- Regex **r"filename(?=\.txt)"** matches ‘filename’ (not filename.txt) in “filename.txt,” but not in “filename.csv”

- Regex **r"filename(?!\.txt)"** matches ‘filename’ (not filename.csv) in “filename.csv,” but not in “filename.txt”

- Regex **r"(?<=year\s)\d{4}"** matches ‘2020’ (not year 2020) in “year 2020,” but not in “series 2020”

- Regex **r"(?<!year\s)\d{4}"** matches ‘2020’ (not series 2020) in “series 2020,” but not in “year 2020”

### 2.7 Examples of Regex for different textual analysis tasks
Last week we learned how to import the EDGAR index for Q4 of 2019. Let's use that file to practice some tasks with Regex.

#### Finding all filings of a certain form type


```python
import re

## Read in the index file and print out the first 25 lines

with open('company20194.idx', 'r') as edgar:
    doc=edgar.readlines()
    
for (c, line) in enumerate(doc,1):
    if c<=25:
        print(f"Line {c}:\n{line}")
```


```python
## Let's first find the number of Form 10-K filings

count=0
for (c,line) in enumerate(doc,1):
    filing10k=re.search(r'\s+(10-K)\s+',line)
    if filing10k:
        print(f"Line {c} contains Form {filing10k.group(1)}")
        count+=1
print(f"There were {count} Form 10-K filings in Q4 2019.")
```


```python
## What if we want to capture the amended 10-K filings as well?
## How would we modify our code?

count=0
for (c,line) in enumerate(doc,1):
    filing10k=re.search(r'\s+(10-K(/A)?)\s+',line)
    if filing10k:
        print(f"Line {c} contains Form {filing10k.group(1)}")
        count+=1
print(f"There were {count} Form 10-K or 10-K/A filings in Q4 2019.")
```


```python
## What if we want to find all of the filings submitted by Apple during the quarter?

## We need a regex that checks the company name, which is the first item in the row.

count=0
for (c,line) in enumerate(doc,1):
    filing10k=re.search(r'^(Apple Inc.*?)\s+(\S+)\s+',line,re.I)
    if filing10k:
        print(f"Line {c}: Company - {filing10k.group(1)}, Form - {filing10k.group(2)}")
        count+=1
print(f"There were {count} filings by Apple in Q4 2019.")
```

#### Export EDGAR index into a CSV file
It might be useful to tranfser the contents of the EDGAR index file into a CSV/Excel file so that we can click through to the underlying filings for further review. To do so, we need to devise a Regex to capture each element of the index: registrant name, form, Central Index Key (CIK), filing date, and URL to the filing. Let's give it a try:


```python
for (c,line) in enumerate(doc,1):
    ## The previous step skips the first 10 rows
    if c<11 or c>50:
        continue
        
    ## Capture the registrant name
    print("Registrant:",re.search(r'^(.+?)\s{2,}',line).group(1))
    
    ## Capture the form type
    print("Form Type:",re.search(r'^(.+?)\s{2,}(.+?)\s{2,}',line).group(2))
    
    ## Capture the CIK
    print("CIK:",re.search(r'^(.+?)\s{2,}(.+?)\s{2,}(\d+)',line).group(3))
    
    ## Capture the filing date
    print("Filing Date:",re.search(r'^(.+?)\s{2,}(.+?)\s{2,}(\d+)\s+(\d{4}-\d{2}-\d{2})',line).group(4))

    ## Capture the partial URL
    print("File URL:",re.search(r'^(.+?)\s{2,}(.+?)\s{2,}(\d+)\s+(\d{4}-\d{2}-\d{2})\s+(\S+)',line).group(5))


    
```


```python
## Export to CSV

## We will use the built-in CSV module
import csv

## Build list with CSV headers
uploads=[('company_name','form_type','cik','filing_date','url')]

## Loop through the index file and append elements to the list 'uploads'
for (c,line) in enumerate(doc,1):
    if c<11:
        continue
    data=re.search(r'^(.+?)\s{2,}(.+?)\s{2,}(\d+)\s+(\d{4}-\d{2}-\d{2})\s+(\S+)',line)
    uploads.append((data.group(1),data.group(2),data.group(3),data.group(4),'https://www.sec.gov/Archives/'+data.group(5)))
    
## Write out to CSV file
with open('cleaned_index.csv', 'w', newline='') as out:
    writer=csv.writer(out)
    writer.writerows(uploads)
```

#### Extracting some information from a text file
I included Apple's most recent quarterly earnings press release in the the files. Let's try to do a few simple tasks with Regex: count dollar figures, count percentage terms, and extract officer quotations.


```python
## Read in the press release
with open('apple_ea.txt', 'r') as pr:
    prtext=pr.read()
    
print(prtext)

## Extract dollar figures and print the number found
dollars=re.findall(r'\$[\d,\.]+\s(?:thousand|million|billion)',prtext,re.I)
print(f"\n\nFound {len(dollars)} dollar figures:")
for x in dollars:
    print(x)
    
## Extract percentage terms and print the number found
percent=re.findall(r'[\d,\.]+(?: percent|%)',prtext,re.I)
print(f"\n\nFound {len(percent)} percentage figures:")
for x in percent:
    print(x)
    
## Extract quotations and print the number found
quotes=re.findall(r'".+?"',prtext,re.I)
print(f"\n\nFound {len(quotes)} quotations:")
for x in quotes:
    print(x)
```


```python

```
