use portfolioproject;

/*

Queries used for tableau Project

*/

--1.

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/ sum(new_cases)*100 as deathpercentage
from covid_death
where continent is not null
order by 1,2;

--nummber are extremly close so we will keep them-
-- the second include "international" location

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/ sum(new_cases)*100 as deathpercentage
from covid_death
where location = 'World'
order by 1,2;

--2.

--We take out these as they are not included in the above queries and want to stay consistant
-- European union is the part of Europe

select location, sum(cast(new_deaths as int)) as totaldeathcount
from covid_death
where continent is null
and location not in ('world', 'European union', 'international')
group by location
order by totaldeathcount desc;

--3.

select location, population, max(total_cases) as highest_infection_count,
max((total_cases/population))*100 as percent_population_infected
from covid_death
group by location, population
order by percent_population_infected desc;

--4.

select location, population,date, max(total_cases) as highest_infection_count,
max((total_cases/population))*100 as percent_population_infected
from covid_death
group by location, population, date
order by percent_population_infected desc;


--Original Queries.

--1.

select dea.continent, dea.location, dea.date, dea.population,
max(vac.total_vaccinations) as rolling_people_vaccinated
from covid_death as dea
join covid_vaccination as vac
	 on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1, 2, 3;

--2.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From covid_death
where continent is not null 
order by 1,2

-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From covid_death
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PercentPopulationInfected
From covid_death
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From Covid_Death
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From covid_death
where continent is not null 
order by 1,2


-- 6. 


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_death as dea
Join covid_vaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,
Max((total_cases/population))*100 as PercentPopulationInfected
From covid_death
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc