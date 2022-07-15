*! version 1.0.0  29dec2016
// Makes a stacked correlation table for use with esttab

program makecorr
	version 12.1
	syntax varlist using/ [if] [in] [, coeflabel(passthru) b(integer 3) substitute(passthru) title(passthru) tex csv rtf float lyx case paren]
	
	
	qui {
		tempfile master
		save `master'
		
		local i=1
		foreach v of local varlist {
			local tlab: var label `v'
			if "`tex'"=="" & "`paren'"!="" label var `v' "(`i') `tlab'"
			else if "`tex'"!="" & "`paren'"!="" label var `v' "(`i')\ `tlab'"
			else if "`tex'"=="" & "`paren'"=="" label var `v' "`i'. `tlab'"
			else label var `v' "`i'.\ `tlab'"
			local ++i
		}
		
		if "`case'"!="" {
			foreach v of local varlist {
				drop if missing(`v')
			}
		}

	
		foreach v of local varlist {
			egen rank_`v'=rank(`v')
		}
		
		eststo clear
		local upper
		local lower `varlist'
		foreach v of local varlist {
		    estpost correlate `v' `lower'
		    foreach m in b rho p count {
		        matrix `m' = e(`m')
		    }
		
			foreach v2 of local varlist {
				ren `v2' raw_`v2'
				ren rank_`v2' `v2'
			}
		
		
		    if "`upper'"!="" {
		        estpost correlate `v' `upper'
		        foreach m in b rho p count {
		            matrix `m' = e(`m'), `m'
		        }
		    }
		    ereturn post b
		    foreach m in rho p count {
		        quietly estadd matrix `m' = `m'
		    }
		
			foreach v2 of local varlist {
				ren `v2' rank_`v2'
				ren raw_`v2' `v2'
			}
		
		    eststo `v'
		    local lower: list lower - v
		    local upper `upper' `v'
		}
		esttab `varlist' using `"`using'"',  `tex' `csv' `rtf' replace nomtitles noobs not label  b(`b') nonote `coeflabel' `float' `title'
		if "`lyx'"!="" tex2lyx "`using'"
		
		use `master', clear
	}


end
