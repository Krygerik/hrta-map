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

for i = 0, 5 do
  for j = 1, length(array_spells[i]) do
    SetObjectEnabled(array_spells[i][j].name,  nil);
    SetObjectEnabled(array_spells[i][j].name2, nil);
    SetObjectEnabled(array_spells[i][j].name3, nil);
    SetObjectEnabled(array_spells[i][j].name4, nil);
  end;
end;


------------------ ARTS ----------------------------

array_arts[0] = {
   { ["name"] = "art1",  ["name2"] = "art1x2",  ["place"] = 7, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 1},   --меч мощи
   { ["name"] = "art2",  ["name2"] = "art2x2",  ["place"] = 7, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 90},  --на грани равновесия
   { ["name"] = "art4",  ["name2"] = "art4x2",  ["place"] = 6, ["price"] = 4000,  ["blocked"] = 0, ["id"] = 8},   --клевер
   { ["name"] = "art5",  ["name2"] = "art5x2",  ["place"] = 6, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 87},  --колода таро
   { ["name"] = "art6",  ["name2"] = "art6x2",  ["place"] = 8, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 27},  --сапоги магической защиты
--   { ["name"] = "art7",  ["name2"] = "art7x2",  ["place"] = 2, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 34},  --тюрбан просвещенности
   { ["name"] = "art8",  ["name2"] = "art8x2",  ["place"] = 2, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 66},  --шлем хаоса
   { ["name"] = "art9",  ["name2"] = "art9x2",  ["place"] = 4, ["price"] = 5500,  ["blocked"] = 0, ["id"] = 64},  --туника из плоти
   { ["name"] = "art10", ["name2"] = "art10x2", ["place"] = 4, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 14},  --нагрудник мощи
   { ["name"] = "art12", ["name2"] = "art12x2", ["place"] = 7, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 80},  --палочка новичка
   { ["name"] = "art13", ["name2"] = "art13x2", ["place"] = 9, ["price"] = 7000,  ["blocked"] = 0, ["id"] = 62},  --плащ силанны
   { ["name"] = "art14", ["name2"] = "art14x2", ["place"] = 9, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 84},  --защитные покровы
   { ["name"] = "art15", ["name2"] = "art15x2", ["place"] = 1, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 20},  --кольцо от молний
   { ["name"] = "art16", ["name2"] = "art16x2", ["place"] = 1, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 60},  --пояс элементалей
   { ["name"] = "art17", ["name2"] = "art17x2", ["place"] = 3, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 16},  --ошейник льва
   { ["name"] = "art19", ["name2"] = "art19x2", ["place"] = 2, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 55},  --шлем некроманта
   { ["name"] = "art20", ["name2"] = "art20x2", ["place"] = 1, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 70},  --кольцо грешников
   { ["name"] = "art21", ["name2"] = "art21x2", ["place"] = 6, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 10},  --свиток маны
   { ["name"] = "art11", ["name2"] = "art11x2", ["place"] = 4, ["price"] = 7000,  ["blocked"] = 0, ["id"] = 56},  --доспех бесстрашия
--   { ["name"] = "art22", ["name2"] = "art22x2", ["place"] = 6, ["price"] = 6500,  ["blocked"] = 1, ["id"] = 86}   --руна пламени
};
array_arts[1] = {
--   { ["name"] = "art23", ["name2"] = "art23x2", ["place"] = 8, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 61},  --изумрудные туфли
--   { ["name"] = "art24", ["name2"] = "art24x2", ["place"] = 9, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 32},  --накидка феникса
   { ["name"] = "art26", ["name2"] = "art26x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 65},  --кольцо предостережения
--   { ["name"] = "art27", ["name2"] = "art27x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 93},  --кольцо изгнания
   { ["name"] = "art29", ["name2"] = "art29x2", ["place"] = 7, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 74},  --дубина орка
   { ["name"] = "art30", ["name2"] = "art30x2", ["place"] = 7, ["price"] = 9500,  ["blocked"] = 0, ["id"] = 85},  --гномий молот
   { ["name"] = "art31", ["name2"] = "art31x2", ["place"] = 7, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 81},  --рунный топор
   { ["name"] = "art32", ["name2"] = "art32x2", ["place"] = 7, ["price"] = 10000, ["blocked"] = 0, ["id"] = 2},   --секира горного короля
   { ["name"] = "art33", ["name2"] = "art33x2", ["place"] = 7, ["price"] = 12500, ["blocked"] = 0, ["id"] = 43},  --меч дракона
   { ["name"] = "art34", ["name2"] = "art34x2", ["place"] = 5, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 58},  --лунный клинок
   { ["name"] = "art35", ["name2"] = "art35x2", ["place"] = 5, ["price"] = 8500,  ["blocked"] = 0, ["id"] = 75},  --щит орка
   { ["name"] = "art36", ["name2"] = "art36x2", ["place"] = 5, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 9},   --ледяной щит
   { ["name"] = "art37", ["name2"] = "art37x2", ["place"] = 5, ["price"] = 10000, ["blocked"] = 0, ["id"] = 71},  --том силы (амулет некроманта)
   { ["name"] = "art38", ["name2"] = "art38x2", ["place"] = 5, ["price"] = 10000, ["blocked"] = 0, ["id"] = 37},  --щит дракона
   { ["name"] = "art39", ["name2"] = "art39x2", ["place"] = 6, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 25},  --золотая подкова
   { ["name"] = "art40", ["name2"] = "art40x2", ["place"] = 8, ["price"] = 10000, ["blocked"] = 0, ["id"] = 38},  --поножи дракона
   { ["name"] = "art41", ["name2"] = "art41x2", ["place"] = 2, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 41},  --шлем дракона
   { ["name"] = "art42", ["name2"] = "art42x2", ["place"] = 4, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 82},  --рунная упряжь
   { ["name"] = "art43", ["name2"] = "art43x2", ["place"] = 4, ["price"] = 11000, ["blocked"] = 0, ["id"] = 36},  --доспех дракона
   { ["name"] = "art44", ["name2"] = "art44x2", ["place"] = 9, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 31},  --накидка льва
   { ["name"] = "art45", ["name2"] = "art45x2", ["place"] = 9, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 95},  --колчан единорога
   { ["name"] = "art46", ["name2"] = "art46x2", ["place"] = 9, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 39},  --мантия дракона
   { ["name"] = "art47", ["name2"] = "art47x2", ["place"] = 1, ["price"] = 10000, ["blocked"] = 0, ["id"] = 23},  --кольцо сломленного духа
   { ["name"] = "art48", ["name2"] = "art48x2", ["place"] = 1, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 63},  --кольцо неудачи
   { ["name"] = "art49", ["name2"] = "art49x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 21},  --кольцо жизненной силы
   { ["name"] = "art51", ["name2"] = "art51x2", ["place"] = 1, ["price"] = 11000, ["blocked"] = 0, ["id"] = 42},  --кольцо дракона
   { ["name"] = "art53", ["name2"] = "art53x2", ["place"] = 3, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 19},  --ожерелье победы
   { ["name"] = "art54", ["name2"] = "art54x2", ["place"] = 3, ["price"] = 10000, ["blocked"] = 0, ["id"] = 40}   --ожерелье дракона
--   { ["name"] = "art55", ["name2"] = "art55x2", ["place"] = 4, ["price"] = 6500,  ["blocked"] = 0, ["id"] = 35}   --кольчуга просвещенности
};
array_arts[2] = {
   { ["name"] = "art52", ["name2"] = "art52x2", ["place"] = 3, ["price"] = 12000, ["blocked"] = 0, ["id"] = 17},  --ожерелье коготь
   { ["name"] = "art50", ["name2"] = "art50x2", ["place"] = 1, ["price"] = 12000, ["blocked"] = 0, ["id"] = 59},  --кольцо стремительности
   { ["name"] = "art28", ["name2"] = "art28x2", ["place"] = 8, ["price"] = 12000, ["blocked"] = 0, ["id"] = 57},  --сапоги скорости
   { ["name"] = "art25", ["name2"] = "art25x2", ["place"] = 2, ["price"] = 12000, ["blocked"] = 0, ["id"] = 88},  --корона лидерства
--   { ["name"] = "art56", ["name2"] = "art56x2", ["place"] = 1, ["price"] = 20000, ["blocked"] = 0, ["id"] = 91},  --кольцо машин
   { ["name"] = "art57", ["name2"] = "art57x2", ["place"] = 7, ["price"] = 15000, ["blocked"] = 0, ["id"] = 4},   --лук единорога
   { ["name"] = "art58", ["name2"] = "art58x2", ["place"] = 7, ["price"] = 12000, ["blocked"] = 0, ["id"] = 45},  --посох сар-иссы
   { ["name"] = "art59", ["name2"] = "art59x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 51},  --щит гномов
   { ["name"] = "art60", ["name2"] = "art60x2", ["place"] = 5, ["price"] = 12000, ["blocked"] = 0, ["id"] = 79},  --том призыва
   { ["name"] = "art61", ["name2"] = "art61x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 77},  --том света
   { ["name"] = "art62", ["name2"] = "art62x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 78},  --том тьмы
   { ["name"] = "art63", ["name2"] = "art63x2", ["place"] = 5, ["price"] = 12000, ["blocked"] = 0, ["id"] = 76},  --том хаоса
   { ["name"] = "art64", ["name2"] = "art64x2", ["place"] = 6, ["price"] = 16000, ["blocked"] = 0, ["id"] = 83},  --череп маркела
   { ["name"] = "art65", ["name2"] = "art65x2", ["place"] = 8, ["price"] = 14500, ["blocked"] = 0, ["id"] = 68},  --сандали святого
   { ["name"] = "art66", ["name2"] = "art66x2", ["place"] = 8, ["price"] = 13000, ["blocked"] = 0, ["id"] = 49},  --поножи гномов
   { ["name"] = "art67", ["name2"] = "art67x2", ["place"] = 2, ["price"] = 16000, ["blocked"] = 0, ["id"] = 11},  --корона льва
   { ["name"] = "art68", ["name2"] = "art68x2", ["place"] = 2, ["price"] = 15000, ["blocked"] = 0, ["id"] = 46},  --корона сар-иссы
   { ["name"] = "art69", ["name2"] = "art69x2", ["place"] = 2, ["price"] = 13000, ["blocked"] = 0, ["id"] = 50},  --шлем гномов
   { ["name"] = "art70", ["name2"] = "art70x2", ["place"] = 4, ["price"] = 15000, ["blocked"] = 0, ["id"] = 44},  --халат сар-иссы
   { ["name"] = "art71", ["name2"] = "art71x2", ["place"] = 4, ["price"] = 13000, ["blocked"] = 0, ["id"] = 48},  --кираса гномов
   { ["name"] = "art72", ["name2"] = "art72x2", ["place"] = 4, ["price"] = 23000, ["blocked"] = 0, ["id"] = 13},  --доспех забытого
   { ["name"] = "art73", ["name2"] = "art73x2", ["place"] = 9, ["price"] = 18000, ["blocked"] = 0, ["id"] = 33},  --плащ смерти
   { ["name"] = "art74", ["name2"] = "art74x2", ["place"] = 1, ["price"] = 17000, ["blocked"] = 0, ["id"] = 47},  --кольцо сар-иссы
   { ["name"] = "art75", ["name2"] = "art75x2", ["place"] = 3, ["price"] = 12000, ["blocked"] = 0, ["id"] = 67},  --кулон поглощения
   { ["name"] = "art3",  ["name2"] = "art3x2",  ["place"] = 7, ["price"] = 14000, ["blocked"] = 0, ["id"] = 5},   --трезубец титанов
   { ["name"] = "art18", ["name2"] = "art18x2", ["place"] = 3, ["price"] = 14000, ["blocked"] = 0, ["id"] = 18},  --ледяной кулон
   { ["name"] = "art77", ["name2"] = "art77x2", ["place"] = 7, ["price"] = 13000, ["blocked"] = 0, ["id"] = 7}    --посох преисподней (кандалы неизбежности)
--   { ["name"] = "art76", ["name2"] = "art76x2", ["place"] = 3, ["price"] = 15000, ["blocked"] = 0, ["id"] = 15},  --кулон мастерства
--   { ["name"] = "art78", ["name2"] = "art78x2", ["place"] = 7, ["price"] = 35000, ["blocked"] = 1, ["id"] = 6},   --посох преисподней
--   { ["name"] = "art79", ["name2"] = "art79x2", ["place"] = 2, ["price"] = 26000, ["blocked"] = 1, ["id"] = 89},  --маска справедливости
--   { ["name"] = "art80", ["name2"] = "art80x2", ["place"] = 9, ["price"] = 16000, ["blocked"] = 1, ["id"] = 69},  --плащ сандро
--   { ["name"] = "art81", ["name2"] = "art81x2", ["place"] = 1, ["price"] = 30000, ["blocked"] = 1, ["id"] = 22}   --кольцо скорости
};

array_artPlace={};
array_artPlace[0]={};
array_artPlace[1]={{20,60,70},{21,23,42,63,21,59,63,65,93},{22,47,91}};
array_artPlace[2]={{34,55,66},{41,88},{11,46,50,89}};
array_artPlace[3]={{16,18,71},{17,19,40},{15,67}};
array_artPlace[4]={{14,56,64},{35,36,82},{13,44,48}};
array_artPlace[5]={{},{9,37,58,75,71},{51,76,77,78,79}};
array_artPlace[6]={{8,86,87},{25},{83}};
array_artPlace[7]={{1,5,80,90},{2,43,74,81,85},{4,6,7,45}};
array_artPlace[8]={{27},{38,57},{49,68}};
array_artPlace[9]={{62,84},{31,39,95},{33,69}};

ArtMaliy = {};
ArtMaliy = { 1, 90, 5, 8, 87, 27, 66, 64, 14, 56, 80, 62, 84, 20, 65, 60, 16, 18, 55, 88};

ArtVelikiy = {};
ArtVelikiy = { 61, 57, 32, 93, 74, 85, 81, 2, 43, 58, 75, 9, 71, 37, 25, 38, 41, 82, 36, 31, 95, 39, 23, 63, 21, 59, 42, 17, 19, 40, 91}

ArtRelikviya = {};
ArtRelikviya = { 4, 45, 51, 79, 77, 78, 76, 83, 68, 49, 11, 46, 50, 44, 48, 13, 33, 69, 47, 67, 15};



------------------ UNITS -------------------------

array_units={}
array_units[0] = {
   { ["name"] = "unit91", ["kol"] = 80, ["id"] =113, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 1},
   { ["name"] = "unit92", ["kol"] = 50, ["id"] = 85, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  829, ["lvl"] = 4},
   { ["name"] = "unit93", ["kol"] = 50, ["id"] = 86, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  795, ["lvl"] = 4},
   { ["name"] = "unit94", ["kol"] = 50, ["id"] = 88, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  813, ["lvl"] = 4},
   { ["name"] = "unit95", ["kol"] = 50, ["id"] = 87, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  856, ["lvl"] = 4},
   { ["name"] = "unit96", ["kol"] = 30, ["id"] =116, ["blocked"] = 0, ["price"] = 25500, ["price1"] =  400, ["power"] = 1542, ["lvl"] = 5},
   { ["name"] = "unit97", ["kol"] = 18, ["id"] = 89, ["blocked"] = 0, ["price"] = 30600, ["price1"] = 1700, ["power"] = 2560, ["lvl"] = 6},
   { ["name"] = "unit98", ["kol"] = 18, ["id"] =115, ["blocked"] = 0, ["price"] = 30600, ["price1"] = 1700, ["power"] = 2523, ["lvl"] = 6},
   { ["name"] = "unit99", ["kol"] =  5, ["id"] = 91, ["blocked"] = 0, ["price"] = 30000, ["price1"] = 6000, ["power"] = 8576, ["lvl"] = 7}
};

array_units[1] = {
   { ["name"] = "unit111", ["kol"] =338, ["id"] =  1, ["blocked"] = 0, ["price"] =  8750, ["price1"] =   30, ["power"] =   72, ["lvl"] = 1},
   { ["name"] = "unit121", ["kol"] =144, ["id"] =  3, ["blocked"] = 0, ["price"] = 11700, ["price1"] =  100, ["power"] =  199, ["lvl"] = 2},
   { ["name"] = "unit131", ["kol"] =100, ["id"] =  5, ["blocked"] = 0, ["price"] =  8500, ["price1"] =  140, ["power"] =  287, ["lvl"] = 3},
   { ["name"] = "unit141", ["kol"] = 45, ["id"] =  7, ["blocked"] = 0, ["price"] = 11000, ["price1"] =  400, ["power"] =  716, ["lvl"] = 4},
   { ["name"] = "unit151", ["kol"] = 24, ["id"] =  9, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  750, ["power"] = 1487, ["lvl"] = 5},
   { ["name"] = "unit161", ["kol"] = 14, ["id"] = 11, ["blocked"] = 0, ["price"] = 18000, ["price1"] = 1400, ["power"] = 2520, ["lvl"] = 6},
   { ["name"] = "unit171", ["kol"] =  6, ["id"] = 13, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6003, ["lvl"] = 7},
   { ["name"] = "unit112", ["kol"] =338, ["id"] =  2, ["blocked"] = 0, ["price"] =  8750, ["price1"] =   30, ["power"] =   72, ["lvl"] = 1},
   { ["name"] = "unit122", ["kol"] =144, ["id"] =  4, ["blocked"] = 0, ["price"] = 11700, ["price1"] =  100, ["power"] =  199, ["lvl"] = 2},
   { ["name"] = "unit132", ["kol"] =100, ["id"] =  6, ["blocked"] = 0, ["price"] =  8500, ["price1"] =  140, ["power"] =  287, ["lvl"] = 3},
   { ["name"] = "unit142", ["kol"] = 45, ["id"] =  8, ["blocked"] = 0, ["price"] = 11000, ["price1"] =  400, ["power"] =  716, ["lvl"] = 4},
   { ["name"] = "unit152", ["kol"] = 24, ["id"] = 10, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  750, ["power"] = 1487, ["lvl"] = 5},
   { ["name"] = "unit162", ["kol"] = 14, ["id"] = 12, ["blocked"] = 0, ["price"] = 18000, ["price1"] = 1400, ["power"] = 2520, ["lvl"] = 6},
   { ["name"] = "unit172", ["kol"] =  6, ["id"] = 14, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6003, ["lvl"] = 7},
   { ["name"] = "unit113", ["kol"] =338, ["id"] =106, ["blocked"] = 0, ["price"] =  8750, ["price1"] =   30, ["power"] =   72, ["lvl"] = 1},
   { ["name"] = "unit123", ["kol"] =144, ["id"] =107, ["blocked"] = 0, ["price"] = 11700, ["price1"] =  100, ["power"] =  199, ["lvl"] = 2},
   { ["name"] = "unit133", ["kol"] =100, ["id"] =108, ["blocked"] = 0, ["price"] =  8500, ["price1"] =  140, ["power"] =  287, ["lvl"] = 3},
   { ["name"] = "unit143", ["kol"] = 45, ["id"] =109, ["blocked"] = 0, ["price"] = 11000, ["price1"] =  400, ["power"] =  716, ["lvl"] = 4},
   { ["name"] = "unit153", ["kol"] = 24, ["id"] =110, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  750, ["power"] = 1487, ["lvl"] = 5},
   { ["name"] = "unit163", ["kol"] = 14, ["id"] =111, ["blocked"] = 0, ["price"] = 18000, ["price1"] = 1400, ["power"] = 2520, ["lvl"] = 6},
   { ["name"] = "unit173", ["kol"] =  6, ["id"] =112, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6003, ["lvl"] = 7}
};

array_units[2] = {
   { ["name"] = "unit211", ["kol"] =224, ["id"] = 15, ["blocked"] = 0, ["price"] = 10800, ["price1"] =   80, ["power"] =  124, ["lvl"] = 1},
   { ["name"] = "unit221", ["kol"] =192, ["id"] = 17, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   85, ["power"] =  149, ["lvl"] = 2},
   { ["name"] = "unit231", ["kol"] = 80, ["id"] = 19, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  170, ["power"] =  338, ["lvl"] = 3},
   { ["name"] = "unit241", ["kol"] = 45, ["id"] = 21, ["blocked"] = 0, ["price"] = 10600, ["price1"] =  400, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit251", ["kol"] = 27, ["id"] = 23, ["blocked"] = 0, ["price"] = 13050, ["price1"] =  800, ["power"] = 1415, ["lvl"] = 5},
   { ["name"] = "unit261", ["kol"] = 14, ["id"] = 25, ["blocked"] = 0, ["price"] = 21600, ["price1"] = 1500, ["power"] = 2360, ["lvl"] = 6},
   { ["name"] = "unit271", ["kol"] =  6, ["id"] = 27, ["blocked"] = 0, ["price"] = 13328, ["price1"] = 3100, ["power"] = 5850, ["lvl"] = 7},
   { ["name"] = "unit212", ["kol"] =224, ["id"] = 16, ["blocked"] = 0, ["price"] = 10800, ["price1"] =   80, ["power"] =  124, ["lvl"] = 1},
   { ["name"] = "unit222", ["kol"] =192, ["id"] = 18, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   85, ["power"] =  149, ["lvl"] = 2},
   { ["name"] = "unit232", ["kol"] = 80, ["id"] = 20, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  170, ["power"] =  338, ["lvl"] = 3},
   { ["name"] = "unit242", ["kol"] = 45, ["id"] = 22, ["blocked"] = 0, ["price"] = 10600, ["price1"] =  400, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit252", ["kol"] = 27, ["id"] = 24, ["blocked"] = 0, ["price"] = 13050, ["price1"] =  800, ["power"] = 1415, ["lvl"] = 5},
   { ["name"] = "unit262", ["kol"] = 14, ["id"] = 26, ["blocked"] = 0, ["price"] = 21600, ["price1"] = 1500, ["power"] = 2360, ["lvl"] = 6},
   { ["name"] = "unit272", ["kol"] =  6, ["id"] = 28, ["blocked"] = 0, ["price"] = 13328, ["price1"] = 3100, ["power"] = 5850, ["lvl"] = 7},
   { ["name"] = "unit213", ["kol"] =224, ["id"] =131, ["blocked"] = 0, ["price"] = 10800, ["price1"] =   80, ["power"] =  124, ["lvl"] = 1},
   { ["name"] = "unit223", ["kol"] =192, ["id"] =132, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   85, ["power"] =  149, ["lvl"] = 2},
   { ["name"] = "unit233", ["kol"] = 80, ["id"] =133, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  170, ["power"] =  338, ["lvl"] = 3},
   { ["name"] = "unit243", ["kol"] = 45, ["id"] =134, ["blocked"] = 0, ["price"] = 10600, ["price1"] =  400, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit253", ["kol"] = 27, ["id"] =135, ["blocked"] = 0, ["price"] = 13050, ["price1"] =  800, ["power"] = 1415, ["lvl"] = 5},
   { ["name"] = "unit263", ["kol"] = 14, ["id"] =136, ["blocked"] = 0, ["price"] = 21600, ["price1"] = 1500, ["power"] = 2360, ["lvl"] = 6},
   { ["name"] = "unit273", ["kol"] =  6, ["id"] =137, ["blocked"] = 0, ["price"] = 13328, ["price1"] = 3100, ["power"] = 5850, ["lvl"] = 7}
};

array_units[3] = {
   { ["name"] = "unit311", ["kol"] =316, ["id"] = 29, ["blocked"] = 0, ["price"] =  9720, ["price1"] =   50, ["power"] =   84, ["lvl"] = 1},
   { ["name"] = "unit321", ["kol"] =180, ["id"] = 31, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   80, ["power"] =  145, ["lvl"] = 2},
   { ["name"] = "unit331", ["kol"] = 90, ["id"] = 33, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  180, ["power"] =  327, ["lvl"] = 3},
   { ["name"] = "unit341", ["kol"] = 45, ["id"] = 35, ["blocked"] = 0, ["price"] = 10875, ["price1"] =  450, ["power"] =  739, ["lvl"] = 4},
   { ["name"] = "unit351", ["kol"] = 24, ["id"] = 37, ["blocked"] = 0, ["price"] = 13635, ["price1"] =  750, ["power"] = 1539, ["lvl"] = 5},
   { ["name"] = "unit361", ["kol"] = 14, ["id"] = 39, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1400, ["power"] = 2449, ["lvl"] = 6},
   { ["name"] = "unit371", ["kol"] =  8, ["id"] = 41, ["blocked"] = 0, ["price"] = 13000, ["price1"] = 1900, ["power"] = 3872, ["lvl"] = 7},
   { ["name"] = "unit312", ["kol"] =316, ["id"] = 30, ["blocked"] = 0, ["price"] =  9720, ["price1"] =   50, ["power"] =   84, ["lvl"] = 1},
   { ["name"] = "unit322", ["kol"] =180, ["id"] = 32, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   80, ["power"] =  145, ["lvl"] = 2},
   { ["name"] = "unit332", ["kol"] = 90, ["id"] = 34, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  180, ["power"] =  327, ["lvl"] = 3},
   { ["name"] = "unit342", ["kol"] = 45, ["id"] = 36, ["blocked"] = 0, ["price"] = 10875, ["price1"] =  450, ["power"] =  739, ["lvl"] = 4},
   { ["name"] = "unit352", ["kol"] = 24, ["id"] = 38, ["blocked"] = 0, ["price"] = 13635, ["price1"] =  750, ["power"] = 1539, ["lvl"] = 5},
   { ["name"] = "unit362", ["kol"] = 14, ["id"] = 40, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1400, ["power"] = 2449, ["lvl"] = 6},
   { ["name"] = "unit372", ["kol"] =  8, ["id"] = 42, ["blocked"] = 0, ["price"] = 13000, ["price1"] = 1900, ["power"] = 3872, ["lvl"] = 7},
   { ["name"] = "unit313", ["kol"] =316, ["id"] =152, ["blocked"] = 0, ["price"] =  9720, ["price1"] =   50, ["power"] =   84, ["lvl"] = 1},
   { ["name"] = "unit323", ["kol"] =180, ["id"] =153, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   80, ["power"] =  145, ["lvl"] = 2},
   { ["name"] = "unit333", ["kol"] = 90, ["id"] =154, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  180, ["power"] =  327, ["lvl"] = 3},
   { ["name"] = "unit343", ["kol"] = 45, ["id"] =155, ["blocked"] = 0, ["price"] = 10875, ["price1"] =  450, ["power"] =  739, ["lvl"] = 4},
   { ["name"] = "unit353", ["kol"] = 24, ["id"] =156, ["blocked"] = 0, ["price"] = 13635, ["price1"] =  750, ["power"] = 1539, ["lvl"] = 5},
   { ["name"] = "unit363", ["kol"] = 14, ["id"] =157, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1400, ["power"] = 2449, ["lvl"] = 6},
   { ["name"] = "unit373", ["kol"] =  8, ["id"] =158, ["blocked"] = 0, ["price"] = 13000, ["price1"] = 1900, ["power"] = 3872, ["lvl"] = 7}
};

array_units[4] = {
   { ["name"] = "unit411", ["kol"] =164, ["id"] = 43, ["blocked"] = 0, ["price"] =  9130, ["price1"] =   70, ["power"] =  169, ["lvl"] = 1},
   { ["name"] = "unit421", ["kol"] =108, ["id"] = 45, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  140, ["power"] =  308, ["lvl"] = 2},
   { ["name"] = "unit431", ["kol"] = 70, ["id"] = 47, ["blocked"] = 0, ["price"] =  7200, ["price1"] =  250, ["power"] =  433, ["lvl"] = 3},
   { ["name"] = "unit441", ["kol"] = 36, ["id"] = 49, ["blocked"] = 0, ["price"] = 11600, ["price1"] =  380, ["power"] =  846, ["lvl"] = 4},
   { ["name"] = "unit451", ["kol"] = 24, ["id"] = 51, ["blocked"] = 0, ["price"] = 13365, ["price1"] =  950, ["power"] = 1441, ["lvl"] = 5},
   { ["name"] = "unit461", ["kol"] = 16, ["id"] = 53, ["blocked"] = 0, ["price"] = 17500, ["price1"] = 1150, ["power"] = 1993, ["lvl"] = 6},
   { ["name"] = "unit471", ["kol"] =  6, ["id"] = 55, ["blocked"] = 0, ["price"] = 11200, ["price1"] = 3600, ["power"] = 5905, ["lvl"] = 7},
   { ["name"] = "unit412", ["kol"] =164, ["id"] = 44, ["blocked"] = 0, ["price"] =  9130, ["price1"] =   70, ["power"] =  169, ["lvl"] = 1},
   { ["name"] = "unit422", ["kol"] =108, ["id"] = 46, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  140, ["power"] =  308, ["lvl"] = 2},
   { ["name"] = "unit432", ["kol"] = 70, ["id"] = 48, ["blocked"] = 0, ["price"] =  7200, ["price1"] =  250, ["power"] =  433, ["lvl"] = 3},
   { ["name"] = "unit442", ["kol"] = 36, ["id"] = 50, ["blocked"] = 0, ["price"] = 11600, ["price1"] =  380, ["power"] =  846, ["lvl"] = 4},
   { ["name"] = "unit452", ["kol"] = 24, ["id"] = 52, ["blocked"] = 0, ["price"] = 13365, ["price1"] =  950, ["power"] = 1441, ["lvl"] = 5},
   { ["name"] = "unit462", ["kol"] = 16, ["id"] = 54, ["blocked"] = 0, ["price"] = 17500, ["price1"] = 1150, ["power"] = 1993, ["lvl"] = 6},
   { ["name"] = "unit472", ["kol"] =  6, ["id"] = 56, ["blocked"] = 0, ["price"] = 11200, ["price1"] = 3600, ["power"] = 5905, ["lvl"] = 7},
   { ["name"] = "unit413", ["kol"] =164, ["id"] =145, ["blocked"] = 0, ["price"] =  9130, ["price1"] =   70, ["power"] =  169, ["lvl"] = 1},
   { ["name"] = "unit423", ["kol"] =108, ["id"] =146, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  140, ["power"] =  308, ["lvl"] = 2},
   { ["name"] = "unit433", ["kol"] = 70, ["id"] =147, ["blocked"] = 0, ["price"] =  7200, ["price1"] =  250, ["power"] =  433, ["lvl"] = 3},
   { ["name"] = "unit443", ["kol"] = 36, ["id"] =148, ["blocked"] = 0, ["price"] = 11600, ["price1"] =  380, ["power"] =  846, ["lvl"] = 4},
   { ["name"] = "unit453", ["kol"] = 24, ["id"] =149, ["blocked"] = 0, ["price"] = 13365, ["price1"] =  950, ["power"] = 1441, ["lvl"] = 5},
   { ["name"] = "unit463", ["kol"] = 16, ["id"] =150, ["blocked"] = 0, ["price"] = 17500, ["price1"] = 1150, ["power"] = 1993, ["lvl"] = 6},
   { ["name"] = "unit473", ["kol"] =  6, ["id"] =151, ["blocked"] = 0, ["price"] = 11200, ["price1"] = 3600, ["power"] = 5905, ["lvl"] = 7}
};
array_units[5] = {
   { ["name"] = "unit511", ["kol"] =280, ["id"] = 57, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   55, ["power"] =  105, ["lvl"] = 1},
   { ["name"] = "unit521", ["kol"] =168, ["id"] = 59, ["blocked"] = 0, ["price"] = 12075, ["price1"] =  100, ["power"] =  172, ["lvl"] = 2},
   { ["name"] = "unit531", ["kol"] = 90, ["id"] = 61, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 3},
   { ["name"] = "unit541", ["kol"] = 45, ["id"] = 63, ["blocked"] = 0, ["price"] = 11375, ["price1"] =  380, ["power"] =  642, ["lvl"] = 4},
   { ["name"] = "unit551", ["kol"] = 30, ["id"] = 65, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  500, ["power"] = 1096, ["lvl"] = 5},
   { ["name"] = "unit561", ["kol"] = 14, ["id"] = 67, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1500, ["power"] = 2535, ["lvl"] = 6},
   { ["name"] = "unit571", ["kol"] =  6, ["id"] = 69, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6095, ["lvl"] = 7},
   { ["name"] = "unit512", ["kol"] =280, ["id"] = 58, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   55, ["power"] =  105, ["lvl"] = 1},
   { ["name"] = "unit522", ["kol"] =168, ["id"] = 60, ["blocked"] = 0, ["price"] = 12075, ["price1"] =  100, ["power"] =  172, ["lvl"] = 2},
   { ["name"] = "unit532", ["kol"] = 90, ["id"] = 62, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 3},
   { ["name"] = "unit542", ["kol"] = 45, ["id"] = 64, ["blocked"] = 0, ["price"] = 11375, ["price1"] =  380, ["power"] =  642, ["lvl"] = 4},
   { ["name"] = "unit552", ["kol"] = 30, ["id"] = 66, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  500, ["power"] = 1096, ["lvl"] = 5},
   { ["name"] = "unit562", ["kol"] = 14, ["id"] = 68, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1500, ["power"] = 2535, ["lvl"] = 5},
   { ["name"] = "unit572", ["kol"] =  6, ["id"] = 70, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6095, ["lvl"] = 5},
   { ["name"] = "unit513", ["kol"] =280, ["id"] =159, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   55, ["power"] =  105, ["lvl"] = 1},
   { ["name"] = "unit523", ["kol"] =168, ["id"] =160, ["blocked"] = 0, ["price"] = 12075, ["price1"] =  100, ["power"] =  172, ["lvl"] = 2},
   { ["name"] = "unit533", ["kol"] = 90, ["id"] =161, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 3},
   { ["name"] = "unit543", ["kol"] = 45, ["id"] =162, ["blocked"] = 0, ["price"] = 11375, ["price1"] =  380, ["power"] =  642, ["lvl"] = 4},
   { ["name"] = "unit553", ["kol"] = 30, ["id"] =163, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  500, ["power"] = 1096, ["lvl"] = 5},
   { ["name"] = "unit563", ["kol"] = 14, ["id"] =164, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1500, ["power"] = 2535, ["lvl"] = 6},
   { ["name"] = "unit573", ["kol"] =  6, ["id"] =165, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6095, ["lvl"] = 7}
};

array_units[6] = {
   { ["name"] = "unit611", ["kol"] = 98, ["id"] = 71, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  110, ["power"] =  290, ["lvl"] = 1},
   { ["name"] = "unit621", ["kol"] = 78, ["id"] = 73, ["blocked"] = 0, ["price"] = 12750, ["price1"] =  190, ["power"] =  477, ["lvl"] = 2},
   { ["name"] = "unit631", ["kol"] = 66, ["id"] = 75, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  200, ["power"] =  474, ["lvl"] = 3},
   { ["name"] = "unit641", ["kol"] = 36, ["id"] = 77, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  450, ["power"] =  812, ["lvl"] = 4},
   { ["name"] = "unit651", ["kol"] = 24, ["id"] = 79, ["blocked"] = 0, ["price"] = 11475, ["price1"] =  850, ["power"] = 1324, ["lvl"] = 5},
   { ["name"] = "unit661", ["kol"] = 14, ["id"] = 81, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1200, ["power"] = 2537, ["lvl"] = 6},
   { ["name"] = "unit671", ["kol"] =  6, ["id"] = 83, ["blocked"] = 0, ["price"] = 18400, ["price1"] = 3800, ["power"] = 6389, ["lvl"] = 7},
   { ["name"] = "unit612", ["kol"] = 98, ["id"] = 72, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  110, ["power"] =  290, ["lvl"] = 1},
   { ["name"] = "unit622", ["kol"] = 78, ["id"] = 74, ["blocked"] = 0, ["price"] = 12750, ["price1"] =  190, ["power"] =  477, ["lvl"] = 2},
   { ["name"] = "unit632", ["kol"] = 66, ["id"] = 76, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  200, ["power"] =  474, ["lvl"] = 3},
   { ["name"] = "unit642", ["kol"] = 36, ["id"] = 78, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  450, ["power"] =  812, ["lvl"] = 4},
   { ["name"] = "unit652", ["kol"] = 24, ["id"] = 80, ["blocked"] = 0, ["price"] = 11475, ["price1"] =  850, ["power"] = 1324, ["lvl"] = 5},
   { ["name"] = "unit662", ["kol"] = 14, ["id"] = 82, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1200, ["power"] = 2537, ["lvl"] = 6},
   { ["name"] = "unit672", ["kol"] =  6, ["id"] = 84, ["blocked"] = 0, ["price"] = 18400, ["price1"] = 3800, ["power"] = 6389, ["lvl"] = 7},
   { ["name"] = "unit613", ["kol"] = 98, ["id"] =138, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  110, ["power"] =  290, ["lvl"] = 1},
   { ["name"] = "unit623", ["kol"] = 78, ["id"] =139, ["blocked"] = 0, ["price"] = 12750, ["price1"] =  190, ["power"] =  477, ["lvl"] = 2},
   { ["name"] = "unit633", ["kol"] = 66, ["id"] =140, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  200, ["power"] =  474, ["lvl"] = 3},
   { ["name"] = "unit643", ["kol"] = 36, ["id"] =141, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  450, ["power"] =  812, ["lvl"] = 4},
   { ["name"] = "unit653", ["kol"] = 24, ["id"] =142, ["blocked"] = 0, ["price"] = 11475, ["price1"] =  850, ["power"] = 1324, ["lvl"] = 5},
   { ["name"] = "unit663", ["kol"] = 14, ["id"] =143, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1200, ["power"] = 2537, ["lvl"] = 6},
   { ["name"] = "unit673", ["kol"] =  6, ["id"] =144, ["blocked"] = 0, ["price"] = 18400, ["price1"] = 3800, ["power"] = 6389, ["lvl"] = 7}
};

array_units[7] = {
   { ["name"] = "unit711", ["kol"] =252, ["id"] = 92, ["blocked"] = 0, ["price"] =  9600, ["price1"] =   65, ["power"] =  115, ["lvl"] = 1},
   { ["name"] = "unit721", ["kol"] =168, ["id"] = 94, ["blocked"] = 0, ["price"] = 11000, ["price1"] =   90, ["power"] =  171, ["lvl"] = 2},
   { ["name"] = "unit731", ["kol"] = 70, ["id"] = 96, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  250, ["power"] =  419, ["lvl"] = 3},
   { ["name"] = "unit741", ["kol"] = 66, ["id"] = 98, ["blocked"] = 0, ["price"] = 10150, ["price1"] =  230, ["power"] =  434, ["lvl"] = 4},
   { ["name"] = "unit751", ["kol"] = 27, ["id"] =100, ["blocked"] = 0, ["price"] = 10650, ["price1"] =  650, ["power"] = 1308, ["lvl"] = 5},
   { ["name"] = "unit761", ["kol"] = 14, ["id"] =102, ["blocked"] = 0, ["price"] = 14000, ["price1"] = 1600, ["power"] = 2437, ["lvl"] = 6},
   { ["name"] = "unit771", ["kol"] =  6, ["id"] =104, ["blocked"] = 0, ["price"] = 12000, ["price1"] = 3400, ["power"] = 6070, ["lvl"] = 7},
   { ["name"] = "unit712", ["kol"] =252, ["id"] = 93, ["blocked"] = 0, ["price"] =  9600, ["price1"] =   65, ["power"] =  115, ["lvl"] = 1},
   { ["name"] = "unit722", ["kol"] =168, ["id"] = 95, ["blocked"] = 0, ["price"] = 11000, ["price1"] =   90, ["power"] =  171, ["lvl"] = 2},
   { ["name"] = "unit732", ["kol"] = 70, ["id"] = 97, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  250, ["power"] =  419, ["lvl"] = 3},
   { ["name"] = "unit742", ["kol"] = 66, ["id"] = 99, ["blocked"] = 0, ["price"] = 10150, ["price1"] =  230, ["power"] =  434, ["lvl"] = 4},
   { ["name"] = "unit752", ["kol"] = 27, ["id"] =101, ["blocked"] = 0, ["price"] = 10650, ["price1"] =  650, ["power"] = 1308, ["lvl"] = 5},
   { ["name"] = "unit762", ["kol"] = 14, ["id"] =103, ["blocked"] = 0, ["price"] = 14000, ["price1"] = 1600, ["power"] = 2437, ["lvl"] = 6},
   { ["name"] = "unit772", ["kol"] =  6, ["id"] =105, ["blocked"] = 0, ["price"] = 12000, ["price1"] = 3400, ["power"] = 6070, ["lvl"] = 7},
   { ["name"] = "unit713", ["kol"] =252, ["id"] =166, ["blocked"] = 0, ["price"] =  9600, ["price1"] =   65, ["power"] =  115, ["lvl"] = 1},
   { ["name"] = "unit723", ["kol"] =168, ["id"] =167, ["blocked"] = 0, ["price"] = 11000, ["price1"] =   90, ["power"] =  171, ["lvl"] = 2},
   { ["name"] = "unit733", ["kol"] = 70, ["id"] =168, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  250, ["power"] =  419, ["lvl"] = 3},
   { ["name"] = "unit743", ["kol"] = 66, ["id"] =169, ["blocked"] = 0, ["price"] = 10150, ["price1"] =  230, ["power"] =  434, ["lvl"] = 4},
   { ["name"] = "unit753", ["kol"] = 27, ["id"] =170, ["blocked"] = 0, ["price"] = 10650, ["price1"] =  650, ["power"] = 1308, ["lvl"] = 5},
   { ["name"] = "unit763", ["kol"] = 14, ["id"] =171, ["blocked"] = 0, ["price"] = 14000, ["price1"] = 1600, ["power"] = 2437, ["lvl"] = 6},
   { ["name"] = "unit773", ["kol"] =  6, ["id"] =172, ["blocked"] = 0, ["price"] = 12000, ["price1"] = 3400, ["power"] = 6070, ["lvl"] = 7}
};

array_units[8] = {
   { ["name"] = "unit811", ["kol"] =386, ["id"] =117, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   35, ["power"] =   66, ["lvl"] = 1},
   { ["name"] = "unit821", ["kol"] =168, ["id"] =119, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  110, ["power"] =  174, ["lvl"] = 2},
   { ["name"] = "unit831", ["kol"] =110, ["id"] =121, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  140, ["power"] =  254, ["lvl"] = 3},
   { ["name"] = "unit841", ["kol"] = 45, ["id"] =123, ["blocked"] = 0, ["price"] = 10575, ["price1"] =  420, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit851", ["kol"] = 40, ["id"] =125, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  550, ["power"] =  895, ["lvl"] = 5},
   { ["name"] = "unit861", ["kol"] = 14, ["id"] =127, ["blocked"] = 0, ["price"] = 17775, ["price1"] = 1200, ["power"] = 2571, ["lvl"] = 6},
   { ["name"] = "unit871", ["kol"] =  6, ["id"] =129, ["blocked"] = 0, ["price"] = 14100, ["price1"] = 3600, ["power"] = 5937, ["lvl"] = 7},
   { ["name"] = "unit812", ["kol"] =386, ["id"] =118, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   35, ["power"] =   66, ["lvl"] = 1},
   { ["name"] = "unit822", ["kol"] =168, ["id"] =120, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  110, ["power"] =  174, ["lvl"] = 2},
   { ["name"] = "unit832", ["kol"] =110, ["id"] =122, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  140, ["power"] =  254, ["lvl"] = 3},
   { ["name"] = "unit842", ["kol"] = 45, ["id"] =124, ["blocked"] = 0, ["price"] = 10575, ["price1"] =  420, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit852", ["kol"] = 40, ["id"] =126, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  550, ["power"] =  895, ["lvl"] = 5},
   { ["name"] = "unit862", ["kol"] = 14, ["id"] =128, ["blocked"] = 0, ["price"] = 17775, ["price1"] = 1200, ["power"] = 2571, ["lvl"] = 6},
   { ["name"] = "unit872", ["kol"] =  6, ["id"] =130, ["blocked"] = 0, ["price"] = 14100, ["price1"] = 3600, ["power"] = 5937, ["lvl"] = 7},
   { ["name"] = "unit813", ["kol"] =386, ["id"] =173, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   35, ["power"] =   66, ["lvl"] = 1},
   { ["name"] = "unit823", ["kol"] =168, ["id"] =174, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  110, ["power"] =  174, ["lvl"] = 2},
   { ["name"] = "unit833", ["kol"] =110, ["id"] =175, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  140, ["power"] =  254, ["lvl"] = 3},
   { ["name"] = "unit843", ["kol"] = 45, ["id"] =176, ["blocked"] = 0, ["price"] = 10575, ["price1"] =  420, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit853", ["kol"] = 40, ["id"] =177, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  550, ["power"] =  895, ["lvl"] = 5},
   { ["name"] = "unit863", ["kol"] = 14, ["id"] =178, ["blocked"] = 0, ["price"] = 17775, ["price1"] = 1200, ["power"] = 2571, ["lvl"] = 6},
   { ["name"] = "unit873", ["kol"] =  6, ["id"] =179, ["blocked"] = 0, ["price"] = 14100, ["price1"] = 3600, ["power"] = 5937, ["lvl"] = 7}
};

------------------ HEROES ------------------------
array_heroes={};
array_heroes[0] = {
	 { ["name"] = "Orrin",       ["name2"] = "Orrin2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  35, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroDugal.txt",      ["p1"] = "hero_1_1_1", ["p2"] = "hero_1_1_2", ["p3"] = "hero_1_1_3", ["p4"] = "hero_1_1_4", ["p5"] = "hero_1_1_5", ["p6"] = "hero_1_1_6", ["p7"] = "hero_1_1_7", ["p8"] = "hero_1_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt" },
	 { ["name"] = "Sarge",       ["name2"] = "Sarge2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  55, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroAksel.txt",      ["p1"] = "hero_2_1_1", ["p2"] = "hero_2_1_2", ["p3"] = "hero_2_1_3", ["p4"] = "hero_2_1_4", ["p5"] = "hero_2_1_5", ["p6"] = "hero_2_1_6", ["p7"] = "hero_2_1_7", ["p8"] = "hero_2_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Jouster/Description.txt"},
	 { ["name"] = "Mardigo",     ["name2"] = "Mardigo2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroLaslo.txt",      ["p1"] = "hero_3_1_1", ["p2"] = "hero_3_1_2", ["p3"] = "hero_3_1_3", ["p4"] = "hero_3_1_4", ["p5"] = "hero_3_1_5", ["p6"] = "hero_3_1_6", ["p7"] = "hero_3_1_7", ["p8"] = "hero_3_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Infantry_Commander/Description.txt"},
	 { ["name"] = "Brem",        ["name2"] = "Brem2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  13, ["skill2"] =  13, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRutger.txt",     ["p1"] = "hero_4_1_1", ["p2"] = "hero_4_1_2", ["p3"] = "hero_4_1_3", ["p4"] = "hero_4_1_4", ["p5"] = "hero_4_1_5", ["p6"] = "hero_4_1_6", ["p7"] = "hero_4_1_7", ["p8"] = "hero_4_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Wanderer/Description.txt"},
	 { ["name"] = "Maeve",       ["name2"] = "Maeve2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  51, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMiv.txt",        ["p1"] = "hero_5_1_1", ["p2"] = "hero_5_1_2", ["p3"] = "hero_5_1_3", ["p4"] = "hero_5_1_4", ["p5"] = "hero_5_1_5", ["p6"] = "hero_5_1_6", ["p7"] = "hero_5_1_7", ["p8"] = "hero_5_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Expediter/Description.txt"},
	 { ["name"] = "Ving",        ["name2"] = "Ving2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  31, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAiris.txt",      ["p1"] = "hero_6_1_1", ["p2"] = "hero_6_1_2", ["p3"] = "hero_6_1_3", ["p4"] = "hero_6_1_4", ["p5"] = "hero_6_1_5", ["p6"] = "hero_6_1_6", ["p7"] = "hero_6_1_7", ["p8"] = "hero_6_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Griffon_Commander/Description.txt"},
	 { ["name"] = "Nathaniel",   ["name2"] = "Nathaniel2",   ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  28, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroEllaina.txt",    ["p1"] = "hero_7_1_1", ["p2"] = "hero_7_1_2", ["p3"] = "hero_7_1_3", ["p4"] = "hero_7_1_4", ["p5"] = "hero_7_1_5", ["p6"] = "hero_7_1_6", ["p7"] = "hero_7_1_7", ["p8"] = "hero_7_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Squire/Description.txt"},
	 { ["name"] = "Christian",   ["name2"] = "Christian2",   ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  23, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroVittorio.txt",   ["p1"] = "hero_8_1_1", ["p2"] = "hero_8_1_2", ["p3"] = "hero_8_1_3", ["p4"] = "hero_8_1_4", ["p5"] = "hero_8_1_5", ["p6"] = "hero_8_1_6", ["p7"] = "hero_8_1_7", ["p8"] = "hero_8_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Artilleryman/Description.txt"},
	 { ["name"] = "Godric",      ["name2"] = "Godric2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  56, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGodric.txt",     ["p1"] = "hero_9_1_1", ["p2"] = "hero_9_1_2", ["p3"] = "hero_9_1_3", ["p4"] = "hero_9_1_4", ["p5"] = "hero_9_1_5", ["p6"] = "hero_9_1_6", ["p7"] = "hero_9_1_7", ["p8"] = "hero_9_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/White_Knight/Description.txt"},
   {["name"]="RedHeavenHero03",["name2"]="RedHeavenHero032",["blocked"] = 0,["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  10, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroValeria.txt",    ["p1"] = "hero_13_1_1",["p2"] = "hero_13_1_2",["p3"] = "hero_13_1_3",["p4"] = "hero_13_1_4",["p5"] = "hero_13_1_5",["p6"] = "hero_13_1_6",["p7"] = "hero_13_1_7",["p8"] = "hero_13_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/SpecValeria/Description.txt"},
	 { ["name"] = "Isabell_A1",  ["name2"] = "Isabell_A12",  ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIsabel.txt",     ["p1"] = "hero_11_1_1",["p2"] = "hero_11_1_2",["p3"] = "hero_11_1_3",["p4"] = "hero_11_1_4",["p5"] = "hero_11_1_5",["p6"] = "hero_11_1_6",["p7"] = "hero_11_1_7",["p8"] = "hero_11_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"},
	 { ["name"] = "Duncan",      ["name2"] = "Duncan2",      ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroDuncan.txt",     ["p1"] = "hero_12_1_1",["p2"] = "hero_12_1_2",["p3"] = "hero_12_1_3",["p4"] = "hero_12_1_4",["p5"] = "hero_12_1_5",["p6"] = "hero_12_1_6",["p7"] = "hero_12_1_7",["p8"] = "hero_12_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"},
   { ["name"] = "Nicolai",     ["name2"] = "Nicolai2",     ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  13, ["skill2"] =  13, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroNicolai.txt",    ["p1"] = "hero_10_1_1",["p2"] = "hero_10_1_2",["p3"] = "hero_10_1_3",["p4"] = "hero_10_1_4",["p5"] = "hero_10_1_5",["p6"] = "hero_10_1_6",["p7"] = "hero_10_1_7",["p8"] = "hero_10_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"}
};

array_heroes[1] = {
	 { ["name"] = "Grok",        ["name2"] = "Grok2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   1, ["skill2"] =  19, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroGrok.txt",       ["p1"] = "hero_1_2_1", ["p2"] = "hero_1_2_2", ["p3"] = "hero_1_2_3", ["p4"] = "hero_1_2_4", ["p5"] = "hero_1_2_5", ["p6"] = "hero_1_2_6", ["p7"] = "hero_1_2_7", ["p8"] = "hero_1_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt" },
	 { ["name"] = "Oddrema",     ["name2"] = "Oddrema2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  41, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroDgezebet.txt",   ["p1"] = "hero_2_2_1", ["p2"] = "hero_2_2_2", ["p3"] = "hero_2_2_3", ["p4"] = "hero_2_2_4", ["p5"] = "hero_2_2_5", ["p6"] = "hero_2_2_6", ["p7"] = "hero_2_2_7", ["p8"] = "hero_2_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Temptress/Description.txt" },
	 { ["name"] = "Marder",      ["name2"] = "Marder2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  37, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMarbas.txt",     ["p1"] = "hero_3_2_1", ["p2"] = "hero_3_2_2", ["p3"] = "hero_3_2_3", ["p4"] = "hero_3_2_4", ["p5"] = "hero_3_2_5", ["p6"] = "hero_3_2_6", ["p7"] = "hero_3_2_7", ["p8"] = "hero_3_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Impregnable/Description.txt" },
	 { ["name"] = "Jazaz",       ["name2"] = "Jazaz2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNibros.txt",     ["p1"] = "hero_4_2_1", ["p2"] = "hero_4_2_2", ["p3"] = "hero_4_2_3", ["p4"] = "hero_4_2_4", ["p5"] = "hero_4_2_5", ["p6"] = "hero_4_2_6", ["p7"] = "hero_4_2_7", ["p8"] = "hero_4_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Flagbearer_of_Darkness/Description.txt" },
	 { ["name"] = "Efion",       ["name2"] = "Efion2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  10, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAlastor.txt",    ["p1"] = "hero_5_2_1", ["p2"] = "hero_5_2_2", ["p3"] = "hero_5_2_3", ["p4"] = "hero_5_2_4", ["p5"] = "hero_5_2_5", ["p6"] = "hero_5_2_6", ["p7"] = "hero_5_2_7", ["p8"] = "hero_5_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Hypnotist/Description.txt" },
	 { ["name"] = "Deleb",       ["name2"] = "Deleb2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  23, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDeleb.txt",      ["p1"] = "hero_6_2_1", ["p2"] = "hero_6_2_2", ["p3"] = "hero_6_2_3", ["p4"] = "hero_6_2_4", ["p5"] = "hero_6_2_5", ["p6"] = "hero_6_2_6", ["p7"] = "hero_6_2_7", ["p8"] = "hero_6_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Bombardier/Description.txt" },
	 { ["name"] = "Calid",       ["name2"] = "Calid2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  59, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGrol.txt",       ["p1"] = "hero_7_2_1", ["p2"] = "hero_7_2_2", ["p3"] = "hero_7_2_3", ["p4"] = "hero_7_2_4", ["p5"] = "hero_7_2_5", ["p6"] = "hero_7_2_6", ["p7"] = "hero_7_2_7", ["p8"] = "hero_7_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Breeder/Description.txt" },
	 { ["name"] = "Nymus",       ["name2"] = "Nymus2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  31, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNimus.txt",      ["p1"] = "hero_8_2_1", ["p2"] = "hero_8_2_2", ["p3"] = "hero_8_2_3", ["p4"] = "hero_8_2_4", ["p5"] = "hero_8_2_5", ["p6"] = "hero_8_2_6", ["p7"] = "hero_8_2_7", ["p8"] = "hero_8_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Gate_Keeper/Description.txt" },
	 { ["name"] = "Orlando",     ["name2"] = "Orlando2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  60, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOrlando.txt",    ["p1"] = "hero_9_2_1", ["p2"] = "hero_9_2_2", ["p3"] = "hero_9_2_3", ["p4"] = "hero_9_2_4", ["p5"] = "hero_9_2_5", ["p6"] = "hero_9_2_6", ["p7"] = "hero_9_2_7", ["p8"] = "hero_9_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/SpecOrlando/Description.txt" },
	 { ["name"] = "Agrael",      ["name2"] = "Agrael2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  36, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAgrail.txt",     ["p1"] = "hero_10_2_1",["p2"] = "hero_10_2_2",["p3"] = "hero_10_2_3",["p4"] = "hero_10_2_4",["p5"] = "hero_10_2_5",["p6"] = "hero_10_2_6",["p7"] = "hero_10_2_7",["p8"] = "hero_10_2_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/SpecAgrael/Description.txt" },
	 { ["name"] = "Kha-Beleth",  ["name2"] = "Kha-Beleth2",  ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  59, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVlastelin.txt",  ["p1"] = "hero_11_2_1",["p2"] = "hero_11_2_2",["p3"] = "hero_11_2_3",["p4"] = "hero_11_2_4",["p5"] = "hero_11_2_5",["p6"] = "hero_11_2_6",["p7"] = "hero_11_2_7",["p8"] = "hero_11_2_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt" }
};

array_heroes[2] = {
	 { ["name"] = "Nemor",       ["name2"] = "Nemor2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  63, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDeidra.txt",     ["p1"] = "hero_1_3_1", ["p2"] = "hero_1_3_2", ["p3"] = "hero_1_3_3", ["p4"] = "hero_1_3_4", ["p5"] = "hero_1_3_5", ["p6"] = "hero_1_3_6", ["p7"] = "hero_1_3_7", ["p8"] = "hero_1_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Dark_Emissary/Description.txt" },
	 { ["name"] = "Tamika",      ["name2"] = "Tamika2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  42, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroLukrecia.txt",   ["p1"] = "hero_2_3_1", ["p2"] = "hero_2_3_2", ["p3"] = "hero_2_3_3", ["p4"] = "hero_2_3_4", ["p5"] = "hero_2_3_5", ["p6"] = "hero_2_3_6", ["p7"] = "hero_2_3_7", ["p8"] = "hero_2_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Vamipre_Princess/Description.txt" },
	 { ["name"] = "Muscip",      ["name2"] = "Muscip2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  10, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNaadir.txt",     ["p1"] = "hero_3_3_1", ["p2"] = "hero_3_3_2", ["p3"] = "hero_3_3_3", ["p4"] = "hero_3_3_4", ["p5"] = "hero_3_3_5", ["p6"] = "hero_3_3_6", ["p7"] = "hero_3_3_7", ["p8"] = "hero_3_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Soulhunter/Description.txt" },
	 { ["name"] = "Aberrar",     ["name2"] = "Aberrar2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroZoltan.txt",     ["p1"] = "hero_4_3_1", ["p2"] = "hero_4_3_2", ["p3"] = "hero_4_3_3", ["p4"] = "hero_4_3_4", ["p5"] = "hero_4_3_5", ["p6"] = "hero_4_3_6", ["p7"] = "hero_4_3_7", ["p8"] = "hero_4_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Mind_Cleaner/Description.txt" },
	 { ["name"] = "Straker",     ["name2"] = "Straker2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOrson.txt",      ["p1"] = "hero_5_3_1", ["p2"] = "hero_5_3_2", ["p3"] = "hero_5_3_3", ["p4"] = "hero_5_3_4", ["p5"] = "hero_5_3_5", ["p6"] = "hero_5_3_6", ["p7"] = "hero_5_3_7", ["p8"] = "hero_5_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Zombie_Leader/Description.txt" },
	 { ["name"] = "Effig",       ["name2"] = "Effig2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  46, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRavenna.txt",    ["p1"] = "hero_6_3_1", ["p2"] = "hero_6_3_2", ["p3"] = "hero_6_3_3", ["p4"] = "hero_6_3_4", ["p5"] = "hero_6_3_5", ["p6"] = "hero_6_3_6", ["p7"] = "hero_6_3_7", ["p8"] = "hero_6_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Maledictor/Description.txt" },
	 { ["name"] = "Pelt",        ["name2"] = "Pelt2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  54, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVlad.txt",       ["p1"] = "hero_7_3_1", ["p2"] = "hero_7_3_2", ["p3"] = "hero_7_3_3", ["p4"] = "hero_7_3_4", ["p5"] = "hero_7_3_5", ["p6"] = "hero_7_3_6", ["p7"] = "hero_7_3_7", ["p8"] = "hero_7_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Reanimator/Description.txt" },
	 { ["name"] = "Gles",        ["name2"] = "Gles2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  22, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroKaspar.txt",     ["p1"] = "hero_8_3_1", ["p2"] = "hero_8_3_2", ["p3"] = "hero_8_3_3", ["p4"] = "hero_8_3_4", ["p5"] = "hero_8_3_5", ["p6"] = "hero_8_3_6", ["p7"] = "hero_8_3_7", ["p8"] = "hero_8_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Empiric/Description.txt" },
	 { ["name"] = "Arantir",     ["name2"] = "Arantir2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] = 108, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroArantir.txt",    ["p1"] = "hero_9_3_1", ["p2"] = "hero_9_3_2", ["p3"] = "hero_9_3_3", ["p4"] = "hero_9_3_4", ["p5"] = "hero_9_3_5", ["p6"] = "hero_9_3_6", ["p7"] = "hero_9_3_7", ["p8"] = "hero_9_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/AvatarOfDeath/Description.txt" },
	 { ["name"] = "OrnellaNecro",["name2"] = "OrnellaNecro2",["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  62, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOrnella.txt",    ["p1"] = "hero_10_3_1",["p2"] = "hero_10_3_2",["p3"] = "hero_10_3_3",["p4"] = "hero_10_3_4",["p5"] = "hero_10_3_5",["p6"] = "hero_10_3_6",["p7"] = "hero_10_3_7",["p8"] = "hero_10_3_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/SpecOrnella/Description.txt" },
   { ["name"] = "Berein",      ["name2"] = "Berein2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  15, ["skill2"] =  15, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMarkel.txt",     ["p1"] = "hero_11_3_1",["p2"] = "hero_11_3_2",["p3"] = "hero_11_3_3",["p4"] = "hero_11_3_4",["p5"] = "hero_11_3_5",["p6"] = "hero_11_3_6",["p7"] = "hero_11_3_7",["p8"] = "hero_11_3_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Heir_of_Undeath/Berein.txt" },
   { ["name"] = "Nikolas",     ["name2"] = "Nikolas2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =   3, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNikolas.txt",    ["p1"] = "hero_12_3_1",["p2"] = "hero_12_3_2",["p3"] = "hero_12_3_3",["p4"] = "hero_12_3_4",["p5"] = "hero_12_3_5",["p6"] = "hero_12_3_6",["p7"] = "hero_12_3_7",["p8"] = "hero_12_3_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/SpecNikolas/Description.txt" }
};

array_heroes[3] = {
	 { ["name"] = "Metlirn",     ["name2"] = "Metlirn2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  16, ["skill2"] =  16, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAnven.txt",      ["p1"] = "hero_1_4_1", ["p2"] = "hero_1_4_2", ["p3"] = "hero_1_4_3", ["p4"] = "hero_1_4_4", ["p5"] = "hero_1_4_5", ["p6"] = "hero_1_4_6", ["p7"] = "hero_1_4_7", ["p8"] = "hero_1_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt" },
	 { ["name"] = "Gillion",     ["name2"] = "Gillion2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGilraen.txt",    ["p1"] = "hero_2_4_1", ["p2"] = "hero_2_4_2", ["p3"] = "hero_2_4_3", ["p4"] = "hero_2_4_4", ["p5"] = "hero_2_4_5", ["p6"] = "hero_2_4_6", ["p7"] = "hero_2_4_7", ["p8"] = "hero_2_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Blade_Master/Description.txt" },
	 { ["name"] = "Nadaur",      ["name2"] = "Nadaur2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  28, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroTalanar.txt",    ["p1"] = "hero_3_4_1", ["p2"] = "hero_3_4_2", ["p3"] = "hero_3_4_3", ["p4"] = "hero_3_4_4", ["p5"] = "hero_3_4_5", ["p6"] = "hero_3_4_6", ["p7"] = "hero_3_4_7", ["p8"] = "hero_3_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Elven_Fury/Description.txt" },
	 { ["name"] = "Diraya",      ["name2"] = "Diraya2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  53, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDirael.txt",     ["p1"] = "hero_4_4_1", ["p2"] = "hero_4_4_2", ["p3"] = "hero_4_4_3", ["p4"] = "hero_4_4_4", ["p5"] = "hero_4_4_5", ["p6"] = "hero_4_4_6", ["p7"] = "hero_4_4_7", ["p8"] = "hero_4_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Call_of_the_Wasp/Description.txt" },
	 { ["name"] = "Ossir",       ["name2"] = "Ossir2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  31, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOssir.txt",      ["p1"] = "hero_5_4_1", ["p2"] = "hero_5_4_2", ["p3"] = "hero_5_4_3", ["p4"] = "hero_5_4_4", ["p5"] = "hero_5_4_5", ["p6"] = "hero_5_4_6", ["p7"] = "hero_5_4_7", ["p8"] = "hero_5_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Hunter/Description.txt" },
	 { ["name"] = "Itil",        ["name2"] = "Itil2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  49, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIlfina.txt",     ["p1"] = "hero_6_4_1", ["p2"] = "hero_6_4_2", ["p3"] = "hero_6_4_3", ["p4"] = "hero_6_4_4", ["p5"] = "hero_6_4_5", ["p6"] = "hero_6_4_6", ["p7"] = "hero_6_4_7", ["p8"] = "hero_6_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Unicorn_Trainer/Description.txt" },
	 { ["name"] = "Elleshar",    ["name2"] = "Elleshar2",    ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVinrael.txt",    ["p1"] = "hero_7_4_1", ["p2"] = "hero_7_4_2", ["p3"] = "hero_7_4_3", ["p4"] = "hero_7_4_4", ["p5"] = "hero_7_4_5", ["p6"] = "hero_7_4_6", ["p7"] = "hero_7_4_7", ["p8"] = "hero_7_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Talented_Warrior/Description.txt" },
	 { ["name"] = "Linaas",      ["name2"] = "Linaas2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVingael.txt",    ["p1"] = "hero_8_4_1", ["p2"] = "hero_8_4_2", ["p3"] = "hero_8_4_3", ["p4"] = "hero_8_4_4", ["p5"] = "hero_8_4_5", ["p6"] = "hero_8_4_6", ["p7"] = "hero_8_4_7", ["p8"] = "hero_8_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Waylayer/Description.txt" },
	 { ["name"] = "Heam",        ["name2"] = "Heam2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  35, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroFaidaen.txt",    ["p1"] = "hero_9_4_1", ["p2"] = "hero_9_4_2", ["p3"] = "hero_9_4_3", ["p4"] = "hero_9_4_4", ["p5"] = "hero_9_4_5", ["p6"] = "hero_9_4_6", ["p7"] = "hero_9_4_7", ["p8"] = "hero_9_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Elven_Volley/Description.txt" },
	 { ["name"] = "Ildar",       ["name2"] = "Ildar2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAlaron.txt",     ["p1"] = "hero_10_4_1",["p2"] = "hero_10_4_2",["p3"] = "hero_10_4_3",["p4"] = "hero_10_4_4",["p5"] = "hero_10_4_5",["p6"] = "hero_10_4_6",["p7"] = "hero_10_4_7",["p8"] = "hero_10_4_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/SpecIldar/Description.txt" },
	 { ["name"] = "GhostFSLord", ["name2"] = "GhostFSLord2", ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  12, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroPrizrak.txt",    ["p1"] = "hero_11_4_1",["p2"] = "hero_11_4_2",["p3"] = "hero_11_4_3",["p4"] = "hero_11_4_4",["p5"] = "hero_11_4_5",["p6"] = "hero_11_4_6",["p7"] = "hero_11_4_7",["p8"] = "hero_11_4_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt" }
};

array_heroes[4] = {
	 { ["name"] = "Faiz",        ["name2"] = "Faiz2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  48, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroFaiz.txt",       ["p1"] = "hero_1_5_1", ["p2"] = "hero_1_5_2", ["p3"] = "hero_1_5_3", ["p4"] = "hero_1_5_4", ["p5"] = "hero_1_5_5", ["p6"] = "hero_1_5_6", ["p7"] = "hero_1_5_7", ["p8"] = "hero_1_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Disrupter/Description.txt" },
	 { ["name"] = "Havez",       ["name2"] = "Havez2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  68, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroHafiz.txt",      ["p1"] = "hero_2_5_1", ["p2"] = "hero_2_5_2", ["p3"] = "hero_2_5_3", ["p4"] = "hero_2_5_4", ["p5"] = "hero_2_5_5", ["p6"] = "hero_2_5_6", ["p7"] = "hero_2_5_7", ["p8"] = "hero_2_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Artisan/Description.txt" },
	 { ["name"] = "Nur",         ["name2"] = "Nur2",         ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  44, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNazir.txt",      ["p1"] = "hero_3_5_1", ["p2"] = "hero_3_5_2", ["p3"] = "hero_3_5_3", ["p4"] = "hero_3_5_4", ["p5"] = "hero_3_5_5", ["p6"] = "hero_3_5_6", ["p7"] = "hero_3_5_7", ["p8"] = "hero_3_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Weilder_of_Fire/Description.txt" },
	 { ["name"] = "Astral",      ["name2"] = "Astral2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  67, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroNura.txt",       ["p1"] = "hero_4_5_1", ["p2"] = "hero_4_5_2", ["p3"] = "hero_4_5_3", ["p4"] = "hero_4_5_4", ["p5"] = "hero_4_5_5", ["p6"] = "hero_4_5_6", ["p7"] = "hero_4_5_7", ["p8"] = "hero_4_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Inexhaustible/Description.txt" },
	 { ["name"] = "Sufi",        ["name2"] = "Sufi2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  42, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOra.txt",        ["p1"] = "hero_5_5_1", ["p2"] = "hero_5_5_2", ["p3"] = "hero_5_5_3", ["p4"] = "hero_5_5_4", ["p5"] = "hero_5_5_5", ["p6"] = "hero_5_5_6", ["p7"] = "hero_5_5_7", ["p8"] = "hero_5_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Feather_Mage/Description.txt" },
	 { ["name"] = "Razzak",      ["name2"] = "Razzak2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNarhiz.txt",     ["p1"] = "hero_6_5_1", ["p2"] = "hero_6_5_2", ["p3"] = "hero_6_5_3", ["p4"] = "hero_6_5_4", ["p5"] = "hero_6_5_5", ["p6"] = "hero_6_5_6", ["p7"] = "hero_6_5_7", ["p8"] = "hero_6_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Mentor/Description.txt" },
	 { ["name"] = "Tan",         ["name2"] = "Tan2",         ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  69, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDgalib.txt",     ["p1"] = "hero_7_5_1", ["p2"] = "hero_7_5_2", ["p3"] = "hero_7_5_3", ["p4"] = "hero_7_5_4", ["p5"] = "hero_7_5_5", ["p6"] = "hero_7_5_6", ["p7"] = "hero_7_5_7", ["p8"] = "hero_7_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Radiant/Description.txt" },
	 { ["name"] = "Isher",       ["name2"] = "Isher2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRazzak.txt",     ["p1"] = "hero_8_5_1", ["p2"] = "hero_8_5_2", ["p3"] = "hero_8_5_3", ["p4"] = "hero_8_5_4", ["p5"] = "hero_8_5_5", ["p6"] = "hero_8_5_6", ["p7"] = "hero_8_5_7", ["p8"] = "hero_8_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Machinist/Description.txt" },
	 { ["name"] = "Zehir",       ["name2"] = "Zehir2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  53, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroZehir.txt",      ["p1"] = "hero_9_5_1", ["p2"] = "hero_9_5_2", ["p3"] = "hero_9_5_3", ["p4"] = "hero_9_5_4", ["p5"] = "hero_9_5_5", ["p6"] = "hero_9_5_6", ["p7"] = "hero_9_5_7", ["p8"] = "hero_9_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Master_of_Elements/Description.txt" },
	 { ["name"] = "Maahir",      ["name2"] = "Maahir2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  17, ["skill2"] =  17, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMaahir.txt",     ["p1"] = "hero_10_5_1",["p2"] = "hero_10_5_2",["p3"] = "hero_10_5_3",["p4"] = "hero_10_5_4",["p5"] = "hero_10_5_5",["p6"] = "hero_10_5_6",["p7"] = "hero_10_5_7",["p8"] = "hero_10_5_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/SpecMaahir/Description.txt" },
	 { ["name"] = "Cyrus",       ["name2"] = "Cyrus2",       ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroSairus.txt",     ["p1"] = "hero_11_5_1",["p2"] = "hero_11_5_2",["p3"] = "hero_11_5_3",["p4"] = "hero_11_5_4",["p5"] = "hero_11_5_5",["p6"] = "hero_11_5_6",["p7"] = "hero_11_5_7",["p8"] = "hero_11_5_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/SpecCyrus/Description.txt" }
};

array_heroes[5] = {
	 { ["name"] = "Eruina",      ["name2"] = "Eruina2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =   9, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroErin.txt",       ["p1"] = "hero_1_6_1", ["p2"] = "hero_1_6_2", ["p3"] = "hero_1_6_3", ["p4"] = "hero_1_6_4", ["p5"] = "hero_1_6_5", ["p6"] = "hero_1_6_6", ["p7"] = "hero_1_6_7", ["p8"] = "hero_1_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Matron_Salvo/Description.txt" },
	 { ["name"] = "Inagost",     ["name2"] = "Inagost2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  70, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroSinitar.txt",    ["p1"] = "hero_2_6_1", ["p2"] = "hero_2_6_2", ["p3"] = "hero_2_6_3", ["p4"] = "hero_2_6_4", ["p5"] = "hero_2_6_5", ["p6"] = "hero_2_6_6", ["p7"] = "hero_2_6_7", ["p8"] = "hero_2_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Power_Bargain/Description.txt" },
	 { ["name"] = "Urunir",      ["name2"] = "Urunir2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIranna.txt",     ["p1"] = "hero_3_6_1", ["p2"] = "hero_3_6_2", ["p3"] = "hero_3_6_3", ["p4"] = "hero_3_6_4", ["p5"] = "hero_3_6_5", ["p6"] = "hero_3_6_6", ["p7"] = "hero_3_6_7", ["p8"] = "hero_3_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Seducer/Description.txt" },
	 { ["name"] = "Almegir",     ["name2"] = "Almegir2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  71, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroIrbet.txt",      ["p1"] = "hero_4_6_1", ["p2"] = "hero_4_6_2", ["p3"] = "hero_4_6_3", ["p4"] = "hero_4_6_4", ["p5"] = "hero_4_6_5", ["p6"] = "hero_4_6_6", ["p7"] = "hero_4_6_7", ["p8"] = "hero_4_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Dark_Acolyte/Description.txt" },
	 { ["name"] = "Menel",       ["name2"] = "Menel2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  29, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKifra.txt",      ["p1"] = "hero_5_6_1", ["p2"] = "hero_5_6_2", ["p3"] = "hero_5_6_3", ["p4"] = "hero_5_6_4", ["p5"] = "hero_5_6_5", ["p6"] = "hero_5_6_6", ["p7"] = "hero_5_6_7", ["p8"] = "hero_5_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Slaveholder/Description.txt" },
	 { ["name"] = "Dalom",       ["name2"] = "Dalom2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  48, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroLetos.txt",      ["p1"] = "hero_6_6_1", ["p2"] = "hero_6_6_2", ["p3"] = "hero_6_6_3", ["p4"] = "hero_6_6_4", ["p5"] = "hero_6_6_5", ["p6"] = "hero_6_6_6", ["p7"] = "hero_6_6_7", ["p8"] = "hero_6_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Poisoner/Description.txt" },
	 { ["name"] = "Ferigl",      ["name2"] = "Ferigl2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  36, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroSorgal.txt",     ["p1"] = "hero_7_6_1", ["p2"] = "hero_7_6_2", ["p3"] = "hero_7_6_3", ["p4"] = "hero_7_6_4", ["p5"] = "hero_7_6_5", ["p6"] = "hero_7_6_6", ["p7"] = "hero_7_6_7", ["p8"] = "hero_7_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Lizard_Breeder/Description.txt" },
	 { ["name"] = "Ohtarig",     ["name2"] = "Ohtarig2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  32, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVaishan.txt",    ["p1"] = "hero_8_6_1", ["p2"] = "hero_8_6_2", ["p3"] = "hero_8_6_3", ["p4"] = "hero_8_6_4", ["p5"] = "hero_8_6_5", ["p6"] = "hero_8_6_6", ["p7"] = "hero_8_6_7", ["p8"] = "hero_8_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Savage/Description.txt" },
	 { ["name"] = "Raelag_A1",   ["name2"] = "Raelag_A12",   ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   1, ["skill2"] =  18, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRailag.txt",     ["p1"] = "hero_9_6_1", ["p2"] = "hero_9_6_2", ["p3"] = "hero_9_6_3", ["p4"] = "hero_9_6_4", ["p5"] = "hero_9_6_5", ["p6"] = "hero_9_6_6", ["p7"] = "hero_9_6_7", ["p8"] = "hero_9_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/MasterOfInitiative/Description.txt" },
	 { ["name"] = "Kelodin",     ["name2"] = "Kelodin2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  38, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroShadia.txt",     ["p1"] = "hero_10_6_1",["p2"] = "hero_10_6_2",["p3"] = "hero_10_6_3",["p4"] = "hero_10_6_4",["p5"] = "hero_10_6_5",["p6"] = "hero_10_6_6",["p7"] = "hero_10_6_7",["p8"] = "hero_10_6_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Evasive/Description.txt" },
	 { ["name"] = "Shadwyn",     ["name2"] = "Shadwyn2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  18, ["skill2"] = 111, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIlaiya.txt",     ["p1"] = "hero_11_6_1",["p2"] = "hero_11_6_2",["p3"] = "hero_11_6_3",["p4"] = "hero_11_6_4",["p5"] = "hero_11_6_5",["p6"] = "hero_11_6_6",["p7"] = "hero_11_6_7",["p8"] = "hero_11_6_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/SpecShadwyn/Description.txt" },
	 { ["name"] = "Thralsai",    ["name2"] = "Thralsai2",    ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =   3, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroTralsai.txt",    ["p1"] = "hero_12_6_1",["p2"] = "hero_12_6_2",["p3"] = "hero_12_6_3",["p4"] = "hero_12_6_4",["p5"] = "hero_12_6_5",["p6"] = "hero_12_6_6",["p7"] = "hero_12_6_7",["p8"] = "hero_12_6_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/SpecThralsai/Description.txt" }
};

array_heroes[6] = {
 	 { ["name"] = "Brand",       ["name2"] = "Brand2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 151, ["skill2"] = 154, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroBrand.txt",      ["p1"] = "hero_1_7_1", ["p2"] = "hero_1_7_2", ["p3"] = "hero_1_7_3", ["p4"] = "hero_1_7_4", ["p5"] = "hero_1_7_5", ["p6"] = "hero_1_7_6", ["p7"] = "hero_1_7_7", ["p8"] = "hero_1_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Economist/Description.txt" },
	 { ["name"] = "Bersy",       ["name2"] = "Bersy2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIbba.txt",       ["p1"] = "hero_2_7_1", ["p2"] = "hero_2_7_2", ["p3"] = "hero_2_7_3", ["p4"] = "hero_2_7_4", ["p5"] = "hero_2_7_5", ["p6"] = "hero_2_7_6", ["p7"] = "hero_2_7_7", ["p8"] = "hero_2_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Rider/Description.txt" },
	 { ["name"] = "Egil",        ["name2"] = "Egil2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =   8, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroErling.txt",     ["p1"] = "hero_3_7_1", ["p2"] = "hero_3_7_2", ["p3"] = "hero_3_7_3", ["p4"] = "hero_3_7_4", ["p5"] = "hero_3_7_5", ["p6"] = "hero_3_7_6", ["p7"] = "hero_3_7_7", ["p8"] = "hero_3_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Magister/Description.txt" },
	 { ["name"] = "Ottar",       ["name2"] = "Ottar2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroHelmar.txt",     ["p1"] = "hero_4_7_1", ["p2"] = "hero_4_7_2", ["p3"] = "hero_4_7_3", ["p4"] = "hero_4_7_4", ["p5"] = "hero_4_7_5", ["p6"] = "hero_4_7_6", ["p7"] = "hero_4_7_7", ["p8"] = "hero_4_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Sacred_Hammer/Description.txt" },
	 { ["name"] = "Una",         ["name2"] = "Una2",         ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  26, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroInga.txt",       ["p1"] = "hero_5_7_1", ["p2"] = "hero_5_7_2", ["p3"] = "hero_5_7_3", ["p4"] = "hero_5_7_4", ["p5"] = "hero_5_7_5", ["p6"] = "hero_5_7_6", ["p7"] = "hero_5_7_7", ["p8"] = "hero_5_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Researcher/Description.txt" },
	 { ["name"] = "Ingvar",      ["name2"] = "Ingvar2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIngvar.txt",     ["p1"] = "hero_6_7_1", ["p2"] = "hero_6_7_2", ["p3"] = "hero_6_7_3", ["p4"] = "hero_6_7_4", ["p5"] = "hero_6_7_5", ["p6"] = "hero_6_7_6", ["p7"] = "hero_6_7_7", ["p8"] = "hero_6_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Defender/Description.txt" },
	 { ["name"] = "Vegeyr",      ["name2"] = "Vegeyr2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  45, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroSveya.txt",      ["p1"] = "hero_7_7_1", ["p2"] = "hero_7_7_2", ["p3"] = "hero_7_7_3", ["p4"] = "hero_7_7_4", ["p5"] = "hero_7_7_5", ["p6"] = "hero_7_7_6", ["p7"] = "hero_7_7_7", ["p8"] = "hero_7_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Stormcaller/Description.txt" },
	 { ["name"] = "Skeggy",      ["name2"] = "Skeggy2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  32, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKarli.txt",      ["p1"] = "hero_8_7_1", ["p2"] = "hero_8_7_2", ["p3"] = "hero_8_7_3", ["p4"] = "hero_8_7_4", ["p5"] = "hero_8_7_5", ["p6"] = "hero_8_7_6", ["p7"] = "hero_8_7_7", ["p8"] = "hero_8_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Axe_Master/Description.txt" },
	 { ["name"] = "KingTolghar", ["name2"] = "KingTolghar2", ["blocked"] = 1, ["taverna"] = 1, ["skill1"] = 151, ["skill2"] = 151, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroTolgar.txt",     ["p1"] = "hero_9_7_1", ["p2"] = "hero_9_7_2", ["p3"] = "hero_9_7_3", ["p4"] = "hero_9_7_4", ["p5"] = "hero_9_7_5", ["p6"] = "hero_9_7_6", ["p7"] = "hero_9_7_7", ["p8"] = "hero_9_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Mountain_King/Description.txt" },
	 { ["name"] = "Wulfstan",    ["name2"] = "Wulfstan2",    ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   1, ["skill2"] =  19, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVulfsten.txt",   ["p1"] = "hero_10_7_1",["p2"] = "hero_10_7_2",["p3"] = "hero_10_7_3",["p4"] = "hero_10_7_4",["p5"] = "hero_10_7_5",["p6"] = "hero_10_7_6",["p7"] = "hero_10_7_7",["p8"] = "hero_10_7_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/SpecWulfstan/Description.txt" },
	 { ["name"] = "Rolf",        ["name2"] = "Rolf2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  30, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRolf.txt",       ["p1"] = "hero_11_7_1",["p2"] = "hero_11_7_2",["p3"] = "hero_11_7_3",["p4"] = "hero_11_7_4",["p5"] = "hero_11_7_5",["p6"] = "hero_11_7_6",["p7"] = "hero_11_7_7",["p8"] = "hero_11_7_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/SpecRolf/Description.txt" }
};

array_heroes[7] = {
	 { ["name"] = "Hero2",       ["name2"] = "Hero22",       ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  22, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroArgat.txt",      ["p1"] = "hero_1_8_1", ["p2"] = "hero_1_8_2", ["p3"] = "hero_1_8_3", ["p4"] = "hero_1_8_4", ["p5"] = "hero_1_8_5", ["p6"] = "hero_1_8_6", ["p7"] = "hero_1_8_7", ["p8"] = "hero_1_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecArgat/Description.txt" },
	 { ["name"] = "Hero3",       ["name2"] = "Hero32",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  36, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGaruna.txt",     ["p1"] = "hero_2_8_1", ["p2"] = "hero_2_8_2", ["p3"] = "hero_2_8_3", ["p4"] = "hero_2_8_4", ["p5"] = "hero_2_8_5", ["p6"] = "hero_2_8_6", ["p7"] = "hero_2_8_7", ["p8"] = "hero_2_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/Blooddrinker/Description.txt" },
	 { ["name"] = "Hero6",       ["name2"] = "Hero62",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroShakKarukat.txt",["p1"] = "hero_3_8_1", ["p2"] = "hero_3_8_2", ["p3"] = "hero_3_8_3", ["p4"] = "hero_3_8_4", ["p5"] = "hero_3_8_5", ["p6"] = "hero_3_8_6", ["p7"] = "hero_3_8_7", ["p8"] = "hero_3_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecShak/Description.txt" },
	 { ["name"] = "Hero8",       ["name2"] = "Hero82",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] = 173, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroTilsek.txt",     ["p1"] = "hero_4_8_1", ["p2"] = "hero_4_8_2", ["p3"] = "hero_4_8_3", ["p4"] = "hero_4_8_4", ["p5"] = "hero_4_8_5", ["p6"] = "hero_4_8_6", ["p7"] = "hero_4_8_7", ["p8"] = "hero_4_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/GrimFighter/Description.txt" },
	 { ["name"] = "Hero7",       ["name2"] = "Hero72",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  35, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroHaggesh.txt",    ["p1"] = "hero_5_8_1", ["p2"] = "hero_5_8_2", ["p3"] = "hero_5_8_3", ["p4"] = "hero_5_8_4", ["p5"] = "hero_5_8_5", ["p6"] = "hero_5_8_6", ["p7"] = "hero_5_8_7", ["p8"] = "hero_5_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/CentaurMistress/Description.txt" },
 	 { ["name"] = "Hero1",       ["name2"] = "Hero12",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] = 175, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKrag.txt",       ["p1"] = "hero_6_8_1", ["p2"] = "hero_6_8_2", ["p3"] = "hero_6_8_3", ["p4"] = "hero_6_8_4", ["p5"] = "hero_6_8_5", ["p6"] = "hero_6_8_6", ["p7"] = "hero_6_8_7", ["p8"] = "hero_6_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/Offender/Description.txt" },
 	 { ["name"] = "Hero9",       ["name2"] = "Hero92",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  28, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroKigan.txt",      ["p1"] = "hero_7_8_1", ["p2"] = "hero_7_8_2", ["p3"] = "hero_7_8_3", ["p4"] = "hero_7_8_4", ["p5"] = "hero_7_8_5", ["p6"] = "hero_7_8_6", ["p7"] = "hero_7_8_7", ["p8"] = "hero_7_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/GoblinKing/Description.txt" },
	 { ["name"] = "Hero4",       ["name2"] = "Hero42",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 172, ["skill2"] = 175, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGoshak.txt",     ["p1"] = "hero_8_8_1", ["p2"] = "hero_8_8_2", ["p3"] = "hero_8_8_3", ["p4"] = "hero_8_8_4", ["p5"] = "hero_8_8_5", ["p6"] = "hero_8_8_6", ["p7"] = "hero_8_8_7", ["p8"] = "hero_8_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/OrcElder/Description.txt" },
	 { ["name"] = "Kujin",       ["name2"] = "Kujin2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 183, ["skill2"] = 174, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKudgin.txt",     ["p1"] = "hero_9_8_1", ["p2"] = "hero_9_8_2", ["p3"] = "hero_9_8_3", ["p4"] = "hero_9_8_4", ["p5"] = "hero_9_8_5", ["p6"] = "hero_9_8_6", ["p7"] = "hero_9_8_7", ["p8"] = "hero_9_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecKujin/Description.txt" },
	 { ["name"] = "Gottai",      ["name2"] = "Gottai2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 172, ["skill2"] = 187, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGotai.txt",      ["p1"] = "hero_10_8_1",["p2"] = "hero_10_8_2",["p3"] = "hero_10_8_3",["p4"] = "hero_10_8_4",["p5"] = "hero_10_8_5",["p6"] = "hero_10_8_6",["p7"] = "hero_10_8_7",["p8"] = "hero_10_8_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/WarLeader/Description.txt" },
	 { ["name"] = "Quroq",       ["name2"] = "Quroq2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 187, ["skill2"] = 190, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKurak.txt",      ["p1"] = "hero_11_8_1",["p2"] = "hero_11_8_2",["p3"] = "hero_11_8_3",["p4"] = "hero_11_8_4",["p5"] = "hero_11_8_5",["p6"] = "hero_11_8_6",["p7"] = "hero_11_8_7",["p8"] = "hero_11_8_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecQuroq/Description.txt" }
};


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

array_skills = {};
array_skills = {
SKILL_LOGISTICS,
SKILL_WAR_MACHINES,
SKILL_LEARNING,
SKILL_LEADERSHIP,
SKILL_LUCK,
SKILL_OFFENCE,
SKILL_DEFENCE,
SKILL_SORCERY,
SKILL_DESTRUCTIVE_MAGIC,
SKILL_DARK_MAGIC,
SKILL_LIGHT_MAGIC,
SKILL_SUMMONING_MAGIC,
SKILL_TRAINING,
SKILL_GATING,
SKILL_NECROMANCY,
SKILL_AVENGER,
SKILL_ARTIFICIER,
SKILL_INVOCATION,
HERO_SKILL_RUNELORE,
HERO_SKILL_DEMONIC_RAGE,
HERO_SKILL_BARBARIAN_LEARNING,
HERO_SKILL_VOICE,
HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC,
HERO_SKILL_SHATTER_DARK_MAGIC,
HERO_SKILL_SHATTER_LIGHT_MAGIC,
HERO_SKILL_SHATTER_SUMMONING_MAGIC
};

array_perks = {};
array_perks = {
PERK_PATHFINDING,
PERK_SCOUTING,
PERK_NAVIGATION,
PERK_FIRST_AID,
PERK_BALLISTA,
PERK_CATAPULT,
PERK_INTELLIGENCE,
PERK_SCHOLAR,
PERK_EAGLE_EYE,
PERK_RECRUITMENT,
PERK_ESTATES,
PERK_DIPLOMACY,
PERK_RESISTANCE,
PERK_LUCKY_STRIKE,
PERK_FORTUNATE_ADVENTURER,
PERK_TACTICS,
PERK_ARCHERY,
PERK_FRENZY,
PERK_PROTECTION,
PERK_EVASION,
PERK_TOUGHNESS,
PERK_MYSTICISM,
PERK_WISDOM,
PERK_ARCANE_TRAINING,
PERK_MASTER_OF_ICE,
PERK_MASTER_OF_FIRE,
PERK_MASTER_OF_LIGHTNINGS,
PERK_MASTER_OF_CURSES,
PERK_MASTER_OF_MIND,
PERK_MASTER_OF_SICKNESS,
PERK_MASTER_OF_BLESSING,
PERK_MASTER_OF_ABJURATION,
PERK_MASTER_OF_WRATH,
PERK_MASTER_OF_QUAKES,
PERK_MASTER_OF_CREATURES,
PERK_MASTER_OF_ANIMATION,
PERK_HOLY_CHARGE,
PERK_PRAYER,
PERK_EXPERT_TRAINER,
PERK_CONSUME_CORPSE,
PERK_DEMONIC_FIRE,
PERK_DEMONIC_STRIKE,
PERK_RAISE_ARCHERS,
PERK_NO_REST_FOR_THE_WICKED,
PERK_DEATH_SCREAM,
PERK_MULTISHOT,
PERK_SNIPE_DEAD,
PERK_IMBUE_ARROW,
PERK_MAGIC_BOND,
PERK_MELT_ARTIFACT,
PERK_MAGIC_MIRROR,
PERK_EMPOWERED_SPELLS,
PERK_DARK_RITUAL,
PERK_ELEMENTAL_VISION,
KNIGHT_FEAT_ROAD_HOME,
KNIGHT_FEAT_TRIPLE_BALLISTA,
KNIGHT_FEAT_ENCOURAGE,
KNIGHT_FEAT_RETRIBUTION,
KNIGHT_FEAT_HOLD_GROUND,
KNIGHT_FEAT_GUARDIAN_ANGEL,
KNIGHT_FEAT_STUDENT_AWARD,
KNIGHT_FEAT_GRAIL_VISION,
KNIGHT_FEAT_CASTER_CERTIFICATE,
KNIGHT_FEAT_ANCIENT_SMITHY,
KNIGHT_FEAT_PARIAH,
KNIGHT_FEAT_ELEMENTAL_BALANCE,
KNIGHT_FEAT_ABSOLUTE_CHARGE,
DEMON_FEAT_QUICK_GATING,
DEMON_FEAT_MASTER_OF_SECRETS,
DEMON_FEAT_TRIPLE_CATAPULT,
DEMON_FEAT_GATING_MASTERY,
DEMON_FEAT_CRITICAL_GATING,
DEMON_FEAT_CRITICAL_STRIKE,
DEMON_FEAT_DEMONIC_RETALIATION,
DEMON_FEAT_EXPLODING_CORPSES,
DEMON_FEAT_DEMONIC_FLAME,
DEMON_FEAT_WEAKENING_STRIKE,
DEMON_FEAT_FIRE_PROTECTION,
DEMON_FEAT_FIRE_AFFINITY,
DEMON_FEAT_ABSOLUTE_GATING,
NECROMANCER_FEAT_DEATH_TREAD,
NECROMANCER_FEAT_LAST_AID,
NECROMANCER_FEAT_LORD_OF_UNDEAD,
NECROMANCER_FEAT_HERALD_OF_DEATH,
NECROMANCER_FEAT_DEAD_LUCK,
NECROMANCER_FEAT_CHILLING_STEEL,
NECROMANCER_FEAT_CHILLING_BONES,
NECROMANCER_FEAT_SPELLPROOF_BONES,
NECROMANCER_FEAT_DEADLY_COLD,
NECROMANCER_FEAT_SPIRIT_LINK,
NECROMANCER_FEAT_TWILIGHT,
NECROMANCER_FEAT_HAUNT_MINE,
NECROMANCER_FEAT_ABSOLUTE_FEAR,
RANGER_FEAT_DISGUISE_AND_RECKON,
RANGER_FEAT_IMBUE_BALLISTA,
RANGER_FEAT_CUNNING_OF_THE_WOODS,
RANGER_FEAT_FOREST_GUARD_EMBLEM,
RANGER_FEAT_ELVEN_LUCK,
RANGER_FEAT_FOREST_RAGE,
RANGER_FEAT_LAST_STAND,
RANGER_FEAT_INSIGHTS,
RANGER_FEAT_SUN_FIRE,
RANGER_FEAT_SOIL_BURN,
RANGER_FEAT_STORM_WIND,
RANGER_FEAT_FOG_VEIL,
RANGER_FEAT_ABSOLUTE_LUCK,
WIZARD_FEAT_MARCH_OF_THE_MACHINES,
WIZARD_FEAT_REMOTE_CONTROL,
WIZARD_FEAT_ACADEMY_AWARD,
WIZARD_FEAT_ARTIFICIAL_GLORY,
WIZARD_FEAT_SPOILS_OF_WAR,
WIZARD_FEAT_WILDFIRE,
WIZARD_FEAT_SEAL_OF_PROTECTION,
WIZARD_FEAT_COUNTERSPELL,
WIZARD_FEAT_MAGIC_CUSHION,
WIZARD_FEAT_SUPRESS_DARK,
WIZARD_FEAT_SUPRESS_LIGHT,
WIZARD_FEAT_UNSUMMON,
WIZARD_FEAT_ABSOLUTE_WIZARDY,
WARLOCK_FEAT_TELEPORT_ASSAULT,
WARLOCK_FEAT_SHAKE_GROUND,
WARLOCK_FEAT_DARK_REVELATION,
WARLOCK_FEAT_FAST_AND_FURIOUS,
WARLOCK_FEAT_LUCKY_SPELLS,
WARLOCK_FEAT_POWER_OF_HASTE,
WARLOCK_FEAT_POWER_OF_STONE,
WARLOCK_FEAT_CHAOTIC_SPELLS,
WARLOCK_FEAT_SECRETS_OF_DESTRUCTION,
WARLOCK_FEAT_PAYBACK,
WARLOCK_FEAT_ELITE_CASTERS,
WARLOCK_FEAT_ELEMENTAL_OVERKILL,
WARLOCK_FEAT_ABSOLUTE_CHAINS,
HERO_SKILL_REFRESH_RUNE,
HERO_SKILL_STRONG_RUNE,
HERO_SKILL_FINE_RUNE,
HERO_SKILL_QUICKNESS_OF_MIND,
HERO_SKILL_RUNIC_MACHINES,
HERO_SKILL_TAP_RUNES,
HERO_SKILL_RUNIC_ATTUNEMENT,
HERO_SKILL_DWARVEN_LUCK,
HERO_SKILL_OFFENSIVE_FORMATION,
HERO_SKILL_DEFENSIVE_FORMATION,
HERO_SKILL_DISTRACT,
HERO_SKILL_SET_AFIRE,
HERO_SKILL_SHRUG_DARKNESS,
HERO_SKILL_ETERNAL_LIGHT,
HERO_SKILL_RUNIC_ARMOR,
HERO_SKILL_ABSOLUTE_PROTECTION,
HERO_SKILL_SNATCH,
HERO_SKILL_MENTORING,
HERO_SKILL_EMPATHY,
HERO_SKILL_PREPARATION,
HERO_SKILL_MIGHT_OVER_MAGIC,
HERO_SKILL_MEMORY_OF_OUR_BLOOD,
HERO_SKILL_POWERFULL_BLOW,
HERO_SKILL_ABSOLUTE_RAGE,
HERO_SKILL_PATH_OF_WAR,
HERO_SKILL_BATTLE_ELATION,
HERO_SKILL_LUCK_OF_THE_BARBARIAN,
HERO_SKILL_STUNNING_BLOW,
HERO_SKILL_DEFEND_US_ALL,
HERO_SKILL_GOBLIN_SUPPORT,
HERO_SKILL_POWER_OF_BLOOD,
HERO_SKILL_WARCRY_LEARNING,
HERO_SKILL_BODYBUILDING,
HERO_SKILL_VOICE_TRAINING,
HERO_SKILL_MIGHTY_VOICE,
HERO_SKILL_VOICE_OF_RAGE,
HERO_SKILL_CORRUPT_DESTRUCTIVE,
HERO_SKILL_WEAKEN_DESTRUCTIVE,
HERO_SKILL_DETAIN_DESTRUCTIVE,
HERO_SKILL_CORRUPT_DARK,
HERO_SKILL_WEAKEN_DARK,
HERO_SKILL_DETAIN_DARK,
HERO_SKILL_CORRUPT_LIGHT,
HERO_SKILL_WEAKEN_LIGHT,
HERO_SKILL_DETAIN_LIGHT,
HERO_SKILL_CORRUPT_SUMMONING,
HERO_SKILL_WEAKEN_SUMMONING,
HERO_SKILL_DETAIN_SUMMONING,
HERO_SKILL_DEATH_TO_NONEXISTENT,
HERO_SKILL_BARBARIAN_ANCIENT_SMITHY,
HERO_SKILL_BARBARIAN_WEAKENING_STRIKE,
HERO_SKILL_BARBARIAN_SOIL_BURN,
HERO_SKILL_BARBARIAN_FOG_VEIL,
HERO_SKILL_BARBARIAN_INTELLIGENCE,
HERO_SKILL_BARBARIAN_MYSTICISM,
HERO_SKILL_BARBARIAN_ELITE_CASTERS,
HERO_SKILL_BARBARIAN_STORM_WIND,
216,
217,
218,
219,
220
};

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

heroes1 = GetPlayerHeroes(PLAYER_1);
heroes2 = GetPlayerHeroes(PLAYER_2);
--HeroMax1 =heroes1[0];
--HeroMax2 =heroes2[0];
HeroDop1 = heroes1[0];
HeroDop2 = heroes2[0];

TELEPORT_BATTLE_ZONE_PLAYER_1_X = 43
TELEPORT_BATTLE_ZONE_PLAYER_1_Y = 45
TELEPORT_BATTLE_ZONE_PLAYER_2_X = 54
TELEPORT_BATTLE_ZONE_PLAYER_2_Y = 45


function no()
end;

HalfLevel = 9;
StartLevel = 18;

RecruitmentCoef = 0.1;
DiplomacyCoef = 0.4;
SaleArmyCoef = 0.25;
CrownOfLeaderBonus = 1.0;
LogisticsSum = 5000;

EllainaDiscount = 20;
MarkelCoef = 0.02;
IngaLevel = 7;
EllesharDiscount = 2500;
EllesharLevel = 0;

EstatesDiscountMentor =  500;
EstatesDiscountLevel  = 2500;

FortunateAdventureDiscount = 0.2;


HalfLeveling1 = 0;
HalfLeveling2 = 0;

DisableBagPlayer1 = 0;
DisableBagPlayer2 = 0;

function pause1F()
  pause1 = 1;
end;

function pause2F()
  pause2 = 1;
end;

function Confirm1F()
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Confirm.txt", 'pause1F');
end;

function Confirm2F()
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Confirm.txt", 'pause2F');
end;

function stop (hero)
  move = 0 - GetHeroStat (hero, STAT_MOVE_POINTS);
  ChangeHeroStat (hero, STAT_MOVE_POINTS, -50000);
end;

stop (heroes1[0]);
stop (heroes2[0]);

PerkSum1 = 1;
PerkSum2 = 1;

StLvlUp1 = 0;
StLvlUp2 = 0;

function levelup12()
  if HasHeroSkill(hero1, 1) and LogisticsEnable1 == 0 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + LogisticsSum * GetHeroSkillMastery(hero1, 1)));
  end;
end;

function levelup22()
  if HasHeroSkill(hero2, 1) and LogisticsEnable2 == 0 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + LogisticsSum * GetHeroSkillMastery(hero2, 1)));
  end;
end;

Rolf1 = 0;
function B1R1()
  SetObjectEnabled ('Bonus1Rolf1', true);
  RemoveObject('Bonus2Rolf1');
  RemoveObject('Bonus3Rolf1');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus1Rolf1', nil );
  MakeHeroInteractWithObject ('Rolf', 'Bonus1Rolf1');
end;

function B2R1()
  SetObjectEnabled ('Bonus2Rolf1', true);
  RemoveObject('Bonus1Rolf1');
  RemoveObject('Bonus3Rolf1');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus2Rolf1', nil );
  MakeHeroInteractWithObject ('Rolf', 'Bonus2Rolf1');
end;

function B3R1()
  SetObjectEnabled ('Bonus3Rolf1', true);
  RemoveObject('Bonus1Rolf1');
  RemoveObject('Bonus2Rolf1');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus3Rolf1', nil );
  MakeHeroInteractWithObject ('Rolf', 'Bonus3Rolf1');
end;

Rolf2 = 0;
function B1R2()
  SetObjectEnabled ('Bonus1Rolf2', true);
  RemoveObject('Bonus2Rolf2');
  RemoveObject('Bonus3Rolf2');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus1Rolf2', nil );
  MakeHeroInteractWithObject ('Rolf2', 'Bonus1Rolf2');
end;

function B2R2()
  SetObjectEnabled ('Bonus2Rolf2', true);
  RemoveObject('Bonus1Rolf2');
  RemoveObject('Bonus3Rolf2');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus2Rolf2', nil );
  MakeHeroInteractWithObject ('Rolf2', 'Bonus2Rolf2');
end;

function B3R2()
  SetObjectEnabled ('Bonus3Rolf2', true);
  RemoveObject('Bonus1Rolf2');
  RemoveObject('Bonus2Rolf2');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus3Rolf2', nil );
  MakeHeroInteractWithObject ('Rolf2', 'Bonus3Rolf2');
end;

function StartArmy(hero, race)
  unitID = GetHeroCreaturesTypes(hero);
  AddHeroCreatures(hero, 87, 1, 6);
  RemoveHeroCreatures(hero, unitID, 1);
end;

function PerkSumF(hero)
  k = 0;
  for i = 1, 26 do
    k = k + GetHeroSkillMastery(hero, array_skills[i]);
  end;
  for i = 1, 189 do
    if HasHeroSkill(hero, array_perks[i]) then
      k = k + 1;
    end;
  end;
  return k;
end;

-- Movement

MovePoints = 25000;

function hodi(hero_name)
	ChangeHeroStat(hero_name, STAT_MOVE_POINTS, 20000);
	ChangeHeroStat(HeroMax1, STAT_MOVE_POINTS, 20000);
	ChangeHeroStat(HeroMax2, STAT_MOVE_POINTS, 20000);
end;

function hodi1(hero_name)
  MP1 = GetHeroStat(hero_name, STAT_MOVE_POINTS);
  if MP1 < MovePoints then
	  ChangeHeroStat(hero_name, STAT_MOVE_POINTS, MovePoints);
  end;
end;

function peredvigenie ()
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '0', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '1', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '2', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '3', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '4', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '5', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '6', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '7', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '8', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '9', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '10', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '11', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '12', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '13', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '14', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '15', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '16', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '17', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '18', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '19', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '20', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '21', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '22', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '23', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '24', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '25', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '26', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '27', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '28', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '29', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '30', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '31', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '32', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '33', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '34', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '35', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '36', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '37', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '38', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '39', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '40', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '41', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '42', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '43', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '44', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '45', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '46', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '47', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '48', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '49', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '50', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '51', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '52', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '53', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '54', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '55', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '56', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '57', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '58', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '59', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '60', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '61', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '62', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '63', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '64', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '65', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '66', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '67', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '68', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '69', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '70', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '71', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '72', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '73', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '74', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '75', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '76', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '77', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '78', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '79', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '80', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '81', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '82', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '83', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '84', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '85', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '86', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '87', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '88', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '89', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '90', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '91', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '92', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '93', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '94', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '95', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '96', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '97', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '98', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '99', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '100', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '101', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '102', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '114', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '115', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '116', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '117', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '118', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '119', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '120', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'hodi' );
end;

function peredvigenie_v_lesu ()
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'hodi1' );
end;


function DayFour()
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '0', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '1', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '2', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '3', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '4', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '5', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '6', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '7', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '8', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '9', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '10', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '11', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '12', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '13', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '14', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '15', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '16', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '17', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '18', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '19', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '20', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '21', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '22', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '23', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '24', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '25', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '26', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '27', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '28', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '29', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '30', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '31', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '32', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '33', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '34', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '35', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '36', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '37', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '38', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '39', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '40', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '41', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '42', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '43', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '44', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '45', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '46', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '47', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '48', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '49', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '50', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '51', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '52', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '53', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '54', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '55', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '56', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '57', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '58', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '59', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '60', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '61', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '62', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '63', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '64', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '65', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '66', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '67', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '68', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '69', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '70', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '71', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '72', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '73', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '74', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '75', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '76', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '77', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '78', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '79', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '80', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '81', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '82', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '83', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '84', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '85', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '86', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '87', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '88', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '89', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '90', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '91', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '92', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '93', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '94', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '95', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '96', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '97', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '98', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '99', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '100', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '101', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '102', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '114', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '115', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '116', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '117', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '118', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '119', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '120', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'no' );

Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'no' );

end;


------------------- ANTISCANER -------------------

StartBonus = {}
StartBonus[1] = bonus1;
StartBonus[2] = bonus2;

NumberBattle = 2;

option = {};
option = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

------------------------------ MENTOR ------------------------------------------

RemoveSkillPlayer1 = 0;
RemoveSkillPlayer2 = 0;
price1 = 2500;
price2 = 2500;
resetExpHero1 = 0;
resetExpHero2 = 0;
RemSk1 = 0;
AddSk1 = 0;
RemSk2 = 0;
AddSk2 = 0;
RemSkSum1 = 0;
RemSkSum2 = 0;


artHero1 = {}
artHero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
artHero2 = {}
artHero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

	--------     HAVEN     INF    NECR     ELF    MAGE    LIGA    GNOM     ORC
	basicA   = {     1,      2,      0,      0,      0,      1,      0,      3};
	basicD   = {     2,      0,      1,      2,      0,      0,      1,      0};
	basicS   = {     1,      1,      3,      1,      2,      3,      2,      1};
	basicK   = {     1,      2,      1,      2,      3,      1,      2,      1};

ReturnSkillPlayer1 = 0;
ReturnSkillPlayer2 = 0;
Skill1_78 = 0;
Skill2_78 = 0;
SumSkill1 = 0;
SumSkill2 = 0;
RevUse1 = 0;
RevUse2 = 0;
upp=0;

Disconnect_SkillPlayer1 = 'AddSkillPlayer1: '
Disconnect_SkillPlayer2 = 'AddSkillPlayer2: '
Disconnect_GoldPlayer1 = 0
Disconnect_GoldPlayer2 = 0

arrayStatHero = {}
arrayStatHero[1] = { 0, 0, 0, 0, 0}
arrayStatHero[2] = { 0, 0, 0, 0, 0}

arrayUpStat = {}
arrayUpStat = { 0, 0, 0, 0, 0}

function ArrayStatHero(hero)
  if GetObjectOwner(hero) == 1 then
    arrayStatHero[1] = { GetHeroStat(hero, 1), GetHeroStat(hero, 2), GetHeroStat(hero, 3), GetHeroStat(hero, 4), GetHeroLevel(hero)}
  end;
  if GetObjectOwner(hero) == 2 then
    arrayStatHero[2] = { GetHeroStat(hero, 1), GetHeroStat(hero, 2), GetHeroStat(hero, 3), GetHeroStat(hero, 4), GetHeroLevel(hero)}
  end;
end;

--------------------------------- SPELL NABOR ----------------------------------

spells = {};
spells[0]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
spells[1]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
spells[2]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
spells[3]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};

BonusSpells = {}
BonusSpells[0] = {["m1"] = 0, ["sp1"] = 0, ["m2"] = 0, ["sp2"] = 0};
BonusSpells[1] = {["m1"] = 0, ["sp1"] = 0, ["m2"] = 0, ["sp2"] = 0};

for i = 0, 5 do
  k = 12;
  if i == 4 then k = 10; end;
  if i == 5 then k =  6; end;
  for j = 1, k do
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name,  GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name2, GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name3, GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name4, GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
  end;
end;


place_spell = {};
place_spell[0] = {
                  {["x"] = 33, ["y"] = 87}, {["x"] = 34, ["y"] = 87}, {["x"] = 35, ["y"] = 87}, {["x"] = 36, ["y"] = 87}, {["x"] = 37, ["y"] = 87},
                  {["x"] = 33, ["y"] = 88}, {["x"] = 34, ["y"] = 88}, {["x"] = 35, ["y"] = 88}, {["x"] = 36, ["y"] = 88}, {["x"] = 37, ["y"] = 88},
                  {["x"] = 38, ["y"] = 87}, {["x"] = 39, ["y"] = 87}, {["x"] = 38, ["y"] = 88}, {["x"] = 39, ["y"] = 88},
                  {["x"] = 33, ["y"] = 89}, {["x"] = 34, ["y"] = 89}, {["x"] = 35, ["y"] = 89}, {["x"] = 36, ["y"] = 89}, {["x"] = 37, ["y"] = 89},
                  {["x"] = 33, ["y"] = 90}, {["x"] = 34, ["y"] = 90}, {["x"] = 35, ["y"] = 90}, {["x"] = 36, ["y"] = 90}, {["x"] = 37, ["y"] = 90}
                 };
place_spell[1] = {
                  {["x"] = 44, ["y"] = 22}, {["x"] = 43, ["y"] = 22}, {["x"] = 42, ["y"] = 22}, {["x"] = 41, ["y"] = 22}, {["x"] = 40, ["y"] = 22},
                  {["x"] = 44, ["y"] = 21}, {["x"] = 43, ["y"] = 21}, {["x"] = 42, ["y"] = 21}, {["x"] = 41, ["y"] = 21}, {["x"] = 40, ["y"] = 21},
                  {["x"] = 39, ["y"] = 22}, {["x"] = 38, ["y"] = 22}, {["x"] = 39, ["y"] = 21}, {["x"] = 38, ["y"] = 21},
                  {["x"] = 44, ["y"] = 20}, {["x"] = 43, ["y"] = 20}, {["x"] = 42, ["y"] = 20}, {["x"] = 41, ["y"] = 20}, {["x"] = 40, ["y"] = 20},
                  {["x"] = 44, ["y"] = 19}, {["x"] = 43, ["y"] = 19}, {["x"] = 42, ["y"] = 19}, {["x"] = 41, ["y"] = 19}, {["x"] = 40, ["y"] = 19},
                 };

HeroHasSpellShield1 = 0;
HeroHasSpellShield2 = 0;

function TeachSpell (hero, nabor)
  if nabor == 0 then
    if SpellResetUse1 == 2 then
      nabor = 2;
    end;
  end;
  if nabor == 1 then
    if SpellResetUse2 == 2 then
      nabor = 3;
    end;
  end;

  for i = 1, 24 do
    if spells[nabor][i].m < 4 and spells[nabor][i].sp ~= 0 then
      if array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 1 or array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 2 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
        if (nabor == 0 or nabor == 2) and HasHeroSkill(HeroMax2, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax2, HERO_SKILL_DEMONIC_RAGE) == 0 then TeachHeroSpell(HeroMax2, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
        if (nabor == 1 or nabor == 3) and HasHeroSkill(HeroMax1, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax1, HERO_SKILL_DEMONIC_RAGE) == 0 then TeachHeroSpell(HeroMax1, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
      end;
      if array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 3 and HasHeroSkill(hero, PERK_WISDOM) then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;
      if array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 4 and HasHeroSkill(hero, PERK_WISDOM) and HasArtefact( hero, 71, 1) then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;

      if spells[nabor][i].m == 0 then magic = SKILL_LIGHT_MAGIC; end;
      if spells[nabor][i].m == 1 then magic = SKILL_DARK_MAGIC; end;
      if spells[nabor][i].m == 2 then magic = SKILL_DESTRUCTIVE_MAGIC; end;
      if spells[nabor][i].m == 3 then magic = SKILL_SUMMONING_MAGIC; end;
      if GetHeroSkillMastery( hero, magic) >= 1 and array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 3 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;
      if GetHeroSkillMastery( hero, magic) >= 2 and array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 4 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;
      if GetHeroSkillMastery( hero, magic) >= 3 and array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 5 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
--        if array_spells[spells[nabor][i].m][spells[nabor][i].sp].id == 34 and hero == HeroMax1 then HeroHasSpellShield1 = 1; end;
--        if array_spells[spells[nabor][i].m][spells[nabor][i].sp].id == 34 and hero == HeroMax2 then HeroHasSpellShield2 = 1; end;
      end;
    end;
    if spells[nabor][i].m == 4 and spells[nabor][i].sp ~= 0 then
      NaborRun = nabor;
      if nabor == 2 then NaborRun = 0; end;
      if nabor == 3 then NaborRun = 1; end;
      if (GetHeroSkillMastery( hero, HERO_SKILL_RUNELORE) == 1 and array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].level < 4) then
        TeachHeroSpell(hero, array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].id);
      end;
      if (GetHeroSkillMastery( hero, HERO_SKILL_RUNELORE) == 2 and array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].level < 5) then
        TeachHeroSpell(hero, array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].id);
      end;
      if (GetHeroSkillMastery( hero, HERO_SKILL_RUNELORE) > 2 and array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].level < 6) then
        TeachHeroSpell(hero, array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].id);
      end;
    end;
    if spells[nabor][i].m == 5 and spells[nabor][i].sp ~= 0 and GetHeroSkillMastery( hero, HERO_SKILL_DEMONIC_RAGE) > 0 then
      TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
--      if nabor == 0 and HasHeroSkill(HeroMax2, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax2, HERO_SKILL_DEMONIC_RAGE) > 0 then TeachHeroSpell(HeroMax2, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
--      if nabor == 1 and HasHeroSkill(HeroMax1, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax1, HERO_SKILL_DEMONIC_RAGE) > 0 then TeachHeroSpell(HeroMax1, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
    end;
  end;
end;
  
function Scholar(hero, nabor)
  for i = 0, 3 do
    for j = 1, 12 do
      if hero == HeroMax1 and HasHeroSkill(hero, PERK_SCHOLAR) and array_spells[i][j].level < 3 and KnowHeroSpell(HeroMax2, array_spells[i][j].id) then
        TeachHeroSpell(hero, array_spells[i][j].id);
      end;
      if hero == HeroMax2 and HasHeroSkill(hero, PERK_SCHOLAR) and array_spells[i][j].level < 3 and KnowHeroSpell(HeroMax1, array_spells[i][j].id) then
        TeachHeroSpell(hero, array_spells[i][j].id);
      end;
      if i == 0 then magic = SKILL_LIGHT_MAGIC; end;
      if i == 1 then magic = SKILL_DARK_MAGIC; end;
      if i == 2 then magic = SKILL_DESTRUCTIVE_MAGIC; end;
      if i == 3 then magic = SKILL_SUMMONING_MAGIC; end;
      if (nabor == 0 or nabor == 2) and HasHeroSkill(HeroMax1, PERK_SCHOLAR) and array_spells[i][j].level == 3 and KnowHeroSpell(HeroMax2, array_spells[i][j].id) and (HasHeroSkill(HeroMax1, PERK_WISDOM) or GetHeroSkillMastery( HeroMax1, magic) >= 1) then
        TeachHeroSpell(HeroMax1, array_spells[i][j].id);
      end;
      if (nabor == 1 or nabor == 3) and HasHeroSkill(HeroMax2, PERK_SCHOLAR) and array_spells[i][j].level == 3 and KnowHeroSpell(HeroMax1, array_spells[i][j].id) and (HasHeroSkill(HeroMax2, PERK_WISDOM) or GetHeroSkillMastery( HeroMax2, magic) >= 1) then
        TeachHeroSpell(HeroMax2, array_spells[i][j].id);
      end;
    end;
  end;
end;

---- ****

arrayPossibleHeroes = {}
arrayPossibleHeroes[0] = {}
arrayPossibleHeroes[1] = {}
arrayPossibleHeroes[2] = {}
arrayPossibleHeroes[3] = {}

--------     HAVEN     INF    NECR     ELF    MAGE    LIGA    GNOM     ORC
PercentA = {    30,     45,     10,     15,     10,     30,     20,     50};
PercentD = {    45,     10,     30,     45,     15,     10,     30,     35};
PercentS = {    10,     15,     45,     10,     30,     45,     30,      5};
PercentK = {    15,     30,     15,     30,     45,     15,     20,     10};

------ RESOURCES ---------------------------------------------------------------

function getrace(hero)
	if GetHeroSkillMastery(hero,          SKILL_TRAINING) > 0 then return 1; end;
	if GetHeroSkillMastery(hero,            SKILL_GATING) > 0 then return 2; end;
	if GetHeroSkillMastery(hero,        SKILL_NECROMANCY) > 0 then return 3; end;
	if GetHeroSkillMastery(hero,           SKILL_AVENGER) > 0 then return 4; end;
	if GetHeroSkillMastery(hero,        SKILL_ARTIFICIER) > 0 then return 5; end;
	if GetHeroSkillMastery(hero,        SKILL_INVOCATION) > 0 then return 6; end;
	if GetHeroSkillMastery(hero,     HERO_SKILL_RUNELORE) > 0 then return 7; end;
	if GetHeroSkillMastery(hero, HERO_SKILL_DEMONIC_RAGE) > 0 then return 8; end;
	return 0;
end;

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

kol_u = {};
price = {};

array_Archer_ID = {}
array_Archer_ID = { 3, 9, 21, 29, 37, 47, 49, 57, 63, 69, 71, 81, 85, 94, 100, 107, 110, 119, 134, 147, 148, 156, 159, 162, 165, 167, 170, 174}

array_HeroSpecCreatures = {}
array_HeroSpecCreatures = {
   { ["name"] = "Orrin",           ["name2"] = "Orrin2",           ["id1"] =   3, ["id2"] = 107 },
   { ["name"] = "Sarge",           ["name2"] = "Sarge2",           ["id1"] =  11, ["id2"] = 111 },
   { ["name"] = "Mardigo",         ["name2"] = "Mardigo2",         ["id1"] =   5, ["id2"] = 108 },
   { ["name"] = "Ving",            ["name2"] = "Ving2",            ["id1"] =   8, ["id2"] = 109 },
   { ["name"] = "Nathaniel",       ["name2"] = "Nathaniel2",       ["id1"] =   1, ["id2"] = 106 },
--   { ["name"] = "RedHeavenHero03", ["name2"] = "RedHeavenHero032", ["id1"] =   9, ["id2"] = 110 },
   { ["name"] = "Oddrema",         ["name2"] = "Oddrema2",         ["id1"] =  21, ["id2"] = 134 },
   { ["name"] = "Calid",           ["name2"] = "Calid2",           ["id1"] =  19, ["id2"] = 133 },
   { ["name"] = "Agrael",          ["name2"] = "Agrael2",          ["id1"] =  27, ["id2"] = 137 },
--   { ["name"] = "Kha-Beleth",      ["name2"] = "Kha-Beleth2",      ["id1"] =  27, ["id2"] = 137 },
--   { ["name"] = "OrnellaNecro",    ["name2"] = "OrnellaNecro2",    ["id1"] =  29, ["id2"] = 152 },
   { ["name"] = "Gles",            ["name2"] = "Gles2",            ["id1"] = 116, ["id2"] =   0 },
   { ["name"] = "Tamika",          ["name2"] = "Tamika2",          ["id1"] =  35, ["id2"] = 155 },
   { ["name"] = "Straker",         ["name2"] = "Straker2",         ["id1"] =  31, ["id2"] = 153 },
   { ["name"] = "Gillion",         ["name2"] = "Gillion2",         ["id1"] =  45, ["id2"] = 146 },
   { ["name"] = "Ossir",           ["name2"] = "Ossir2",           ["id1"] =  47, ["id2"] = 147 },
   { ["name"] = "Itil",            ["name2"] = "Itil2",            ["id1"] =  51, ["id2"] = 149 },
--   { ["name"] = "Ildar",           ["name2"] = "Ildar2",           ["id1"] =  55, ["id2"] = 151 },
--   { ["name"] = "GhostFSLord",     ["name2"] = "GhostFSLord2",     ["id1"] =  49, ["id2"] = 148 },
   { ["name"] = "Havez",           ["name2"] = "Havez2",           ["id1"] =  57, ["id2"] = 159 },
   { ["name"] = "Razzak",          ["name2"] = "Razzak2",          ["id1"] =  63, ["id2"] = 162 },
   { ["name"] = "Tan",             ["name2"] = "Tan2",             ["id1"] =  68, ["id2"] =  70 },
   { ["name"] = "Isher",           ["name2"] = "Isher2",           ["id1"] =  61, ["id2"] = 161 },
   { ["name"] = "Eruina",          ["name2"] = "Eruina2",          ["id1"] =  81, ["id2"] =  82 },
   { ["name"] = "Urunir",          ["name2"] = "Urunir2",          ["id1"] =  73, ["id2"] = 139 },
   { ["name"] = "Menel",           ["name2"] = "Menel2",           ["id1"] =  75, ["id2"] = 140 },
   { ["name"] = "Ferigl",          ["name2"] = "Ferigl2",          ["id1"] =  77, ["id2"] = 141 },
   { ["name"] = "Ohtarig",         ["name2"] = "Ohtarig2",         ["id1"] =  71, ["id2"] = 138 },
   { ["name"] = "Bersy",           ["name2"] = "Bersy2",           ["id1"] =  96, ["id2"] = 168 },
   { ["name"] = "Egil",            ["name2"] = "Egil2",            ["id1"] = 100, ["id2"] = 170 },
   { ["name"] = "Ingvar",          ["name2"] = "Ingvar2",          ["id1"] =  92, ["id2"] = 166 },
   { ["name"] = "Skeggy",          ["name2"] = "Skeggy2",          ["id1"] =  94, ["id2"] = 167 },
   { ["name"] = "Wulfstan",        ["name2"] = "Wulfstan2",        ["id1"] =  98, ["id2"] = 169 },
   { ["name"] = "Hero6",           ["name2"] = "Hero62",           ["id1"] = 127, ["id2"] = 178 },
   { ["name"] = "Hero8",           ["name2"] = "Hero82",           ["id1"] = 121, ["id2"] = 175 },
   { ["name"] = "Hero7",           ["name2"] = "Hero72",           ["id1"] = 119, ["id2"] = 174 },
   { ["name"] = "Hero9",           ["name2"] = "Hero92",           ["id1"] = 117, ["id2"] = 173 },
   { ["name"] = "Hero4",           ["name2"] = "Hero42",           ["id1"] = 125, ["id2"] = 177 }}
--   { ["name"] = "Quroq",           ["name2"] = "Quroq2",           ["id1"] = 123, ["id2"] = 176 }}

array_ArtDragon_ID = {}
array_ArtDragon_ID = {
  { ["id"] = 36, ["place"] = 4 },
  { ["id"] = 37, ["place"] = 5 },
  { ["id"] = 38, ["place"] = 8 },
  { ["id"] = 39, ["place"] = 9 },
  { ["id"] = 40, ["place"] = 3 },
  { ["id"] = 41, ["place"] = 2 },
  { ["id"] = 42, ["place"] = 1 },
  { ["id"] = 43, ["place"] = 7 }}
  
array_ArtPlace = {}
array_ArtPlace = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_RaceArt_ID = {}
array_RaceArt_ID[0] = { 11, 16, 31}
array_RaceArt_ID[1] = { 23, 66}
array_RaceArt_ID[2] = {  7, 33}
array_RaceArt_ID[3] = {  4, 95}
array_RaceArt_ID[4] = { 44, 45, 46, 47}
array_RaceArt_ID[5] = { 81, 82}
array_RaceArt_ID[6] = { 48, 49, 50, 51}
array_RaceArt_ID[7] = { 74, 75}

array_MassSpell_ID = {}
array_MassSpell_ID = {
   { ["mass"] = 210, ["single"] = 11 },
   { ["mass"] = 211, ["single"] = 13 },
   { ["mass"] = 212, ["single"] = 12 },
   { ["mass"] = 213, ["single"] = 17 },
   { ["mass"] = 214, ["single"] = 14 },
   { ["mass"] = 215, ["single"] = 15 },
   { ["mass"] = 216, ["single"] = 23 },
   { ["mass"] = 217, ["single"] = 26 },
   { ["mass"] = 218, ["single"] = 25 },
   { ["mass"] = 219, ["single"] = 29 },
   { ["mass"] = 220, ["single"] = 28 },
   { ["mass"] = 221, ["single"] = 24 }}

array_Tier7_ID = {}
array_Tier7_ID = { 13, 27, 41, 55, 69, 83, 105, 112, 129, 137, 144, 151, 158, 165, 172, 179}

array_Fly_ID = {}
array_Fly_ID = { 7, 8, 13, 27, 34, 35, 41, 43, 55, 59, 65, 83, 88, 91, 102, 109, 112, 115, 127, 137, 144, 145, 151, 154, 155, 158, 160, 163, 171, 178}

function DeletePerk(hero, perk)
  j = 1;
  for i = 1, 26 do
    array_skills_Hero[i] = GetHeroSkillMastery(HeroMax1, array_skills[i]);
  end;
  for i = 1, 189 do
    if HasHeroSkill( HeroMax1, array_perks[i]) then
      array_perks_Hero[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero = j;
    end;
  end;
  expHero = GetHeroStat(HeroMax1, STAT_EXPERIENCE);
  attHero = GetHeroStat(HeroMax1, STAT_ATTACK);
  defHero = GetHeroStat(HeroMax1, STAT_DEFENCE);
  spHero  = GetHeroStat(HeroMax1, STAT_SPELL_POWER);
  knHero  = GetHeroStat(HeroMax1, STAT_KNOWLEDGE);
  Trigger( HERO_ADD_SKILL_TRIGGER, hero, 'no');
  Trigger( HERO_REMOVE_SKILL_TRIGGER, hero, 'no');
  TakeAwayHeroExp(hero, expHero - 1);
  WarpHeroExp(hero, expHero);
  TakeAwayHeroExp(hero, expHero - 1);
  WarpHeroExp(hero, expHero);
  for i = 1, 26 do
    for j = 1, array_skills_Hero[i] do
      if array_skills_Hero[i] >= j then
        if GetHeroSkillMastery(hero, array_skills[i]) < array_skills_Hero[i] then
          GiveHeroSkill(hero, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero do
    if array_perks_Hero[i] ~= perk then
      GiveHeroSkill(hero, array_perks_Hero[i]);
    end;
  end;
  ChangeHeroStat(hero, STAT_ATTACK, attHero - GetHeroStat(HeroMax1, STAT_ATTACK));
  ChangeHeroStat(hero, STAT_DEFENCE, defHero - GetHeroStat(HeroMax1, STAT_DEFENCE));
  ChangeHeroStat(hero, STAT_SPELL_POWER, spHero - GetHeroStat(HeroMax1, STAT_SPELL_POWER));
  ChangeHeroStat(hero, STAT_KNOWLEDGE, knHero - GetHeroStat(HeroMax1, STAT_KNOWLEDGE));
  sleep(2);
end;

function BlockBattleZone(race1, race2)
  if race1 == 1 or race2 == 1 or race1 == 4 or race2 == 4 then SetRegionBlocked ('land_block_race1', true); end;
  if race1 == 2 or race2 == 2 then SetRegionBlocked ('land_block_race2', true); end;
  if race1 == 3 or race2 == 3 then SetRegionBlocked ('land_block_race3', true); end;
  if race1 == 5 or race2 == 5 then SetRegionBlocked ('land_block_race5', true); end;
  if race1 == 6 or race2 == 6 then SetRegionBlocked ('land_block_race6', true); end;
  if race1 == 7 or race7 == 2 then SetRegionBlocked ('land_block_race7', true); end;
  if race1 == 8 or race2 == 8 then SetRegionBlocked ('land_block_race8', true); end;
end

ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_1, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");

kolUnit1 = {}
kolUnit1 = { 0, 0, 0, 0, 0, 0, 0}
kolUnit2 = {}
kolUnit2 = { 0, 0, 0, 0, 0, 0, 0}


-- обработчик наступления нового дня
function newday ()
  if GetDate (DAY) == 2 then
    doFile(GetMapDataPath().."day2/day2_scripts.lua");
  end;

  if GetDate (DAY) == 3 then
    doFile(GetMapDataPath().."day3/day3_scripts.lua");
  end;

  if GetDate (DAY) == 4 then

     if not IsHeroAlive(HeroMax1) then print(Disconnect_SkillPlayer1); print('GoldPlayer1 = ', Disconnect_GoldPlayer1); print('RegenSpell = ', SpellResetUse1); end;
     if not IsHeroAlive(HeroMax2) then print(Disconnect_SkillPlayer2); print('GoldPlayer2 = ', Disconnect_GoldPlayer2); print('RegenSpell = ', SpellResetUse2); end;

     sleep(2)

     startThread (DayFour);
     
     if ((HasHeroSkill(HeroMax1, 19) and HasHeroSkill(HeroMax2, 19) == nil) and Name(HeroMax2) ~= "Jazaz") or Name(HeroMax1) == "Jazaz" then
       TELEPORT_BATTLE_ZONE_PLAYER_1_X, TELEPORT_BATTLE_ZONE_PLAYER_2_X = TELEPORT_BATTLE_ZONE_PLAYER_2_X, TELEPORT_BATTLE_ZONE_PLAYER_1_X
       TELEPORT_BATTLE_ZONE_PLAYER_1_Y, TELEPORT_BATTLE_ZONE_PLAYER_2_Y = TELEPORT_BATTLE_ZONE_PLAYER_2_Y, TELEPORT_BATTLE_ZONE_PLAYER_1_Y
     end
     
     BlockBattleZone(hero1race, hero2race)
     
     if HasHeroSkill(HeroMax1, 19) or HasHeroSkill(HeroMax2, 19) or Name(HeroMax1) == "Jazaz" or Name(HeroMax2) == "Jazaz" then
       SetRegionBlocked ('land_block_race1', false);
       SetRegionBlocked ('land_block_race2', false);
       SetRegionBlocked ('land_block_race3', false);
       SetRegionBlocked ('land_block_race5', false);
       SetRegionBlocked ('land_block_race6', false);
       SetRegionBlocked ('land_block_race7', false);
       SetRegionBlocked ('land_block_race8', false);
     end;
     
     
     sleep(5);

     startThread (DayFour2);
     startThread (DayFour1);
  end;

  if GetDate (DAY) == 5 then
     -- менторство
     if (HasHeroSkill(HeroMax1, 169)) then ChangeLevel(HeroMax1, 8); if Name(HeroMax1) == "Una" then SpecInga1(); end; end;
     if (HasHeroSkill(HeroMax2, 169)) then ChangeLevel(HeroMax2, 8); if Name(HeroMax2) == "Una" then SpecInga2(); end; end;

     sleep(2);

     stop(HeroMax1); stop(HeroMax2); stop(HeroMin1); stop(HeroMin2);

     -- фикс бага с грифонами
     if GetHeroCreatures(HeroMax1, 7) > 0 then kolCreatures = GetHeroCreatures(HeroMax1, 7); RemoveHeroCreatures(HeroMax1, 7, kolCreatures); AddHeroCreatures(HeroMax1, 8, kolCreatures); end;
     if GetHeroCreatures(HeroMax2, 7) > 0 then kolCreatures = GetHeroCreatures(HeroMax2, 7); RemoveHeroCreatures(HeroMax2, 7, kolCreatures); AddHeroCreatures(HeroMax2, 8, kolCreatures); end;


     ------------- АРТЕФАКТЫ ---------------

     -- тюрбан просвещенности
     if HasArtefact(HeroMax1, 34, 1) then ChangeLevel(HeroMax1, 6); end;
     if HasArtefact(HeroMax2, 34, 1) then ChangeLevel(HeroMax2, 6); end;
     
     -- корона лидерства
     if HasArtefact(HeroMax1, 88, 1) then CrownLeader(HeroMax1); end;
     if HasArtefact(HeroMax2, 88, 1) then CrownLeader(HeroMax2); end;

     ------------- ГЕРОИ ---------------

     -- Рутгер
     if (HeroMax1 == "Brem" or HeroMax1 == "Brem2") and GetHeroSkillMastery(HeroMax1, SKILL_TRAINING) == 3 then SubHero(HeroMax1, "Brem3"); HeroMax1 = "Brem3"; sleep(3); end;
     if (HeroMax1 == "Brem" or HeroMax1 == "Brem2") and GetHeroSkillMastery(HeroMax1, SKILL_TRAINING) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_TRAINING) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_TRAINING); end;

     if (HeroMax2 == "Brem" or HeroMax2 == "Brem2") and GetHeroSkillMastery(HeroMax2, SKILL_TRAINING) == 3 then SubHero(HeroMax2, "Brem4"); HeroMax2 = "Brem4"; sleep(3); end;
     if (HeroMax2 == "Brem" or HeroMax2 == "Brem2") and GetHeroSkillMastery(HeroMax2, SKILL_TRAINING) < 3 and GetHeroSkillMastery(HeroMax2, SKILL_TRAINING) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no'); GiveHeroSkill(HeroMax2, SKILL_TRAINING); end;

     -- Илайя
     if (HeroMax1 == "Shadwyn" or HeroMax1 == "Shadwyn2") and GetHeroSkillMastery(HeroMax1, SKILL_INVOCATION) == 3 then SubHero(HeroMax1, "Shadwyn3"); HeroMax1 = "Shadwyn3"; sleep(3); end;
     if (HeroMax1 == "Shadwyn" or HeroMax1 == "Shadwyn2") and GetHeroSkillMastery(HeroMax1, SKILL_INVOCATION) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_INVOCATION) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_INVOCATION); end;

     if (HeroMax2 == "Shadwyn" or HeroMax2 == "Shadwyn2") and GetHeroSkillMastery(HeroMax2, SKILL_INVOCATION) == 3 then SubHero(HeroMax2, "Shadwyn4"); HeroMax2 = "Shadwyn4"; sleep(3); end;
     if (HeroMax2 == "Shadwyn" or HeroMax2 == "Shadwyn2") and GetHeroSkillMastery(HeroMax2, SKILL_INVOCATION) < 3 and GetHeroSkillMastery(HeroMax2, SKILL_INVOCATION) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no'); GiveHeroSkill(HeroMax2, SKILL_INVOCATION); end;

     -- Киган
     if Name(HeroMax1) == "Hero9" then
     if GetHeroCreatures(HeroMax1, 117) > 0 then AddHeroCreatures(HeroMax1, 117, 6 * GetHeroLevel(HeroMax1)); else AddHeroCreatures(HeroMax1, 173, 6 * GetHeroLevel(HeroMax1)); end; end;
     if Name(HeroMax2) == "Hero9" then
     if GetHeroCreatures(HeroMax2, 117) > 0 then AddHeroCreatures(HeroMax2, 117, 6 * GetHeroLevel(HeroMax2)); else AddHeroCreatures(HeroMax2, 173, 6 * GetHeroLevel(HeroMax2)); end; end;

     -- Орландо
     if Name(HeroMax1) == "Orlando" then
     if GetHeroCreatures(HeroMax1, 27) >= GetHeroCreatures(HeroMax1, 137) then AddHeroCreatures(HeroMax1, 27, 1 + floor(GetHeroLevel(HeroMax1)/10)); else AddHeroCreatures(HeroMax1, 137, 1 + floor(GetHeroLevel(HeroMax1)/10)); end; end;
     if Name(HeroMax2) == "Orlando" then
     if GetHeroCreatures(HeroMax2, 27) >= GetHeroCreatures(HeroMax2, 137) then AddHeroCreatures(HeroMax2, 27, 1 + floor(GetHeroLevel(HeroMax2)/10)); else AddHeroCreatures(HeroMax2, 137, 1 + floor(GetHeroLevel(HeroMax2)/10)); end; end;


     TeachSpell (HeroMax1, 0);
     TeachSpell (HeroMax2, 1);
     Scholar (HeroMax1, 0);
     Scholar (HeroMax2, 1);

     sleep(5);

     if hero1race == 7 then
       if GetHeroSkillMastery(HeroMax1, HERO_SKILL_RUNELORE) >  0 then SetPlayerResource(1, WOOD, 7); SetPlayerResource(1, ORE, 7); SetPlayerResource(1, MERCURY,  5); SetPlayerResource(1, CRYSTAL,  5); SetPlayerResource(1, SULFUR,  5); SetPlayerResource(1, GEM,  5); end;
       if GetHeroSkillMastery(HeroMax1, HERO_SKILL_RUNELORE) == 4 then SetPlayerResource(1, WOOD, 15); SetPlayerResource(1, ORE, 15); SetPlayerResource(1, MERCURY, 10); SetPlayerResource(1, CRYSTAL, 10); SetPlayerResource(1, SULFUR, 10); SetPlayerResource(1, GEM, 10); end;
     end;

     if hero2race == 7 then
       if GetHeroSkillMastery(HeroMax2, HERO_SKILL_RUNELORE) >  0 then SetPlayerResource(2, WOOD, 7); SetPlayerResource(2, ORE, 7); SetPlayerResource(2, MERCURY,  5); SetPlayerResource(2, CRYSTAL,  5); SetPlayerResource(2, SULFUR,  5); SetPlayerResource(2, GEM,  5); end;
       if GetHeroSkillMastery(HeroMax2, HERO_SKILL_RUNELORE) == 4 then SetPlayerResource(2, WOOD, 15); SetPlayerResource(2, ORE, 15); SetPlayerResource(2, MERCURY, 10); SetPlayerResource(2, CRYSTAL, 10); SetPlayerResource(2, SULFUR, 10); SetPlayerResource(2, GEM, 10); end;
     end;

     ------------- УМЕНИЯ ---------------

     -- сбор войск
     if (HasHeroSkill(HeroMax1, 28)) then recruitment1(HeroMax1); end;
     if (HasHeroSkill(HeroMax2, 28)) then recruitment2(HeroMax2); end;

     -- покровительство асхи
--     if (HasHeroSkill(HeroMax1, 80)) then GraalVision(HeroMax1, hero1race); end;
--     if (HasHeroSkill(HeroMax2, 80)) then GraalVision(HeroMax2, hero2race); end;
     
     ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 1000);
     ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 1000);
     

     -- аура стремительности
--     if (HasHeroSkill(HeroMax1, 21)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
--     if (HasHeroSkill(HeroMax2, 21)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_INITIATIVE, 1); end;

     -- тайное преимущество
--     if (HasHeroSkill(HeroMax1, 81)) then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, SinergyLevel1 + 1); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 10 * (SinergyLevel1 + 1)); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 0 - (SinergyLevel1 + 1)); end;
--     if (HasHeroSkill(HeroMax2, 81)) then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, SinergyLevel2 + 1); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 10 * (SinergyLevel2 + 1)); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 0 - (SinergyLevel2 + 1)); end;

     sleep(2);

     -- изменчивая мана
     --if HasHeroSkill(HeroMax1, 145) then mana = 10 + random(21); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, mana); ShowFlyingSign({GetMapDataPath().."RandomMana.txt"; eq = mana}, HeroMax1, 1, 5.0); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -5); end;
     --if HasHeroSkill(HeroMax2, 145) then mana = 10 + random(21); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, mana); ShowFlyingSign({GetMapDataPath().."RandomMana.txt"; eq = mana}, HeroMax2, 2, 5.0); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -5); end;
     --sleep(2);
     
     -- сумерки
     if HasHeroSkill(HeroMax1, 109) then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 30); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -5); end;
     if HasHeroSkill(HeroMax2, 109) then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 30); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -5); end;
     sleep(2);

     -- сопротивление
     if (HasHeroSkill(HeroMax1, 131)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     if (HasHeroSkill(HeroMax2, 131)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     
     -- смертельная неудача
     --if (HasHeroSkill(HeroMax1, 103)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_LUCK, -1); end;
     --if (HasHeroSkill(HeroMax2, 103)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_LUCK, -1); end;

     -- выносливость
     if (HasHeroSkill(HeroMax1, 186)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 5); end;
     if (HasHeroSkill(HeroMax2, 186)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 5); end;

     -- тайное откровение (хранитель тайного)
--     if (HasHeroSkill(HeroMax1, 87)) then Insights(HeroMax1); end;
--     if (HasHeroSkill(HeroMax2, 87)) then Insights(HeroMax2); end;

     -- путь войны
--     if (HasHeroSkill(HeroMax1, 177) and HasHeroSkill(HeroMax2, 19) == nil and HasHeroSkill(HeroMax2, 21) == nil and Name(HeroMax2) ~= "Jazaz") then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_ATTACK, 2); GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_DEFENCE, 2); end;
--     if (HasHeroSkill(HeroMax2, 177) and HasHeroSkill(HeroMax1, 19) == nil and HasHeroSkill(HeroMax1, 21) == nil and Name(HeroMax1) ~= "Jazaz") then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_ATTACK, 2); GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_DEFENCE, 2); end;

     -- мародерство
     if (HasHeroSkill(HeroMax1, 168)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_SPEED, -1); end;
     if (HasHeroSkill(HeroMax2, 168)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_SPEED, -1); end;
     
     -- родные земли
     if (HasHeroSkill(HeroMax1, 73)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_SPEED, 1); end;
     if (HasHeroSkill(HeroMax2, 73)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_SPEED, 1); end;

     -- охота на демонов (орочье восполнение маны)
--     if (HasHeroSkill(HeroMax1, 213)) then DestroyTownBuildingToLevel('RANDOMTOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM, 0); end;
--     if (HasHeroSkill(HeroMax2, 213)) then DestroyTownBuildingToLevel('RANDOMTOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM, 0); end;

     -- боевая закалка (катапульта)
--     if (HasHeroSkill(HeroMax1, 24)) and (HasHeroSkill(HeroMax2, 126)) then DeletePerk(HeroMax2, WIZARD_FEAT_REMOTE_CONTROL); end;
--     if (HasHeroSkill(HeroMax1, 24)) and (HasHeroSkill(HeroMax2, 107)) then DeletePerk(HeroMax2, NECROMANCER_FEAT_DEADLY_COLD); end;
--     if (HasHeroSkill(HeroMax2, 24)) and (HasHeroSkill(HeroMax1, 126)) then DeletePerk(HeroMax1, WIZARD_FEAT_REMOTE_CONTROL); end;
--     if (HasHeroSkill(HeroMax2, 24)) and (HasHeroSkill(HeroMax1, 107)) then DeletePerk(HeroMax1, NECROMANCER_FEAT_DEADLY_COLD); end;

     -- небесный щит
--     if (HasHeroSkill(HeroMax1,  40)) and HeroHasSpellShield1 == 1 then DeletePerk(HeroMax1,         PERK_MYSTICISM); GiveHeroSkill(HeroMax1, 166); end;
--     if (HasHeroSkill(HeroMax1, 166)) and HeroHasSpellShield1 == 0 then DeletePerk(HeroMax1, HERO_SKILL_RUNIC_ARMOR); GiveHeroSkill(HeroMax1,  40); end;
--     if (HasHeroSkill(HeroMax2,  40)) and HeroHasSpellShield2 == 1 then DeletePerk(HeroMax2,         PERK_MYSTICISM); GiveHeroSkill(HeroMax2, 166); end;
--     if (HasHeroSkill(HeroMax2, 166)) and HeroHasSpellShield2 == 0 then DeletePerk(HeroMax2, HERO_SKILL_RUNIC_ARMOR); GiveHeroSkill(HeroMax2,  40); end;

     -- помощь гоблинов
     --if (HasHeroSkill(HeroMax1, 182)) and (GetHeroCreatures(HeroMax1, 117) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 117); RemoveHeroCreatures(HeroMax1, 117, kolCreatures); AddHeroCreatures(HeroMax1, 118, kolCreatures); end;
     --if (HasHeroSkill(HeroMax1, 182)) and (GetHeroCreatures(HeroMax1, 173) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 173); RemoveHeroCreatures(HeroMax1, 173, kolCreatures); AddHeroCreatures(HeroMax1,  30, kolCreatures); end;
     --if (HasHeroSkill(HeroMax2, 182)) and (GetHeroCreatures(HeroMax2, 117) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 117); RemoveHeroCreatures(HeroMax2, 117, kolCreatures); AddHeroCreatures(HeroMax2, 118, kolCreatures); end;
     --if (HasHeroSkill(HeroMax2, 182)) and (GetHeroCreatures(HeroMax2, 173) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 173); RemoveHeroCreatures(HeroMax2, 173, kolCreatures); AddHeroCreatures(HeroMax2,  30, kolCreatures); end;

     -- лесная ярость
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1,  51) > 0) then kolCreatures = GetHeroCreatures(HeroMax1,  51); RemoveHeroCreatures(HeroMax1,  51, kolCreatures); AddHeroCreatures(HeroMax1,  52, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1, 149) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 149); RemoveHeroCreatures(HeroMax1, 149, kolCreatures); AddHeroCreatures(HeroMax1,  66, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1,  53) > 0) then kolCreatures = GetHeroCreatures(HeroMax1,  53); RemoveHeroCreatures(HeroMax1,  53, kolCreatures); AddHeroCreatures(HeroMax1,  54, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1, 150) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 150); RemoveHeroCreatures(HeroMax1, 150, kolCreatures); AddHeroCreatures(HeroMax1,  44, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1,  55) > 0) then kolCreatures = GetHeroCreatures(HeroMax1,  55); RemoveHeroCreatures(HeroMax1,  55, kolCreatures); AddHeroCreatures(HeroMax1,  56, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1, 151) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 151); RemoveHeroCreatures(HeroMax1, 151, kolCreatures); AddHeroCreatures(HeroMax1,  84, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2,  51) > 0) then kolCreatures = GetHeroCreatures(HeroMax2,  51); RemoveHeroCreatures(HeroMax2,  51, kolCreatures); AddHeroCreatures(HeroMax2,  52, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2, 149) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 149); RemoveHeroCreatures(HeroMax2, 149, kolCreatures); AddHeroCreatures(HeroMax2,  66, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2,  53) > 0) then kolCreatures = GetHeroCreatures(HeroMax2,  53); RemoveHeroCreatures(HeroMax2,  53, kolCreatures); AddHeroCreatures(HeroMax2,  54, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2, 150) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 150); RemoveHeroCreatures(HeroMax2, 150, kolCreatures); AddHeroCreatures(HeroMax2,  44, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2,  55) > 0) then kolCreatures = GetHeroCreatures(HeroMax2,  55); RemoveHeroCreatures(HeroMax2,  55, kolCreatures); AddHeroCreatures(HeroMax2,  56, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2, 151) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 151); RemoveHeroCreatures(HeroMax2, 151, kolCreatures); AddHeroCreatures(HeroMax2,  84, kolCreatures); end;



     -- вечное рабство
