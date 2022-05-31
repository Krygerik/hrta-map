-- Не запускаем скрипты, если в бою
consoleCmd('@nde = 1')

sleep(10)
if nde == 1 then
	return
end

-- Увеличиваем размер строк вывода в консоль
-- Запрещаем писать в файл
consoleCmd('console_size 999')
consoleCmd('game_writelog 0')
sleep(1)

doFile(GetMapDataPath()..'common.lua');
doFile(GetMapDataPath()..'utils.lua');
doFile(GetMapDataPath()..'constants.lua');
sleep(1)

removeHeroMovePoints(Biara);
removeHeroMovePoints(Djovanni);

heroes1 = GetPlayerHeroes (PLAYER_1)
heroes2 = GetPlayerHeroes (PLAYER_2)

-- Обработчик наступления нового дня
function handleNewDay()
  if GetDate(DAY) == 2 then
    doFile(GetMapDataPath().."day2/day2_scripts.lua");
  end;

  if GetDate(DAY) == 3 then
    doFile(GetMapDataPath().."day3/day3_scripts.lua");
  end;
  
  if GetDate(DAY) == 4 then
    doFile(GetMapDataPath().."day4/day4_scripts.lua");
  end;
end;

-- Корневые триггеры
Trigger (NEW_DAY_TRIGGER, 'handleNewDay');

doFile(GetMapDataPath().."day1/day1_scripts.lua");

-- Комментируем всю старую дичь
function mainMock()

function InitCombatExecThread(hero)
	StartCombat(hero, nil, 1, 1, 1, '/scripts/RTA_TestExecutionThread.(Script).xdb#xpointer(/Script)')
	local t = {}
	for i=1,6 do
		t[i] = random(16777216)
	end
	consoleCmd([[@SetGameVar('combat_prng_seed', 'return {]] .. concat(t, ',') .. [[}')]])
end

