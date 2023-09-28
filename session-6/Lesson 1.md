# Python basics

## 1. Indentation


```python
div_yield_firm1 = 0.06 
div_yield_firm2 = 0.04

if div_yield_firm1 > 0.05:
    print('Invest in firm 1.')
else:
    if div_yield_firm2 > 0.05:
        print('Invest in firm 2.')
    else:
        print('Do not invest at this time.')
```

    Invest in firm 1.


## 2. Comments


```python
# Some sample code

x=3
```

## 3. Variables


```python
# Declaration
z=14

# Integers
k=-7352
print(k)

# Floating point numbers
myFloat1=-5.7
myFloat2=5.0
myFloat3=5.

print(myFloat3)
print(type(myFloat2))

# Strings
myString1 = 'The CEO said, "Earnings growth will exceed 5% next quarter."'
print(myString1)

myString2 = "Harley's ticker symbol is HOG."
print(myString2)
```

    -7352
    5.0
    <class 'float'>
    The CEO said, "Earnings growth will exceed 5% next quarter."
    Harley's ticker symbol is HOG.


When Python sees a single quote, it looks for the next single quote. Everything in between the two single quotes is treated as a string. The same rule applies for double quotes.

It is possible to include a single quote inside a single-quoted string, or to include a double quote inside a double-quoted string. To do so, prefix the quote inside the string with a backslash character (\\). When Python sees a backslash character, it treats the next character as a literal, meaning it does not assign a special meaning to it. Here are some examples:


```python
myString = 'Harley\'s ticker symbol is HOG.' 
print(myString)

myString = "The CEO said, \"Earnings growth will exceed 5% next quarter.\""
print(myString)
```

    Harley's ticker symbol is HOG.
    The CEO said, "Earnings growth will exceed 5% next quarter."


### 3.1 Booleans
A Boolean (bool) can only assume the values True or False. Boolean values are extremely important because they are used in every condi- tional expression in Python. All if statements and while loops use Boolean values. For example, consider the following code.


```python
x=0

if (x>3):
    print('Something')
else:
    print('Something else')
```

    Something else


When this code is executed, Python checks whether x is greater than 3. If it is, then the value True is substituted for (x > 3). If x is less than or equal to 3, then the value False is substituted for (x > 3). In other words, Python converts the expression (x > 3) into a Boolean value and uses that to execute the code. In sum, every condition given to an if or to a while is reduced and converted into a Boolean.

### 3.2 Checking the Type of a Variable, Value, or Expression
Use the built-in function type() to check the type of a variable, value, or expression. For example:


```python
type(7)
type(4.3)
type('Hello')
type(False)
```




    bool



The type() function can also be used to check the type of data stored in a variable. For example:


```python
y = 'Hello there.' 
type(y)
```




    str



### 3.3 Converting Between Types
Some conversions will fail. For example, if you attempt to convert a string to an int or to a float, Python will throw an error. For example:


```python
#int('EBITDA is 1.03 million.')
type(str(7))
```




    str



## 4. Operators
Operators are symbols that act on values. Python provides the following types of operators. Knowledge of these operators will be helpful when performing text analysis:
- Arithmetic operators
- Comparison operators
- Logical operators (for working with Boolean values)
- Membership operators (for checking whether something is part of a collection)

### 4.1 Arithmetic Operators


```python
# Addition

print(5+3)

# Subtraction

print(4.0-19.3)

# Multiplication

print(2*3)

# Division

print(3.1514/2)

# Floor division

print(7//2)

# Mod (remainder)

print(14%3)

# Exponentiation

print(3.0**4)
```

    8
    -15.3
    6
    1.5757
    3
    2
    81.0


### 4.2 Comparison Operators


```python
x=6 #Set the value of x to 5.

if x>5:
    print('x greater than 5.')
```

    x greater than 5.


### 4.3 Logical Operators


```python
year=2009
revenue=1200

if (year>2010) or (revenue>1000):
    print('TRUE')
```

    TRUE


### 4.4 Membership Operators