--     if (HasHeroSkill(HeroMax1, 62)) and (GetHeroCreatures(HeroMax1,  29) > 0) and HeroMax1 ~= "OrnellaNecro" and HeroMax1 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax1,  29); RemoveHeroCreatures(HeroMax1,  29, kolCreatures); AddHeroCreatures(HeroMax1,  95, kolCreatures); end;
--     if (HasHeroSkill(HeroMax1, 62)) and (GetHeroCreatures(HeroMax1, 152) > 0) and HeroMax1 ~= "OrnellaNecro" and HeroMax1 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax1, 152); RemoveHeroCreatures(HeroMax1, 152, kolCreatures); AddHeroCreatures(HeroMax1,  97, kolCreatures); end;
--     if (HasHeroSkill(HeroMax2, 62)) and (GetHeroCreatures(HeroMax2,  29) > 0) and HeroMax2 ~= "OrnellaNecro" and HeroMax2 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax2,  29); RemoveHeroCreatures(HeroMax2,  29, kolCreatures); AddHeroCreatures(HeroMax2,  95, kolCreatures); end;
--     if (HasHeroSkill(HeroMax2, 62)) and (GetHeroCreatures(HeroMax2, 152) > 0) and HeroMax2 ~= "OrnellaNecro" and HeroMax2 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax2, 152); RemoveHeroCreatures(HeroMax2, 152, kolCreatures); AddHeroCreatures(HeroMax2,  97, kolCreatures); end;

     -- сила против магии
     if (HasHeroSkill(HeroMax1, 173) and frac(GetHeroStat(HeroMax1, STAT_SPELL_POWER) / 2) == 0.5 ) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 1); end;
     if (HasHeroSkill(HeroMax2, 173) and frac(GetHeroStat(HeroMax2, STAT_SPELL_POWER) / 2) == 0.5 ) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 1); end;

     -- чародейская защита
     --if HasHeroSkill(HeroMax1, 176) then GiveArtefact(HeroMax1, 29); GiveArtefact(HeroMax1, 12); GiveArtefact(HeroMax1, 26); GiveArtefact(HeroMax1, 28); end;
     --if HasHeroSkill(HeroMax2, 176) then GiveArtefact(HeroMax2, 29); GiveArtefact(HeroMax2, 12); GiveArtefact(HeroMax2, 26); GiveArtefact(HeroMax2, 28); end;

     -- лесное коварство
     if HasHeroSkill(HeroMax1, 114) then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;
     if HasHeroSkill(HeroMax2, 114) then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;

     -- чувство стихий
     if HasHeroSkill(HeroMax1, 111) then SetTownBuildingLimitLevel('RANDOMTOWN1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 1); UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); end;
     if HasHeroSkill(HeroMax2, 111) then SetTownBuildingLimitLevel('RANDOMTOWN2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 1); UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); end;

     -- некролидерство
     if GetHeroSkillMastery(HeroMax1, SKILL_NECROMANCY) > 0 and hero1race == 3 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) >= GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) ); end;
     if GetHeroSkillMastery(HeroMax1, SKILL_NECROMANCY) > 0 and hero1race == 3 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) <  GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) ); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_NECROMANCY) > 0 and hero2race == 3 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) >= GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) ); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_NECROMANCY) > 0 and hero2race == 3 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) <  GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) ); end;

     -- открытие врат (+5% если не Нимус)
     --if GetHeroSkillMastery(HeroMax1, 14) > 0 and Name(HeroMax1) ~= "Nymus" then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN2', hero1race); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     --if GetHeroSkillMastery(HeroMax2, 14) > 0 and Name(HeroMax2) ~= "Nymus" then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN4', hero2race); SetObjectOwner('TOWN4', PLAYER_2); UpgradeTownBuilding('TOWN4', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;

     -- мститель
     if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 4 then TransformPlTown('TOWN1', 4); SetObjectOwner('TOWN1', PLAYER_1); UpgradeTownBuilding('TOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); TransformPlTown('TOWN2', 4); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 4 then TransformPlTown('TOWN5', 4); SetObjectOwner('TOWN5', PLAYER_2); UpgradeTownBuilding('TOWN5', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); TransformPlTown('TOWN6', 4); SetObjectOwner('TOWN6', PLAYER_2); UpgradeTownBuilding('TOWN6', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;

     -- управление машинами
     if GetHeroSkillMastery(HeroMax1, SKILL_WAR_MACHINES) > 0 then GiveHeroWarMachine(HeroMax1, 1); GiveHeroWarMachine(HeroMax1, 3); GiveHeroWarMachine(HeroMax1, 4); ChangeHeroStat(HeroMax1, STAT_LUCK, -1); ChangeHeroStat(HeroMax1, STAT_LUCK, 1); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_WAR_MACHINES) > 0 then GiveHeroWarMachine(HeroMax2, 1); GiveHeroWarMachine(HeroMax2, 3); GiveHeroWarMachine(HeroMax2, 4); ChangeHeroStat(HeroMax2, STAT_LUCK, -1); ChangeHeroStat(HeroMax2, STAT_LUCK, 1);  end;

     -- солдатская удача
     if HasHeroSkill(HeroMax1, 32) and HasHeroSkill(HeroMax1, 78) == nil then kolCreatures = GetHeroCreatures(HeroMax1,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  13, kolCreatures); AddHeroCreatures(HeroMax1,  14, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 134); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 134, kolCreatures); AddHeroCreatures(HeroMax1,  16, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1,  27); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  27, kolCreatures); AddHeroCreatures(HeroMax1,  24, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 154); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 154, kolCreatures); AddHeroCreatures(HeroMax1,  30, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 145); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 145, kolCreatures); AddHeroCreatures(HeroMax1,  44, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 166); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 166, kolCreatures); AddHeroCreatures(HeroMax1,  93, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 143, kolCreatures); AddHeroCreatures(HeroMax1,  84, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 102); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 102, kolCreatures); AddHeroCreatures(HeroMax1, 103, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 171); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 171, kolCreatures); AddHeroCreatures(HeroMax1,  95, kolCreatures); end; end;

     if HasHeroSkill(HeroMax2, 32) and HasHeroSkill(HeroMax2, 78) == nil then kolCreatures = GetHeroCreatures(HeroMax2,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  13, kolCreatures); AddHeroCreatures(HeroMax2,  14, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 134); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 134, kolCreatures); AddHeroCreatures(HeroMax2,  16, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2,  27); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  27, kolCreatures); AddHeroCreatures(HeroMax2,  24, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 154); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 154, kolCreatures); AddHeroCreatures(HeroMax2,  30, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 145); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 145, kolCreatures); AddHeroCreatures(HeroMax2,  44, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 166); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 166, kolCreatures); AddHeroCreatures(HeroMax2,  93, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 143, kolCreatures); AddHeroCreatures(HeroMax2,  84, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 102); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 102, kolCreatures); AddHeroCreatures(HeroMax2, 103, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 171); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 171, kolCreatures); AddHeroCreatures(HeroMax2,  95, kolCreatures); end; end;

     -- ангел-хранитель
     if HasHeroSkill(HeroMax1, 78) and HasHeroSkill(HeroMax1, 32) == nil then kolCreatures = GetHeroCreatures(HeroMax1,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  13, kolCreatures); AddHeroCreatures(HeroMax1, 118, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 78) then kolCreatures = GetHeroCreatures(HeroMax1, 112); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 112, kolCreatures); AddHeroCreatures(HeroMax1,  52, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 78) and HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  13, kolCreatures); AddHeroCreatures(HeroMax1,  66, kolCreatures); end; end;

     if HasHeroSkill(HeroMax2, 78) and HasHeroSkill(HeroMax2, 32) == nil then kolCreatures = GetHeroCreatures(HeroMax2,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  13, kolCreatures); AddHeroCreatures(HeroMax2, 118, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 78) then kolCreatures = GetHeroCreatures(HeroMax2, 112); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 112, kolCreatures); AddHeroCreatures(HeroMax2,  52, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 78) and HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  13, kolCreatures); AddHeroCreatures(HeroMax2,  66, kolCreatures); end; end;



     ------------- АРТЕФАКТЫ ---------------

     -- посох преисподней
     if HasArtefact(HeroMax1, 7, 1) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_INITIATIVE, -1); end;
     if HasArtefact(HeroMax2, 7, 1) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_INITIATIVE, -1); end;

     -- сила стихий (старая)
