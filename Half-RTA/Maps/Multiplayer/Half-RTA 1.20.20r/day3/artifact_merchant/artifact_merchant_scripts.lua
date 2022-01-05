PATH_TO_MERCHANT_MODULE = PATH_TO_DAY3_SCRIPTS.."artifact_merchant/";
PATH_TO_MERCHANT_MESSAGES = PATH_TO_MERCHANT_MODULE.."messages/";

-- Статус использования трофеев у обоих игроков
PLAYERS_USE_SPOILS_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- Соотношение лавок артефактов к игрокам
MAP_MERCHANT_ON_PLAYER = {
  [PLAYER_1] = 'lavka1',
  [PLAYER_2] = 'lavka2',
}

-- Триггеры на лавку артефактов
function artifact_merchant_scripts()
  print "artifact_merchant_scripts"

  for _, playerId in PLAYER_ID_TABLE do
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'handleTouchArtifactMerchant' );
  end;
end;

-- Обработчик касания героя с лавкой
function handleTouchArtifactMerchant(triggerHero)
  print "handleTouchArtifactMerchant"
  
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  -- Если ГГ еще нет - не реагируем
  if playerMainHeroProps.name == nil or PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return nil;
  end;
  
  -- Если у героя есть трофеи - работаем
  if HasHeroSkill(playerMainHeroProps.name, WIZARD_FEAT_SPOILS_OF_WAR) then
    QuestionBoxForPlayers(playerId, PATH_TO_MERCHANT_MESSAGES.."question_use_spoils.txt", 'spoilsOfWar', 'noop');
  end;
end;

-- Активация трофеев
function spoilsOfWar(strPlayerId)
  print "spoilsOfWar"
  
  local playerId = strPlayerId + 0;
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  -- Формируем список слотов, которые заняты у героя текущими артами
  -- Список занятых слотов
  local havingItemPositionList = {};
  
  for _, art in ALL_ARTS_LIST do
    if HasArtefact(playerMainHeroProps.name, art.id) then
      local slotIsNotAdded = not nil; -- Ору с этого, почему то адекватный true тут не существует :)
      
      for _, position in havingItemPositionList do
        if position == art.position then
          slotIsNotAdded = nil;
        end;
      end;
      
      if slotIsNotAdded then
        havingItemPositionList[length(havingItemPositionList)] = art.position;
      end;
    end;
  end;
  
  -- На основе списка занятых слотов формируем список артефактов мажорных артов в доступные слоты
  -- Список возможных для выдачи артефактов
  local allowedItemIdList = {};
  
  for _, art in ALL_ARTS_LIST do
    if art.level == ARTS_LEVELS.MAJOR then
      local isAllowedPosition = not nil;
      
      for _, position in havingItemPositionList do
        if art.position == position then
          isAllowedPosition = nil;
        end;
      end;
      
      if isAllowedPosition then
        allowedItemIdList[length(allowedItemIdList)] = art.id;
      end;
    end;
  end;
  
  -- Теперь рандомим из этой кучи выдаваемый арт
  local randomIndexArt = random(length(allowedItemIdList));
  
  GiveArtefact(playerMainHeroProps.name, allowedItemIdList[randomIndexArt]);
  
  -- И запрещаем игроку больше использовать трофеи
  PLAYERS_USE_SPOILS_STATUS[playerId] = not nil;
end;

artifact_merchant_scripts();