-- ‘айл, описывающий общие функции, использующиес€ во всем приложении

-- —нимает все очки передвижени€ у переданного геро€ до 0
function removeHeroMovePoints(hero)
  print "removeHeroMovePoints"

  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- ƒобавл€ет очки передвижени€ у переданному герою
function addHeroMovePoints(hero)
  print "addHeroMovePoints"
  
  removeHeroMovePoints(hero);

  local ADD_MOVE_POINTS = 30000;

  ChangeHeroStat(hero, STAT_MOVE_POINTS, ADD_MOVE_POINTS);
end;

-- ѕолучение словарного названи€ геро€ по его зарезервированному названию
function getDictionaryHeroName(heroName)
  print "getDictionaryHeroName"
  
  for indexHero = 1, length(MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME) do
    local heroReservedNamesTable = MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME[indexHero];
    
    for indexName = 1, length(heroReservedNamesTable.reservedNames) do
      local heroReverveName = heroReservedNamesTable.reservedNames[indexName];
      
      if heroReverveName == heroName then
        return heroReservedNamesTable.dictName;
      end;
    end;
  end;
end;

-- ѕолучение словарного названи€ геро€ по его зарезервированному названию
function getReservedHeroName(playerId, dictHeroName)
  print "getReservedHeroName"

  for indexHero = 1, length(MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME) do
    local heroReservedNamesTable = MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME[indexHero];
    
    if heroReservedNamesTable.dictName == dictHeroName then
      return heroReservedNamesTable.reservedNames[playerId];
    end;
  end;
end;

-- ”ниверсальный перенос артефактов между геро€ми
function transferAllArts(sourceHero, targetHero)
  print "transferAllArts"

  for _, artData in ALL_ARTS_LIST do
    if HasArtefact(sourceHero, artData.id) then
      GiveArtefact(targetHero, artData.id);
      RemoveArtefact(sourceHero, artData.id);
    end;
  end;
end;
