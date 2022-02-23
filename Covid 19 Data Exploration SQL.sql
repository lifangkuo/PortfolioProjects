Select * From 
PortfolioProject..CovidDeaths 
order by 3,4;

Select * From 
PortfolioProject..CovidDeaths 
Where continent is not null
order by 3,4;


--Select * 
--from PortfolioProject..CovidVaccinations 
--order by 3, 4;


Select location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..CovidDeaths 
Where continent is not null
order by 1, 2;

-- Looking at Total Cases vs Total Deaths
Select location, date, total_cases, total_deaths, 
Round((Cast(total_deaths as int)/total_cases)*100, 2) as DeathPercentage
From PortfolioProject..CovidDeaths 
Where continent is not null
order by 1, 2;

-- Looking at Total Cases vs Population
Select location, date, population, total_cases, 
Round((total_cases/population)*100, 2) as PercentPopulationInfected
From PortfolioProject..CovidDeaths 
Where continent is not null
order by 1, 2;

-- Looking at Countries with Highest Infection Rate Compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount, 
Round(MAX(total_cases/population)*100, 2) as PercentPopulationInfected
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by location, population
order by PercentPopulationInfected desc;


-- Showing Countries with Highest Death Count per Poppulation
Select location, MAX(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by location
order by TotalDeathCount desc;


-- Showing continents with the highest death count per population
Select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
Where continent is not null 
Group by continent
order by TotalDeathCount desc;



-- Global Numbers
Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, 
Round(Sum(Cast(new_deaths as int))/Sum(new_cases)*100, 2) as DeathPercentage
From PortfolioProject..CovidDeaths 
Where continent is not null
order by 1, 2;



-- Looking at Countries with Vaccinated Rate 
-- Using CTE

With Popvsvac (continent, location, date, population, people_vaccinated, vaccinated_rate_per_hundred)
as
(
Select Distinct dea.continent, dea.location, dea.date, dea.population,vac.people_vaccinated,
Round((Convert(bigint, vac.people_vaccinated)/dea.population)*100, 2)

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *
From PopvsVac
Order by 2, 3;



-- Using Temp table
Drop table if exists #PercentPopluationVaccinated;
Create Table #PercentPopluationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Ddte datetime,
population float,
people_vaccinated nvarchar(255),
vaccinated_rate_per_hundred nvarchar(255)
)

-- For 'people_vaccinated' and 'vaccinated_rate_per_hundred', 
-- nvarchar(255) is the default datatype from the oringinal dataset

Insert Into #PercentPopluationVaccinated
Select Distinct dea.continent, dea.location, dea.date, dea.population,vac.people_vaccinated,
Round((Convert(bigint, vac.people_vaccinated)/dea.population)*100, 2)

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null;

Select *
From #PercentPopluationVaccinated
Order by 2, 3;




-- Creating View to store data for later visualizations

Use PortfolioProject;

-- View for PercentPopluationVaccinated;


Drop View if exists PercentPopluationVaccinated;
Go
Create View PercentPopluationVaccinated As
Select Distinct dea.continent, dea.location, dea.date, dea.population,vac.people_vaccinated,
Round((Convert(bigint, vac.people_vaccinated)/dea.population)*100, 2) 
As vaccinated_rate_per_hundred

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null;
Go



-- View for countries with the highest_death_count;

--Drop View if exists country_highest_death_count;
--Go
--Create View country_highest_death_count As
--Select location, MAX(Cast(total_deaths As int)) As TotalDeathCount
--From PortfolioProject..CovidDeaths 
--Where continent is not null
--Group by location;
--Go



-- View for Total Cases vs Total Deaths;

Drop View if exists TotalCasesVsDeaths;
Go
Create View TotalCasesVsDeaths As
Select location, date, total_cases, total_deaths, 
Round(((Convert(int, total_deaths)/total_cases)*100), 2) as DeathPercentage
From PortfolioProject..CovidDeaths 
Where continent is not null
Go


-- View for Total Cases vs Population;

Drop View if exists TotalCasesVsPopulation;
Go
Create View TotalCasesVsPopulation As
Select location, date, population, total_cases, 
Round((total_cases/population)*100, 2)as PercentPopulationInfected
From PortfolioProject..CovidDeaths 
Where continent is not null
Go







