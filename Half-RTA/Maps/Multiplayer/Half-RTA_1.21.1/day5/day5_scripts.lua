
PATH_TO_DAY5_SCRIPTS = GetMapDataPath().."day5/";
PATH_TO_DAY5_MESSAGES = PATH_TO_DAY5_SCRIPTS.."messages/";

doFile(PATH_TO_DAY5_SCRIPTS.."day5_constants.lua");
sleep(1);

-- ����� ������
function day5_scripts()
  print "day5_scripts"

  if needPostponeBattle() then
    -- ���������� �� ����� ������
    selectBattlefield();
  else
    startBattle();
  end;
end;

day5_scripts();