-- Looking at the data
SELECT*
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS not NULL
order by 3,4

/*
SELECT*
FROM PortfolioProject.dbo.CovidVaccination
order by 3,4
*/
-- Select Data that we are going to be using
/*
Select location, date, total_cases,new_cases,total_deaths,population
FROM PortfolioProject.dbo.CovidDeath
order by 1,2
*/
/*-- Looing at Total cases VS Total Deaths
-- Shows likelyhood of dying in Australia
Select Location, date, total_cases,total_deaths, round(total_deaths/total_cases*100,2) as percentage_of_death
FROM PortfolioProject.dbo.CovidDeath
WHERE location = 'Australia'
order by 1,2;*/

-- Looking at Population VS Total Cases 
-- Shows what percentage of population got COVID

Select Location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeath
WHERE LOCATION LIKE '%states%'
order by 1,2;


SELECT Location,MAX(total_cases) AS Highest_Infection_Count, (MAX(total_cases/population))*100 AS percentageOfPopulationInfected
FROM PortfolioProject.dbo.CovidDeath 
GROUP BY Location
Order BY percentageOfPopulationInfected DESC; 

--Showing countries with total Death Count Per population
SELECT Location, MAX(total_deaths) As Total_Death_Count
FROM PortfolioProject.dbo.CovidDeath
WHERE continent is not null
GROUP BY Location
ORDER BY Total_Death_Count DESC;

-- Showing total deaths count by continent
SELECT Location, MAX(total_deaths) As Total_Death_Count
FROM PortfolioProject.dbo.CovidDeath
WHERE continent is null and location not like '%income'
GROUP BY Location
ORDER BY Total_Death_Count DESC;

-- Global cases and deaths
SELECT date, SUM(new_cases) as total_cases ,SUM(cast(new_deaths as int)) as total_deaths, round(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,2) as DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2


-- LOOKING at population VS vacination

SELECT dea.continent, dea.[location],dea.[date],dea.population,vac.new_vaccinations
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    and dea.[date] = vac.[date]
WHERE dea.continent is not NULL
ORDER by 2,3


-- USE CTE
WITH PopVSVac(continent, location,date,population,new_vaccinations, rolling_People_Vaccinated)
as(
SELECT dea.continent, dea.[location],dea.[date],dea.population,vac.new_vaccinations, SUM(vac.new_vaccinations)OVER(PARTITION BY dea.LOCATION ORDER BY dea.location,dea.date) as rolling_People_Vaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    and dea.[date] = vac.[date]
WHERE dea.continent is not NULL)
--ORDER by 2,3

SELECT *, rolling_People_Vaccinated/population*100
FROM PopVSVac

--USE TEMP TABLE
DROP TABLE if EXISTS #PercentPopulationVaccinated
/*Create TABLE PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    LOCATION NVARCHAR(255),
    DATE DATETIME,
    Population Numeric,
    new_vaccinations NUMERIC,
    rolling_People_Vaccinated NUMERIC
)
INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.[location],dea.[date],dea.population,vac.new_vaccinations, SUM(vac.new_vaccinations)OVER(PARTITION BY dea.LOCATION ORDER BY dea.location,dea.date) as rolling_People_Vaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    and dea.[date] = vac.[date]
--WHERE dea.continent is not NULL

SELECT *, rolling_People_Vaccinated/population*100
FROM PercentPopulationVaccinated
*/

/*
Create VIEW PercentPopulationVaccinated2 as 
SELECT dea.continent, dea.[location],dea.[date],dea.population,vac.new_vaccinations, SUM(vac.new_vaccinations)OVER(PARTITION BY dea.LOCATION ORDER BY dea.location,dea.date) as rolling_People_Vaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    and dea.[date] = vac.[date]
WHERE dea.continent is not NULL
*/