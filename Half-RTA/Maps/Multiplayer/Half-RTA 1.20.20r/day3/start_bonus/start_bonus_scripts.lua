-- Путь до сообщений этого модуля
PATH_TO_START_BONUS_MESSAGES = GetMapDataPath().."day3/start_bonus/messages/"

doFile(GetMapDataPath().."day3/start_bonus/start_bonus_constants.lua");
sleep(1);

-- Получение начального бонуса игрокам
function setStartedBonus()
  print "setStartedBonus"

  for _, playerId in PLAYER_ID_TABLE do
    local bonus = getCalculatedStartedBonus(playerId);
    local firstHero = GetPlayerHeroes(playerId)[0];
    local secondHero = GetPlayerHeroes(playerId)[1];

    if bonus == STARTED_BONUSES.GOLD then
      local randomStartGold = 4000 + random(11)*100;
      
      SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + randomStartGold);
      ShowFlyingSign({PATH_TO_START_BONUS_MESSAGES.."start_gold.txt"; eq = randomStartGold}, secondHero, playerId, 5.0);
    end;
    
    if bonus == STARTED_BONUSES.ART then
      transferAllSmallArt(firstHero, secondHero);
    end;
  end;
end;

-- Перенос ма артефактов между героями
function transferAllSmallArt(sourceHero, targetHero)
  print "transferAllSmallArt"
  
  for i = 1, length(ARTS.SMALL) do
    if HasArtefact(sourceHero, ARTS.SMALL[i].id) then
      GiveArtefact(targetHero, ARTS.SMALL[i].id);
      RemoveArtefact(sourceHero, ARTS.SMALL[i].id);
    end;
  end;
end;

-- Точка входа
setStartedBonus();
