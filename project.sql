-- Looking at all the data in covidDeaths table
SELECT * FROM
projects..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

-- Looking at case by case for total deaths

SELECT location, date, total_cases, new_cases, total_deaths, population
from projects..CovidDeaths
ORDER BY 1, 2;

--looking at total cases vs total deaths

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as death_percentage
from projects..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2;


--Looking at the total cases vs population

SELECT location, date, total_cases, population,(total_cases/population)*100 as case_percentage
from projects..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2;

--Looking at counties with highest infection rate compared to population
SELECT location, MAX(total_cases) as highestInfection, population, MAX((total_cases/population))*100 as case_percentage
from projects..CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY population, location
ORDER BY case_percentage DESC;

--Looking at the countries with the hightes death count per population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeaths
from projects..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeaths DESC;


--breaking things down by continent

SELECT location, MAX(cast(total_deaths as int)) as TotalDeaths
from projects..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeaths DESC;

-- showing the continents with the hightest death counts

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeaths
from projects..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC;


--caculate * for the entire world aka global numbers

SELECT date, SUM(new_cases) as new_cases, SUM(cast(new_deaths as int))  as new_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from projects..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2;


--look at vax table with join/ total vax vs population

SELECT dea.continent, dea.date, dea.population, vax.new_vaccinations,
SUM(CAST(vax.new_vaccinations as int)) OVER(partition by dea.location ORDER BY dea.location, dea.date)
as rollingVax (rollingVax/population)*100
FROM projects..CovidDeaths dea
join CovidVaccinations$ vax on dea.location = vax.location
and dea.date = vax.date
where dea.continent is not null
ORDER BY 2, 3;

-- Use Cte
WITH PopvsVax (continent, location, date, population,new_vaccinations, rollingVax)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(CAST(vax.new_vaccinations as int)) OVER(partition by dea.location ORDER BY dea.location, dea.date)
as rollingVax
--, (rollingVax/population)*100
FROM projects..CovidDeaths dea
join CovidVaccinations$ vax on dea.location = vax.location
and dea.date = vax.date
where dea.continent is not null
--ORDER BY 2, 3;
)
SELECT *,(rollingVax/population)*100 
FROM PopvsVax


--Temp table

CREATE TABLE vaxvax (
INSERT INTO
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(CAST(vax.new_vaccinations as int)) OVER(partition by dea.location ORDER BY dea.location, dea.date)
as rollingVax
--, (rollingVax/population)*100
FROM projects..CovidDeaths dea
join projects..CovidVaccinations$ vax on dea.location = vax.location
and dea.date = vax.date
where dea.continent is not null
--ORDER BY 2, 3;
)
SELECT *,(rollingVax/population)*100 
FROM PopvsVax

SELECT vax.date, vax.location, vax.life_expectancy, dea.new_deaths 
FROM projects..CovidVaccinations$ vax JOIN projects..CovidDeaths dea
on vax.date = dea.date
and vax.location = dea.location
AND vax.location LIKE '%states%'
;

-- Creating a view for later 
CREATE view PopulationPercentage as
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(CAST(vax.new_vaccinations as int)) OVER(partition by dea.location ORDER BY dea.location, dea.date)
as rollingVax
--, (rollingVax/population)*100
FROM projects..CovidDeaths dea
join projects..CovidVaccinations$ vax on dea.location = vax.location
and dea.date = vax.date
where dea.continent is not null
--ORDER BY 2, 3;

SELECT * FROM PopulationPercentage