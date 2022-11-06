
PATH_TO_TRAINING_MODULES = PATH_TO_DAY4_SCRIPTS..'modules/';

PLAYERS_TRAINING_GARRISONS = {
  [PLAYER_1] = 'training_garrison_1',
  [PLAYER_2] = 'training_garrison_2',
};

tierUnitForTrainingTable = {1, 2, 3, 5};

PLAYERS_TRAINING_UNITS = {
  [PLAYER_1] = {
    [1] = 'training_peasant_1',
    [2] = 'training_archer_1',
    [3] = 'training_footman_1',
    [5] = 'training_priest_1',
  },
  [PLAYER_2] = {
    [1] = 'training_peasant_2',
    [2] = 'training_archer_2',
    [3] = 'training_footman_2',
    [5] = 'training_priest_2',
  },
};

PLAYERS_TRAINING_UNITS_POSITION = {
  [PLAYER_1] = {
    [1] = { x = 44, y = 81 },
    [2] = { x = 46, y = 81 },
    [3] = { x = 48, y = 81 },
    [5] = { x = 50, y = 81 },
  },
  [PLAYER_2] = {
    [1] = { x = 46, y = 12 },
    [2] = { x = 44, y = 12 },
    [3] = { x = 42, y = 12 },
    [5] = { x = 40, y = 12 },
  },
}

MAP_OPTION_COUNT_UNIT = {
  1,
  3,
  5,
  10,
  25,
};

MAP_TIER_TO_TRAINED_TIER = {
  [1] = 2,
  [2] = 3,
  [3] = 5,
  [5] = 6,
}

MAP_TIER_TO_UNIT_NAME = {
  [1] = { CREATURE_MILITIAMAN, CREATURE_LANDLORD },
  [2] = { CREATURE_LONGBOWMAN, CREATURE_MARKSMAN },
  [3] = { CREATURE_SWORDSMAN, CREATURE_VINDICATOR },
  [5] = { CREATURE_CLERIC, CREATURE_ZEALOT },
  [6] = { CREATURE_PALADIN, CREATURE_CHAMPION },
};

MAP_TIER_TO_TRAINING_POINTS = {
  [1] = 4,
  [2] = 5,
  [3] = 10,
  [5] = 25,
};

-- Очки тренинга игроков
PLAYERS_TRAINING_POINTS = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
}

-- Выбранный уровень существ для тренировки
PLAYERS_SELECTED_TIER = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
}

function calculatePlayerTrainingPoints(playerId)
  print "calculatePlayerTrainingPoints"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local trainingLevel = GetHeroSkillMastery(mainHeroName, SKILL_TRAINING);
  local POINTS_PER_TRAINING_LEVEL = 50;
  local POINTS_PER_EXPERT_TRAINING = 50;
  local INITIAL_TRAINING_POINTS = 100;
  
  local summaryPoints = INITIAL_TRAINING_POINTS + trainingLevel * POINTS_PER_TRAINING_LEVEL;
  
  if HasHeroSkill(mainHeroName, PERK_EXPERT_TRAINER) then
    summaryPoints = summaryPoints + POINTS_PER_EXPERT_TRAINING;
  end;

  PLAYERS_TRAINING_POINTS[playerId] = summaryPoints;

  ShowFlyingSign({PATH_TO_TRAINING_MODULES..'n_left_points.txt'; eq=PLAYERS_TRAINING_POINTS[playerId]}, mainHeroName, playerId, 5);
end;

-- Наблюдатель отслеживания взятия существ из гарнизона
function garrisonWatcherTread(playerId)
  print "garrisonWatcherTread"

  local garrisonName = PLAYERS_TRAINING_GARRISONS[playerId];
  
  SetObjectOwner(garrisonName, playerId);

  while GetDate(DAY) < 5 do
    for _, tierUnits in MAP_TIER_TO_UNIT_NAME do
      local countGrade1 = GetObjectCreatures(garrisonName, tierUnits[1]);
      local countGrade2 = GetObjectCreatures(garrisonName, tierUnits[2]);

      if countGrade1 ~= 0 or countGrade2 ~= 0 then
        if countGrade1 < countGrade2 then
          RemoveObjectCreatures(garrisonName, tierUnits[2], countGrade2 - countGrade1);
        elseif countGrade1 > countGrade2 then
          RemoveObjectCreatures(garrisonName, tierUnits[1], countGrade1 - countGrade2);
        end
      end
    end

    sleep();
  end
end;

