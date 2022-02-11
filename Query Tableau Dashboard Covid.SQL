/*
Queries used for Tableau Project with export from query to csv, aggragation, 
*/


-- 1. 

COPY ( 
	Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	From CovidDeaths
	--Where location like 'Indonesia'
	where continent is not null 
	--Group By date
	order by 1,2
)
TO 'D:\Pekerjaan\Data Engineer\Learn SQL\Tableu\t1.csv' DELIMITER ',' CSV HEADER;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From CovidDeaths
----Where location like 'Indonesia'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

COPY ( 
	Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
	From CovidDeaths
	--Where location like '%states%'
	Where continent is null 
	and location not in ('World', 'European Union', 'International')
	Group by location
	order by TotalDeathCount desc
)
TO 'D:\Pekerjaan\Data Engineer\Learn SQL\Tableu\t2.csv' DELIMITER ',' CSV HEADER;

-- 3.

COPY ( 
	Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
	From CovidDeaths
	--Where location like '%states%'
	Group by Location, Population
	order by PercentPopulationInfected desc
)
TO 'D:\Pekerjaan\Data Engineer\Learn SQL\Tableu\t3.csv' DELIMITER ',' CSV HEADER;

-- 4.

COPY ( 
	Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
	From CovidDeaths
	--Where location like '%states%'
	Group by Location, Population, date
	order by PercentPopulationInfected desc
)
TO 'D:\Pekerjaan\Data Engineer\Learn SQL\Tableu\t4.csv' DELIMITER ',' CSV HEADER;



-- the dashboard that i made from this query https://public.tableau.com/app/profile/asep7889/viz/CovidPercentPopulationInfectedDashboard/Dashboard1