```python
myList=[1,2,3] # List of integers 1, 2, and 3

if 5 in myList:
    print('5 is in the list.')
else:
    print('5 is not in the list.')
```

    5 is not in the list.


Another common use of membership operators is to iterate over a collection. For example:


```python
myList = [1,2,3]

for x in myList:
    print(x)
```

    1
    2
    3


## 5. The print function
Python has a built-in print function. When performing text analysis, it is useful to include the print function for testing and debugging. For example, as we write code, we may wish to print the value of a variable or expression.


```python
pi=3.14
print(pi)
```

    3.14



```python
print(5, -3, 'EDGAR')
```

    5 -3 EDGAR


A common scenario is to substitute the values of variables into a string and then print that string. For example, say we want to print a sentence that includes the name, fiscal year, and net income of a company, all of which are stored in variables. The simplest and most elegant way to perform this is through f-strings. Consider the following example:


```python
CompanyName = 'General Motors' 
FiscalYear = 2019
NetIncome = 6581000000

print(f'In FY{FiscalYear}, {CompanyName.upper()} had net income of {NetIncome / 1e9} billion.')
```

    In FY2019, GENERAL MOTORS had net income of 6.581 billion.


When Python sees the letter f before a string, it treats the string differently. Inside the string, Python looks for expressions inside curly braces. It evaluates those expressions and replaces them with the string equivalents of their values. Notice that the expression {FiscalYear} was replaced with the value 2019, the value of the variable FiscalYear. Also notice that the expressions inside f-strings need not be variables; they can be any valid Python expression. Notice the second expression, {CompanyName.upper()}. The upper() method converts a string to all upper-case. Also notice that the third expression divides the variable NetIncome by one billion.
## 6. Control Flow
Control flow is the order in which statements are executed in a program. In this section, we will discuss basic control flow in Python, specifically branching (if statements) and loops (while and for).
### 6.1 if Statements
The syntax for the Python **if** statement is:
***
if condition_A:
    A statements
elif condition_B:
    B statements
elif condition_C:
    C statements
else:
    else_statements
***
An if statement begins with the keyword if. This keyword is followed by a condition, and then a colon (:). The condition must be an expression that evaluates to, or can be converted to, a Boolean value. Logical operators can be used to join multiple conditions and create complex logic. All statements to be executed if the condition is true must begin on the next line and must be indented. Thus, in the above example, if condition_A evaluates to True, all of the A statements will be executed. Note that the A statements can contain another if statement. This is called “nesting” and an example is shown below.


```python
x=5
y=4
if x>y:
    print(x)
    if y>3:
        print(y)
```

    5
    4


In this example, the value of the variable x is printed if x is greater than y. The nested if statement then checks whether y is greater than 3. If so, the value of y is printed. If x is less than or equal to y, nothing is printed and neither the condition, (y < 3), nor the print statement in the nested if is executed.

Python allows optional elif and else clauses. Any number of elif clauses is allowed, but only one else clause is allowed. These rules allow for arbitrarily complex logic. Also note that Python checks the clauses in order and stops execution after one clause evaluates to True. Consider the following example, which assumes that a variable age exists in the environment and contains a numeric value.


```python
age=25

if age<13:
    print('child')
elif age<20:
    print('teenager')
elif age<30:
    print('young adult')
else:
    print('old')
```

    young adult


If the variable age equals 25, Python will check the first condition (age < 13). This will evaluate to False. Python will then check the first elif, which contains the condition (age < 20). This will evaluate to False, so Python will check the second elif condition, (age < 30). This will evaluate to True, so Python will execute the corresponding statement and print 'young adult'. Python will then stop execution.
### 6.2 Loops
A loop executes an action while a condition is met, then terminates.
#### 6.2.1 while Loops
As its name suggests, a while loop executes while a condition is true. In Python, the while loop first checks whether its condition is true. If it is, the loop takes some actions and then rechecks the condition. If the condition is still true, the loop executes the actions again. This process repeats until the condition is false.

Below is an example of a while loop in action:


