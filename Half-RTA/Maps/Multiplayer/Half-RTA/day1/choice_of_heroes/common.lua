-- ������� �� ��� 1 ���������� ����� �� ������ ������ ������
function getRandomHeroFromAll()
  print "setRandomHeroFromHeroList"
  
  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local allHeroesByRace = HEROES_BY_RACE[raceId];

    local resultHeroes = RESULT_HERO_LIST[playerId].heroes;
    local opponentResultHeroes = RESULT_HERO_LIST[PLAYERS_OPPONENT[playerId]].heroes;

    local filteredHeroList = {};

    for _, heroData in allHeroesByRace do
      local isExist = nil;

      for _, disallowHeroName in resultHeroes do
        if heroData.name == disallowHeroName then
          isExist = not nil;
        end;
      end;

      for _, disallowHeroName in opponentResultHeroes do
        if heroData.name == disallowHeroName then
          isExist = not nil;
        end;
      end;

      if not isExist then
        filteredHeroList[length(filteredHeroList) + 1] = heroData.name;
      end;
    end;

    -- �������� ����� � �������
    local randomHeroIndex = random(length(filteredHeroList)) + 1;

    local randomHero = filteredHeroList[randomHeroIndex];

    resultHeroes[length(resultHeroes) + 1] = randomHero;
  end;
end;

-- ����� ��������� 2 ������ �� ����������� ������ � 1 ���������
function setRandomHeroFromHeroList()
  print "setRandomHeroFromHeroList"

  -- ������� 2 ��������� ������ �� ��������� �������
  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local resultHeroes = RESULT_HERO_LIST[playerId].heroes;
    local opponentResultHeroes = RESULT_HERO_LIST[PLAYERS_OPPONENT[playerId]].heroes;
    local heroList = RESULT_HERO_LIST[playerId].choised_heroes;

    local filteredHeroList = {};

    -- ������� �� ������ ��������� ������, ��������� ������ ���������
    for _, posibleHeroName in heroList do
      local isExist = nil;

      for _, disallowHeroname in opponentResultHeroes do
        if posibleHeroName == disallowHeroname then
          isExist = not nil;
        end;
      end

      if not isExist then
        filteredHeroList[length(filteredHeroList) + 1] = posibleHeroName;
      end;
    end;

    for resultHeroIndex = 1, 3 do
      -- �������� ��������� �����

      local randomHeroIndex = random(length(filteredHeroList)) + 1;

      local randomHero = filteredHeroList[randomHeroIndex];

      resultHeroes[resultHeroIndex] = randomHero;

      -- ��������� ������ ��������� ������
      local heroListWORandomHero = {};

      for _, heroName in filteredHeroList do
        if heroName ~= randomHero then
          heroListWORandomHero[length(heroListWORandomHero) + 1] = heroName;
        end;
      end;

      filteredHeroList = heroListWORandomHero;
    end;
  end;

  -- ������� �� ��� 1 ���������� ����� �� ������ ������ ������
  -- getRandomHeroFromAll();
end;