--     if (HasArtefact(HeroMax1, 5, 1)) and (HasArtefact(HeroMax1, 18, 1)) and (HasArtefact(HeroMax1, 32, 1)) and (HasArtefact(HeroMax1, 61, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, int(1.3 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER))));
--     else if (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 32, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 32, 1) and HasArtefact(HeroMax1, 61, 1))   then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0);
--     else if (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 18, 1)) or (HasArtefact(HeroMax1, 32, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 32, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0 - int(0.1 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER))));
--     else if  (HasArtefact(HeroMax1, 5, 1)) or (HasArtefact(HeroMax1, 18, 1)) or (HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 61, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER)))); end; end; end; end;

--     if (HasArtefact(HeroMax2, 5, 1)) and (HasArtefact(HeroMax2, 18, 1)) and (HasArtefact(HeroMax2, 32, 1)) and (HasArtefact(HeroMax2, 61, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, int(1.3 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER))));
--     else if (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 32, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 32, 1) and HasArtefact(HeroMax2, 61, 1))   then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0);
--     else if (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 18, 1)) or (HasArtefact(HeroMax2, 32, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 32, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0 - int(0.1 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER))));
--     else if  (HasArtefact(HeroMax2, 5, 1)) or (HasArtefact(HeroMax2, 18, 1)) or (HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 61, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER)))); end; end; end; end;

     -- сила стихий
