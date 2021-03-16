-- Файл, описывающий общие функции, использующиеся во всем приложении

-- Снимает все очки передвижения у переданного героя до 0
function removeHeroMovePoints(hero)
  print "removeHeroMovePoints"

  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- Добавляет очки передвижения у переданному герою
function addHeroMovePoints(hero)
  print "addHeroMovePoints"
  
  removeHeroMovePoints(hero);

  local ADD_MOVE_POINTS = 30000;

  ChangeHeroStat(hero, STAT_MOVE_POINTS, ADD_MOVE_POINTS);
end;
