

****************************** UPDATE May 20th ****************

cd "TradeWeather"

set matsize 2000
set more off
use conflict_wto.dta,clear
global out "graph_folder_wto_gatt"
set more off
 
* prepare trade outome 
* wto for all conuntris for the last regressions 


* Could you run a set of regressions that only include WTO/GATT status interacted
* with rainfall, NINO3, etc? (i.e. drop the whole tax/subsidy stuff)
*- Also a set of regressions that include the lead of WTO/GATT status 
* (i.e. the value at t+1), to test the parallel trends assumption
*- Please add some rows to the table that clarify what fixed effects and other stuff you're controlling for. 
* I think it's always the same, but it's good to have a reminder in the table.



* add  the producers' prices regression 
* add , WTO, WTO*l.NONO3, WTO *l.temp, wto#l.rain, wto # weather



* WTO/GATT regress on country FE interacted with weather
* ( i.cowid # rainfall  and i.cowid # temp )

* Define the local macros to be used
 local weather lwtem lwpre L.lwtem L.lwpre
 local interaction wto_status gatt_status c.gatt_status#cL.nino3_late c.gatt_status#cL.lwtem c.gatt_status#cL.lwpre c.gatt_status#c.lwtem c.gatt_status#c.lwpre c.wto_status#cL.nino3_late c.wto_status#cL.lwtem c.wto_status#cL.lwpre c.wto_status#c.lwtem c.wto_status#c.lwpre
 local dummies i.year i.cow_id#c.year
local inter_dummy i.cow_id#cL.lwpre i.cow_id#cL.lwtem 


 	foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' `dummies' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }


 	foreach v in lmaize  lrice lwheat logcpipse {
      xtreg `v' `weather' `interaction' `dummies' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using wto_whole.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using wto_whole_price.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear


**** gatt/wto indicator instead ***


* Define the local macros to be used
 local interac_2 gatt_wto c.gatt_wto#cL.nino3_late c.gatt_wto#cL.lwtem c.gatt_wto#cL.lwpre c.gatt_wto#c.lwtem c.gatt_wto#c.lwpre  


 	foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interac_2' `dummies' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_gatt_wto_whole
 }


 	foreach v in lmaize  lrice lwheat logcpipse {
      xtreg `v' `weather' `interac_2' `dummies' `inter_dummy'  [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_gatt_wto_whole
 }    
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_gatt_wto_whole ltotal_gatt_wto_whole food_consu_gatt_wto_whole any_prio_gatt_wto_whole  using gatt_wto_whole.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interac_2'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


	esttab logcpipse_gatt_wto_whole lmaize_gatt_wto_whole lrice_gatt_wto_whole lwheat_gatt_wto_whole  using gatt_wto_whole_price.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interac_2') ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear




