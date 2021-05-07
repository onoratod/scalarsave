# scalarsave
 `scalarsave` is a Stata ado file for saving numeric scalar values to delimited files. This program was created to be used with LaTeX to programmatically add numbers to research papers. A lot of times economists will include numbers in the body of their research paper. As the research evolves, these numbers change and need to be updated. It can be cumbersome and lead to errors if you need to go through and edit the paper every time a number changes. This ado is meant to help address this problem by allowing you to create a delimited file with all the numbers in your paper (with associated ids) that will be programmatically insterted into your paper with LaTeX. This way when a number changes, it will be automatically updated in your paper (more details [below](#using-with-latex)). 
 
 Example usage: 

```Stata
scalarsave using "example.csv", scalar(100) id("Example scalar")
```

For more info try `help scalarsave` in Stata. 
 
 ## Installation 
 To add this ado program to your list of Stata ados you need to move it somewhere in your adopath. To view your adopaths, type `adopath` in the Stata command line. You should get something like this:
 
 ```Stata
 . adopath
  [1]  (BASE)      "C:\Program Files\Stata16\ado\base/"
  [2]  (SITE)      "C:\Program Files\Stata16\ado\site/"
  [3]              "."
  [4]  (PERSONAL)  "C:\Users\username\ado\personal/"
  [5]  (PLUS)      "C:\Users\username\ado\plus/"
  [6]  (OLDPLACE)  "c:\ado/"

 ```
 
 Move the `scalarsave.ado` and `scalarsave.sthlp` to any of these filepaths and then you can call `scalarsave` from Stata. 

## Using with LaTeX

Using `scalarsave` with the `datatools` and `filecontents` LaTeX packages can allow you to programmatically insert numbers into your academic papers. Once you create a delimited text file or csv with the numbers for your paper you can load it into LaTeX using these packages and refer to the numbers using their ids. For a full working example with Stata and LaTeX code see `latex_example`. 

Suppose you had your scalar file `scalars.csv` with the following information and you want these numbers to be in your paper.

```
observations, 100
mean_income, 2000
```

you would write something like (see example code for more details)

```There are \var{observations} observations in my data and the mean income is \var{mean_income} dollars. ```

in LaTeX and when you compile your .tex file you would see

```Ther are 100 observations in my data and the mean income is 2000 dollars.```

and when `scalars.csv` is updated by your code and you recompile your .tex file these numbers will update to reflect the changes. The exact integration is provided in the files in `latex_example`.

## Testing

Tests for the ado can be found in the `tests` folder. If you make any changes be sure to add tests to `test.do` and run the file to make sure it works as expected. 
