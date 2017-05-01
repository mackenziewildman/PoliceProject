# Exploring connections between police violence and salaries

Police violence has jumped to the forefront of our country's challenges since the deaths of Eric Garner and Michael Brown made national news in 2014. In California, we pay our law enforcement officers the [highest salaries in the country on average](http://city-salaries.careertrends.com/stories/5583/worst-paying-cities-for-police#Intro). Is this investment well spent? By combining a data set on police killings from 2013-2017 with city-specific data on police salaries we can begin to explore the relationship between police violence and wages. To most accurately approach this question, I propose to take into account additional factors such as population, average income, crime rates, and number of officers by city. This project uniquely takes a granular approach by making observations at a city or county level.

## Data sources

* Police killings, <https://mappingpoliceviolence.org/>, documents 4,977 police killings in the United States since 2013. Size: 3.11MB

* 2015 police salaries by California city, [The Sacramento Bee](http://www.sacbee.com/site-services/databases/article2573210.html).

* Cost of living index in 2015 dollars by California city and by California county, [U.S. Census Bureau, 2015 American Community Survey 1-Year Estimates](https://factfinder.census.gov/), Table B19301.

* 2015 Population by California city, [U.S. Census Bureau, 2011-2015 American Community Survey 5-Year Estimates
](https://factfinder.census.gov/), Table DP05. Size: 1.99 MB

## Preliminary observations

First, the basic relationship between the number of police killings in a city between 2013 and 2017 and the 2015 average police officer salary in that city is observed. See [Plot 1](https://github.com/mackenziewildman/PoliceProject/blob/master/Plot1.png).

Next, additional insight is provided by incorporating the average per capita resident income of each city (or if not available, the corresponding county). [Plot 2](https://github.com/mackenziewildman/PoliceProject/blob/master/Plot2.png) shows the relationship between the number of police killings in a city and the percent difference of local average income that police officers are paid. Note that on average, police officers are paid well above the local average salary (up to almost 7 times the average local income). Benefits and overtime are included in the police officer salary data and further work must be done to address whether this inflates the police salaries against the average.

Finally, local population is incorporated to show the number of people killed by police per 100,000 residents in each city. See [Plot 3](https://github.com/mackenziewildman/PoliceProject/blob/master/Plot3.png). Outliers are removed from the plot in order to show a meaningful relationship between the remaining data points.

Within California, higher relative police officer salaries are not obviously associated with fewer instances of police-inflicted fatalities. I propose to further this analysis to understand whether increasing police officer salaries can lead to less police violence and what alternative approaches may be used.

## Next steps

* Include additional juristictions in analysis. Begin by comparing California data with a state with low police officer salaries, e.g. [Mississippi](https://www.bls.gov/oes/current/ms_counties.htm).

* Analyze [complaint data](https://codeforamerica.github.io/PoliceOpenDataCensus/datasets.html) of local law enforcement offices. How does the number of complaints filed in a city relate to the number of police killings and the officers' salaries?

* Include analysis of [local crime rates](http://www.city-data.com/crime/) - are police officers in more violent areas more likely to use violence themselves?

* Incorporate the [number of law enforcement officers in each jurisdiction](https://ucr.fbi.gov/crime-in-the-u.s/2011/crime-in-the-u.s.-2011/police-employee-data) - what is the total expenditure of each city on its law enforcement efforts and how does this compare to the average police officer salary and ultimately to the rate of police violence?
