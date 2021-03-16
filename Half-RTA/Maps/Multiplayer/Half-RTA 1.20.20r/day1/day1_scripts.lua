-- Скрипт, выполняющийся при загрузке карты сразу же, в первый день

-- Путь до текущей папки
PATH_TO_DAY1_MODULE = GetMapDataPath().."day1/";

doFile(PATH_TO_DAY1_MODULE.."day1_constants.lua");
doFile(PATH_TO_DAY1_MODULE.."day1_utils.lua");
sleep(1)


-- Точка входа для выполнения скриптов модулю
function day1()
  print "day1"

  -- Получерк
  if GAME_MODE.HALF then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/half.lua");
  end;
  -- Простой выбор
  if GAME_MODE.SIMPLE_CHOOSE then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/simple.lua");
  end;
end;

-- Точка входа в модуль
day1();