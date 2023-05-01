
doFile(GetMapDataPath().."day3/start_bonus/start_bonus_constants.lua");
sleep(1);

-- ��������� ���������� ������ �������
-- �������� ������ ���������. ������ ��� ���������� �������� �� ����� �� ���������
function setStartedBonus()
  print "setStartedBonus"

  for _, playerId in PLAYER_ID_TABLE do
    local bonus = getCalculatedStartedBonus(playerId);
    
    PLAYER_STARTED_BONUSES[playerId] = bonus;

    local firstHero = GetPlayerHeroes(playerId)[0];
    local secondHero = GetPlayerHeroes(playerId)[1];
    
    if bonus == STARTED_BONUSES.ART then
      transferAllArts(firstHero, secondHero);
    end;
  end;
end;

-- ����� �����
setStartedBonus();