--     if  (HasArtefact(HeroMax1, 5, 1)) or (HasArtefact(HeroMax1, 18, 1)) or (HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 61, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER)))); end;
--     if  (HasArtefact(HeroMax2, 5, 1)) or (HasArtefact(HeroMax2, 18, 1)) or (HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 61, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER)))); end;

     -- воля ургаша
     if GetHeroSkillMastery(HeroMax1, 14) > 0 and HasArtefact(HeroMax1, 23, 1) and HasArtefact(HeroMax1, 66, 1) then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN2', hero1race); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     if GetHeroSkillMastery(HeroMax2, 14) > 0 and HasArtefact(HeroMax2, 23, 1) and HasArtefact(HeroMax2, 66, 1) then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN4', hero2race); SetObjectOwner('TOWN4', PLAYER_2); UpgradeTownBuilding('TOWN4', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     --if GetHeroSkillMastery(HeroMax1, 14) > 0 and HasArtefact(HeroMax1, 23, 1) and HasArtefact(HeroMax1, 66, 1) then TransformPlTown('TOWN1', 2); SetObjectOwner('TOWN1', PLAYER_1); UpgradeTownBuilding('TOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); TransformPlTown('TOWN2', 2); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     --if GetHeroSkillMastery(HeroMax2, 14) > 0 and HasArtefact(HeroMax2, 23, 1) and HasArtefact(HeroMax2, 66, 1) then TransformPlTown('TOWN5', 2); SetObjectOwner('TOWN5', PLAYER_2); UpgradeTownBuilding('TOWN5', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); TransformPlTown('TOWN6', 2); SetObjectOwner('TOWN6', PLAYER_2); UpgradeTownBuilding('TOWN6', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;



     -- объятия смерти
     if HasArtefact(HeroMax1, 7, 1) and HasArtefact(HeroMax1, 33, 1) then NecroArtSet(HeroMax2); end;
     if HasArtefact(HeroMax2, 7, 1) and HasArtefact(HeroMax2, 33, 1) then NecroArtSet(HeroMax1); end;
     
     -- свиток маны
     if HasArtefact(HeroMax1, 10, 1) then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 50); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 25); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -50); end;
     if HasArtefact(HeroMax2, 10, 1) then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 50); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 25); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -50); end;

     -- кольцо грешников
     if HasArtefact(HeroMax1, 70, 1) then
       if GetHeroArtifactsCount(HeroMax1, 70, 1) == 1 then
         GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_LUCK, -1);
       else
         GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_LUCK, -2);
       end;
     end;
     if HasArtefact(HeroMax2, 70, 1) then
       if GetHeroArtifactsCount(HeroMax2, 70, 1) == 1 then
         GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_LUCK, -1);
       else
         GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_LUCK, -2);
       end;
     end;
     
     -- Доспех гномьих королей
     if GetArtifactSetItemsCount(HeroMax1, 5, 1) == 2 then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     if GetArtifactSetItemsCount(HeroMax1, 5, 1) == 3 then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 15); end;
     if GetArtifactSetItemsCount(HeroMax1, 5, 1) == 4 then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 20); end;
     if (GetArtifactSetItemsCount(HeroMax1, 5, 1) == 2 or GetArtifactSetItemsCount(HeroMax1, 5, 1) == 3 or GetArtifactSetItemsCount(HeroMax1, 5, 1) == 4) and GetHeroSkillMastery(HeroMax1, HERO_SKILL_RUNELORE) >  0 then ChangeHeroStat(HeroMax1, 3, 4); end;
     if GetArtifactSetItemsCount(HeroMax2, 5, 1) == 2 then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     if GetArtifactSetItemsCount(HeroMax2, 5, 1) == 3 then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 15); end;
     if GetArtifactSetItemsCount(HeroMax2, 5, 1) == 4 then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 20); end;
     if (GetArtifactSetItemsCount(HeroMax2, 5, 1) == 2 or GetArtifactSetItemsCount(HeroMax2, 5, 1) == 3 or GetArtifactSetItemsCount(HeroMax2, 5, 1) == 4) and GetHeroSkillMastery(HeroMax2, HERO_SKILL_RUNELORE) >  0 then ChangeHeroStat(HeroMax2, 3, 4); end;


     --------------- ГЕРОИ -----------------

     -- Валерия
