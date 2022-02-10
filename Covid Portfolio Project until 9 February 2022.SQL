/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views
*/

-- membuat tabel CovidDeaths

CREATE TABLE CovidDeaths (
	id Serial,
	iso_code VARCHAR(50),
  	continent VARCHAR(50),
 	location VARCHAR(50),
	date DATE,
	population float,
	total_cases float,
	new_cases float,
	new_cases_smoothed float,
	total_deaths float,
	new_deaths float,
	new_deaths_smoothed float,
	total_cases_per_million float,
	new_cases_per_million float,
	new_cases_smoothed_per_million float,
	total_deaths_per_million float,
	new_deaths_per_million float,
	new_deaths_smoothed_per_million float,
	reproduction_rate float,
	icu_patients float,
	icu_patients_per_million float,
	hosp_patients float,
	hosp_patients_per_million float,
	weekly_icu_admissions float,
	weekly_icu_admissions_per_million float,
	weekly_hosp_admissions float,
	weekly_hosp_admissions_per_million float,
  PRIMARY KEY (id)
)

-- melihat tabel apakah sudah terbuat atau belum
SELECT * FROM CovidDeaths;

-- mengopy file CSV CovidDeaths yang didownload dari https://ourworldindata.org/covid-deaths

COPY CovidDeaths(iso_code,continent,location,date,population,total_cases,new_cases,new_cases_smoothed,total_deaths,new_deaths,new_deaths_smoothed,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million,total_deaths_per_million,new_deaths_per_million,new_deaths_smoothed_per_million,reproduction_rate,icu_patients,icu_patients_per_million,hosp_patients,hosp_patients_per_million,weekly_icu_admissions,weekly_icu_admissions_per_million,weekly_hosp_admissions,weekly_hosp_admissions_per_million)
FROM 'D:\Pekerjaan\Data Engineer\Learn SQL\CovidDeaths.csv'
DELIMITER ','
CSV HEADER;

-- membuat tabel CovidVaccinations
CREATE TABLE CovidVaccinations (
	id Serial,
	iso_code VARCHAR(50),
  	continent VARCHAR(50),
 	location VARCHAR(50),
	date DATE,
	new_tests float,
	total_tests float,
	total_tests_per_thousand float,
	new_tests_per_thousand float,
	new_tests_smoothed float,
	new_tests_smoothed_per_thousand float,
	positive_rate float,
	tests_per_case float,
	tests_units VARCHAR(50),
	total_vaccinations float,
	people_vaccinated float,
	people_fully_vaccinated float,
	total_boosters float,
	new_vaccinations float,
	new_vaccinations_smoothed float,
	total_vaccinations_per_hundred float,
	people_vaccinated_per_hundred float,
	people_fully_vaccinated_per_hundred float,
	total_boosters_per_hundred float,
	new_vaccinations_smoothed_per_million float,
	new_people_vaccinated_smoothed float,
	new_people_vaccinated_smoothed_per_hundred float,
	stringency_index float,
	population_density float,
	median_age float,
	aged_65_older float,
	aged_70_older float,
	gdp_per_capita float,
	extreme_poverty float,
	cardiovasc_death_rate float,
	diabetes_prevalence float,
	female_smokers float,
	male_smokers float,
	handwashing_facilities float,
	hospital_beds_per_thousand float,
	life_expectancy float,
	human_development_index float,
	excess_mortality_cumulative_absolute float,
	excess_mortality_cumulative float,
	excess_mortality float,
	excess_mortality_cumulative_per_million float,
  PRIMARY KEY (id)
)

-- mengopy file CSV CovidDeaths yang didownload dari https://ourworldindata.org/covid-deaths

COPY CovidVaccinations(iso_code,continent,location,date,new_tests,total_tests,total_tests_per_thousand,new_tests_per_thousand,new_tests_smoothed,new_tests_smoothed_per_thousand,positive_rate,tests_per_case,tests_units,total_vaccinations,people_vaccinated,people_fully_vaccinated,total_boosters,new_vaccinations,new_vaccinations_smoothed,total_vaccinations_per_hundred,people_vaccinated_per_hundred,people_fully_vaccinated_per_hundred,total_boosters_per_hundred,new_vaccinations_smoothed_per_million,new_people_vaccinated_smoothed,new_people_vaccinated_smoothed_per_hundred,stringency_index,population_density,median_age,aged_65_older,aged_70_older,gdp_per_capita,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,hospital_beds_per_thousand,life_expectancy,human_development_index,excess_mortality_cumulative_absolute,excess_mortality_cumulative,excess_mortality,excess_mortality_cumulative_per_million
)
FROM 'D:\Pekerjaan\Data Engineer\Learn SQL\CovidVaccinations.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM CovidVaccinations;

-- select data yang akan kita gunakan

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2

-- mencari total cases vs total deaths di Indonesia
-- menunjukkan kemungkinan kematian jika kamu tertular covid di Indonesia
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From CovidDeaths
Where location like 'Indonesia'
Order by 1,2

-- Total Cases vs Population
-- Menunjukkan berapa persentase populasi yang terinfeksi Covid di Indonesia

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
Where location like 'Indonesia'
order by 1,2


-- Negara dengan Tingkat Infeksi Tertinggi dibandingkan dengan Populasi Negara tersebut

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like 'Indonesia'
Group by Location, Population
order by PercentPopulationInfected desc


-- Negara dengan Jumlah Kematian Tertinggi per Populasi Negara tersebut

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- Melihat data dari sudut pandang Benua

-- Menampilkan benua dengan jumlah kematian tertinggi per populasi

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null AND total_cases is not null 
Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Menunjukkan Persentase Penduduk yang telah menerima setidaknya satu Vaksin Covid

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Menggunakan CTE untuk melakukan Perhitungan pada Partition By pada kueri sebelumnya

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Menggunakan Tabel Temp untuk melakukan Perhitungan pada Partisi Dengan di kueri sebelumnya

DROP Table if exists PercentPopulationVaccinated
CREATE Table PercentPopulationVaccinated
(
	Continent varchar(255),
	Location varchar(255),
	Date DATE,
	Population float,
	New_vaccinations float,
	RollingPeopleVaccinated float
)

Insert into PercentPopulationVaccinated ( Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--