-- Обработчик выбора опции тренинга
function handleSelectTrainingOption(playerId, optionNumber)
  print "handleSelectTrainingOption"

  local tierLvl = PLAYERS_SELECTED_TIER[playerId];

  if optionNumber == -1 then
    return nil;
  end;

  local countUnits = MAP_OPTION_COUNT_UNIT[optionNumber];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local needPoints = countUnits * MAP_TIER_TO_TRAINING_POINTS[tierLvl];
  local currentPoints = PLAYERS_TRAINING_POINTS[playerId];

  if needPoints > currentPoints then
    ShowFlyingSign(
      {GetMapDataPath()..'day4/modules/not_enough_point.txt'; eq1=needPoints, eq2=currentPoints},
      mainHeroName,
      playerId,
      5
    );

    return nil;
  end

  for _, creatureId in MAP_TIER_TO_UNIT_NAME[tierLvl] do
    if GetHeroCreatures(mainHeroName, creatureId) >= countUnits then
      local garrisonName = PLAYERS_TRAINING_GARRISONS[playerId];

      -- Добавляем оба грейда в гарнизон, чтобы игрок выбрал нужный
      for _, trainedCreatureId in MAP_TIER_TO_UNIT_NAME[MAP_TIER_TO_TRAINED_TIER[tierLvl]] do
        AddObjectCreatures(garrisonName, trainedCreatureId, countUnits);
      end;

      RemoveHeroCreatures(mainHeroName, creatureId, countUnits);

      local resultTrainingPoints = currentPoints - needPoints;

      PLAYERS_TRAINING_POINTS[playerId] = resultTrainingPoints

      ShowFlyingSign({GetMapDataPath()..'day4/modules/n_left_points.txt'; eq=resultTrainingPoints}, mainHeroName, playerId, 5);

      sleep(2);

      MakeHeroInteractWithObject(mainHeroName, garrisonName);

      return nil;
    end;
  end;
  
  ShowFlyingSign(
    GetMapDataPath()..'day4/modules/not_enough_unit.txt',
    mainHeroName,
    playerId,
    5
  );
end;

-- Обработчик касания существа, которое хотят тренировать
function handleTouchTrainingUnit(strPlayerId, strUnitTierLvl)
  print "handleTouchTrainingUnit"

  local playerId = strPlayerId + 0;
  local unitTierLvl = strUnitTierLvl + 0;

  local MAP_TIER_TO_ICON = {
    [1] = "/Textures/Interface/CombatArena/Faces/Heaven/ico_Militiaman_128.xdb#xpointer(/Texture)",
    [2] = "/Textures/Interface/CombatArena/Faces/Heaven/ico_Archer_128.xdb#xpointer(/Texture)",
    [3] = "/Textures/Interface/CombatArena/Faces/Heaven/ico_Footman_128.xdb#xpointer(/Texture)",
    [5] = "/Textures/Interface/CombatArena/Faces/Heaven/ico_Priest_128.xdb#xpointer(/Texture)",
  };
  
  PLAYERS_SELECTED_TIER[playerId] = unitTierLvl;

  TalkBoxForPlayers(
    playerId,
    MAP_TIER_TO_ICON[unitTierLvl],
    nil,
    GetMapDataPath()..'day4/modules/description.txt',
    nil,
    'handleSelectTrainingOption',
    1,
    GetMapDataPath()..'day4/modules/title.txt',
    GetMapDataPath()..'day4/modules/select_count_unit.txt',
    1,
    GetMapDataPath()..'day4/modules/option_1.txt',
    GetMapDataPath()..'day4/modules/option_3.txt',
    GetMapDataPath()..'day4/modules/option_5.txt',
    GetMapDataPath()..'day4/modules/option_10.txt',
    GetMapDataPath()..'day4/modules/option_25.txt'
  );
end

-- Новый скриптовый тренинг
function prepareForHavenTraining(playerId)
  print "prepareForHavenTraining"

  calculatePlayerTrainingPoints(playerId);

  for _, tierLvl in tierUnitForTrainingTable do
    local unitName = PLAYERS_TRAINING_UNITS[playerId][tierLvl];
    local unitPosition = PLAYERS_TRAINING_UNITS_POSITION[playerId][tierLvl];
    
    print(GetMapDataPath()..'day4/modules/unit_'.. tierLvl .."_tier_name.txt")
    print(GetMapDataPath()..'day4/modules/unit_'.. tierLvl .."_tier_desc.txt")

    SetObjectPosition(unitName, unitPosition.x, unitPosition.y);

    if playerId == PLAYER_2 then
      SetObjectRotation(unitName, 180);
    end;
    
    SetObjectEnabled(unitName, nil);

    OverrideObjectTooltipNameAndDescription(
      unitName,
      GetMapDataPath()..'day4/modules/unit_'.. tierLvl .."_tier_name.txt",
      GetMapDataPath()..'day4/modules/unit_'.. tierLvl .."_tier_desc.txt"
    );
    Trigger(OBJECT_TOUCH_TRIGGER, unitName, 'handleTouchTrainingUnit('..playerId..','..tierLvl..')');
  end;

  startThread(garrisonWatcherTread, playerId);
end;

for _, playerId in PLAYER_ID_TABLE do
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  if raceId == RACES.HAVEN then
    prepareForHavenTraining(playerId);
  end
end;

