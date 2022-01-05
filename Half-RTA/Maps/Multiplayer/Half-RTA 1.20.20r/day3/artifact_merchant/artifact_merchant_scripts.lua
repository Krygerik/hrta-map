PATH_TO_MERCHANT_MODULE = PATH_TO_DAY3_SCRIPTS.."artifact_merchant/";
PATH_TO_MERCHANT_MESSAGES = PATH_TO_MERCHANT_MODULE.."messages/";

-- ������ ������������� ������� � ����� �������
PLAYERS_USE_SPOILS_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ����������� ����� ���������� � �������
MAP_MERCHANT_ON_PLAYER = {
  [PLAYER_1] = 'lavka1',
  [PLAYER_2] = 'lavka2',
}

-- �������� �� ����� ����������
function artifact_merchant_scripts()
  print "artifact_merchant_scripts"

  for _, playerId in PLAYER_ID_TABLE do
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'handleTouchArtifactMerchant' );
  end;
end;

-- ���������� ������� ����� � ������
function handleTouchArtifactMerchant(triggerHero)
  print "handleTouchArtifactMerchant"
  
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  -- ���� �� ��� ��� - �� ���������
  if playerMainHeroProps.name == nil or PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return nil;
  end;
  
  -- ���� � ����� ���� ������ - ��������
  if HasHeroSkill(playerMainHeroProps.name, WIZARD_FEAT_SPOILS_OF_WAR) then
    QuestionBoxForPlayers(playerId, PATH_TO_MERCHANT_MESSAGES.."question_use_spoils.txt", 'spoilsOfWar', 'noop');
  end;
end;

-- ��������� �������
function spoilsOfWar(strPlayerId)
  print "spoilsOfWar"
  
  local playerId = strPlayerId + 0;
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  -- ��������� ������ ������, ������� ������ � ����� �������� ������
  -- ������ ������� ������
  local havingItemPositionList = {};
  
  for _, art in ALL_ARTS_LIST do
    if HasArtefact(playerMainHeroProps.name, art.id) then
      local slotIsNotAdded = not nil; -- ��� � �����, ������ �� ���������� true ��� �� ���������� :)
      
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
  
  -- �� ������ ������ ������� ������ ��������� ������ ���������� �������� ����� � ��������� �����
  -- ������ ��������� ��� ������ ����������
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
  
  -- ������ �������� �� ���� ���� ���������� ���
  local randomIndexArt = random(length(allowedItemIdList));
  
  GiveArtefact(playerMainHeroProps.name, allowedItemIdList[randomIndexArt]);
  
  -- � ��������� ������ ������ ������������ ������
  PLAYERS_USE_SPOILS_STATUS[playerId] = not nil;
end;

artifact_merchant_scripts();