--     if Name(HeroMax1) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax1,   9); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,   9, kolCreatures); AddHeroCreatures(HeroMax1, 52, kolCreatures); end; end;
--     if Name(HeroMax1) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax1, 110); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 110, kolCreatures); AddHeroCreatures(HeroMax1, 66, kolCreatures); end; end;
--     if Name(HeroMax2) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax2,   9); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,   9, kolCreatures); AddHeroCreatures(HeroMax2, 52, kolCreatures); end; end;
--     if Name(HeroMax2) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax2, 110); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 110, kolCreatures); AddHeroCreatures(HeroMax2, 66, kolCreatures); end; end;

     -- Аграил
--     if Name(HeroMax1) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax1,  15); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  15, kolCreatures); AddHeroCreatures(HeroMax1, 16, kolCreatures); end; end;
--     if Name(HeroMax1) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax1, 131); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 131, kolCreatures); AddHeroCreatures(HeroMax1, 44, kolCreatures); end; end;
--     if Name(HeroMax2) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax2,  15); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  15, kolCreatures); AddHeroCreatures(HeroMax2, 16, kolCreatures); end; end;
--     if Name(HeroMax2) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax2, 131); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 131, kolCreatures); AddHeroCreatures(HeroMax2, 44, kolCreatures); end; end;

     -- Таланар
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1,  45); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  45, kolCreatures); AddHeroCreatures(HeroMax1, 46, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1, 146); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 146, kolCreatures); AddHeroCreatures(HeroMax1, 18, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2,  45); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  45, kolCreatures); AddHeroCreatures(HeroMax2, 46, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2, 146); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 146, kolCreatures); AddHeroCreatures(HeroMax2, 18, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  47, kolCreatures); AddHeroCreatures(HeroMax1, 48, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 147, kolCreatures); AddHeroCreatures(HeroMax1, 20, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  47, kolCreatures); AddHeroCreatures(HeroMax2, 48, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 147, kolCreatures); AddHeroCreatures(HeroMax2, 20, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  49, kolCreatures); AddHeroCreatures(HeroMax1, 50, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 148, kolCreatures); AddHeroCreatures(HeroMax1, 22, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  49, kolCreatures); AddHeroCreatures(HeroMax2, 50, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 148, kolCreatures); AddHeroCreatures(HeroMax2, 22, kolCreatures); end; end;

     -- Файдаэн
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  47, kolCreatures); AddHeroCreatures(HeroMax1, 62, kolCreatures); end; end;
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 147, kolCreatures); AddHeroCreatures(HeroMax1, 76, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  47, kolCreatures); AddHeroCreatures(HeroMax2, 62, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 147, kolCreatures); AddHeroCreatures(HeroMax2, 76, kolCreatures); end; end;
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  49, kolCreatures); AddHeroCreatures(HeroMax1, 72, kolCreatures); end; end;
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 148, kolCreatures); AddHeroCreatures(HeroMax1, 74, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  49, kolCreatures); AddHeroCreatures(HeroMax2, 72, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 148, kolCreatures); AddHeroCreatures(HeroMax2, 74, kolCreatures); end; end;

     -- Аларон
