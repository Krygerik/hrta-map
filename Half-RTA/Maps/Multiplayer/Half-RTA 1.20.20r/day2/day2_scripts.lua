-- ���� �� ������� �����
local MODULE_PATH = GetMapDataPath().."day2/";
-- ���� �� ����� � ������� �����������
local PATH_TO_MODULE_MESSAGES = MODULE_PATH.."messages/";

-- ����� (����� ��������)
local Biara = GetPlayerHeroes(PLAYER_1)[0]
-- �������� (����� ������)
local Djovanni = GetPlayerHeroes(PLAYER_2)[0]

-- ���� ��������
if GAME_MODE.MATCHUPS then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", Biara, 1, 5.0);
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", Djovanni, 2, 5.0);
end;

-- ��������
if GAME_MODE.HALF then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."choose_race.txt", Biara, 1, 5.0);
   stop(Djovanni);
end;

-- ��������� ����
if GAME_MODE.MIX then
   if podvariant == 1 then
      ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."mix_cherk_desc.txt", Biara, 1, 5.0);
      stop (Djovanni);
   end;
   if podvariant == 2 then
      ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_of_set_step1.txt", Biara, 1, 5.0);
      ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_of_set_step1.txt", Djovanni, 2, 5.0);
   end;
end;

-- ������� �����
if GAME_MODE.SIMPLE_CHOOSE then
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", Biara, 1, 5.0);
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", Djovanni, 2, 5.0);
end;

-- ������� ��� ���� ������������ � �����
function stop (hero)
  ChangeHeroStat (hero, STAT_MOVE_POINTS, -50000);
end;