```python
counter=1
while counter<10:
    print(counter)
    counter+=1
```

    1
    2
    3
    4
    5
    6
    7
    8
    9


#### 6.2.2 for Loops
A for loop is very similar to a while loop. It will test a condition and execute the body of the loop if the condition is satisfied. The difference is that a for loop will iterate, or loop over, something automatically. In other words, a for loop is a while loop with some built-in conveniences.

A common scenario is to iterate over a collection of data, such as a list, and do something to every item in the collection. Consider the following example that prints every item in a list.


```python
for x in [1,2,3,7]:
    print(x)
```

    1
    2
    3
    7


The code above creates a list with the values, 1, 2, 3, and 7. The for loop iterates over the list. It does so by automatically creating a new variable that we named x. The loop sets x to the first item in the list, which in this case is 1. It then executes the body of the loop, which prints x. The loop then sets x to the next thing on the list, 2, and executes the body of the loop. This continues until the loop has iterated over every value in the list.

Another common scenario is to execute an action a given number of times. This is typically accomplished using the built-in range() function. In the example below, the range function returns the sequence 0, 1, 2, 3, 4, 5, 6. The for loop will iterate over this sequence and print every value in the sequence.


```python
startyear=1999
endyear=2008
for x in range(startyear,endyear+1):
    print(x)
```

    1999
    2000
    2001
    2002
    2003
    2004
    2005
    2006
    2007
    2008


Note that by default the range function starts at zero. Thus, range(7) returns a sequence of length 7 that begins at zero and ends at 6. This is common in many programming languages. To start the range function at an arbitrary integer k, instead of the default 0, use range(k, n). This will return the sequence k,k + 1,...,n − 1. Note that if k ≥ n, the range() function will return an empty sequence and the loop will not execute.
## 7. Functions
A function is a reusable block of code. In this section, we will first show how to create functions in Python. We will then show how to use functions written by others. Such functions are typically organized into modules; we will show how to reference functions stored in modules.
### 7.1 Writing Functions
Consider the following code. It defines a function, MyAverage, that computes the average of its two inputs.


```python
def MyAverage(x,y):
    return (x+y)/2
```

A function definition begins with the keyword def, which stands for define. Following the def keyword is a name for the function. Next is an argument list; this list must be enclosed in parentheses and separated by commas. Our MyAverage function takes two arguments, x and y. These arguments will create variables, but these variables will only “live” inside the function. The first line of the function definition must end with a colon. The next lines are the body of the function and they must be indented. Python uses the indentation to determine which statements constitute the “body” of the function. Python will execute the body of the function, line by line, until it reaches a return statement, or until it executes the last indented statement. A return statement, if provided,
“returns” a value to whatever line of code called the function.


```python
test_avg=MyAverage(4,5)
print(test_avg)
```

    4.5


It is possible to define a function with zero arguments. To do so, place open and close parentheses after the function name (e.g., def FunctionName():).

Functions need not return anything. If you do not wish to return anything from your function, you may omit the return statement or use a return statement with no return value.

#### Rules for Naming Functions
The rules for naming functions are the same as the rules for naming variables. Function names can contain upper- and lowercase letters, digits, and the underscore character. Function names cannot contain spaces and cannot begin with a digit.
#### Arguments are Local Variables
When a function is called, Python creates a new environment for that function. The new environment inherits everything from its calling environment. Any arguments to the function are created as variables in the function’s environment. Those variables, and the function’s environment, are deleted once the function returns a value or finishes execution.

Functions may reference variables in their calling environment. How- ever, if a function attempts to alter a variable in its calling environment, Python will create a new local variable with the same name. Any changes made to the local variable do not affect the calling environment. This subtlety is best illustrated with an example:


```python
def SampleFunction(): 
    x=0
    print(f'Inside SampleFunction , x is {x}')

x = 15
SampleFunction()
print(f'Outside SampleFunction , x is {x}')
```

    Inside SampleFunction , x is 0
    Outside SampleFunction , x is 15


