-- Устанавливаем голема и навешиваем триггер
function showGolem()
  print "showGolem"

  SetObjectEnabled('golem', nil);
  SetObjectPosition('red10', 1, 1, UNDERGROUND);
  SetObjectPosition('golem', 35, 83);
  SetDisabledObjectMode('golem', DISABLED_INTERACT);
  Trigger(OBJECT_TOUCH_TRIGGER, 'golem', 'questionGameMode1');
end;

-- Вопрос выбора режима 1
function questionGameMode1()
  print "questionGameMode1"
  
  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/question_enable_random_pickHero_no_mentor.txt", 'prepareForOnGameMode1', 'questionGameMode2');

end;

-- Вопрос выбора режима 2
function questionGameMode2()
  print "questionGameMode2"

  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/question_enable_game_mode_only_pick_hero.txt", 'prepareForOnGameMode2', 'noop');
end;

-- Подготовка к game-mode 1
--function prepareForOnGameMode1()
--  print "prepareForOnGameMode1"

--  RemoveObject('golem');
--  deleteAllRacesUnit();
--  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/mummy/mummy.lua");
--  prepareForRandomChoise()
  
--  CUSTOM_GAME_MODE_NO_MENTOR = 1;
--  CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = 1;
--end

function prepareForOnGameMode1()
  print "prepareForOnGameMode1"
  
  
  SetObjectPosition('golem', 19, 45);
  SetObjectPosition('red10', 35, 83, GROUND);
  CUSTOM_GAME_MODE_NO_MENTOR = 1;
  CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = 1;
end;

function prepareForOnGameMode2()
  print "prepareForOnGameMode2"


  SetObjectPosition('golem', 19, 45);
  SetObjectPosition('red10', 35, 83, GROUND);
  CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = 1;
end;


-- Подготовка к game-mode 2
--function prepareForOnGameMode2()
--  print "prepareForOnGameMode2"

--  RemoveObject('golem');
--  RemoveObject('mumiya');
--  deleteAllRacesUnit();
--  moveDelimetersToFirstMode()
  
--  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/half.lua");
  
--  CUSTOM_GAME_MODE_NO_MENTOR = 1;
--end

-- Перемещение магов и гремлина
function moveDelimetersToFirstMode()
  print "moveDelimetersToFirstMode"
  
  SetObjectPosition('mage1', 54, 87);
  SetObjectPosition('mage2', 60, 87);
  SetObjectPosition('mage3', 51, 9);
  SetObjectPosition('mage4', 57, 9);

  SetObjectPosition('gremlin1', 58, 80);
  SetObjectPosition('gremlin2', 58, 14);
  

  
end;

showGolem()