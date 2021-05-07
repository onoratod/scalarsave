* Unit test command function.
*	you give it a condition to check after you run a command 
*	i.e. unittest assert _rc == 0 : reg y x 
* 	will check there was no error return code when running `reg y x'
program define unittest
	_on_colon_parse `0'
	loc command `"`s(after)'"'
	loc pre `"`s(before)'"'
	
	*di `"`pre'"'
	*di `"`command'"'
	
	qui cap : `command'
	cap : `pre'
	
	if _rc {
		noi di as error "	...Test failed" _newline
	}
	else {
		noi di "	...Test passed" _newline
	}
end

*** Tests *** 

qui {
    
	*** Error Testing *** 
	
	* Invalid file specified 
	noi di "Bad file specified"
	noi unittest assert _rc == 99 : scalarsave using "${github}/scalarsave/testing/bad_file.xlsx", scalar(1) id("test") replace
	
	* Try csv with non-comma delimiter
	noi di "csv with no comma delimiter"
	noi unittest assert _rc == 99 : scalarsave using "${github}/scalarsave/testing/bad_csv.csv", scalar(1) id("test") delim(=)

	* Cannot specify both update and replace
	noi di "Cannot specify both replace and update"
	noi unittest assert _rc == 99 : scalarsave using "${github}/scalarsave/testing/scalars.txt", scalar(1, update) id("test") replace
	
	* Cannot append to non-existing file
	noi di "Cannot replace non-existent file"
	noi unittest assert _rc == 99 : scalarsave using "${github}/scalarsave/testing/noscalars.txt", scalar(1, update) id("test") replace
	
	* Try updating a scalar that doesn't exist
	noi di "Update scalar that doesn't exist"
	noi unittest assert _rc == 99 : scalarsave using "${github}/scalarsave/testing/scalars.txt", scalar(21, update) id("test")
	
	* Bad format
	noi di "Bad format"
	noi unittest assert _rc == 99 : scalarsave using "${github}/scalarsave/testing/scalars.txt", scalar(10.5, update fmt(3)) id("testing")
	
	* Bad format, commas
	noi di "Bad format, commas"
	noi unittest assert _rc == 99 : scalarsave using "${github}/scalarsave/testing/scalars.txt", scalar(10.5, update fmt(%3.2fc)) id("testing")
	
	
	*** Functionality Testing *** 
	
	copy "${github}/scalarsave/testing/scalars.txt" "${github}/scalarsave/testing/scalars_test.txt", public text replace
	
	* Add a number with formatting
	noi di "Add a number"
	noi unittest assert _rc == 0 : scalarsave using "${github}/scalarsave/testing/scalars_test.txt", scalar(10.5237899) id("new scalar")
	
	* Update a number in existing file
	noi di "Update scalar in existing file"
	noi unittest assert _rc == 0 : scalarsave using "${github}/scalarsave/testing/scalars_test.txt", scalar(21, update) id("testing")
	
	* Add a number with formatting
	noi di "Add a number with formatting"
	noi unittest assert _rc == 0 : scalarsave using "${github}/scalarsave/testing/scalars_test.txt", scalar(100.679, fmt("%5.1f")) id("new scalar 2")
	
	* Check file 
	noi di "Basic solution check"
	import delimited "${github}/scalarsave/testing/scalars_solution_1.txt", varnames(nonames) stringcols(_all) clear
	tempfile solution
	ren v2 v2_solution
	save `solution'
	import delimited "${github}/scalarsave/testing/scalars_test.txt", varnames(nonames) stringcols(_all) clear
	capture noisily : merge 1:1 v1 using `solution', assert(3) nogen
	noi unittest assert _rc == 0 : assert v2 == v2_solution 
	
	* Replace a file, use a different delimiter with commas
	noi di "Replace a file, use a different delimiter and format with commas"
	noi unittest assert _rc == 0 : scalarsave using "${github}/scalarsave/testing/scalars_test.txt", scalar(2000, fmt("%5.0fc")) delim(=) id("test replace") replace
 	
	* Check file 
	noi di "Replace solution check"
	import delimited "${github}/scalarsave/testing/scalars_solution_2.txt", varnames(nonames) stringcols(_all) clear
	tempfile solution
	ren v2 v2_solution
	save `solution'
	import delimited "${github}/scalarsave/testing/scalars_test.txt", varnames(nonames) stringcols(_all) clear
	capture noisily : merge 1:1 v1 using `solution', assert(3) nogen
	noi unittest assert _rc == 0 : assert v2 == v2_solution 
	
	* Delete the test file 
	erase "${github}/scalarsave/testing/scalars_test.txt"
	
	
}