function SaveHeroesInfoBeforeCombat(heroes)
	local t = {[[@SetGameVar('heroes_info', 'return {]]}
	for i, hero in heroes do
		append(t, '["' .. hero .. '"]={')

		-- уровень --
		append(t, 'level=' .. GetHeroLevel(hero) .. ',')
		
		-- удача --
		append(t, 'luck=' .. GetHeroStat(hero, STAT_LUCK) .. ',')
		
		-- артефакты --
		append(t, 'ArtSet={')
    for artset = 0, 9 do
      local artsetlevel = GetArtifactSetItemsCount(hero, artset, 1)
      if artsetlevel > 0 then
        append(t, '[' .. artset .. ']=' .. artsetlevel .. ',')
      end
    end
    append(t, '},')

		-- навыки и умения --
		append(t, 'skills={')
		for skill = 1, 220 do
			local mastery = GetHeroSkillMastery(hero, skill)
			if mastery > 0 then
				append(t, '[' .. skill .. ']=' .. mastery .. ',')
			end
		end
		append(t, '},')
		


		append(t, '},')
	end
	append(t, [[}')]])
	consoleCmd(concat(t))
end

------------------ SPELLS --------------------------

array_spells={}
array_spells[0] = {
   { ["name"] = "spell_1_1_1",  ["name2"] = "spell_1_1_2",  ["name3"] = "spell_1_1_3",  ["name4"] = "spell_1_1_4", ["text"] = "spell_1_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 23  },                      -- божественная сила

   { ["name"] = "spell_1_6_1",  ["name2"] = "spell_1_6_2",  ["name3"] = "spell_1_6_3",  ["name4"] = "spell_1_6_4", ["text"] = "spell_1_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 29  },                      -- уклонение

   { ["name"] = "spell_1_3_1",  ["name2"] = "spell_1_3_2",  ["name3"] = "spell_1_3_3",  ["name4"] = "spell_1_3_4", ["text"] = "spell_1_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 25  },                      -- каменная кожа

   { ["name"] = "spell_1_2_1",  ["name2"] = "spell_1_2_2",  ["name3"] = "spell_1_2_3",  ["name4"] = "spell_1_2_4", ["text"] = "spell_1_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 24  },                      -- ускорение

   { ["name"] = "spell_1_7_1",  ["name2"] = "spell_1_7_2",  ["name3"] = "spell_1_7_3",  ["name4"] = "spell_1_7_4", ["text"] = "spell_1_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 28  },                      -- карающий удар

   { ["name"] = "spell_1_5_1",  ["name2"] = "spell_1_5_2",  ["name3"] = "spell_1_5_3",  ["name4"] = "spell_1_5_4", ["text"] = "spell_1_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 26  },                      -- снятие чар

   { ["name"] = "spell_1_4_1",  ["name2"] = "spell_1_4_2",  ["name3"] = "spell_1_4_3",  ["name4"] = "spell_1_4_4", ["text"] = "spell_1_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 280 },                      -- регенерация

   { ["name"] = "spell_1_8_1",  ["name2"] = "spell_1_8_2",  ["name3"] = "spell_1_8_3",  ["name4"] = "spell_1_8_4", ["text"] = "spell_1_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 32  },                      -- телепорт

   { ["name"] = "spell_1_9_1",  ["name2"] = "spell_1_9_2",  ["name3"] = "spell_1_9_3",  ["name4"] = "spell_1_9_4", ["text"] = "spell_1_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 31  },                      -- антимагия

   { ["name"] = "spell_1_10_1", ["name2"] = "spell_1_10_2", ["name3"] = "spell_1_10_3", ["name4"] = "spell_1_10_4", ["text"] = "spell_1_10.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 281 },                      -- божественная месть

   { ["name"] = "spell_1_11_1", ["name2"] = "spell_1_11_2", ["name3"] = "spell_1_11_3", ["name4"] = "spell_1_11_4", ["text"] = "spell_1_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 48  },                      -- воскрешение

   { ["name"] = "spell_1_12_1", ["name2"] = "spell_1_12_2", ["name3"] = "spell_1_12_3", ["name4"] = "spell_1_12_4", ["text"] = "spell_1_12.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 35  }                       -- святое слово
};

array_spells[1] = {
   { ["name"] = "spell_2_2_1",  ["name2"] = "spell_2_2_2",  ["name3"] = "spell_2_2_3",  ["name4"] = "spell_2_2_4", ["text"] = "spell_2_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 11  },                      -- ослабление

   { ["name"] = "spell_2_3_1",  ["name2"] = "spell_2_3_2",  ["name3"] = "spell_2_3_3",  ["name4"] = "spell_2_3_4", ["text"] = "spell_2_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 12  },                      -- замедление

   { ["name"] = "spell_2_7_1",  ["name2"] = "spell_2_7_2",  ["name3"] = "spell_2_7_3",  ["name4"] = "spell_2_7_4", ["text"] = "spell_2_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 15  },                      -- немощность

   { ["name"] = "spell_2_4_1",  ["name2"] = "spell_2_4_2",  ["name3"] = "spell_2_4_3",  ["name4"] = "spell_2_4_4", ["text"] = "spell_2_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 13  },                      -- разрушающий луч

   { ["name"] = "spell_2_6_1",  ["name2"] = "spell_2_6_2",  ["name3"] = "spell_2_6_3",  ["name4"] = "spell_2_6_4", ["text"] = "spell_2_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 17  },                      -- рассеяность

   { ["name"] = "spell_2_5_1",  ["name2"] = "spell_2_5_2",  ["name3"] = "spell_2_5_3",  ["name4"] = "spell_2_5_4", ["text"] = "spell_2_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 14  },                      -- чума

   { ["name"] = "spell_2_1_1",  ["name2"] = "spell_2_1_2",  ["name3"] = "spell_2_1_3",  ["name4"] = "spell_2_1_4", ["text"] = "spell_2_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 277 },                      -- скорбь

   { ["name"] = "spell_2_8_1",  ["name2"] = "spell_2_8_2",  ["name3"] = "spell_2_8_3",  ["name4"] = "spell_2_8_4", ["text"] = "spell_2_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 19  },                      -- ослепление

   { ["name"] = "spell_2_10_1", ["name2"] = "spell_2_10_2", ["name3"] = "spell_2_10_3", ["name4"] = "spell_2_10_4", ["text"] = "spell_2_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 278 },                      -- вампиризм

   { ["name"] = "spell_2_9_1",  ["name2"] = "spell_2_9_2",  ["name3"] = "spell_2_9_3",  ["name4"] = "spell_2_9_4", ["text"] = "spell_2_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 18  },                      -- берсерк

   { ["name"] = "spell_2_11_1", ["name2"] = "spell_2_11_2", ["name3"] = "spell_2_11_3", ["name4"] = "spell_2_11_4", ["text"] = "spell_2_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 20  },                      -- подчинение

   { ["name"] = "spell_2_12_1", ["name2"] = "spell_2_12_2", ["name3"] = "spell_2_12_3", ["name4"] = "spell_2_12_4", ["text"] = "spell_2_12.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 21  }                       -- нечестивое слово
};

array_spells[2] = {
   { ["name"] = "spell_3_1_1",  ["name2"] = "spell_3_1_2",  ["name3"] = "spell_3_1_3",  ["name4"] = "spell_3_1_4", ["text"] = "spell_3_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 237 },                      -- каменные шипы

   { ["name"] = "spell_3_2_1",  ["name2"] = "spell_3_2_2",  ["name3"] = "spell_3_2_3",  ["name4"] = "spell_3_2_4", ["text"] = "spell_3_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 1   },                      -- магическая стрела

   { ["name"] = "spell_3_3_1",  ["name2"] = "spell_3_3_2",  ["name3"] = "spell_3_3_3",  ["name4"] = "spell_3_3_4", ["text"] = "spell_3_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 4   },                      -- ледяная глыба

   { ["name"] = "spell_3_4_1",  ["name2"] = "spell_3_4_2",  ["name3"] = "spell_3_4_3",  ["name4"] = "spell_3_4_4", ["text"] = "spell_3_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 3   },                      -- молния

   { ["name"] = "spell_3_5_1",  ["name2"] = "spell_3_5_2",  ["name3"] = "spell_3_5_3",  ["name4"] = "spell_3_5_4", ["text"] = "spell_3_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 6   },                      -- кольцо холода

   { ["name"] = "spell_3_7_1",  ["name2"] = "spell_3_7_2",  ["name3"] = "spell_3_7_3",  ["name4"] = "spell_3_7_4", ["text"] = "spell_3_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 5   },                      -- огненный шар

   { ["name"] = "spell_3_6_1",  ["name2"] = "spell_3_6_2",  ["name3"] = "spell_3_6_3",  ["name4"] = "spell_3_6_4", ["text"] = "spell_3_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 236 },                      -- стена огня

   { ["name"] = "spell_3_8_1",  ["name2"] = "spell_3_8_2",  ["name3"] = "spell_3_8_3",  ["name4"] = "spell_3_8_4", ["text"] = "spell_3_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 7   },                      -- цепь молний

   { ["name"] = "spell_3_9_1",  ["name2"] = "spell_3_9_2",  ["name3"] = "spell_3_9_3",  ["name4"] = "spell_3_9_4", ["text"] = "spell_3_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 8   },                      -- метеоритный дождь

   { ["name"] = "spell_3_10_1", ["name2"] = "spell_3_10_2", ["name3"] = "spell_3_10_3", ["name4"] = "spell_3_10_4", ["text"] = "spell_3_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 279 },                      -- останавливающий холод

   { ["name"] = "spell_3_11_1", ["name2"] = "spell_3_11_2", ["name3"] = "spell_3_11_3", ["name4"] = "spell_3_11_4", ["text"] = "spell_3_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 9   },                      -- шок земли

   { ["name"] = "spell_3_12_1", ["name2"] = "spell_3_12_2", ["name3"] = "spell_3_12_3", ["name4"] = "spell_3_12_4", ["text"] = "spell_3_12.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 10  }                       -- армагеддон
};

array_spells[3] = {
   { ["name"] = "spell_4_1_1",  ["name2"] = "spell_4_1_2",  ["name3"] = "spell_4_1_3",  ["name4"] = "spell_4_1_4", ["text"] = "spell_4_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 2   },                      -- волшебный кулак

   { ["name"] = "spell_4_2_1",  ["name2"] = "spell_4_2_2",  ["name3"] = "spell_4_2_3",  ["name4"] = "spell_4_2_4", ["text"] = "spell_4_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 38  },                      -- огненная ловушка

   { ["name"] = "spell_4_3_1",  ["name2"] = "spell_4_3_2",  ["name3"] = "spell_4_3_3",  ["name4"] = "spell_4_3_4", ["text"] = "spell_4_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 39  },                      -- призыв осиного роя

   { ["name"] = "spell_4_5_1",  ["name2"] = "spell_4_5_2",  ["name3"] = "spell_4_5_3",  ["name4"] = "spell_4_5_4", ["text"] = "spell_4_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 282 },                      -- кристалл тайного

   { ["name"] = "spell_4_7_1",  ["name2"] = "spell_4_7_2",  ["name3"] = "spell_4_7_3",  ["name4"] = "spell_4_7_4", ["text"] = "spell_4_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 284 },                      -- стена мечей

   { ["name"] = "spell_4_4_1",  ["name2"] = "spell_4_4_2",  ["name3"] = "spell_4_4_3",  ["name4"] = "spell_4_4_4", ["text"] = "spell_4_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 42  },                      -- поднятие мертвых

   { ["name"] = "spell_4_6_1",  ["name2"] = "spell_4_6_2",  ["name3"] = "spell_4_6_3",  ["name4"] = "spell_4_6_4", ["text"] = "spell_4_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 40  },                      -- создание фантома

   { ["name"] = "spell_4_8_1",  ["name2"] = "spell_4_8_2",  ["name3"] = "spell_4_8_3",  ["name4"] = "spell_4_8_4", ["text"] = "spell_4_8.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 41  },                      -- землетрясение

   { ["name"] = "spell_4_9_1",  ["name2"] = "spell_4_9_2",  ["name3"] = "spell_4_9_3",  ["name4"] = "spell_4_9_4", ["text"] = "spell_4_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 43  },                      -- призыв элементалей

   { ["name"] = "spell_4_10_1", ["name2"] = "spell_4_10_2", ["name3"] = "spell_4_10_3", ["name4"] = "spell_4_10_4", ["text"] = "spell_4_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 283 },                      -- призыв улья

   { ["name"] = "spell_4_11_1", ["name2"] = "spell_4_11_2", ["name3"] = "spell_4_11_3", ["name4"] = "spell_4_11_4", ["text"] = "spell_4_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 235 },                      -- призыв феникса

   { ["name"] = "spell_4_12_1", ["name2"] = "spell_4_12_2", ["name3"] = "spell_4_12_3", ["name4"] = "spell_4_12_4", ["text"] = "spell_4_12.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 34  }                       -- небесный щит
};

array_spells[4] = {
   { ["name"] = "spell_5_1_1",  ["name2"] = "spell_5_1_2",  ["name3"] = "spell_5_1_3",  ["name4"] = "spell_5_1_4", ["text"] = "spell_5_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 249 },                      -- руна энергии

   { ["name"] = "spell_5_5_1",  ["name2"] = "spell_5_5_2",  ["name3"] = "spell_5_5_3",  ["name4"] = "spell_5_5_4", ["text"] = "spell_5_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 253 },                      -- руна стихийной невосприимчивости

   { ["name"] = "spell_5_3_1",  ["name2"] = "spell_5_3_2",  ["name3"] = "spell_5_3_3",  ["name4"] = "spell_5_3_4", ["text"] = "spell_5_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 251 },                      -- руна магического надзора

   { ["name"] = "spell_5_4_1",  ["name2"] = "spell_5_4_2",  ["name3"] = "spell_5_4_3",  ["name4"] = "spell_5_4_4", ["text"] = "spell_5_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 252 },                      -- руна экзорзизма

   { ["name"] = "spell_5_6_1",  ["name2"] = "spell_5_6_2",  ["name3"] = "spell_5_6_3",  ["name4"] = "spell_5_6_4", ["text"] = "spell_5_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 256 },                      -- руна неосязаемости

   { ["name"] = "spell_5_7_1",  ["name2"] = "spell_5_7_2",  ["name3"] = "spell_5_7_3",  ["name4"] = "spell_5_7_4", ["text"] = "spell_5_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 254 },                      -- руна громового раската

   { ["name"] = "spell_5_2_1",  ["name2"] = "spell_5_2_2",  ["name3"] = "spell_5_2_3",  ["name4"] = "spell_5_2_4", ["text"] = "spell_5_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 250 },                      -- руна берсеркерства

   { ["name"] = "spell_5_8_1",  ["name2"] = "spell_5_8_2",  ["name3"] = "spell_5_8_3",  ["name4"] = "spell_5_8_4", ["text"] = "spell_5_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 257 },                      -- руна воскрешения

   { ["name"] = "spell_5_9_1",  ["name2"] = "spell_5_9_2",  ["name3"] = "spell_5_9_3",  ["name4"] = "spell_5_9_4", ["text"] = "spell_5_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 258 },                      -- руна драконьего обличья

   { ["name"] = "spell_5_10_1", ["name2"] = "spell_5_10_2", ["name3"] = "spell_5_10_3", ["name4"] = "spell_5_10_4", ["text"] = "spell_5_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 255 },                      -- руна боевой ярости
};

array_spells[5] = {
   { ["name"] = "spell_6_1_1",  ["name2"] = "spell_6_1_2",  ["name3"] = "spell_6_1_3",  ["name4"] = "spell_6_1_4", ["text"] = "spell_6_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 290},                       -- объединяющий клич

   { ["name"] = "spell_6_2_1",  ["name2"] = "spell_6_2_2",  ["name3"] = "spell_6_2_3",  ["name4"] = "spell_6_2_4", ["text"] = "spell_6_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 291},                       -- зов крови

   { ["name"] = "spell_6_3_1",  ["name2"] = "spell_6_3_2",  ["name3"] = "spell_6_3_3",  ["name4"] = "spell_6_3_4", ["text"] = "spell_6_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 292},                       -- слово вождя

   { ["name"] = "spell_6_4_1",  ["name2"] = "spell_6_4_2",  ["name3"] = "spell_6_4_3",  ["name4"] = "spell_6_4_4", ["text"] = "spell_6_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 293},                       -- устрашающий рык

   { ["name"] = "spell_6_5_1",  ["name2"] = "spell_6_5_2",  ["name3"] = "spell_6_5_3",  ["name4"] = "spell_6_5_4", ["text"] = "spell_6_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 294},                       -- боевой клич

   { ["name"] = "spell_6_6_1",  ["name2"] = "spell_6_6_2",  ["name3"] = "spell_6_6_3",  ["name4"] = "spell_6_6_4", ["text"] = "spell_6_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 295},                       -- ярость орды
};

------------------ HEROES ------------------------

dublikat_heroes = {}
dublikat_heroes[0] = {

	 { ["name"] = "Orrin",           ["name2"] = "Orrin2",          ["name3"] = "Orrin3",          ["name4"] = "Orrin4",          },
	 { ["name"] = "Sarge",           ["name2"] = "Sarge2",          ["name3"] = "Sarge3",          ["name4"] = "Sarge4",          },
	 { ["name"] = "Mardigo",         ["name2"] = "Mardigo2",        ["name3"] = "Mardigo3",        ["name4"] = "Mardigo4",        },
	 { ["name"] = "Brem",            ["name2"] = "Brem2",           ["name3"] = "Brem7",           ["name4"] = "Brem8",           },
	 { ["name"] = "Brem3",           ["name2"] = "Brem4",           ["name3"] = "Brem5",           ["name4"] = "Brem6",           },
	 { ["name"] = "Maeve",           ["name2"] = "Maeve2",          ["name3"] = "Maeve3",          ["name4"] = "Maeve4",          },
	 { ["name"] = "Ving",            ["name2"] = "Ving2",           ["name3"] = "Ving3",           ["name4"] = "Ving4",           },
	 { ["name"] = "Nathaniel",       ["name2"] = "Nathaniel2",      ["name3"] = "Nathaniel3",      ["name4"] = "Nathaniel4",      },
	 { ["name"] = "Christian",       ["name2"] = "Christian2",      ["name3"] = "Christian3",      ["name4"] = "Christian4",      },
	 { ["name"] = "Godric",          ["name2"] = "Godric2",         ["name3"] = "Godric3",         ["name4"] = "Godric4",         },
   { ["name"] = "RedHeavenHero03", ["name2"] = "RedHeavenHero032",["name3"] = "RedHeavenHero037",["name4"] = "RedHeavenHero038",},
   { ["name"] = "RedHeavenHero033",["name2"] = "RedHeavenHero034",["name3"] = "RedHeavenHero035",["name4"] = "RedHeavenHero036",},
	 { ["name"] = "Isabell_A1",      ["name2"] = "Isabell_A12",     ["name3"] = "Isabell_A17",     ["name4"] = "Isabell_A18",     },
	 { ["name"] = "Isabell_A13",     ["name2"] = "Isabell_A14",     ["name3"] = "Isabell_A15",     ["name4"] = "Isabell_A16",     },
	 { ["name"] = "Duncan",          ["name2"] = "Duncan2",         ["name3"] = "Duncan3",         ["name4"] = "Duncan4",         },
   { ["name"] = "Nicolai",         ["name2"] = "Nicolai2",        ["name3"] = "Nicolai3",        ["name4"] = "Nicolai4",        }
};

dublikat_heroes[1] = {
	 { ["name"] = "Grok",        ["name2"] = "Grok2",        ["name3"] = "Grok3",        ["name4"] = "Grok4",        },
	 { ["name"] = "Oddrema",     ["name2"] = "Oddrema2",     ["name3"] = "Oddrema3",     ["name4"] = "Oddrema4",     },
	 { ["name"] = "Marder",      ["name2"] = "Marder2",      ["name3"] = "Marder3",      ["name4"] = "Marder4",      },
	 { ["name"] = "Jazaz",       ["name2"] = "Jazaz2",       ["name3"] = "Jazaz3",       ["name4"] = "Jazaz4",       },
	 { ["name"] = "Efion",       ["name2"] = "Efion2",       ["name3"] = "Efion3",       ["name4"] = "Efion4",       },
	 { ["name"] = "Deleb",       ["name2"] = "Deleb2",       ["name3"] = "Deleb3",       ["name4"] = "Deleb4",       },
	 { ["name"] = "Calid",       ["name2"] = "Calid2",       ["name3"] = "Calid3",       ["name4"] = "Calid4",       },
	 { ["name"] = "Nymus",       ["name2"] = "Nymus2",       ["name3"] = "Nymus3",       ["name4"] = "Nymus4",       },
	 { ["name"] = "Orlando",     ["name2"] = "Orlando2",     ["name3"] = "Orlando3",     ["name4"] = "Orlando4",     },
	 { ["name"] = "Agrael",      ["name2"] = "Agrael2",      ["name3"] = "Agrael3",      ["name4"] = "Agrael4",      },
	 { ["name"] = "Kha-Beleth",  ["name2"] = "Kha-Beleth2",  ["name3"] = "Kha-Beleth3",  ["name4"] = "Kha-Beleth4",  }
};

dublikat_heroes[2] = {
	 { ["name"] = "Nemor",       ["name2"] = "Nemor2",       ["name3"] = "Nemor3",       ["name4"] = "Nemor4",       },
	 { ["name"] = "Tamika",      ["name2"] = "Tamika2",      ["name3"] = "Tamika3",      ["name4"] = "Tamika4",      },
	 { ["name"] = "Muscip",      ["name2"] = "Muscip2",      ["name3"] = "Muscip3",      ["name4"] = "Muscip4",      },
	 { ["name"] = "Aberrar",     ["name2"] = "Aberrar2",     ["name3"] = "Aberrar7",     ["name4"] = "Aberrar8",     },
	 { ["name"] = "Aberrar3",    ["name2"] = "Aberrar4",     ["name3"] = "Aberrar5",     ["name4"] = "Aberrar6",     },
	 { ["name"] = "Straker",     ["name2"] = "Straker2",     ["name3"] = "Straker3",     ["name4"] = "Straker4",     },
	 { ["name"] = "Effig",       ["name2"] = "Effig2",       ["name3"] = "Effig3",       ["name4"] = "Effig4",       },
	 { ["name"] = "Pelt",        ["name2"] = "Pelt2",        ["name3"] = "Pel3t",        ["name4"] = "Pelt4",        },
	 { ["name"] = "Gles",        ["name2"] = "Gles2",        ["name3"] = "Gles3",        ["name4"] = "Gles4",        },
	 { ["name"] = "Arantir",     ["name2"] = "Arantir2",     ["name3"] = "Arantir3",     ["name4"] = "Arantir4",     },
	 { ["name"] = "OrnellaNecro",["name2"] = "OrnellaNecro2",["name3"] = "OrnellaNecro5",["name4"] = "OrnellaNecro6",},
	 { ["name"] = "Berein",      ["name2"] = "Berein2",      ["name3"] = "Berein3",      ["name4"] = "Berein4",      },
	 { ["name"] = "Nikolas",     ["name2"] = "Nikolas2",     ["name3"] = "Nikolas3",     ["name4"] = "Nikolas4",     }
};

dublikat_heroes[3] = {
	 { ["name"] = "Metlirn",     ["name2"] = "Metlirn2",     ["name3"] = "Metlirn3",     ["name4"] = "Metlirn4",     },
	 { ["name"] = "Gillion",     ["name2"] = "Gillion2",     ["name3"] = "Gillion3",     ["name4"] = "Gillion4",     },
	 { ["name"] = "Nadaur",      ["name2"] = "Nadaur2",      ["name3"] = "Nadaur3",      ["name4"] = "Nadaur4",      },
	 { ["name"] = "Diraya",      ["name2"] = "Diraya2",      ["name3"] = "Diraya3",      ["name4"] = "Diraya4",      },
	 { ["name"] = "Ossir",       ["name2"] = "Ossir2",       ["name3"] = "Ossir3",       ["name4"] = "Ossir4",       },
	 { ["name"] = "Itil",        ["name2"] = "Itil2",        ["name3"] = "Itil3",        ["name4"] = "Itil4",        },
	 { ["name"] = "Elleshar",    ["name2"] = "Elleshar2",    ["name3"] = "Elleshar3",    ["name4"] = "Elleshar4",    },
	 { ["name"] = "Linaas",      ["name2"] = "Linaas2",      ["name3"] = "Linaas3",      ["name4"] = "Linaas4",      },
	 { ["name"] = "Heam",        ["name2"] = "Heam2",        ["name3"] = "Heam3",        ["name4"] = "Heam4",        },
	 { ["name"] = "Ildar",       ["name2"] = "Ildar2",       ["name3"] = "Ildar7",       ["name4"] = "Ildar8",       },
	 { ["name"] = "Ildar3",      ["name2"] = "Ildar4",       ["name3"] = "Ildar5",       ["name4"] = "Ildar6",       },
	 { ["name"] = "GhostFSLord", ["name2"] = "GhostFSLord2", ["name3"] = "GhostFSLord3", ["name4"] = "GhostFSLord4", }
};

dublikat_heroes[4] = {
	 { ["name"] = "Faiz",        ["name2"] = "Faiz2",        ["name3"] = "Faiz3",        ["name4"] = "Faiz4",        },
	 { ["name"] = "Havez",       ["name2"] = "Havez2",       ["name3"] = "Havez3",       ["name4"] = "Havez4",       },
	 { ["name"] = "Nur",         ["name2"] = "Nur2",         ["name3"] = "Nur3",         ["name4"] = "Nur4",         },
	 { ["name"] = "Astral",      ["name2"] = "Astral2",      ["name3"] = "Astral3",      ["name4"] = "Astral4",      },
	 { ["name"] = "Sufi",        ["name2"] = "Sufi2",        ["name3"] = "Sufi3",        ["name4"] = "Sufi4",        },
	 { ["name"] = "Razzak",      ["name2"] = "Razzak2",      ["name3"] = "Razzak3",      ["name4"] = "Razzak4",      },
	 { ["name"] = "Tan",         ["name2"] = "Tan2",         ["name3"] = "Tan3",         ["name4"] = "Tan4",         },
	 { ["name"] = "Isher",       ["name2"] = "Isher2",       ["name3"] = "Isher3",       ["name4"] = "Isher4",       },
	 { ["name"] = "Zehir",       ["name2"] = "Zehir2",       ["name3"] = "Zehir3",       ["name4"] = "Zehir4",       },
	 { ["name"] = "Maahir",      ["name2"] = "Maahir2",      ["name3"] = "Maahir3",      ["name4"] = "Maahir4",      },
	 { ["name"] = "Cyrus",       ["name2"] = "Cyrus2",       ["name3"] = "Cyrus3",       ["name4"] = "Cyrus4",       }
};

dublikat_heroes[5] = {
	 { ["name"] = "Eruina",      ["name2"] = "Eruina2",      ["name3"] = "Eruina3",      ["name4"] = "Eruina4",      },
	 { ["name"] = "Inagost",     ["name2"] = "Inagost2",     ["name3"] = "Inagost3",     ["name4"] = "Inagost4",     },
	 { ["name"] = "Urunir",      ["name2"] = "Urunir2",      ["name3"] = "Urunir3",      ["name4"] = "Urunir4",      },
	 { ["name"] = "Almegir",     ["name2"] = "Almegir2",     ["name3"] = "Almegir3",     ["name4"] = "Almegir4",     },
	 { ["name"] = "Menel",       ["name2"] = "Menel2",       ["name3"] = "Menel3",       ["name4"] = "Menel4",       },
	 { ["name"] = "Dalom",       ["name2"] = "Dalom2",       ["name3"] = "Dalom3",       ["name4"] = "Dalom4",       },
	 { ["name"] = "Ferigl",      ["name2"] = "Ferigl2",      ["name3"] = "Ferigl3",      ["name4"] = "Ferigl4",      },
	 { ["name"] = "Ohtarig",     ["name2"] = "Ohtarig2",     ["name3"] = "Ohtarig3",     ["name4"] = "Ohtarig4",     },
	 { ["name"] = "Raelag_A1",   ["name2"] = "Raelag_A12",   ["name3"] = "Raelag_A13",   ["name4"] = "Raelag_A14",   },
	 { ["name"] = "Kelodin",     ["name2"] = "Kelodin2",     ["name3"] = "Kelodin3",     ["name4"] = "Kelodin4",     },
	 { ["name"] = "Shadwyn",     ["name2"] = "Shadwyn2",     ["name3"] = "Shadwyn3",     ["name4"] = "Shadwyn4",     },
	 { ["name"] = "Thralsai",    ["name2"] = "Thralsai2",    ["name3"] = "Thralsai3",    ["name4"] = "Thralsai4",    }
};

dublikat_heroes[6] = {
 	 { ["name"] = "Brand",       ["name2"] = "Brand2",       ["name3"] = "Brand3",       ["name4"] = "Brand4",       },
	 { ["name"] = "Bersy",       ["name2"] = "Bersy2",       ["name3"] = "Bersy3",       ["name4"] = "Bersy4",       },
	 { ["name"] = "Egil",        ["name2"] = "Egil2",        ["name3"] = "Egil3",        ["name4"] = "Egil4",        },
	 { ["name"] = "Ottar",       ["name2"] = "Ottar2",       ["name3"] = "Ottar3",       ["name4"] = "Ottar4",       },
	 { ["name"] = "Una",         ["name2"] = "Una2",         ["name3"] = "Una3",         ["name4"] = "Una4",         },
	 { ["name"] = "Ingvar",      ["name2"] = "Ingvar2",      ["name3"] = "Ingvar3",      ["name4"] = "Ingvar4",      },
	 { ["name"] = "Vegeyr",      ["name2"] = "Vegeyr2",      ["name3"] = "Vegeyr3",      ["name4"] = "Vegeyr4",      },
	 { ["name"] = "Skeggy",      ["name2"] = "Skeggy2",      ["name3"] = "Skeggy3",      ["name4"] = "Skeggy4",      },
	 { ["name"] = "KingTolghar", ["name2"] = "KingTolghar2", ["name3"] = "KingTolghar3", ["name4"] = "KingTolghar4", },
	 { ["name"] = "Wulfstan",    ["name2"] = "Wulfstan2",    ["name3"] = "Wulfstan3",    ["name4"] = "Wulfstan4",    },
	 { ["name"] = "Rolf",        ["name2"] = "Rolf2",        ["name3"] = "Rolf3",        ["name4"] = "Rolf4",        }
};

dublikat_heroes[7] = {
	 { ["name"] = "Hero2",       ["name2"] = "Hero22",       ["name3"] = "Hero23",       ["name4"] = "Hero24",       },
	 { ["name"] = "Hero3",       ["name2"] = "Hero32",       ["name3"] = "Hero33",       ["name4"] = "Hero34",       },
	 { ["name"] = "Hero6",       ["name2"] = "Hero62",       ["name3"] = "Hero63",       ["name4"] = "Hero64",       },
	 { ["name"] = "Hero8",       ["name2"] = "Hero82",       ["name3"] = "Hero83",       ["name4"] = "Hero84",       },
	 { ["name"] = "Hero7",       ["name2"] = "Hero72",       ["name3"] = "Hero73",       ["name4"] = "Hero74",       },
 	 { ["name"] = "Hero1",       ["name2"] = "Hero12",       ["name3"] = "Hero13",       ["name4"] = "Hero14",       },
 	 { ["name"] = "Hero9",       ["name2"] = "Hero92",       ["name3"] = "Hero93",       ["name4"] = "Hero94",       },
	 { ["name"] = "Hero4",       ["name2"] = "Hero42",       ["name3"] = "Hero43",       ["name4"] = "Hero44",       },
	 { ["name"] = "Kujin",       ["name2"] = "Kujin2",       ["name3"] = "Kujin3",       ["name4"] = "Kujin4",       },
	 { ["name"] = "Gottai",      ["name2"] = "Gottai2",      ["name3"] = "Gottai3",      ["name4"] = "Gottai4",      },
	 { ["name"] = "Quroq",       ["name2"] = "Quroq2",       ["name3"] = "Quroq3",       ["name4"] = "Quroq4",       }
};

----------------- SKILLS ----------------------------------------

array_skills_id = {};
array_skills_id = {
	 { ["name"] = SKILL_LOGISTICS,                      ["ID"] = 1},
	 { ["name"] = SKILL_WAR_MACHINES,                   ["ID"] = 2},
	 { ["name"] = SKILL_LEARNING,                       ["ID"] = 3},
	 { ["name"] = SKILL_LEADERSHIP,                     ["ID"] = 4},
	 { ["name"] = SKILL_LUCK,                           ["ID"] = 5},
	 { ["name"] = SKILL_OFFENCE,                        ["ID"] = 6},
	 { ["name"] = SKILL_DEFENCE,                        ["ID"] = 7},
	 { ["name"] = SKILL_SORCERY,                        ["ID"] = 8},
	 { ["name"] = SKILL_DESTRUCTIVE_MAGIC,              ["ID"] = 9},
	 { ["name"] = SKILL_DARK_MAGIC,                     ["ID"] = 10},
	 { ["name"] = SKILL_LIGHT_MAGIC,                    ["ID"] = 11},
	 { ["name"] = SKILL_SUMMONING_MAGIC,                ["ID"] = 12},
	 { ["name"] = SKILL_TRAINING,                       ["ID"] = 13},
	 { ["name"] = SKILL_GATING,                         ["ID"] = 14},
	 { ["name"] = SKILL_NECROMANCY,                     ["ID"] = 15},
	 { ["name"] = SKILL_AVENGER,                        ["ID"] = 16},
	 { ["name"] = SKILL_ARTIFICIER,                     ["ID"] = 17},
	 { ["name"] = SKILL_INVOCATION,                     ["ID"] = 18},
	 { ["name"] = HERO_SKILL_RUNELORE,                  ["ID"] = 151},
	 { ["name"] = HERO_SKILL_DEMONIC_RAGE,              ["ID"] = 172},
	 { ["name"] = HERO_SKILL_BARBARIAN_LEARNING,        ["ID"] = 183},
	 { ["name"] = HERO_SKILL_VOICE,                     ["ID"] = 187},
	 { ["name"] = HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC, ["ID"] = 191},
	 { ["name"] = HERO_SKILL_SHATTER_DARK_MAGIC,        ["ID"] = 195},
	 { ["name"] = HERO_SKILL_SHATTER_LIGHT_MAGIC,       ["ID"] = 199},
	 { ["name"] = HERO_SKILL_SHATTER_SUMMONING_MAGIC,   ["ID"] = 203}
}

function int(number)
  int_num = 0;
  ost = frac(number);
  if ost >= 0.5 then
    int_num = floor(number + 1);
  else
    int_num = floor(number);
  end;
  return int_num;
end;

-- Movement

MovePoints = 25000;

function hodi1(hero_name)
  MP1 = GetHeroStat(hero_name, STAT_MOVE_POINTS);
  if MP1 < MovePoints then
	  ChangeHeroStat(hero_name, STAT_MOVE_POINTS, MovePoints);
  end;
end;

------------------- ANTISCANER -------------------

StartBonus = {}
StartBonus[1] = bonus1;
StartBonus[2] = bonus2;

------------------------------ MENTOR ------------------------------------------

RemSkSum1 = 0;
RemSkSum2 = 0;

Disconnect_SkillPlayer1 = 'AddSkillPlayer1: '
Disconnect_SkillPlayer2 = 'AddSkillPlayer2: '
Disconnect_GoldPlayer1 = 0
Disconnect_GoldPlayer2 = 0

------ RESOURCES ---------------------------------------------------------------

SetObjectOwner('RANDOMTOWN1',  PLAYER_NONE);
SetObjectOwner('RANDOMTOWN2',  PLAYER_NONE);

function TransformPlTown (town, race)
  if race == 1 then TransformTown(town, 0); end;
  if race == 2 then TransformTown(town, 5); end;
  if race == 3 then TransformTown(town, 4); end;
  if race == 4 then TransformTown(town, 1); end;
  if race == 5 then TransformTown(town, 2); end;
  if race == 6 then TransformTown(town, 3); end;
  if race == 7 then TransformTown(town, 6); end;
  if race == 8 then TransformTown(town, 7); end;
end;

------- BONUS -----------------------------------------------------------------------

price = {};

-- обработчик наступления нового дня
function newday ()
  if GetDate (DAY) == 5 then
     Trigger(COMBAT_RESULTS_TRIGGER, 'CombatResult');

     CombatID = 'CombatID:' .. hero1race .. HeroID(hero1race, HeroMax1) .. GetHeroStat(HeroMax1, 1) .. GetHeroStat(HeroMax1, 2) .. GetHeroStat(HeroMax1, 3) .. GetHeroStat(HeroMax1, 4) .. hero2race .. HeroID(hero2race, HeroMax2) .. GetHeroStat(HeroMax2, 1) .. GetHeroStat(HeroMax2, 2) .. GetHeroStat(HeroMax2, 3) .. GetHeroStat(HeroMax2, 4) .. random(100)

     consoleCmd('game_writelog 1');
     sleep(2);
     print('StartReport')
     print(CombatID);
     consoleCmd('profile_name')
     InfoPlayer(HeroMax1, 1, hero1race, RemSkSum1);
     InfoPlayer(HeroMax2, 2, hero2race, RemSkSum2);

     sleep(1);
     consoleCmd('game_writelog 0');
     

     if ((HasHeroSkill(HeroMax1, 19) and HasHeroSkill(HeroMax2, 19) == nil) and Name(HeroMax2) ~= "Jazaz") or Name(HeroMax1) == "Jazaz" then
       PathFinding(HeroMax1, HeroMax2, hero1race);
     else
       if ((HasHeroSkill(HeroMax2, 19) and HasHeroSkill(HeroMax1, 19) == nil) and Name(HeroMax1) ~= "Jazaz") or Name(HeroMax2) == "Jazaz" then
         PathFinding(HeroMax2, HeroMax1, hero2race);
       else
         if BattleNextDay1 == 0 and BattleNextDay2 == 0 then
           sleep(5);
           InitCombatExecThread(HeroMax1)
           sleep(5)
           SaveHeroesInfoBeforeCombat{HeroMax1, HeroMax2}
           sleep(5)
           MakeHeroInteractWithObject (HeroMax1, HeroMax2);
           while IsHeroAlive(HeroMax1) and IsHeroAlive(HeroMax2) do
		         MakeHeroInteractWithObject(HeroMax1, HeroMax2);
		         sleep(10);
	         end;
         else
           hodi1(HeroMax2);
           ShowFlyingSign(GetMapDataPath().."propusk.txt", HeroMax1, 1, 5.0);
           ShowFlyingSign(GetMapDataPath().."arena.txt", HeroMax2, 2, 5.0);
         end;
       end;
     end;
     
     
  end;
  
  if GetDate (DAY) == 6 then
     sleep(5);
     InitCombatExecThread(HeroMax1)
     sleep(5)
     SaveHeroesInfoBeforeCombat{HeroMax1, HeroMax2}
     sleep(5)
     MakeHeroInteractWithObject (HeroMax1, HeroMax2);
  end;
end;

function CombatResult(id)
  local n_stacks, creature, count, died, looserName;
  --consoleCmd('game_writelog 1')
  looserName = GetSavedCombatArmyHero(id, 0)
  if looserName == HeroMax1 then Loose(1); end;
  if looserName == HeroMax2 then Loose(2); end;

  -- анализ победившей стороны
  n_stacks = GetSavedCombatArmyCreaturesCount(id, 1);
  Info_Hero_ArmyRemainder = 'ArmyRemainder: '
  for i = 0,(n_stacks-1) do
    creature, count, died = GetSavedCombatArmyCreatureInfo(id, 1, i);
    Info_Hero_ArmyRemainder = Info_Hero_ArmyRemainder .. 'ID' .. creature .. ' = ' .. (count - died) .. ', '
  end

  if IsHeroAlive(HeroMax1) then
    TalkBoxForPlayers( 1, "/Textures/Icons/Heroes/Inferno/Inferno_Biara_128x128.(Texture).xdb#xpointer(/Texture)", GetMapDataPath().."ReportDSCRP.txt", nil, nil, 'SendReport', 0, GetMapDataPath().."ReportNAME.txt", GetMapDataPath().."ReportQ.txt", nil, GetMapDataPath().."Tournament1.txt", GetMapDataPath().."Tournament2.txt", GetMapDataPath().."Tournament3.txt", GetMapDataPath().."Tournament4.txt", GetMapDataPath().."Tournament5.txt");
  end;
  if IsHeroAlive(HeroMax2) then
    TalkBoxForPlayers( 2, "/UI/H5A1/Icons/Heroes/Portrets128x128/Giovanni.(Texture).xdb#xpointer(/Texture)", GetMapDataPath().."ReportDSCRP.txt", nil, nil, 'SendReport', 0, GetMapDataPath().."ReportNAME.txt", GetMapDataPath().."ReportQ.txt", nil, GetMapDataPath().."Tournament1.txt", GetMapDataPath().."Tournament2.txt", GetMapDataPath().."Tournament3.txt", GetMapDataPath().."Tournament4.txt", GetMapDataPath().."Tournament5.txt");
   end;
end;

function SendReport(player, tournament)
  consoleCmd('game_writelog 1')
  sleep(1)
--  if player == 1 then Loose(2) else Loose(1) end
--  sleep(3);
  if tournament ~= 5 then
    print('Winner: Player', player)
    consoleCmd('profile_name');
    sleep(1);
    print(CombatID)
    print('Tournament: ', tournament)
    print(array_info[1].Name)
    print(array_info[1].Race)
    print(array_info[1].Level)
    print(array_info[1].Attack)
    print(array_info[1].Defence)
    print(array_info[1].Spellpower)
    print(array_info[1].Knowledge)
    print(array_info[1].Luck)
    print(array_info[1].Morale)
    print(array_info[1].Mana)
    print(array_info[1].StartBonus)
    print(array_info[1].Mentoring)
    print(array_info[1].Army)
    print(array_info[1].Arts)
    print(array_info[1].Spells)
    print(array_info[1].Skills)
    print(array_info[1].Perks)
  
    print(array_info[2].Name)
    print(array_info[2].Race)
    print(array_info[2].Level)
    print(array_info[2].Attack)
    print(array_info[2].Defence)
    print(array_info[2].Spellpower)
    print(array_info[2].Knowledge)
    print(array_info[2].Luck)
    print(array_info[2].Morale)
    print(array_info[2].Mana)
    print(array_info[2].StartBonus)
    print(array_info[2].Mentoring)
    print(array_info[2].Army)
    print(array_info[2].Arts)
    print(array_info[2].Spells)
    print(array_info[2].Skills)
    print(array_info[2].Perks)
  
    print(Info_Hero_ArmyRemainder)
    print('Finish')
    consoleCmd('game_writelog 0')
  else
    print('Disconnect');
    consoleCmd('game_writelog 0')
  end;
end

function DeleteReport(player)
  consoleCmd('game_writelog 1')
  sleep(1)
  print('DeleteReport')
end

function HeroID(race, hero)
  local id = 0;
  for i = 1, length(dublikat_heroes[race - 1]) do
    if dublikat_heroes[race - 1].name == hero or dublikat_heroes[race - 1].name2 == hero or dublikat_heroes[race - 1].name3 == hero or dublikat_heroes[race - 1].name4 == hero then
      id = i;
    end;
  end;
  return id;
end;

array_info = {}

function InfoPlayer(hero, player, race, mentoring)
  Info_Hero_Name       = 'Hero' .. player.. '_Name: ' .. Name(hero);
  Info_Hero_Race       = 'Hero' .. player.. '_Race: ' .. race;
  Info_Hero_Attack     = 'Hero' .. player.. '_Attack: ' .. GetHeroStat(hero, 1);
  Info_Hero_Defence    = 'Hero' .. player.. '_Defence: ' .. GetHeroStat(hero, 2);
  Info_Hero_Spellpower = 'Hero' .. player.. '_Spellpower: ' .. GetHeroStat(hero, 3);
  Info_Hero_Knowledge  = 'Hero' .. player.. '_Knowledge: ' .. GetHeroStat(hero, 4);
  Info_Hero_Luck       = 'Hero' .. player.. '_Luck: ' .. GetHeroStat(hero, 5);
  Info_Hero_Morale     = 'Hero' .. player.. '_Morale: ' .. GetHeroStat(hero, 6);
  Info_Hero_Mana       = 'Hero' .. player.. '_Mana: ' .. GetHeroStat(hero, 8);
  Info_Hero_Level      = 'Hero' .. player.. '_Level: ' .. GetHeroLevel(hero);
  Info_Hero_StartBonus = 'Hero' .. player.. '_StartBonus: ' .. StartBonus[player];
  Info_Hero_Mentoring  = 'Hero' .. player.. '_Mentoring: ' .. mentoring;
  Info_Hero_Army = 'Hero' .. player.. '_Army: '
  for i = 1, 999 do
    if GetHeroCreatures(hero, i) > 0 then
      Info_Hero_Army = Info_Hero_Army .. 'ID' .. i .. ' = ' .. GetHeroCreatures(hero, i) .. ', '
    end;
  end;
  Info_Hero_Arts = 'Hero' .. player.. '_Arts: '
  for i = 1, 96 do
    if HasArtefact(hero, i, 1) then
      Info_Hero_Arts = Info_Hero_Arts .. 'ID' .. i .. ', '
    end;
  end;
  Info_Hero_Spells = 'Hero' .. player.. '_Spells: '
  for i = 0, 5 do
    for j = 1, length(array_spells[i]) do
      if KnowHeroSpell(hero, array_spells[i][j].id) then
        Info_Hero_Spells = Info_Hero_Spells .. 'ID' .. array_spells[i][j].id .. ', '
      end;
    end;
  end;
  Info_Hero_Skills = 'Hero' .. player.. '_Skills: '
  for i = 1, length(array_skills_id) do
    if GetHeroSkillMastery(hero, array_skills_id[i].name) > 0 then
      Info_Hero_Skills = Info_Hero_Skills .. 'ID' .. array_skills_id[i].ID .. ' = ' .. GetHeroSkillMastery(hero, array_skills_id[i].name) .. ', '
    end;
  end;
  Info_Hero_Perks = 'Hero' .. player.. '_Perks: '
  for i = 19, 220 do
    if GetHeroSkillMastery(hero, i) > 0 and i ~= 61 and i ~= 65 and i ~= 72 and i ~= 85 and i ~= 92 and i ~= 151 and i ~= 172 and i ~= 183 and i ~= 187
    and i ~= 191 and i ~= 195 and i ~= 199 and i ~= 203 then
      Info_Hero_Perks = Info_Hero_Perks .. 'ID' .. i .. ', '
    end;
  end;
  
  array_info[player] = {
     ["Name"] = Info_Hero_Name, ["Race"] = Info_Hero_Race, ["Attack"] = Info_Hero_Attack, ["Defence"] = Info_Hero_Defence, ["Spellpower"] = Info_Hero_Spellpower,
     ["Knowledge"] = Info_Hero_Knowledge, ["Luck"] = Info_Hero_Luck, ["Morale"] = Info_Hero_Morale, ["Mana"] = Info_Hero_Mana, ["Level"] = Info_Hero_Level,
     ["StartBonus"] = Info_Hero_StartBonus, ["Mentoring"] = Info_Hero_Mentoring, ["Army"] = Info_Hero_Army, ["Arts"] = Info_Hero_Arts, ["Spells"] = Info_Hero_Spells,
     ["Skills"] = Info_Hero_Skills, ["Perks"] = Info_Hero_Perks }
end;

----------------------------- GLOBAL MODE --------------------------------------

PathFindingX = {} ;
PathFindingX = { 50, 56, 48, 50, 44, 44, 56, 51};

PathFindingY = {} ;
PathFindingY = { 45, 49, 52, 45, 48, 42, 41, 38};

function PathFinding(HeroWithPerk, HeroWithoutPerk, race)
  hodi1(HeroWithPerk);
  sleep(1);
  MoveHeroRealTime(HeroWithPerk, PathFindingX[race], PathFindingY[race]);
  sleep(10);
  
  InitCombatExecThread(HeroMax1)
  sleep(5)
  SaveHeroesInfoBeforeCombat{HeroMax1, HeroMax2}
  sleep(5)
  MakeHeroInteractWithObject (HeroWithoutPerk, HeroWithPerk);
  
  while IsHeroAlive(HeroWithoutPerk) and IsHeroAlive(HeroWithPerk) do
		MakeHeroInteractWithObject(HeroWithoutPerk, HeroWithPerk);
		sleep(10);
	end;
end;

function Name(hero)
  for i = 0, 7 do
    for j = 1, length(dublikat_heroes[i]) do
      if hero == dublikat_heroes[i][j].name or hero == dublikat_heroes[i][j].name2 or hero == dublikat_heroes[i][j].name3 or hero == dublikat_heroes[i][j].name4 then
        nameH = dublikat_heroes[i][j].name;
        j = length(dublikat_heroes[i]);
        i = 7;
      end;
    end;
  end;
  return nameH;
end;

function AutoSave()
  i1 = 0;
  while GetDate (DAY) == 2 or GetDate (DAY) == 3 do
    sleep (100);
    i1 = i1 + 1;
    Save(GetMapDataPath().."AutoSave");
  end;
end;

-- Opisaniya

SetObjectEnabled('bonus1', nil);

SetObjectEnabled('bonus2', nil);

OverrideObjectTooltipNameAndDescription ('port1', GetMapDataPath().."portNAME.txt", GetMapDataPath().."portDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('port2', GetMapDataPath().."portNAME.txt", GetMapDataPath().."portDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('oko1', GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
OverrideObjectTooltipNameAndDescription ('oko2', GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
OverrideObjectTooltipNameAndDescription ('bandit_map', GetMapDataPath().."banditNAME.txt", GetMapDataPath().."bandit_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mostovik_map', GetMapDataPath().."mostovikNAME.txt", GetMapDataPath().."mostovik_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('vsev_map', GetMapDataPath().."vsevNAME.txt", GetMapDataPath().."vsev_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('tari_map', GetMapDataPath().."tariNAME.txt", GetMapDataPath().."tari_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('bonus1', GetMapDataPath().."bonusNAME.txt", GetMapDataPath().."bon.txt");
OverrideObjectTooltipNameAndDescription ('bonus2', GetMapDataPath().."bonusNAME.txt", GetMapDataPath().."bon.txt");

end;