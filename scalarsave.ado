/* 
 Author: 		Danny Onorato 
 Description: 	Program to save scalar values to a .csv that can then be loaded into LaTeX to
				populate numbers in a document.
*/				

program define scalarsave
	version 16.1
	* syntax using/, scalar(real, update fmt(fmt)) id(string) [replace]
	syntax using/, scalar(string) id(string) [replace delim(string)]
	
	* Deal with delimiter 
	if "`delim'" == "" {
		loc delim ,
	}
	
	* Check using file is valid 
	loc ext = substr("`using'", -3, 3)
	if ~inlist("`ext'", "txt", "csv") {
		noi di as error "Extension must be one of: .txt, .csv"
		exit 99
	}
	
	if "`delim'" != "," & "`ext'" == "csv" {
		noi di as error "You specified the file extension as {bf:.csv} but delimiter is not set to {bf:,}"
		exit 99
	}
	
	* Parse the scalar sub-options
	_parse_scalar_opt `scalar'
	
	* Update the program locals from the parsing
	loc scalar `s(scalar)'
	loc update `s(update)'
	loc fmt `s(fmt)'
	
	* Check format if specified
	 if "`fmt'" != "" {
		 cap confirm numeric format `fmt'
		 if _rc {
				noi di as error "Bad format passed to {bf: scalar(, fmt)}."
				exit 99
		 }
		 
		 * Can't do commas or the latex won't work 
		 * XX - add option to put delimiter, only add this check for comma as delimiter
		 noi di "delim: `delim'"
		 if substr("`fmt'", -1, 1) == "c" & "`delim'" == "," {
		 	noi di as error "Can't format with commas, LaTeX won't parse .csv correctly."
			exit 99
		 }
		 
		 loc scalar : di `fmt' `scalar' // format here if checks pass
	 }
	
	* Can only specify one of update or replace 
	if "`update'" == "update" & "`replace'" == "replace" {
		noi di as error "Can only specify one of update and replace."
		exit 99
	}

	* If you do not specify replace, check that the file exists
	if "`replace'" != "" {
		capture confirm file "`using'"
		if _rc {
			noi di as error "You specified {bf:replace} but the file does not exist."
			exit 99
		}
	}

	* If you specify update, update the scalar and exit the program
	if "`update'" == "update" {
		qui _update_scalar, scalar(`scalar') id("`id'") file("`using'")
		exit
	}
	
	* If not updating or replacing and the file exists, check the id doesn't already exist otherwise it will add a duplicate row
	if "`replace'" == "" & "`update'" == "" {
		capture confirm file "`using'" // only need to check if the file already exists
		if _rc == 0 {
			qui {
				preserve 
					import delimited using "`using'", varnames(nonames) clear
					
					gen match = regexm(v1, "`id'")
					qui su match 
					if `r(max)' == 1 {
						noi di as error "This id already exists in the using file and you did not specify {bf:update}."
						frames change default
						exit 99
					}
				restore
			}
		}
	}
	
	* Replace or Append?
	if ("`replace'"=="replace") local overwrite replace
	else local overwrite append

	* Open file
	tempname file
	file open `file' using `using', write text `overwrite'
	
	* Write CSV line
	file write `file' "`id'`delim'`scalar'" _n
	
	* Close file
	file close `file'

end

* Parse scalar sub-options and return them to main program
program _parse_scalar_opt, sclass 
	syntax anything(name=scalar) [, update fmt(string)]
	
	* Check that scalar is real
	 cap confirm number `scalar'
	 if _rc {
	 	noi di as error "Scalar must be real."
		exit 99
	 }
	 
	sreturn local update "`update'"
	sreturn local scalar = `scalar' // used to format here, maybe move back in future
	sreturn local fmt "`fmt'"
end

* Read in the CSV and update a scalar
program _update_scalar
	syntax, scalar(real) id(string) file(string)
	
	preserve 
		import delimited using "`file'", varnames(nonames) clear
		
		* Check that id exists 
		gen match = v1 == "`id'"
		qui su match 
		if `r(max)' != 1 {
			noi di as error "You specified {bf:update} in {bf:scalar} but no scalar with the specified {bf:id} exists."
			exit 99
		}
		
		replace v2 = `scalar' if v1 == "`id'"
		
		drop match 
		export delimited using "`file'", replace novarnames datafmt
	restore 
end

