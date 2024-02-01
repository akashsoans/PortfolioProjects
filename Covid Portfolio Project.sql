--CovidVaccinations Table
SELECT *
FROM Portfolioproject..CovidVaccinations
ORDER BY 3,4

--CovidDeaths Table
SELECT *
FROM Portfolioproject..CovidDeaths
ORDER BY 3,4

--Select Data that we are going to be using
SELECT Location, Date, Total_cases, New_cases, Total_deaths, Population
FROM Portfolioproject..CovidDeaths
ORDER BY 1,2
 

--Looking at Total cases vs Total deaths
--Shows likelihood of dying if you contract covid in your country
SELECT Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
FROM Portfolioproject..CovidDeaths
WHERE location like '%Canada%'
ORDER BY 1,2


--Looking at the Total cases vs Population
SELECT Location, Date, Population, Total_cases, (Total_cases/Population)*100 as CovidcasesPercentage
FROM Portfolioproject..CovidDeaths
ORDER BY 1,2


--Looking at countries with highest infection rate compared to population
SELECT Location, Population, MAX(Total_cases) as HighestInfectionCount, MAX((Total_cases/Population))*100 as MaxCovidcasesPercentage
FROM Portfolioproject..CovidDeaths
WHERE Continent is not NULL
GROUP BY Location, Population
ORDER BY MaxCovidcasesPercentage desc


--Showing Countries with Highest Death Count per Population
SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Portfolioproject..CovidDeaths
WHERE Continent is not NULL
GROUP BY Location
ORDER BY TotalDeathCount desc


--Showing continents with the highest death count per population
SELECT Location, Max(cast(Total_deaths as int)) as TotalDeathCount
FROM Portfolioproject..CovidDeaths
WHERE Continent is null
GROUP BY Location
ORDER BY TotalDeathCount desc

--Daily Global Numbers of cases and deaths
SELECT Date,SUM(new_cases) as GlobalCasesPerDay, SUM(CAST(new_deaths as int)) as GlobalDeathsPerDay, 
(SUM(Cast(new_deaths as int))/SUM(new_cases))*100 as GlobalDeathsPerGlobalCases
FROM Portfolioproject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1

--Total Global Numbers of cases and deaths
SELECT SUM(new_cases) as GlobalCasesPerDay, SUM(CAST(new_deaths as int)) as GlobalDeathsPerDay, 
(SUM(Cast(new_deaths as int))/SUM(new_cases))*100 as GlobalDeathsPerGlobalCases
FROM Portfolioproject..CovidDeaths
WHERE continent is not null

--Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations as int)) OVER (Partition by dea.location ORDER by dea.location,dea.date) as RollingCountNewVaccinations
FROM Portfolioproject..CovidDeaths dea
JOIN Portfolioproject..CovidVaccinations Vacc
     ON dea.location = vacc.location
	 and dea.date = vacc.date
WHERE dea.continent is not null
ORDER BY 2,3


--looking at percentage of total people vaccinated by date using CTE

With PopvsVac (Continent, Location, date, population, new_vaccinations, RollingCountNewVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations as int)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingCountNewVaccinations
FROM Portfolioproject..CovidDeaths dea
JOIN Portfolioproject..CovidVaccinations Vacc
     ON dea.location = vacc.location
	 and dea.date = vacc.date
WHERE dea.continent is not null
)

Select *, (RollingCountNewVaccinations/Population)*100 as PercentageOfPeopleVaccinated
From PopvsVac

--looking at percentage of total people vaccinated by date Using Temp table
DROP TABLE IF EXISTS #PercentagePeopleVaccinated
Create Table #PercentagePeopleVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingCountNewVaccinations numeric
)

Insert into #PercentagePeopleVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations as int)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingCountNewVaccinations
FROM Portfolioproject..CovidDeaths dea
JOIN Portfolioproject..CovidVaccinations Vacc
     ON dea.location = vacc.location
	 and dea.date = vacc.date
WHERE dea.continent is not null


Select *, (RollingCountNewVaccinations/Population)*100 as PercentageOfPeopleVaccinated
From #PercentagePeopleVaccinated

--Creating view to store data for later Visualization
Create View PercentagePeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations as int)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingCountNewVaccinations
FROM Portfolioproject..CovidDeaths dea
JOIN Portfolioproject..CovidVaccinations Vacc
     ON dea.location = vacc.location
	 and dea.date = vacc.date
WHERE dea.continent is not null

Select *
From PercentagePeopleVaccinated