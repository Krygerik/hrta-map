-- Скрипты установки начальных значений ресурсов для игроков

-- Путь до сообщений этого модуля
PATH_TO_SET_INIT_RESOURCES_MESSAGES = GetMapDataPath().."day3/set_initial_resources/messages/"

doFile(GetMapDataPath().."day3/set_initial_resources/set_initial_resources_constants.lua");
sleep(1);

-- Точка входа
function setInitialResources()
  print "setInitialResources"
  
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local bonus = getCalculatedStartedBonus(playerId);
    local secondHero = GetPlayerHeroes(playerId)[1];
  
    for resourceId, resourceValue in INITIAL_RESOURCES[raceId] do
      local resValue = resourceValue;
    
      -- Для золота учитываем стартовый бонус
      if resourceId == GOLD then
        if bonus == STARTED_BONUSES.GOLD then
          local randomStartGold = 4000 + random(11)*100;

          resValue = resValue + randomStartGold;

          ShowFlyingSign({PATH_TO_SET_INIT_RESOURCES_MESSAGES.."start_gold.txt"; eq = randomStartGold}, secondHero, playerId, 5.0);
        end;
      end;
      
      SetPlayerResource(playerId, resourceId, resValue);
    end;
  end;
end;

-- Точка входа
setInitialResources();
