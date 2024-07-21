select *
from CovidVaccinations$
where continent is not null
order by 3,4

select location = 'Bangladesh',  date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2

create view BDcovidDeaths as 
select location = 'Bangladesh',  date, total_cases, new_cases, total_deaths, population
from CovidDeaths$



--looking at total cases vs total Deaths

select location,  date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathper
from CovidDeaths$
where location like '%stan%'
order by 1,2

--creating views
create view DeathperCases as 

select location,  date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathper
from CovidDeaths$
where location like '%stan%'



--looking at total case vs population 

select location, date, total_cases, population, (total_cases/population)*100 as Perpopulation 
from CovidDeaths$
where location = 'India'
order by 1,2

-- looking at countries with highest infection rate 

select location, population, max(total_cases)as highestInfection, max(total_cases/population)*100 as PerPOpulation 
from CovidDeaths$
group by location, population

order by PerPOpulation desc

--looking at the total death by countries per population
select location, MAX(cast(total_deaths as int)) as HighestdeathRate
from CovidDeaths$
where continent is not null and total_deaths is not null 
group by continent, location 
order by HighestdeathRate desc

select location = 'Bangladesh', MAX(cast(total_deaths as int)) as HighestdeathRate
from CovidDeaths$
where total_deaths is not null 
group by continent, location 
order by HighestdeathRate asc

--lets do it by continent 
select continent, location, MAX(cast(total_deaths as int)) as HighestdeathRate
from CovidDeaths$
where continent is not null
group by continent
order by HighestdeathRate desc

select  location, MAX(cast(total_deaths as int)) as HighestdeathRate
from CovidDeaths$
where continent is not null
group by continent, location 
order by HighestdeathRate desc 


--Global Number

select  date,sum(new_cases) as Totalcases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100  as DeathPercentage
from CovidDeaths$
where continent is not null 
group by Date
order by 1,2,3

--using COMMON TABLE EXPRESSION 

with percentage (date, totalcases, totalDeaths, Deathpercentage)
as (
select  date,sum(new_cases) as Totalcases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100  as DeathPercentage
from CovidDeaths$
where continent is not null 
group by Date
--order by 1,2,3
)

select * 
from percentage







--covidVaccination table 
select dea.date, vac.total_tests, vac.total_vaccinations, vac.people_fully_vaccinated, dea.continent, dea.location 
,sum(cast(vac.new_vaccinations as int))  over (partition by dea.location order by dea.location, dea.date ) as newVacc
from CovidVaccinations$ vac
join CovidDeaths$ dea
	on vac.new_vaccinations = dea.total_deaths
	where 
	vac.total_vaccinations is not null
	and vac.people_fully_vaccinated is not null 
	and dea.continent is not null 
order by 1,2 
 
 --using CTE 

 WITH deathvsVac (Continent, location, date, population, people_fully_vaccinated, total_test, total_vacinations, newVacc)
 as (
 select dea.date,population, vac.total_tests, vac.total_vaccinations, vac.people_fully_vaccinated, dea.continent, dea.location 
,sum(cast(vac.new_vaccinations as int))  over (partition by dea.location order by dea.location, dea.date ) as newVacc
from CovidVaccinations$ vac
join CovidDeaths$ dea
	on vac.new_vaccinations = dea.total_deaths
	where 
	vac.total_vaccinations is not null
	and vac.people_fully_vaccinated is not null 
	and dea.continent is not null 
/*order by 1,2 */
)
 
 select *, (newvacc/population)*100 
 from deathvsVac




 --TEMP TABLE 
 
 CREATE TABLE #percentapopulationVaccinated 
 (
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
NewVacc numeric
)

insert into #percentapopulationVaccinated 
 select dea.date,population, vac.total_tests, vac.total_vaccinations, vac.people_fully_vaccinated, dea.continent, dea.location 
,sum(cast(vac.new_vaccinations as int))  over (partition by dea.location order by dea.location, dea.date ) as newVacc
from CovidVaccinations$ vac
join CovidDeaths$ dea
	on vac.new_vaccinations = dea.total_deaths
	where 
	vac.total_vaccinations is not null
	and vac.people_fully_vaccinated is not null 
	and dea.continent is not null 
/*order by 1,2 */


--creating views 

create view Newvacc as

select dea.date, vac.total_tests, vac.total_vaccinations, vac.people_fully_vaccinated, dea.continent, dea.location 
,sum(cast(vac.new_vaccinations as int))  over (partition by dea.location order by dea.location, dea.date ) as newVacc
from CovidVaccinations$ vac
join CovidDeaths$ dea
	on vac.new_vaccinations = dea.total_deaths
	where 
	vac.total_vaccinations is not null
	and vac.people_fully_vaccinated is not null 
	and dea.continent is not null 
--order by 1,2 

select *
from Newvacc