--     if Name(HeroMax1) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax1,  55); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  55, kolCreatures); AddHeroCreatures(HeroMax1, 56, kolCreatures); end; end;
--     if Name(HeroMax1) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax1, 151); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 151, kolCreatures); AddHeroCreatures(HeroMax1, 84, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax2,  55); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  55, kolCreatures); AddHeroCreatures(HeroMax2, 56, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax2, 151); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 151, kolCreatures); AddHeroCreatures(HeroMax2, 84, kolCreatures); end; end;

     -- Тиеру
--     if Name(HeroMax1) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax1,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  49, kolCreatures); AddHeroCreatures(HeroMax1, 64, kolCreatures); end; end;
--     if Name(HeroMax1) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax1, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 148, kolCreatures); AddHeroCreatures(HeroMax1, 60, kolCreatures); end; end;
--     if Name(HeroMax2) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax2,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  49, kolCreatures); AddHeroCreatures(HeroMax2, 64, kolCreatures); end; end;
--     if Name(HeroMax2) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax2, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 148, kolCreatures); AddHeroCreatures(HeroMax2, 60, kolCreatures); end; end;

     -- Эрин
     if Name(HeroMax1) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax1,  81); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  81, kolCreatures); AddHeroCreatures(HeroMax1, 82, kolCreatures); end; end;
