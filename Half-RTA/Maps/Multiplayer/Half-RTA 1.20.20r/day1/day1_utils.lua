-- Файл, описывающий общие функции, которые используются в разных скриптах текущего модуля

-- Функция, не делающая ничего
function noop()
end;

-- Снимает все очки передвижения у переданного героя до 0
function removeHeroMovePoints(hero)
  print "removeHeroMovePoints"

  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- Добавляет очки передвижения у переданному герою
function addHeroMovePoints(hero)
  print "addHeroMovePoints"
  
  local ADD_MOVE_POINTS = 50000;
  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints+ADD_MOVE_POINTS);
end;