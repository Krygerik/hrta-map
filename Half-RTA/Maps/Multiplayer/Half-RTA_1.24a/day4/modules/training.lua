
PATH_TO_TRAINING_MODULES = PATH_TO_DAY4_SCRIPTS..'modules/';

PLAYERS_TRAINING_GARRISONS = {
  [PLAYER_1] = 'training_garrison_1',
  [PLAYER_2] = 'training_garrison_2',
};

tierUnitForTrainingTable = {1, 2, 3, 5};

PLAYERS_TO_POSITION = {
  [PLAYER_1] = { x = 88, y = 73 },
  [PLAYER_2] = { x = 81, y = 25 },
}

PLAYERS_TRAINING_UNITS = {
  [PLAYER_1] = {
    [1] = 'training_peasant_1_',
    [2] = 'training_archer_1_',
    [3] = 'training_footman_1_',
    [5] = 'training_priest_1_',
  },
  [PLAYER_2] = {
    [1] = 'training_peasant_2_',
    [2] = 'training_archer_2_',
    [3] = 'training_footman_2_',
    [5] = 'training_priest_2_',
  },
};

MAP_OPTION_COUNT_UNIT = {
  1,
  3,
  5,
  10,
  25,
};

-- Соотношение уровня существа к уровню получаемого
MAP_TIER_TO_TRAINED_TIER = {
  [1] = 2,
  [2] = 3,
  [3] = 5,
  [5] = 6,
}

-- Соотношение уровня к существам
MAP_TIER_TO_UNIT_NAME = {
  [1] = { CREATURE_PEASANT, CREATURE_LANDLORD },
  [2] = { CREATURE_ARCHER, CREATURE_LONGBOWMAN },
  [3] = { CREATURE_FOOTMAN, CREATURE_VINDICATOR },
  [5] = { CREATURE_PRIEST, CREATURE_ZEALOT },
  [6] = { CREATURE_CAVALIER, CREATURE_CHAMPION },
};

MAP_TIER_TO_TRAINING_POINTS = {
  [1] = 5,
  [2] = 6,
  [3] = 15,
  [5] = 30,
};

-- Очки тренинга игроков
PLAYERS_TRAINING_POINTS = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
}

function calculatePlayerTrainingPoints(playerId)
  print "calculatePlayerTrainingPoints"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  local trainingLevel = GetHeroSkillMastery(mainHeroName, SKILL_TRAINING);
  local POINTS_PER_TRAINING_LEVEL = 60;
  local POINTS_PER_EXPERT_TRAINING = 120;
  local POINTS_FOR_RUTGER = 120;
  local INITIAL_TRAINING_POINTS = 0;

  local summaryPoints = INITIAL_TRAINING_POINTS + trainingLevel * POINTS_PER_TRAINING_LEVEL;

  if dictHeroName == HEROES.BREM then
    summaryPoints = summaryPoints + POINTS_FOR_RUTGER;
  end;
  
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
function handleSelectTrainingOption(strPlayerId, strTier, strCountUnits)
  print "handleSelectTrainingOption"

  local playerId = strPlayerId + 0;
  local countUnits = strCountUnits + 0;
  local tierLvl = strTier + 0;

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local needPoints = countUnits * MAP_TIER_TO_TRAINING_POINTS[tierLvl];
  local currentPoints = PLAYERS_TRAINING_POINTS[playerId];

  if needPoints > currentPoints then
    ShowFlyingSign(
      {GetMapDataPath()..'day4/modules/not_enough_point.txt'; eq1=needPoints, eq2=currentPoints},
      mainHeroName,
      playerId,
      7
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

-- Вопрос, чтобы избежать случайного клика
function questionSelectTrainingOption(playerId, levelUnit, countUnits)
  print "questionSelectTrainingOption"

  QuestionBoxForPlayers(
    playerId,
    GetMapDataPath()..'day4/modules/question_select_option.txt',
    'handleSelectTrainingOption('..playerId..', '..levelUnit..', '..countUnits..')',
    'noop'
  );
end;

-- Новый скриптовый тренинг
function prepareForHavenTraining(playerId)
  print "prepareForHavenTraining"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  SetObjectPosition(mainHeroName, PLAYERS_TO_POSITION[playerId].x, PLAYERS_TO_POSITION[playerId].y);

  local rotate = playerId == PLAYER_1 and 0 or 3.14;
  MoveCameraForPlayers(playerId, PLAYERS_TO_POSITION[playerId].x, PLAYERS_TO_POSITION[playerId].y, GROUND, 50, rotate, 0, 0, 0, 1);

  calculatePlayerTrainingPoints(playerId);

  for _, tierLvl in tierUnitForTrainingTable do
    local halfUnitName = PLAYERS_TRAINING_UNITS[playerId][tierLvl];

    for _, count in MAP_OPTION_COUNT_UNIT do
      local unitName = halfUnitName..count;

      SetObjectEnabled(unitName, nil);

      OverrideObjectTooltipNameAndDescription(
        unitName,
        GetMapDataPath()..'day4/modules/unit_'.. count .."_tier_name.txt",
        GetMapDataPath()..'day4/modules/unit_'.. tierLvl .."_tier_desc.txt"
      );
      Trigger(OBJECT_TOUCH_TRIGGER, unitName, 'questionSelectTrainingOption('..playerId..','..tierLvl..','..count..')');
    end;
  end;

  startThread(garrisonWatcherTread, playerId);
end;

for _, playerId in PLAYER_ID_TABLE do
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  if raceId == RACES.HAVEN then
    prepareForHavenTraining(playerId);
  end
end;