--     if Name(HeroMax1) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax1, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 143, kolCreatures); AddHeroCreatures(HeroMax1, 82, kolCreatures); end; end;
     if Name(HeroMax2) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax2,  81); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  81, kolCreatures); AddHeroCreatures(HeroMax2, 82, kolCreatures); end; end;
--     if Name(HeroMax2) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax2, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 143, kolCreatures); AddHeroCreatures(HeroMax2, 82, kolCreatures); end; end;

     -- Соргал
     if Name(HeroMax1) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax1,  77); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  77, kolCreatures); AddHeroCreatures(HeroMax1, 200 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;
     if Name(HeroMax1) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax1, 141); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 141, kolCreatures); AddHeroCreatures(HeroMax1, 210 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;
     if Name(HeroMax2) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax2,  77); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  77, kolCreatures); AddHeroCreatures(HeroMax2, 200 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;
     if Name(HeroMax2) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax2, 141); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 141, kolCreatures); AddHeroCreatures(HeroMax2, 210 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;

     -- Вульфстен
     if Name(HeroMax1) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax1,  98); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  98, kolCreatures); AddHeroCreatures(HeroMax1, 99, kolCreatures); end; end;
     if Name(HeroMax1) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax1, 169); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 169, kolCreatures); AddHeroCreatures(HeroMax1, 80, kolCreatures); end; end;
     if Name(HeroMax2) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax2,  98); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  98, kolCreatures); AddHeroCreatures(HeroMax2, 99, kolCreatures); end; end;
     if Name(HeroMax2) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax2, 169); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 169, kolCreatures); AddHeroCreatures(HeroMax2, 80, kolCreatures); end; end;

     -- Шак'Карукат
--     if Name(HeroMax1) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax1,  28); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  28, kolCreatures); AddHeroCreatures(HeroMax1, 128, kolCreatures); end; end;
--     if Name(HeroMax1) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax1, 137); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 137, kolCreatures); AddHeroCreatures(HeroMax1, 130, kolCreatures); end; end;
--     if Name(HeroMax2) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax2,  28); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  28, kolCreatures); AddHeroCreatures(HeroMax2, 128, kolCreatures); end; end;
--     if Name(HeroMax2) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax2, 137); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 137, kolCreatures); AddHeroCreatures(HeroMax2, 130, kolCreatures); end; end;

     -- Вайшан
--     if Name(HeroMax1) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax1,  71); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  71, kolCreatures); AddHeroCreatures(HeroMax1,  93, kolCreatures); end; end;
--     if Name(HeroMax1) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax1, 138); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 138, kolCreatures); AddHeroCreatures(HeroMax1, 101, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax2,  71); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  71, kolCreatures); AddHeroCreatures(HeroMax2,  93, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax2, 138); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 138, kolCreatures); AddHeroCreatures(HeroMax2, 101, kolCreatures); end; end;


     -- Курак
--     if Name(HeroMax1) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax1, 123); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 123, kolCreatures); AddHeroCreatures(HeroMax1, 124, kolCreatures); end; end;
--     if Name(HeroMax1) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax1, 176); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 176, kolCreatures); AddHeroCreatures(HeroMax1, 126, kolCreatures); end; end;
--     if Name(HeroMax2) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax2, 123); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 123, kolCreatures); AddHeroCreatures(HeroMax2, 124, kolCreatures); end; end;
--     if Name(HeroMax2) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax2, 176); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 176, kolCreatures); AddHeroCreatures(HeroMax2, 126, kolCreatures); end; end;

     -- Грок
     if Name(HeroMax1) == "Grok" then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_SPEED, 1); end;
     if Name(HeroMax2) == "Grok" then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_SPEED, 1); end;
     
     -- Марбас
     if Name(HeroMax1) == "Marder" then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, round(0.4 * GetHeroLevel(HeroMax1) ) ); end;
     if Name(HeroMax2) == "Marder" then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, round(0.4 * GetHeroLevel(HeroMax2) ) ); end;

     -- Илайя
     --if Name(HeroMax1) == "Shadwyn" then SetObjectOwner('Dwel1', PLAYER_1); TransformTown('Dwel1', 3); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_MAGIC_GUILD); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); TeachHeroSpell(HeroMax1, 1); TeachHeroSpell(HeroMax1, 3); TeachHeroSpell(HeroMax1, 4); TeachHeroSpell(HeroMax1, 237); end;
     --if Name(HeroMax2) == "Shadwyn" then SetObjectOwner('Dwel2', PLAYER_2); TransformTown('Dwel2', 3); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_MAGIC_GUILD); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); TeachHeroSpell(HeroMax2, 1); TeachHeroSpell(HeroMax2, 3); TeachHeroSpell(HeroMax2, 4); TeachHeroSpell(HeroMax2, 237); end;
     
     -- Бранд
     if Name(HeroMax1) == "Brand" then res = floor(GetHeroLevel(HeroMax1)/6); SetPlayerResource(1, WOOD, GetPlayerResource( 1, WOOD) + res); SetPlayerResource(1, ORE, GetPlayerResource( 1, ORE) + res); SetPlayerResource(1, MERCURY, GetPlayerResource( 1, MERCURY) + res); SetPlayerResource(1, CRYSTAL, GetPlayerResource( 1, CRYSTAL) + res); SetPlayerResource(1, SULFUR, GetPlayerResource( 1, SULFUR) + res); SetPlayerResource(1, GEM, GetPlayerResource( 1, GEM) + res); end;
     if Name(HeroMax2) == "Brand" then res = floor(GetHeroLevel(HeroMax2)/6); SetPlayerResource(2, WOOD, GetPlayerResource( 2, WOOD) + res); SetPlayerResource(2, ORE, GetPlayerResource( 2, ORE) + res); SetPlayerResource(2, MERCURY, GetPlayerResource( 2, MERCURY) + res); SetPlayerResource(2, CRYSTAL, GetPlayerResource( 2, CRYSTAL) + res); SetPlayerResource(2, SULFUR, GetPlayerResource( 2, SULFUR) + res); SetPlayerResource(2, GEM, GetPlayerResource( 2, GEM) + res); end;

     -- Куджин
     if Name(HeroMax1) == "Kujin" then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_STRONGHOLD_PILE_OF_OUR_FOES); end;
     if Name(HeroMax2) == "Kujin" then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_STRONGHOLD_PILE_OF_OUR_FOES); end;
     
     if TeleportUse1 == 0 and (hero1race == 4 or hero1race == 5) then TeleportBattleZone1(); BattleNextDay1 = 1; else BattleNextDay1 = 0; end;
     if TeleportUse2 == 0 and (hero2race == 4 or hero2race == 5) then TeleportBattleZone2(); BattleNextDay2 = 1; else BattleNextDay2 = 0; end;


     sleep(5);

--     if (HasHeroSkill(HeroMax1, 21) and HasHeroSkill(HeroMax2, 19) == nil) or (HasHeroSkill(HeroMax2, 21) and HasHeroSkill(HeroMax1, 19) == nil) then
--       MakeHeroInteractWithObject (HeroMax1, 'boat1');
--       MakeHeroInteractWithObject (HeroMax2, 'boat2');
--       MakeHeroInteractWithObject (HeroMax2, HeroMax1);
--     end;

     if option[NumberBattle] == 2 then BattleInTown1(); end;
     if option[NumberBattle] == 3 then BattleInTown2(); end;

     sleep(5);
     
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

