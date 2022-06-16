
-- Проверяем, не находится ли герой на запрещенке
function checkNeedAutoTransferHero()
  print "checkNeedAutoTransferHero"

  local activePlayerId = getSelectedBattlefieldPlayerId();
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[activePlayerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  if HasHeroSkill(mainHeroName, PERK_PATHFINDING) == nil and dictHeroName ~= HEROES.JAZAZ then
    -- Добавить передвижение героя на
  end;
end;

-- Генерим сид
function generateSeed()
  print "generateSeed"

  local t = {};
  
	for i=1,6 do
		t[i] = random(16777216)
	end;

	consoleCmd([[@SetGameVar('combat_prng_seed', 'return {]] .. concat(t, ',') .. [[}')]])
end;

-- Прокидываем данные об игроках в боевые скрипты
function saveHeroesInfoInToBattle()
  print "saveHeroesInfoInToBattle"
  
  local customConsoleCommand = {[[@SetGameVar('heroes_info', 'return {]]};
  
  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    append(customConsoleCommand, '["' .. mainHeroName .. '"]={');
    
    -- уровень --
		append(customConsoleCommand, 'level=' .. GetHeroLevel(mainHeroName) .. ',')

		-- удача --
		append(customConsoleCommand, 'luck=' .. GetHeroStat(mainHeroName, STAT_LUCK) .. ',')

		-- артефакты --
		append(customConsoleCommand, 'ArtSet={')
    for artset = 0, 9 do
      local artsetlevel = GetArtifactSetItemsCount(mainHeroName, artset, 1)
      if artsetlevel > 0 then
        append(customConsoleCommand, '[' .. artset .. ']=' .. artsetlevel .. ',')
      end
    end
    append(customConsoleCommand, '},')

		-- навыки и умения --
		append(customConsoleCommand, 'skills={')
		for skill = 1, 220 do
			local mastery = GetHeroSkillMastery(mainHeroName, skill)
			if mastery > 0 then
				append(customConsoleCommand, '[' .. skill .. ']=' .. mastery .. ',')
			end
		end
		append(customConsoleCommand, '},')

		append(customConsoleCommand, '},')
  end;
  
  append(customConsoleCommand, [[}')]])
	consoleCmd(concat(customConsoleCommand))
end;

-- Точка старта
function day5_scripts()
  print "day5_scripts"

  saveHeroesInfoInToBattle();
  generateSeed();
  
  consoleCmd("@SetGameVar('execution_thread', '1')");
  
  local p1MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_1].name;
  local p2MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_2].name;
  
  while IsHeroAlive(p1MainHeroName) and IsHeroAlive(p2MainHeroName) do
    MakeHeroInteractWithObject(p1MainHeroName, p2MainHeroName);
    sleep(10);
  end;
end;

day5_scripts();