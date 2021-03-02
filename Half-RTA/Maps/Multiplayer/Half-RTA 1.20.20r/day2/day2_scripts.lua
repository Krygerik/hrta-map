-- ���� �� ������� �����
local MODULE_PATH = GetMapDataPath().."day2/";
-- ���� �� ����� � ������� �����������
local PATH_TO_MODULE_MESSAGES = MODULE_PATH.."messages/";

-- ����� (����� ��������)
local redHero = GetPlayerHeroes(PLAYER_1)[0]
-- �������� (����� ������)
local blueHero = GetPlayerHeroes(PLAYER_2)[0]

-- ���� ��������
if GAME_MODE.MATCHUPS then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", redHero, 1, 5.0);
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", blueHero, 2, 5.0);
end;

-- ��������
if GAME_MODE.HALF then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."choose_race.txt", redHero, 1, 5.0);
   stop(blueHero);
end;

-- ��������� ����
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

-- ������� �����
if GAME_MODE.SIMPLE_CHOOSE then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", redHero, 1, 5.0);
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", blueHero, 2, 5.0);
end;

-- ������� ��� ���� ������������ � �����
function stop (hero)
  ChangeHeroStat (hero, STAT_MOVE_POINTS, -50000);
end;
