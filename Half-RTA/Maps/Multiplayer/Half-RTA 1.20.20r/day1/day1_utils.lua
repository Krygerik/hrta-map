-- ����, ����������� ����� �������, ������� ������������ � ������ �������� �������� ������

-- �������, �� �������� ������
function noop()
end;

-- ������� ��� ���� ������������ � ����������� ����� �� 0
function removeHeroMovePoints(hero)
  print "removeHeroMovePoints"

  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- ��������� ���� ������������ � ����������� �����
function addHeroMovePoints(hero)
  print "addHeroMovePoints"
  
  local ADD_MOVE_POINTS = 50000;
  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints+ADD_MOVE_POINTS);
end;