function DayFour1()
  -- Аларон
  if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) == 3 then SubHero(HeroMax1, "Ildar3"); HeroMax1 = "Ildar3"; sleep(3); end;
  if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_LIGHT_MAGIC); end;

  -- Джалиб
  if Name(HeroMax1) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax1,  65); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  65, kolCreatures); AddHeroCreatures(HeroMax1, 68, kolCreatures); end; end;
  if Name(HeroMax1) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax1, 163); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 163, kolCreatures); AddHeroCreatures(HeroMax1, 70, kolCreatures); end; end;

  -- солдатская удача
  if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1,  57); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  57, kolCreatures); AddHeroCreatures(HeroMax1, 60, kolCreatures); end; end;
  if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 165); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 165, kolCreatures); AddHeroCreatures(HeroMax1, 64, kolCreatures); end; end;

  -- инфо
  if hero2race == 4 and hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax1, 1, 5.0); end;
  if hero2race == 5 and hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax1, 1, 5.0); end;
end;

function DayFour2()
  -- Аларон
  if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) == 3 then SubHero(HeroMax1, "Ildar3"); HeroMax1 = "Ildar3"; sleep(3); end;
  if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_LIGHT_MAGIC); end;

  -- Джалиб
  if Name(HeroMax2) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax2,  65); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  65, kolCreatures); AddHeroCreatures(HeroMax2, 68, kolCreatures); end; end;
  if Name(HeroMax2) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax2, 163); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 163, kolCreatures); AddHeroCreatures(HeroMax2, 70, kolCreatures); end; end;

  -- солдатская удача
  if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2,  57); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  57, kolCreatures); AddHeroCreatures(HeroMax2, 60, kolCreatures); end; end;
  if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 165); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 165, kolCreatures); AddHeroCreatures(HeroMax2, 64, kolCreatures); end; end;

  -- инфо
  if hero1race == 4 and hero2race ~= 3 and hero2race ~= 4 and hero2race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax2, 2, 5.0); end;
  if hero1race == 5 and hero2race ~= 3 and hero2race ~= 4 and hero2race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax2, 2, 5.0); end;
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

  -- анализ проигравшей стороны
  --n_stacks = GetSavedCombatArmyCreaturesCount(id, 0);
  --for i = 0,(n_stacks-1) do
  --  creature, count, died = GetSavedCombatArmyCreatureInfo(id, 0, i);
  --  Info_Hero_ArmyRemainder = Info_Hero_ArmyRemainder .. 'ID' .. creature .. ' = ' .. (count - died) .. ', '
  --end
  
  
  
  --print(Info_Hero_ArmyRemainder)

  if IsHeroAlive(HeroMax1) then
    --Loose(2)
    TalkBoxForPlayers( 1, "/Textures/Icons/Heroes/Inferno/Inferno_Biara_128x128.(Texture).xdb#xpointer(/Texture)", GetMapDataPath().."ReportDSCRP.txt", nil, nil, 'SendReport', 0, GetMapDataPath().."ReportNAME.txt", GetMapDataPath().."ReportQ.txt", nil, GetMapDataPath().."Tournament1.txt", GetMapDataPath().."Tournament2.txt", GetMapDataPath().."Tournament3.txt", GetMapDataPath().."Tournament4.txt", GetMapDataPath().."Tournament5.txt");
    --QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."ReportQ.txt", 'SendReport', 'DeleteReport');
--    print('Winner: Player1');

--    Loose(2);
--    sleep(3);
--    consoleCmd('profile_name');
  end;
  if IsHeroAlive(HeroMax2) then
    --Loose(1)
    TalkBoxForPlayers( 2, "/UI/H5A1/Icons/Heroes/Portrets128x128/Giovanni.(Texture).xdb#xpointer(/Texture)", GetMapDataPath().."ReportDSCRP.txt", nil, nil, 'SendReport', 0, GetMapDataPath().."ReportNAME.txt", GetMapDataPath().."ReportQ.txt", nil, GetMapDataPath().."Tournament1.txt", GetMapDataPath().."Tournament2.txt", GetMapDataPath().."Tournament3.txt", GetMapDataPath().."Tournament4.txt", GetMapDataPath().."Tournament5.txt");
    --QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."ReportQ.txt", 'SendReport', 'DeleteReport');
  
--    print('Winner: Player2')
--    Loose(1);
--    sleep(3);
--    consoleCmd('profile_name');
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
  --print('hero1_mana=')
  --h1b=parse(GetGameVar('hero1_mana'))()
  --print('hero1_mana=',h1b)
  --if player == 1 then print('Hero1_Mana_R: ', GetHeroStat(HeroMax1, 8)); else print('Hero2_Mana_R: ', GetHeroStat(HeroMax2, 8)); end

  --HERO1_MANA = GetGameVar('hero1_mana')
  --print(HERO1_MANA)
  
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

--  print(Info_Hero_Name);
--  print(Info_Hero_Level);
--  print(Info_Hero_Attack);
--  print(Info_Hero_Defence);
--  print(Info_Hero_Spellpower);
--  print(Info_Hero_Knowledge);
--  print(Info_Hero_Luck);
--  print(Info_Hero_Morale);
--  print(Info_Hero_StartBonus);
--  print(Info_Hero_Army);
--  print(Info_Hero_Arts);
--  print(Info_Hero_Spells);
--  print(Info_Hero_Skills);
--  print(Info_Hero_Perks);
end;


----------------------- HERO SPEC -------------------------

function CrownLeader(hero)
  kol_u[1]=0;kol_u[2]=0;kol_u[3]=0;kol_u[4]=0;kol_u[5]=0;kol_u[6]=0;kol_u[7]=0;
  kol_u[1], kol_u[2], kol_u[3], kol_u[4], kol_u[5], kol_u[6], kol_u[7] = GetHeroCreaturesTypes(hero);
  for i = 1, 7 do
    if kol_u[i] > 0 then
      AddHeroCreatures(hero, kol_u[i], 1);
    end;
  end;
end;


----------------------------- GLOBAL MODE --------------------------------------


array_level = {};
array_level = {       0,         -- 0    1
                   1000,         -- 1    2
                   2000,         -- 2    3
                   3200,         -- 3    4
                   4600,         -- 4    5
                   6200,         -- 5    6
                   8000,         -- 6    7
                  10000,         -- 7    8
                  12200,         -- 8    9
                  14700,         -- 9    10
                  17500,         --10    11
                  20600,         --11    12
                  24320,         --12    13
                  28784,         --13    14
                  34140,         --14    15
                  40567,         --15    16
                  48279,         --16    17
                  57533,         --17    18
                  68637,         --18    19
                  81961,         --19    20
                  97949,         --20    21
                 117134,         --21    22
                 140156,         --22    23
                 167782,         --23    24
                 200933,         --24    25
                 244029,         --25    26
                 304363,         --26    27
                 394864,         --27    28
                 539665,         --28    29
                 785826,         --29    30
                1228915,         --30    31
                2070784,         --31    32
                3754522,         --32    33
                7290371,         --33    34
               15069240,         --34    35
               32960630,         --35    36
               75899970,         --36    37
              183258314,         --37    38
              462353978,         --38    39
             1215939194};        --39    40

function ChangeLevel(hero, delta)
  heroExp = GetHeroStat(hero, STAT_EXPERIENCE);
  heroLevel = GetHeroLevel(hero);
  deltaExp = array_level[heroLevel + delta + 1] - array_level[heroLevel + 1];
  WarpHeroExp (hero, heroExp + deltaExp);
end;

array_units_for_recruitment = {};
array_units_for_recruitment = { 1, 2, 3, 4, 5, 6, 15, 16, 17, 18, 19, 20, 29, 30, 31, 32, 33, 34, 43, 44, 45, 46, 47, 48, 57, 58, 59, 60, 61, 62, 71, 71, 73, 74, 75, 76, 92, 93, 94, 95, 96, 97, 106, 107, 108, 117, 118, 119, 120, 121, 122, 131, 132, 133, 138, 139, 140, 145, 146, 147, 152, 153, 154, 159, 160, 161, 166, 167, 168, 173, 174, 175};

kolUnit1 = {intg(K * kol_u1_pl1), intg(K * kol_u2_pl1), intg(K * kol_u3_pl1), intg(K * kol_u4_pl1), intg(K * kol_u5_pl1), intg(K * kol_u6_pl1), intg(K * kol_u7_pl1)};
Unit2 = {intg(K * kol_u1_pl2), intg(K * kol_u2_pl2), intg(K * kol_u3_pl2), intg(K * kol_u4_pl2), intg(K * kol_u5_pl2), intg(K * kol_u6_pl2), intg(K * kol_u7_pl2)}

function recruitment1(hero)
  Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetHeroCreaturesTypes(hero);
  if HasArtefact( hero, 88, 1) then k1 = CrownOfLeaderBonus; else k1 = 1; end;
  for i = 1, 7 do
    if Stek1[i].id > 0 then
      for j = 1, 8 do
        for k = 1, 21 do
          if Stek1[i].id == array_units[j][k].id and array_units[j][k].lvl < 4 then
            Stek1[i].kol = int(k1 * RecruitmentCoef * kolUnit1[array_units[j][k].lvl]);
            AddHeroCreatures(hero, Stek1[i].id, Stek1[i].kol );
            k = 21;
            j = 8;
          end;
        end;
      end;
    end;
  end;
end;

function recruitment2(hero)
  Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetHeroCreaturesTypes(hero);
  if HasArtefact( hero, 88, 1) then k2 = CrownOfLeaderBonus; else k2 = 1; end;
  for i = 1, 7 do
    if Stek2[i].id > 0 then
      for j = 1, 8 do
        for k = 1, 21 do
          if Stek2[i].id == array_units[j][k].id and array_units[j][k].lvl < 4 then
            Stek2[i].kol = int(k2 * RecruitmentCoef * kolUnit2[array_units[j][k].lvl]);
            AddHeroCreatures(hero, Stek2[i].id, Stek2[i].kol );
            k = 21;
            j = 8;
          end;
        end;
      end;
    end;
  end;
end;



DiplomacyEnable1 = 0;
DiplomacyEnable2 = 0;
--DiplomacyTrue1 = 0;
--DiplomacyTrue2 = 0;

array_mage = {}
array_mage = {
   { ["kol"] = 3, ["id"] =  10},
   { ["kol"] = 3, ["id"] = 110},
   { ["kol"] = 2, ["id"] =  26},
   { ["kol"] = 5, ["id"] = 134},
   { ["kol"] = 3, ["id"] =  38},
   { ["kol"] = 3, ["id"] = 156},
   { ["kol"] = 4, ["id"] =  50},
   { ["kol"] = 4, ["id"] = 148},
   { ["kol"] = 5, ["id"] =  64},
   { ["kol"] = 5, ["id"] = 162},
   { ["kol"] = 2, ["id"] =  82},
   { ["kol"] = 2, ["id"] = 143},
   { ["kol"] = 3, ["id"] = 101},
   { ["kol"] = 3, ["id"] = 170},
   { ["kol"] = 4, ["id"] = 124},
   { ["kol"] = 4, ["id"] = 176}
};

function NoActivity (hero1, hero2)
  bonus = 1;
  if HasHeroSkill(hero2,  21)   then bonus = bonus + 3; end;
  if HasHeroSkill(hero2, 141)   then bonus = bonus + 3; end;
  if HasArtefact (hero2, 57, 1) then bonus = bonus + 3; end;
  if HasArtefact (hero2, 59, 1) then bonus = bonus + 3; end;
  ChangeHeroStat(hero1, 2, bonus);
end;

PathFindingX = {} ;
PathFindingX = { 50, 56, 48, 50, 44, 44, 56, 51};

PathFindingY = {} ;
PathFindingY = { 45, 49, 52, 45, 48, 42, 41, 38};

function PathFinding(HeroWithPerk, HeroWithoutPerk, race)
--  if HasHeroSkill(HeroWithPerk, 177) then GiveHeroBattleBonus(HeroWithPerk, HERO_BATTLE_BONUS_ATTACK, 2); GiveHeroBattleBonus(HeroWithPerk, HERO_BATTLE_BONUS_DEFENCE, 2); end;
--  GiveHeroBattleBonus(HeroWithPerk, HERO_BATTLE_BONUS_LUCK, 1);
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

function Insights(hero)
  if KnowHeroSpell(hero, array_spells[2][8].id) and KnowHeroSpell(hero, array_spells[2][9].id) and KnowHeroSpell(hero, array_spells[2][10].id) and KnowHeroSpell(hero, array_spells[2][11].id) and KnowHeroSpell(hero, array_spells[2][12].id) then
  else
    rnd = random(5) + 8;
    while KnowHeroSpell(hero, array_spells[2][rnd].id) do
      rnd = random(5) + 8;
    end;
    TeachHeroSpell(hero, array_spells[2][rnd].id);
  end;
end;

function Function_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY == CUSTOM_ABILITY_1) and (GetObjectOwner(hero) == 1) then
    HeroR1 = hero;
    x1, y1 = GetObjectPosition(HeroR1);
    DenyGarrisonCreaturesTakeAway('regrade1', 0);
    MakeHeroInteractWithObject (hero, 'regrade1');
    startThread (RegradeUnit1);
  end;

  if (CUSTOM_ABILITY == CUSTOM_ABILITY_1) and (GetObjectOwner(hero) == 2) then
    HeroR2 = hero;
    x2, y2 = GetObjectPosition(HeroR2);
    DenyGarrisonCreaturesTakeAway('regrade2', 0);
    MakeHeroInteractWithObject (hero, 'regrade2');
    startThread (RegradeUnit2);
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax1) then
    SaleArmyQuestion(HeroMax1)
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax2) then
    SaleArmyQuestion(HeroMax2)
  end;
end;

SaleArmyUse1 = 0;
SaleArmyUse2 = 0;

function SaleArmyQuestion(hero)
  if GetObjectOwner(hero) == 1 then
    price = 0;
    if HasArtefact( hero, 88, 1) then k = CrownOfLeaderBonus else k = 1; end;
    for i = 1, 8 do
      for j = 1, 21 do
        if GetObjectDwellingCreatures('RANDOMTOWN1', array_units[i][j].id) > 0 then
          price = price + SaleArmyCoef * GetObjectDwellingCreatures('RANDOMTOWN1', array_units[i][j].id) * array_units[i][j].price1;
        end;
      end;
    end;
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."SaleArmy.txt"; eq = 0.5 * price}, 'SaleArmyQ1', 'no');
  end;
  if GetObjectOwner(hero) == 2 then
    price = 0;
    if HasArtefact( hero, 88, 1) then k = CrownOfLeaderBonus else k = 1; end;
    for i = 1, 8 do
      for j = 1, 21 do
        if GetObjectDwellingCreatures('RANDOMTOWN2', array_units[i][j].id) > 0 then
          price = price + SaleArmyCoef * GetObjectDwellingCreatures('RANDOMTOWN2', array_units[i][j].id) * array_units[i][j].price1;
        end;
      end;
    end;
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."SaleArmy.txt"; eq = 0.5 * price}, 'SaleArmyQ2', 'no');
  end;
end;

function SaleArmyQ1()
  SaleArmy('RANDOMTOWN1', HeroMax1);
  SaleArmyUse1 = 1;
end;

function SaleArmyQ2()
  SaleArmy('RANDOMTOWN2', HeroMax2);
  SaleArmyUse2 = 1;
end;

function SaleArmy(town, hero)
  price = 0;
  if HasArtefact( hero, 88, 1) then k = CrownOfLeaderBonus else k = 1; end;
  for i = 1, 8 do
    for j = 1, 21 do
      if GetObjectDwellingCreatures(town, array_units[i][j].id) > 0 then
        SetPlayerResource (GetObjectOwner(hero), GOLD, (GetPlayerResource (GetObjectOwner(hero), GOLD) + k * SaleArmyCoef * GetObjectDwellingCreatures(town, array_units[i][j].id) * array_units[i][j].price1));
        price = price + SaleArmyCoef * GetObjectDwellingCreatures(town, array_units[i][j].id) * array_units[i][j].price1;
        SetObjectDwellingCreatures(town, array_units[i][j].id, 0);
      end;
    end;
  end;
  x, y = GetObjectPosition(hero);
  Play2DSoundForPlayers ( GetObjectOwner(hero), "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x, y, 0);
  ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = price}, hero, GetObjectOwner(hero), 5.0);
end;

HauntMineEnable1 = 0;
HauntMineEnable2 = 0;

function HauntMine1(hero)
  if HauntMineEnable1 == 0 then
    AddHeroCreatures(hero, 34, 20);
  end;
  HauntMineEnable1 = 1;
end;

function HauntMine2(hero)
  if HauntMineEnable2 == 0 then
    AddHeroCreatures(hero, 34, 20);
  end;
  HauntMineEnable2 = 1;
end;

array_skills_Hero = {}
array_skills_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_skills_Hero1 = {}
array_skills_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_skills_Hero2 = {}
array_skills_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_Hero = {}
array_perks_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_Hero1 = {}
array_perks_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_Hero2 = {}
array_perks_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_arts_Hero = {}
array_arts_Hero = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

array_arts_Hero1 = {}
array_arts_Hero1 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

array_arts_Hero2 = {}
array_arts_Hero2 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

array_army_Hero = {}
array_army_Hero = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};

array_army_Hero1 = {}
array_army_Hero1 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};

array_army_Hero2 = {}
array_army_Hero2 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};

array_machine_Hero = {}
array_machine_Hero = { 0, 0, 0}

array_machine_Hero1 = {}
array_machine_Hero1 = { 0, 0, 0}

array_machine_Hero2 = {}
array_machine_Hero2 = { 0, 0, 0}

function SubHero(hero1, hero2)
  j = 1;
  for i = 1, 26 do
    array_skills_Hero[i] = GetHeroSkillMastery(hero1, array_skills[i]);
  end;

  for i = 1, 189 do
    if HasHeroSkill(hero1, array_perks[i]) then
      array_perks_Hero[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero = j;
    end;
  end;

  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(hero1, array_arts[i][j].id, 0) then
        array_arts_Hero[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(hero1, array_arts[i][j].id, 1) then
        array_arts_Hero[k - 1].Eq = 1;
        RemoveArtefact(hero1, array_arts[i][j].id);
      end;
    end;
  end;

  j = 1;
  for i = 1, 179 do
    if GetHeroCreatures( hero1, i) > 0 then
      array_army_Hero[j].ID  = i;
      array_army_Hero[j].kol = GetHeroCreatures( hero1, i);
      j = j + 1;
    end;
  end;

  j = 1;
  for i = 1, 4 do
    if HasHeroWarMachine(hero1, i) and i ~= 2 then
      array_machine_Hero[j]  = i;
      j = j + 1;
    end;
  end;
  
  expHero = GetHeroStat(hero1, STAT_EXPERIENCE);
  attHero = GetHeroStat(hero1, STAT_ATTACK);
  defHero = GetHeroStat(hero1, STAT_DEFENCE);
  spHero  = GetHeroStat(hero1, STAT_SPELL_POWER);
  knHero  = GetHeroStat(hero1, STAT_KNOWLEDGE);

  x, y = GetObjectPosition(hero1);
  RemoveObject(hero1);
  DeployReserveHero(hero2, x, y, 0);
  Trigger( HERO_ADD_SKILL_TRIGGER, hero2, 'no');
  WarpHeroExp(hero2, expHero);
  for i = 1, 26 do
    for j = 1, array_skills_Hero[i] do
      if array_skills_Hero[i] >= j then
        if GetHeroSkillMastery(hero2, array_skills[i]) < array_skills_Hero[i] then
          GiveHeroSkill(hero2, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero do
    GiveHeroSkill(hero2, array_perks_Hero[i]);
  end;
  
  k = 0;
  for i = 1, 189 do
    if HasHeroSkill( hero2, array_perks[i]) then
      k = k + 1;
    end;
  end;
  while k < (kol_perks_Hero - 1) do
    for i = 1, kol_perks_Hero do
      if HasHeroSkill( hero2, array_perks_Hero[i]) == nil then
        GiveHeroSkill(hero2, array_perks_Hero[i]);
        k = k + 1;
        if array_perks_Hero[i] == 115 and GetHeroCreatures(hero2, 146) > 0 then RemoveHeroCreatures(hero2, 146, 10); end;
        if array_perks_Hero[i] == 181 and GetHeroCreatures(hero2, 173) > 0 then RemoveHeroCreatures(hero2, 173, 15); end;
      end;
    end;
  end;

  for i = 1, length(array_army_Hero) do
    if array_army_Hero[i].ID ~= 0 then
      AddHeroCreatures(hero2, array_army_Hero[i].ID, array_army_Hero[i].kol);
      if GetHeroCreatures(hero2, 88) > 0 then RemoveHeroCreatures(hero2, 88, GetHeroCreatures(hero2, 88)); end;
    end;
  end;

  for i = 1, length(array_machine_Hero) do
    if array_machine_Hero[i] ~= 0 then
      GiveHeroWarMachine(hero2, array_machine_Hero[i]);
    end;
  end;
  
  if StartBonus[GetObjectOwner(hero2)] == 'spell' then
    TeachHeroSpell(hero2, array_spells[BonusSpells[GetObjectOwner(hero2) - 1].m1][BonusSpells[GetObjectOwner(hero2) - 1].sp1].id );
    TeachHeroSpell(hero2, array_spells[BonusSpells[GetObjectOwner(hero2) - 1].m2][BonusSpells[GetObjectOwner(hero2) - 1].sp2].id );
  end;

  attHero = attHero - GetHeroStat(hero2, STAT_ATTACK); --print(attHero2);
  defHero = defHero - GetHeroStat(hero2, STAT_DEFENCE); --print(defHero2);
  spHero  = spHero  - GetHeroStat(hero2, STAT_SPELL_POWER); --print(spHero2);
  knHero  = knHero  - GetHeroStat(hero2, STAT_KNOWLEDGE); --print(knHero2);

  if attHero > 0 then ChangeHeroStat(hero2, STAT_ATTACK,      attHero); end;
  if defHero > 0 then ChangeHeroStat(hero2, STAT_DEFENCE,     defHero); end;
  if spHero  > 0 then ChangeHeroStat(hero2, STAT_SPELL_POWER,  spHero); end;
  if knHero  > 0 then ChangeHeroStat(hero2, STAT_KNOWLEDGE,    knHero); end;

  for i = 1, length(array_arts_Hero) do
    if array_arts_Hero[i].ID ~= 0 and array_arts_Hero[i].Eq == 1 then
      GiveArtefact(hero2, array_arts_Hero[i].ID);
    end;
  end;
  for i = 1, length(array_arts_Hero) do
    if array_arts_Hero[i].ID ~= 0 and array_arts_Hero[i].Eq == 0 then
      GiveArtefact(hero2, array_arts_Hero[i].ID);
    end;
  end;

  sleep(2);

  array_skills_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_perks_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_arts_Hero = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}
  array_army_Hero = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};
  array_machine_Hero = { 0, 0, 0}
end;

--------------------------------------------------------------------------------

function NecroArtSet(hero)
  if GetHeroSkillMastery(hero,          SKILL_TRAINING) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 2, -2); end;
  if GetHeroSkillMastery(hero,            SKILL_GATING) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 4, -2); end;
  if GetHeroSkillMastery(hero,        SKILL_NECROMANCY) > 0 then ChangeHeroStat(hero, 2, -2); ChangeHeroStat(hero, 3, -2); end;
  if GetHeroSkillMastery(hero,           SKILL_AVENGER) > 0 then ChangeHeroStat(hero, 2, -2); ChangeHeroStat(hero, 4, -2); end;
  if GetHeroSkillMastery(hero,        SKILL_ARTIFICIER) > 0 then ChangeHeroStat(hero, 3, -2); ChangeHeroStat(hero, 4, -2); end;
  if GetHeroSkillMastery(hero,        SKILL_INVOCATION) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 3, -2); end;
  if GetHeroSkillMastery(hero,     HERO_SKILL_RUNELORE) > 0 then ChangeHeroStat(hero, 2, -2); ChangeHeroStat(hero, 3, -2); end;
  if GetHeroSkillMastery(hero, HERO_SKILL_DEMONIC_RAGE) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 2, -2); end;
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

Trigger( OBJECT_TOUCH_TRIGGER, 'port1', 'TeleportStartZone1' ); SetObjectEnabled('port1', nil); SetDisabledObjectMode('port1', 2);
Trigger( OBJECT_TOUCH_TRIGGER, 'port2', 'TeleportStartZone2' ); SetObjectEnabled('port2', nil); SetDisabledObjectMode('port2', 2);

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