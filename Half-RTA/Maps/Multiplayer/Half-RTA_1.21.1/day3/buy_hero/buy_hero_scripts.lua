
PATH_TO_BUY_HERO_MODULE = PATH_TO_DAY3_SCRIPTS.."buy_hero/";
PATH_TO_BUY_HERO_MESSAGES = PATH_TO_BUY_HERO_MODULE.."messages/";

-- ��������� ������� �����
BUY_HERO_COST = 5000;

-- ����������� �� �������� ��� ������� ��� ������ � �������
MAP_BUY_HERO_OBJECT_ON_PLAYER = {
  [PLAYER_1] = 'taverna1',
  [PLAYER_2] = 'taverna2',
};

-- ����������� ������� �� ��������� ������� ��������������� �����
MAP_PLAYER_ON_BUY_HERO_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ���������� ������� ��������������� ����� �� �������
function buy_hero_scripts()
  print "buy_hero_scripts"
  
  for _, playerId in PLAYER_ID_TABLE do
    SetObjectEnabled(MAP_BUY_HERO_OBJECT_ON_PLAYER[playerId], nil);
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_BUY_HERO_OBJECT_ON_PLAYER[playerId], 'handleTouchBuyHeroObject');
  end;
end;

-- ��������� ������� � �������� ��� ������� �����
function handleTouchBuyHeroObject(triggerHero)
  print "handleTouchBuyHeroObject"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  
  -- ����� ��� ����������
  if MAP_PLAYER_ON_BUY_HERO_STATUS[playerId] ~= nil then
    MessageBoxForPlayers(playerId, PATH_TO_BUY_HERO_MESSAGES.."hero_already_buy.txt");

    return nil;
  end;

  -- ���� � ������ �� ������� �����
  if GetPlayerResource(playerId, GOLD) < BUY_HERO_COST then
    MessageBoxForPlayers(playerId, { PATH_TO_BUY_HERO_MESSAGES.."not_enough_n_gold.txt"; eq = BUY_HERO_COST });
    
    return nil;
  end;

  QuestionBoxForPlayers(playerId, {PATH_TO_BUY_HERO_MESSAGES.."question_buy_hero.txt"; eq = BUY_HERO_COST}, 'buyHero("'..playerId..'")', 'noop');
end;

-- ������� ��������������� �����
function buyHero(strPlayerId)
  print "buyHero"
  
  local playerId = strPlayerId + 0;
  local heroFromTavern = RESULT_HERO_LIST[playerId].heroes[3];
  
  local reservedHeroName = getReservedHeroName(playerId, heroFromTavern);
  
  addHeroMovePoints(reservedHeroName);
  MAP_PLAYER_ON_BUY_HERO_STATUS[playerId] = not nil;
  
  SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) - BUY_HERO_COST);
end;

buy_hero_scripts();