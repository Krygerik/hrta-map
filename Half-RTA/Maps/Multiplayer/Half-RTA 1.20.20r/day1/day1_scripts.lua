-- ������, ������������� ��� �������� ����� ����� ��, � ������ ����

-- ���� �� ������� �����
PATH_TO_DAY1_MODULE = GetMapDataPath().."day1/";

doFile(PATH_TO_DAY1_MODULE.."day1_constants.lua");
doFile(PATH_TO_DAY1_MODULE.."day1_utils.lua");
sleep(1)

-- ����������� ������ ������
function detectHotseatStatus()
  print "detectHotseatStatus"
  
  if GetTurnTimeLeft(PLAYER_2) <= 0 then
    HOTSEAT_STATUS = not nil;
  end;
end;



-- ����� ����� ��� ���������� �������� ������
function day1()
  print "day1"

  detectHotseatStatus();

  -- ��������
  if GAME_MODE.HALF then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/half.lua");
  end;
  -- ������� �����
  if GAME_MODE.SIMPLE_CHOOSE then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/simple.lua");
  end;
  -- ���� ��������
  if GAME_MODE.MATCHUPS then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/matchups.lua");
  end;
  -- ���� ����
  if GAME_MODE.MIX then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/mix.lua");
  end;
end;

-- ����� ����� � ������
day1();
