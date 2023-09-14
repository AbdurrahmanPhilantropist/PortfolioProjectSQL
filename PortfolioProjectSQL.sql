select *
from FirstProject.CovidDeath
where continent is not null
order by 3,4 

-- data will be using
select location, date, total_cases, new_cases, total_cases, population
from FirstProject.CovidDeath
order by 1,2


-- looking at Total cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/ total_cases ) * 100 as Death_Percentage
from FirstProject.CovidDeath
where location like %states%
order by 1,2 

-- shows what percentage of population got covid

 select location, date, population, total_cases, (total_deaths/ population ) * 100 as Death_Percentage
from FirstProject.CovidDeath

order by Death_Percentage 

-- looking at countries with highest infection rate compared to Population

 select Location, population, max(total_cases) as HighestInfectionCount , max((total_deaths/ population )) * 100 as PercentPopulationInfection
from FirstProject.CovidDeath
group by Location, Population
order by PercentPopulationInfection desc  

-- showing the countries with the highest death count by population

select Location, max(Total_deaths) as TotalDeathCount 
from FirstProject.CovidDeath
where continent is not null
group by Location
order by TotalDeathCount desc  

-- continent with the highest death count

select continent, max(Total_deaths) as TotalDeathCount 
from FirstProject.CovidDeath
where continent is not null
group by continent
order by TotalDeathCount desc  

-- Global Numbers

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/ sum(new_cases)*100 as DeathPercentage 
from FirstProject.CovidDeath
where continent is not null
group by date
order by 1,2   

-- looking at total Population vs Vaccinations

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from FirstProject.CovidDeath dea
join FirstProject.CovidVaccination vac
   on dea.location = vac.location
   and dea.date = vac.date
    
where dea.continent is not null
 
order by 2,3


-- USE CTE
WITH PopvsVac (Continent, location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from FirstProject.CovidDeath dea
join FirstProject.CovidVaccination vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated / Population)*100
 from PopvsVac


-- TEMPORARY TABLE
drop table if exists #PercentPopulationVaccinated
create temporary table #PercentPopulationVaccinated
( Continent nvarchar (255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);
insert into #PercentPopulationVaccinated
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from FirstProject.CovidDeath dea
join FirstProject.CovidVaccination vac
   on dea.location = vac.location
   and dea.date = vac.date
-- where dea.continent is not null
 
 select * (RollingPeopleVaccinated/Population)*100
 from #PercentPopulationVaccinated

-- creating view to store data for later visualization

create view PercentPopulationVaccinated as
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from FirstProject.CovidDeath dea
join FirstProject.CovidVaccination vac
   on dea.location = vac.location
   and dea.date = vac.date
 where dea.continent is not null








