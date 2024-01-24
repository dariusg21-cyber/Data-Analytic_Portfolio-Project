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