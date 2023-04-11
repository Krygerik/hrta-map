
-- Выбор случайных 2 героев из переданного списка и 1 рандомным
function setRandomHeroFromHeroList(playerId, raceId, heroList)
  print "setRandomHeroFromHeroList"

  RESULT_HERO_LIST[playerId].raceId = raceId;

  local resultHeroes = RESULT_HERO_LIST[playerId].heroes;
  local opponentResultHeroes = RESULT_HERO_LIST[PLAYERS_OPPONENT[playerId]].heroes;

  for resultHeroIndex = 1, 2 do
    local randomSelectedHero;
    local countEqualHeroNames = 0;

    -- Повторять, пока не сгенерируем индекс героя, которого не выбрали
    repeat
      local randomIndex = random(length(heroList)) + 1;
      randomSelectedHero = heroList[randomIndex];
      countEqualHeroNames = 0;

      -- Проверяем наличие героя в наборе
      for heroIndex, heroName in resultHeroes do
        if heroName == randomSelectedHero then
          countEqualHeroNames = countEqualHeroNames + 1;
        end;
      end;

      -- Проверяем наличие героя в наборе оппонента
      for heroIndex, heroName in opponentResultHeroes do
        if heroName == randomSelectedHero then
          countEqualHeroNames = countEqualHeroNames + 1;
        end;
      end;
    until countEqualHeroNames == 0;

    resultHeroes[resultHeroIndex] = randomSelectedHero;
  end;

  -- Заполняем список еще одним случайным героем этой расы
  local allHeroesByRace = HEROES_BY_RACE[raceId];
  local randomHero;
  local countEqualHeroNames = 0;

  -- Повторяем, пока не зарандомим не выбранного героя
  repeat
    local randomIndex = random(length(allHeroesByRace)) + 1;
    randomHero = allHeroesByRace[randomIndex];
    countEqualHeroNames = 0;

    -- Проверяем наличие героя в наборе
    for i, resultHero in resultHeroes do
      if resultHero == randomHero.name then
        countEqualHeroNames = countEqualHeroNames + 1;
      end;
    end;

    -- Проверяем наличие героя в наборе оппонента
    for i, resultHero in opponentResultHeroes do
      if resultHero == randomHero.name then
        countEqualHeroNames = countEqualHeroNames + 1;
      end;
    end;
  until countEqualHeroNames == 0;

  resultHeroes[3] = randomHero.name;
end;