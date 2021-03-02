-- Путь до текущей папки
local MODULE_PATH = GetMapDataPath().."day2/";
-- Путь до папки с текстом уведомлений
local PATH_TO_MODULE_MESSAGES = MODULE_PATH.."messages/";

-- Биара (герой красного)
local redHero = GetPlayerHeroes(PLAYER_1)[0]
-- Джованни (негой синего)
local blueHero = GetPlayerHeroes(PLAYER_2)[0]

-- черк матчапов
if GAME_MODE.MATCHUPS then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", redHero, 1, 5.0);
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", blueHero, 2, 5.0);
end;

-- получерк
if GAME_MODE.HALF then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."choose_race.txt", redHero, 1, 5.0);
   stop(blueHero);
end;

-- смешанный черк
if GAME_MODE.MIX then
   if podvariant == 1 then
      ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."mix_cherk_desc.txt", redHero, 1, 5.0);
      stop (blueHero);
   end;
   if podvariant == 2 then
      ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_of_set_step1.txt", redHero, 1, 5.0);
      ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_of_set_step1.txt", blueHero, 2, 5.0);
   end;
end;

-- простой выбор
if GAME_MODE.SIMPLE_CHOOSE then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", redHero, 1, 5.0);
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", blueHero, 2, 5.0);
end;

-- Снимает все очки передвижения у героя
function stop (hero)
  ChangeHeroStat (hero, STAT_MOVE_POINTS, -50000);
end;
