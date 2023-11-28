## Textual Analysis using Dictionaries

One of the basic ways to capture the content of a document is to count the *relative frequency of particular words* in the document. For instance, to determine how optimistic/pessimistic a given text is, researchers often use dictionaries of *positive* and *negative* words. Similar techniques can be used to determine risk and uncertainty of disclosures, financial focus of disclosures, focus on corporate social responsibility, non-GAAP reporting, etc.

An alternative to a dictionary-based textual analysis would be to use a machine-learning algorithm which 'learns' text classifications from manually-coded pieces of text. However, since simple dictionary-based approaches often perform as well as more complex machine-learning algorithms ([Henry and Leone 2016](https://doi.org/10.2308/accr-51161)), we will focus our tutorial on how to use dictionaries to analyze texts.

There are many different dictionaries for content analysis. For example:
<br>
\- general and domain-specific dictionaries for tone/sentiment analysis
<br>
http://www.wjh.harvard.edu/~inquirer/homecat.htm
<br>
https://sraf.nd.edu/textual-analysis/resources/#LM%20Sentiment%20Word%20Lists
<br>
\- corporate social responsibility dictionary
<br>
https://www.springer.com/us/book/9783319105352
<br>
\- dictionary of accounting terms
<br>
http://www.oxfordreference.com/view/10.1093/acref/9780199563050.001.0001/acref-9780199563050

Depending on your research question, you can always construct your own dictionary (e.g., dictionary of specific accounting terms that identify non-GAAP reporting).

The following academic papers provide some examples of dictionary-based content analysis in accounting and finance:

\- tone/sentiment analysis using *binary* dictionaries of positive and negative words: [Henry 2008](https://doi.org/10.1177/0021943608319388); [Loughran and McDonald 2011](https://doi.org/10.1111/j.1540-6261.2010.01625.x); [Tetlock 2007](https://doi.org/10.1111/j.1540-6261.2007.01232.x);
<br>
\- tone/sentiment analysis using *extremity rankings* of positive and negative words: [Bochkay, Chava, and Hales 2018](http://dx.doi.org/10.2139/ssrn.2781784);
<br>
\- analysis of *topical content* of disclosures (e.g., product market, corporate strategy, corporate governance, marketing, etc.): [Hanley and Hoberg 2010](https://doi.org/10.1093/rfs/hhq024).

### Disclosure Tone
Assume we want to calculate *Tone* of a company's earnings conference call, i.e., to what extent the earnings call exhibits optimistic vs. pessimistic views. Before writing your code, you have to make several design choices:

**1\)** <font color='blue'>Select a dictionary for sentiment analysis and clearly understand how this dictionary was constructed.</font> Some dictionaries contain only root words (e.g., increase, decrease), whereas others contain both root words and their word families (e.g., increase, increasing, increased, increases, etc). Some dictionaries also contain phrases in addition to individual words.

If the selected dictionary contains only root words then you have to perform *stemming* of your documents.
<br>
*Stemming* is the process of reducing inflected (or sometimes derived) words to their word base or root. More information about stemming in Python can be found at: 
<br>
https://www.datacamp.com/community/tutorials/stemming-lemmatization-python. 

Also, you will have to understand the format in which words are recorded in the dictionary file - Is each word recorded in a separate line? Do you have any other information in the dictionary besides words? We strongly recommend you to work with files in .txt format, either tab delimited or comma separated.

**2\)** <font color='blue'>Determine if every word count will be equally-weighted or not.</font>
    <br>
    Equally-weighed *Tone* measure is calculated as follows:
  <font color='red'>
  <br>
    $$ Tone = \frac{Positive Word Count - Negative Word Count}{Total Word Count} $$ 
 <br>
    </font>
 A popular alternative to equal-weighting of all word counts is to weight each word count by its document frequency. 
 
Specifically, inverse document frequency of a word $i$, <font color='green'> $idf_i = log(\frac{\text{Number of Documents in the Sample}}{\text{Number of Documents Containing a word $i$}})$</font>, penalizes commonly-used words and assigns a higher weight to less common words.

With $idf$, *Tone* of a document is calculated as follows:
<br>
<font color='red'>
    $$ Tone = \frac{\sum_i PositiveWordCount_i \times idf_i - \sum_j NegativeWordCount_j \times idf_j}{Total Word Count} $$ 
 <br>
</font>

More information about word weightings can be found at:
<br>
https://nlp.stanford.edu/IR-book/html/htmledition/tf-idf-weighting-1.html

**3\)** <font color='blue'>Determine how you will be dealing with negators (e.g., not bad, not good, did not increase).</font> You have several options:
<br>
\- ignore that a positive/negative word can be negated. However, your reviewer will likely pick up on that;
<br>
\- create a Regex to check for the presence of negators in front of positive and negative words. 

If a negator is present, then you can simply reverse the sentiment of the word next to the negator. For example:
<br>
"our performance was not *bad*" -1 (original) $\rightarrow$ +1 (new), indicating that "not bad" has a positive sentiment.  
"our performance was not *good*" +1 (original) $\rightarrow$ -1 (new), indicating that "not good" has a negative sentiment. 

Alternatively, you can assign a new weight to a negated word in some *systematic* fashion. For example, you can assign 0.5 x original sentiment score to all negated words.

Here is a list of negators you might want to consider in your regex:
<br>
<font color='green'>
*not, never, no, none, nobody, nothing, don't, doesn't, won't, shan't, didn't, shouldn't, wouldn't, couldn't, can't, cannot, neither, nor*
    </font>



```python
import re
# Let us start with a simple tone analysis, where each word is equally-weighted and we do not account for negators
# First, we need to load our dictionary files
positive_words_dict = r"./dictionaries/LM_Positive.txt" # file path (location) to a text file with positive words
negative_words_dict = r"./dictionaries/LM_Negative.txt" # file path to a text file with negative words

# To be able to match all positive and negative words in dictionaries, we need to create a list of regular expressions corresponding to these words.
# So, we need to write a function that will read all dictionary terms line-by-line and convert them to a dictionary of Regexes

def create_dict_regex_list(dict_file:str):
    """Creates a list of regex expressions of dictionary terms.""" # function description (optional)
    with open(dict_file,"r") as file:  # opens the specified dict_file in "r" (read) mode 
        dict_terms = file.read().splitlines() # reads the content of the file line-by-line and creates a list of extracted content
    dict_terms_regex = [re.compile(r'\b' + term + r'\b', re.I) for term in dict_terms] 
    # re.compile(pattern) in Python compiles a regular expression pattern, which can be used for matching using its re.search, re.findall, etc.
    # by adding "\b" (i.e., boundary) on each side of the dictionary term in Regex, we specify an exact match of each dictionary term 
    return dict_terms_regex # specifies the output of the function - in our case, a list of Regex expressions

# Now we can apply our function to create Regex lists for positive and negative dictionary terms
positive_dict_regex = create_dict_regex_list(positive_words_dict)
negative_dict_regex = create_dict_regex_list(negative_words_dict)
print(positive_dict_regex[0:3])
print(negative_dict_regex[0:3])
```


```python
# Next step is to write a function that will count positive, negative and all words in a given text.
# Tone = (PositiveWordCount - NegativeWordCount)/TotalWordCount

def get_tone (input_text:str):
    """Counts All and Specific Words in Text""" # function description (optional)
    
    ### Positive Words ###
    
    positive_words_matches = [re.findall(regex, input_text) for regex in positive_dict_regex] 
    # output of this search will be of the following format: [['able'], [], ['accomplish','accomplish'], [], ... ]
    
    positive_words_counts = [len(match) for match in positive_words_matches]
    # output of this list transformation will be of the following format: [1, 0, 2, 0, ...]
    
    positive_words_sum = sum(positive_words_counts) # add all positive word counts
    
    ### Negative Words ###
    
    # now we can perform the same word counts for negative words
    negative_words_matches = [re.findall(regex, input_text) for regex in negative_dict_regex]
    negative_words_counts = [len(match) for match in negative_words_matches]
    negative_words_sum = sum(negative_words_counts) # add all negative word counts
    
    ### Total Words ###
    total_words = re.findall(r'\b[a-zA-Z\'\-]+\b', input_text) # searches for all words in text, allowing apostrophes and hyphens in words, e.g., company's, state-of-the-art
    total_words_count = len(total_words) # calculates the number of all words in a given text
    
    # Finally, we can calculate Tone (expressed in % terms):
    tone = 100 * (positive_words_sum - negative_words_sum)/total_words_count
    
    return (total_words_count, positive_words_sum, negative_words_sum, tone)
    
# Running our count_words function:
counts = get_tone("As our volumes and revenues demonstrate, FedEx is experiencing strong growth in the US, where the economy remains solid. However, our international business, especially in Europe, weakened significantly since we last talked with you during our earnings call in September. In addition, China's economy has weakened due in part to trade disputes.  While international revenue was still growing, it is not growing at the rate we expected because of the overall global economic uncertainty. As a result, we have lowered our fiscal 2019 earnings guidance and are accelerating actions to reduce costs given the uncertainty of global macroeconomic trends. We are highly confident that we will achieve the benefits expected with the acquisition of TNT Express, although we will not achieve our FedEx profit improvement goal in fiscal 2019. [...] Like the rapid changes we have experienced, I'm confident that we will see improved operating earnings, margins and cash flow in FY '20 versus FY '19.")
print(counts)
```


```python
# To account for negators we have to keep track of negated words. Therefore, we need to update our Regex expressions:

def create_dict_regex_list_with_negators(dict_file:str):
    """Creates a list of regex expressions of dictionary terms."""
    with open(dict_file,"r") as file: 
        dict_terms = file.read().splitlines() 
    dict_terms_regex =[re.compile(r'(not|never|no|none|nobody|nothing|don\'t|doesn\'t|won\'t|shan\'t|didn\'t|shouldn\'t|wouldn\'t|couldn\'t|can\'t|cannot|neither|nor)?\s(' + term + r')\b', re.I) for term in dict_terms] 
    return dict_terms_regex 

# Now we can apply our function to create Regex lists for positive and negative dictionary terms
positive_dict_regex = create_dict_regex_list_with_negators(positive_words_dict)
negative_dict_regex = create_dict_regex_list_with_negators(negative_words_dict)

print(positive_dict_regex[0])
print(negative_dict_regex[0])
```


```python
# count words version 2, accounting for negators
def get_tone2 (input_text:str):
    """Counts All and Specific Words in Text, accounting for negators""" # function description (optional)
    
    total_words = re.findall(r'\b[a-zA-Z\'\-]+\b', input_text) # find all words in text
    total_words_count = len(total_words) # calculate the number of total words
    
    # To account for negators, let's create two separate counts for positive and negated positive words
    
    positive_word_count = 0 # initial values
    negated_positive_word_count = 0 # initial values
    
    for regex in positive_dict_regex:
        matches = re.findall(regex, input_text) # searches for all occurences of Regex
        for match in matches:
            if len(match)>0: # if the match is not empty
                print(match) # just to check the match output
                
            if match[0] == '':
                positive_word_count += 1 
            else:
                negated_positive_word_count += 1
                
   # If we are just shifting the sentiment of negated positive words, then the final positive word count is just:
    positive_words_sum = positive_word_count # i.e., count without negators
    
### Repeat the same for negative words:
    negative_word_count = 0 # initial values
    negated_negative_word_count = 0 # initial values
    
    for regex in negative_dict_regex:
        matches = re.findall(regex, input_text) # search for all occurences of Regex
        for match in matches:
            if len(match)>0: # if the match is not empty
                print(match) # just to check the match output         
            if match[0] == '':
                negative_word_count += 1 
            else:
                negated_negative_word_count += 1
                
   # If we are just shifting the sentiment of negated negative words, then the final negative word count is just:
    negative_words_sum = negative_word_count # i.e., count without negators
    
    # Then, Tone is:
    tone = 100 * (positive_words_sum - negative_words_sum)/total_words_count
    
    return (total_words_count, positive_words_sum, negative_words_sum, tone)

# Running our count_words2 function:
counts = get_tone2("As our volumes and revenues demonstrate, FedEx is experiencing strong growth in the US, where the economy remains solid. However, our international business, especially in Europe, weakened significantly since we last talked with you during our earnings call in September. In addition, China's economy has weakened due in part to trade disputes.  While international revenue was still growing, it is not growing at the rate we expected because of the overall global economic uncertainty. As a result, we have lowered our fiscal 2019 earnings guidance and are accelerating actions to reduce costs given the uncertainty of global macroeconomic trends. We are highly confident that we will achieve the benefits expected with the acquisition of TNT Express, although we will not achieve our FedEx profit improvement goal in fiscal 2019. [...] Like the rapid changes we have experienced, I'm confident that we will see improved operating earnings, margins and cash flow in FY '20 versus FY '19.")

print(counts)
```
