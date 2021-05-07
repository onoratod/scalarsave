*** Make sure Stata reads in scalarsave 

* Load some data 
sysuse auto, clear

* Save the number of observations, NOTE: you need to update this filepath
count 
scalarsave using "${github}/scalarsave/latex_example/scalars.csv", scalar(`r(N)') id(n_observations)

* Save the average price. 
su price
scalarsave using "${github}/scalarsave/latex_example/scalars.csv", scalar(`r(mean)', fmt("%3.2f")) id(average_price)