In the above code, the variable x is created in some environment and set to 15. When SampleFunction() is called, it tries to assign the value 0 to x. When Python sees this, it creates a new local variable x and sets its value to 0. This new x will live only within the environment of SampleFunction. Additionally, the new symbol x masks the variable x in the top-level environment. Thus, when the function exits, the local x is destroyed and the top-level x is unmasked.

It is possible for functions to alter variables in calling environments, but we strongly discourage this practice. In good programming practice, functions act as “black boxes.” What happens inside the function should stay inside the function, and a function should not directly alter its calling environment.
#### Anonymous Functions / Lambda Expressions
Python allows programmers to create anonymous functions “on the fly.” A common use case occurs when performing an operation on each row of a dataset; sometimes, there is no available, preexisting function for the desired operation. A programmer could create the function with a def statement, but that would create unnecessary clutter. It is simpler and easier to use an anonymous function.

Use the lambda keyword to create an anonymous function. The following example demonstrates the creation and use of an anonymous function:


```python
# Create the list [0 ,1 ,...9]
L = list(range(10))

print(L)
# Extract all elements of L greater than 7

# Save to new list named filteredList 

filteredList = list(filter(lambda x: x > 7, L))

print(filteredList)
```

    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    [8, 9]


The above example creates a list L. The second line of code extracts all elements of L greater than 7 and saves them to a new list. We used a lambda expression to perform the filtering. The expression, lambda x: x > 7, begins with the lambda keyword and is followed by an argument x and a colon. The body of the function follows the colon. In this case, the function body is simply x > 7, which evaluates to a Boolean. The filter() function applies the anonymous function to every element of the list L and keeps list elements for which the anonymous function evaluates to True. Notice that the anonymous function is created inline, used once, and discarded.
### 7.2 Using Functions Written By Others
Researchers performing text analysis in Python will mostly work with functions written by others. In this section, we demonstrate how to work with such functions. We discuss how functions are organized into modules and show how to call a function from a module.

In programming, functions behave like “black boxes”; a function receives inputs (arguments) and emits an output (the return value). Python supports two types of arguments, positional arguments and keyword arguments. We will demonstrate how to use both types.
#### Modules and import Statements
Since Python is so popular, people have written thousands of Python functions that researchers can download and use in their own work. Without organizing those functions, many problems would result. For example, say we want to write a function to filter some data. A natural name for such a function is filter, but that function already exists in Python’s standard library. Additionally, many programmers find it useful to bundle a set of related functions. The solution to these problems is to package related functions into a module (sometimes called a package or a library). A module is simply a group of functions that reside in the same file.

When we open Python, it loads some built-in functions into the environment (see here). Python also provides a “standard library” that contains many modules with useful functions. If we want to use one of those modules, we have to tell Python by using an import statement. For example, to use the functions in Python’s math library, we would type:


```python
import math
```

That statement tells Python to load all of the functions from its math module into the environment. After we execute this import statement, we can use any of the functions in the module. For example, the following code computes the factorial of a number using a function from the math library.


```python
import math
print(math.factorial(5))
```

    120


Note that the name of the function is math.factorial, not factorial. Readers might wonder why Python requires them to prefix the function name with “math..” The reason is that, without such a prefix, an import statement might hide, or mask, other functions in the environment with the same name.

Readers who do not wish to type a prefix have two options. They can either import the function directly from a module into their environment, or define an alias for the module. Both options are commonly used by Python programmers.
##### Option 1: Import the functions directly
If we do not want to type math. before every function name, we can use something like the following. However, we discourage this practice as it clutters the environment with unneeded function names and increases the chance of a “name collision.”


```python
from math import factorial, log, sin
print(log(13))
```

    2.5649493574615367


This code imports specific functions from the math library. Additionally, such functions do not require the prefix “math..” If someone wishes to import all functions from a library, they can use something like the following:


```python
from math import *
```

##### Option 2: Define an alias for the module
Some libraries have long names, such as the statistics module. Typing statistics. before every function would be tedious. To prevent this, Python allows users to create an alias for a library name. For example:


```python
import statistics as st

mydata=[1,3,5,7,9]

my_median=st.median(mydata)

print(f'The median of my data is {my_median}.')
```

    The median of my data is 5.


