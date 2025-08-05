select *
from covid_portfolio.dbo.CovidDeaths
order by 3,4
--select *
--from covid_portfolio.dbo.CovidVaccinations
--order by 3,4
-- select we are going to use
Select location, date, total_cases, new_cases, total_deaths, population
From covid_portfolio.dbo.CovidDeaths
order by 1,2

-- looking at total case vs total deaths
-- shows likelihood of dying if your contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
From covid_portfolio.dbo.CovidDeaths
Where location like '%states%'
order by 1,2

-- looking at countries with highest infection rates
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) *100 as InfectionPercentage
From covid_portfolio.dbo.CovidDeaths
where location like '%uzb%'
Group by Location, population
order by InfectionPercentage desc

-- LET'S break things down by continent
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From covid_portfolio.dbo.CovidDeaths
WHERE continent is null
Group by location
order by TotalDeathCount desc


--this is showing countries with highest death per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From covid_portfolio.dbo.CovidDeaths
WHERE continent is not null
Group by Location
order by TotalDeathCount desc

--Showing continents with highest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From covid_portfolio.dbo.CovidDeaths
WHERE continent is not null
Group by continent
order by TotalDeathCount desc

-- Global numbers
Select SUM((new_cases)) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From covid_portfolio.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2


-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(new_vaccinations as int)) over  (partition by dea.location order by dea.location, 
dea.Date) as  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from covid_portfolio..CovidDeaths dea
join covid_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(new_vaccinations as int)) over  (partition by dea.location order by dea.location, 
dea.Date) as  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from covid_portfolio..CovidDeaths dea
join covid_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

--temp table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(new_vaccinations as int)) over  (partition by dea.location order by dea.location, 
dea.Date) as  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from covid_portfolio..CovidDeaths dea
join covid_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--creating view to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(new_vaccinations as int)) over  (partition by dea.location order by dea.location, 
dea.Date) as  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from covid_portfolio..CovidDeaths dea
join covid_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null
--order by 2,3


select * 
from PercentPopulationVaccinated