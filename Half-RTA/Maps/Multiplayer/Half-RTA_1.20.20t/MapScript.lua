-- Не запускаем скрипты, если в бою
consoleCmd('@nde = 1')

sleep(10)
if nde == 1 then
	return
end

-- Увеличиваем размер строк вывода в консоль
-- Запрещаем писать в файл
consoleCmd('console_size 999')
consoleCmd('game_writelog 0')
sleep(1)

doFile(GetMapDataPath()..'common.lua');
doFile(GetMapDataPath()..'utils.lua');
doFile(GetMapDataPath()..'constants.lua');
sleep(1)

removeHeroMovePoints(Biara);
removeHeroMovePoints(Djovanni);

heroes1 = GetPlayerHeroes (PLAYER_1)
heroes2 = GetPlayerHeroes (PLAYER_2)

-- Обработчик наступления нового дня
function handleNewDay()
  if GetDate(DAY) == 2 then
    doFile(GetMapDataPath().."day2/day2_scripts.lua");
  end;

  if GetDate(DAY) == 3 then
    doFile(GetMapDataPath().."day3/day3_scripts.lua");
  end;
  
  if GetDate(DAY) == 4 then
    doFile(GetMapDataPath().."day4/day4_scripts.lua");
  end;
  
  if GetDate(DAY) == 5 then
    doFile(GetMapDataPath().."day5/day5_scripts.lua");
  end;
end;

-- Корневые триггеры
Trigger (NEW_DAY_TRIGGER, 'handleNewDay');

doFile(GetMapDataPath().."day1/day1_scripts.lua");