The above code tells Python to use st as an alias for the statistics module. An alias can be any valid variable name.
### 7.3 Calling Functions
Consider the following code. It creates a variable, text, and then calls a function re.sub to substitute all occurrences of the string 'OI' with the more informative 'Operating Income'. Notice that we passed three arguments to re.sub. The first argument is the search text, the second argument is the replacement text, and the third argument is the text to search.


```python
import re
text = "OI for FY 2019 was 12.4 billion, up more than eight percent from OI in FY 2018."
pretty_text = re.sub("OI", "Operating Income", text) 
print(pretty_text)
```

    Operating Income for FY 2019 was 12.4 billion, up more than eight percent from Operating Income in FY 2018.


#### Positional Arguments
If we do not tell it otherwise, re.sub assumes that the first argument is the search text, the second argument is the replacement text, and the third argument is the text to search. Functions called in this manner rely on positional arguments: the position of the argument in the function call has meaning. When using positional arguments, we must read the function documentation to learn the correct order of the arguments. The argument order is specified in the function’s signature. For example, the documentation for re.sub provides this function’s signature:
***

re.sub(pattern, repl, string, count=0, flags=0)

***
The function signature specifies the arguments that a function accepts. If an argument is followed by an equals sign and a value, that argument is optional. If the argument is omitted, a default value (0 in this case) is used.

Many Python programmers use positional arguments when calling frequently-used functions that accept few arguments. However, many functions accept dozens of arguments, many of them optional, making it difficult to remember which argument is which. In this situation, we recommend the reader to consider keyword arguments, which we discuss next.
#### Keyword Arguments
Consider the call to re.sub in the previous example. An alternative method of calling this function is:
***

pretty_text = re.sub(pattern="OI", repl="Operating Income", string=text)

***
In the modified code, we explicitly told Python that the value of the pattern argument is "OI", the value of repl is "Operating Income", and the value of string is text. A function called this way relies on keyword arguments. Keyword arguments provide many advantages over positional arguments. Code readability is increased since the arguments are clearly specified. Additionally, arguments can be passed in any order. Thus, this function call would yield an identical result:
***

pretty_text = re.sub(string=text, repl="Operating Income", pattern="OI")

***
#### Mixing Positional and Keyword Arguments
Python allows function calls with positional and keyword arguments. The only stipulation is that once a keyword argument is used, all remaining arguments must be keyword arguments. Thus, the following is allowed:


```python
re.sub("OI", "Operating Income", string=text)
```




    'Operating Income for FY 2019 was 12.4 billion, up more than eight percent from Operating Income in FY 2018.'



However, the following would raise an error since a positional argument follows a keyword argument:


```python
re.sub(pattern="OI", "Operating Income", text)
```


      File "<ipython-input-173-1a96811d74d8>", line 1
        re.sub(pattern="OI", "Operating Income", text)
                            ^
    SyntaxError: positional argument follows keyword argument



## 8. Collections - Lists, Tuples, and Dictionaries
Python provides many ways of storing collections of data. In this section, we introduce three data structures for storing data collections: lists, tu- ples, and dictionaries. In the next chapter, we will introduce another data structure for storing collections of data, the Pandas DataFrame. Much of the syntax for lists and dictionaries applies to Pandas DataFrames.
### 8.1 Lists
A list is a mutable collection of objects. Python lists can contain data of different data types. List items can be added, modified, and deleted.
#### Creating a List
Create a list by enclosing data inside square brackets and separating each data item with a comma. Spaces between commas are optional. The following example creates a list and saves the list into a variable, L. The list contains three elements, a string, a float, and a list. Note that the type of the variable is list. Also note that it is possible to nest lists within lists.


```python
L = ['GM', -3.14, [1, 2, 3]]
type(L)
print(L)
```

    ['GM', -3.14, [1, 2, 3]]


#### Retrieving List Elements
In Python, each list element is assigned an index. List indexes begin at 0 and end at n − 1, where n is the number of elements in the list. Thus, in the previous example, the list element 'GM' has an index of 0, -3.14 has an index of 1, and \[1,2,3\] has an index of 2.