**************** add country specific weather dummy **********


 	foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' `dummies' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }


 	foreach v in lmaize  lrice lwheat logcpipse {
      xtreg `v' `weather' `interaction' `dummies' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using wto_whole_dummy.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using wto_whole_price_dummy.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.cow_id#c.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear

***** exclude country trend ***** 


local inter_dummy i.cow_id#cL.lwpre i.cow_id#cL.lwtem 


 	foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' i.year `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }


 	foreach v in lmaize  lrice lwheat logcpipse {
      xtreg `v' `weather' `interaction' i.year `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using wto_whole_dummy.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using wto_whole_price_dummy.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear





* try several leads when doing the analysis 

* Forward 

 	foreach v in lcalory ltotal food_consu  logcpipse any_prio {
      xtreg `v' lwtem lwpre L.lwtem L.lwpre F.gatt_wto gatt_wto Fc.gatt_wto#cL.nino3_late Fc.gatt_wto#cL.lwtem Fc.gatt_wto#cL.lwpre Fc.gatt_wto#c.lwtem Fc.gatt_wto#c.lwpre   c.gatt_wto#cL.nino3_late c.gatt_wto#cL.lwtem c.gatt_wto#cL.lwpre c.gatt_wto#c.lwtem c.gatt_wto#c.lwpre i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto
 }
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_wto ltotal_wto food_consu_wto logcpipse_wto any_prio_wto using new_reg_forward.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep(F.gatt_wto gatt_wto cF.gatt_wto#cL.nino3_late cF.gatt_wto#cL.lwtem cF.gatt_wto#cL.lwpre cF.gatt_wto#c.lwtem cF.gatt_wto#c.lwpre lwtem lwpre L.lwtem L.lwpre gatt_wto c.gatt_wto#cL.nino3_late c.gatt_wto#cL.lwtem c.gatt_wto#cL.lwpre c.gatt_wto#c.lwtem c.gatt_wto#c.lwpre ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear





 	foreach v in lcalory ltotal food_consu logcpipse any_prio {
      xtreg `v' lwtem lwpre L.lwtem L.lwpre F.gatt_wto gatt_wto i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto
 }
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_wto ltotal_wto food_consu_wto logcpipse_wto any_prio_wto using new_reg_exclude.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( lwtem lwpre L.lwtem L.lwpre F.gatt_wto gatt_wto ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(year effects = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear




**** gatt/wto indicator instead ***


* Define the local macros to be used
 local interac_2 gatt_wto c.gatt_wto#cL.nino3_late c.gatt_wto#cL.lwtem c.gatt_wto#cL.lwpre c.gatt_wto#c.lwtem c.gatt_wto#c.lwpre  


 	foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interac_2' i.year `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_gatt_wto_whole
 }


 	foreach v in lmaize  lrice lwheat logcpipse {
      xtreg `v' `weather' `interac_2' i.year `inter_dummy'  [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_gatt_wto_whole
 }    
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_gatt_wto_whole ltotal_gatt_wto_whole food_consu_gatt_wto_whole any_prio_gatt_wto_whole  using gatt_wto_whole.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interac_2'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


	esttab logcpipse_gatt_wto_whole lmaize_gatt_wto_whole lrice_gatt_wto_whole lwheat_gatt_wto_whole  using gatt_wto_whole_price.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interac_2') ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear



* geographic region # rain/temp 

local regiondummy i.region#cL.lwpre i.region#cL.lwtem


 	foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' i.year  `regiondummy' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }


 	foreach v in lmaize  lrice lwheat logcpipse {
      xtreg `v' `weather' `interaction' i.year `regiondummy' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
     
* eststo: xtreg lcalory dev_abs_nra_covt lwtem lwpre  L.lwtem L.lwpre gatt_wto gatt_wto#c.dev_abs_nra_covt  i.year i.cow_id#c.year [aweight = meanpop], fe i(cow_id) vce(cluster cow_id)
*estout 

 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using wto_whole_region.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction' *.region#cL.lwpre *.region#cL.lwtem ) ///
	drop（1.region#cL.lwtem ）
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using wto_whole_price_region.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' *.region#cL.lwpre *.region#cL.lwtem ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear


* Explaination for the lead effect: persistent drop in subsidy before join in WTO 

* understand the details of the distribution：

* like a tripple diff 


* regress food production/consumption on temperature bins 


* make notes of what tried , documents of interaction 

	* separate WTO/GATT indicators : all GATT member convert to WTO in 1994
	* exclude country specific time trends 


* Nicole: all countries , country data with food securiy



/*
1. Regression results are for all the countries in the data (113 countries)
2. Add in country FE interacted with weather variable reduces the noise in the weather variables. Higher temperature leads to lower production and less consumption. 
3. When add in regional weather variables (region # weather), rainfall variables make more sense for Africa (signs are correct except for conflict ).The other regions see relatively less effect of rainfall, and more are on temperature. South America is negatively affected by high temperature. 
4. After introducing the temperature bins,   the negative effect is largest in the lowest bin and smallest in the 
5. Removing the country specific lead to a flip of sings 
6. separate WTO/GATT indicators : all GATT member convert to WTO in 1994
7. Also a set of regressions that include the lead of WTO/GATT status (i.e. the value at t+1), to test the parallel trends assumption. * try several leads when doing the analysis 
*/


 

* Define the local macros to be used
 local weather lwtem lwpre L.lwtem L.lwpre
 local interaction wto_status gatt_status c.gatt_status#cL.nino3_late c.gatt_status#cL.lwtem c.gatt_status#cL.lwpre c.gatt_status#c.lwtem c.gatt_status#c.lwpre c.wto_status#cL.nino3_late c.wto_status#cL.lwtem c.wto_status#cL.lwpre c.wto_status#c.lwtem c.wto_status#c.lwpre
  local interac_2 gatt_wto c.gatt_wto#cL.nino3_late c.gatt_wto#cL.lwtem c.gatt_wto#cL.lwpre c.gatt_wto#c.lwtem c.gatt_wto#c.lwpre  
 local dummies i.year i.cow_id#c.year
  local dummies2 i.year 

local inter_dummy i.cow_id#cL.lwpre i.cow_id#cL.lwtem 
local regiondummy i.region#cL.lwpre i.region#cL.lwtem

**********************************************************************
*   1. GATT or WTO  (together)
**********************************************************************
*i.country # weather without country specific time trend 

foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interac_2' `dummies2' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interac_2' `dummies2' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using table1.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interac_2'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using table2.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interac_2' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear

*i.region # weather without country specific time trend


foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interac_2' `dummies2' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interac_2' `dummies2' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using table3.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interac_2' *.region#cL.lwpre *.region#cL.lwtem   ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using table4.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interac_2' *.region#cL.lwpre *.region#cL.lwtem ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear

*i.country # weather  + country specific time trend 


foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interac_2' `dummies' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interac_2' `dummies' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using table5.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interac_2'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using table6.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interac_2' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear
* i.country # weather  + country specific time trend 

foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interac_2' `dummies' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interac_2' `dummies' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using table7.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interac_2' *.region#cL.lwpre *.region#cL.lwtem   ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using table8.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interac_2' *.region#cL.lwpre *.region#cL.lwtem ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear

 	
***********************************************************************
*   2. GATT or WTO  (separate)
**********************************************************************
*i.country # weather without country specific time trend 

foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' `dummies2' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interaction' `dummies2' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using biao1.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using biao2.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear

*i.region # weather without country specific time trend


foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' `dummies2' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interaction' `dummies2' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using biao3.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction' *.region#cL.lwpre *.region#cL.lwtem   ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using biao4.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' *.region#cL.lwpre *.region#cL.lwtem ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear

*i.country # weather  + country specific time trend 


foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' `dummies' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interaction' `dummies' `inter_dummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using biao5.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction'  ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using biao6.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear
* i.country # weather  + country specific time trend 

foreach v in lcalory ltotal food_consu any_prio {
      xtreg `v' `weather' `interaction' `dummies' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole 
 }


 	foreach v in lmaize  lrice lwheat logcpipse logcpifood{
      xtreg `v' `weather' `interaction' `dummies' `regiondummy' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_whole
 }    
    
 	 
	esttab lcalory_wto_whole ltotal_wto_whole food_consu_wto_whole any_prio_wto_whole  using biao7.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `weather' `interaction' *.region#cL.lwpre *.region#cL.lwtem   ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))



	esttab logcpipse_wto_whole logcpifood_wto_whole lmaize_wto_whole lrice_wto_whole lwheat_wto_whole  using biao8.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	 scalars("year")///
	keep( `weather' `interaction' *.region#cL.lwpre *.region#cL.lwtem ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate(  Country specific trend = *.year ) ///
	stats(N N_clust r2, fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))


est clear

 	




************************************************************
* Temperature bins
************************************************************

local temp_bins L.bin1 L.bin2 L.bin3 L.bin4 L.bin5
local wtoweather  1.wto_status#cL.lwpre 1.wto_status#c.lwpre 1.gatt_status#cL.lwpre 1.gatt_status#c.lwpre lwpre L.lwpre
local gattwtoweather gatt_wto 1.gatt_wto#cL.lwpre 1.gatt_wto#c.lwpre lwpre L.lwpre

local regiondummies2 i.region#cL.lwpre  

	foreach v in lcalory ltotal food_consu any_prio  {
      xtreg `v' `temp_bins' `wtoweather' 1.wto_status#cL.nino3_late 1.gatt_status#cL.nino3_late `dummies' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_bins
 }

 esttab lcalory_wto_bins ltotal_wto_bins food_consu_wto_bins any_prio_wto_bins using wto_bins1.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `temp_bins' wto_status gatt_status lwpre L.lwpre 1.wto_status#cL.lwpre 1.wto_status#c.lwpre 1.wto_status#cL.nino3_late 1.gatt_status#cL.lwpre 1.gatt_status#c.lwpre 1.gatt_status#cL.nino3_late) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))

est clear


foreach v in lcalory ltotal food_consu any_prio  {
      xtreg `v' `temp_bins' `wtoweather' 1.wto_status#cL.nino3_late 1.gatt_status#cL.nino3_late `dummies' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_bins
 }

 esttab lcalory_wto_bins ltotal_wto_bins food_consu_wto_bins any_prio_wto_bins using wto_bins2.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `temp_bins' lwpre L.lwpre 1.wto_status#cL.lwpre 1.wto_status#c.lwpre 1.wto_status#cL.nino3_late 1.gatt_status#cL.lwpre 1.gatt_status#c.lwpre 1.gatt_status#cL.nino3_late) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))

est clear

	foreach v in lcalory ltotal food_consu any_prio  {
      xtreg `v' `temp_bins' `gattwtoweather' 1.gatt_wto#cL.nino3_late `dummies2' [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_bins
 }

 esttab lcalory_wto_bins ltotal_wto_bins food_consu_wto_bins any_prio_wto_bins using wto_bins2.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `temp_bins'  lwpre L.lwpre 1.gatt_wto#cL.lwpre 1.gatt_wto#c.lwpre 1.gatt_wto#cL.nino3_late) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))

est clear

foreach v in lcalory ltotal food_consu any_prio  {
      xtreg `v' `temp_bins' `wtoweather' 1.wto_status#cL.nino3_late 1.gatt_status#cL.nino3_late `dummies2' `regiondummies2'  [aweight = meanpop], fe i(cow_id) vce(cluster cow_id) 
    est store `v'_wto_bins
 }

 esttab lcalory_wto_bins ltotal_wto_bins food_consu_wto_bins any_prio_wto_bins using wto_bins3.tex, replace f  ///
	label booktabs b(3) se(3) eqlabels(none) alignment(C C)  ///
	keep( `temp_bins' wto_status gatt_status lwpre L.lwpre 1.wto_status#cL.lwpre 1.wto_status#c.lwpre 1.wto_status#cL.nino3_late 1.gatt_status#cL.lwpre 1.gatt_status#c.lwpre 1.gatt_status#cL.nino3_late) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	indicate( Year Effects and Country specific trend = *.year) ///
	stats(N N_clust r2 , fmt(0 0 3) layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Clusters"' `"R^2"'))

est clear



