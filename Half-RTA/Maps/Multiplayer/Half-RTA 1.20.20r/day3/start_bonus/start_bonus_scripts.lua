
doFile(GetMapDataPath().."day3/start_bonus/start_bonus_constants.lua");
sleep(1);

-- ��������� ���������� ������ �������
-- �������� ������ ���������. ������ ��� ���������� �������� �� ����� �� ���������
function setStartedBonus()
  print "setStartedBonus"

  for _, playerId in PLAYER_ID_TABLE do
    local bonus = getCalculatedStartedBonus(playerId);
    local firstHero = GetPlayerHeroes(playerId)[0];
    local secondHero = GetPlayerHeroes(playerId)[1];
    
    if bonus == STARTED_BONUSES.ART then
      transferAllSmallArt(firstHero, secondHero);
    end;
  end;
end;

-- ������� �� ���������� ����� �������
function transferAllSmallArt(sourceHero, targetHero)
  print "transferAllSmallArt"
  
  for i = 1, length(ARTS.SMALL) do
    if HasArtefact(sourceHero, ARTS.SMALL[i].id) then
      GiveArtefact(targetHero, ARTS.SMALL[i].id);
      RemoveArtefact(sourceHero, ARTS.SMALL[i].id);
    end;
  end;
end;

-- ����� �����
setStartedBonus();