To access a single element of a list, type the name of the list and then enter the list index in square brackets. For example:


```python
L[1]
```




    -3.14



Python provides a shortcut to retrieve elements from the end of the list. The list index −1, refers to the last element of the list, −2 to the element that precedes the last, and so on. For example:


```python
print(L[-1])
```

    [1, 2, 3]


#### Slicing
Python makes it very easy to retrieve more than one element of a list. This process is called slicing. In our opinion, slicing is one of the most useful features of Python.

The syntax for slicing a list is:
***

list_name\[start:end:step\]

***
where start is the index of the first element we wish to retrieve (inclusive lower bound), end is one more than the index of the last element we wish to retrieve (exclusive upper bound), and step is the step size, or gap between indexes. Note that start, end, and step are optional. If omitted, Python assumes 0 for start, the list length for end, and 1 for step. Slicing is best illustrated with examples:


```python
L = ['a', 'b', 'c', 'd', 'e', 'f']

print(f'Example 1: {L[0:2]}') 
print(f'Example 2: {L[2:2]}') 
print(f'Example 3: {L[4:]}') 
print(f'Example 4: {L[:2]}') 
print(f'Example 5: {L[0:6:2]}') 
print(f'Example 6: {L[5:2:-1]}')
```

    Example 1: ['a', 'b']
    Example 2: []
    Example 3: ['e', 'f']
    Example 4: ['a', 'b']
    Example 5: ['a', 'c', 'e']
    Example 6: ['f', 'e', 'd']


Example 1 tells Python to retrieve all elements beginning with index 0 (the first element) and ending with one minus the end parameter of 2. This yields the first two elements of the list. Example 2 tells Python to start at index 2 and end at index 1. No list indices meet these criteria so the empty list is returned. Examples 3 and 4 illustrate the optional nature of the parameters; example 3 retrieves the list element with index 4 and all remaining list elements; example 4 retrieves all elements with indices less than 2. Example 5 retrieves elements with indices 0, 2, and 4; it begins with index 0 and increments the index in steps of 2. Finally, the last example demonstrates how to retrieve list elements in reverse order. It begins with index 5 and retrieves all elements with indexes strictly greater than 2 (recall that the end parameter is an exclusive bound).
#### Modifying List Elements
To modify a single element of a list, simply assign a value to that list element using the indexing method demonstrated above. Thus, to modify the element 'b' in the previous example:


```python
L[1]=6
print(L)
```

    ['a', 6, 'c', 'd', 'e', 'f']


To modify multiple elements simultaneously, simply assign to a list slice:


```python
L[4:6] = [-999, 0] 
print(L)
```

    ['a', 6, 'c', 'd', -999, 0]


#### Other List Operations
Python provides many useful functions for manipulating lists. In this section, we will demonstrate how to concatenate (join) lists, duplicate lists, copy lists, retrieve list length, and add and remove elements from lists.
##### Concatenating Lists
Use the + operator to concatenate, or join, lists.


```python
list1 = ['a', 'b', 'c'] 
list2 = [1, 2, 3]
list1 + list2
```




    ['a', 'b', 'c', 1, 2, 3]



##### Duplicating Lists
The * operator makes copies of a list and concatenates them into a new list.


```python
L = [1, 2, 3]
L*3
```




    [1, 2, 3, 1, 2, 3, 1, 2, 3]



###### Copying Lists
To demonstrate list copying, we must first introduce the concepts of shallow and deep copies. Say that a list is stored in the variable L. The statement L2 = L creates a shallow copy. It creates a new symbol in the environment, L2, but that symbol points to the same data as L. Thus, a change made to L2 will affect L. To see this, consider the following code:


```python
L=[1,2,3]

L2=L
L2[0]='text'

print(f'L = {L}')
print(f'L2 = {L2}')
```

    L = ['text', 2, 3]
    L2 = ['text', 2, 3]


To make a deep copy of a list, you must use a list’s copy method. This method duplicates the list in memory and prevents behavior like that shown in the previous example. The following code demonstrates the copy method of list.


```python
L = [1, 2, 3]
L2 = L.copy() 
L2[0] = 'text'

print(f'L = {L}')
print(f'L2 = {L2}')
```

    L = [1, 2, 3]
    L2 = ['text', 2, 3]


##### Getting the Length of a List
The len function retrieves the length of a list. Thus, len(\[1,2,3\]) returns 3.
##### Adding and Removing Elements from Lists
Use the append method of list to add a new element to the end of a list.


```python
L = [1, 2, 3] 
L.append('cat')
print(L)

print(len(L))
```

    [1, 2, 3, 'cat']
    4


Python also provides the insert and remove methods to insert and remove list elements. L.insert(i, x) inserts x at the index given by i. L.remove(x) removes the first item from L where L\[i\] is equal to x.
### 8.2 Tuples
A tuple is an immutable list - it cannot be changed after it is created. The syntax for tuples is nearly identical to that for lists. The main difference is that tuples use parentheses ( ) whereas lists use square brackets \[ \]. The process for retrieving an element from a tuple is identical to that for lists. We mention tuples because many Python functions either require tuples as arguments or return tuples. For example, the Pandas DataFrame, which we introduce in the next chapter, stores a table of data. Pandas provides a function that retrieves the dimensions of a DataFrame and this function returns a tuple containing the number of rows and columns.
### 8.3 Dictionaries
A dictionary is a list of key-value pairs. Dictionaries are very useful data structures since they allow users to assign data items (values) to keys of their choice. This makes it easier to store and retrieve data. For example, consider the following code that stores an income statement as a dictionary.


```python
income_stmt = {'Revenue': 100, 'COGS': 52,
'Gross margin': 48, 'SG&A': 40,
'Net Income': 8}
```

To create a dictionary, use curly braces { }. Within the curly braces, enter a key, followed by a colon, followed by the value. Separate each key-value pair with a comma. Note that Python permits newlines inside a dictionary to increase code readability. Keys can be numbers, strings, or tuples, and the keys must be unique (i.e., no repeated keys). The values can be any valid data type.

To retrieve a value from a dictionary, use the same syntax for lists. However, instead of using a numerical index, use a key.


```python
income_stmt['Revenue']
```




    100



To add a key-value pair to a dictionary, simply assign the value to a new key and Python will add the key-value pair to the dictionary. Thus,


```python
income_stmt['Fiscal Year'] = 2018
```

will create a new key 'Fiscal Year' in the dictionary income_stmt and assign it the value 2018.

To modify a value in the dictionary, simply set the new value using a key. Say, for example, we wish to change the fiscal year that we just added. We would type:


```python
income_stmt['Fiscal Year'] = 1998
income_stmt['Fiscal Year']
```




    1998



Python provides support for many other built-in dictionary opera- tions. You can get the length of the dictionary (number of key-value pairs), delete dictionary keys (and their values), clear all keys and values, copy the dictionary, retrieve only the keys, retrieve only the values, etc. We do not demonstrate those here.
## 9. Working with Strings
In many ways, Python strings behave like lists. Strings can be sliced, joined using the + operator, duplicated using the * operator, just like lists. That is why this section appears after the section on lists.
### 9.1 Strings as Lists of Characters
Conceptually, a string is just a list of characters. To see this, consider the following code and its output. The code uses Python’s built-in list function to split a string into a list of single-character strings. This illustrates how strings can be perceived as lists of characters.


```python
s = 'Hello world.' 
list(s)
```




    ['H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd', '.']



### 9.2 Extracting Pieces of Strings
To extract a substring, use list indexing or slicing notation.


```python
s = 'Hello world.' 
print(s[-1]) 
print(s[0:5])
```

    .
    Hello


### 9.3 String Operations
#### Joining Strings
Use the + operator to join (concatenate) two strings.


```python
s1 = 'Hello'
s2 = 'World'
s1 + ' ' + s2 + '.'
```




    'Hello World.'



#### Repeating Strings

Use the * operator to repeat a string.


```python
s1='Hello'
s1*3
```




    'HelloHelloHello'



#### Checking Whether a String Contains a Substring
Use the in operator to check whether a string contains a substring. The expression substr in s evaluates to True if substr appears anywhere in s, and False otherwise. In the following example, note that the second expression evaluates to False because Python strings are case-sensitive.


```python
s = 'Journal of Accounting Research' 
print('Accounting' in s)
print('AND' in s)
```

    True
    False


### 9.4 Useful String Functions and Methods
Following are some useful functions for working with strings. We only demonstrate a subset of the features of these functions. Many of these functions have optional arguments whose use we do not demonstrate. To learn more about these functions, see the official [documentation](https://docs.python.org/3/library/stdtypes.html#str) on Python’s built-in string methods.

We distinguish between functions and methods. A function is a reusable block of code. A method is a specific type of function. Python (and many other programming languages) support a construct known as objects and implement “object-oriented programming.” An object is a container for data and may contain its own functions. For example, lists and strings are implemented as objects in Python. Functions that belong to an object are called methods. Methods are called differently than ordinary functions. Recall the append method of the list object. We called it using a different syntax than we use for ordinary functions, e.g., L.append(x). Methods are called by typing an object’s name, followed by a dot (.), followed by the method name, then any arguments in parentheses.
#### Getting the Length of a String
Use the len function, e.g., len('abcd') returns 4.
#### lower and upper
lower and upper convert a string to all lower case or all upper case, respectively.


```python
s = 'Hello world.' 
print(s.upper()) 
print(s.lower())
```

    HELLO WORLD.
    hello world.


#### strip, lstrip, and rstrip
A common need when cleaning text data is to remove white space from strings. Python provides the strip method for this purpose. strip removes all white space characters from the beginning and end of a string. White space includes space, tab, and newline characters.


```python
s = ' Dirty string with unnecessary spaces at beginning and end. '
s.strip()
```




    'Dirty string with unnecessary spaces at beginning and end.'



Notice that strip removed the spaces from the beginning and the end of the string. If we wish to remove white space from only the beginning (end) of a string, use lstrip (rstrip).

By default, these methods remove white space, but we can pass an optional argument to tell these methods which characters to strip.


```python
s = 'Hello.' 
s.rstrip('.')
```




    'Hello'



#### startswith and endswith
Use the startswith and endswith to determine whether a string starts or ends with a given substring. These methods are similar to the in operator, but they only test the beginning or end of a string. These methods return True or False.


```python
s = '111 33' 
print(s.startswith('11')) 
print(s.endswith('x'))
```

    True
    False


#### find
find searches for a substring within a string. If the substring is found, find returns the index of the first occurrence. If the substring is not found, find returns -1.


```python
s = 'text analysis'
s.find('xt a')
```




    2



#### replace
Use replace to replace one substring with another. By default, it replaces all occurrences of a substring. An optional count argument allows to specify the number of replacements.


```python
s = 'text analysis' 
s.replace('text', 'TEXT')
```




    'TEXT analysis'



#### Count Occurrences of a Substring
The count method returns the number of times a substring occurs in a string.


```python
s = "At FedEx Ground, we have the market leading e-commerce portfolio. We continue to see strong demand across all customer segments with our new seven-day service. We will increase our speed advantage during the New Year. Our Sunday roll-out will speed up some lanes by one and two full transit days. This will increase our advantage significantly. And as you know, we are already faster by at least one day when compared to UPS's ground service in 25% of lanes. It is also really important to note our speed advantage and seven-day service is also very valuable for the premium B2B sectors , including healthcare and perishables shippers. Now, turning to Q2, I'm not pleased with our financial results."
s.count('we')
```




    2



#### split
The split method splits a string and returns a list of substrings. By default, it splits using spaces but we can tell Python which delimiter we wish to use.


```python
s = 'text analysis is fun.' 
x=s.split()
print(x)
type(x)
```

    ['text', 'analysis', 'is', 'fun.']





    list




```python
import wrds
```
