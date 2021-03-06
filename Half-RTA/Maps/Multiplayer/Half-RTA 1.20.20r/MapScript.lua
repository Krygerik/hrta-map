consoleCmd('@nde = 1')

sleep(10)
if nde == 1 then
	return
end

consoleCmd('console_size 999')
consoleCmd('game_writelog 0')
sleep(1)

doFile(GetMapDataPath()..'common.lua');
doFile(GetMapDataPath()..'constants.lua');
doFile(GetMapDataPath().."day1/day1_scripts.lua");
sleep(10)

print('MAP_SCRIPT')

heroes1 = GetPlayerHeroes (PLAYER_1)
heroes2 = GetPlayerHeroes (PLAYER_2)

-- Корневые триггеры
Trigger (NEW_DAY_TRIGGER, 'newday');

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

function shuffle(t)

end

function GetRandFrom(...)
  if arg.n == 0 then return nil end
  if arg.n == 1 then return arg[1] end
  local answer = 0
  local rnd_mode = random(1) == 1 and 'combat' or 'adv'
  answer = random(arg.n) + 1 * (rnd_mode == 'adv' and 1 or 0)
  for i = 1, arg.n do
    if answer == i then
      answer = arg[i]
      return answer
    end
  end
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

array_arts={}
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



----------------- BATTLES ---------------------------------------

array_battles={}
array_battles[0] = {
    { ["text"] = GetMapDataPath().."Battle/Battle1.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle2.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle3.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle4.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle5.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle6.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle7.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle8.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle9.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle10.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle11.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle12.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle13.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle14.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle15.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle16.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle17.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle18.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle19.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle20.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle21.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle22.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle23.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle24.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle25.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle26.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle27.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle28.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle29.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle30.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle31.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle32.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle33.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle34.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle35.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle36.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle37.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle38.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle39.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle40.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle41.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle42.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle43.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle44.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle45.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle46.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle47.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle48.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle49.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle50.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle51.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle52.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle53.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle54.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle55.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle56.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle57.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle58.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle59.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle60.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle61.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle62.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle63.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle64.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle65.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle66.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle67.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle68.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle69.txt",   ["blocked"] = 0, ["kv"] = 100},
};

BonusForSiege = 0;
arrayBonusForSiege = {};
--                        HAV  INF  NEC  ELF  MAG  LIG  RUN  ORC
arrayBonusForSiege[0] = {  20,  20,  25,  20,  20,  25,  20,  15}; -- HAVEN
arrayBonusForSiege[1] = {  15,  20,  20,  20,  20,  25,  20,  10}; -- INFERNO
arrayBonusForSiege[2] = {  10,  10,  15,  10,  20,  30,  10,   5}; -- NECROPOLIS
arrayBonusForSiege[3] = {  20,  20,  25,  15,  20,  25,  15,  15}; -- ELF
arrayBonusForSiege[4] = {  10,  15,  10,  15,  20,  15,   5,   0}; -- ACADEMY
arrayBonusForSiege[5] = {   0,   0,   0,   0,  10,  10,   5,   0}; -- WARLOCK
arrayBonusForSiege[6] = {  15,  20,  30,  15,  20,  25,  20,  20}; -- RUNEMAGE
arrayBonusForSiege[7] = {  20,  25,  30,  20,  25,  25,  20,  20}; -- STRONGHOLD
h1r = 3
h2r = 3

array_options={}
array_options[0] = {
    { ["text"] =  GetMapDataPath().."Battle/Option0.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  {GetMapDataPath().."Battle/Option1.txt"; eq = arrayBonusForSiege[h1r - 1][h2r]},    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  {GetMapDataPath().."Battle/Option2.txt"; eq = arrayBonusForSiege[h2r - 1][h1r]},    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option3.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option4.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option5.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option6.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option7.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option8.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option9.txt",    ["blocked"] = 1, ["kv"] = 100},
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


array_elf_enemy={}
array_elf_enemy[0] = {};

array_elf_enemy[1] = {
   { ["kol"] = 44, ["id"] =  1, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 24, ["id"] =  3, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 20, ["id"] =  5, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] =  7, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] =  9, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 11, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 13, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[2] = {
   { ["kol"] = 32, ["id"] = 15, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 30, ["id"] = 17, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 16, ["id"] = 19, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 21, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 23, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] =136, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 27, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[3] = {
   { ["kol"] = 40, ["id"] = 29, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 30, ["id"] = 31, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 18, ["id"] = 34, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 35, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 37, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 39, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 41, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[4] = {
   { ["kol"] = 30, ["id"] = 43, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 18, ["id"] = 45, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 14, ["id"] = 47, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  8, ["id"] = 49, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 51, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 53, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 55, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[5] = {
   { ["kol"] = 40, ["id"] = 57, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 28, ["id"] = 59, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 18, ["id"] = 61, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 63, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 65, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 67, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 69, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[6] = {
   { ["kol"] = 14, ["id"] = 92, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 73, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 12, ["id"] = 75, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  8, ["id"] = 77, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 79, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 81, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 83, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[7] = {
   { ["kol"] = 36, ["id"] = 71, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 28, ["id"] = 94, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 14, ["id"] = 96, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 12, ["id"] = 98, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] =100, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] =102, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] =105, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[8] = {
   { ["kol"] = 50, ["id"] =117, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 28, ["id"] =119, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 22, ["id"] =121, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] =123, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] =125, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] =127, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] =129, ["blocked1"] = 0, ["blocked2"] = 0},
};


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

lvl1 = 1;
lvl2 = 1;

LevelUp = {}
LevelUp = { 8500, 9000, 9500, 10000, 10500, 11000}

SkillCost = 12000;
SkillCostStart = 14000;
StatRegenCost = 5000;
TavernCost = 5000;

SpellResetCost = 8500;
SpellResetCostOrc = 7000;
RunesResetCost = 7000;

StartExperience = 54000;
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

function no1()
  DisableBagPlayer1 = 0;
  DisableBag = 0;
end;

function no2()
  DisableBagPlayer2 = 0;
  DisableBag = 0;
end;

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

HeroTavern1 = 0;
HeroTavern2 = 0;

PerkSum1 = 1;
PerkSum2 = 1;

Ellaina1 = 0;
Ellaina2 = 0;

StLvlUp1 = 0;
StLvlUp2 = 0;

SetObjectEnabled ('arena', nil);
SetObjectEnabled ('gorgul', nil);
SetObjectEnabled ('sklep', nil);
SetObjectEnabled ('higina', nil);
SetObjectEnabled ('heops', nil);
SetObjectEnabled ('gertva', nil);
SetObjectEnabled ('utopa', nil);
SetObjectEnabled ('academy', nil);

Trigger (OBJECT_TOUCH_TRIGGER, 'arena',   'levelupstart1');
Trigger (OBJECT_TOUCH_TRIGGER, 'gorgul',  'levelupstart1');
Trigger (OBJECT_TOUCH_TRIGGER, 'sklep',   'levelupstart1');
Trigger (OBJECT_TOUCH_TRIGGER, 'higina',  'levelupstart1');
Trigger (OBJECT_TOUCH_TRIGGER, 'heops',   'levelupstart1');
Trigger (OBJECT_TOUCH_TRIGGER, 'gertva',  'levelupstart1');
Trigger (OBJECT_TOUCH_TRIGGER, 'utopa',   'levelupstart1');
Trigger (OBJECT_TOUCH_TRIGGER, 'academy', 'levelupstart1');

SetObjectEnabled ('tent1', nil);
SetObjectEnabled ('tent2', nil);
OverrideObjectTooltipNameAndDescription ('tent1', GetMapDataPath().."tentNAME.txt", GetMapDataPath().."tentDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('tent2', GetMapDataPath().."tentNAME.txt", GetMapDataPath().."tentDSCRP.txt");

DisguiseEnable1 = 0;
DisguiseEnable2 = 0;
DisguiseHero1 = 0;

function levelupstart1 (hero)
--  Load(GetMapDataPath().."AutoSave");
  hero1 = hero;
  if DisableBagPlayer1 == 0 and GetDate (DAY) == 3 and (DisguiseEnable1 == 0 or (DisguiseEnable1 == 1 and DisguiseHero1 == hero1)) then
    DisableBagPlayer1 = 1;
    ArrayStatHero(hero1);
    if hero1race == 1 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15human1.txt", 'levelup11', 'no1'); end;
    if hero1race == 2 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15ad1.txt",    'levelup11', 'no1'); end;
    if hero1race == 3 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15necro1.txt", 'levelup11', 'no1'); end;
    if hero1race == 4 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15elf1.txt",   'levelup11', 'no1'); end;
    if hero1race == 5 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15mage1.txt",  'levelup11', 'no1'); end;
    if hero1race == 6 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15liga1.txt",  'levelup11', 'no1'); end;
    if hero1race == 7 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15gnom1.txt",  'levelup11', 'no1'); end;
    if hero1race == 8 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."UR15orc1.txt",   'levelup11', 'no1'); end;
  end;
  if GetHeroStat (hero1, STAT_EXPERIENCE) > array_level[HalfLevel] then
    levelup11();
  end;
end;

function levelup11()
  StLvlUp1 = 1;
  levelup12();
end;

function levelup12()
  if GetHeroStat (hero1, STAT_EXPERIENCE) >= array_level[HalfLevel] then
    ArrayStatHero(hero1);
    if Name(hero1) == "Elleshar" then Discount1 = EllesharDiscount; else Discount1 = 0; end;
    ChangeHeroStat (hero1, STAT_EXPERIENCE, array_level[GetHeroLevel(hero1) + StartLevel - HalfLevel] - GetHeroStat(hero1, STAT_EXPERIENCE));
    --EllesharLevelBonus = 0;
    --if HasHeroSkill(hero1, 29) then EstatesEnable1 = 1; end;
    Trigger (OBJECT_TOUCH_TRIGGER, 'arena',   'levelup13');
    Trigger (OBJECT_TOUCH_TRIGGER, 'gorgul',  'levelup13');
    Trigger (OBJECT_TOUCH_TRIGGER, 'sklep',   'levelup13');
    Trigger (OBJECT_TOUCH_TRIGGER, 'higina',  'levelup13');
    Trigger (OBJECT_TOUCH_TRIGGER, 'heops',   'levelup13');
    Trigger (OBJECT_TOUCH_TRIGGER, 'gertva',  'levelup13');
    Trigger (OBJECT_TOUCH_TRIGGER, 'utopa',   'levelup13');
    Trigger (OBJECT_TOUCH_TRIGGER, 'academy', 'levelup13');

    SetObjectEnabled ('mentor1', true);
    Trigger( OBJECT_TOUCH_TRIGGER, 'mentor1', 'mentor1' );
    PerkSum1 = PerkSum1 + StartLevel - HalfLevel;
  else
    if HalfLeveling1 == 0 then
      if GenerateLearningEnable1 == 0 then GenerateStatLearning1(hero1); end;
      Learning1(hero1);
      ArrayStatHero(hero1);
      if hero1 == HeroDop1 then HeroDop1 = HeroMax1; HeroTavern1 = 1; end;
      if hero1 == HeroMin1 then HeroMin1 = HeroMax1; end;
      HeroMax1 = hero1;
      if Name(hero1) == "Nathaniel" and Ellaina1 == 0 then Ellaina1 = 1; startThread(SpecEllaina1); end;
      if Name(hero1) == "Una" then Trigger(HERO_LEVELUP_TRIGGER, HeroMax1, 'SpecInga1'); end;
      if HasHeroSkill(hero1, 1) and LogisticsEnable1 == 0 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + LogisticsSum * GetHeroSkillMastery(hero1, 1))); end;
      --if HasHeroSkill(hero1, 29) then EstatesEnable1 = 1; end;
      if HasHeroSkill(hero1, 33) then ControlHeroCustomAbility(hero1, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
      ChangeHeroStat (hero1, STAT_EXPERIENCE, array_level[HalfLevel - 1 + GetHeroLevel(hero1)] - GetHeroStat(hero1, STAT_EXPERIENCE) + 500);
      SetObjectEnabled ('mentor11', nil);
      SetObjectEnabled ('mentor12', nil);
      SetObjectEnabled ('mentor13', nil);
      SetObjectEnabled ('mentor14', nil);
      SetObjectEnabled ('mentor15', nil);
      SetObjectEnabled ('mentor16', nil);
      SetObjectEnabled ('mentor17', nil);
      SetObjectEnabled ('mentor18', nil);
      Scouting1DopInfo();
      if hero1 == "Nikolas" or hero1 == "Nikolas2" then SetObjectOwner('Dwel1', PLAYER_1); startThread(HeraldFunction1); MoveCameraForPlayers( 1, 89, 82, 0, 40, 0, 0, 0, 0, 1); OpenCircleFog( 89, 82, 0, 12, 1 ); end;
--      if HasHeroSkill(hero1, 29) then ControlHeroCustomAbility(hero1, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
      PerkSum1 = PerkSumF(HeroMax1) + HalfLevel - 1;
    end;
    HalfLeveling1 = 1;
  end;
end;


function levelup13()
  --if HasHeroSkill(HeroMax1, 29) then EstatesEnable1 = 1; end;
  --if EstatesEnable1 == 1 then DiscountLevel1 = EstatesDiscountLevel; else DiscountLevel1 = 0; end;
  if lvl1 <= length(LevelUp) then
    if GetPlayerResource(1, 6) >= (LevelUp[lvl1] - Discount1) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."LevelUP.txt"; eq = LevelUp[lvl1] - Discount1}, 'levelup13yes', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."NoLevelUP.txt"; eq = LevelUp[lvl1] - Discount1} );
    end;
  else
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."URMAX.txt" );
	end;
end;

function levelup13yes()
  ArrayStatHero(hero1);
  SetPlayerResource(PLAYER_1, 6, GetPlayerResource(1, 6) - LevelUp[lvl1] + Discount1);
--  if EstatesEnable1 == 1 and EstatesDiscountUse1 == 0 and GetHeroLevel(hero1) > (StartLevel - 1) then
--    EstatesDiscountUse1 = 1;
--    SetPlayerResource(PLAYER_1, 6, GetPlayerResource(1, 6) + DiscountLevel1 * (GetHeroLevel(hero1) - StartLevel) + RemSkSum1 * EstatesDiscountMentor);
--    ShowFlyingSign({GetMapDataPath().."EstatesPostfactum.txt"; eq = DiscountLevel1 * (GetHeroLevel(hero1) - StartLevel) + RemSkSum1 * EstatesDiscountMentor}, hero1, 1, 5.0);
--  end;
--  if EstatesEnable1 == 1 then EstatesDiscountUse1 = 1; end;
	LevelUpHero (hero1);
	lvl1 = lvl1 + 1;
	PerkSum1 = PerkSum1 + 1;
end;


SetObjectEnabled ('hram', nil);
SetObjectEnabled ('rune', nil);
SetObjectEnabled ('mogila', nil);
SetObjectEnabled ('derevo', nil);
SetObjectEnabled ('treasure', nil);
SetObjectEnabled ('magiya', nil);
SetObjectEnabled ('obelisk', nil);
SetObjectEnabled ('gizn', nil);

Trigger (OBJECT_TOUCH_TRIGGER, 'hram',     'levelupstart2');
Trigger (OBJECT_TOUCH_TRIGGER, 'rune',     'levelupstart2');
Trigger (OBJECT_TOUCH_TRIGGER, 'mogila',   'levelupstart2');
Trigger (OBJECT_TOUCH_TRIGGER, 'derevo',   'levelupstart2');
Trigger (OBJECT_TOUCH_TRIGGER, 'treasure', 'levelupstart2');
Trigger (OBJECT_TOUCH_TRIGGER, 'magiya',   'levelupstart2');
Trigger (OBJECT_TOUCH_TRIGGER, 'obelisk',  'levelupstart2');
Trigger (OBJECT_TOUCH_TRIGGER, 'gizn',     'levelupstart2');

function levelupstart2 (hero)
  hero2 = hero;
  if DisableBagPlayer2 == 0 and GetDate (DAY) == 3  and (DisguiseEnable2 == 0 or (DisguiseEnable2 == 1 and DisguiseHero2 == hero2)) then
    DisableBagPlayer2 = 1;
    ArrayStatHero(hero2);
    if hero2race == 1 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15human2.txt", 'levelup21', 'no2'); end;
    if hero2race == 2 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15ad2.txt",    'levelup21', 'no2'); end;
    if hero2race == 3 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15necro2.txt", 'levelup21', 'no2'); end;
    if hero2race == 4 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15elf2.txt",   'levelup21', 'no2'); end;
    if hero2race == 5 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15mage2.txt",  'levelup21', 'no2'); end;
    if hero2race == 6 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15liga2.txt",  'levelup21', 'no2'); end;
    if hero2race == 7 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15gnom2.txt",  'levelup21', 'no2'); end;
    if hero2race == 8 then QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."UR15orc2.txt",   'levelup21', 'no2'); end;
  end;
  if GetHeroStat (hero2, STAT_EXPERIENCE) > 12000 then
    levelup21();
  end;
end;

function levelup21()
  StLvlUp2 = 1;
  levelup22();
end;

function levelup22()
  if GetHeroStat (hero2, STAT_EXPERIENCE) >= array_level[HalfLevel] then
    ArrayStatHero(hero2);
    if Name(hero2) == "Elleshar" then Discount2 = EllesharDiscount; else Discount2 = 0; end;
    --if Name(hero2) == "Elleshar" then EllesharLevelBonus = EllesharLevel; else EllesharLevelBonus = 0; end;
    ChangeHeroStat (hero2, STAT_EXPERIENCE, array_level[GetHeroLevel(hero2) + StartLevel - HalfLevel] - GetHeroStat(hero2, STAT_EXPERIENCE));
    --EllesharLevelBonus = 0;
    --if HasHeroSkill(hero2, 29) then EstatesEnable2 = 1; end;
    Trigger (OBJECT_TOUCH_TRIGGER, 'hram',     'levelup23');
    Trigger (OBJECT_TOUCH_TRIGGER, 'rune',     'levelup23');
    Trigger (OBJECT_TOUCH_TRIGGER, 'mogila',   'levelup23');
    Trigger (OBJECT_TOUCH_TRIGGER, 'derevo',   'levelup23');
    Trigger (OBJECT_TOUCH_TRIGGER, 'treasure', 'levelup23');
    Trigger (OBJECT_TOUCH_TRIGGER, 'magiya',   'levelup23');
    Trigger (OBJECT_TOUCH_TRIGGER, 'obelisk',  'levelup23');
    Trigger (OBJECT_TOUCH_TRIGGER, 'gizn',     'levelup23');

    SetObjectEnabled ('mentor2', true);
    Trigger( OBJECT_TOUCH_TRIGGER, 'mentor2', 'mentor2' );
    PerkSum2 = PerkSum2 + StartLevel - HalfLevel;
  else
    if HalfLeveling2 == 0 then
      if GenerateLearningEnable2 == 0 then GenerateStatLearning2(hero2); end;
      Learning2(hero2);
      ArrayStatHero(hero2);
      if hero2 == HeroDop2 then HeroDop2 = HeroMax2; HeroTavern2 = 1; end;
      if hero2 == HeroMin2 then HeroMin2 = HeroMax2; end;
      HeroMax2 = hero2;
      if Name(hero2) == "Nathaniel" and Ellaina2 == 0 then Ellaina2 = 1; startThread(SpecEllaina2); end;
      if Name(hero2) == "Una" then Trigger(HERO_LEVELUP_TRIGGER, HeroMax2, 'SpecInga2'); end;
      if HasHeroSkill(hero2, 1) and LogisticsEnable2 == 0 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + LogisticsSum * GetHeroSkillMastery(hero2, 1))); end;
      --if HasHeroSkill(hero2, 29) then EstatesEnable2 = 1; end;
      if HasHeroSkill(hero2, 33) then ControlHeroCustomAbility(hero2, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
      ChangeHeroStat (hero2, STAT_EXPERIENCE, array_level[HalfLevel - 1 + GetHeroLevel(hero2)] - GetHeroStat(hero2, STAT_EXPERIENCE) + 500);
      SetObjectEnabled ('mentor21', nil);
      SetObjectEnabled ('mentor22', nil);
      SetObjectEnabled ('mentor23', nil);
      SetObjectEnabled ('mentor24', nil);
      SetObjectEnabled ('mentor25', nil);
      SetObjectEnabled ('mentor26', nil);
      SetObjectEnabled ('mentor27', nil);
      SetObjectEnabled ('mentor28', nil);
      Scouting2DopInfo();
      if hero2 == "Nikolas" or hero2 == "Nikolas2" then SetObjectOwner('Dwel2', PLAYER_2); startThread(HeraldFunction2); MoveCameraForPlayers( 2, 81, 7, 0, 40, 0, 3.14, 0, 0, 1);  OpenCircleFog( 81, 7, 0, 12, 2 ); end;
--      if HasHeroSkill(hero2, 29) then ControlHeroCustomAbility(hero2, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
      PerkSum2 = PerkSumF(HeroMax2) + HalfLevel - 1;
    end;
    HalfLeveling2 = 1;
  end;
end;

function levelup23()
  --if HasHeroSkill(HeroMax2, 29) then EstatesEnable2 = 1; end;
  --if EstatesEnable2 == 1 then DiscountLevel2 = EstatesDiscountLevel; else DiscountLevel2 = 0; end;
  if lvl2 <= length(LevelUp) then
    if GetPlayerResource(2, 6) >= (LevelUp[lvl2] - Discount2) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."LevelUP.txt"; eq = LevelUp[lvl2] - Discount2}, 'levelup23yes', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."NoLevelUP.txt"; eq = LevelUp[lvl2] - Discount2} );
    end;
  else
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."URMAX.txt" );
	end;
end;

function levelup23yes()
  ArrayStatHero(hero2);
  SetPlayerResource(PLAYER_2, 6, GetPlayerResource(2, 6) - LevelUp[lvl2] + Discount2);
--  if EstatesEnable2 == 1 and EstatesDiscountUse2 == 0 and GetHeroLevel(hero2) > (StartLevel - 1) then
--    EstatesDiscountUse2 = 1;
--    SetPlayerResource(PLAYER_2, 6, GetPlayerResource(2, 6) + DiscountLevel2 * (GetHeroLevel(hero2) - StartLevel) + RemSkSum2 * EstatesDiscountMentor);
--    ShowFlyingSign({GetMapDataPath().."EstatesPostfactum.txt"; eq = DiscountLevel2 * (GetHeroLevel(hero2) - StartLevel) + RemSkSum2 * EstatesDiscountMentor}, hero2, 2, 5.0);
--  end;
--  if EstatesEnable2 == 1 then EstatesDiscountUse2 = 1; end;
	LevelUpHero (hero2);
	lvl2 = lvl2 + 1;
	PerkSum2 = PerkSum2 + 1;
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




function SetArmyTown (race, pl, k1, k2, k3, k4, k5, k6, k7)
--HUMAN UNITS and RESOURSES
if race == 1 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 1, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 3, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 5, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 7, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 9, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 11, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 13, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 1, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 3, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 5, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 7, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 9, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 11, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 13, k7);
end;
end;

--ELF UNITS and RESOURSES
if race == 4 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 43, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 45, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 47, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 49, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 51, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 53, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 55, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 43, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 45, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 47, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 49, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 51, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 53, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 55, k7);
end;
end;

--AD UNITS and RESOURSES
if race == 2 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 15, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 17, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 19, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 21, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 23, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 25, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 27, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 15, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 17, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 19, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 21, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 23, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 25, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 27, k7);
end;
end;

--MAGE UNITS and RESOURSES
if race == 5 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 57, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 59, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 61, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 63, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 65, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 67, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 69, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 57, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 59, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 61, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 63, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 65, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 67, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 69, k7);
end;
end;

--LIGA UNITS and RESOURSES
if race == 6 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 92, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 73, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 75, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 77, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 79, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 81, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 83, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 92, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 73, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 75, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 77, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 79, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 81, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 83, k7);
end;
end;

--GNOM UNITS and RESOURSES
if race == 7 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 71, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 94, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 96, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 98, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 100, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 102, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 105, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 71, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 94, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 96, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 98, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 100, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 102, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 105, k7);
end;
end;

--ORC UNITS and RESOURSES
if race == 8 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 117, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 119, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 121, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 123, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 125, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 127, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 129, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 117, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 119, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 121, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 123, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 125, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 127, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 129, k7);
end;
end;

--NECRO UNITS and RESOURSES
if race == 3 then
if pl == 1 then
SetObjectDwellingCreatures('RANDOMTOWN1', 29, k1);
SetObjectDwellingCreatures('RANDOMTOWN1', 31, k2);
SetObjectDwellingCreatures('RANDOMTOWN1', 34, k3);
SetObjectDwellingCreatures('RANDOMTOWN1', 35, k4);
SetObjectDwellingCreatures('RANDOMTOWN1', 37, k5);
SetObjectDwellingCreatures('RANDOMTOWN1', 39, k6);
SetObjectDwellingCreatures('RANDOMTOWN1', 41, k7);
end;
if pl == 2 then
SetObjectDwellingCreatures('RANDOMTOWN2', 29, k1);
SetObjectDwellingCreatures('RANDOMTOWN2', 31, k2);
SetObjectDwellingCreatures('RANDOMTOWN2', 34, k3);
SetObjectDwellingCreatures('RANDOMTOWN2', 35, k4);
SetObjectDwellingCreatures('RANDOMTOWN2', 37, k5);
SetObjectDwellingCreatures('RANDOMTOWN2', 39, k6);
SetObjectDwellingCreatures('RANDOMTOWN2', 41, k7);
end;
end;
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

function hodSleep(hero1, hero2)
  hodEn = 1;
  while hodEn == 1 do
    sleep(30);
    hodi1(hero1);
    hodi1(hero2);
  end;
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

MaxLevelForAntiscaner = 12;
levelH1 = 2;

function AntiscanerHM1()
if levelH1 < MaxLevelForAntiscaner then
  j = 1;
  for i = 1, 26 do
    array_skills_H1[i] = GetHeroSkillMastery(HeroMax1, array_skills[i]);
  end;
  for i = 1, 189 do
    if HasHeroSkill( HeroMax1, array_perks[i]) then
      array_perks_H1[j] = array_perks[i];
      j = j + 1;
      kol_perks_H1 = j;
    end;
  end;
  expH1 = GetHeroStat(HeroMax1, STAT_EXPERIENCE);
  attH1 = GetHeroStat(HeroMax1, STAT_ATTACK);
  defH1 = GetHeroStat(HeroMax1, STAT_DEFENCE);
  spH1 = GetHeroStat(HeroMax1, STAT_SPELL_POWER);
  knH1 = GetHeroStat(HeroMax1, STAT_KNOWLEDGE);
  TakeAwayHeroExp(HeroMax1, expH1 - 1);

  WarpHeroExp(HeroMax1, expH1);
  for i = 1, 26 do
    for j = 1, array_skills_H1[i] do
      if array_skills_H1[i] >= j then
        if GetHeroSkillMastery(HeroMax1, array_skills[i]) < array_skills_H1[i] then
          GiveHeroSkill(HeroMax1, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_H1 do
    GiveHeroSkill(HeroMax1, array_perks_H1[i]);
  end;
  ChangeHeroStat(HeroMax1, STAT_ATTACK, attH1 - GetHeroStat(HeroMax1, STAT_ATTACK));
  ChangeHeroStat(HeroMax1, STAT_DEFENCE, defH1 - GetHeroStat(HeroMax1, STAT_DEFENCE));
  ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, spH1 - GetHeroStat(HeroMax1, STAT_SPELL_POWER));
  ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, knH1 - GetHeroStat(HeroMax1, STAT_KNOWLEDGE));

  levelH1 = levelH1 + 1;
  LevelUpHero (HeroMax1);
end;
if levelH1 == MaxLevelForAntiscaner then
  ChangeHeroStat (HeroMax1, STAT_EXPERIENCE, 28000);
  if HeroMax1 == "Elleshar" then ChangeHeroStat (HeroMax1, STAT_EXPERIENCE, 9000); end;
  levelH1 = levelH1 + 1;
end;
end;


podvariant = 1;

bonus1 = 'art';
bonus2 = 'art';

if GetPlayerResource(PLAYER_1, GOLD)~=10000
   and GetPlayerResource(PLAYER_1, GOLD)~=20000
   and GetPlayerResource(PLAYER_1, GOLD)~=30000
   and GetPlayerResource(PLAYER_1, GOLD)~=50000
then podvariant = 1; schetchikUnit=0; bonus1 = 'gold'; end;

if mod(GetPlayerResource(PLAYER_1, 0) + GetPlayerResource(PLAYER_1, 1) + GetPlayerResource(PLAYER_1, 2)
   + GetPlayerResource(PLAYER_1, 3) + GetPlayerResource(PLAYER_1, 4) + GetPlayerResource(PLAYER_1, 5), 40) ~= 0
then podvariant = 1; schetchikUnit=0; bonus1 = 'spell'; end;

if GetPlayerResource(PLAYER_2, GOLD)~=10000
   and GetPlayerResource(PLAYER_2, GOLD)~=20000
   and GetPlayerResource(PLAYER_2, GOLD)~=30000
   and GetPlayerResource(PLAYER_2, GOLD)~=50000
then bonus2 = 'gold'; end;

if mod(GetPlayerResource(PLAYER_2, 0) + GetPlayerResource(PLAYER_2, 1) + GetPlayerResource(PLAYER_2, 2)
   + GetPlayerResource(PLAYER_2, 3) + GetPlayerResource(PLAYER_2, 4) + GetPlayerResource(PLAYER_2, 5), 40) ~= 0
then bonus2 = 'spell'; end;

StartBonus = {}
StartBonus[1] = bonus1;
StartBonus[2] = bonus2;

function BonusStartGold(player)
  StartGold = 4000 + random(11)*100;
  SetPlayerResource(player, GOLD, GetPlayerResource(player, GOLD) + StartGold);
  if player == 1 then
--    ShowFlyingSign({GetMapDataPath().."StartGold.txt"; eq = StartGold}, heroes1[0], 1, 5.0);
    ShowFlyingSign({GetMapDataPath().."StartGold.txt"; eq = StartGold}, HeroMax1, 1, 5.0);
  end;
  if player == 2 then
--    ShowFlyingSign({GetMapDataPath().."StartGold.txt"; eq = StartGold}, heroes2[0], 2, 5.0);
    ShowFlyingSign({GetMapDataPath().."StartGold.txt"; eq = StartGold}, HeroMax2, 2, 5.0);
  end;
end;

rndSpell1 = 49; rndSpellM1 = 0; rndSpellSp1 = 1;
rndSpell2 = 49; rndSpellM11 = 0; rndSpellSp11 = 1;
rndSpell11 = 49; rndSpellM2 = 0; rndSpellSp2 = 1;
rndSpell22 = 49; rndSpellM22 = 0; rndSpellSp22 = 1;

function StartRandomSpell (player)
  if player == 1 then
    TeachHeroSpell(HeroMax1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
    TeachHeroSpell(HeroMin1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
    TeachHeroSpell(HeroDop1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
    if hero1race ~= 8 then
      TeachHeroSpell(HeroDop1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
      TeachHeroSpell(HeroMax1, array_spells[BonusSpells[0].m2][BonusSpells[0].sp2].id );
      TeachHeroSpell(HeroMin1, array_spells[BonusSpells[0].m2][BonusSpells[0].sp2].id );
      TeachHeroSpell(HeroDop1, array_spells[BonusSpells[0].m2][BonusSpells[0].sp2].id );
    end;
  end;
  if player == 2 then
    TeachHeroSpell(HeroMax2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
    TeachHeroSpell(HeroMin2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
    TeachHeroSpell(HeroDop2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
    if hero2race ~= 8 then
      TeachHeroSpell(HeroDop2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
      TeachHeroSpell(HeroMax2, array_spells[BonusSpells[1].m2][BonusSpells[1].sp2].id );
      TeachHeroSpell(HeroMin2, array_spells[BonusSpells[1].m2][BonusSpells[1].sp2].id );
      TeachHeroSpell(HeroDop2, array_spells[BonusSpells[1].m2][BonusSpells[1].sp2].id );
    end;
  end;
end;

function transferSpell (player)
  if player == 1 then
    if hero1race ~= 8 then
      TeachHeroSpell(HeroMax1, rndSpell1);
      TeachHeroSpell(HeroMax1, rndSpell11);
      TeachHeroSpell(HeroMin1, rndSpell1);
      TeachHeroSpell(HeroMin1, rndSpell11);
      Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, 'SpellForHeroFromTavern1');
    else
      SetPlayerResource (1, GOLD, GetPlayerResource(1, GOLD) + 4500);
      ShowFlyingSign ({GetMapDataPath().."StartGold.txt"; eq = 4500}, heroes1[0], 1, 3.0);
      ShowFlyingSign ({GetMapDataPath().."StartGold.txt"; eq = 4500}, HeroMax1, 1, 3.0);
    end;
  end;
  if player == 2 then
    if hero2race ~= 8 then
      TeachHeroSpell(HeroMax2, rndSpell2);
      TeachHeroSpell(HeroMax2, rndSpell22);
      TeachHeroSpell(HeroMin2, rndSpell2);
      TeachHeroSpell(HeroMin2, rndSpell22);
      Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_2, 'SpellForHeroFromTavern2');
    else
      SetPlayerResource (2, GOLD, GetPlayerResource(2, GOLD) + 4500);
      ShowFlyingSign ({GetMapDataPath().."StartGold.txt"; eq = 4500}, heroes2[0], 2, 3.0);
      ShowFlyingSign ({GetMapDataPath().."StartGold.txt"; eq = 4500}, HeroMax2, 2, 3.0);
    end;
  end;
end;

function SpellForHeroFromTavern1(hero)
   if getrace (hero) ~= 8 then
    TeachHeroSpell (hero, rndSpell1);
    TeachHeroSpell (hero, rndSpell11);
  end;
end;

function SpellForHeroFromTavern2(hero)
  if getrace (hero) ~= 8 then
    TeachHeroSpell (hero, rndSpell2);
    TeachHeroSpell (hero, rndSpell22);
  end;
end;

function RaskladkaPolya()
  SetObjectPosition(heroes1[0], 35, 85);
  SetObjectPosition(heroes2[0], 42, 24);
  if battle[NumberBattle] == 5 then stop(heroes1[0]); end;
  if battle[NumberBattle] == 5 then stop(heroes2[0]); end;
  SetObjectPosition('spell_nabor1', 35, 86, 0);
  SetObjectPosition('spell_nabor2', 42, 23, 0);
  SetObjectEnabled ('spell_nabor1', nil);
  SetObjectEnabled ('spell_nabor2', nil);
  if option[NumberBattle] ~= 5 and option[NumberBattle] ~= 6 then
    SetRegionBlocked ('block1', true);
    SetRegionBlocked ('block2', true);
    SetRegionBlocked ('block3', true);
    SetRegionBlocked ('block4', true);
  end;
end;

Para = {
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["race1"] =  0, ["race2"] =  0 },
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["race1"] =  0, ["race2"] =  0 },
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["race1"] =  0, ["race2"] =  0 },
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["race1"] =  0, ["race2"] =  0 }
}

if GAME_MODE.SIMPLE_CHOOSE then
  SetObjectPosition('blue1', 44, 24);
  SetObjectPosition('blue2', 45, 24);
  SetObjectPosition('blue3', 46, 24);
  SetObjectPosition('blue4', 44, 22);
  SetObjectPosition('blue5', 45, 22);
  SetObjectPosition('blue6', 46, 22);
  SetObjectPosition('blue7', 44, 20);
  SetObjectPosition('blue8', 45, 20);
  SetObjectPosition('blue9', 46, 20);
  SetObjectPosition('red12', 37, 89);
  SetObjectPosition('red13', 38, 89);
  SetObjectPosition('red14', 39, 89);
  SetObjectPosition('red15', 37, 87);
  SetObjectPosition('red16', 38, 87);
  SetObjectPosition('red17', 39, 87);
  SetObjectPosition('red18', 37, 85);
  SetObjectPosition('red19', 38, 85);
  SetObjectPosition('red20', 39, 85);
--  SetObjectPosition('red10', 35, 85, UNDERGROUND);
  SetObjectEnabled('mumiya', nil);
  SetObjectPosition('mumiya', 35, 91);
  SetDisabledObjectMode('mumiya', 3);
  Trigger( OBJECT_TOUCH_TRIGGER, 'mumiya', 'mumiyaVopros' );
end;

if GAME_MODE.MATCHUPS then
  RemoveObject('blue1');
  RemoveObject('blue2');
  RemoveObject('blue3');
  RemoveObject('blue4');
  RemoveObject('blue5');
  RemoveObject('blue6');
  RemoveObject('blue7');
  RemoveObject('blue8');
  RemoveObject('blue9');
  RemoveObject('blue12');
  RemoveObject('blue13');
  RemoveObject('blue14');
  RemoveObject('blue15');
  RemoveObject('blue16');
  RemoveObject('blue17');
  RemoveObject('blue18');
  RemoveObject('blue19');
  RemoveObject('blue20');
  RemoveObject('red1');
  RemoveObject('red2');
  RemoveObject('red3');
  RemoveObject('red4');
  RemoveObject('red5');
  RemoveObject('red6');
  -- RemoveObject('red7');
  RemoveObject('red8');
  RemoveObject('red9');
  RemoveObject('red12');
  RemoveObject('red13');
  RemoveObject('red14');
  RemoveObject('red15');
  RemoveObject('red16');
  RemoveObject('red17');
  RemoveObject('red18');
  RemoveObject('red19');
  RemoveObject('red20');
--  SetObjectPosition('s11', 85, 38, 0);
--  SetObjectPosition('s12', 86, 38, 0);
--  SetObjectPosition('s13', 87, 38, 0);
--  SetObjectPosition('s14', 88, 38, 0);
--  SetObjectPosition('s15', 89, 38, 0);
--  SetObjectPosition('s16', 90, 38, 0);
--  SetObjectPosition('s17', 91, 38, 0);
--  SetObjectPosition('s18', 92, 38, 0);
--  SetObjectPosition('s19', 93, 38, 0);
--  SetObjectPosition('s21',  2, 60, 0);
--  SetObjectPosition('s22',  3, 60, 0);
--  SetObjectPosition('s23',  4, 60, 0);
--  SetObjectPosition('s24',  5, 60, 0);
--  SetObjectPosition('s25',  6, 60, 0);
--  SetObjectPosition('s26',  7, 60, 0);
--  SetObjectPosition('s27',  8, 60, 0);
--  SetObjectPosition('s28',  9, 60, 0);
--  SetObjectPosition('s29', 10, 60, 0);
  SetObjectEnabled('s11', nil);
  SetObjectEnabled('s12', nil);
  SetObjectEnabled('s13', nil);
  SetObjectEnabled('s14', nil);
  SetObjectEnabled('s15', nil);
  SetObjectEnabled('s16', nil);
  SetObjectEnabled('s17', nil);
  SetObjectEnabled('s18', nil);
  SetObjectEnabled('s19', nil);
  SetObjectEnabled('s21', nil);
  SetObjectEnabled('s22', nil);
  SetObjectEnabled('s23', nil);
  SetObjectEnabled('s24', nil);
  SetObjectEnabled('s25', nil);
  SetObjectEnabled('s26', nil);
  SetObjectEnabled('s27', nil);
  SetObjectEnabled('s28', nil);
  SetObjectEnabled('s29', nil);
  Trigger( OBJECT_TOUCH_TRIGGER, 's11', 'MinusS1Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's21', 'MinusS1Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's12', 'MinusS2Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's22', 'MinusS2Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's13', 'MinusS3Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's23', 'MinusS3Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's14', 'MinusS4Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's24', 'MinusS4Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's15', 'MinusS5Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's25', 'MinusS5Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's16', 'MinusS6Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's26', 'MinusS6Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's17', 'MinusS7Question' );
  Trigger( OBJECT_TOUCH_TRIGGER, 's27', 'MinusS7Question' );
end;

NumberBattle = 2;

battle = {};
battle = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
option = {};
option = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

function MinusS1Question(hero)
  HeroQ = hero;
  if GetObjectOwner(hero) == 1 then NumberMutchUp1 = 1; end;
  if GetObjectOwner(hero) == 2 then NumberMutchUp2 = 1; end;
  if DisableBagPlayer1 == 0 and GetObjectOwner(hero) == 1 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 1 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no1');
  end;
  if DisableBagPlayer2 == 0 and GetObjectOwner(hero) == 2 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 2 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no2');
  end;
end;

function MinusS2Question(hero)
  HeroQ = hero;
  if GetObjectOwner(hero) == 1 then NumberMutchUp1 = 2; end;
  if GetObjectOwner(hero) == 2 then NumberMutchUp2 = 2; end;
  if DisableBagPlayer1 == 0 and GetObjectOwner(hero) == 1 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 1 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no1');
  end;
  if DisableBagPlayer2 == 0 and GetObjectOwner(hero) == 2 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 2 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no2');
  end;
end;

function MinusS3Question(hero)
  HeroQ = hero;
  if GetObjectOwner(hero) == 1 then NumberMutchUp1 = 3; end;
  if GetObjectOwner(hero) == 2 then NumberMutchUp2 = 3; end;
  if DisableBagPlayer1 == 0 and GetObjectOwner(hero) == 1 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 1 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no1');
  end;
  if DisableBagPlayer2 == 0 and GetObjectOwner(hero) == 2 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 2 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no2');
  end;
end;

function MinusS4Question(hero)
  HeroQ = hero;
  if GetObjectOwner(hero) == 1 then NumberMutchUp1 = 4; end;
  if GetObjectOwner(hero) == 2 then NumberMutchUp2 = 4; end;
  if DisableBagPlayer1 == 0 and GetObjectOwner(hero) == 1 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 1 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no1');
  end;
  if DisableBagPlayer2 == 0 and GetObjectOwner(hero) == 2 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 2 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no2');
  end;
end;

function MinusS5Question(hero)
  HeroQ = hero;
  if GetObjectOwner(hero) == 1 then NumberMutchUp1 = 5; end;
  if GetObjectOwner(hero) == 2 then NumberMutchUp2 = 5; end;
  if DisableBagPlayer1 == 0 and GetObjectOwner(hero) == 1 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 1 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no1');
  end;
  if DisableBagPlayer2 == 0 and GetObjectOwner(hero) == 2 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 2 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no2');
  end;
end;

function MinusS6Question(hero)
  HeroQ = hero;
  if GetObjectOwner(hero) == 1 then NumberMutchUp1 = 6; end;
  if GetObjectOwner(hero) == 2 then NumberMutchUp2 = 6; end;
  if DisableBagPlayer1 == 0 and GetObjectOwner(hero) == 1 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 1 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no1');
  end;
  if DisableBagPlayer2 == 0 and GetObjectOwner(hero) == 2 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 2 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no2');
  end;
end;

function MinusS7Question(hero)
  HeroQ = hero;
  if GetObjectOwner(hero) == 1 then NumberMutchUp1 = 7; end;
  if GetObjectOwner(hero) == 2 then NumberMutchUp2 = 7; end;
  if DisableBagPlayer1 == 0 and GetObjectOwner(hero) == 1 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 1 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no1');
  end;
  if DisableBagPlayer2 == 0 and GetObjectOwner(hero) == 2 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter( 2 ), GetMapDataPath().."QuestionMatchup.txt", 'MatchUpChoise', 'no2');
  end;
end;

array_MathcUp = {};
array_MathcUp = {
--   { ["obj11"] = 'm101', ["obj12"] = 'm102', ["obj13"] = 's10', ["obj21"] = 'm201', ["obj22"] = 'm202', ["obj23"] = 's20', ["sum"] =  0 }, --НЕ ИСПОЛЬЗУЕТСЯ!!!!
   { ["obj11"] = 'm111', ["obj12"] = 'm112', ["obj13"] = 's11', ["obj21"] = 'm211', ["obj22"] = 'm212', ["obj23"] = 's21', ["calc1"] =  0, ["calc2"] =  0, ["sum"] =  0, ["colour11"] = "PosterRed_1", ["colour12"] = "PosterRed_7",  ["colour21"] = "PosterBlue_1", ["colour22"] = "PosterBlue_7"  },
   { ["obj11"] = 'm121', ["obj12"] = 'm122', ["obj13"] = 's12', ["obj21"] = 'm221', ["obj22"] = 'm222', ["obj23"] = 's22', ["calc1"] =  0, ["calc2"] =  0, ["sum"] =  0, ["colour11"] = "PosterRed_2", ["colour12"] = "PosterRed_8",  ["colour21"] = "PosterBlue_2", ["colour22"] = "PosterBlue_8"  },
   { ["obj11"] = 'm131', ["obj12"] = 'm132', ["obj13"] = 's13', ["obj21"] = 'm231', ["obj22"] = 'm232', ["obj23"] = 's23', ["calc1"] =  0, ["calc2"] =  0, ["sum"] =  0, ["colour11"] = "PosterRed_3", ["colour12"] = "PosterRed_9",  ["colour21"] = "PosterBlue_3", ["colour22"] = "PosterBlue_9"  },
   { ["obj11"] = 'm141', ["obj12"] = 'm142', ["obj13"] = 's14', ["obj21"] = 'm241', ["obj22"] = 'm242', ["obj23"] = 's24', ["calc1"] =  0, ["calc2"] =  0, ["sum"] =  0, ["colour11"] = "PosterRed_4", ["colour12"] = "PosterRed_10", ["colour21"] = "PosterBlue_4", ["colour22"] = "PosterBlue_10" },
   { ["obj11"] = 'm151', ["obj12"] = 'm152', ["obj13"] = 's15', ["obj21"] = 'm251', ["obj22"] = 'm252', ["obj23"] = 's25', ["calc1"] =  0, ["calc2"] =  0, ["sum"] =  0, ["colour11"] = "PosterRed_5", ["colour12"] = "PosterRed_11", ["colour21"] = "PosterBlue_5", ["colour22"] = "PosterBlue_11" },
   { ["obj11"] = 'm161', ["obj12"] = 'm162', ["obj13"] = 's16', ["obj21"] = 'm261', ["obj22"] = 'm262', ["obj23"] = 's26', ["calc1"] =  0, ["calc2"] =  0, ["sum"] =  0, ["colour11"] = "PosterRed_6", ["colour12"] = "PosterRed_12", ["colour21"] = "PosterBlue_6", ["colour22"] = "PosterBlue_12" }}

CalcChoisePlayer1 = 0;
CalcChoisePlayer2 = 0;

function MatchUpChoise(player)

  if player == PLAYER_1 then
    DisableBagPlayer1 = 0;
    CalcChoisePlayer1 = CalcChoisePlayer1 + 1;
    array_MathcUp[NumberMutchUp1].calc1 = CalcChoisePlayer1;
    ShowFlyingSign({GetMapDataPath().."ScoreRed.txt"; eq = CalcChoisePlayer1}, array_MathcUp[NumberMutchUp1].obj11, 1, 2.0);
    RemoveObject(array_MathcUp[NumberMutchUp1].obj11);
    RemoveObject(array_MathcUp[NumberMutchUp1].obj12);
    RemoveObject(array_MathcUp[NumberMutchUp1].obj13);
    RemoveObject(array_MathcUp[NumberMutchUp1].colour11);
    RemoveObject(array_MathcUp[NumberMutchUp1].colour21);
    array_MathcUp[NumberMutchUp1].sum = array_MathcUp[NumberMutchUp1].sum + CalcChoisePlayer1;
  end;

  if player == PLAYER_2 then
    DisableBagPlayer2 = 0;
    CalcChoisePlayer2 = CalcChoisePlayer2 + 1;
    array_MathcUp[NumberMutchUp2].calc2 = CalcChoisePlayer2;
    ShowFlyingSign({GetMapDataPath().."ScoreBlue.txt"; eq = CalcChoisePlayer2}, array_MathcUp[NumberMutchUp2].obj21, 2, 2.0);
    RemoveObject(array_MathcUp[NumberMutchUp2].obj21);
    RemoveObject(array_MathcUp[NumberMutchUp2].obj22);
    RemoveObject(array_MathcUp[NumberMutchUp2].obj23);
    RemoveObject(array_MathcUp[NumberMutchUp2].colour12);
    RemoveObject(array_MathcUp[NumberMutchUp2].colour22);
    array_MathcUp[NumberMutchUp2].sum = array_MathcUp[NumberMutchUp2].sum + CalcChoisePlayer2;
  end;

  if CalcChoisePlayer1 == 5 and player == PLAYER_1 then
    for i = 1, 6 do
      if IsObjectExists(array_MathcUp[i].obj11) == 1 then
        array_MathcUp[i].sum = array_MathcUp[i].sum + 6;
        array_MathcUp[i].calc1 = 6;
        ShowFlyingSign({GetMapDataPath().."ScoreRed.txt"; eq = 6}, array_MathcUp[i].obj11, 1, 2.0);
        RemoveObject(array_MathcUp[i].obj11);
        RemoveObject(array_MathcUp[i].obj12);
        RemoveObject(array_MathcUp[i].obj13);
        RemoveObject(array_MathcUp[i].colour11);
        RemoveObject(array_MathcUp[i].colour21);
      end;
    end;
    stop(heroes1[0]);
  end;

  if CalcChoisePlayer2 == 5 and player == PLAYER_2 then
    for i = 1, 6 do
      if IsObjectExists(array_MathcUp[i].obj21) == 1 then
        array_MathcUp[i].sum = array_MathcUp[i].sum + 6;
        array_MathcUp[i].calc2 = 6;
        ShowFlyingSign({GetMapDataPath().."ScoreBlue.txt"; eq = 6}, array_MathcUp[i].obj21, 2, 2.0);
        RemoveObject(array_MathcUp[i].obj21);
        RemoveObject(array_MathcUp[i].obj22);
        RemoveObject(array_MathcUp[i].obj23);
        RemoveObject(array_MathcUp[i].colour12);
        RemoveObject(array_MathcUp[i].colour22);
      end;
    end;
    stop(heroes2[0]);
  end;

  if CalcChoisePlayer1 == 5 and CalcChoisePlayer2 == 5 then
    for i = 1, 6 do
      for j = 1, 6 do
        if i ~= j then
          if array_MathcUp[i].sum < array_MathcUp[j].sum then
            array_MathcUp[i].sum = 0;
            j = 6;
          end;
        end;
      end;
    end;
    NumberBattle = random(6) + 1;
    while array_MathcUp[NumberBattle].sum == 0 do
      NumberBattle = random(6) + 1;
    end;
    SetOptionBattle();
    sleep(1);
    ShowFlyingSign({GetMapDataPath().."ScoreRedBlue.txt"; eq1 = array_MathcUp[NumberBattle].calc1, eq2 = array_MathcUp[NumberBattle].calc2, eq3 = (array_MathcUp[NumberBattle].calc1 + array_MathcUp[NumberBattle].calc2)}, 's17', 1, 6.0);
    ShowFlyingSign({GetMapDataPath().."ScoreRedBlue.txt"; eq1 = array_MathcUp[NumberBattle].calc1, eq2 = array_MathcUp[NumberBattle].calc2, eq3 = (array_MathcUp[NumberBattle].calc1 + array_MathcUp[NumberBattle].calc2)}, 'blue10', 2, 6.0);
  end;
end;

function MinusS2(hero)
  RemoveObject('s12');
  RemoveObject('s22');
  RemoveObject('m121');
  RemoveObject('m122');
  RemoveObject('m221');
  RemoveObject('m222');
  NumberBattle = NumberBattle - 2;
  if HeroQ == heroes1[0] then
    schetchikPl1 = schetchikPl1 + 1;
    hodi1(heroes2[0]);
    stop(HeroQ);
  end;
  if HeroQ == heroes2[0] then
    schetchikPl2 = schetchikPl2 + 1;
    hodi1(heroes1[0]);
    stop(HeroQ);
  end;
  if (schetchikPl1 + schetchikPl2) == 6 then
    SetOptionBattle();
  end;
end;

function MinusS3(hero)
  RemoveObject('s13');
  RemoveObject('s23');
  RemoveObject('m131');
  RemoveObject('m132');
  RemoveObject('m231');
  RemoveObject('m232');
  NumberBattle = NumberBattle - 3;
  if HeroQ == heroes1[0] then
    schetchikPl1 = schetchikPl1 + 1;
    hodi1(heroes2[0]);
    stop(HeroQ);
  end;
  if HeroQ == heroes2[0] then
    schetchikPl2 = schetchikPl2 + 1;
    hodi1(heroes1[0]);
    stop(HeroQ);
  end;
  if (schetchikPl1 + schetchikPl2) == 6 then
    SetOptionBattle();
  end;
end;

function MinusS4(hero)
  RemoveObject('s14');
  RemoveObject('s24');
  RemoveObject('m141');
  RemoveObject('m142');
  RemoveObject('m241');
  RemoveObject('m242');
  NumberBattle = NumberBattle - 4;
  if HeroQ == heroes1[0] then
    schetchikPl1 = schetchikPl1 + 1;
    hodi1(heroes2[0]);
    stop(HeroQ);
  end;
  if HeroQ == heroes2[0] then
    schetchikPl2 = schetchikPl2 + 1;
    hodi1(heroes1[0]);
    stop(HeroQ);
  end;
  if (schetchikPl1 + schetchikPl2) == 6 then
    SetOptionBattle();
  end;
end;

function MinusS5(hero)
  RemoveObject('s15');
  RemoveObject('s25');
  RemoveObject('m151');
  RemoveObject('m152');
  RemoveObject('m251');
  RemoveObject('m252');
  NumberBattle = NumberBattle - 5;
  if HeroQ == heroes1[0] then
    schetchikPl1 = schetchikPl1 + 1;
    hodi1(heroes2[0]);
    stop(HeroQ);
  end;
  if HeroQ == heroes2[0] then
    schetchikPl2 = schetchikPl2 + 1;
    hodi1(heroes1[0]);
    stop(HeroQ);
  end;
  if (schetchikPl1 + schetchikPl2) == 6 then
    SetOptionBattle();
  end;
end;

function MinusS6(hero)
  RemoveObject('s16');
  RemoveObject('s26');
  RemoveObject('m161');
  RemoveObject('m162');
  RemoveObject('m261');
  RemoveObject('m262');
  NumberBattle = NumberBattle - 6;
  if HeroQ == heroes1[0] then
    schetchikPl1 = schetchikPl1 + 1;
    hodi1(heroes2[0]);
    stop(HeroQ);
  end;
  if HeroQ == heroes2[0] then
    schetchikPl2 = schetchikPl2 + 1;
    hodi1(heroes1[0]);
    stop(HeroQ);
  end;
  if (schetchikPl1 + schetchikPl2) == 6 then
    SetOptionBattle();
  end;
end;

function MinusS7(hero)
  RemoveObject('s17');
  RemoveObject('s27');
  RemoveObject('m171');
  RemoveObject('m271');
  NumberBattle = NumberBattle - 7;
  if HeroQ == heroes1[0] then
    schetchikPl1 = schetchikPl1 + 1;
    hodi1(heroes2[0]);
    stop(HeroQ);
  end;
  if HeroQ == heroes2[0] then
    schetchikPl2 = schetchikPl2 + 1;
    hodi1(heroes1[0]);
    stop(HeroQ);
  end;
  if (schetchikPl1 + schetchikPl2) == 6 then
    SetOptionBattle();
  end;
end;

FM = 0;

function SetOptionBattle()

  rndLightRace = {};
  rndLightRace = { 1, 4, 5, 7};
  rndDarkRace  = {};
  rndDarkRace  = { 2, 3, 6, 8};
  rndMagicRace = {};
  rndMagicRace = { 3, 5, 6, 7};
  rndMightRace = {};
  rndMightRace = { 1, 2, 4, 8};

  SetObjectPosition('s17', 35, 91, 0);
  SetObjectPosition('s27', 42, 18, 0);
  SetObjectRotation('s27', 180);
  Trigger( OBJECT_TOUCH_TRIGGER, 's17', 'no'); Trigger( OBJECT_TOUCH_TRIGGER, 's27', 'no');

  if battle[NumberBattle] >= 6   and battle[NumberBattle] <= 13  then hero1race = 1; end;
  if battle[NumberBattle] >= 14  and battle[NumberBattle] <= 21  then hero1race = 2; end;
  if battle[NumberBattle] >= 22  and battle[NumberBattle] <= 29  then hero1race = 3; end;
  if battle[NumberBattle] >= 30  and battle[NumberBattle] <= 37  then hero1race = 4; end;
  if battle[NumberBattle] >= 38  and battle[NumberBattle] <= 45  then hero1race = 5; end;
  if battle[NumberBattle] >= 46  and battle[NumberBattle] <= 53  then hero1race = 6; end;
  if battle[NumberBattle] >= 54  and battle[NumberBattle] <= 61  then hero1race = 7; end;
  if battle[NumberBattle] >= 62  and battle[NumberBattle] <= 69  then hero1race = 8; end;
  if battle[NumberBattle] ==  1                                  then hero1race = random(8) + 1; end;
  if battle[NumberBattle] ==  2                                  then hero1race = rndLightRace[random(4) + 1]; end;
  if battle[NumberBattle] ==  3                                  then hero1race = rndMagicRace[random(4) + 1]; end;

  if mod(battle[NumberBattle] + 10, 8) == 0                      then hero2race = 1; end;
  if mod(battle[NumberBattle] +  9, 8) == 0                      then hero2race = 2; end;
  if mod(battle[NumberBattle] +  8, 8) == 0                      then hero2race = 3; end;
  if mod(battle[NumberBattle] +  7, 8) == 0                      then hero2race = 4; end;
  if mod(battle[NumberBattle] +  6, 8) == 0                      then hero2race = 5; end;
  if mod(battle[NumberBattle] +  5, 8) == 0                      then hero2race = 6; end;
  if mod(battle[NumberBattle] +  4, 8) == 0                      then hero2race = 7; end;
  if mod(battle[NumberBattle] +  3, 8) == 0                      then hero2race = 8; end;
  if battle[NumberBattle] ==  1                                  then hero2race = random(8) + 1; end;
  if battle[NumberBattle] ==  2                                  then hero2race =  rndDarkRace[random(4) + 1]; end;
  if battle[NumberBattle] ==  3                                  then hero2race = rndMightRace[random(4) + 1]; end;

  if battle[NumberBattle] == 4 then hero1race = random(8) + 1; hero2race = hero1race; end;
--  if battle[NumberBattle] == 5 then hero1race = random(8) + 1; hero2race = hero1race; end;

  x11=41; x12=44; y11=78; y12=78;
  x21=43; x22=41; y21=15; y22=15;

  OptionText[0] = array_options[0][option[NumberBattle]].text;
  if option[NumberBattle] == 2 then
    if arrayBonusForSiege[hero2race - 1][hero1race] ==  0 then OptionText[0] = GetMapDataPath().."Battle/SiegeRed0.txt";  end;
    if arrayBonusForSiege[hero2race - 1][hero1race] ==  5 then OptionText[0] = GetMapDataPath().."Battle/SiegeRed5.txt";  end;
    if arrayBonusForSiege[hero2race - 1][hero1race] == 10 then OptionText[0] = GetMapDataPath().."Battle/SiegeRed10.txt"; end;
    if arrayBonusForSiege[hero2race - 1][hero1race] == 15 then OptionText[0] = GetMapDataPath().."Battle/SiegeRed15.txt"; end;
    if arrayBonusForSiege[hero2race - 1][hero1race] == 20 then OptionText[0] = GetMapDataPath().."Battle/SiegeRed20.txt"; end;
    if arrayBonusForSiege[hero2race - 1][hero1race] == 25 then OptionText[0] = GetMapDataPath().."Battle/SiegeRed25.txt"; end;
    if arrayBonusForSiege[hero2race - 1][hero1race] == 30 then OptionText[0] = GetMapDataPath().."Battle/SiegeRed30.txt"; end;
  end;
  if option[NumberBattle] == 3 then
    if arrayBonusForSiege[hero1race - 1][hero2race] ==  0 then OptionText[0] = GetMapDataPath().."Battle/SiegeBlue0.txt";  end;
    if arrayBonusForSiege[hero1race - 1][hero2race] ==  5 then OptionText[0] = GetMapDataPath().."Battle/SiegeBlue5.txt";  end;
    if arrayBonusForSiege[hero1race - 1][hero2race] == 10 then OptionText[0] = GetMapDataPath().."Battle/SiegeBlue10.txt"; end;
    if arrayBonusForSiege[hero1race - 1][hero2race] == 15 then OptionText[0] = GetMapDataPath().."Battle/SiegeBlue15.txt"; end;
    if arrayBonusForSiege[hero1race - 1][hero2race] == 20 then OptionText[0] = GetMapDataPath().."Battle/SiegeBlue20.txt"; end;
    if arrayBonusForSiege[hero1race - 1][hero2race] == 25 then OptionText[0] = GetMapDataPath().."Battle/SiegeBlue25.txt"; end;
    if arrayBonusForSiege[hero1race - 1][hero2race] == 30 then OptionText[0] = GetMapDataPath().."Battle/SiegeBlue30.txt"; end;
  end;

  OverrideObjectTooltipNameAndDescription ('s17',  array_battles[0][battle[NumberBattle]].text, OptionText[0]);
  OverrideObjectTooltipNameAndDescription ('s27',  array_battles[0][battle[NumberBattle]].text, OptionText[0]);

  if FM == 1 and NumberBattle == 7 then FullMirror();
  else
    if random(2) == 0 then        --ПОМЕНЯТЬ НА 2!!!!!!
      CherkPossibleHeroes();
    else
      SetPossibleHeroes();
    end;
  end;

  if option[NumberBattle] == 7 then
    LevelUp = { 6000, 6500, 7000, 7500, 8000, 8500}
    StartExperience = 24500;
    StartLevel = 13;
  end;

  if option[NumberBattle] == 8 then
    LevelUp = { 10000, 10500, 11000, 11500, 12000, 12500}
    StartExperience = 99000;
    StartLevel = 21;
  end;

  if option[NumberBattle] == 9 then
    LevelUp = { 12000, 12500, 13000, 13500, 14000, 14500}
    StartExperience = 201000;
    StartLevel = 25;
  end;

end;

function RandomBattle()

  bat = random(length(array_battles[0]) - 6) + 7;
  while array_battles[0][bat].kv < random(100) or array_battles[0][bat].blocked == 1 do
    bat = random(length(array_battles[0]) - 6) + 7;
  end;
  array_battles[0][bat].blocked = 1;

  if bat >= 6   and bat <= 13  then h1race = 1; end;
  if bat >= 14  and bat <= 21  then h1race = 2; end;
  if bat >= 22  and bat <= 29  then h1race = 3; end;
  if bat >= 30  and bat <= 37  then h1race = 4; end;
  if bat >= 38  and bat <= 45  then h1race = 5; end;
  if bat >= 46  and bat <= 53  then h1race = 6; end;
  if bat >= 54  and bat <= 61  then h1race = 7; end;
  if bat >= 62  and bat <= 69  then h1race = 8; end;

  if mod(bat + 10, 8) == 0     then h2race = 1; end;
  if mod(bat +  9, 8) == 0     then h2race = 2; end;
  if mod(bat +  8, 8) == 0     then h2race = 3; end;
  if mod(bat +  7, 8) == 0     then h2race = 4; end;
  if mod(bat +  6, 8) == 0     then h2race = 5; end;
  if mod(bat +  5, 8) == 0     then h2race = 6; end;
  if mod(bat +  4, 8) == 0     then h2race = 7; end;
  if mod(bat +  3, 8) == 0     then h2race = 8; end;

  if h1race == h2race then
    Mirror = 1;
  else
    Mirror = 0;
  end;

  return bat, h1race, h2race;

end;


function RandomOption()
  if random(100) < 0 then
    opt = random(10) + 1;
    while array_options[0][opt].blocked == 1 do
      opt = random(10) + 1;
    end;
  else
    opt = 1;
  end;
--  if Mirror == 1 and opt == 1 and random(10) > 0 then
--    OverrideObjectTooltipNameAndDescription ('s17',  array_battles[0][battle[7]].text, GetMapDataPath().."Battle/Battle5.txt");
--    OverrideObjectTooltipNameAndDescription ('s27',  array_battles[0][battle[7]].text, GetMapDataPath().."Battle/Battle5.txt");
--    FM = 1;
--  end;
  return opt;
end;


function FullMirror()
  num_heroes=11;
  if (hero1race == 6) then num_heroes = 12; end;
  if (hero1race == 1) then num_heroes = 13; end;
  rnd1 = random(num_heroes) + 1;
  while array_heroes[hero1race-1][rnd1].blocked == 1 do
    rnd1 = random(num_heroes) + 1;
  end;
  DeployReserveHero(array_heroes[hero1race-1][rnd1].name, x11, y11, 0);
--  UpHeroStat(array_heroes[hero1race-1][rnd1].name);
  stop(array_heroes[hero1race-1][rnd1].name);
  HeroMax1 = array_heroes[hero1race-1][rnd1].name;
  HeroDop1 = array_heroes[hero1race-1][rnd1].name;
  DeployReserveHero(array_heroes[hero2race-1][rnd1].name2, x21, y21, 0);
--  UpHeroStat(array_heroes[hero2race-1][rnd1].name2);
  stop(array_heroes[hero2race-1][rnd1].name2);
  HeroMax2 = array_heroes[hero2race-1][rnd1].name2;
  HeroDop2 = array_heroes[hero2race-1][rnd1].name2;
  array_heroes[hero1race-1][rnd1].block_temply = 1;
  rnd2 = random(num_heroes) + 1;
  while array_heroes[hero1race-1][rnd2].blocked == 1 or array_heroes[hero1race-1][rnd2].block_temply == 1 do
    rnd2 = random(num_heroes) + 1;
  end;
  DeployReserveHero(array_heroes[hero1race-1][rnd2].name, x12, y12, 0);
--  UpHeroStat(array_heroes[hero1race-1][rnd2].name);
  stop(array_heroes[hero1race-1][rnd2].name);
  HeroMin1 = array_heroes[hero1race-1][rnd2].name;
  DeployReserveHero(array_heroes[hero2race-1][rnd2].name2, x22, y22, 0);
--  UpHeroStat(array_heroes[hero2race-1][rnd2].name2);
  stop(array_heroes[hero2race-1][rnd2].name2);
  HeroMin2 = array_heroes[hero2race-1][rnd2].name2;
  stop(heroes1[0]);
  stop(heroes2[0]);
end;

function SpellMirror()
  if hero1race == 1 then m11=0; m21=1; m31=RandomMagic(hero1race); end;
  if hero1race == 2 then m11=1; m21=2; m31=RandomMagic(hero1race); end;
  if hero1race == 3 then m11=1; m21=3; m31=RandomMagic(hero1race); end;
  if hero1race == 4 then m11=0; m21=2; m31=RandomMagic(hero1race); end;
  if hero1race == 5 then m11=3; m21=RandomMagic(hero1race);m31=-1; end;
  if hero1race == 6 then m11=2; m21=3; m31=RandomMagic(hero1race); end;
  if hero1race == 7 then m11=0; m21=2; m31=RandomMagic(hero1race); end;
  if hero1race == 8 then m11=5; m21=0; m31=RandomMagic(hero1race); end;

  if m11 < 4 then
    j = 1;
    for i = 1, 5 do
      sp = kolSpell( i, m11);
      while array_spells[m11][sp].blocked == 1 or array_spells[m11][sp].block_temply == 1 do
        sp = kolSpell( i, m11);
      end;
      array_spells[m11][sp].block_temply = 1;
      spells[0][j].m  = m11;
      spells[0][j].sp = sp;
      spells[1][j].m  = m11;
      spells[1][j].sp = sp;
      SpellPosition(m11, sp, j, 0);
      SpellPosition(m11, sp, j, 1);
      j = j + 1;
    end;
    for i = 1, 5 do
      sp = kolSpell( i, m21);
      while array_spells[m21][sp].blocked == 1 or array_spells[m21][sp].block_temply == 1 do
        sp = kolSpell( i, m21);
      end;
      array_spells[m21][sp].block_temply = 1;
      spells[0][j].m  = m21;
      spells[0][j].sp =  sp;
      spells[1][j].m  = m21;
      spells[1][j].sp =  sp;
      SpellPosition(m21, sp, j, 0);
      SpellPosition(m21, sp, j, 1);
      j = j + 1;
    end;
    for i = 1, 3 do
      m = random(4);
      sp = kolSpell( i, m);
      while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 or m == m11 or m == m21 do
        m = random(4);
        sp = kolSpell( i, m);
      end;
      array_spells[m][sp].block_temply = 1;
      spells[0][j].m  = m;
      spells[0][j].sp = sp;
      spells[1][j].m  = m;
      spells[1][j].sp = sp;
      SpellPosition(m, sp, j, 0);
      SpellPosition(m, sp, j, 1);
      j = j + 1;
    end;

    if m31 ~= -1 and hero1race ~= 5 then
      for i = 1, 5 do
        sp = kolSpell( i, m31);
        while array_spells[m31][sp].blocked == 1 or array_spells[m31][sp].block_temply == 1 do
          sp = kolSpell( i, m31);
        end;
        array_spells[m31][sp].block_temply = 1;
        spells[0][j].m  = m31;
        spells[0][j].sp =  sp;
        spells[1][j].m  = m31;
        spells[1][j].sp =  sp;
        SpellPosition(m31, sp, j, 0);
        SpellPosition(m31, sp, j, 1);
        j = j + 1;
      end;
    end;

    if hero1race == 5 and m31 == -1 then
      for i = 1, 5 do
        m = random(4);
        sp = kolSpell( i, m);
        while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1
        or (i > 3 and (m == m11 or m == m21)) do
          m = random(4);
          sp = kolSpell( i, m);
        end;
        array_spells[m][sp].block_temply = 1;
        spells[0][j].m  =  m;
        spells[0][j].sp = sp;
        spells[1][j].m  =  m;
        spells[1][j].sp = sp;
        SpellPosition( m, sp, j, 0);
        SpellPosition( m, sp, j, 1);
        j = j + 1;
      end;
    end;

    if hero1race == 5 and m31 ~= -1 then
      for i = 1, 5 do
        sp = kolSpell( i, m31);
        while array_spells[m31][sp].blocked == 1 or array_spells[m31][sp].block_temply == 1 do
          sp = kolSpell( i, m31);
        end;
        array_spells[m31][sp].block_temply = 1;
        spells[0][j].m  = m31;
        spells[0][j].sp =  sp;
        SpellPosition(m31, sp, j, 0);
        SpellPosition(m31, sp, j, 1);
        j = j + 1;
      end;
    end;

    if hero1race == 6 then
      for i = 4, 5 do
        m = random(4);
        sp = kolSpell( i, m);
        while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
          m = random(4);
          sp = kolSpell( i, m);
        end;
        array_spells[m][sp].block_temply = 1;
        spells[0][j].m  =  m;
        spells[0][j].sp = sp;
        spells[1][j].m  =  m;
        spells[1][j].sp = sp;
        SpellPosition( m, sp, j, 0);
        SpellPosition( m, sp, j, 1);
        j = j + 1;
      end;
      if m31 == -1 then
        for i = 4, 5 do
          m = random(4);
          sp = kolSpell( i, m);
          while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
            m = random(4);
            sp = kolSpell( i, m);
          end;
          array_spells[m][sp].block_temply = 1;
          spells[0][j].m  =  m;
          spells[0][j].sp = sp;
          spells[1][j].m  =  m;
          spells[1][j].sp = sp;
          SpellPosition( m, sp, j, 0);
          SpellPosition( m, sp, j, 1);
          j = j + 1;
        end;
      end;
      i = random(2) + 4;
      m = random(4);
      sp = kolSpell( i, m);
      while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
        m = random(4);
        sp = kolSpell( i, m);
      end;
      array_spells[m][sp].block_temply = 1;
      spells[0][j].m  =  m;
      spells[0][j].sp = sp;
      spells[1][j].m  =  m;
      spells[1][j].sp = sp;
      SpellPosition( m, sp, j, 0);
      SpellPosition( m, sp, j, 1);
      j = j + 1;
    end;

    if race == 7 then
      for i = 1, 5 do
        sp = kolSpell( i, 4);
        while array_spells[4][sp].blocked == 1 or array_spells[4][sp].block_temply == 1 do
          sp = kolSpell( i, 4);
        end;
        array_spells[4][sp].block_temply = 1;
        spells[0][j].m  =  4;
        spells[0][j].sp = sp;
        spells[1][j].m  =  4;
        spells[1][j].sp = sp;
        SpellPosition( 4, sp, j, 0);
        SpellPosition( 4, sp, j, 1);
        j = j + 1;
      end;
    end;

    for i = 0, 4 do
      k = 12;
      if i == 4 then k = 10; end;
      for j = 1, k do
        array_spells[i][j].block_temply = 0;
      end;
    end;

  end;

  if m11 == 5 then
    j = 1;
    spells[0][1].m  = 5;
    spells[0][1].sp = 1;
    spells[1][1].m  = 5;
    spells[1][1].sp = 1;
    SpellPosition(5, 1, j, 0);
    SpellPosition(5, 1, j, 1);
    j = j + 2;
    spells[0][2].m  = 5;
    spells[0][2].sp = 2;
    spells[1][2].m  = 5;
    spells[1][2].sp = 2;
    SpellPosition(5, 2, j, 0);
    SpellPosition(5, 2, j, 1);
    j = j + 2;
    sp = random(2)+3;
    spells[0][3].m  = 5;
    spells[0][3].sp = sp;
    spells[1][3].m  = 5;
    spells[1][3].sp = sp;
    SpellPosition(5, sp, j, 0);
    SpellPosition(5, sp, j, 1);
    j = j + 7;
    sp = random(2)+5;
    spells[0][4].m  = 5;
    spells[0][4].sp = sp;
    spells[1][4].m  = 5;
    spells[1][4].sp = sp;
    SpellPosition(5, sp, j, 0);
    SpellPosition(5, sp, j, 1);
  end;

end;

OptionText = {}
OptionText = { GetMapDataPath().."Battle/Option0.txt", GetMapDataPath().."Battle/Option0.txt", GetMapDataPath().."Battle/Option0.txt", GetMapDataPath().."Battle/Option0.txt", GetMapDataPath().."Battle/Option0.txt", GetMapDataPath().."Battle/Option0.txt", GetMapDataPath().."Battle/Option0.txt"}

if GAME_MODE.MATCHUPS then

  NumberBattle = 28;

  for i = 1, 6 do
--    if i == 7 then Mirror = 1; else Mirror = 0; end;
    battle[i], h1r, h2r = RandomBattle();
    option[i] = RandomOption();
    if h1r == 1 then ID1 =   5; end;
    if h1r == 2 then ID1 =  15; end;
    if h1r == 3 then ID1 =  35; end;
    if h1r == 4 then ID1 =  47; end;
    if h1r == 5 then ID1 =  63; end;
    if h1r == 6 then ID1 =  73; end;
    if h1r == 7 then ID1 = 100; end;
    if h1r == 8 then ID1 = 125; end;
    if h2r == 1 then ID2 = 108; end;
    if h2r == 2 then ID2 = 131; end;
    if h2r == 3 then ID2 = 155; end;
    if h2r == 4 then ID2 = 147; end;
    if h2r == 5 then ID2 = 162; end;
    if h2r == 6 then ID2 = 139; end;
    if h2r == 7 then ID2 = 170; end;
    if h2r == 8 then ID2 = 177; end;

    if i == 1 then
--      battle[i] = 5;
      CreateMonster('m111', ID1, 1, 31, 90, 0, 1, 2,  90, 0); SetObjectEnabled('m111', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm111', 'MinusS1Question' );
      if option[i] ~= 1 then SetObjectPosition ('s11', 32, 90, 0); end;
      CreateMonster('m112', ID2, 1, 32, 90, 0, 1, 2, 270, 0); SetObjectEnabled('m112', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm112', 'MinusS1Question' );  SetObjectPosition('m112', 32, 90, 0);
      CreateMonster('m211', ID1, 1, 39, 25, 0, 1, 2, 270, 0); SetObjectEnabled('m211', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm211', 'MinusS1Question' );
      if option[i] ~= 1 then SetObjectPosition ('s21', 39, 25, 0); end;
      CreateMonster('m212', ID2, 1, 38, 25, 0, 1, 2,  90, 0); SetObjectEnabled('m212', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm212', 'MinusS1Question' );  SetObjectPosition('m212', 38, 25, 0);
      SetObjectPosition(array_MathcUp[i].colour11, 31, 90, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour11, 'MinusS1Question' );
      SetObjectPosition(array_MathcUp[i].colour21, 32, 90, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour21, 'MinusS1Question' );
      SetObjectPosition(array_MathcUp[i].colour12, 39, 25, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour12, 'MinusS1Question' );
      SetObjectPosition(array_MathcUp[i].colour22, 38, 25, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour22, 'MinusS1Question' );
      OptionText[i] = array_options[0][option[i]].text;
      if option[i] == 2 then
        if arrayBonusForSiege[h2r - 1][h1r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed0.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed5.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed10.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed15.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed20.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed25.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed30.txt"; end;
      end;
      if option[i] == 3 then
        if arrayBonusForSiege[h1r - 1][h2r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue0.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue5.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue10.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue15.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue20.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue25.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue30.txt"; end;
      end;
      OverrideObjectTooltipNameAndDescription ('m111', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m112', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m211', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m212', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s11',  array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s21',  array_battles[0][battle[i]].text, OptionText[i]);
    end;

    if i == 2 then
      CreateMonster('m121', ID1, 1, 38, 90, 0, 1, 2,  90, 0); SetObjectEnabled('m121', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm121', 'MinusS2Question' );
      if option[i] ~= 1 then SetObjectPosition ('s12', 38, 90, 0); end;
      CreateMonster('m122', ID2, 1, 39, 90, 0, 1, 2, 270, 0); SetObjectEnabled('m122', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm122', 'MinusS2Question' );  SetObjectPosition('m122', 39, 90, 0);
      CreateMonster('m221', ID1, 1, 46, 25, 0, 1, 2, 270, 0); SetObjectEnabled('m221', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm221', 'MinusS2Question' );
      if option[i] ~= 1 then SetObjectPosition ('s22', 45, 25, 0); end;
      CreateMonster('m222', ID2, 1, 45, 25, 0, 1, 2,  90, 0); SetObjectEnabled('m222', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm222', 'MinusS2Question' );  SetObjectPosition('m222', 45, 25, 0);
      SetObjectPosition(array_MathcUp[i].colour11, 38, 90, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour11, 'MinusS2Question' );
      SetObjectPosition(array_MathcUp[i].colour21, 39, 90, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour21, 'MinusS2Question' );
      SetObjectPosition(array_MathcUp[i].colour12, 46, 25, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour12, 'MinusS2Question' );
      SetObjectPosition(array_MathcUp[i].colour22, 45, 25, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour22, 'MinusS2Question' );
      OptionText[i] = array_options[0][option[i]].text;
      if option[i] == 2 then
        if arrayBonusForSiege[h2r - 1][h1r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed0.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed5.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed10.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed15.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed20.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed25.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed30.txt"; end;
      end;
      if option[i] == 3 then
        if arrayBonusForSiege[h1r - 1][h2r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue0.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue5.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue10.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue15.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue20.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue25.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue30.txt"; end;
      end;
      OverrideObjectTooltipNameAndDescription ('m121', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m122', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m221', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m222', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s12',  array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s22',  array_battles[0][battle[i]].text, OptionText[i]);
    end;
    if i == 3 then
      CreateMonster('m131', ID1, 1, 31, 87, 0, 1, 2,  90, 0); SetObjectEnabled('m131', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm131', 'MinusS3Question' );
      if option[i] ~= 1 then SetObjectPosition ('s13', 32, 87, 0); end;
      CreateMonster('m132', ID2, 1, 32, 87, 0, 1, 2, 270, 0); SetObjectEnabled('m132', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm132', 'MinusS3Question' );  SetObjectPosition('m132', 32, 87, 0);
      CreateMonster('m231', ID1, 1, 39, 22, 0, 1, 2, 270, 0); SetObjectEnabled('m231', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm231', 'MinusS3Question' );
      if option[i] ~= 1 then SetObjectPosition ('s23', 39, 22, 0); end;
      CreateMonster('m232', ID2, 1, 38, 22, 0, 1, 2,  90, 0); SetObjectEnabled('m232', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm232', 'MinusS3Question' );  SetObjectPosition('m232', 38, 22, 0);
      SetObjectPosition(array_MathcUp[i].colour11, 31, 87, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour11, 'MinusS3Question' );
      SetObjectPosition(array_MathcUp[i].colour21, 32, 87, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour21, 'MinusS3Question' );
      SetObjectPosition(array_MathcUp[i].colour12, 39, 22, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour12, 'MinusS3Question' );
      SetObjectPosition(array_MathcUp[i].colour22, 38, 22, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour22, 'MinusS3Question' );
      OptionText[i] = array_options[0][option[i]].text;
      if option[i] == 2 then
        if arrayBonusForSiege[h2r - 1][h1r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed0.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed5.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed10.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed15.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed20.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed25.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed30.txt"; end;
      end;
      if option[i] == 3 then
        if arrayBonusForSiege[h1r - 1][h2r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue0.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue5.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue10.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue15.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue20.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue25.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue30.txt"; end;
      end;
      OverrideObjectTooltipNameAndDescription ('m131', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m132', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m231', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m232', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s13',  array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s23',  array_battles[0][battle[i]].text, OptionText[i]);
    end;
    if i == 4 then
      CreateMonster('m141', ID1, 1, 38, 87, 0, 1, 2,  90, 0); SetObjectEnabled('m141', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm141', 'MinusS4Question' );
      if option[i] ~= 1 then SetObjectPosition ('s14', 38, 87, 0); end;
      CreateMonster('m142', ID2, 1, 39, 87, 0, 1, 2, 270, 0); SetObjectEnabled('m142', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm142', 'MinusS4Question' );  SetObjectPosition('m142', 39, 87, 0);
      CreateMonster('m241', ID1, 1, 46, 22, 0, 1, 2, 270, 0); SetObjectEnabled('m241', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm241', 'MinusS4Question' );
      if option[i] ~= 1 then SetObjectPosition ('s24', 45, 22, 0); end;
      CreateMonster('m242', ID2, 1, 45, 22, 0, 1, 2,  90, 0); SetObjectEnabled('m242', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm242', 'MinusS4Question' );  SetObjectPosition('m242', 45, 22, 0);
      SetObjectPosition(array_MathcUp[i].colour11, 38, 87, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour11, 'MinusS4Question' );
      SetObjectPosition(array_MathcUp[i].colour21, 39, 87, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour21, 'MinusS4Question' );
      SetObjectPosition(array_MathcUp[i].colour12, 46, 22, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour12, 'MinusS4Question' );
      SetObjectPosition(array_MathcUp[i].colour22, 45, 22, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour22, 'MinusS4Question' );
      OptionText[i] = array_options[0][option[i]].text;
      if option[i] == 2 then
        if arrayBonusForSiege[h2r - 1][h1r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed0.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed5.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed10.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed15.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed20.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed25.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed30.txt"; end;
      end;
      if option[i] == 3 then
        if arrayBonusForSiege[h1r - 1][h2r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue0.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue5.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue10.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue15.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue20.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue25.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue30.txt"; end;
      end;
      OverrideObjectTooltipNameAndDescription ('m141', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m142', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m241', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m242', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s14',  array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s24',  array_battles[0][battle[i]].text, OptionText[i]);
    end;
    if i == 5 then
      CreateMonster('m151', ID1, 1, 31, 84, 0, 1, 2,  90, 0); SetObjectEnabled('m151', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm151', 'MinusS5Question' );
      if option[i] ~= 1 then SetObjectPosition ('s15', 32, 84, 0); end;
      CreateMonster('m152', ID2, 1, 32, 84, 0, 1, 2, 270, 0); SetObjectEnabled('m152', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm152', 'MinusS5Question' );  SetObjectPosition('m152', 32, 84, 0);
      CreateMonster('m251', ID1, 1, 39, 19, 0, 1, 2, 270, 0); SetObjectEnabled('m251', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm251', 'MinusS5Question' );
      if option[i] ~= 1 then SetObjectPosition ('s25', 39, 19, 0); end;
      CreateMonster('m252', ID2, 1, 38, 19, 0, 1, 2,  90, 0); SetObjectEnabled('m252', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm252', 'MinusS5Question' );  SetObjectPosition('m252', 38, 19, 0);
      SetObjectPosition(array_MathcUp[i].colour11, 31, 84, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour11, 'MinusS5Question' );
      SetObjectPosition(array_MathcUp[i].colour21, 32, 84, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour21, 'MinusS5Question' );
      SetObjectPosition(array_MathcUp[i].colour12, 39, 19, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour12, 'MinusS5Question' );
      SetObjectPosition(array_MathcUp[i].colour22, 38, 19, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour22, 'MinusS5Question' );
      OptionText[i] = array_options[0][option[i]].text;
      if option[i] == 2 then
        if arrayBonusForSiege[h2r - 1][h1r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed0.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed5.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed10.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed15.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed20.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed25.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed30.txt"; end;
      end;
      if option[i] == 3 then
        if arrayBonusForSiege[h1r - 1][h2r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue0.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue5.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue10.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue15.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue20.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue25.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue30.txt"; end;
      end;
      OverrideObjectTooltipNameAndDescription ('m151', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m152', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m251', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m252', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s15',  array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s25',  array_battles[0][battle[i]].text, OptionText[i]);
    end;
    if i == 6 then
      CreateMonster('m161', ID1, 1, 38, 84, 0, 1, 2,  90, 0); SetObjectEnabled('m161', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm161', 'MinusS6Question' );
      if option[i] ~= 1 then SetObjectPosition ('s16', 38, 84, 0); end;
      CreateMonster('m162', ID2, 1, 39, 84, 0, 1, 2, 270, 0); SetObjectEnabled('m162', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm162', 'MinusS6Question' );  SetObjectPosition('m162', 39, 84, 0);
      CreateMonster('m261', ID1, 1, 46, 19, 0, 1, 2, 270, 0); SetObjectEnabled('m261', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm261', 'MinusS6Question' );
      if option[i] ~= 1 then SetObjectPosition ('s26', 45, 19, 0); end;
      CreateMonster('m262', ID2, 1, 45, 19, 0, 1, 2,  90, 0); SetObjectEnabled('m262', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm262', 'MinusS6Question' );  SetObjectPosition('m262', 45, 19, 0);
      SetObjectPosition(array_MathcUp[i].colour11, 38, 84, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour11, 'MinusS6Question' );
      SetObjectPosition(array_MathcUp[i].colour21, 39, 84, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour21, 'MinusS6Question' );
      SetObjectPosition(array_MathcUp[i].colour12, 46, 19, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour12, 'MinusS6Question' );
      SetObjectPosition(array_MathcUp[i].colour22, 45, 19, 0); Trigger( OBJECT_TOUCH_TRIGGER, array_MathcUp[i].colour22, 'MinusS6Question' );
      OptionText[i] = array_options[0][option[i]].text;
      if option[i] == 2 then
        if arrayBonusForSiege[h2r - 1][h1r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed0.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed5.txt";  end;
        if arrayBonusForSiege[h2r - 1][h1r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed10.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed15.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed20.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed25.txt"; end;
        if arrayBonusForSiege[h2r - 1][h1r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeRed30.txt"; end;
      end;
      if option[i] == 3 then
        if arrayBonusForSiege[h1r - 1][h2r] ==  0 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue0.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] ==  5 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue5.txt";  end;
        if arrayBonusForSiege[h1r - 1][h2r] == 10 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue10.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 15 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue15.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 20 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue20.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 25 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue25.txt"; end;
        if arrayBonusForSiege[h1r - 1][h2r] == 30 then OptionText[i] = GetMapDataPath().."Battle/SiegeBlue30.txt"; end;
      end;
      OverrideObjectTooltipNameAndDescription ('m161', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m162', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m261', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('m262', array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s16',  array_battles[0][battle[i]].text, OptionText[i]);
      OverrideObjectTooltipNameAndDescription ('s26',  array_battles[0][battle[i]].text, OptionText[i]);
    end;
    
--    if i == 7 then
--      CreateMonster('m171', ID1, 1, 89, 32, 0, 1, 2, 0, 0); SetObjectEnabled('m171', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm171', 'MinusS7Question' );
--      SetObjectPosition     ('s17', 89, 32, 0);
--      CreateMonster('m271', ID1, 1,  6, 54, 0, 1, 2, 0, 0); SetObjectEnabled('m271', nil); Trigger( OBJECT_TOUCH_TRIGGER, 'm271', 'MinusS7Question' );
--      SetObjectPosition     ('s27',  6, 54, 0);
--      OverrideObjectTooltipNameAndDescription ('m171', array_battles[0][battle[i]].text, array_options[0][option[i]].text);
--      OverrideObjectTooltipNameAndDescription ('m271', array_battles[0][battle[i]].text, array_options[0][option[i]].text);
--      if FM ~=1 then OverrideObjectTooltipNameAndDescription ('s17',  array_battles[0][battle[i]].text, array_options[0][option[i]].text); end;
--      if FM ~=1 then OverrideObjectTooltipNameAndDescription ('s27',  array_battles[0][battle[i]].text, array_options[0][option[i]].text); end;
--    end;
  end;
end;



function mumiyaVopros ()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."mumiya.txt", 'rndRace', 'no');
end;



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

Trigger( OBJECT_TOUCH_TRIGGER, 'mentor1', 'mentor1' );
Trigger( OBJECT_TOUCH_TRIGGER, 'mentor2', 'mentor2' );

RemoveSkillStart1 = 0;
RemoveSkillStart2 = 0;

function mentor1(heroX)
  ArraySkill1();
  ArrayStatHero(heroX);
  if GenerateLearningEnable1 == 0 then GenerateStatLearning1(heroX); end;
  Trigger( HERO_REMOVE_SKILL_TRIGGER, heroX, 'MentorRemoveSkill1');
  RemSk1 = 0;
  AddSk1 = 0;
  Trigger( HERO_ADD_SKILL_TRIGGER, heroX, 'MentorAddSkill1');
  STARTattH1 = GetHeroStat(heroX, STAT_ATTACK);
  STARTdefH1 = GetHeroStat(heroX, STAT_DEFENCE);
  STARTspH1  = GetHeroStat(heroX, STAT_SPELL_POWER);
  STARTknH1  = GetHeroStat(heroX, STAT_KNOWLEDGE);
end;

function mentor2(heroX)
  ArraySkill2();
  ArrayStatHero(heroX);
  if GenerateLearningEnable2 == 0 then GenerateStatLearning2(heroX); end;
  Trigger( HERO_REMOVE_SKILL_TRIGGER, heroX, 'MentorRemoveSkill2');
  RemSk2 = 0;
  AddSk2 = 0;
  Trigger( HERO_ADD_SKILL_TRIGGER, heroX, 'MentorAddSkill2');
  STARTattH2 = GetHeroStat(heroX, STAT_ATTACK);
  STARTdefH2 = GetHeroStat(heroX, STAT_DEFENCE);
  STARTspH2  = GetHeroStat(heroX, STAT_SPELL_POWER);
  STARTknH2  = GetHeroStat(heroX, STAT_KNOWLEDGE);
end;

function MentorRemoveSkill1(heroXX,skillXX)
  if GetHeroStat(heroXX, STAT_EXPERIENCE) < 2000 and RemoveSkillStart1 < 2 then
--    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  500));
    RemoveSkillStart1 = RemoveSkillStart1 + 1;
  else
    if GetHeroStat(heroXX, STAT_EXPERIENCE) < 2000 and RemoveSkillStart1 > 1 then
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - 2000));
      RemoveSkillStart1 = RemoveSkillStart1 + 1;
    end;
  end;
  if GetHeroStat(heroXX, STAT_EXPERIENCE) >= 2000   and GetHeroStat(heroXX, STAT_EXPERIENCE) < 14000 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  1000)); end;
  if GetHeroStat(heroXX, STAT_EXPERIENCE) >= 14000 and GetHeroStat(heroXX, STAT_EXPERIENCE) < 20000 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -   500)); end;
  RemSk1 = RemSk1 + 1;
  RemSkSum1 = RemSkSum1 + 1;
  RemoveSkill1(heroXX, skillXX);
end;

function  MentorRemoveSkill2(heroXX,skillXX)
  if GetHeroStat(heroXX, STAT_EXPERIENCE) < 2000 and RemoveSkillStart2 < 2 then
--    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  500));
    RemoveSkillStart2 = RemoveSkillStart2 + 1;
  else
    if GetHeroStat(heroXX, STAT_EXPERIENCE) < 2000 and RemoveSkillStart2 > 1 then
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - 2000));
      RemoveSkillStart2 = RemoveSkillStart2 + 1;
    end;
  end;
  if GetHeroStat(heroXX, STAT_EXPERIENCE) >= 2000   and GetHeroStat(heroXX, STAT_EXPERIENCE) < 14000 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  1000)); end;
  if GetHeroStat(heroXX, STAT_EXPERIENCE) >= 14000 and GetHeroStat(heroXX, STAT_EXPERIENCE) < 20000 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -   500)); end;
  RemSk2 = RemSk2 + 1;
  RemSkSum2 = RemSkSum2 + 1;
  RemoveSkill2(heroXX, skillXX);
end;

function MentorAddSkill1(hero, skill)
  AddSkill1(hero, skill);
  AddSk1 = AddSk1 + 1;
--  if EstatesEnable1 == 1 then EstatesDiscountUse1 = 1; else EstatesDiscountUse1 = 0; end;
  if AddSk1 == RemSk1 and ReturnSkillPlayer1 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse1 == 1 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + RemSk1 * EstatesDiscountMentor));
    ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = RemSk1 * EstatesDiscountMentor}, HeroMax1, 1, 5.0);
  end;
  if AddSk1 == RemSk1 and ReturnSkillPlayer1 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse1 == 0 then
    Estates1Q(hero);
  end;
  if AddSk1 == RemSk1 and ReturnSkillPlayer1 == 1 then
    ShowFlyingSign(GetMapDataPath().."NoForget.txt", HeroMax1, 1, 5.0);
    ReturnSkill1(hero);
  end;
end;

function MentorAddSkill2(hero, skill)
  AddSkill2(hero, skill);
  AddSk2 = AddSk2 + 1;
--  if EstatesEnable2 == 1 then EstatesDiscountUse2 = 1; else EstatesDiscountUse2 = 0; end;
  if AddSk2 == RemSk2 and ReturnSkillPlayer2 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse2 == 1 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + RemSk2 * EstatesDiscountMentor));
    ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = RemSk2 * EstatesDiscountMentor}, HeroMax2, 2, 5.0);
  end;
  if AddSk2 == RemSk2 and ReturnSkillPlayer2 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse2 == 0 then
    Estates2Q(hero);
  end;
  if AddSk2 == RemSk2 and ReturnSkillPlayer2 == 1 then
    ShowFlyingSign(GetMapDataPath().."NoForget.txt", HeroMax2, 2, 5.0);
    ReturnSkill2(hero);
  end;
end;



ReturnSkillPlayer1 = 0;
ReturnSkillPlayer2 = 0;
EstatesUse1 = 0;
EstatesUse2 = 0;
SpoilsUse1 = 0;
SpoilsUse2 = 0;
Skill1_78 = 0;
Skill2_78 = 0;
SumSkill1 = 0;
SumSkill2 = 0;
RevUse1 = 0;
RevUse2 = 0;
upp=0;
StudentUse1 = 0;
StudentUse2 = 0;
AcademyUse1 = 0;
AcademyUse2 = 0;


EstatesEnable1 = 0;
EstatesEnable2 = 0;
EstatesDiscountUse1 = 0;
EstatesDiscountUse2 = 0;

Disconnect_SkillPlayer1 = 'AddSkillPlayer1: '
Disconnect_SkillPlayer2 = 'AddSkillPlayer2: '
Disconnect_GoldPlayer1 = 0
Disconnect_GoldPlayer2 = 0

function AddSkill1(hero, skill)
--  print(skill);
  Disconnect_SkillPlayer1 = Disconnect_SkillPlayer1 .. ' +' .. skill
  Disconnect_GoldPlayer1 = GetPlayerResource (PLAYER_1, GOLD)
  ControlStatHero(hero, skill, 1);
--  if RevUse1 == 2 then RevUse1 = 1; end;
--  if RevDel1 == 1 and RevUse1 ~= 1 and ((GetHeroLevel(hero) == 10 and DisableBagPlayer1 == 0) or (StartLevel == 13 and GetHeroLevel(hero) > 13)
--    or (StartLevel == 17 and GetHeroLevel(hero) > 17) or (StartLevel == 21 and GetHeroLevel(hero) > 21) or (StartLevel == 25 and GetHeroLevel(hero) > 25))
--    then RevUse1 = 2; LevelUpHero(hero);
--  end;
  if skill == 129 and GetDate (DAY) == 4 and SpoilsUse1 == 0 then Spoils1(hero) end;
  if skill ==  30 and GetDate (DAY) == 4 then diplomacy1(hero) end;
  if skill == 79 and StudentUse1 == 0 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 1000)); StudentUse1 = 1; end;
--  if skill == 127 and AcademyUse1 == 0 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 1000)); AcademyUse1 = 1; end;
--  if skill == 87 then ChangeHeroStat(hero, 3, 1); end; --ХРАНИТЕЛЬ ТАЙНОГО
--  if skill == 169 then ChangeLevel(hero, 10); end;
  if skill == 33 and GetHeroStat(hero, STAT_EXPERIENCE) > 1000 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end; --FortunateAdventure1(hero) end;
  if (skill == 29 and RemSk1 == 0) or (skill == 29 and GetHeroLevel(hero) > StartLevel) then Estates1Q(hero); end; --ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
  if skill == 71 or (HasHeroSkill(hero, 71) and GetHeroLevel(hero) == 2) then startThread(DarkRitual) end;
  if skill == 182 then GoblinSupport1(hero) end;
--  if skill == 110 then HauntMine1(hero) end;
  if skill == 57 then SetTownBuildingLimitLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 1); end;
  if skill == 115 then ForestGuard1(hero); end;
  if skill == 181 then DefendUsAll1(hero); end;
  if skill == 1 then Logistics1(hero); end;
  if skill == 21 or (HasHeroSkill(hero, 21) and GetHeroLevel(hero) == 2)then Navigation1(); end;
  if skill == 131 then ChangeHeroStat(hero, 2, -2); end;
--  if skill == 141 then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, -1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
  if skill == 186 then ChangeHeroStat(hero, 2, -1); end;
  if skill == 185 then ChangeHeroStat(hero, 4,  2); end;
  if skill == 110 or skill == 137 then GraalVision(hero, 1); end;
  if (skill == 140 or skill == 219) and (RevDel1 == 3) then Revelation1(); end;
--  if (HasHeroSkill(hero, 140) or HasHeroSkill(hero, 219)) and (RevDel1 == 0 or (RevUse1 == 1 and RevDel1 == 1) or (RevUse1 == 3 and RevDel1 == 3)) then Revelation1(); end;
  if skill == 20 or skill == 112 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
--  if skill == 168 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
  if skill == 102 then startThread(HeraldFunction1); end; --ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
--  if (skill == 78 or HasHeroSkill(hero, 78)) and GetHeroLevel(hero) >= StartLevel and Skill1_78 == 0 then ChangeLevel(hero, 5); Skill1_78 = 1; end;
  if skill == 81 then ChangeHeroStat(hero, STAT_MANA_POINTS, -100); end;
--  if RevUse1 == 4 then RevUse1 = 3; end;
  if skill == 81 then ChangeHeroStat(hero, 3, -2); end; --ChangeHeroStat(hero, 4, 2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, -2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
--  print(skill)
  if (skill == 3 or skill == 183) and ReturnSkillPlayer1 == 0 then Learning1(hero) end;
  ArrayStatHero(hero);
end;

function AddSkill2(hero, skill)
--  print(skill);
  Disconnect_SkillPlayer2 = Disconnect_SkillPlayer2 .. ' +' .. skill
  Disconnect_GoldPlayer2 = GetPlayerResource (PLAYER_2, GOLD)
  ControlStatHero(hero, skill, 1);
--  if RevUse2 == 2 then RevUse2 = 1; end;
--  if RevDel2 == 1 and RevUse2 ~= 1 and ((GetHeroLevel(hero) == 10 and DisableBagPlayer2 == 0) or (StartLevel == 13 and GetHeroLevel(hero) > 13)
--    or (StartLevel == 17 and GetHeroLevel(hero) > 17) or (StartLevel == 21 and GetHeroLevel(hero) > 21) or (StartLevel == 25 and GetHeroLevel(hero) > 25))
--    then RevUse2 = 2; LevelUpHero(hero);
--  end;
  if skill == 129 and GetDate (DAY) == 4 and SpoilsUse2 == 0 then Spoils2(hero) end;
  if skill ==  30 and GetDate (DAY) == 4 then diplomacy2(hero) end;
  if skill == 79 and StudentUse2 == 0 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 1000)); StudentUse2 = 1; end;
--  if skill == 127 and AcademyUse2 == 0 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 1000)); AcademyUse2 = 1; end;
--  if skill == 87 then ChangeHeroStat(hero, 3, 1); end; --ХРАНИТЕЛЬ ТАЙНОГО
--  if skill == 169 then ChangeLevel(hero, 10); end;
  if skill == 33 and GetHeroStat(hero, STAT_EXPERIENCE) > 1000 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end; --FortunateAdventure2(hero) end;
  if (skill == 29 and RemSk2 == 0) or (skill == 29 and GetHeroLevel(hero) > StartLevel) then Estates2Q(hero); end; --ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
  if skill == 71 or (HasHeroSkill(hero, 71) and GetHeroLevel(hero) == 2) then startThread(DarkRitual) end;
  if skill == 182 then GoblinSupport2(hero) end;
--  if skill == 110 then HauntMine2(hero) end;
  if skill == 57 then SetTownBuildingLimitLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 1); end;
  if skill == 115 then ForestGuard2(hero); end;
  if skill == 181 then DefendUsAll2(hero); end;
  if skill == 1 then Logistics2(hero) end;
  if skill == 21 or (HasHeroSkill(hero, 21) and GetHeroLevel(hero) == 2)then Navigation2(); end;
  if skill == 131 then ChangeHeroStat(hero, 2, -2); end;
--  if skill == 141 then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, -1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
  if skill == 186 then ChangeHeroStat(hero, 2, -1); end;
  if skill == 185 then ChangeHeroStat(hero, 4,  2); end;
  if skill == 110 or skill == 137 then GraalVision(hero, 1); end;
  if (skill == 140 or skill == 219) and (RevDel2 == 3) then Revelation2(); end;
--  if (HasHeroSkill(hero, 140) or HasHeroSkill(hero, 219)) and (RevDel2 == 0 or (RevUse2 == 1 and RevDel2 == 1) or (RevUse2 == 3 and RevDel2 == 3)) then Revelation2(); end;
  if skill == 20 or skill == 112 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
--  if skill == 168 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
  if skill == 102 then startThread(HeraldFunction2); end; -- ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
--  if (skill == 78 or HasHeroSkill(hero, 78)) and GetHeroLevel(hero) >= StartLevel and Skill2_78 == 0 then ChangeLevel(hero, 5); Skill2_78 = 1; end;
  if skill == 81 then ChangeHeroStat(hero, STAT_MANA_POINTS, -100); end;
--  if RevUse2 == 4 then RevUse2 = 3; end;
  if skill == 81 then ChangeHeroStat(hero, 3, -2); end; --ChangeHeroStat(hero, 4, 2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, -2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
--  print(skill)
  if (skill == 3 or skill == 183) and ReturnSkillPlayer2 == 0 then Learning2(hero) end;
  ArrayStatHero(hero);
end;


function RemoveSkill1(hero, skill)
  sleep(1);
  Disconnect_SkillPlayer1 = Disconnect_SkillPlayer1 .. ' -' .. skill

  ControlStatHero(hero, skill, 0);
  sleep(1);
  if skill == 129 and SpoilsUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 16 and AvengerUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 17 and minikUse1 > 0 then ReturnSkillPlayer1 = 1; end;
  if skill == 29 and EstatesDiscountUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 29 and EstatesDiscountUse1 == 0 and ReturnSkillPlayer1 == 0 then EstatesEnable1 = 0; end; --ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED); end;
  if skill == 33 and FortunateAdventureEnable1 ~= 0 then ReturnSkillPlayer1 = 1; end;
  if skill == 33 and FortunateAdventureEnable1 == 0 and ReturnSkillPlayer1 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED); end; --SetObjectEnabled('lavka1',  true); Trigger( OBJECT_TOUCH_TRIGGER, 'lavka1', 'no' ); end;
--  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_TRAINING_GROUNDS) > 0 then ReturnSkillPlayer1 = 1; end;
  if skill == 152 and RunesChangeUse1 > 0 then ReturnSkillPlayer1 = 1; end;
  if skill == 1 then DelLogistics1(hero); if LogisticsNoMoney1 == 1 then ReturnSkillPlayer1 = 1; end; end;
  if skill == 21 and NavUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 131 then ChangeHeroStat(hero, 2, 2); end;
--  if skill == 141 then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, 1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, -1); end;
  if skill == 186 then ChangeHeroStat(hero, 2, 1); end;
  if skill == 185 then ChangeHeroStat(hero, 4, -2); end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) <  1 then SetTownBuildingLimitLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0); end;
  if skill == 110 or skill == 137 then GraalVision(hero, -1); end;
--  if skill == 169 then ChangeLevel(hero, -10); end;
  if skill == 71 and ReturnSkillPlayer1 == 0 then RemoveDarkRitual1(hero); end;
--  if skill == 87 then ChangeHeroStat(hero, 3, -1); end; --ХРАНИТЕЛЬ ТАЙНОГО
--  if skill == 78 then ChangeLevel(hero, -5); Skill1_78 = 0; end;
  if skill == 140 or skill == 219 then RevelationDel1(hero); end;
  if skill == 20 and ScoutingEnable1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 20 and ScoutingEnable1 == 0 and HasHeroSkill(hero, 112)  == nil and ReturnSkillPlayer1 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
  if skill == 112 and DisguiseEnable1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 112 and DisguiseEnable1 == 0 and HasHeroSkill(hero, 20)  == nil and ReturnSkillPlayer1 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
--  if skill == 168 and SnatchUse1 == 1 then ReturnSkillPlayer1 = 1; end;
--  if skill == 168 and SnatchUse1 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED); end;
  if skill == 102 and HeraldUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 102 and HeraldUse1 == 0 and ReturnSkillPlayer1 == 0 then HeraldUse1 = 2; end; -- ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED); end;
  if skill == 81 then ChangeHeroStat(hero, 3, 2); end; --ChangeHeroStat(hero, 4, -2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, 2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
  if (skill == 3 or skill == 183) and ReturnSkillPlayer1 == 0 then Learning1(hero) end;
  if ReturnSkillPlayer1 == 0 then ArrayStatHero(hero); end;
end;

function RemoveSkill2(hero, skill)
  sleep(1);
  Disconnect_SkillPlayer2 = Disconnect_SkillPlayer2 .. ' -' .. skill

  ControlStatHero(hero, skill, 0);
  sleep(1);
  if skill == 129 and SpoilsUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 16 and AvengerUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 17 and minikUse2 > 0 then ReturnSkillPlayer2 = 1; end;
  if skill == 29 and EstatesDiscountUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 29 and EstatesDiscountUse2 == 0 and ReturnSkillPlayer2 == 0 then EstatesEnable2 = 0; end; -- ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED); end;
  if skill == 33 and FortunateAdventureEnable2 ~= 0 then ReturnSkillPlayer2 = 1; end;
  if skill == 33 and FortunateAdventureEnable2 == 0 and ReturnSkillPlayer2 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED); end; --SetObjectEnabled('lavka2',  true); Trigger( OBJECT_TOUCH_TRIGGER, 'lavka2', 'no' ); end;
--  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_TRAINING_GROUNDS) > 0 then ReturnSkillPlayer2 = 1; end;
  if skill == 152 and RunesChangeUse2 > 0 then ReturnSkillPlayer2 = 1; end;
  if skill == 1 then DelLogistics2(hero); if LogisticsNoMoney2 == 1 then ReturnSkillPlayer2 = 1; end; end;
  if skill == 21 and NavUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 131 then ChangeHeroStat(hero, 2, 2); end;
--  if skill == 141 then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, 1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, -1); end;
  if skill == 186 then ChangeHeroStat(hero, 2, 1); end;
  if skill == 185 then ChangeHeroStat(hero, 4, -2); end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) <  1 then SetTownBuildingLimitLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0); end;
  if skill == 110 or skill == 137 then GraalVision(hero, -1); end;
--  if skill == 169 then ChangeLevel(hero, -10); end;
  if skill == 71 and ReturnSkillPlayer2 == 0 then RemoveDarkRitual2(hero); end;
--  if skill == 87 then ChangeHeroStat(hero, 3, -1); end; --ХРАНИТЕЛЬ ТАЙНОГО
--  if skill == 78 then ChangeLevel(hero, -5); Skill2_78 = 0; end;
  if skill == 140 or skill == 219 then RevelationDel2(hero); end;
  if skill == 20 and ScoutingEnable2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 20 and ScoutingEnable2 == 0 and HasHeroSkill(hero, 112)  == nil and ReturnSkillPlayer2 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
  if skill == 112 and DisguiseEnable2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 112 and DisguiseEnable2 == 0 and HasHeroSkill(hero, 20)  == nil and ReturnSkillPlayer2 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
--  if skill == 168 and SnatchUse2 == 1 then ReturnSkillPlayer2 = 1; end;
--  if skill == 168 and SnatchUse2 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED); end;
  if skill == 102 and HeraldUse2 == 1 then ReturnSkillPlayer2 = 1; end; --ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED); end;
  if skill == 102 and HeraldUse2 == 0 and ReturnSkillPlayer2 == 0 then HeraldUse2 = 2; end; --ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED); end;
  if skill == 81 then ChangeHeroStat(hero, 3, 2); end; --ChangeHeroStat(hero, 4, -2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, 2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
  if (skill == 3 or skill == 183) and ReturnSkillPlayer2 == 0 then Learning2(hero) end;
  if ReturnSkillPlayer2 == 0 then ArrayStatHero(hero); end;
end;



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

probel= " ";

function ControlStatHero(hero, skill, add)
  if GetObjectOwner(hero) == 1 and add == 1 then
    if skill == 115 then arrayStatHero[1][1] = arrayStatHero[1][1] + 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[1][2] = arrayStatHero[1][2] + 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[1][3] = arrayStatHero[1][3] + 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[1][4] = arrayStatHero[1][4] + 2; end;
    if skill == 101 then arrayStatHero[1][4] = arrayStatHero[1][4] + 1; end;
    sumPrev = arrayStatHero[1][1] + arrayStatHero[1][2] + arrayStatHero[1][3] + arrayStatHero[1][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
--    print(sumPrev);
--    print(sumNow);
    if (sumNow > (sumPrev + 1)) and (GetHeroLevel(hero) > arrayStatHero[1][5]) then
      arrayUpStat = { 0, 0, 0, 0, 0};
      for i = 1, 4 do
        if GetHeroStat(hero, i) > arrayStatHero[1][i] then
          arrayUpStat[i] = arrayStatHero[1][i] - GetHeroStat(hero, i);
        end;
      end;
      ChangeHeroStat(hero, 1, arrayStatHero[1][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[1][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[1][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[1][4] - GetHeroStat(hero, 4));
      rnd = random(4) + 1;
      while arrayUpStat[rnd] == 0 do
        rnd = random(4) + 1;
      end;
      ChangeHeroStat(hero, rnd, 1);
    end;
--    print(skill);

    if (sumNow > sumPrev) and (GetHeroLevel(hero) == arrayStatHero[1][5]) then
      ChangeHeroStat(hero, 1, arrayStatHero[1][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[1][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[1][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[1][4] - GetHeroStat(hero, 4));
    end;
--    sumNow1  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
--    print(sumNow);
--    print(GetHeroLevel(hero), probel, skill, probel,  arrayStatHero[1][1], probel,  arrayStatHero[1][2], probel,  arrayStatHero[1][3], probel,  arrayStatHero[1][4]);
--    print(GetHeroLevel(hero), probel, skill, probel, GetHeroStat(hero, 1), probel, GetHeroStat(hero, 2), probel, GetHeroStat(hero, 3), probel, GetHeroStat(hero, 4));
  end;
  if GetObjectOwner(hero) == 2 and add == 1 then
    if skill == 115 then arrayStatHero[2][1] = arrayStatHero[2][1] + 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[2][2] = arrayStatHero[2][2] + 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[2][3] = arrayStatHero[2][3] + 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[2][4] = arrayStatHero[2][4] + 2; end;
    if skill == 101 then arrayStatHero[2][4] = arrayStatHero[2][4] + 1; end;
    sumPrev = arrayStatHero[2][1] + arrayStatHero[2][2] + arrayStatHero[2][3] + arrayStatHero[2][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4));
--    print(sumPrev);
--    print(sumNow);
    if (sumNow > (sumPrev + 1)) and (GetHeroLevel(hero) > arrayStatHero[2][5]) then
      arrayUpStat = { 0, 0, 0, 0, 0};
      for i = 1, 4 do
        if GetHeroStat(hero, i) > arrayStatHero[2][i] then
          arrayUpStat[i] = arrayStatHero[2][i] - GetHeroStat(hero, i);
        end;
      end;
      ChangeHeroStat(hero, 1, arrayStatHero[2][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[2][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[2][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[2][4] - GetHeroStat(hero, 4));
      rnd = random(4) + 1;
      while arrayUpStat[rnd] == 0 do
        rnd = random(4) + 1;
      end;
      ChangeHeroStat(hero, rnd, 1);
    end;
--    print(skill);

    if (sumNow > sumPrev) and (GetHeroLevel(hero) == arrayStatHero[2][5]) then
      ChangeHeroStat(hero, 1, arrayStatHero[2][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[2][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[2][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[2][4] - GetHeroStat(hero, 4));
    end;
--    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
--    print(sumNow);
--    print(GetHeroLevel(hero), probel, skill, probel,  arrayStatHero[2][1], probel,  arrayStatHero[2][2], probel,  arrayStatHero[2][3], probel,  arrayStatHero[2][4]);
--    print(GetHeroLevel(hero), probel, skill, probel, GetHeroStat(hero, 1), probel, GetHeroStat(hero, 2), probel, GetHeroStat(hero, 3), probel, GetHeroStat(hero, 4));
  end;

  if GetObjectOwner(hero) == 1 and add == 0 then
    if skill == 115 then arrayStatHero[1][1] = arrayStatHero[1][1] - 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[1][2] = arrayStatHero[1][2] - 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[1][3] = arrayStatHero[1][3] - 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[1][4] = arrayStatHero[1][4] - 2; end;
    if skill == 101 then arrayStatHero[1][4] = arrayStatHero[1][4] - 1; end;
    sumPrev = arrayStatHero[1][1] + arrayStatHero[1][2] + arrayStatHero[1][3] + arrayStatHero[1][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
    if sumNow < sumPrev then
      ChangeHeroStat(hero, 1, arrayStatHero[1][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[1][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[1][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[1][4] - GetHeroStat(hero, 4));
    end;
  end;

  if GetObjectOwner(hero) == 2 and add == 0 then
    if skill == 115 then arrayStatHero[2][1] = arrayStatHero[2][1] - 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[2][2] = arrayStatHero[2][2] - 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[2][3] = arrayStatHero[2][3] - 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[2][4] = arrayStatHero[2][4] - 2; end;
    if skill == 101 then arrayStatHero[2][4] = arrayStatHero[2][4] - 1; end;
    sumPrev = arrayStatHero[2][1] + arrayStatHero[2][2] + arrayStatHero[2][3] + arrayStatHero[2][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
    if sumNow < sumPrev then
      ChangeHeroStat(hero, 1, arrayStatHero[2][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[2][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[2][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[2][4] - GetHeroStat(hero, 4));
    end;
  end;
end;


array_skills_H1 = {}
array_skills_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_H1 = {}
array_perks_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}


array_skills_H2 = {}
array_skills_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_H2 = {}
array_perks_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}


function ArraySkill1()
  j = 1;
  array_skills_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  array_perks_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  for i = 1, 26 do
    if i == 3 and getrace(HeroMax1) == 8 then i = 4; end;
    array_skills_H1[i] = GetHeroSkillMastery(HeroMax1, array_skills[i]);
  end;
  for i = 1, 194 do
    if HasHeroSkill( HeroMax1, array_perks[i]) then
      array_perks_H1[j] = array_perks[i];
      j = j + 1;
      kol_perks_H1 = j;
    end;
  end;
  expH1 = GetHeroStat(HeroMax1, STAT_EXPERIENCE);
  GoldPlayer1 = GetPlayerResource (PLAYER_1, GOLD);
end;

function ArraySkill2()
  j = 1;
  array_skills_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  array_perks_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  for i = 1, 26 do
    if i == 3 and getrace(HeroMax2) == 8 then i = 4; end;
    array_skills_H2[i] = GetHeroSkillMastery(HeroMax2, array_skills[i]);
  end;
  for i = 1, 194 do
    if HasHeroSkill( HeroMax2, array_perks[i]) then
      array_perks_H2[j] = array_perks[i];
      j = j + 1;
      kol_perks_H2 = j;
    end;
  end;
  expH2 = GetHeroStat(HeroMax2, STAT_EXPERIENCE);
  GoldPlayer2 = GetPlayerResource (PLAYER_2, GOLD);
end;


function ReturnSkill1(heroX)
  SetPlayerResource (PLAYER_1, GOLD, GoldPlayer1);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroX, 'no');
  Trigger( HERO_REMOVE_SKILL_TRIGGER, heroX, 'no');

  attH1 = GetHeroStat(heroX, STAT_ATTACK);
  defH1 = GetHeroStat(heroX, STAT_DEFENCE);
  spH1  = GetHeroStat(heroX, STAT_SPELL_POWER);
  knH1  = GetHeroStat(heroX, STAT_KNOWLEDGE);
  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(heroX, array_arts[i][j].id, 0) then
        array_arts_Hero1[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(heroX, array_arts[i][j].id, 1) then
        array_arts_Hero1[k - 1].Eq = 1;
        RemoveArtefact(heroX, array_arts[i][j].id);
      end;
    end;
  end;
  sleep(1);
  DELTAattH1 = attH1 - GetHeroStat(heroX, STAT_ATTACK);
  DELTAdefH1 = defH1 - GetHeroStat(heroX, STAT_DEFENCE);
  DELTAspH1  = spH1 - GetHeroStat(heroX, STAT_SPELL_POWER);
  DELTAknH1  = knH1 - GetHeroStat(heroX, STAT_KNOWLEDGE);

  TakeAwayHeroExp(heroX, expH1 - 1);
  WarpHeroExp(heroX, expH1);
  TakeAwayHeroExp(heroX, expH1 - 1);
  WarpHeroExp(heroX, expH1);
  for i = 1, 26 do
    for j = 1, array_skills_H1[i] do
      if array_skills_H1[i] >= j then
        if GetHeroSkillMastery(heroX, array_skills[i]) < array_skills_H1[i] then
          GiveHeroSkill(heroX, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_H1 do
    GiveHeroSkill(heroX, array_perks_H1[i]);
  end;
--  k = 0;
--  for i = 1, 189 do
--    if HasHeroSkill( heroX, array_perks[i]) then
--      k = k + 1;
--    end;
--  end;
--  while k < kol_perks_H1 do
    for i = 1, 5 do
      if HasHeroSkill( heroX, array_perks_H1[i]) == nil then
        GiveHeroSkill(heroX, array_perks_H1[i]);
--        k = k + 1;
      end;
    end;
--  end;
  ChangeHeroStat(heroX, STAT_ATTACK, 5);
  ChangeHeroStat(heroX, STAT_DEFENCE, 5);
  ChangeHeroStat(heroX, STAT_SPELL_POWER, 5);
  ChangeHeroStat(heroX, STAT_KNOWLEDGE, 5);

--  ChangeHeroStat(heroX, STAT_ATTACK, attH1 - GetHeroStat(heroX, STAT_ATTACK));
--  ChangeHeroStat(heroX, STAT_DEFENCE, defH1 - GetHeroStat(heroX, STAT_DEFENCE));
--  ChangeHeroStat(heroX, STAT_SPELL_POWER, spH1 - GetHeroStat(heroX, STAT_SPELL_POWER));
--  ChangeHeroStat(heroX, STAT_KNOWLEDGE, knH1 - GetHeroStat(heroX, STAT_KNOWLEDGE));

  ChangeHeroStat(heroX, STAT_ATTACK, STARTattH1 - GetHeroStat(heroX, STAT_ATTACK) - DELTAattH1);
  ChangeHeroStat(heroX, STAT_DEFENCE, STARTdefH1 - GetHeroStat(heroX, STAT_DEFENCE) - DELTAdefH1);
  ChangeHeroStat(heroX, STAT_SPELL_POWER, STARTspH1 - GetHeroStat(heroX, STAT_SPELL_POWER) - DELTAspH1);
  ChangeHeroStat(heroX, STAT_KNOWLEDGE, STARTknH1 - GetHeroStat(heroX, STAT_KNOWLEDGE) - DELTAknH1);
  
  for i = 1, length(array_arts_Hero1) do
    if array_arts_Hero1[i].ID ~= 0 and array_arts_Hero1[i].Eq == 1 then
      GiveArtefact(heroX, array_arts_Hero1[i].ID);
    end;
  end;

  array_arts_Hero1 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

  ReturnSkillPlayer1 = 0;
  sleep(1);
  LearningLvl1 = GetHeroSkillMastery(heroX, 3);
  ArrayStatHero(heroX);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroX, 'MentorAddSkill1');
--15.03.20  DT_use1 = DT_use1prev;
end;

function ReturnSkill2(heroXX)
  SetPlayerResource (PLAYER_2, GOLD, GoldPlayer2);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroXX, 'no');
  Trigger( HERO_REMOVE_SKILL_TRIGGER, heroXX, 'no');

  attH2 = GetHeroStat(heroXX, STAT_ATTACK);
  defH2 = GetHeroStat(heroXX, STAT_DEFENCE);
  spH2  = GetHeroStat(heroXX, STAT_SPELL_POWER);
  knH2  = GetHeroStat(heroXX, STAT_KNOWLEDGE);
  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(heroXX, array_arts[i][j].id, 0) then
        array_arts_Hero2[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(heroXX, array_arts[i][j].id, 1) then
        array_arts_Hero2[k - 1].Eq = 1;
        RemoveArtefact(heroXX, array_arts[i][j].id);
      end;
    end;
  end;
  sleep(1);
  DELTAattH2 = attH2 - GetHeroStat(HeroMax2, STAT_ATTACK);
  DELTAdefH2 = defH2 - GetHeroStat(HeroMax2, STAT_DEFENCE);
  DELTAspH2  = spH2  - GetHeroStat(HeroMax2, STAT_SPELL_POWER);
  DELTAknH2  = knH2  - GetHeroStat(HeroMax2, STAT_KNOWLEDGE);

  TakeAwayHeroExp(heroXX, expH2 - 1);
  WarpHeroExp(heroXX, expH2);
  TakeAwayHeroExp(heroXX, expH2 - 1);
  WarpHeroExp(heroXX, expH2);
  for i = 1, 26 do
    for j = 1, array_skills_H2[i] do
      if array_skills_H2[i] >= j then
        if GetHeroSkillMastery(heroXX, array_skills[i]) < array_skills_H2[i] then
          GiveHeroSkill(heroXX, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_H2 do
    GiveHeroSkill(heroXX, array_perks_H2[i]);
  end;
--  k = 0;
--  for i = 1, 189 do
--    if HasHeroSkill( heroXX, array_perks[i]) then
--      k = k + 1;
--    end;
--  end;
--  while k < kol_perks_H2 do
    for i = 1, 5 do
      if HasHeroSkill( heroXX, array_perks_H2[i]) == nil then
        GiveHeroSkill(heroXX, array_perks_H2[i]);
--        k = k + 1;
      end;
    end;
--  end;
  ChangeHeroStat(heroXX, STAT_ATTACK, 5);
  ChangeHeroStat(heroXX, STAT_DEFENCE, 5);
  ChangeHeroStat(heroXX, STAT_SPELL_POWER, 5);
  ChangeHeroStat(heroXX, STAT_KNOWLEDGE, 5);

--  ChangeHeroStat(heroX, STAT_ATTACK, attH1 - GetHeroStat(heroX, STAT_ATTACK));
--  ChangeHeroStat(heroX, STAT_DEFENCE, defH1 - GetHeroStat(heroX, STAT_DEFENCE));
--  ChangeHeroStat(heroX, STAT_SPELL_POWER, spH1 - GetHeroStat(heroX, STAT_SPELL_POWER));
--  ChangeHeroStat(heroX, STAT_KNOWLEDGE, knH1 - GetHeroStat(heroX, STAT_KNOWLEDGE));

  ChangeHeroStat(heroXX, STAT_ATTACK, STARTattH2 - GetHeroStat(heroXX, STAT_ATTACK) - DELTAattH2);
  ChangeHeroStat(heroXX, STAT_DEFENCE, STARTdefH2 - GetHeroStat(heroXX, STAT_DEFENCE) - DELTAdefH2);
  ChangeHeroStat(heroXX, STAT_SPELL_POWER, STARTspH2 - GetHeroStat(heroXX, STAT_SPELL_POWER) - DELTAspH2);
  ChangeHeroStat(heroXX, STAT_KNOWLEDGE, STARTknH2 - GetHeroStat(heroXX, STAT_KNOWLEDGE) - DELTAknH2);

  for i = 1, length(array_arts_Hero2) do
    if array_arts_Hero2[i].ID ~= 0 and array_arts_Hero2[i].Eq == 1 then
      GiveArtefact(heroXX, array_arts_Hero2[i].ID);
    end;
  end;

  array_arts_Hero2 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

  ReturnSkillPlayer2 = 0;
  sleep(1);
  LearningLvl2 = GetHeroSkillMastery(heroXX, 3);
  ArrayStatHero(heroXX);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroXX, 'MentorAddSkill2');
--15.03.20  DT_use2 = DT_use2prev;
end;










function ResetExp1()

  if FortunateAdventureEnable1 == 0 and EstatesUse1 == 0 and SpoilsUse1 == 0 and ScoutingEnable1 == 0 and DisguiseEnable1 == 0 and SnatchUse1 == 0 and HeraldUse1 == 0 and RunesChangeUse1 == 0 then
  if (GetPlayerResource( PLAYER_1, 6) >= ResetExpPrice1) then
    Trigger( HERO_REMOVE_SKILL_TRIGGER, heroReset1, 'RemoveSkill1');
    Trigger( HERO_ADD_SKILL_TRIGGER,    heroReset1, 'MentorAddSkill1');

--    ResetExpAndDelLearning1 = 1;

    j = 1;
    for i = 1, length(array_arts[0]) do
      if HasArtefact   (heroReset1, array_arts[0][i].id) then
        RemoveArtefact (heroReset1, array_arts[0][i].id);
        artHero1[j] = array_arts[0][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[1]) do
      if HasArtefact   (heroReset1, array_arts[1][i].id) then
        RemoveArtefact (heroReset1, array_arts[1][i].id);
        artHero1[j] = array_arts[1][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[2]) do
      if HasArtefact   (heroReset1, array_arts[2][i].id) then
        RemoveArtefact (heroReset1, array_arts[2][i].id);
        artHero1[j] = array_arts[2][i].id;
        j = j + 1;
      end;
    end;
    ExpHero = GetHeroStat(heroReset1, STAT_EXPERIENCE);
    TakeAwayHeroExp(heroReset1, ExpHero);
    sleep(1);
    for i = 1, 5 do                 -- в цик
      ChangeHeroStat (heroReset1, STAT_ATTACK,      basicA[hero1race] - GetHeroStat(heroReset1, STAT_ATTACK));
      ChangeHeroStat (heroReset1, STAT_DEFENCE,     basicD[hero1race] - GetHeroStat(heroReset1, STAT_DEFENCE));
      ChangeHeroStat (heroReset1, STAT_SPELL_POWER, basicS[hero1race] - GetHeroStat(heroReset1, STAT_SPELL_POWER));
      ChangeHeroStat (heroReset1, STAT_KNOWLEDGE,   basicK[hero1race] - GetHeroStat(heroReset1, STAT_KNOWLEDGE));
    end;
    sleep(1);
    ArrayStatHero(heroReset1);
    ChangeHeroStat (heroReset1, STAT_EXPERIENCE, ExpHero);
    resetExpHero1 = 1;
--    ResetExpAndDelLearning1 = 0;
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - ResetExpPrice1));
    for i = 1, 7 do
      GiveArtefact   (heroReset1, artHero1[i]);
    end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
  end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NoForgetSkills.txt" );
  end;
end;

function ResetExp2()

  if FortunateAdventureEnable2 == 0 and EstatesUse2 == 0 and SpoilsUse2 == 0 and ScoutingEnable2 == 0 and DisguiseEnable2 == 0 and SnatchUse2 == 0 and HeraldUse2 == 0 and RunesResetUse2 == 0 then
  if (GetPlayerResource( PLAYER_2, 6) >= ResetExpPrice2) then
    Trigger( HERO_REMOVE_SKILL_TRIGGER, heroReset2, 'RemoveSkill2');
    Trigger( HERO_ADD_SKILL_TRIGGER,    heroReset2, 'MentorAddSkill2');

--    ResetExpAndDelLearning2 = 1;

    j = 1;
    for i = 1, length(array_arts[0]) do
      if HasArtefact   (heroReset2, array_arts[0][i].id) then
        RemoveArtefact (heroReset2, array_arts[0][i].id);
        artHero2[j] = array_arts[0][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[1]) do
      if HasArtefact   (heroReset2, array_arts[1][i].id) then
        RemoveArtefact (heroReset2, array_arts[1][i].id);
        artHero2[j] = array_arts[1][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[2]) do
      if HasArtefact   (heroReset2, array_arts[2][i].id) then
        RemoveArtefact (heroReset2, array_arts[2][i].id);
        artHero2[j] = array_arts[2][i].id;
        j = j + 1;
      end;
    end;
    ExpHero = GetHeroStat(heroReset2, STAT_EXPERIENCE);
    TakeAwayHeroExp(heroReset2, ExpHero);
    ChangeHeroStat (heroReset2, STAT_ATTACK,      basicA[hero2race] - GetHeroStat(heroReset2, STAT_ATTACK));
    ChangeHeroStat (heroReset2, STAT_DEFENCE,     basicD[hero2race] - GetHeroStat(heroReset2, STAT_DEFENCE));
    ChangeHeroStat (heroReset2, STAT_SPELL_POWER, basicS[hero2race] - GetHeroStat(heroReset2, STAT_SPELL_POWER));
    ChangeHeroStat (heroReset2, STAT_KNOWLEDGE,   basicK[hero2race] - GetHeroStat(heroReset2, STAT_KNOWLEDGE));
    ArrayStatHero(heroReset2);
    ChangeHeroStat (heroReset2, STAT_EXPERIENCE, ExpHero);
    resetExpHero2 = 1;
--    ResetExpAndDelLearning2 = 0;
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - ResetExpPrice2));
    for i = 1, 7 do
      GiveArtefact   (heroReset2, artHero2[i]);
    end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
  end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NoForgetSkills.txt" );
  end;
end;


function ReturnGold1(hero, skill)
  AddSkill1(hero, skill);
  SetPlayerResource( 1, GOLD, GoldPl1);
  SetObjectEnabled('mentor1', nil);
  ShowFlyingSign({GetMapDataPath().."MentorBalance.txt"; eq = price1}, HeroMax1, 1, 5.0);
--  Trigger( OBJECT_TOUCH_TRIGGER, 'mentor1', 'mentor1price' );
end;

function ReturnGold2(hero, skill)
  AddSkill2(hero, skill);
  SetPlayerResource( 2, GOLD, GoldPl2);
  SetObjectEnabled('mentor2', nil);
  ShowFlyingSign({GetMapDataPath().."MentorBalance.txt"; eq = price2}, HeroMax2, 2, 5.0);
--  Trigger( OBJECT_TOUCH_TRIGGER, 'mentor2', 'mentor2price' );
end;


function mentor1price(hero)
  if price1 <= GetPlayerResource (PLAYER_1, GOLD) then
    SetObjectEnabled('mentor1', true);
    Trigger( OBJECT_TOUCH_TRIGGER, 'mentor1', 'mentor1' );
    MakeHeroInteractWithObject (hero, 'mentor1');
  else
    ShowFlyingSign({GetMapDataPath().."MentorBalance.txt"; eq = price1}, HeroMax1, 1, 2.0);
  end;
end;

function mentor2price(hero)
  if price2 <= GetPlayerResource (PLAYER_2, GOLD) then
    SetObjectEnabled('mentor2', true);
    Trigger( OBJECT_TOUCH_TRIGGER, 'mentor2', 'mentor2' );
    MakeHeroInteractWithObject (hero, 'mentor2');
  else
    ShowFlyingSign({GetMapDataPath().."MentorBalance.txt"; eq = price2}, HeroMax2, 2, 2.0);
  end;
end;






--------------------------------- SPELL NABOR ----------------------------------

Trigger (OBJECT_TOUCH_TRIGGER, 'spell_nabor1', 'AskForSpellReset1');
Trigger (OBJECT_TOUCH_TRIGGER, 'spell_nabor2', 'AskForSpellReset2');
SpellResetUse1 = 0;
SpellResetUse2 = 0;
RunesChangeUse1 = 0;
RunesChangeUse2 = 0;
RunesResetUse1 = 0;
RunesResetUse2 = 0;
SpellResetCostTotal1 = 0;
SpellResetCostTotal2 = 0;
RunesResetCostTotal1 = 0;
RunesResetCostTotal2 = 0;

function AskForSpellReset1 ()
  if hero1race < 7 and SpellResetUse1 == 0 then
    SpellResetCostTotal1 = SpellResetCost;
    if (GetPlayerResource (PLAYER_1, GOLD) >= SpellResetCostTotal1) then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."SpellSet.txt"; eq = SpellResetCostTotal1}, 'SpSet1', 'no');
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal1});
    end;
  elseif hero1race == 7 and SpellResetUse1 == 0 then
    SpellResetCostTotal1 = SpellResetCost;
    RunesResetCostTotal1 = RunesResetCost;
    if (GetPlayerResource (PLAYER_1, GOLD) >= RunesResetCostTotal1) then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."SpellSet.txt"; eq = SpellResetCostTotal1}, 'SpSet1', 'AskForRunesReset11');
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal1}, 'AskForRunesReset11');
    end;
  else
    if SpellResetUse1 == 0 then
      SpellResetCostTotal1 = SpellResetCostOrc;
      if (GetPlayerResource (PLAYER_1, GOLD) >= SpellResetCostTotal1) then
        QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."SpellSet.txt"; eq = SpellResetCostTotal1}, 'SpSet1', 'no');
      else
        MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal1});
      end;
    end;
  end;
  if SpellResetUse1 == 1 or SpellResetUse1 == 2 then
    if hero1race ~= 7 then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."SpellReset.txt", 'SpellPositionSecondSet1', 'no');
    else
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."SpellReset.txt", 'SpellPositionSecondSet1', 'AskForRunesReset11');
    end;
  end;
end;


function AskForRunesReset11 ()
  if (RunesResetUse1 == 0) then
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."RunesReset.txt"; eq = RunesResetCostTotal1}, 'RuneSet1', 'no'); -- 'AskForRunesReset12');  АКТИВАЦИЯ ЗАМЕНЫ ОДНОЙ РУНЫ
  else
--    AskForRunesReset12(); АКТИВАЦИЯ ЗАМЕНЫ ОДНОЙ РУНЫ
  end;
-- возврат рун не работает, баг
--  if (RunesResetUse1 == 1 or RunesResetUse1 == 2) then
--    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."RunesReturn.txt", 'RunesPositionSecondSet1', 'no'); --'AskForRunesReset12');  АКТИВАЦИЯ ЗАМЕНЫ ОДНОЙ РУНЫ
--  end;
end;

function AskForRunesReset12 ()
  if (HasHeroSkill(HeroMax1, 152) and GetHeroStat (HeroMax1, STAT_EXPERIENCE) > 5000) and RunesChangeUse1 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."RunesSet.txt", 'RuneChangeQ1', 'no');
  end;
end;

function SpSet1 ()
  if (GetPlayerResource (PLAYER_1, GOLD) >= SpellResetCostTotal1) then
    if SpellResetUse1 == 0 then
      SpellResetUse1 = 1;
      ResetSpell (0);
--      Stop (heroes1[0]);
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - SpellResetCostTotal1));
    end;
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal1});
  end;
end;

function RuneSet1 ()
  if (GetPlayerResource (PLAYER_1, GOLD) >= RunesResetCostTotal1) then
    if RunesResetUse1 == 0 then
      RunesResetUse1 = 1;
--      RuneChangeQ1(1);
      ResetRunes (0);
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - RunesResetCostTotal1));
    end;
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = RunesResetCostTotal1});
  end;
end;

function AskForSpellReset2 ()
  if hero2race < 7 and SpellResetUse2 == 0 then
    SpellResetCostTotal2 = SpellResetCost;
    if (GetPlayerResource (PLAYER_2, GOLD) >= SpellResetCostTotal2) then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."SpellSet.txt"; eq = SpellResetCostTotal2}, 'SpSet2', 'no');
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal2});
    end;
  elseif hero2race == 7 and SpellResetUse2 == 0 then
    SpellResetCostTotal2 = SpellResetCost;
    RunesResetCostTotal2 = RunesResetCost;
    if (GetPlayerResource (PLAYER_2, GOLD) >= RunesResetCostTotal2) then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."SpellSet.txt"; eq = SpellResetCostTotal2}, 'SpSet2', 'AskForRunesReset21');
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal2}, 'AskForRunesReset21');
    end;
  else
    if SpellResetUse2 == 0 then
      SpellResetCostTotal2 = SpellResetCostOrc;
      if (GetPlayerResource (PLAYER_2, GOLD) >= SpellResetCostTotal2) then
        QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."SpellSet.txt"; eq = SpellResetCostTotal2}, 'SpSet2', 'no');
      else
        MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal2});
      end;
    end;
  end;
  if SpellResetUse2 == 1 or SpellResetUse2 == 2 then
    if hero2race ~= 7 then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."SpellReset.txt", 'SpellPositionSecondSet2', 'no');
    else
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."SpellReset.txt", 'SpellPositionSecondSet2', 'AskForRunesReset21');
    end;
  end;
end;

function AskForRunesReset21()
  if (RunesResetUse2 == 0) then
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."RunesReset.txt"; eq = RunesResetCostTotal2}, 'RuneSet2', 'no'); -- 'AskForRunesReset22'); АКТИВАЦИЯ ЗАМЕНЫ ОДНОЙ РУНЫ
  else
--    AskForRunesReset22();  АКТИВАЦИЯ ЗАМЕНЫ ОДНОЙ РУНЫ
  end;
-- возврат рун не работает, баг
--  if (RunesResetUse2 == 1 or RunesResetUse2 == 2) then
--    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."RunesReturn.txt", 'RunesPositionSecondSet2', 'no'); --'AskForRunesReset22'); АКТИВАЦИЯ ЗАМЕНЫ ОДНОЙ РУНЫ
--  end;
end;

function AskForRunesReset22()
  if (HasHeroSkill(HeroMax2, 152) and GetHeroStat (HeroMax2, STAT_EXPERIENCE) > 5000) and RunesChangeUse2 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."RunesSet.txt", 'RuneChangeQ1', 'no');
  end;
end;


function SpSet2 ()
  if (GetPlayerResource (PLAYER_2, GOLD) >= SpellResetCostTotal2) then
    if SpellResetUse2 == 0 then
      SpellResetUse2 = 1;
      ResetSpell (1);
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - SpellResetCostTotal2));
    end;
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = SpellResetCostTotal2});
  end;
end;

function RuneSet2 ()
  if (GetPlayerResource (PLAYER_2, GOLD) >= RunesResetCostTotal2) then
    if RunesResetUse2 == 0 then
      RunesResetUse2 = 1;
--      RuneChangeQ1(1);
      ResetRunes (1);
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - RunesResetCostTotal2));
    end;
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = RunesResetCostTotal2});
  end;
end;

function ResetRunes (place)
  for i = 15, 19 do
    spells[place + 2][i].m  = spells[place][i].m;
    spells[place + 2][i].sp = spells[place][i].sp;
  end;
  for i = 1, 24 do
    if spells[place][i].m == 4 then
      if place == 0 then
        SetObjectPosition (array_spells[spells[place][i].m][spells[place][i].sp].name,  i, 90 - place, UNDERGROUND);
      elseif place == 1 then
        SetObjectPosition (array_spells[spells[place][i].m][spells[place][i].sp].name2, i, 90 - place, UNDERGROUND);
      end;
    end;
  end;
  Rbl = random (5) + 15;
  while (spells[place][Rbl].m ~= 4) or (array_spells[4][spells[place][Rbl].sp].block_temply == 1) do
    Rbl = random (5) + 15;
  end;
  array_spells[4][spells[place][Rbl].sp].block_temply = 1;
  Rbl = random (5) + 15;
  while (spells[place][Rbl].m ~= 4) or (array_spells[4][spells[place][Rbl].sp].block_temply == 1) do
    Rbl = random (5) + 15;
  end;
  array_spells[4][spells[place][Rbl].sp].block_temply = 1;
--  while (spells[place][Rbl].m ~= 4) or (array_spells[4][spells[place][Rbl].sp].block_temply == 1) do
--    Rbl = random (24) + 1;
--  end;
--  array_spells[4][spells[place][Rbl].sp].block_temply = 1;
  RunesGenerate (place);
end;

function RuneChangeQ1(player)
  if player == 1 then
    pl = 1;
    lvl = 1;
    QuestionBoxForPlayers ( 1, GetMapDataPath().."RuneLevel1.txt", 'RuneChange', 'RuneChangeQ2');
  end;
  if player == 2 then
    pl = 2;
    lvl = 1;
    QuestionBoxForPlayers ( 2, GetMapDataPath().."RuneLevel1.txt", 'RuneChange', 'RuneChangeQ2');
  end;
end;

function RuneChangeQ2(player)
  if player == 1 then
    pl = 1;
    lvl = 2;
    QuestionBoxForPlayers ( 1, GetMapDataPath().."RuneLevel2.txt", 'RuneChange', 'RuneChangeQ3');
  end;
  if player == 2 then
    pl = 2;
    lvl = 2;
    QuestionBoxForPlayers ( 2, GetMapDataPath().."RuneLevel2.txt", 'RuneChange', 'RuneChangeQ3');
  end;
end;

function RuneChangeQ3(player)
  if player == 1 then
    pl = 1;
    lvl = 3;
    QuestionBoxForPlayers ( 1, GetMapDataPath().."RuneLevel3.txt", 'RuneChange', 'RuneChangeQ4');
  end;
  if player == 2 then
    pl = 2;
    lvl = 3;
    QuestionBoxForPlayers ( 2, GetMapDataPath().."RuneLevel3.txt", 'RuneChange', 'RuneChangeQ4');
  end;
end;

function RuneChangeQ4(player)
  if player == 1 then
    pl = 1;
    lvl = 4;
    QuestionBoxForPlayers ( 1, GetMapDataPath().."RuneLevel4.txt", 'RuneChange', 'RuneChangeQ5');
  end;
  if player == 2 then
    pl = 2;
    lvl = 4;
    QuestionBoxForPlayers ( 2, GetMapDataPath().."RuneLevel4.txt", 'RuneChange', 'RuneChangeQ5');
  end;
end;

function RuneChangeQ5(player)
  if player == 1 then
    pl = 1;
    lvl = 5;
    QuestionBoxForPlayers ( 1, GetMapDataPath().."RuneLevel5.txt", 'RuneChange', 'no');
  end;
  if player == 2 then
    pl = 2;
    lvl = 5;
    QuestionBoxForPlayers ( 2, GetMapDataPath().."RuneLevel5.txt", 'RuneChange', 'no');
  end;
end;

function RuneChange()
  if lvl > 0 then
    if pl == 1 then
      RunesChangeUse1 = 1;
    end;
    if pl == 2 then
      RunesChangeUse2 = 1;
    end;
    if pl == 1 then SetObjectPosition (array_spells[spells[pl - 1][14 + lvl].m][spells[pl - 1][14 + lvl].sp].name,  1, 90 - pl, UNDERGROUND); end;
    if pl == 2 then SetObjectPosition (array_spells[spells[pl - 1][14 + lvl].m][spells[pl - 1][14 + lvl].sp].name2, 1, 90 - pl, UNDERGROUND); end;
    if frac(spells[pl - 1][14 + lvl].sp / 2) > 0 then
      spells[pl - 1][14 + lvl].sp = spells[pl - 1][14 + lvl].sp + 1;
    else
      spells[pl - 1][14 + lvl].sp = spells[pl - 1][14 + lvl].sp - 1;
    end;
    SpellPosition (4, spells[pl - 1][14 + lvl].sp, 14 + lvl, pl - 1);
  end;
end;

function ResetSpell (place)
  for i = 1, 24 do
    spells[place + 2][i].m  = spells[place][i].m;
    spells[place + 2][i].sp = spells[place][i].sp;
  end;
  for i = 1, 24 do
    if spells[place][i].sp ~= 0 and spells[place][i].m ~= 4 then
      if place == 0 then
        SetObjectPosition (array_spells[spells[place][i].m][spells[place][i].sp].name,  i, 90 - place, UNDERGROUND);
      elseif place == 1 then
        SetObjectPosition (array_spells[spells[place][i].m][spells[place][i].sp].name2, i, 90 - place, UNDERGROUND);
      end;
    end;
  end;
  if place == 0 then
--    if AddSpells == 1 then m31 = RandomMagic (hero1race); end;
--    if AddSpells == 0 then
    m31 = -1;-- end;
    if hero1race == 5 then m21 = RandomMagic (hero1race); end;

    --1.99b
    if hero1race ~= 8 then
      if m11 == 0 then
        Rbl1 = random (4) + 1;
      else
        Rbl1 = random (5) + 1;
      end;
      while CheckSpells (m11, spells[0][Rbl1].sp, 0) == 0 do
        if m11 == 0 then
          Rbl1 = random (4) + 1;
        else
          Rbl1 = random (5) + 1;
        end;
      end;
      array_spells[m11][spells[0][Rbl1].sp].block_temply = 1;
      if m11 == 0 then
        Rbl2 = random (4) + 1;
      else
        Rbl2 = random (5) + 1;
      end;
      while (Rbl2 == Rbl1) or (CheckSpells (m11, spells[0][Rbl2].sp, 0) == 0) do
        if m11 == 0 then
          Rbl2 = random (4) + 1;
        else
          Rbl2 = random (5) + 1;
        end;
      end;
      array_spells[m11][spells[0][Rbl2].sp].block_temply = 1;
      if m11 ~= 0 then
        Rbl3 = random (5) + 1;
        while (Rbl3 == Rbl1) or (Rbl3 == Rbl2) or (CheckSpells (m11, spells[0][Rbl3].sp, 0) == 0) do
          Rbl3 = random (5) + 1;
        end;
        array_spells[m11][spells[0][Rbl3].sp].block_temply = 1;
      end;
      if (hero1race ~= 5) or (hero1race == 5 and spells[0][6].m == m21) then
        if m21 == 0 then
          Rbl1 = random (4) + 1;
        else
          Rbl1 = random (5) + 1;
        end;
        while CheckSpells (m21, spells[0][5+Rbl1].sp, 0) == 0 do
          if m21 == 0 then
            Rbl1 = random (4) + 1;
          else
            Rbl1 = random (5) + 1;
          end;
        end;
        array_spells[m21][spells[0][5+Rbl1].sp].block_temply = 1;
        if m21 == 0 then
          Rbl2 = random (4) + 1;
        else
          Rbl2 = random (5) + 1;
        end;
        while (Rbl2 == Rbl1) or CheckSpells (m21, spells[0][5+Rbl2].sp, 0) == 0 do
          if m21 == 0 then
            Rbl2 = random (4) + 1;
          else
            Rbl2 = random (5) + 1;
          end;
        end;
        array_spells[m21][spells[0][5+Rbl2].sp].block_temply = 1;
        if m21 ~= 0 then
          Rbl3 = random (5) + 1;
          while (Rbl3 == Rbl1) or (Rbl3 == Rbl2) or (CheckSpells (m21, spells[0][5+Rbl3].sp, 0) == 0) do
            Rbl3 = random (5) + 1;
          end;
          array_spells[m21][spells[0][5+Rbl3].sp].block_temply = 1;
        end;
      end;
    else
      Rbl1 = random (4) + 3;
      while (spells[0][3].sp ~= Rbl1) and (spells[0][4].sp ~= Rbl1) do
        Rbl1 = random (4) + 3;
      end;
      array_spells[5][Rbl1].block_temply = 1;
    end;

    for i = 1, 24 do
      if spells[0][i].m ~= 4 then
        spells[0][i].m = 0;
        spells[0][i].sp = 0;
      end;
    end;

    SpellGenerate (m11, m21, m31, hero1race, 0);
  end;

  if place == 1 then
--    if AddSpells == 1 then m32 = RandomMagic (hero2race); end;
--    if AddSpells == 0 then
    m32 = -1;-- end;
    if hero2race == 5 then m22 = RandomMagic (hero2race); end;

    --1.99b
    if hero2race ~= 8 then
      if m12 == 0 then
        Rbl1 = random (4) + 1;
      else
        Rbl1 = random (5) + 1;
      end;
      while CheckSpells (m12, spells[1][Rbl1].sp, 1) == 0 do
        if m12 == 0 then
          Rbl1 = random (4) + 1;
        else
          Rbl1 = random (5) + 1;
        end;
      end;
      array_spells[m12][spells[1][Rbl1].sp].block_temply = 1;
      if m12 == 0 then
        Rbl2 = random (4) + 1;
      else
        Rbl2 = random (5) + 1;
      end;
      while (Rbl2 == Rbl1) or (CheckSpells (m12, spells[1][Rbl2].sp, 1) == 0) do
        if m12 == 0 then
          Rbl2 = random (4) + 1;
        else
          Rbl2 = random (5) + 1;
        end;
      end;
      array_spells[m12][spells[1][Rbl2].sp].block_temply = 1;
      if m12 ~= 0 then
        Rbl3 = random (5) + 1;
        while (Rbl3 == Rbl1) or (Rbl3 == Rbl2) or (CheckSpells (m12, spells[1][Rbl3].sp, 1) == 0) do
          Rbl3 = random (5) + 1;
        end;
        array_spells[m12][spells[1][Rbl3].sp].block_temply = 1;
      end;
      if (hero2race ~= 5) or (hero2race == 5 and spells[1][6].m == m22) then
        if m22 == 0 then
          Rbl1 = random (4) + 1;
        else
          Rbl1 = random (5) + 1;
        end;
        while CheckSpells (m22, spells[1][5+Rbl1].sp, 1) == 0 do
          if m22 == 0 then
            Rbl1 = random (4) + 1;
          else
            Rbl1 = random (5) + 1;
          end;
        end;
        array_spells[m22][spells[1][5+Rbl1].sp].block_temply = 1;
        if m22 == 0 then
          Rbl2 = random (4) + 1;
        else
          Rbl2 = random (5) + 1;
        end;
        while (Rbl1 == Rbl2) or (CheckSpells (m22, spells[1][5+Rbl2].sp, 1) == 0) do
          if m22 == 0 then
            Rbl2 = random (4) + 1;
          else
            Rbl2 = random (5) + 1;
          end;
        end;
        array_spells[m22][spells[1][5+Rbl2].sp].block_temply = 1;
        if m22 ~= 0 then
          Rbl3 = random (5) + 1;
          while (Rbl3 == Rbl1) or (Rbl3 == Rbl2) or (CheckSpells (m22, spells[1][5+Rbl3].sp, 1) == 0) do
            Rbl3 = random (5) + 1;
          end;
          array_spells[m22][spells[1][5+Rbl3].sp].block_temply = 1;
        end;
      end;
    else
      Rbl1 = random (4) + 3;
      while (spells[1][3].sp ~= Rbl1) and (spells[1][4].sp ~= Rbl1) do
        Rbl1 = random (4) + 3;
      end;
      array_spells[5][Rbl1].block_temply = 1;
    end;

    for i = 1, 24 do
      if spells[1][i].m ~= 4 then
        spells[1][i].m = 0;
        spells[1][i].sp = 0;
      end;
    end;
    SpellGenerate (m12, m22, m32, hero2race, 1);
  end;
end;

runes = {};
runes[0] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
runes[1] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
runes[2] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
runes[3] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};

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

function CheckSpells (r_magic, r_sp, r_pl)
  CheckSuccess = 1;
  if r_pl == 0 then
    rnd_m1 = rndSpellM1; rnd_sp1 = rndSpellSp1; rnd_m2 = rndSpellM11; rnd_sp2 = rndSpellSp11;
  else
    rnd_m1 = rndSpellM2; rnd_sp1 = rndSpellSp2; rnd_m2 = rndSpellM22; rnd_sp2 = rndSpellSp22;
  end;
  if (r_magic == rnd_m1 or r_magic == rnd_m2) then
    if r_magic == 0 then
      if (r_sp == 4 and (rnd_sp1 == 5 or rnd_sp2 == 5)) or (r_sp == 5 and (rnd_sp1 == 4 or rnd_sp2 == 4))
      or (r_sp == 6 and (rnd_sp1 == 7 or rnd_sp2 == 7)) or (r_sp == 7 and (rnd_sp1 == 6 or rnd_sp2 == 6)) then
        CheckSuccess = 0;
      end;
    elseif r_magic == 1 then
      if (r_sp == 4 and (rnd_sp1 == 5 or rnd_sp2 == 5)) or (r_sp == 5 and (rnd_sp1 == 4 or rnd_sp2 == 4))
      or (r_sp == 6 and (rnd_sp1 == 7 or rnd_sp2 == 7)) or (r_sp == 7 and (rnd_sp1 == 6 or rnd_sp2 == 6)) then
        CheckSuccess = 0;
      end;
    elseif r_magic == 2 then
      if (r_sp == 1 and (rnd_sp1 == 2 or rnd_sp2 == 2)) or (r_sp == 2 and (rnd_sp1 == 1 or rnd_sp2 == 1))
      or (r_sp == 3 and (rnd_sp1 == 4 or rnd_sp2 == 4)) or (r_sp == 4 and (rnd_sp1 == 3 or rnd_sp2 == 3)) then
        CheckSuccess = 0;
      end;
    elseif r_magic == 3 then
      if (r_sp == 4 and (rnd_sp1 == 5 or rnd_sp2 == 5)) or (r_sp == 5 and (rnd_sp1 == 4 or rnd_sp2 == 4))
      or (r_sp == 6 and (rnd_sp1 == 7 or rnd_sp2 == 7)) or (r_sp == 7 and (rnd_sp1 == 6 or rnd_sp2 == 6)) then
        CheckSuccess = 0;
      end;
    end;
  end;
  return CheckSuccess;
end;

function RandomMagic(race)
  rnd = random (100);
  if race == 1 then
    if rnd < 50 then M = 2; end;
    if rnd > 49 then M = 3; end;
  end;
  if race == 2 then M = 3; end;
  if race == 3 then M = 0; end;
  if race == 4 then M = 3; end;
  if race == 5 then
    if rnd < 50 then M = 0; end;
    if rnd < 75 and rnd >= 50 then M = 2; end;
    if rnd > 74 then M = 1; end;
  end;
  if race == 6 then
    if rnd < 75 then M = 1; end;
    if rnd > 74 then M = 0; end;
  end;
  if race == 7 then M = 3; end;
  if race == 8 then M = 0; end;
  return M;
end;

AddSpells = -1;



function SpellNabor(race1, race2)
--  rnd = random (100);
--  if rnd > 74 then m31 = RandomMagic(race1); m32 = RandomMagic(race2); AddSpells = 1; end;
--  if rnd < 75 then
  m31 = -1; m32 = -1; AddSpells = 0; --end;

  if race1 == 1 then m11=0; m21=1; end;
  if race1 == 2 then m11=1; m21=2; end;
  if race1 == 3 then m11=1; m21=3; end;
  if race1 == 4 then m11=0; m21=2; end;
  if race1 == 5 then m11=3; m21=RandomMagic(race1); end;
  if race1 == 6 then m11=2; m21=3; end;
  if race1 == 7 then m11=0; m21=2; end;
  if race1 == 8 then m11=5; m21=0; end;

  if race2 == 1 then m12=0; m22=1; end;
  if race2 == 2 then m12=1; m22=2; end;
  if race2 == 3 then m12=1; m22=3; end;
  if race2 == 4 then m12=0; m22=2; end;
  if race2 == 5 then m12=3; m22=RandomMagic(race2); end;
  if race2 == 6 then m12=2; m22=3; end;
  if race2 == 7 then m12=0; m22=2; end;
  if race2 == 8 then m12=5; m22=0; end;

  SpellGenerate( m11, m21, m31, race1, 0);
  SpellGenerate( m12, m22, m32, race2, 1);

end;

function SpellGenerate (magic1, magic2, magic3, race, place)
--1.95
  if place == 0 and rndSpell1 ~= 49 then
    array_spells[rndSpellM1][rndSpellSp1].block_temply = 1;
    array_spells[rndSpellM11][rndSpellSp11].block_temply = 1;
  end;
  if place == 1 and rndSpell2 ~= 49 then
    array_spells[rndSpellM2][rndSpellSp2].block_temply = 1;
    array_spells[rndSpellM22][rndSpellSp22].block_temply = 1;
  end;

  if magic1 < 4 then
    num = 1;
    rnd = random(2); -- for bonus spell
    for lvl = 1, 5 do
      sp = kolSpell (lvl, magic1);
      while array_spells[magic1][sp].blocked == 1 or array_spells[magic1][sp].block_temply == 1 or array_spells[magic1][sp].kv == 0 do
        sp = kolSpell (lvl, magic1);
      end;
      array_spells[magic1][sp].block_temply = 1;
      spells[place][num].m = magic1;
      spells[place][num].sp = sp;
      SpellPosition (magic1, sp, num, place);
      num = num + 1;

      -- bonus spell
      if rnd == 0 and lvl == 1 and BonusSpells[place].sp1 == 0 and StartBonus[place + 1] == 'spell' then
         BonusSpells[place].m1  = magic1;
         BonusSpells[place].sp1 = 1 + int (0.1 + mod( sp, 2));
         array_spells[magic1][BonusSpells[place].sp1].block_temply = 1;
      end;
      if rnd == 1 and lvl == 2 and BonusSpells[place].sp1 == 0 and StartBonus[place + 1] == 'spell' then
         BonusSpells[place].m1  = magic1;
         BonusSpells[place].sp1 = 3 + int (0.1 + mod( sp, 2));
         array_spells[magic1][BonusSpells[place].sp1].block_temply = 1;
      end;
    end;

    rnd = random(2); -- for bonus spell
    for lvl = 1, 5 do
      sp = kolSpell (lvl, magic2);
      while array_spells[magic2][sp].blocked == 1 or array_spells[magic2][sp].block_temply == 1 or array_spells[magic2][sp].kv == 0 do
        sp = kolSpell (lvl, magic2);
      end;
      array_spells[magic2][sp].block_temply = 1;
      spells[place][num].m = magic2;
      spells[place][num].sp = sp;
      SpellPosition (magic2, sp, num, place);
      num = num + 1;

      -- bonus spell
      if rnd == 0 and lvl == 1 and BonusSpells[place].sp2 == 0 and StartBonus[place + 1] == 'spell' then
         BonusSpells[place].m2  = magic2;
         BonusSpells[place].sp2 = 1 + int (0.1 + mod( sp, 2));
         array_spells[magic2][BonusSpells[place].sp2].block_temply = 1;
      end;
      if rnd == 1 and lvl == 2 and BonusSpells[place].sp2 == 0 and StartBonus[place + 1] == 'spell' then
         BonusSpells[place].m2  = magic2;
         BonusSpells[place].sp2 = 3 + int (0.1 + mod( sp, 2));
         array_spells[magic2][BonusSpells[place].sp2].block_temply = 1;
      end;
    end;

    if magic3 == -1 or race == 5 then

      for lvl = 1, 3 do
        m = random (4);
        sp = kolSpell (lvl, m);
        while m == magic1 or m == magic2 or array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
          m = random (4);
          sp = kolSpell (lvl, m);
        end;
        array_spells[m][sp].block_temply = 1;
        spells[place][num].m = m;
        spells[place][num].sp = sp;
        SpellPosition (m, sp, num, place);
        num = num + 1;
      end;

      m = random (4);
      sp = 7;
      array_spells[m][sp].block_temply = 1;
      spells[place][num].m = m;
      spells[place][num].sp = sp;
      SpellPosition (m, sp, num, place);
      num = num + 1;

    end;

    if magic3 ~= -1 and race ~= 5 then
      num = num + 3;
      for lvl = 1, 5 do
        sp = kolSpell (lvl, magic3);
        while array_spells[magic3][sp].blocked == 1 or array_spells[magic3][sp].block_temply == 1 do
          sp = kolSpell (lvl, magic3);
        end;
        array_spells[magic3][sp].block_temply = 1;
        spells[place][num].m = magic3;
        spells[place][num].sp = sp;
        SpellPosition (magic3, sp, num, place);
        num = num + 1;
      end;
    end;

    if race == 5 then
      ml = 0; md = 0;
      for lvl = 1, 5 do
        m = random (4);
        sp = kolSpell (lvl, m);
        while (lvl > 3 and (m == magic1 or m == magic2))
        or (m == 0 and ml == 1 and magic2 == 0 and magic3 == -1)
        or (m == 1 and md == 1 and magic2 == 1 and magic3 == -1)
        or array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
          m = random (4);
          sp = kolSpell (lvl, m);
        end;
	if (lvl < 4 and m == 0 and magic2 == 0 and magic3 == -1) then
	  ml = 1;
	end;
	if (lvl < 4 and m == 1 and magic2 == 1 and magic3 == -1) then
	  md = 1;
	end;
        array_spells[m][sp].block_temply = 1;
        spells[place][num].m = m;
        spells[place][num].sp = sp;
        SpellPosition (m, sp, num, place);
        num = num + 1;
      end;
    end;

    if race == 6 then
      for lvl = 4, 5 do
        m = random (4);
        sp = kolSpell (lvl, m);
        while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
          m = random (4);
          sp = kolSpell (lvl, m);
        end;
        array_spells[m][sp].block_temply = 1;
        spells[place][num].m = m;
        spells[place][num].sp = sp;
        SpellPosition (m, sp, num, place);
        num = num + 1;
      end;

      if magic3 == -1 then
        for lvl = 4, 5 do
          m = random (4);
          sp = kolSpell (lvl, m);
          while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
            m = random (4);
            sp = kolSpell (lvl, m);
          end;
          array_spells[m][sp].block_temply = 1;
          spells[place][num].m = m;
          spells[place][num].sp = sp;
          SpellPosition (m, sp, num, place);
          num = num + 1;
        end;
      end;

      lvl = random (2) + 4;
      m = random (4);
      sp = kolSpell (lvl, m);
      while array_spells[m][sp].blocked == 1 or array_spells[m][sp].block_temply == 1 do
        m = random (4);
        sp = kolSpell (lvl, m);
      end;
      array_spells[m][sp].block_temply = 1;
      spells[place][num].m = m;
      spells[place][num].sp = sp;
      SpellPosition (m, sp, num, place);
      num = num + 1;
    end;

    if race == 7 then
      if (place == 0 and SpellResetUse1 == 0) or (place == 1 and SpellResetUse2 == 0) then
        for lvl = 1, 5 do
          sp = kolSpell (lvl, 4);
          while array_spells[4][sp].blocked == 1 or array_spells[4][sp].block_temply == 1 do
            sp = kolSpell (lvl, 4);
          end;
          array_spells[4][sp].block_temply = 1;
          spells[place][num].m = 4;
          spells[place][num].sp = sp;
          SpellPosition (4, sp, num, place);
          runes[place][lvl].m  = 4;
          runes[place][lvl].sp = spells[place][num].sp;
          num = num + 1;
        end;
      end;
    end;
  end;

  if magic1 == 5 then
    num = 1;
    if magic3 == -1 then
      sp = random (2) + 1;
      while array_spells[5][sp].blocked == 1 or array_spells[5][sp].block_temply == 1 do
        sp = random (2) + 1;
      end;
      spells[place][1].m = 5;
      spells[place][1].sp = sp;
      SpellPosition (5, sp, num, place);
      num = num + 2;
      -- bonus spell
      if BonusSpells[place].sp1 == 0 and StartBonus[place + 1] == 'spell' then
         BonusSpells[place].m1  = magic1;
         BonusSpells[place].sp1 = 1 + int (0.1 + mod( sp, 2));
      end;
--      spells[place][2].m = 5;
--      spells[place][2].sp = sp;
      sp = random (2) + 3;
      while array_spells[5][sp].blocked == 1 or array_spells[5][sp].block_temply == 1 do
        sp = random (2) + 3;
      end;
      spells[place][2].m = 5;
      spells[place][2].sp = sp;
      SpellPosition (5, sp, num, place);
      num = num + 2;
    end;
    if magic3 ~= -1 then
      spells[place][1].m = 5;
      spells[place][1].sp = 1;
      SpellPosition (5, 1, num, place);
      num = num + 2;
      spells[place][2].m = 5;
      spells[place][2].sp = 2;
      SpellPosition (5, 2, num, place);
      num = num + 2;
      sp = random (2) + 3;
      while array_spells[5][sp].blocked == 1 or array_spells[5][sp].block_temply == 1 do
        sp = random (2) + 3;
      end;
      spells[place][3].m = 5;
      spells[place][3].sp = sp;
      SpellPosition (5, sp, num, place);
      num = num + 7;
    end;
    sp = random (2) + 5;
    while array_spells[5][sp].blocked == 1 or array_spells[5][sp].block_temply == 1 do
      sp = random (2) + 5;
    end;
    spells[place][3].m = 5;
    spells[place][3].sp = sp;
    SpellPosition (5, sp, num, place);
  end;

  for i = 0, 5 do
    k = 12;
    if i == 4 then k = 10; end;
    if i == 5 then k = 6; end;
    for j = 1, k do
      array_spells[i][j].block_temply = 0;
    end;
  end;
end;


function kolSpell ( level, magic)
  if magic == 0 then
    if level == 1 then spell = random(2) +  1; end;
    if level == 2 then spell = random(2) +  3; end;
    if level == 3 then spell = random(2) +  5; end;
    if level == 4 then spell = random(3) +  8; end;
    if level == 5 then spell = random(2) + 11; end;
  end;
  if magic == 1 then
    if level == 1 then spell = random(2) +  1; end;
    if level == 2 then spell = random(2) +  3; end;
    if level == 3 then spell = random(2) +  5; end;
    if level == 4 then spell = random(2) +  8; end;
    if level == 5 then spell = random(3) + 10; end;
  end;
  if magic == 2 then
    if level == 1 then spell = random(2) +  1; end;
    if level == 2 then spell = random(2) +  3; end;
    if level == 3 then spell = random(2) +  5; end;
    if level == 4 then spell = random(2) +  8; end;
    if level == 5 then spell = random(3) + 10; end;
  end;
  if magic == 3 then
    if level == 1 then spell = random(2) +  1; end;
    if level == 2 then spell = random(2) +  3; end;
    if level == 3 then spell = random(2) +  5; end;
    if level == 4 then spell = random(2) +  9; end;
    if level == 5 then spell = random(2) + 11; end;
  end;
  if magic == 4 then
    if level == 1 then spell = random(2) +  1; end;
    if level == 2 then spell = random(2) +  3; end;
    if level == 3 then spell = random(2) +  5; end;
    if level == 4 then spell = random(2) +  7; end;
    if level == 5 then spell = random(2) +  9; end;
    if level == 6 then spell = random(6) +  1; end;
    if level == 7 then spell = random(4) +  7; end;
  end;
  return spell;
end;

function RunesGenerate (place)
  num = 1;
  while spells[place][num].m ~= 4 do
    num = num + 1;
  end;
  for lvl = 1, 5 do
    sp = kolSpell (lvl, 4);
    while array_spells[4][sp].blocked == 1 or array_spells[4][sp].block_temply == 1 do
      sp = kolSpell (lvl, 4);
    end;
    array_spells[4][sp].block_temply = 1;
    spells[place][num].m = 4;
    spells[place][num].sp = sp;
    SpellPosition (4, sp, num, place);
    runes[place + 2][lvl].m  = 4;
    runes[place + 2][lvl].sp = spells[place][lvl + 14].sp;
    num = num + 1;
  end;
  for j = 1, 10 do
    array_spells[4][j].block_temply = 0;
  end;
end;

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

function SpellPosition ( magic, spell, number, place)
  if place == 0 then
    SetObjectPosition(array_spells[magic][spell].name,  place_spell[place][number].x, place_spell[place][number].y, 0);
  end;
  if place == 1 then
    SetObjectPosition(array_spells[magic][spell].name2, place_spell[place][number].x, place_spell[place][number].y, 0);
  end;
end;

function SpellPositionSecondSet1()
  delta = 0;
  if SpellResetUse1 == 1 then
    for i = 1, 24 do
      if spells[2][i].sp == 0 or spells[2][i].m == 4 then
      else
        SetObjectPosition (array_spells[spells[0][i].m][spells[0][i].sp].name, i, 90, UNDERGROUND);
        SetObjectPosition (array_spells[spells[2][i].m][spells[2][i].sp].name3, place_spell[0][i + delta].x, place_spell[0][i].y, 0);
        if spells[2][i].m == 5 then
          delta = delta + 1;
        end;
      end;
    end;
  end;
  if SpellResetUse1 == 2 then
    for i = 1, 24 do
      if spells[0][i].sp == 0 or spells[0][i].m == 4 then
      else
        SetObjectPosition (array_spells[spells[2][i].m][spells[2][i].sp].name3, i, 90, UNDERGROUND);
        SetObjectPosition (array_spells[spells[0][i].m][spells[0][i].sp].name, place_spell[0][i + delta].x, place_spell[0][i].y, 0);
        if spells[0][i].m == 5 then
          delta = delta + 1;
        end;
      end;
    end;
  end;
  if SpellResetUse1 == 1 then
    SpellResetUse1 = 2;
  else
    SpellResetUse1 = 1;
  end;
end;

function SpellPositionSecondSet2()
  delta = 0;
  if SpellResetUse2 == 1 then
    for i = 1, 24 do
      if spells[3][i].sp ~= 0 and spells[3][i].m ~= 4 then
        SetObjectPosition (array_spells[spells[1][i].m][spells[1][i].sp].name2, i, 89, UNDERGROUND);
        SetObjectPosition (array_spells[spells[3][i].m][spells[3][i].sp].name4, place_spell[1][i + delta].x, place_spell[1][i].y, 0);
        if spells[3][i].m == 5 then
          delta = delta + 1;
        end;
      end;
    end;
  end;
  if SpellResetUse2 == 2 then
    for i = 1, 24 do
      if spells[1][i].sp ~= 0 and spells[1][i].m ~= 4 then
        SetObjectPosition (array_spells[spells[3][i].m][spells[3][i].sp].name4, i, 89, UNDERGROUND);
        SetObjectPosition (array_spells[spells[1][i].m][spells[1][i].sp].name2, place_spell[1][i + delta].x, place_spell[1][i].y, 0);
        if spells[1][i].m == 5 then
          delta = delta + 1;
        end;
      end;
    end;
  end;
  if SpellResetUse2 == 1 then
    SpellResetUse2 = 2;
  else
    SpellResetUse2 = 1;
  end;
end;

function RunesPositionSecondSet1()
  if RunesResetUse1 == 1 then
    for i = 1, 5 do
      SetObjectPosition (array_spells[runes[2][i].m][runes[2][i].sp].name,  i + 14, 90, UNDERGROUND);
      SetObjectPosition (array_spells[runes[0][i].m][runes[0][i].sp].name3, place_spell[0][i + 14].x, place_spell[0][i + 14].y, 0);
    end;
  end;
  if RunesResetUse1 == 2 then
    for i = 1, 5 do
      SetObjectPosition (array_spells[runes[0][i].m][runes[0][i].sp].name3, i + 14, 90, UNDERGROUND);
      SetObjectPosition (array_spells[runes[2][i].m][runes[2][i].sp].name,  place_spell[0][i + 14].x, place_spell[0][i + 14].y, 0);
    end;
  end;
  if RunesResetUse1 == 1 then
    RunesResetUse1 = 2;
  else
    RunesResetUse1 = 1;
  end;
end;

function RunesPositionSecondSet2()
  if RunesResetUse2 == 1 then
    for i = 1, 5 do
      SetObjectPosition (array_spells[runes[3][i].m][runes[3][i].sp].name2, i + 14, 89, UNDERGROUND);
      SetObjectPosition (array_spells[runes[1][i].m][runes[1][i].sp].name4, place_spell[1][i + 14].x, place_spell[1][i + 14].y, 0);
    end;
  end;
  if RunesResetUse2 == 2 then
    for i = 1, 5 do
      SetObjectPosition (array_spells[runes[1][i].m][runes[1][i].sp].name4, i + 14, 89, UNDERGROUND);
      SetObjectPosition (array_spells[runes[3][i].m][runes[3][i].sp].name2, place_spell[1][i + 14].x, place_spell[1][i + 14].y, 0);
    end;
  end;
  if RunesResetUse2 == 1 then
    RunesResetUse2 = 2;
  else
    RunesResetUse2 = 1;
  end;
end;

HeroHasSpellShield1 = 0;
HeroHasSpellShield2 = 0;

function TeachSpell (hero, nabor)
  if nabor == 0 then
    if SpellResetUse1 == 2 then
      nabor = 2;
--      for i = 1, 24 do
--        spells[0][i].m  = spells[2][i].m;
--        spells[0][i].sp = spells[2][i].m;
--      end;
    end;
--    if RunesChangeUse1 == 2 then
--      for i = 14, 18 do
--        spells[0][i].m  = runes[2][i - 13].m;
--        spells[0][i].sp = runes[2][i - 13].sp;
--      end;
--    end;
  end;
  if nabor == 1 then
    if SpellResetUse2 == 2 then
      nabor = 3;
--      for i = 1, 24 do
--        spells[1][i].m  = spells[3][i].m;
--        spells[1][i].sp = spells[3][i].m;
--      end;
    end;
--    if RunesResetUse2 == 2 then
--      for i = 14, 18 do
--        spells[1][i].m  = runes[3][i - 13].m;
--        spells[1][i].sp = runes[3][i - 13].sp;
--      end;
--    end;
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
--      if array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 5 and HasHeroSkill(hero, PERK_WISDOM) and HasArtefact( hero, 71, 1) then
--        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
--        if array_spells[spells[nabor][i].m][spells[nabor][i].sp].id == 34 and hero == HeroMax1 then HeroHasSpellShield1 = 1; end;
--        if array_spells[spells[nabor][i].m][spells[nabor][i].sp].id == 34 and hero == HeroMax2 then HeroHasSpellShield2 = 1; end;
--      end;
--      if (array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 1 or array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 2) and (nabor == 0) and (HasHeroSkill(HeroMax2, 26)) then
--        TeachHeroSpell(HeroMax2, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
--      end;
--      if (array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 1 or array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 2) and (nabor == 1) and (HasHeroSkill(HeroMax1, 26)) then
--        TeachHeroSpell(HeroMax1, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
--      end;

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


function transferArt (heroSender, heroAddressee)
  for i = 1, length(array_arts[0]) do
    if HasArtefact   (heroSender, array_arts[0][i].id) then
      GiveArtefact   (heroAddressee, array_arts[0][i].id);
      RemoveArtefact (heroSender, array_arts[0][i].id);
    end;
  end;
end;


--------------------------------------------------------------------------------
-- VYBOR RACE ------------------------------------------------------------------

function rndRace ()
  RemoveObject('mumiya');
  vybor=0;
  pl_vybor(2, 1, random(8)+1);
  pl_vybor(1, 1, random(8)+1);
end;


hero1race = 0;
hero2race = 0;

pl1_race1=random(8)+1;
pl1_race2=random(8)+1;
while pl1_race1==pl1_race2 do
  pl1_race2=random(8)+1;
end;

pl2_race1=random(8)+1;
pl2_race2=random(8)+1;
while pl2_race1==pl2_race2 do
  pl2_race2=random(8)+1;
end;

if GAME_MODE.HALF then

  pl1_race3=random(8)+1;
  while (pl1_race3==pl1_race1) or (pl1_race3==pl1_race2) do
    pl1_race3=random(8)+1;
  end;

  pl1_race4=random(8)+1;
  while (pl1_race4==pl1_race1) or (pl1_race4==pl1_race2) or (pl1_race4==pl1_race3) do
    pl1_race4=random(8)+1;
  end;

  pl2_race3=random(8)+1;
  while (pl2_race3==pl2_race1) or (pl2_race3==pl2_race2) do
    pl2_race3=random(8)+1;
  end;

  pl2_race4=random(8)+1;
  while (pl2_race4==pl2_race1) or (pl2_race4==pl2_race2) or (pl2_race4==pl2_race3) do
    pl2_race4=random(8)+1;
  end;

  hero1race = pl1_race1 * pl1_race2 * pl1_race3 * pl1_race4;
  hero2race = pl2_race1 * pl2_race2 * pl2_race3 * pl2_race4;
  regionFinal1 = 1 * 2 * 3 * 4;
  regionFinal2 = 5 * 6 * 7 * 8;

end;

if GAME_MODE.MIX then

  pl1_race3=random(8)+1;
  while (pl1_race3==pl1_race1) or (pl1_race3==pl1_race2) do
    pl1_race3=random(8)+1;
  end;

  pl1_race4=random(8)+1;
  while (pl1_race4==pl1_race1) or (pl1_race4==pl1_race2) or (pl1_race4==pl1_race3) do
    pl1_race4=random(8)+1;
  end;

  pl2_race3=random(8)+1;
  while (pl2_race3==pl2_race1) or (pl2_race3==pl2_race2) do
    pl2_race3=random(8)+1;
  end;

  pl2_race4=random(8)+1;
  while (pl2_race4==pl2_race1) or (pl2_race4==pl2_race2) or (pl2_race4==pl2_race3) do
    pl2_race4=random(8)+1;
  end;

  hero1race = pl1_race1 * pl1_race2 * pl1_race3 * pl1_race4;
  hero2race = pl2_race1 * pl2_race2 * pl2_race3 * pl2_race4;
  regionFinal1 = 1 * 2 * 3 * 4;
  regionFinal2 = 5 * 6 * 7 * 8;

end;

if GAME_MODE.SIMPLE_CHOOSE then
  pl1_race1=1;
  pl1_race2=2;
  pl1_race3=3;
  pl1_race4=4;
  pl2_race1=5;
  pl2_race2=6;
  pl2_race3=7;
  pl2_race4=8;
end;

reg1block=0;
reg2block=0;
reg3block=0;
reg4block=0;
reg5block=0;
reg6block=0;
reg7block=0;
reg8block=0;

function SetRace (race, pl, x1, x2, y1, y2)
  if pl==1 then
    if race == 1 then
      SetObjectPosition('human1', x1, y1);
      SetObjectPosition('human2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="human.txt"; end;
      if GAME_MODE.HALF then text="humanCherk.txt"; end;
      if GAME_MODE.MIX then text="humanCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="human.txt"; end;
    end;
    if race == 2 then
      SetObjectPosition('demon1', x1, y1);
      SetObjectPosition('demon2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="demon.txt"; end;
      if GAME_MODE.HALF then text="demonCherk.txt"; end;
      if GAME_MODE.MIX then text="demonCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="demon.txt"; end;
    end;
    if race == 3 then
      SetObjectPosition('nekr1', x1, y1);
      SetObjectPosition('nekr2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="nekr.txt"; end;
      if GAME_MODE.HALF then text="nekrCherk.txt"; end;
      if GAME_MODE.MIX then text="nekrCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="nekr.txt"; end;
    end;
    if race == 4 then
      SetObjectPosition('elf1', x1, y1);
      SetObjectPosition('elf2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="elf.txt"; end;
      if GAME_MODE.HALF then text="elfCherk.txt"; end;
      if GAME_MODE.MIX then text="elfCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="elf.txt"; end;
    end;
    if race == 5 then
      SetObjectPosition('mag1', x1, y1);
      SetObjectPosition('mag2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="mag.txt"; end;
      if GAME_MODE.HALF then text="magCherk.txt"; end;
      if GAME_MODE.MIX then text="magCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="mag.txt"; end;
    end;
    if race == 6 then
      SetObjectPosition('liga1', x1, y1);
      SetObjectPosition('liga2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="liga.txt"; end;
      if GAME_MODE.HALF then text="ligaCherk.txt"; end;
      if GAME_MODE.MIX then text="ligaCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="liga.txt"; end;
    end;
    if race == 7 then
      SetObjectPosition('gnom1', x1, y1);
      SetObjectPosition('gnom2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="gnom.txt"; end;
      if GAME_MODE.HALF then text="gnomCherk.txt"; end;
      if GAME_MODE.MIX then text="gnomCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="gnom.txt"; end;
    end;
    if race == 8 then
      SetObjectPosition('ork1', x1, y1);
      SetObjectPosition('ork2vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="ork.txt"; end;
      if GAME_MODE.HALF then text="orkCherk.txt"; end;
      if GAME_MODE.MIX then text="orkCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="ork.txt"; end;
    end;
  end;
  if pl==2 then
    if race == 1 then
      SetObjectPosition('human2', x1, y1);
      SetObjectPosition('human1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="human.txt"; end;
      if GAME_MODE.HALF then text="humanCherk.txt"; end;
      if GAME_MODE.MIX then text="humanCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="human.txt"; end;
    end;
    if race == 2 then
      SetObjectPosition('demon2', x1, y1);
      SetObjectPosition('demon1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="demon.txt"; end;
      if GAME_MODE.HALF then text="demonCherk.txt"; end;
      if GAME_MODE.MIX then text="demonCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="demon.txt"; end;
    end;
    if race == 3 then
      SetObjectPosition('nekr2', x1, y1);
      SetObjectPosition('nekr1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="nekr.txt"; end;
      if GAME_MODE.HALF then text="nekrCherk.txt"; end;
      if GAME_MODE.MIX then text="nekrCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="nekr.txt"; end;
    end;
    if race == 4 then
      SetObjectPosition('elf2', x1, y1);
      SetObjectPosition('elf1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="elf.txt"; end;
      if GAME_MODE.HALF then text="elfCherk.txt"; end;
      if GAME_MODE.MIX then text="elfCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="elf.txt"; end;
    end;
    if race == 5 then
      SetObjectPosition('mag2', x1, y1);
      SetObjectPosition('mag1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="mag.txt"; end;
      if GAME_MODE.HALF then text="magCherk.txt"; end;
      if GAME_MODE.MIX then text="magCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="mag.txt"; end;
    end;
    if race == 6 then
      SetObjectPosition('liga2', x1, y1);
      SetObjectPosition('liga1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="liga.txt"; end;
      if GAME_MODE.HALF then text="ligaCherk.txt"; end;
      if GAME_MODE.MIX then text="ligaCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="liga.txt"; end;
    end;
    if race == 7 then
      SetObjectPosition('gnom2', x1, y1);
      SetObjectPosition('gnom1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="gnom.txt"; end;
      if GAME_MODE.HALF then text="gnomCherk.txt"; end;
      if GAME_MODE.MIX then text="gnomCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="gnom.txt"; end;
    end;
    if race == 8 then
      SetObjectPosition('ork2', x1, y1);
      SetObjectPosition('ork1vrag', x2, y2);
      if GAME_MODE.MATCHUPS then text="ork.txt"; end;
      if GAME_MODE.HALF then text="orkCherk.txt"; end;
      if GAME_MODE.MIX then text="orkCherk.txt"; end;
      if GAME_MODE.SIMPLE_CHOOSE then text="ork.txt"; end;
    end;
  end;
  return text;
end;

units={};

function SetUnit (race, x, y, rotate)
  unit_race=random(9);
  while unit_race==race do
    unit_race=random(9);
  end;
  if unit_race==0 then KU=9; else KU=21; end;
  unit_number=random(KU)+1;
  while array_units[unit_race][unit_number].blocked==1 do
    unit_number=random(KU)+1;
  end;
  array_units[unit_race][unit_number].blocked=1;
  koef=1;
  if GAME_MODE.SIMPLE_CHOOSE then koef=2; end;
  if GAME_MODE.HALF then koef=0.9; end;
  if GAME_MODE.MIX then koef=0.7; end;
  CreateMonster (array_units[unit_race][unit_number].name, array_units[unit_race][unit_number].id,
                 array_units[unit_race][unit_number].kol*koef, x, y, 0, MONSTER_MOOD_FRIENDLY,
                 MONSTER_COURAGE_ALWAYS_JOIN, rotate);
  SetObjectEnabled(array_units[unit_race][unit_number].name, nil);
  SetDisabledObjectMode(array_units[unit_race][unit_number].name, 3);
  if schetchikUnit==0 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl1_vopros5' ); end;
  if schetchikUnit==1 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl1_vopros6' ); end;
  if schetchikUnit==2 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl1_vopros7' ); end;
  if schetchikUnit==3 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl1_vopros8' ); end;
  if schetchikUnit==4 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl2_vopros5' ); end;
  if schetchikUnit==5 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl2_vopros6' ); end;
  if schetchikUnit==6 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl2_vopros7' ); end;
  if schetchikUnit==7 then Trigger( OBJECT_TOUCH_TRIGGER, array_units[unit_race][unit_number].name, 'pl2_vopros8' ); end;
  u_r=unit_race; u_n=unit_number;
  units[schetchikUnit] = {["UR"] = unit_race, ["UN"] = unit_number};
  schetchikUnit=schetchikUnit+1;
end;

function SetArt ( x, y, stage, arena)
  if stage == 0 then kolArt=length(array_arts[0]); end;
  if stage == 1 then kolArt=length(array_arts[1]); end;
  if stage == 2 then kolArt=length(array_arts[2]); end;
  rnd=random(kolArt)+1;
  while array_arts[stage][rnd].blocked==1 do
    rnd=random(kolArt)+1;
  end;
  array_arts[stage][rnd].blocked=1;
  if arena == 1 then
    CreateArtifact(array_arts[stage][rnd].name, array_arts[stage][rnd].id, x, y, 0);
    SetObjectEnabled(array_arts[stage][rnd].name, nil);
  --  OverrideObjectTooltipNameAndDescription (array_arts[stage][rnd].name, GetMapDataPath().."ArtName.txt", GetMapDataPath().."ArtDSCRP.txt");
    if stage==0 then Trigger( OBJECT_TOUCH_TRIGGER, array_arts[stage][rnd].name, 'artVopros0' ); end;
    if stage==1 then Trigger( OBJECT_TOUCH_TRIGGER, array_arts[stage][rnd].name, 'artVopros1' ); end;
    if stage==2 then Trigger( OBJECT_TOUCH_TRIGGER, array_arts[stage][rnd].name, 'artVopros2' ); end;
  end;
  if arena == 2 then
    CreateArtifact(array_arts[stage][rnd].name2, array_arts[stage][rnd].id, x, y, 0);
    SetObjectEnabled(array_arts[stage][rnd].name2, nil);
    OverrideObjectTooltipNameAndDescription (array_arts[stage][rnd].name2, GetMapDataPath().."ArtName.txt", GetMapDataPath().."ArtDSCRP.txt");
    if stage==0 then Trigger( OBJECT_TOUCH_TRIGGER, array_arts[stage][rnd].name2, 'artVopros0' ); end;
    if stage==1 then Trigger( OBJECT_TOUCH_TRIGGER, array_arts[stage][rnd].name2, 'artVopros1' ); end;
    if stage==2 then Trigger( OBJECT_TOUCH_TRIGGER, array_arts[stage][rnd].name2, 'artVopros2' ); end;
  end;
end;

function artVopros0( hero, name)
  pl=GetObjectOwner(hero);
  for i=1, length(array_arts[0]) do
    if name==array_arts[0][i].name or name==array_arts[0][i].name2 then numArt=i; i=length(array_arts[0]); end;
  end;
  if pl==1 then numArtForPl1=numArt; end;
  if pl==2 then numArtForPl2=numArt; end;
  QuestionBoxForPlayers (GetPlayerFilter( pl ), {GetMapDataPath().."pokupka_Art.txt"; eq = array_arts[0][numArt].price}, 'giveArt0(pl)', 'no');
end;

function artVopros1( hero, name)
  pl=GetObjectOwner(hero);
  for i=1, length(array_arts[1]) do
    if name==array_arts[1][i].name or name==array_arts[1][i].name2 then numArt=i; i=length(array_arts[1]); end;
  end;
  if pl==1 then numArtForPl1=numArt; end;
  if pl==2 then numArtForPl2=numArt; end;
  QuestionBoxForPlayers (GetPlayerFilter( pl ), {GetMapDataPath().."pokupka_Art.txt"; eq = array_arts[1][numArt].price}, 'giveArt1(pl)', 'no');
end;

function artVopros2( hero, name)
  pl=GetObjectOwner(hero);
  for i=1, length(array_arts[2]) do
    if name==array_arts[2][i].name or name==array_arts[2][i].name2 then numArt=i; i=length(array_arts[2]); end;
  end;
  if pl==1 then numArtForPl1=numArt; end;
  if pl==2 then numArtForPl2=numArt; end;
  QuestionBoxForPlayers (GetPlayerFilter( pl ), {GetMapDataPath().."pokupka_Art.txt"; eq = array_arts[2][numArt].price}, 'giveArt2(pl)', 'no');
end;

function giveArt0(player)
  if player==1 then NA=numArtForPl1; end;
  if player==2 then NA=numArtForPl2; end;
  heroy=GetPlayerHeroes(player);
  h=length(heroy);
  if (GetPlayerResource(player, 6) >= array_arts[0][NA].price) then
    GiveArtefact(heroy[h-1], array_arts[0][NA].id, 0);
    SetPlayerResource (player, GOLD, (GetPlayerResource (player, GOLD) -  array_arts[0][NA].price));
    if player==1 then RemoveObject(array_arts[0][NA].name); end;
    if player==2 then RemoveObject(array_arts[0][NA].name2); end;
  else MessageBoxForPlayers(GetPlayerFilter( player ), GetMapDataPath().."NOmoney.txt" );
  end;
end;

function giveArt1(player)
  if player==1 then NA=numArtForPl1; end;
  if player==2 then NA=numArtForPl2; end;
  heroy=GetPlayerHeroes(player);
  h=length(heroy);
  if (GetPlayerResource(player, 6) >= array_arts[1][NA].price) then
    GiveArtefact(heroy[h-1], array_arts[1][NA].id, 0);
    SetPlayerResource (player, GOLD, (GetPlayerResource (player, GOLD) -  array_arts[1][NA].price));
    if player==1 then RemoveObject(array_arts[1][NA].name); end;
    if player==2 then RemoveObject(array_arts[1][NA].name2); end;
  else MessageBoxForPlayers(GetPlayerFilter( player ), GetMapDataPath().."NOmoney.txt" );
  end;
end;

function giveArt2(player)
  if player==1 then NA=numArtForPl1; end;
  if player==2 then NA=numArtForPl2; end;
  heroy=GetPlayerHeroes(player);
  h=length(heroy);
  if (GetPlayerResource(player, 6) >= array_arts[2][NA].price) then
    GiveArtefact(heroy[h-1], array_arts[2][NA].id, 0);
    SetPlayerResource (player, GOLD, (GetPlayerResource (player, GOLD) -  array_arts[2][NA].price));
    if player==1 then RemoveObject(array_arts[2][NA].name); end;
    if player==2 then RemoveObject(array_arts[2][NA].name2); end;
  else MessageBoxForPlayers(GetPlayerFilter( player ), GetMapDataPath().."NOmoney.txt" );
  end;
end;

function UnitShop ()
  schetchikUnit=0;
  unit_race=0;
  unit_number=0;
  sleep(5);
  SetRegionBlocked ('block1', nil);
  SetRegionBlocked ('block2', nil);
  SetRegionBlocked ('block3', nil);
  SetRegionBlocked ('block4', nil);
  SetRegionBlocked ('reg_shop1', true);
  SetRegionBlocked ('reg_shop2', true);
  SetRegionBlocked ('reg_shop3', true);
  SetRegionBlocked ('reg_shop4', true);
  SetRegionBlocked ('reg_shop5', true);
  SetRegionBlocked ('reg_shop6', true);
  SetObjectPosition(heroes1[0], 89, 30);
  SetObjectPosition(heroes2[0],  6, 62);
  sleep(5);
  Unit1Buy = 0;
  Unit2Buy = 0;
  Unit3Buy = 0;
  Unit4Buy = 0;
  Unit5Buy = 0;
  Unit6Buy = 0;
  Unit7Buy = 0;
  Unit8Buy = 0;
  SetUnit(hero1race, 37, 86, 270);  OpenCircleFog( 37, 84, 0, 2, 2 );
  SetUnit(hero1race, 37, 84, 270);  --OpenCircleFog( 92, 32, 0, 2, 2 );
  SetUnit(hero1race, 33, 86,  90);  OpenCircleFog( 33, 84, 0, 2, 2 );
  SetUnit(hero1race, 33, 84,  90);  --OpenCircleFog( 86, 32, 0, 2, 2 );
  SetUnit(hero2race, 44, 23, 270);  OpenCircleFog( 44, 25, 0, 2, 1 );
  SetUnit(hero2race, 44, 25, 270);  --OpenCircleFog(  9, 60, 0, 2, 1 );
  SetUnit(hero2race, 40, 23,  90);  OpenCircleFog( 40, 25, 0, 2, 1 );
  SetUnit(hero2race, 40, 25,  90);  --OpenCircleFog(  3, 60, 0, 2, 1 );
  SetObjectPosition(heroes1[0], 89, 33);
  SetObjectPosition(heroes2[0],  6, 59);
end;

function sbrosArtBlock()
  for i=1, length(array_arts[0]) do
    array_arts[0][i].blocked=0;
  end;
  for i=1, length(array_arts[1]) do
    array_arts[1][i].blocked=0;
  end;
  for i=1, length(array_arts[2]) do
    array_arts[2][i].blocked=0;
  end;
end;

function ArtNabor(race, x, y, mirror)

  rnd=random(length(array_arts[0]))+1;
  while array_arts[0][rnd].blocked==1 do
    rnd=random(length(array_arts[0]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[0][rnd].id, x, y+1, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place1=array_arts[0][rnd].place;
  a1=array_arts[0][rnd].id;
  if i==0 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl1_vopros1' ); end;
  if i==1 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl1_vopros2' ); end;
  if i==2 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl2_vopros1' ); end;
  if i==3 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl2_vopros2' ); end;
  j=j+1;

  rnd=random(length(array_arts[0]))+1;
  while array_arts[0][rnd].blocked==1 or array_arts[0][rnd].place==place1 do
    rnd=random(length(array_arts[0]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[0][rnd].id, x, y, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place2=array_arts[0][rnd].place;
  a2=array_arts[0][rnd].id;
  if i==0 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl1_vopros1' ); end;
  if i==1 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl1_vopros2' ); end;
  if i==2 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl2_vopros1' ); end;
  if i==3 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl2_vopros2' ); end;
  j=j+1;

  rnd=random(length(array_arts[0]))+1;
  while array_arts[0][rnd].blocked==1 or array_arts[0][rnd].place==place1 or array_arts[0][rnd].place==place2 do
    rnd=random(length(array_arts[0]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[0][rnd].id, x, y-1, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place3=array_arts[0][rnd].place;
  a3=array_arts[0][rnd].id;
  if i==0 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl1_vopros1' ); end;
  if i==1 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl1_vopros2' ); end;
  if i==2 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl2_vopros1' ); end;
  if i==3 then Trigger( OBJECT_TOUCH_TRIGGER, array_name[i][j], 'pl2_vopros2' ); end;
  j=j+1;

  rnd=random(length(array_arts[1]))+1;
  while array_arts[1][rnd].blocked==1 or array_arts[1][rnd].place==place1 or array_arts[1][rnd].place==place2
  or array_arts[1][rnd].place==place3 do
    rnd=random(length(array_arts[1]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[1][rnd].id, x-(mirror*1), y+1, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place4=array_arts[1][rnd].place;
  a4=array_arts[1][rnd].id;
  j=j+1;

  rnd=random(length(array_arts[1]))+1;
  while array_arts[1][rnd].blocked==1 or array_arts[1][rnd].place==place1 or array_arts[1][rnd].place==place2
  or array_arts[1][rnd].place==place3 or array_arts[1][rnd].place==place4 do
    rnd=random(length(array_arts[1]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[1][rnd].id, x-(mirror*1), y, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place5=array_arts[1][rnd].place;
  a5=array_arts[1][rnd].id;
  j=j+1;

  rnd=random(length(array_arts[1]))+1;
  while array_arts[1][rnd].blocked==1 or array_arts[1][rnd].place==place1 or array_arts[1][rnd].place==place2
  or array_arts[1][rnd].place==place3 or array_arts[1][rnd].place==place4 or array_arts[1][rnd].place==place5 do
    rnd=random(length(array_arts[1]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[1][rnd].id, x-(mirror*1), y-1, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place6=array_arts[1][rnd].place;
  a6=array_arts[1][rnd].id;
  j=j+1;

  rnd=random(length(array_arts[2]))+1;
  while array_arts[2][rnd].blocked==1 or array_arts[2][rnd].place==place1 or array_arts[2][rnd].place==place2
  or array_arts[2][rnd].place==place3 or array_arts[2][rnd].place==place4 or array_arts[2][rnd].place==place5
  or array_arts[2][rnd].place==place6 do
    rnd=random(length(array_arts[2]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[2][rnd].id, x-(mirror*2), y+1, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place7=array_arts[2][rnd].place;
  a7=array_arts[2][rnd].id;
  j=j+1;

  rnd=random(length(array_arts[2]))+1;
  while array_arts[2][rnd].blocked==1 or array_arts[2][rnd].place==place1 or array_arts[2][rnd].place==place2
  or array_arts[2][rnd].place==place3 or array_arts[2][rnd].place==place4 or array_arts[2][rnd].place==place5
  or array_arts[2][rnd].place==place6 or array_arts[2][rnd].place==place7 do
    rnd=random(length(array_arts[2]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[2][rnd].id, x-(mirror*2), y, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place8=array_arts[2][rnd].place;
  a8=array_arts[2][rnd].id;
  j=j+1;

  rnd=random(length(array_arts[2]))+1;
  while array_arts[2][rnd].blocked==1 or array_arts[2][rnd].place==place1 or array_arts[2][rnd].place==place2
  or array_arts[2][rnd].place==place3 or array_arts[2][rnd].place==place4 or array_arts[2][rnd].place==place5
  or array_arts[2][rnd].place==place6 or array_arts[2][rnd].place==place7 or array_arts[2][rnd].place==place8 do
    rnd=random(length(array_arts[2]))+1;
  end;
  CreateArtifact(array_name[i][j], array_arts[2][rnd].id, x-(mirror*2), y-1, 0);
  SetObjectEnabled(array_name[i][j], nil);
  place9=array_arts[2][rnd].place;
  a9=array_arts[2][rnd].id;
  j=1;
  i=i+1;

--  SetUnit(race, x-(mirror*2), y, 180-(90*mirror));
--  ur=u_r;
--  un=u_n;
  return a1, a2, a3, a4, a5, a6, a7, a8, a9;

end;

function SetArtNabor()
  array_name={};
  array_name[0]={"n1a1", "n1a2", "n1a3", "n1a4", "n1a5", "n1a6", "n1a7", "n1a8", "n1a9"}
  array_name[1]={"n2a1", "n2a2", "n2a3", "n2a4", "n2a5", "n2a6", "n2a7", "n2a8", "n2a9"}
  array_name[2]={"n3a1", "n3a2", "n3a3", "n3a4", "n3a5", "n3a6", "n3a7", "n3a8", "n3a9"}
  array_name[3]={"n4a1", "n4a2", "n4a3", "n4a4", "n4a5", "n4a6", "n4a7", "n4a8", "n4a9"}
--  array_name[4]={"n5a1", "n5a2", "n5a3", "n5a4", "n5a5", "n5a6", "n5a7"}
--  array_name[5]={"n6a1", "n6a2", "n6a3", "n6a4", "n6a5", "n6a6", "n6a7"}
--  array_name[6]={"n7a1", "n7a2", "n7a3", "n7a4", "n7a5", "n7a6", "n7a7"}
--  array_name[7]={"n8a1", "n8a2", "n8a3", "n8a4", "n8a5", "n8a6", "n8a7"}
  schetchikUnit=0;
  i=0;j=1;
  GetSetArtsPlayer1 = 0;
  GetSetArtsPlayer2 = 0;
  sleep(5);
  SetObjectPosition(heroes1[0], 35, 82);
  SetObjectPosition(heroes2[0], 42, 27);
  sleep(5);
  n1a1, n1a2, n1a3, n1a4, n1a5, n1a6, n1a7, n1a8, n1a9 = ArtNabor(hero1race, 34, 85,  1);
  n2a1, n2a2, n2a3, n2a4, n2a5, n2a6, n2a7, n2a8, n2a9 = ArtNabor(hero1race, 36, 85, -1);
  n3a1, n3a2, n3a3, n3a4, n3a5, n3a6, n3a7, n3a8, n3a9 = ArtNabor(hero2race, 41, 24,  1);
  n4a1, n4a2, n4a3, n4a4, n4a5, n4a6, n4a7, n4a8, n4a9 = ArtNabor(hero2race, 43, 24, -1);
--  n5a1, n5a2, n5a3, n5a4, n5a5, n5a6, n5a7, n5ur, n5un = ArtNabor(hero2race,  4, 59, 1);
--  n6a1, n6a2, n6a3, n6a4, n6a5, n6a6, n6a7, n6ur, n6un = ArtNabor(hero2race,  4, 55, 1);
--  n7a1, n7a2, n7a3, n7a4, n7a5, n7a6, n7a7, n7ur, n7un = ArtNabor(hero2race,  8, 59, -1);
--  n8a1, n8a2, n8a3, n8a4, n8a5, n8a6, n8a7, n8ur, n8un = ArtNabor(hero2race,  8, 55, -1);
  SetObjectPosition(heroes1[0], 35, 85);
  SetObjectPosition(heroes2[0], 42, 24);
end;

function nabor1()
  if GetSetArtsPlayer1 == 0 then
    heroy=GetPlayerHeroes(PLAYER_1);
    h=length(heroy);
    GiveArtefact(heroy[h-1], n1a1, 0);
    GiveArtefact(heroy[h-1], n1a2, 0);
    GiveArtefact(heroy[h-1], n1a3, 0);
    GiveArtefact(heroy[h-1], n1a4, 0);
    GiveArtefact(heroy[h-1], n1a5, 0);
    GiveArtefact(heroy[h-1], n1a6, 0);
    GiveArtefact(heroy[h-1], n1a7, 0);
    GiveArtefact(heroy[h-1], n1a8, 0);
    GiveArtefact(heroy[h-1], n1a9, 0);
    for i=1, 9 do
      RemoveObject(array_name[0][i]);
      RemoveObject(array_name[1][i]);
    end;
  end;
  GetSetArtsPlayer1 = 1;
  SetRegionBlocked ('block1', true);
  SetRegionBlocked ('block2', true);
end;

function nabor2()
  if GetSetArtsPlayer1 == 0 then
    heroy=GetPlayerHeroes(PLAYER_1);
    h=length(heroy);
    GiveArtefact(heroy[h-1], n2a1, 0);
    GiveArtefact(heroy[h-1], n2a2, 0);
    GiveArtefact(heroy[h-1], n2a3, 0);
    GiveArtefact(heroy[h-1], n2a4, 0);
    GiveArtefact(heroy[h-1], n2a5, 0);
    GiveArtefact(heroy[h-1], n2a6, 0);
    GiveArtefact(heroy[h-1], n2a7, 0);
    GiveArtefact(heroy[h-1], n2a8, 0);
    GiveArtefact(heroy[h-1], n2a9, 0);
    for i=1, 9 do
      RemoveObject(array_name[0][i]);
      RemoveObject(array_name[1][i]);
    end;
  end;
  GetSetArtsPlayer1 = 1;
  SetRegionBlocked ('block1', true);
  SetRegionBlocked ('block2', true);
end;

function nabor3()
  heroy=GetPlayerHeroes(PLAYER_1);
  h=length(heroy);
  GiveArtefact(heroy[h-1], n3a1, 0);
  GiveArtefact(heroy[h-1], n3a2, 0);
  GiveArtefact(heroy[h-1], n3a3, 0);
  GiveArtefact(heroy[h-1], n3a4, 0);
  GiveArtefact(heroy[h-1], n3a5, 0);
  GiveArtefact(heroy[h-1], n3a6, 0);
  GiveArtefact(heroy[h-1], n3a7, 0);
  AddHeroCreatures(heroes1[0], array_units[n3ur][n3un].id, array_units[n3ur][n3un].kol);
  reg11block=1;
  reg12block=1;
  reg15block=1;
  reg16block=1;
  for i=1, 7 do
    RemoveObject(array_name[2][i]);
  end;
  RemoveObject(array_units[n3ur][n3un].name);
end;

function nabor4()
  heroy=GetPlayerHeroes(PLAYER_1);
  h=length(heroy);
  GiveArtefact(heroy[h-1], n4a1, 0);
  GiveArtefact(heroy[h-1], n4a2, 0);
  GiveArtefact(heroy[h-1], n4a3, 0);
  GiveArtefact(heroy[h-1], n4a4, 0);
  GiveArtefact(heroy[h-1], n4a5, 0);
  GiveArtefact(heroy[h-1], n4a6, 0);
  GiveArtefact(heroy[h-1], n4a7, 0);
  AddHeroCreatures(heroes1[0], array_units[n4ur][n4un].id, array_units[n4ur][n4un].kol);
  reg11block=1;
  reg12block=1;
  reg15block=1;
  reg16block=1;
  for i=1, 7 do
    RemoveObject(array_name[3][i]);
  end;
  RemoveObject(array_units[n4ur][n4un].name);
end;

function nabor5()
  if GetSetArtsPlayer2 == 0 then
    heroy=GetPlayerHeroes(PLAYER_2);
    h=length(heroy);
    GiveArtefact(heroy[h-1], n3a1, 0);
    GiveArtefact(heroy[h-1], n3a2, 0);
    GiveArtefact(heroy[h-1], n3a3, 0);
    GiveArtefact(heroy[h-1], n3a4, 0);
    GiveArtefact(heroy[h-1], n3a5, 0);
    GiveArtefact(heroy[h-1], n3a6, 0);
    GiveArtefact(heroy[h-1], n3a7, 0);
    GiveArtefact(heroy[h-1], n3a8, 0);
    GiveArtefact(heroy[h-1], n3a9, 0);
    for i=1, 9 do
      RemoveObject(array_name[2][i]);
      RemoveObject(array_name[3][i]);
    end;
  end;
  GetSetArtsPlayer2 = 1;
  SetRegionBlocked ('block3', true);
  SetRegionBlocked ('block4', true);
end;

function nabor6()
  if GetSetArtsPlayer1 == 0 then
    heroy=GetPlayerHeroes(PLAYER_2);
    h=length(heroy);
    GiveArtefact(heroy[h-1], n4a1, 0);
    GiveArtefact(heroy[h-1], n4a2, 0);
    GiveArtefact(heroy[h-1], n4a3, 0);
    GiveArtefact(heroy[h-1], n4a4, 0);
    GiveArtefact(heroy[h-1], n4a5, 0);
    GiveArtefact(heroy[h-1], n4a6, 0);
    GiveArtefact(heroy[h-1], n4a7, 0);
    GiveArtefact(heroy[h-1], n4a8, 0);
    GiveArtefact(heroy[h-1], n4a9, 0);
    for i=1, 9 do
      RemoveObject(array_name[2][i]);
      RemoveObject(array_name[3][i]);
    end;
  end;
  GetSetArtsPlayer2 = 1;
  SetRegionBlocked ('block3', true);
  SetRegionBlocked ('block4', true);
end;

function nabor7()
  heroy=GetPlayerHeroes(PLAYER_2);
  h=length(heroy);
  GiveArtefact(heroy[h-1], n7a1, 0);
  GiveArtefact(heroy[h-1], n7a2, 0);
  GiveArtefact(heroy[h-1], n7a3, 0);
  GiveArtefact(heroy[h-1], n7a4, 0);
  GiveArtefact(heroy[h-1], n7a5, 0);
  GiveArtefact(heroy[h-1], n7a6, 0);
  GiveArtefact(heroy[h-1], n7a7, 0);
  AddHeroCreatures(heroes2[0], array_units[n7ur][n7un].id, array_units[n7ur][n7un].kol);
  reg21block=1;
  reg22block=1;
  reg25block=1;
  reg26block=1;
  for i=1, 7 do
    RemoveObject(array_name[6][i]);
  end;
  RemoveObject(array_units[n7ur][n7un].name);
end;

function nabor8()
  heroy=GetPlayerHeroes(PLAYER_2);
  h=length(heroy);
  GiveArtefact(heroy[h-1], n8a1, 0);
  GiveArtefact(heroy[h-1], n8a2, 0);
  GiveArtefact(heroy[h-1], n8a3, 0);
  GiveArtefact(heroy[h-1], n8a4, 0);
  GiveArtefact(heroy[h-1], n8a5, 0);
  GiveArtefact(heroy[h-1], n8a6, 0);
  GiveArtefact(heroy[h-1], n8a7, 0);
  AddHeroCreatures(heroes2[0], array_units[n8ur][n8un].id, array_units[n8ur][n8un].kol);
  reg21block=1;
  reg22block=1;
  reg25block=1;
  reg26block=1;
  for i=1, 7 do
    RemoveObject(array_name[7][i]);
  end;
  RemoveObject(array_units[n8ur][n8un].name);
end;



--if GAME_MODE.MATCHUPS then
--  text11=SetRace(pl1_race1, 1, 85, 10, 36, 58);
--  text12=SetRace(pl1_race2, 1, 85, 10, 34, 56);
--  text21=SetRace(pl2_race1, 2,  2, 93, 58, 36);
--  text22=SetRace(pl2_race2, 2,  2, 93, 56, 34);
--end;

--if GAME_MODE.HALF then
--  text11=SetRace(pl1_race1, 1, 85, 10, 36, 58);
--  text12=SetRace(pl1_race2, 1, 85, 10, 34, 56);
--  text13=SetRace(pl1_race3, 1, 85, 10, 38, 60);
--  text14=SetRace(pl1_race4, 1, 85, 10, 32, 54);
--  text21=SetRace(pl2_race1, 2,  2, 93, 58, 36);
--  text22=SetRace(pl2_race2, 2,  2, 93, 56, 34);
--  text23=SetRace(pl2_race3, 2,  2, 93, 60, 38);
--  text24=SetRace(pl2_race4, 2,  2, 93, 54, 32);
--end;



---------------  ЧЕРК ГЕРОЕВ И РАС ---------

array_PosterRed = {}
array_PosterRed[1] = { "PosterRed_1",  "PosterRed_2",  "PosterRed_3",  "PosterRed_4"  }
array_PosterRed[2] = { "PosterRed_5",  "PosterRed_6",  "PosterRed_7",  "PosterRed_8"  }
array_PosterRed[3] = { "PosterRed_9",  "PosterRed_10", "PosterRed_11", "PosterRed_12" }
array_PosterRed[4] = { "PosterRed_13", "PosterRed_14", "PosterRed_15", "PosterRed_16" }
array_PosterRed[5] = { "PosterRed_17", "PosterRed_18", "PosterRed_19", "PosterRed_20" }
array_PosterRed[6] = { "PosterRed_21", "PosterRed_22", "PosterRed_23", "PosterRed_24" }
array_PosterRed[7] = { "PosterRed_25", "PosterRed_26", "PosterRed_27", "PosterRed_28" }
array_PosterRed[8] = { "PosterRed_29", "PosterRed_30", "PosterRed_31", "PosterRed_32" }

array_PosterBlue = {}
array_PosterBlue[1] = { "PosterBlue_1",  "PosterBlue_2",  "PosterBlue_3",  "PosterBlue_4"  }
array_PosterBlue[2] = { "PosterBlue_5",  "PosterBlue_6",  "PosterBlue_7",  "PosterBlue_8"  }
array_PosterBlue[3] = { "PosterBlue_9",  "PosterBlue_10", "PosterBlue_11", "PosterBlue_12" }
array_PosterBlue[4] = { "PosterBlue_13", "PosterBlue_14", "PosterBlue_15", "PosterBlue_16" }
array_PosterBlue[5] = { "PosterBlue_17", "PosterBlue_18", "PosterBlue_19", "PosterBlue_20" }
array_PosterBlue[6] = { "PosterBlue_21", "PosterBlue_22", "PosterBlue_23", "PosterBlue_24" }
array_PosterBlue[7] = { "PosterBlue_25", "PosterBlue_26", "PosterBlue_27", "PosterBlue_28" }
array_PosterBlue[8] = { "PosterBlue_29", "PosterBlue_30", "PosterBlue_31", "PosterBlue_32" }

KitHero1 = {}
KitHero1[1] = { 0, 0, 0, 0}
KitHero1[2] = { 0, 0, 0, 0}
KitHero1[3] = { 0, 0, 0, 0}
KitHero1[4] = { 0, 0, 0, 0}
KitHero1[5] = { 0, 0, 0, 0}
KitHero1[6] = { 0, 0, 0, 0}
KitHero1[7] = { 0, 0, 0, 0}
KitHero1[8] = { 0, 0, 0, 0}

KitHero2 = {}
KitHero2[1] = { 0, 0, 0, 0}
KitHero2[2] = { 0, 0, 0, 0}
KitHero2[3] = { 0, 0, 0, 0}
KitHero2[4] = { 0, 0, 0, 0}
KitHero2[5] = { 0, 0, 0, 0}
KitHero2[6] = { 0, 0, 0, 0}
KitHero2[7] = { 0, 0, 0, 0}
KitHero2[8] = { 0, 0, 0, 0}

KitHeroRace = {}
KitHeroRace[1] = { 0, 0, 0, 0, 0, 0, 0, 0}
KitHeroRace[2] = { 0, 0, 0, 0, 0, 0, 0, 0}

PostersCherkHero1XY = {}
PostersCherkHero1XY[1] = { { ["x"] = 31, ["y"] = 89}, { ["x"] = 32, ["y"] = 89}, { ["x"] = 33, ["y"] = 89}, { ["x"] = 34, ["y"] = 89} }
PostersCherkHero1XY[2] = { { ["x"] = 31, ["y"] = 88}, { ["x"] = 32, ["y"] = 88}, { ["x"] = 33, ["y"] = 88}, { ["x"] = 34, ["y"] = 88} }
PostersCherkHero1XY[3] = { { ["x"] = 36, ["y"] = 89}, { ["x"] = 37, ["y"] = 89}, { ["x"] = 38, ["y"] = 89}, { ["x"] = 39, ["y"] = 89} }
PostersCherkHero1XY[4] = { { ["x"] = 36, ["y"] = 88}, { ["x"] = 37, ["y"] = 88}, { ["x"] = 38, ["y"] = 88}, { ["x"] = 39, ["y"] = 88} }
PostersCherkHero1XY[5] = { { ["x"] = 31, ["y"] = 85}, { ["x"] = 32, ["y"] = 85}, { ["x"] = 33, ["y"] = 85}, { ["x"] = 34, ["y"] = 85} }
PostersCherkHero1XY[6] = { { ["x"] = 31, ["y"] = 84}, { ["x"] = 32, ["y"] = 84}, { ["x"] = 33, ["y"] = 84}, { ["x"] = 34, ["y"] = 84} }
PostersCherkHero1XY[7] = { { ["x"] = 36, ["y"] = 85}, { ["x"] = 37, ["y"] = 85}, { ["x"] = 38, ["y"] = 85}, { ["x"] = 39, ["y"] = 85} }
PostersCherkHero1XY[8] = { { ["x"] = 36, ["y"] = 84}, { ["x"] = 37, ["y"] = 84}, { ["x"] = 38, ["y"] = 84}, { ["x"] = 39, ["y"] = 84} }

PostersCherkHero2XY = {}
PostersCherkHero2XY[1] = { { ["x"] = 38, ["y"] = 24}, { ["x"] = 39, ["y"] = 24}, { ["x"] = 40, ["y"] = 24}, { ["x"] = 41, ["y"] = 24} }
PostersCherkHero2XY[2] = { { ["x"] = 38, ["y"] = 23}, { ["x"] = 39, ["y"] = 23}, { ["x"] = 40, ["y"] = 23}, { ["x"] = 41, ["y"] = 23} }
PostersCherkHero2XY[3] = { { ["x"] = 43, ["y"] = 24}, { ["x"] = 44, ["y"] = 24}, { ["x"] = 45, ["y"] = 24}, { ["x"] = 46, ["y"] = 24} }
PostersCherkHero2XY[4] = { { ["x"] = 43, ["y"] = 23}, { ["x"] = 44, ["y"] = 23}, { ["x"] = 45, ["y"] = 23}, { ["x"] = 46, ["y"] = 23} }
PostersCherkHero2XY[5] = { { ["x"] = 38, ["y"] = 20}, { ["x"] = 39, ["y"] = 20}, { ["x"] = 40, ["y"] = 20}, { ["x"] = 41, ["y"] = 20} }
PostersCherkHero2XY[6] = { { ["x"] = 38, ["y"] = 19}, { ["x"] = 39, ["y"] = 19}, { ["x"] = 40, ["y"] = 19}, { ["x"] = 41, ["y"] = 19} }
PostersCherkHero2XY[7] = { { ["x"] = 43, ["y"] = 20}, { ["x"] = 44, ["y"] = 20}, { ["x"] = 45, ["y"] = 20}, { ["x"] = 46, ["y"] = 20} }
PostersCherkHero2XY[8] = { { ["x"] = 43, ["y"] = 19}, { ["x"] = 44, ["y"] = 19}, { ["x"] = 45, ["y"] = 19}, { ["x"] = 46, ["y"] = 19} }


function CherkOfSetStep1()
  SetObjectPosition('red1', 31, 91, UNDERGROUND);
  SetObjectPosition('red2', 32, 91, UNDERGROUND);
  SetObjectPosition('red3', 33, 91, UNDERGROUND);
  SetObjectPosition('red4', 34, 91, UNDERGROUND);
  SetObjectPosition('red5', 36, 91, UNDERGROUND);
  SetObjectPosition('red6', 37, 91, UNDERGROUND);
  -- SetObjectPosition('red7', 38, 91, UNDERGROUND);
  SetObjectPosition('red8', 39, 91, UNDERGROUND);
  RemoveObject('red9');
  SetObjectPosition('red12', 31, 83, UNDERGROUND);
  SetObjectPosition('red13', 32, 83, UNDERGROUND);
  SetObjectPosition('red14', 33, 83, UNDERGROUND);
  SetObjectPosition('red15', 34, 83, UNDERGROUND);
  SetObjectPosition('red16', 36, 83, UNDERGROUND);
  SetObjectPosition('red17', 37, 83, UNDERGROUND);
  SetObjectPosition('red18', 38, 83, UNDERGROUND);
  SetObjectPosition('red19', 39, 83, UNDERGROUND);
  RemoveObject('red20');
  SetObjectPosition('blue1', 38, 18, UNDERGROUND);
  SetObjectPosition('blue2', 39, 18, UNDERGROUND);
  SetObjectPosition('blue3', 40, 18, UNDERGROUND);
  SetObjectPosition('blue4', 41, 18, UNDERGROUND);
  SetObjectPosition('blue5', 43, 18, UNDERGROUND);
  SetObjectPosition('blue6', 44, 18, UNDERGROUND);
  SetObjectPosition('blue7', 45, 18, UNDERGROUND);
  SetObjectPosition('blue8', 46, 18, UNDERGROUND);
  RemoveObject('blue9');
  SetObjectPosition('blue12', 38, 26, UNDERGROUND);
  SetObjectPosition('blue13', 39, 26, UNDERGROUND);
  SetObjectPosition('blue14', 40, 26, UNDERGROUND);
  SetObjectPosition('blue15', 41, 26, UNDERGROUND);
  SetObjectPosition('blue16', 43, 26, UNDERGROUND);
  SetObjectPosition('blue17', 44, 26, UNDERGROUND);
  SetObjectPosition('blue18', 45, 26, UNDERGROUND);
  SetObjectPosition('blue19', 46, 26, UNDERGROUND);
  RemoveObject('blue20');
  Para = {
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["obj5"] = 'o', ["obj6"] = 'o', ["obj7"] = 'o', ["obj8"] = 'o', ["obj9"] = 'o', ["obj10"] = 'o', ["obj11"] = 'o', ["obj12"] = 'o', ["obj13"] = 'o', ["obj14"] = 'o', ["obj15"] = 'o', ["obj16"] = 'o', ["race1"] =  0, ["race2"] =  0 },
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["obj5"] = 'o', ["obj6"] = 'o', ["obj7"] = 'o', ["obj8"] = 'o', ["obj9"] = 'o', ["obj10"] = 'o', ["obj11"] = 'o', ["obj12"] = 'o', ["obj13"] = 'o', ["obj14"] = 'o', ["obj15"] = 'o', ["obj16"] = 'o', ["race1"] =  0, ["race2"] =  0 },
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["obj5"] = 'o', ["obj6"] = 'o', ["obj7"] = 'o', ["obj8"] = 'o', ["obj9"] = 'o', ["obj10"] = 'o', ["obj11"] = 'o', ["obj12"] = 'o', ["obj13"] = 'o', ["obj14"] = 'o', ["obj15"] = 'o', ["obj16"] = 'o', ["race1"] =  0, ["race2"] =  0 },
   { ["obj1"] = 'o', ["obj2"] = 'o', ["obj3"] = 'o', ["obj4"] = 'o', ["obj5"] = 'o', ["obj6"] = 'o', ["obj7"] = 'o', ["obj8"] = 'o', ["obj9"] = 'o', ["obj10"] = 'o', ["obj11"] = 'o', ["obj12"] = 'o', ["obj13"] = 'o', ["obj14"] = 'o', ["obj15"] = 'o', ["obj16"] = 'o', ["race1"] =  0, ["race2"] =  0 }}
  for i = 1, 2 do
    for k = 1, 8 do
      rnd = random(8) + 1;
      while KitHeroRace[i][rnd] > 0 do
        rnd = random(8) + 1;
      end;
      KitHeroRace[i][rnd] = k;
    end;
  end;
  for j = 1, 8 do
    for k = 1, 4 do
      rnd = random(length(array_heroes[KitHeroRace[1][j] - 1])) + 1;
      while KitHero1[j][1] == rnd or KitHero1[j][2] == rnd or KitHero1[j][3] == rnd or KitHero1[j][4] == rnd or array_heroes[KitHeroRace[1][j] - 1][rnd].block_temply == 1 or array_heroes[KitHeroRace[1][j] - 1][rnd].blocked == 1 do
        rnd = random(length(array_heroes[KitHeroRace[1][j] - 1])) + 1;
      end;
      KitHero1[j][k] = rnd;
      array_heroes[KitHeroRace[1][j] - 1][rnd].block_temply = 1;
    end;
  end;
  for j = 1, 8 do
    for k = 1, 4 do
      rnd = random(length(array_heroes[KitHeroRace[2][j] - 1])) + 1;
      while KitHero2[j][1] == rnd or KitHero2[j][2] == rnd or KitHero2[j][3] == rnd or KitHero2[j][4] == rnd or array_heroes[KitHeroRace[2][j] - 1][rnd].block_temply == 1 or array_heroes[KitHeroRace[2][j] - 1][rnd].blocked == 1 do
        rnd = random(length(array_heroes[KitHeroRace[2][j] - 1])) + 1;
      end;
      KitHero2[j][k] = rnd;
      array_heroes[KitHeroRace[2][j] - 1][rnd].block_temply = 1;
    end;
  end;
  for i = 1, 8 do
    for j = 1, 4 do
      SetObjectPosition(array_PosterRed[i][j], PostersCherkHero1XY[i][j].x, PostersCherkHero1XY[i][j].y, GROUND);
      SetObjectEnabled(array_PosterRed[i][j], nil);
    end;
  end;
  for i = 1, 8 do
    for j = 1, 4 do
      SetObjectPosition(array_PosterBlue[i][j], PostersCherkHero2XY[i][j].x, PostersCherkHero2XY[i][j].y, GROUND);
      SetObjectEnabled(array_PosterBlue[i][j], nil);
    end;
  end;
  sleep(1);
  for j = 1, 8 do
    for k = 1, 4 do
      SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, GROUND);
      SetObjectEnabled(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1,  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
      OverrideObjectTooltipNameAndDescription (array_PosterRed[j][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
      if j < 5 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, 'Step1Set12Q' );
                    Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k],                                'Step1Set12Q' );
               else Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, 'Step1Set11Q' );
                    Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k],                                'Step1Set11Q' ); end;
    end;
  end;
  for j = 1, 8 do
    for k = 1, 4 do
      SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, GROUND);
      SetObjectEnabled(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2,  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
      OverrideObjectTooltipNameAndDescription (array_PosterBlue[j][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
      if j < 5 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, 'Step1Set22Q' );
                    Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k],                               'Step1Set22Q' );
               else Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, 'Step1Set21Q' );
                    Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k],                               'Step1Set21Q' ); end;
    end;
  end;
end;

function Step1Set11Q()
  if DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."SetTop.txt", 'Step1Set11', 'no1');
  end;
end;

function Step1Set12Q()
  if DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."SetLow.txt", 'Step1Set12', 'no1');
  end;
end;

function Step1Set21Q()
  if DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."SetTop.txt", 'Step1Set21', 'no2');
  end;
end;

function Step1Set22Q()
  if DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."SetLow.txt", 'Step1Set22', 'no2');
  end;
end;

Count = 0;

function Step1Set11()
  for j = 5, 8 do
    for k = 1, 4 do
      SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      SetObjectPosition(array_PosterRed[j][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
    end;
    KitHeroRace[1][j] = 0;
  end;
  Count = Count + 1;
  if Count == 2 then hodi1(heroes2[0]); CherkOfSetStep2(); else stop(heroes1[0]); end;
end;

function Step1Set12()
  for j = 1, 4 do
    for k = 1, 4 do
      SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      SetObjectPosition(array_PosterRed[j][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
    end;
    KitHeroRace[1][j] = 0;
  end;
  Count = Count + 1;
  if Count == 2 then hodi1(heroes2[0]); CherkOfSetStep2(); else stop(heroes1[0]); end;
end;

function Step1Set21()
  for j = 5, 8 do
    for k = 1, 4 do
      SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
      SetObjectPosition(array_PosterBlue[j][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
    end;
    KitHeroRace[2][j] = 0;
  end;
  Count = Count + 1;
  if Count == 2 then hodi1(heroes1[0]); CherkOfSetStep2(); else stop(heroes2[0]); end;
end;

function Step1Set22()
  for j = 1, 4 do
    for k = 1, 4 do
      SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
      SetObjectPosition(array_PosterBlue[j][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
    end;
    KitHeroRace[2][j] = 0;
  end;
  Count = Count + 1;
  if Count == 2 then hodi1(heroes1[0]); CherkOfSetStep2(); else stop(heroes2[0]); end;
end;


function CherkOfSetStep2()
  Count = 0;
  DisableBagPlayer1 = 0;
  DisableBagPlayer2 = 0;
  ShowFlyingSign(GetMapDataPath().."CherkOfSetStep2.txt", heroes1[0], 1, 5.0);
  ShowFlyingSign(GetMapDataPath().."CherkOfSetStep2.txt", heroes2[0], 2, 5.0);
  for j = 1, 8 do
    for k = 1, 4 do
      if j < 5 then
        SetObjectPosition(array_PosterRed[j][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, GROUND);
        Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'no' );
      else
        SetObjectPosition(array_PosterRed[j][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, GROUND);
        if j < 7 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step2Set21Q' );
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step2Set22Q' );
        end;
      end;
      if KitHeroRace[1][j] ~= 0 then
        if j > 4 then
          SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, PostersCherkHero1XY[j - 4][k].x, PostersCherkHero1XY[j - 4][k].y, GROUND);
          OverrideObjectTooltipNameAndDescription (array_PosterRed[j - 4][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
          SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, GROUND);
          SetObjectEnabled(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3,  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
          OverrideObjectTooltipNameAndDescription (array_PosterRed[j][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
          if j < 7 then
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, 'Step2Set21Q' );
          else
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, 'Step2Set22Q' );
          end;
        else
          SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, PostersCherkHero2XY[j + 4][k].x, PostersCherkHero2XY[j + 4][k].y, GROUND);
          SetObjectEnabled(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3,  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
          OverrideObjectTooltipNameAndDescription (array_PosterRed[j + 4][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
          if j < 3 then
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, 'Step2Set21Q' );
          else
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, 'Step2Set22Q' );
          end;
        end;
        Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, 'no' );
      end;
    end;
  end;
  for j = 1, 8 do
    for k = 1, 4 do
      if j < 5 then
        SetObjectPosition(array_PosterBlue[j][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, GROUND);
        Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'no' );
      else
        SetObjectPosition(array_PosterBlue[j][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, GROUND);
        if j < 7 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step2Set11Q' );
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step2Set12Q' );
        end;
      end;
      if KitHeroRace[2][j] ~= 0 then
        if j > 4 then
          SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, PostersCherkHero2XY[j - 4][k].x, PostersCherkHero2XY[j - 4][k].y, GROUND);
          OverrideObjectTooltipNameAndDescription (array_PosterBlue[j - 4][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
          SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, GROUND);
          SetObjectEnabled(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4,  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
          OverrideObjectTooltipNameAndDescription (array_PosterBlue[j][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
          if j < 7 then
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, 'Step2Set11Q' );
          else
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, 'Step2Set12Q' );
          end;
        else
          SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, PostersCherkHero1XY[j + 4][k].x, PostersCherkHero1XY[j + 4][k].y, GROUND);
          SetObjectEnabled(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4,  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
          OverrideObjectTooltipNameAndDescription (array_PosterBlue[j + 4][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
          if j < 3 then
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, 'Step2Set11Q' );
          else
            Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, 'Step2Set12Q' );
          end;
        end;
        Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, 'no' );
      end;
    end;
  end;
end;

function Step2Set11Q()
  if DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."SetLeft.txt", 'Step2Set11', 'no1');
  end;
end;

function Step2Set12Q()
  if DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."SetRight.txt", 'Step2Set12', 'no1');
  end;
end;

function Step2Set21Q()
  if DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."SetLeft.txt", 'Step2Set21', 'no2');
  end;
end;

function Step2Set22Q()
  if DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."SetRight.txt", 'Step2Set22', 'no2');
  end;
end;

function Step2Set11()
  for j = 1, 8 do
    if j == 1 or j == 2 or j == 5 or j == 6 then
      if KitHeroRace[2][j] ~= 0 then
        for k = 1, 4 do
          SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterBlue[5][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterBlue[6][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        end;
        KitHeroRace[2][j] = KitHeroRace[2][j] + 8;
      end;
    end;
  end;
  Count = Count + 1;
  if Count == 2 then CherkOfSetStep3(); else stop(heroes1[0]); end;
end;

function Step2Set12()
  for j = 1, 8 do
    if j == 3 or j == 4 or j == 7 or j == 8 then
      if KitHeroRace[2][j] ~= 0 then
        for k = 1, 4 do
          SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterBlue[7][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterBlue[8][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        end;
        KitHeroRace[2][j] = KitHeroRace[2][j] + 8;
      end;
    end;
  end;
  Count = Count + 1;
  if Count == 2 then CherkOfSetStep3(); else stop(heroes1[0]); end;
end;

function Step2Set21()
  for j = 1, 8 do
    if j == 1 or j == 2 or j == 5 or j == 6 then
      if KitHeroRace[1][j] ~= 0 then
        for k = 1, 4 do
          SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterRed[5][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterRed[6][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        end;
        KitHeroRace[1][j] = KitHeroRace[1][j] + 8;
      end;
    end;
  end;
  Count = Count + 1;
  if Count == 2 then hodi1(heroes1[0]); stop(heroes2[0]); CherkOfSetStep3(); else stop(heroes2[0]); end;
end;

function Step2Set22()
  for j = 1, 8 do
    if j == 3 or j == 4 or j == 7 or j == 8 then
      if KitHeroRace[1][j] ~= 0 then
        for k = 1, 4 do
          SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterRed[7][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
          SetObjectPosition(array_PosterRed[8][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        end;
        KitHeroRace[1][j] = KitHeroRace[1][j] + 8;
      end;
    end;
  end;
  Count = Count + 1;
  if Count == 2 then hodi1(heroes1[0]); stop(heroes2[0]); CherkOfSetStep3(); else stop(heroes2[0]); end;
end;

function CherkOfSetStep3()
  DisableBagPlayer1 = 0;
  DisableBagPlayer2 = 0;
  for j = 1, 8 do
    if KitHeroRace[1][j] > 8 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-9][KitHero1[j][k]].p1, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
      KitHeroRace[1][j] = 0;
    end;
  end;
  for j = 1, 8 do
    if KitHeroRace[2][j] > 8 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-9][KitHero2[j][k]].p2, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
      end;
      KitHeroRace[2][j] = 0;
    end;
  end;
  ShowFlyingSign(GetMapDataPath().."variant6.txt", heroes1[0], 1, 5.0);
  PosterCount = 1;
  ParaCount = 1;
  for j = 1, 8 do
    for k = 1, 4 do
      if j == 1 or j == 3 or j == 5 or j == 7 then
        SetObjectPosition(array_PosterRed[j][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, GROUND);
        if j == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set1Q' );
        elseif j == 3 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set2Q' );
        elseif j == 5 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set3Q' );
        elseif j == 7 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set4Q' );
        end;
      else
        SetObjectPosition(array_PosterRed[j][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, GROUND);
        if j == 2 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set1Q' );
        elseif j == 4 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set2Q' );
        elseif j == 6 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set3Q' );
        elseif j == 8 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterRed[j][k], 'Step3Set4Q' );
        end;
      end;
    end;
    if KitHeroRace[1][j] ~= 0 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, PostersCherkHero1XY[PosterCount][k].x, PostersCherkHero1XY[PosterCount][k].y,     GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterRed[2 * ParaCount - 1][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        if ParaCount == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, 'Step3Set1Q' );
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, 'Step3Set3Q' );
        end;
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, PostersCherkHero2XY[PosterCount + 1][k].x, PostersCherkHero2XY[PosterCount + 1][k].y, GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterRed[2 * ParaCount][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        if ParaCount == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, 'Step3Set1Q' );
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, 'Step3Set3Q' );
        end;
      end;
      Para[ParaCount].race1 = KitHeroRace[1][j];
      PosterCount = PosterCount + 2;
      ParaCount = ParaCount + 1;
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5, PostersCherkHero1XY[PosterCount][k].x,     PostersCherkHero1XY[PosterCount][k].y,     GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterRed[2 * ParaCount - 1][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        if ParaCount == 2 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5, 'Step3Set2Q' );
          SetObjectEnabled(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5,  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5, 'Step3Set4Q' );
          SetObjectEnabled(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5,  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        end;
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7, PostersCherkHero2XY[PosterCount + 1][k].x, PostersCherkHero2XY[PosterCount + 1][k].y, GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterRed[2 * ParaCount][k],  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        if ParaCount == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7, 'Step3Set2Q' );
          SetObjectEnabled(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7,  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7, 'Step3Set4Q' );
          SetObjectEnabled(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7,  GetMapDataPath()..array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].txt, array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].dsc);
        end;
      end;
      Para[ParaCount].race1 = KitHeroRace[1][j];
      PosterCount = PosterCount + 2;
      ParaCount = ParaCount + 1;
    end;
  end;
  PosterCount = 1;
  ParaCount = 1;
  for j = 1, 8 do
    for k = 1, 4 do
      if j == 1 or j == 3 or j == 5 or j == 7 then
        SetObjectPosition(array_PosterBlue[j][k], PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, GROUND);
        if j == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set1Q' );
        elseif j == 3 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set2Q' );
        elseif j == 5 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set3Q' );
        elseif j == 7 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set4Q' );
        end;
      else
        SetObjectPosition(array_PosterBlue[j][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, GROUND);
        if j == 2 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set1Q' );
        elseif j == 4 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set2Q' );
        elseif j == 6 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set3Q' );
        elseif j == 8 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_PosterBlue[j][k], 'Step3Set4Q' );
        end;
      end;
    end;
    if KitHeroRace[2][j] ~= 0 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, PostersCherkHero2XY[PosterCount][k].x,     PostersCherkHero2XY[PosterCount][k].y,     GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterBlue[2 * ParaCount - 1][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
        if ParaCount == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, 'Step3Set1Q' );
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, 'Step3Set2Q' );
        end;
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, PostersCherkHero1XY[PosterCount + 1][k].x, PostersCherkHero1XY[PosterCount + 1][k].y, GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterBlue[2 * ParaCount][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
        if ParaCount == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, 'Step3Set1Q' );
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, 'Step3Set2Q' );
        end;
      end;
      Para[ParaCount].race2 = KitHeroRace[2][j];
      PosterCount = PosterCount + 4;
      ParaCount = ParaCount + 2;
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6, PostersCherkHero2XY[PosterCount][k].x,     PostersCherkHero2XY[PosterCount][k].y,     GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterBlue[2 * ParaCount - 1][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
        if ParaCount == 3 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6, 'Step3Set3Q' );
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6,  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
          SetObjectEnabled(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6, nil);
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6, 'Step3Set4Q' );
          SetObjectEnabled(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6,  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
        end;
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8, PostersCherkHero1XY[PosterCount + 1][k].x, PostersCherkHero1XY[PosterCount + 1][k].y, GROUND);
        OverrideObjectTooltipNameAndDescription (array_PosterBlue[2 * ParaCount][k],  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
        if ParaCount == 1 then
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8, 'Step3Set3Q' );
          SetObjectEnabled(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8,  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
        else
          Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8, 'Step3Set4Q' );
          SetObjectEnabled(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8, nil);
          OverrideObjectTooltipNameAndDescription (array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8,  GetMapDataPath()..array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].txt, array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].dsc);
        end;
      end;
      Para[ParaCount].race2 = KitHeroRace[2][j];
      PosterCount = PosterCount - 2;
      ParaCount = ParaCount - 1;
    end;
  end;
end;

function Step3Set1Q(hero)
  if GetObjectOwner(hero) == 1 and DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    ParaDel = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no1');
  end;
  if GetObjectOwner(hero) == 2 and DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    ParaDel = 1;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no2');
  end;
end;

function Step3Set2Q(hero)
  if GetObjectOwner(hero) == 1 and DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    ParaDel = 2;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no1');
  end;
  if GetObjectOwner(hero) == 2 and DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    ParaDel = 2;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no2');
  end;
end;

function Step3Set3Q(hero)
  if GetObjectOwner(hero) == 1 and DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    ParaDel = 3;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no1');
  end;
  if GetObjectOwner(hero) == 2 and DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    ParaDel = 3;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no2');
  end;
end;

function Step3Set4Q(hero)
  if GetObjectOwner(hero) == 1 and DisableBagPlayer1 == 0 then
    DisableBagPlayer1 = 1;
    ParaDel = 4;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no1');
  end;
  if GetObjectOwner(hero) == 2 and DisableBagPlayer2 == 0 then
    DisableBagPlayer2 = 1;
    ParaDel = 4;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."QuestionMatchup.txt", 'Step4', 'no2');
  end;
end;

function Step4(player)
  if ParaDel == 1 then
    ParaDel1(ParaDel);
  end;
  if ParaDel == 2 then
    ParaDel2(ParaDel);
  end;
  if ParaDel == 3 then
    ParaDel3(ParaDel);
  end;
  if ParaDel == 4 then
    ParaDel4(ParaDel);
  end;
  if player == 1 then
    stop(heroes1[0]);
    hodi1(heroes2[0]);
    ShowFlyingSign(GetMapDataPath().."variant6.txt", heroes2[0], 2, 5.0);
  end;
  if player == 2 then
    stop(heroes2[0]);
    sleep(4);
    rnd = random(2);
    if rnd == 0 then
      if Para[1].race1 ~= 0 then hero1race = Para[1].race1; hero2race = Para[1].race2; num = 1;
      else
        if Para[2].race1 ~= 0 then hero1race = Para[2].race1; hero2race = Para[2].race2; num = 2;
        else hero1race = Para[3].race1; hero2race = Para[3].race2; num = 3;
        end;
      end;
    else
      if Para[4].race1 ~= 0 then hero1race = Para[4].race1; hero2race = Para[4].race2; num = 4;
      else
        if Para[3].race1 ~= 0 then hero1race = Para[3].race1; hero2race = Para[3].race2; num = 3;
        else hero1race = Para[2].race1; hero2race = Para[2].race2; num = 2;
        end;
      end;
    end;
    for i = 1, 4 do
      if Para[i].race1 ~= 0 then
        if num ~= i then
          if i == 1 then
            ParaDel1(i);
          elseif i == 2 then
            ParaDel2(i);
          elseif i == 3 then
            ParaDel3(i);
          elseif i == 4 then
            ParaDel4(i);
          end;
        end;
      end;
    end;
    sleep(4);
    for i = 1, 4 do
      if num == i then
        if i == 1 then
          ParaDel1(i);
        elseif i == 2 then
          ParaDel2(i);
        elseif i == 3 then
          ParaDel3(i);
        elseif i == 4 then
          ParaDel4(i);
        end;
      end;
    end;

    x11=41; x12=44; y11=78; y12=78;
    x21=43; x22=41; y21=15; y22=15;
    sleep(3);

    for i = 1, 8 do
      for j = 1, 4 do
        if KitHeroRace[1][i] == hero1race then
          arrayPossibleHeroes[0][j] = KitHero1[i][j];
          arrayPossibleHeroes[1][j] = KitHero1[i][j];
        end;
      end;
    end;
    for i = 1, 8 do
      for j = 1, 4 do
        if KitHeroRace[2][i] == hero2race then
          arrayPossibleHeroes[2][j] = KitHero2[i][j];
          arrayPossibleHeroes[3][j] = KitHero2[i][j];
        end;
      end;
    end;

    HeroCollectionPlayer1 = 0;
    HeroCollectionPlayer2 = 2;
    CherkFinish = 0;
    
    add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
    add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
    unreserve();

  end;
    
end;

function ParaDel1(n)
  for j = 1, 8 do
    if KitHeroRace[1][j] == Para[n].race1 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[1][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[2][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
    if KitHeroRace[2][j] == Para[n].race2 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[1][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[2][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
  end;
  Para[n].race1 = 0;
  Para[n].race2 = 0;
end;

function ParaDel2(n)
  for j = 1, 8 do
    if KitHeroRace[1][j] == Para[n].race1 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[3][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[4][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
    if KitHeroRace[2][j] == Para[n].race2 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p2, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p4, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[3][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[4][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
  end;
  Para[n].race1 = 0;
  Para[n].race2 = 0;
end;

function ParaDel3(n)
  for j = 1, 8 do
    if KitHeroRace[1][j] == Para[n].race1 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p1, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p3, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[5][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[6][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
    if KitHeroRace[2][j] == Para[n].race2 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[5][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[6][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
  end;
  Para[n].race1 = 0;
  Para[n].race2 = 0;
end;

function ParaDel4(n)
  for j = 1, 8 do
    if KitHeroRace[1][j] == Para[n].race1 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p5, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[1][j]-1][KitHero1[j][k]].p7, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[7][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterRed[8][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
    if KitHeroRace[2][j] == Para[n].race2 then
      for k = 1, 4 do
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p6, PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_heroes[KitHeroRace[2][j]-1][KitHero2[j][k]].p8, PostersCherkHero2XY[j][k].x, PostersCherkHero2XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[7][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
        SetObjectPosition(array_PosterBlue[8][k], PostersCherkHero1XY[j][k].x, PostersCherkHero1XY[j][k].y, UNDERGROUND);
      end;
    end;
  end;
  Para[n].race1 = 0;
  Para[n].race2 = 0;
end;


---------------  СМЕШАННЫЙ ЧЕРК ГЕРОЕВ И РАС ---------


array1_PosterRed = {}
array1_PosterRed = { "PosterRed_1",  "PosterRed_2",  "PosterRed_3",  "PosterRed_4",  "PosterRed_5",  "PosterRed_6",  "PosterRed_7",  "PosterRed_8",
                     "PosterRed_9",  "PosterRed_10", "PosterRed_11", "PosterRed_12", "PosterRed_13", "PosterRed_14", "PosterRed_15", "PosterRed_16",
                     "PosterRed_17", "PosterRed_18", "PosterRed_19", "PosterRed_20", "PosterRed_21", "PosterRed_22", "PosterRed_23", "PosterRed_24",
                     "PosterRed_25", "PosterRed_26", "PosterRed_27", "PosterRed_28", "PosterRed_29", "PosterRed_30", "PosterRed_31", "PosterRed_32" }

array1_PosterBlue = {}
array1_PosterBlue = { "PosterBlue_1",  "PosterBlue_2",  "PosterBlue_3",  "PosterBlue_4",  "PosterBlue_5",  "PosterBlue_6",  "PosterBlue_7",  "PosterBlue_8",
                      "PosterBlue_9",  "PosterBlue_10", "PosterBlue_11", "PosterBlue_12", "PosterBlue_13", "PosterBlue_14", "PosterBlue_15", "PosterBlue_16",
                      "PosterBlue_17", "PosterBlue_18", "PosterBlue_19", "PosterBlue_20", "PosterBlue_21", "PosterBlue_22", "PosterBlue_23", "PosterBlue_24",
                      "PosterBlue_25", "PosterBlue_26", "PosterBlue_27", "PosterBlue_28", "PosterBlue_29", "PosterBlue_30", "PosterBlue_31", "PosterBlue_32" }

array_MixCherkFill_1 = {}
array_MixCherkFill_2 = {}
array_MixCherkFill_1[1] = {{ ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 32, ["y1"] = 90, ["x2"] = 43, ["y2"] = 25, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 32, ["y1"] = 89, ["x2"] = 43, ["y2"] = 24, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 32, ["y1"] = 88, ["x2"] = 43, ["y2"] = 23, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 32, ["y1"] = 87, ["x2"] = 43, ["y2"] = 22, ["enable"] = 1 }}
array_MixCherkFill_1[2] = {{ ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 33, ["y1"] = 90, ["x2"] = 44, ["y2"] = 25, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 33, ["y1"] = 89, ["x2"] = 44, ["y2"] = 24, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 33, ["y1"] = 88, ["x2"] = 44, ["y2"] = 23, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 33, ["y1"] = 87, ["x2"] = 44, ["y2"] = 22, ["enable"] = 1 }}
array_MixCherkFill_1[3] = {{ ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 34, ["y1"] = 90, ["x2"] = 45, ["y2"] = 25, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 34, ["y1"] = 89, ["x2"] = 45, ["y2"] = 24, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 34, ["y1"] = 88, ["x2"] = 45, ["y2"] = 23, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 34, ["y1"] = 87, ["x2"] = 45, ["y2"] = 22, ["enable"] = 1 }}
array_MixCherkFill_2[1] = {{ ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 39, ["y1"] = 25, ["x2"] = 36, ["y2"] = 90, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 39, ["y1"] = 24, ["x2"] = 36, ["y2"] = 89, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 39, ["y1"] = 23, ["x2"] = 36, ["y2"] = 88, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 39, ["y1"] = 22, ["x2"] = 36, ["y2"] = 87, ["enable"] = 1 }}
array_MixCherkFill_2[2] = {{ ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 40, ["y1"] = 25, ["x2"] = 37, ["y2"] = 90, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 40, ["y1"] = 24, ["x2"] = 37, ["y2"] = 89, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 40, ["y1"] = 23, ["x2"] = 37, ["y2"] = 88, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 40, ["y1"] = 22, ["x2"] = 37, ["y2"] = 87, ["enable"] = 1 }}
array_MixCherkFill_2[3] = {{ ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 41, ["y1"] = 25, ["x2"] = 38, ["y2"] = 90, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 41, ["y1"] = 24, ["x2"] = 38, ["y2"] = 89, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 41, ["y1"] = 23, ["x2"] = 38, ["y2"] = 88, ["enable"] = 1 },
                           { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 41, ["y1"] = 22, ["x2"] = 38, ["y2"] = 87, ["enable"] = 1 }}



array_MixCherk = {}
array_MixCherk = {{ ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 33, ["y1"] = 85, ["x2"] = 40, ["y2"] = 20, ["enable"] = 1 },
                  { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 34, ["y1"] = 85, ["x2"] = 41, ["y2"] = 20, ["enable"] = 1 },
                  { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 35, ["y1"] = 85, ["x2"] = 42, ["y2"] = 20, ["enable"] = 1 },
                  { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 36, ["y1"] = 85, ["x2"] = 43, ["y2"] = 20, ["enable"] = 1 },
                  { ["obj1"] = 0, ["obj2"] = 0, ["race"] = 0, ["hero"] = 0, ["x1"] = 37, ["y1"] = 85, ["x2"] = 44, ["y2"] = 20, ["enable"] = 1 } }

array_FunctionMixCherk = {}
array_FunctionMixCherk[1] = { 'MixCherkStep1Q1', 'MixCherkStep1Q2', 'MixCherkStep1Q3', 'MixCherkStep1Q4', 'MixCherkStep1Q5' }
array_FunctionMixCherk[2] = { 'MixCherkStep2Q1', 'MixCherkStep2Q2', 'MixCherkStep2Q3', 'MixCherkStep2Q4', 'MixCherkStep2Q5', 'MixCherkStep2Q6' }

array_ListRace = {}
array_ListRace = { 0, 0, 0, 0, 0, 0}

function MixCherkStep1()
  SetObjectPosition('red1', 31, 91, UNDERGROUND);
  SetObjectPosition('red2', 32, 91, UNDERGROUND);
  SetObjectPosition('red3', 33, 91, UNDERGROUND);
  SetObjectPosition('red4', 34, 91, UNDERGROUND);
  SetObjectPosition('red5', 36, 91, UNDERGROUND);
  SetObjectPosition('red6', 37, 91, UNDERGROUND);
  -- SetObjectPosition('red7', 38, 91, UNDERGROUND);
  SetObjectPosition('red8', 39, 91, UNDERGROUND);
  RemoveObject('red9');
  SetObjectPosition('red12', 31, 83, UNDERGROUND);
  SetObjectPosition('red13', 32, 83, UNDERGROUND);
  SetObjectPosition('red14', 33, 83, UNDERGROUND);
  SetObjectPosition('red15', 34, 83, UNDERGROUND);
  SetObjectPosition('red16', 36, 83, UNDERGROUND);
  SetObjectPosition('red17', 37, 83, UNDERGROUND);
  SetObjectPosition('red18', 38, 83, UNDERGROUND);
  SetObjectPosition('red19', 39, 83, UNDERGROUND);
  RemoveObject('red20');
  SetObjectPosition('blue1', 38, 18, UNDERGROUND);
  SetObjectPosition('blue2', 39, 18, UNDERGROUND);
  SetObjectPosition('blue3', 40, 18, UNDERGROUND);
  SetObjectPosition('blue4', 41, 18, UNDERGROUND);
  SetObjectPosition('blue5', 43, 18, UNDERGROUND);
  SetObjectPosition('blue6', 44, 18, UNDERGROUND);
  SetObjectPosition('blue7', 45, 18, UNDERGROUND);
  SetObjectPosition('blue8', 46, 18, UNDERGROUND);
  RemoveObject('blue9');
  SetObjectPosition('blue12', 38, 26, UNDERGROUND);
  SetObjectPosition('blue13', 39, 26, UNDERGROUND);
  SetObjectPosition('blue14', 40, 26, UNDERGROUND);
  SetObjectPosition('blue15', 41, 26, UNDERGROUND);
  SetObjectPosition('blue16', 43, 26, UNDERGROUND);
  SetObjectPosition('blue17', 44, 26, UNDERGROUND);
  SetObjectPosition('blue18', 45, 26, UNDERGROUND);
  SetObjectPosition('blue19', 46, 26, UNDERGROUND);
  RemoveObject('blue20');

--  SetObjectPosition('port12', 31, 84, GROUND);
--  SetObjectPosition('port11', 39, 85, GROUND);

--  MoveCameraForPlayers( 1, 31, 88, 0, 20, 0, 0, 0, 0, 1);

  SetObjectPosition(heroes1[0], 35, 84, GROUND);
  SetObjectPosition(heroes2[0], 42, 19, GROUND);
  stop(heroes2[0]);

  SetRegionBlocked ('MixCherk11', true);
  SetRegionBlocked ('MixCherk12', true);
  SetRegionBlocked ('MixCherk21', true);
  SetRegionBlocked ('MixCherk22', true);

  for i = 1, 5 do
    SetObjectPosition(array1_PosterRed[i], array_MixCherk[i].x1, array_MixCherk[i].y1, GROUND);
    SetObjectEnabled (array1_PosterRed[i], nil);
    Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[i], array_FunctionMixCherk[1][i]);
    SetObjectPosition(array1_PosterBlue[i], array_MixCherk[i].x2, array_MixCherk[i].y2, GROUND);
    SetObjectEnabled (array1_PosterBlue[i], nil);
    Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[i], array_FunctionMixCherk[1][i]);
  end;
  
  SetObjectEnabled (array1_PosterRed[6], nil);
  SetObjectEnabled (array1_PosterBlue[6], nil);

  for i = 1, 3 do
    for j = 1, 3 do
      SetObjectPosition(array1_PosterRed[4 + i * 3 + j], array_MixCherkFill_1[i][j].x1, array_MixCherkFill_1[i][j].y1, GROUND);
      SetObjectEnabled (array1_PosterRed[4 + i * 3 + j], nil);
      OverrideObjectTooltipNameAndDescription(array1_PosterRed[4 + i * 3 + j],  GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
      SetObjectPosition(array1_PosterRed[13 + i * 3 + j], array_MixCherkFill_1[i][j].x2, array_MixCherkFill_1[i][j].y2, GROUND);
      SetObjectEnabled (array1_PosterRed[13 + i * 3 + j], nil);
      OverrideObjectTooltipNameAndDescription(array1_PosterRed[13 + i * 3 + j],  GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
      SetObjectPosition(array1_PosterBlue[4 + i * 3 + j], array_MixCherkFill_2[i][j].x1, array_MixCherkFill_2[i][j].y1, GROUND);
      SetObjectEnabled (array1_PosterBlue[4 + i * 3 + j], nil);
      OverrideObjectTooltipNameAndDescription(array1_PosterBlue[4 + i * 3 + j],  GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
      SetObjectPosition(array1_PosterBlue[13 + i * 3 + j], array_MixCherkFill_2[i][j].x2, array_MixCherkFill_2[i][j].y2, GROUND);
      SetObjectEnabled (array1_PosterBlue[13 + i * 3 + j], nil);
      OverrideObjectTooltipNameAndDescription(array1_PosterBlue[13 + i * 3 + j],  GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
    end;
  end;
  
  for i = 1, 6 do
    retry = 0;
    array_ListRace[i] = random(8) + 1;
    if i > 1 then
      for j = 1, (i - 1) do
        if array_ListRace[i] == array_ListRace[j] then retry = 1; end;
      end;
      while retry == 1 do
        retry = 0;
        array_ListRace[i] = random(8) + 1;
        for j = 1, (i - 1) do
          if array_ListRace[i] == array_ListRace[j] then retry = 1; end;
        end;
      end;
    end;
  end;

  for i = 1, 5 do
    rndRace = array_ListRace[i];
    rndHero = random(length(array_heroes[rndRace - 1])) + 1;
    while (array_heroes[rndRace - 1][rndHero].blocked == 1 or array_heroes[rndRace - 1][rndHero].block_temply == 1) do
      rndHero = random(length(array_heroes[rndRace - 1])) + 1;
    end;
    array_heroes[rndRace - 1][rndHero].block_temply = 1;
    array_MixCherk[i].obj1 = array_heroes[rndRace - 1][rndHero].p1;
    array_MixCherk[i].obj2 = array_heroes[rndRace - 1][rndHero].p2;
    array_MixCherk[i].race = rndRace;
    array_MixCherk[i].hero = rndHero;
    SetObjectPosition(array_MixCherk[i].obj1, array_MixCherk[i].x1, array_MixCherk[i].y1, GROUND);
    SetObjectPosition(array_MixCherk[i].obj2, array_MixCherk[i].x2, array_MixCherk[i].y2, GROUND);
    SetObjectEnabled (array_MixCherk[i].obj1, nil);
    SetObjectEnabled (array_MixCherk[i].obj2, nil);
    OverrideObjectTooltipNameAndDescription(array1_PosterRed[i],  GetMapDataPath()..array_heroes[rndRace - 1][rndHero].txt, array_heroes[rndRace - 1][rndHero].dsc);
    OverrideObjectTooltipNameAndDescription(array_MixCherk[i].obj1,  GetMapDataPath()..array_heroes[rndRace - 1][rndHero].txt, array_heroes[rndRace - 1][rndHero].dsc);
    OverrideObjectTooltipNameAndDescription(array1_PosterBlue[i],  GetMapDataPath()..array_heroes[rndRace - 1][rndHero].txt, array_heroes[rndRace - 1][rndHero].dsc);
    OverrideObjectTooltipNameAndDescription(array_MixCherk[i].obj2,  GetMapDataPath()..array_heroes[rndRace - 1][rndHero].txt, array_heroes[rndRace - 1][rndHero].dsc);
    Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherk[i].obj1, array_FunctionMixCherk[1][i]);
    Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherk[i].obj2, array_FunctionMixCherk[1][i]);
  end;

--  ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes2[0], 2, 7.0);
end;

DisableBag = 0;

function MixCherkStep1Q1(hero)
  if DisableBag == 0 then
    DisableBag = 1;
    Pick = 1;
    if GetObjectOwner(hero) == 1 then
      for i = 1, 3 do
        if (array_MixCherkFill_1[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_1[i][3].hero == 0) or (array_MixCherkFill_1[i][1].race == 0 and array_MixCherkFill_1[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_1[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
    if GetObjectOwner(hero) == 2 then
      for i = 1, 3 do
        if (array_MixCherkFill_2[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_2[i][3].hero == 0) or (array_MixCherkFill_2[i][1].race == 0 and array_MixCherkFill_2[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_2[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
  end;
end;

function MixCherkStep1Q2(hero)
  if DisableBag == 0 then
    DisableBag = 1;
    Pick = 2;
    if GetObjectOwner(hero) == 1 then
      for i = 1, 3 do
        if (array_MixCherkFill_1[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_1[i][3].hero == 0) or (array_MixCherkFill_1[i][1].race == 0 and array_MixCherkFill_1[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_1[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
    if GetObjectOwner(hero) == 2 then
      for i = 1, 3 do
        if (array_MixCherkFill_2[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_2[i][3].hero == 0) or (array_MixCherkFill_2[i][1].race == 0 and array_MixCherkFill_2[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_2[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
  end;
end;

function MixCherkStep1Q3(hero)
  if DisableBag == 0 then
    DisableBag = 1;
    Pick = 3;
    if GetObjectOwner(hero) == 1 then
      for i = 1, 3 do
        if (array_MixCherkFill_1[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_1[i][3].hero == 0) or (array_MixCherkFill_1[i][1].race == 0 and array_MixCherkFill_1[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_1[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
    if GetObjectOwner(hero) == 2 then
      for i = 1, 3 do
        if (array_MixCherkFill_2[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_2[i][3].hero == 0) or (array_MixCherkFill_2[i][1].race == 0 and array_MixCherkFill_2[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_2[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
  end;
end;

function MixCherkStep1Q4(hero)
  if DisableBag == 0 then
    DisableBag = 1;
    Pick = 4;
    if GetObjectOwner(hero) == 1 then
      for i = 1, 3 do
        if (array_MixCherkFill_1[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_1[i][3].hero == 0) or (array_MixCherkFill_1[i][1].race == 0 and array_MixCherkFill_1[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_1[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
    if GetObjectOwner(hero) == 2 then
      for i = 1, 3 do
        if (array_MixCherkFill_2[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_2[i][3].hero == 0) or (array_MixCherkFill_2[i][1].race == 0 and array_MixCherkFill_2[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_2[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
  end;
end;

function MixCherkStep1Q5(hero)
  if DisableBag == 0 then
    DisableBag = 1;
    Pick = 5;
    if GetObjectOwner(hero) == 1 then
      for i = 1, 3 do
        if (array_MixCherkFill_1[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_1[i][3].hero == 0) or (array_MixCherkFill_1[i][1].race == 0 and array_MixCherkFill_1[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_1[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
    if GetObjectOwner(hero) == 2 then
      for i = 1, 3 do
        if (array_MixCherkFill_2[i][1].race == array_MixCherk[Pick].race and array_MixCherkFill_2[i][3].hero == 0) or (array_MixCherkFill_2[i][1].race == 0 and array_MixCherkFill_2[1][1].race ~= array_MixCherk[Pick].race and array_MixCherkFill_2[2][1].race ~= array_MixCherk[Pick].race) then
          QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."HeroAddQuestion.txt", 'MixCherkPick', 'no1');
          i = 3;
        else
          DisableBag = 0;
        end;
      end;
    end;
  end;
end;


PickNum = 0;

function MixCherkPick(player)
  if player == 1 then
    if PickNum == 0 then ShowFlyingSign(GetMapDataPath().."MixCherkDSCRP5.txt", heroes2[0], 2, 5.0); end;
    DisableBag = 0;
    for i = 1, 3 do
      if array_MixCherkFill_1[i][1].race == array_MixCherk[Pick].race or array_MixCherkFill_1[i][1].race == 0 then
        for j = 1, 3 do
          if array_MixCherkFill_1[i][j].hero == 0 then
            stop(heroes1[0]);
            hodi1(heroes2[0]);
            array_MixCherkFill_1[i][j].obj1 = array_MixCherk[Pick].obj1;
            array_MixCherkFill_1[i][j].obj2 = array_MixCherk[Pick].obj2;
            SetObjectPosition(array_MixCherk[Pick].obj1, array_MixCherkFill_1[i][j].x1, array_MixCherkFill_1[i][j].y1, GROUND);
            SetObjectPosition(array_MixCherk[Pick].obj2, array_MixCherkFill_1[i][j].x2, array_MixCherkFill_1[i][j].y2, GROUND);
            array_MixCherkFill_1[i][j].race = array_MixCherk[Pick].race;
            array_MixCherkFill_1[i][j].hero = array_MixCherk[Pick].hero;
            OverrideObjectTooltipNameAndDescription(array1_PosterRed[4 + i * 3 + j], GetMapDataPath()..array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].txt, array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].dsc);
            OverrideObjectTooltipNameAndDescription(array1_PosterRed[13 + i * 3 + j], GetMapDataPath()..array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].txt, array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].dsc);

--            PickNum = PickNum + 1; --удалить
            sleep(2);
--            if PickNum < 9 then  --удалить
--            MixCherkNewHero( 1, array_MixCherkFill_1[1][1].race, array_MixCherkFill_1[2][1].race, array_MixCherkFill_1[3][1].race, Pick);
--            MixCherkNewHeroWithReturn( 1, array_MixCherkFill_1[1][1].race, array_MixCherkFill_1[2][1].race, array_MixCherkFill_1[3][1].race, Pick);
--ОКОНЧАТЕЛЬНЫЙ
              MixCherkNewHero( 2, array_MixCherkFill_2[1][1].race, array_MixCherkFill_2[2][1].race, array_MixCherkFill_2[3][1].race, Pick);
              MixCherkNewHeroWithReturn( 2, array_MixCherkFill_2[1][1].race, array_MixCherkFill_2[2][1].race, array_MixCherkFill_2[3][1].race, Pick);
--            end; --удалить
            j = 3;
            i = 3;
          end;
        end;
      end;
    end;
  end;
  
  if player == 2 then
    DisableBag = 0;
    for i = 1, 3 do
      if array_MixCherkFill_2[i][1].race == array_MixCherk[Pick].race or array_MixCherkFill_2[i][1].race == 0 then
        for j = 1, 3 do
          if array_MixCherkFill_2[i][j].hero == 0 then
            stop(heroes2[0]);
            hodi1(heroes1[0]);
            array_MixCherkFill_2[i][j].obj1 = array_MixCherk[Pick].obj1;
            array_MixCherkFill_2[i][j].obj2 = array_MixCherk[Pick].obj2;
            SetObjectPosition(array_MixCherk[Pick].obj1, array_MixCherkFill_2[i][j].x1, array_MixCherkFill_2[i][j].y1, GROUND);
            SetObjectPosition(array_MixCherk[Pick].obj2, array_MixCherkFill_2[i][j].x2, array_MixCherkFill_2[i][j].y2, GROUND);
            array_MixCherkFill_2[i][j].race = array_MixCherk[Pick].race;
            array_MixCherkFill_2[i][j].hero = array_MixCherk[Pick].hero;
            OverrideObjectTooltipNameAndDescription(array1_PosterBlue[4 + i * 3 + j], GetMapDataPath()..array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].txt, array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].dsc);
            OverrideObjectTooltipNameAndDescription(array1_PosterBlue[13 + i * 3 + j], GetMapDataPath()..array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].txt, array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].dsc);
            PickNum = PickNum + 1;

            sleep(2);

            if PickNum < 9 then        -- <18
--              MixCherkNewHero( 2, array_MixCherkFill_2[1][1].race, array_MixCherkFill_2[2][1].race, array_MixCherkFill_2[3][1].race, Pick);
--              MixCherkNewHeroWithReturn( 2, array_MixCherkFill_2[1][1].race, array_MixCherkFill_2[2][1].race, array_MixCherkFill_2[3][1].race, Pick);
--ОКОНЧАТЕЛЬНЫЙ
              MixCherkNewHero( 1, array_MixCherkFill_1[1][1].race, array_MixCherkFill_1[2][1].race, array_MixCherkFill_1[3][1].race, Pick);
              MixCherkNewHeroWithReturn( 1, array_MixCherkFill_1[1][1].race, array_MixCherkFill_1[2][1].race, array_MixCherkFill_1[3][1].race, Pick);
            else
              j = 3;
              i = 3;
              array_heroes[array_MixCherk[Pick].race - 1][array_MixCherk[Pick].hero].block_temply = 1;
              MixCherkStep2();
            end;

            j = 3;
            i = 3;
          end;
        end;
      end;
    end;
  end;

end;

function MixCherkNewHero( player, race1, race2, race3, slot)
  race = array_ListRace[random(6) + 1];
  if race1 ~= 0 then
    if player == 1 then
      if ((array_MixCherkFill_1[1][3].hero ~= 0 and race2 == 0) or (array_MixCherkFill_1[1][3].hero ~= 0 and array_MixCherkFill_1[2][3].hero ~= 0 and race3 == 0)) == nil then
        while ((race == race1 and array_MixCherkFill_1[1][3].hero == 0) or (race == race2 and array_MixCherkFill_1[2][3].hero == 0) or (race == race3 and array_MixCherkFill_1[3][3].hero == 0)) == nil do
          race = array_ListRace[random(6) + 1];
        end;
      else
        while ((race == race1) or (race == race2)) do
          race = array_ListRace[random(6) + 1];
        end;
      end;
    end;
    if player == 2 then
      if ((array_MixCherkFill_2[1][3].hero ~= 0 and race2 == 0) or (array_MixCherkFill_2[1][3].hero ~= 0 and array_MixCherkFill_2[2][3].hero ~= 0 and race3 == 0)) == nil then
        while ((race == race1 and array_MixCherkFill_2[1][3].hero == 0) or (race == race2 and array_MixCherkFill_2[2][3].hero == 0) or (race == race3 and array_MixCherkFill_2[3][3].hero == 0)) == nil do
          race = array_ListRace[random(6) + 1];
        end;
      else
        while ((race == race1) or (race == race2)) do
          race = array_ListRace[random(6) + 1];
        end;
      end;
    end;
  end;
  count = 1;
  rndHero = random(length(array_heroes[race - 1])) + 1;
  while (array_heroes[race - 1][rndHero].blocked == 1 or array_heroes[race - 1][rndHero].block_temply == 1) do
    rndHero = random(length(array_heroes[race - 1])) + 1;
    count = count + 1;
    if count > 30 then race = random(8) + 1; count = 1; end;
  end;
  array_heroes[race - 1][rndHero].block_temply = 1;
  array_MixCherk[slot].obj1 = array_heroes[race - 1][rndHero].p1;
  array_MixCherk[slot].obj2 = array_heroes[race - 1][rndHero].p2;
  array_MixCherk[slot].race = race;
  array_MixCherk[slot].hero = rndHero;
  SetObjectPosition(array_MixCherk[slot].obj1, array_MixCherk[slot].x1, array_MixCherk[slot].y1, GROUND);
  SetObjectPosition(array_MixCherk[slot].obj2, array_MixCherk[slot].x2, array_MixCherk[slot].y2, GROUND);
  SetObjectEnabled (array_MixCherk[slot].obj1, nil);
  SetObjectEnabled (array_MixCherk[slot].obj2, nil);
  OverrideObjectTooltipNameAndDescription(array1_PosterRed[slot],  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  OverrideObjectTooltipNameAndDescription(array_MixCherk[slot].obj1,  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  OverrideObjectTooltipNameAndDescription(array1_PosterBlue[slot],  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  OverrideObjectTooltipNameAndDescription(array_MixCherk[slot].obj2,  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherk[slot].obj1, array_FunctionMixCherk[1][slot]);
  Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherk[slot].obj2, array_FunctionMixCherk[1][slot]);
end;

function MixCherkNewHeroWithReturn( player, race1, race2, race3, slotNotTouch)
  sleep(2);
  slot = random(5) + 1;
  while slot == slotNotTouch do
    slot = random(5) + 1;
  end;
  array_heroes[array_MixCherk[slot].race - 1][array_MixCherk[slot].hero].block_temply = 0;
  SetObjectPosition(array_MixCherk[slot].obj1, array_MixCherk[slot].x1, array_MixCherk[slot].y1, UNDERGROUND);
  SetObjectPosition(array_MixCherk[slot].obj2, array_MixCherk[slot].x2, array_MixCherk[slot].y2, UNDERGROUND);
  sleep(2);
  
  race = array_ListRace[random(6) + 1];
  if race1 > 0 and race2 > 0 and race3 > 0 then
    if player == 1 then
      while ((race == race1 and array_MixCherkFill_1[1][3].hero == 0) or (race == race2 and array_MixCherkFill_1[2][3].hero == 0) or (race == race3 and array_MixCherkFill_1[3][3].hero == 0)) == nil do
        race = array_ListRace[random(6) + 1];
      end;
    end;
    if player == 2 then
      while ((race == race1 and array_MixCherkFill_2[1][3].hero == 0) or (race == race2 and array_MixCherkFill_2[2][3].hero == 0) or (race == race3 and array_MixCherkFill_2[3][3].hero == 0)) == nil do
        race = array_ListRace[random(6) + 1];
      end;
    end;
  else
    while ((race == race1) or (race == race2)) do
      race = array_ListRace[random(6) + 1];
    end;
  end;
  count = 1;
  rndHero = random(length(array_heroes[race - 1])) + 1;
  while (array_heroes[race - 1][rndHero].blocked == 1 or array_heroes[race - 1][rndHero].block_temply == 1) do
    rndHero = random(length(array_heroes[race - 1])) + 1;
    count = count + 1;
    if count > 30 then race = random(8) + 1; count = 1; end;
  end;
  array_heroes[race - 1][rndHero].block_temply = 1;
  array_MixCherk[slot].obj1 = array_heroes[race - 1][rndHero].p1;
  array_MixCherk[slot].obj2 = array_heroes[race - 1][rndHero].p2;
  array_MixCherk[slot].race = race;
  array_MixCherk[slot].hero = rndHero;
  SetObjectPosition(array_MixCherk[slot].obj1, array_MixCherk[slot].x1, array_MixCherk[slot].y1, GROUND);
  SetObjectPosition(array_MixCherk[slot].obj2, array_MixCherk[slot].x2, array_MixCherk[slot].y2, GROUND);
  SetObjectEnabled (array_MixCherk[slot].obj1, nil);
  SetObjectEnabled (array_MixCherk[slot].obj2, nil);
  OverrideObjectTooltipNameAndDescription(array1_PosterRed[slot],  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  OverrideObjectTooltipNameAndDescription(array_MixCherk[slot].obj1,  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  OverrideObjectTooltipNameAndDescription(array1_PosterBlue[slot],  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  OverrideObjectTooltipNameAndDescription(array_MixCherk[slot].obj2,  GetMapDataPath()..array_heroes[race - 1][rndHero].txt, array_heroes[race - 1][rndHero].dsc);
  Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherk[slot].obj1, array_FunctionMixCherk[1][slot]);
  Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherk[slot].obj2, array_FunctionMixCherk[1][slot]);
end;

function MixCherkStep2()
  SetRegionBlocked ('MixCherk11', false);
  SetRegionBlocked ('MixCherk12', false);
  SetRegionBlocked ('MixCherk21', false);
  SetRegionBlocked ('MixCherk22', false);
  for i = 1, 5 do
    sleep(1);
    if i ~= Pick then
      array_heroes[array_MixCherk[i].race - 1][array_MixCherk[i].hero].block_temply = 0;
      SetObjectPosition(array_MixCherk[i].obj1, array_MixCherk[i].x1, array_MixCherk[i].y1, UNDERGROUND);
      SetObjectPosition(array_MixCherk[i].obj2, array_MixCherk[i].x2, array_MixCherk[i].y2, UNDERGROUND);
    end;
  end;
  for i = 1, 3 do
    race = array_MixCherkFill_1[i][1].race;
    rndHero = random(length(array_heroes[race - 1])) + 1;
    while (array_heroes[race - 1][rndHero].blocked == 1 or array_heroes[race - 1][rndHero].block_temply == 1) do
      rndHero = random(length(array_heroes[race - 1])) + 1;
    end;
    array_heroes[race - 1][rndHero].block_temply = 1;
    array_MixCherkFill_1[i][4].obj1 = array_heroes[race - 1][rndHero].p1;
    array_MixCherkFill_1[i][4].obj2 = array_heroes[race - 1][rndHero].p2;
    array_MixCherkFill_1[i][4].race = race;
    array_MixCherkFill_1[i][4].hero = rndHero;
    SetObjectPosition(array_MixCherkFill_1[i][4].obj1, array_MixCherkFill_1[i][4].x1, array_MixCherkFill_1[i][4].y1, GROUND);
    SetObjectPosition(array_MixCherkFill_1[i][4].obj2, array_MixCherkFill_1[i][4].x2, array_MixCherkFill_1[i][4].y2, GROUND);
    SetObjectEnabled (array_MixCherkFill_1[i][4].obj1, nil);
    SetObjectEnabled (array_MixCherkFill_1[i][4].obj2, nil);
    OverrideObjectTooltipNameAndDescription(array_MixCherkFill_1[i][4].obj1, GetMapDataPath()..array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].txt, array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].dsc);
    OverrideObjectTooltipNameAndDescription(array_MixCherkFill_1[i][4].obj2, GetMapDataPath()..array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].txt, array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].dsc);
    SetObjectPosition(array1_PosterRed[i], array_MixCherkFill_1[i][4].x1, array_MixCherkFill_1[i][4].y1, GROUND);
    SetObjectPosition(array1_PosterRed[i + 3], array_MixCherkFill_1[i][4].x2, array_MixCherkFill_1[i][4].y2, GROUND);
    OverrideObjectTooltipNameAndDescription(array1_PosterRed[i], GetMapDataPath()..array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].txt, array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].dsc);
    OverrideObjectTooltipNameAndDescription(array1_PosterRed[i + 3], GetMapDataPath()..array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].txt, array_heroes[array_MixCherkFill_1[i][4].race - 1][array_MixCherkFill_1[i][4].hero].dsc);
    Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[i], array_FunctionMixCherk[2][i]);
    Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[i + 3], array_FunctionMixCherk[2][i]);
    Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherkFill_1[i][4].obj1, array_FunctionMixCherk[2][i]);
    Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherkFill_1[i][4].obj2, array_FunctionMixCherk[2][i]);
  end;
  for i = 1, 3 do
    race = array_MixCherkFill_2[i][1].race;
    rndHero = random(length(array_heroes[race - 1])) + 1;
    while (array_heroes[race - 1][rndHero].blocked == 1 or array_heroes[race - 1][rndHero].block_temply == 1) do
      rndHero = random(length(array_heroes[race - 1])) + 1;
    end;
    array_heroes[race - 1][rndHero].block_temply = 1;
    array_MixCherkFill_2[i][4].obj1 = array_heroes[race - 1][rndHero].p1;
    array_MixCherkFill_2[i][4].obj2 = array_heroes[race - 1][rndHero].p2;
    array_MixCherkFill_2[i][4].race = race;
    array_MixCherkFill_2[i][4].hero = rndHero;
    SetObjectPosition(array_MixCherkFill_2[i][4].obj1, array_MixCherkFill_2[i][4].x1, array_MixCherkFill_2[i][4].y1, GROUND);
    SetObjectPosition(array_MixCherkFill_2[i][4].obj2, array_MixCherkFill_2[i][4].x2, array_MixCherkFill_2[i][4].y2, GROUND);
    SetObjectEnabled (array_MixCherkFill_2[i][4].obj1, nil);
    SetObjectEnabled (array_MixCherkFill_2[i][4].obj2, nil);
    OverrideObjectTooltipNameAndDescription(array_MixCherkFill_2[i][4].obj1, GetMapDataPath()..array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].txt, array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].dsc);
    OverrideObjectTooltipNameAndDescription(array_MixCherkFill_2[i][4].obj2, GetMapDataPath()..array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].txt, array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].dsc);
    SetObjectPosition(array1_PosterBlue[i], array_MixCherkFill_2[i][4].x1, array_MixCherkFill_2[i][4].y1, GROUND);
    SetObjectPosition(array1_PosterBlue[i + 3], array_MixCherkFill_2[i][4].x2, array_MixCherkFill_2[i][4].y2, GROUND);
    OverrideObjectTooltipNameAndDescription(array1_PosterBlue[i], GetMapDataPath()..array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].txt, array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].dsc);
    OverrideObjectTooltipNameAndDescription(array1_PosterBlue[i + 3], GetMapDataPath()..array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].txt, array_heroes[array_MixCherkFill_2[i][4].race - 1][array_MixCherkFill_2[i][4].hero].dsc);
    Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[i], array_FunctionMixCherk[2][i + 3]);
    Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[i + 3], array_FunctionMixCherk[2][i + 3]);
    Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherkFill_2[i][4].obj1, array_FunctionMixCherk[2][i + 3]);
    Trigger (OBJECT_TOUCH_TRIGGER, array_MixCherkFill_2[i][4].obj2, array_FunctionMixCherk[2][i + 3]);
  end;
  SetObjectPosition(array1_PosterRed[7], array_MixCherkFill_1[1][4].x1, array_MixCherkFill_1[1][4].y1, UNDERGROUND);
  SetObjectPosition(array1_PosterBlue[7], array_MixCherkFill_2[1][4].x1, array_MixCherkFill_2[1][4].y1, UNDERGROUND);
  stop(heroes2[0]);
  hodi1(heroes1[0]);
  ShowFlyingSign(GetMapDataPath().."MixCherkDSCRP4.txt", heroes1[0], 1, 5.0);
  ShowFlyingSign(GetMapDataPath().."MixCherkWait.txt", heroes2[0], 2, 5.0);
end;

function MixCherkDeleteRaceQ()
  if player == 1 then
    choice = 2;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkDelete.txt", 'MixCherkStep2Choice', 'no');
  end;
  if player == 2 then
    choice = 2;
    QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkDelete.txt", 'MixCherkStep2Choice', 'no');
  end;
end;

function MixCherkStep2Q1(hero)
  Pick = 1;
  if GetObjectOwner(hero) == 1 then
    if array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0 and ((array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0) or (array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0) or (array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0)) then
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
  if GetObjectOwner(hero) == 2 then
    if array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0 and ((array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0) or (array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0) or (array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0)) then
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
end;

function MixCherkStep2Q2(hero)
  Pick = 2;
  if GetObjectOwner(hero) == 1 then
    if array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0 and ((array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0) or (array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0) or (array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0)) then
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
  if GetObjectOwner(hero) == 2 then
    if array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0 and ((array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0) or (array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0) or (array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0)) then
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
end;

function MixCherkStep2Q3(hero)
  Pick = 3;
  if GetObjectOwner(hero) == 1 then
    if array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0 and ((array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0) or (array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0) or (array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0)) then
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
  if GetObjectOwner(hero) == 2 then
    if array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0 and ((array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0) or (array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0) or (array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0)) then
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
end;

function MixCherkStep2Q4(hero)
  Pick = 4;
  if GetObjectOwner(hero) == 1 then
    if array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0 and ((array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0) or (array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0) or (array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0)) then
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
  if GetObjectOwner(hero) == 2 then
    if array_MixCherkFill_2[2][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0 and ((array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0) or (array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0) or (array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0)) then
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
end;

function MixCherkStep2Q5(hero)
  Pick = 5;
  if GetObjectOwner(hero) == 1 then
    if array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0 and ((array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0) or (array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0) or (array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0)) then
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
  if GetObjectOwner(hero) == 2 then
    if array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[3][1].race ~= 0 and ((array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0) or (array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0) or (array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0)) then
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
end;

function MixCherkStep2Q6(hero)
  Pick = 6;
  if GetObjectOwner(hero) == 1 then
    if array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0 and ((array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0) or (array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0) or (array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0)) then
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 1;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
  if GetObjectOwner(hero) == 2 then
    if array_MixCherkFill_2[1][1].race ~= 0 and array_MixCherkFill_2[2][1].race ~= 0 and ((array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[2][1].race ~= 0) or (array_MixCherkFill_1[1][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0) or (array_MixCherkFill_1[2][1].race ~= 0 and array_MixCherkFill_1[3][1].race ~= 0)) then
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'MixCherkDeleteRaceQ');
    else
      choice = 1;
      player = 2;
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MixCherkSelect.txt", 'MixCherkStep2Choice', 'no');
    end;
  end;
end;

function MixCherkStep2Choice()
  if choice == 1 then
    if Pick < 4 then
      for i = 1, 3 do
        if i ~= Pick then
          for j = 1, 4 do
            SetObjectPosition(array_MixCherkFill_1[i][j].obj1, array_MixCherkFill_1[i][j].x1, array_MixCherkFill_1[i][j].y1, UNDERGROUND);
            SetObjectPosition(array_MixCherkFill_1[i][j].obj2, array_MixCherkFill_1[i][j].x1, array_MixCherkFill_1[i][j].y1, UNDERGROUND);
            array_MixCherkFill_1[i][j].race = 0;
          end;
        end;
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[i], 'no');
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[i + 3], 'no');
      end;
    else
      for i = 4, 6 do
        if i ~= Pick then
          for j = 1, 4 do
            SetObjectPosition(array_MixCherkFill_2[i - 3][j].obj1, array_MixCherkFill_2[i - 3][j].x1, array_MixCherkFill_2[i - 3][j].y1, UNDERGROUND);
            SetObjectPosition(array_MixCherkFill_2[i - 3][j].obj2, array_MixCherkFill_2[i - 3][j].x1, array_MixCherkFill_2[i - 3][j].y1, UNDERGROUND);
            array_MixCherkFill_2[i - 3][j].race = 0;
          end;
        end;
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[i - 3], 'no');
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[i], 'no');
      end;
    end;
  end;

  if choice == 2 then
    if Pick < 4 then
      for j = 1, 4 do
        SetObjectPosition(array_MixCherkFill_1[Pick][j].obj1, array_MixCherkFill_1[Pick][j].x1, array_MixCherkFill_1[Pick][j].y1, UNDERGROUND);
        SetObjectPosition(array_MixCherkFill_1[Pick][j].obj2, array_MixCherkFill_1[Pick][j].x1, array_MixCherkFill_1[Pick][j].y1, UNDERGROUND);
        array_MixCherkFill_1[Pick][j].race = 0;
      end;
      for j = 1, 3 do
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[4 + Pick * 3 + j], 'no');
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[13 + Pick * 3 + j], 'no');
      end;
      Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[Pick], 'no');
      Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterRed[Pick + 3], 'no');
    else
      for j = 1, 4 do
        SetObjectPosition(array_MixCherkFill_2[Pick - 3][j].obj1, array_MixCherkFill_2[Pick - 3][j].x1, array_MixCherkFill_2[Pick - 3][j].y1, UNDERGROUND);
        SetObjectPosition(array_MixCherkFill_2[Pick - 3][j].obj2, array_MixCherkFill_2[Pick - 3][j].x1, array_MixCherkFill_2[Pick - 3][j].y1, UNDERGROUND);
        array_MixCherkFill_2[Pick - 3][j].race = 0;
      end;
      for j = 1, 3 do
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[4 + (Pick - 3) * 3 + j], 'no');
        Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[13 + (Pick - 3) * 3 + j], 'no');
      end;
      Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[Pick - 3], 'no');
      Trigger (OBJECT_TOUCH_TRIGGER, array1_PosterBlue[Pick], 'no');
    end;
  end;
  
  if choice ~= 0 then
    k = 0;
    for i = 1, 3 do
      if array_MixCherkFill_1[i][1].race == 0 then k = k + 1; else hero1race = array_MixCherkFill_1[i][1].race; end;
      if array_MixCherkFill_2[i][1].race == 0 then k = k + 1; else hero2race = array_MixCherkFill_2[i][1].race; end;
    end;

    if k < 4 then
      if player == 1 then
        stop(heroes1[0]);
        hodi1(heroes2[0]);
        ShowFlyingSign(GetMapDataPath().."MixCherkDSCRP4.txt", heroes2[0], 2, 5.0);
      end;
      if player == 2 then
        stop(heroes2[0]);
        hodi1(heroes1[0]);
        ShowFlyingSign(GetMapDataPath().."MixCherkDSCRP4.txt", heroes1[0], 1, 5.0);
      end;
    else
      stop(heroes1[0]);
      stop(heroes2[0]);
      for i = 1, 3 do
        if array_MixCherkFill_1[i][1].race ~= 0 then
          for j = 1, 4 do
            SetObjectPosition(array_MixCherkFill_1[i][j].obj1, 1, 5 + 3 * i + j, UNDERGROUND);
            SetObjectPosition(array_MixCherkFill_1[i][j].obj2, 2, 5 + 3 * i + j, UNDERGROUND);
          end;
        end;
        if array_MixCherkFill_2[i][1].race ~= 0 then
          for j = 1, 4 do
            SetObjectPosition(array_MixCherkFill_2[i][j].obj1, 3, 5 + 3 * i + j, UNDERGROUND);
            SetObjectPosition(array_MixCherkFill_2[i][j].obj2, 4, 5 + 3 * i + j, UNDERGROUND);
          end;
        end;
      end;
      for i = 1, 25 do
        SetObjectPosition(array1_PosterRed[i], 5, 5 + i, UNDERGROUND);
        SetObjectPosition(array1_PosterBlue[i], 6, 5 + i, UNDERGROUND);
      end;

      x11=41; x12=44; y11=78; y12=78;
      x21=43; x22=41; y21=15; y22=15;
      sleep(3);

      for i = 1, 3 do
        for j = 1, 4 do
          if array_MixCherkFill_1[i][1].race ~= 0 then
            arrayPossibleHeroes[0][j] = array_MixCherkFill_1[i][j].hero;
            arrayPossibleHeroes[1][j] = array_MixCherkFill_1[i][j].hero;
          end;
        end;
      end;
      for i = 1, 3 do
        for j = 1, 4 do
          if array_MixCherkFill_2[i][1].race ~= 0 then
            arrayPossibleHeroes[2][j] = array_MixCherkFill_2[i][j].hero;
            arrayPossibleHeroes[3][j] = array_MixCherkFill_2[i][j].hero;
          end;
        end;
      end;

      HeroCollectionPlayer1 = 0;
      HeroCollectionPlayer2 = 2;
      CherkFinish = 0;

      add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
      add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
      unreserve();

    end;
  end;
end;

if GAME_MODE.MIX then
  stop(heroes1[0]);
  stop(heroes2[0]);
  ShowFlyingSign(GetMapDataPath().."propusk.txt", heroes1[0], 1, 5.0);
  ShowFlyingSign(GetMapDataPath().."propusk.txt", heroes2[0], 2, 5.0);
  MixCherkStep1(); podvariant = 1;
end;

---- ****

function ChoiseMixCherk( g1, g2)
  if g2 == 1 then MixCherkStep1(); podvariant = 1; end;
  if g2 == 2 then CherkOfSetStep1(); podvariant = 2; end;
end;

if GAME_MODE.SIMPLE_CHOOSE then
  text11=SetRace(pl1_race1, 1, 31, 46, 88, 23);
  text12=SetRace(pl1_race2, 1, 31, 46, 86, 21);
  text13=SetRace(pl1_race3, 1, 31, 46, 90, 25);
  text14=SetRace(pl1_race4, 1, 31, 46, 84, 19);
  text21=SetRace(pl2_race1, 2, 38, 39, 23, 88);
  text22=SetRace(pl2_race2, 2, 38, 39, 21, 86);
  text23=SetRace(pl2_race3, 2, 38, 39, 25, 90);
  text24=SetRace(pl2_race4, 2, 38, 39, 19, 84);
end;

vybor=0;

--if GAME_MODE.MATCHUPS then
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'pl1_vopros1' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'pl1_vopros2' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'pl2_vopros1' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'pl2_vopros2' );
--end;

--if GAME_MODE.HALF then
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'pl1_vopros1' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'pl1_vopros2' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'pl1_vopros3' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'pl1_vopros4' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'pl1_vopros5' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'pl1_vopros6' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'pl1_vopros7' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'pl1_vopros8' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'pl2_vopros1' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'pl2_vopros2' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'pl2_vopros3' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'pl2_vopros4' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'pl2_vopros5' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'pl2_vopros6' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'pl2_vopros7' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'pl2_vopros8' );
--end;

--if GAME_MODE.MIX then
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'pl1_vopros1' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'pl1_vopros2' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'pl1_vopros3' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'pl1_vopros4' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'pl1_vopros5' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'pl1_vopros6' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'pl1_vopros7' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'pl1_vopros8' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'pl2_vopros1' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'pl2_vopros2' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'pl2_vopros3' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'pl2_vopros4' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'pl2_vopros5' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'pl2_vopros6' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'pl2_vopros7' );
--  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'pl2_vopros8' );
--end;

if GAME_MODE.SIMPLE_CHOOSE then
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'pl1_vopros1' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'pl1_vopros2' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'pl1_vopros3' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'pl1_vopros4' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'pl1_vopros5' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'pl1_vopros6' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'pl1_vopros7' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'pl1_vopros8' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'pl2_vopros1' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'pl2_vopros2' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'pl2_vopros3' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'pl2_vopros4' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'pl2_vopros5' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'pl2_vopros6' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'pl2_vopros7' );
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'pl2_vopros8' );
end;

function pl1_vopros1()
  if GetDate (DAY) == 2 then
    if reg1block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text11, 'pl1_vybor1', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
--    if reg11block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."nabor.txt", 'nabor1', 'no');
--    end;
  end;
end;

function pl1_vopros2()
  if GetDate (DAY) == 2 then
    if reg2block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text12, 'pl1_vybor2', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
--    if reg12block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."nabor.txt", 'nabor2', 'no');
--    end;
  end;
end;

function pl1_vopros3()
  if GetDate (DAY) == 2 then
    if reg3block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text13, 'pl1_vybor3', 'no');
    end;
  end;
end;

function pl1_vopros4()
  if GetDate (DAY) == 2 then
    if reg4block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text14, 'pl1_vybor4', 'no');
    end;
  end;
end;

function pl1_vopros5()
  if GetDate (DAY) == 2 then
    if reg5block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text21, 'pl1_vybor5', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[0].UR][units[0].UN].price1 * array_units[units[0].UR][units[0].UN].kol)}, 'unit1', 'no');
  end;
--  if GetDate (DAY) == 3 and podvariant == 3 then
--    if reg15block ~= 1 then
--      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."nabor.txt", 'nabor3', 'no');
--    end;
--  end;
end;

function pl1_vopros6()
  if GetDate (DAY) == 2 then
    if reg6block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text22, 'pl1_vybor6', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[1].UR][units[1].UN].price1 * array_units[units[1].UR][units[1].UN].kol)}, 'unit2', 'no');
  end;
--  if GetDate (DAY) == 3 and podvariant == 3 then
--    if reg16block ~= 1 then
--      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."nabor.txt", 'nabor4', 'no');
--    end;
--  end;
end;

function pl1_vopros7()
  if GetDate (DAY) == 2 then
    if reg7block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text23, 'pl1_vybor7', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[2].UR][units[2].UN].price1 * array_units[units[2].UR][units[2].UN].kol)}, 'unit3', 'no');
  end;
end;

function pl1_vopros8()
  if GetDate (DAY) == 2 then
    if reg8block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath()..text24, 'pl1_vybor8', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[3].UR][units[3].UN].price1 * array_units[units[3].UR][units[3].UN].kol)}, 'unit4', 'no');
  end;
end;

function pl2_vopros1()
  if GetDate (DAY) == 2 then
    if reg5block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text21, 'pl2_vybor1', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then --and podvariant == 3 then
--    if reg21block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."nabor.txt", 'nabor5', 'no');
--    end;
  end;
end;

function pl2_vopros2()
  if GetDate (DAY) == 2 then
    if reg6block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text22, 'pl2_vybor2', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then --and podvariant == 3 then
--    if reg22block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."nabor.txt", 'nabor6', 'no');
--    end;
  end;
end;

function pl2_vopros3()
  if GetDate (DAY) == 2 then
    if reg7block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text23, 'pl2_vybor3', 'no');
    end;
  end;
end;

function pl2_vopros4()
  if GetDate (DAY) == 2 then
    if reg8block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text24, 'pl2_vybor4', 'no');
    end;
  end;
end;

function pl2_vopros5()
  if GetDate (DAY) == 2 then
    if reg1block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text11, 'pl2_vybor5', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[4].UR][units[4].UN].price1 * array_units[units[4].UR][units[4].UN].kol)}, 'unit5', 'no');
  end;
--  if GetDate (DAY) == 3 and podvariant == 3 then
--    if reg25block ~= 1 then
--      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."nabor.txt", 'nabor7', 'no');
--    end;
--  end;
end;

function pl2_vopros6()
  if GetDate (DAY) == 2 then
    if reg2block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text12, 'pl2_vybor6', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[5].UR][units[5].UN].price1 * array_units[units[5].UR][units[5].UN].kol)}, 'unit6', 'no');
  end;
--  if GetDate (DAY) == 3 and podvariant == 3 then
--    if reg26block ~= 1 then
--      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."nabor.txt", 'nabor8', 'no');
--    end;
--  end;
end;

function pl2_vopros7()
  if GetDate (DAY) == 2 then
    if reg3block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text13, 'pl2_vybor7', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[6].UR][units[6].UN].price1 * array_units[units[6].UR][units[6].UN].kol)}, 'unit7', 'no');
  end;
end;

function pl2_vopros8()
  if GetDate (DAY) == 2 then
    if reg4block ~= 1 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath()..text14, 'pl2_vybor8', 'no');
    end;
  end;
  if GetDate (DAY) == 3 then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."pokupka_Unit.txt"; eq = (array_units[units[7].UR][units[7].UN].price1 * array_units[units[7].UR][units[7].UN].kol)}, 'unit8', 'no');
  end;
end;

function SetResUnitLevel7 (pl, UR)
  if UR == 1 then SetPlayerResource(pl, CRYSTAL, (GetPlayerResource(pl, CRYSTAL)+16)); end;
  if UR == 2 then SetPlayerResource(pl,  SULFUR, (GetPlayerResource(pl,  SULFUR)+16)); end;
  if UR == 3 then SetPlayerResource(pl, MERCURY, (GetPlayerResource(pl, MERCURY)+20)); end;
  if UR == 4 then SetPlayerResource(pl,     GEM, (GetPlayerResource(pl,     GEM)+14)); end;
  if UR == 5 then SetPlayerResource(pl,     GEM, (GetPlayerResource(pl,     GEM)+16)); end;
  if UR == 6 then SetPlayerResource(pl,  SULFUR, (GetPlayerResource(pl,  SULFUR)+16)); end;
  if UR == 7 then SetPlayerResource(pl, CRYSTAL, (GetPlayerResource(pl, CRYSTAL)+12)); end;
  if UR == 8 then SetPlayerResource(pl, MERCURY, (GetPlayerResource(pl, MERCURY)+12)); end;
end;

function unit1(hero)
  if Unit1Buy == 0 then
    if (GetPlayerResource(1, 6) >= array_units[units[0].UR][units[0].UN].price1 * array_units[units[0].UR][units[0].UN].kol) then
      AddHeroCreatures(HeroMax1, array_units[units[0].UR][units[0].UN].id, array_units[units[0].UR][units[0].UN].kol);
      Unit1Buy = 1;
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  array_units[units[0].UR][units[0].UN].price1 * array_units[units[0].UR][units[0].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;

function unit2(hero)
  if Unit2Buy == 0 then
    if (GetPlayerResource(1, 6) >= array_units[units[1].UR][units[1].UN].price1 * array_units[units[1].UR][units[1].UN].kol) then
      AddHeroCreatures(HeroMax1, array_units[units[1].UR][units[1].UN].id, array_units[units[1].UR][units[1].UN].kol);
      Unit2Buy = 1;
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  array_units[units[1].UR][units[1].UN].price1 * array_units[units[1].UR][units[1].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;

function unit3(hero)
  if Unit3Buy == 0 then
    if (GetPlayerResource(1, 6) >= array_units[units[2].UR][units[2].UN].price1 * array_units[units[2].UR][units[2].UN].kol) then
      AddHeroCreatures(HeroMax1, array_units[units[2].UR][units[2].UN].id, array_units[units[2].UR][units[2].UN].kol);
      Unit3Buy = 1;
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  array_units[units[2].UR][units[2].UN].price1 * array_units[units[2].UR][units[2].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;

function unit4(hero)
  if Unit4Buy == 0 then
    if (GetPlayerResource(1, 6) >= array_units[units[3].UR][units[3].UN].price1 * array_units[units[3].UR][units[3].UN].kol) then
      AddHeroCreatures(HeroMax1, array_units[units[3].UR][units[3].UN].id, array_units[units[3].UR][units[3].UN].kol);
      Unit4Buy = 1;
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  array_units[units[3].UR][units[3].UN].price1 * array_units[units[3].UR][units[3].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;

function unit5(hero)
  if Unit5Buy == 0 then
    if (GetPlayerResource(2, 6) >= array_units[units[4].UR][units[4].UN].price1 * array_units[units[4].UR][units[4].UN].kol) then
      AddHeroCreatures(HeroMax2, array_units[units[4].UR][units[4].UN].id, array_units[units[4].UR][units[4].UN].kol);
      Unit5Buy = 1;
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  array_units[units[4].UR][units[4].UN].price1 * array_units[units[4].UR][units[4].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;

function unit6(hero)
  if Unit6Buy == 0 then
    if (GetPlayerResource(2, 6) >= array_units[units[5].UR][units[5].UN].price1 * array_units[units[5].UR][units[5].UN].kol) then
      AddHeroCreatures(HeroMax2, array_units[units[5].UR][units[5].UN].id, array_units[units[5].UR][units[5].UN].kol);
      Unit6Buy = 1;
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  array_units[units[5].UR][units[5].UN].price1 * array_units[units[5].UR][units[5].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;

function unit7(hero)
  if Unit7Buy == 0 then
    if (GetPlayerResource(2, 6) >= array_units[units[6].UR][units[6].UN].price1 * array_units[units[6].UR][units[6].UN].kol) then
      AddHeroCreatures(HeroMax2, array_units[units[6].UR][units[6].UN].id, array_units[units[6].UR][units[6].UN].kol);
      Unit7Buy = 1;
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  array_units[units[6].UR][units[6].UN].price1 * array_units[units[6].UR][units[6].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;

function unit8(hero)
  if Unit8Buy == 0 then
    if (GetPlayerResource(2, 6) >= array_units[units[7].UR][units[7].UN].price1 * array_units[units[7].UR][units[7].UN].kol) then
      AddHeroCreatures(HeroMax2, array_units[units[7].UR][units[7].UN].id, array_units[units[7].UR][units[7].UN].kol);
      Unit8Buy = 1;
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  array_units[units[7].UR][units[7].UN].price1 * array_units[units[7].UR][units[7].UN].kol));
    else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;
end;


schetchikPl1=0;
schetchikPl2=0;
SecondCherk = -1;

function cherk (pl, race, reg)
  if reg < 5 then
    schetchikPl1=schetchikPl1+1;
    hero1race = hero1race/race;
    regionFinal1 = regionFinal1/reg;
    if SecondCherk == -1 and GAME_MODE.HALF then SetRace (race, 1, (64+schetchikPl1*2+schetchikPl2*2), (65+schetchikPl1*2+schetchikPl2*2), 53, 53);
    else SetRace (race, 1, (64+schetchikPl1*2+schetchikPl2*2), (65+schetchikPl1*2+schetchikPl2*2), 53, 53);
    end;
  end;
  if reg > 4 then
    schetchikPl2=schetchikPl2+1;
    hero2race = hero2race/race;
    regionFinal2 = regionFinal2/reg;
    if SecondCherk == -1 and GAME_MODE.HALF then SetRace (race, 2, (64+schetchikPl1*2+schetchikPl2*2), (65+schetchikPl1*2+schetchikPl2*2), 53, 53);
    else SetRace (race, 2, (64+schetchikPl1*2+schetchikPl2*2), (65+schetchikPl1*2+schetchikPl2*2), 53, 53);
    end;
  end;
  if pl == 1 then
    stop (heroes1[0]);
    hodi1(heroes2[0]);
  end;
  if pl == 2 then
    if ((schetchikPl1+schetchikPl2) ~= 4) and GAME_MODE.HALF then stop (heroes2[0]);
    else stop (heroes2[0]);
    end;
    if ((schetchikPl1+schetchikPl2) ~= 6) then
      hodi1(heroes1[0]);
    end;
  end;
  if GAME_MODE.MIX then
    if schetchikPl1 == 3 then
      if regionFinal1 == 1 then
        reg1block = 1;
      end;
      if regionFinal1 == 2 then
        reg2block = 1;
      end;
      if regionFinal1 == 3 then
        reg3block = 1;
      end;
      if regionFinal1 == 4 then
        reg4block = 1;
      end;
    end;
    if schetchikPl2 == 3 then
      if regionFinal2 == 5 then
        reg5block = 1;
      end;
      if regionFinal2 == 6 then
        reg6block = 1;
      end;
      if regionFinal2 == 7 then
        reg7block = 1;
      end;
      if regionFinal2 == 8 then
        reg8block = 1;
      end;
    end;
  end;
  if GAME_MODE.HALF then
    if schetchikPl1 == 2 and SecondCherk == -1 then
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'no' );
    end;
    if schetchikPl2 == 2 and SecondCherk == -1 then
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'no' );
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'no' );
    end;
    if (schetchikPl1+schetchikPl2) == 4 then
      hodi1(heroes1[0]);
      hodi1(heroes2[0]);
      SecondCherk = random(2);
      if SecondCherk == 0 then
        ShowFlyingSign(GetMapDataPath().."variant4.txt", heroes1[0], 1, 5.0);
        ShowFlyingSign(GetMapDataPath().."variant4.txt", heroes2[0], 2, 5.0);
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'pl1_vopros1' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'pl1_vopros2' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'pl1_vopros3' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'pl1_vopros4' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'pl2_vopros1' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'pl2_vopros2' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'pl2_vopros3' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'pl2_vopros4' );
      end;
      if SecondCherk == 1 then
        ShowFlyingSign(GetMapDataPath().."variant5.txt", heroes1[0], 1, 5.0);
        ShowFlyingSign(GetMapDataPath().."variant5.txt", heroes2[0], 2, 5.0);
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'pl1_vopros5' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'pl1_vopros6' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'pl1_vopros7' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'pl1_vopros8' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'pl2_vopros5' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'pl2_vopros6' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'pl2_vopros7' );
        Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'pl2_vopros8' );
      end;
    end;
  end;
end;

function pl1_vybor1 ()
  pl_vybor ( 1, 1, pl1_race1)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg1block = 1; end;
end;

function pl1_vybor2 ()
  pl_vybor ( 1, 2, pl1_race2)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg2block = 1; end;
end;

function pl1_vybor3 ()
  pl_vybor ( 1, 3, pl1_race3)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg3block = 1; end;
end;

function pl1_vybor4 ()
  pl_vybor ( 1, 4, pl1_race4)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg4block = 1; end;
end;

function pl1_vybor5 ()
  pl_vybor ( 1, 5, pl2_race1)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg5block = 1; end;
end;

function pl1_vybor6 ()
  pl_vybor ( 1, 6, pl2_race2)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg6block = 1; end;
end;

function pl1_vybor7 ()
  pl_vybor ( 1, 7, pl2_race3)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg7block = 1; end;
end;

function pl1_vybor8 ()
  pl_vybor ( 1, 8, pl2_race4)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg8block = 1; end;
end;

function pl2_vybor1 ()
  pl_vybor ( 2, 5, pl2_race1)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg5block = 1; end;
end;

function pl2_vybor2 ()
  pl_vybor ( 2, 6, pl2_race2)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg6block = 1; end;
end;

function pl2_vybor3 ()
  pl_vybor ( 2, 7, pl2_race3)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg7block = 1; end;
end;

function pl2_vybor4 ()
  pl_vybor ( 2, 8, pl2_race4)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg8block = 1; end;
end;

function pl2_vybor5 ()
  pl_vybor ( 2, 1, pl1_race1)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg1block = 1; end;
end;

function pl2_vybor6 ()
  pl_vybor ( 2, 2, pl1_race2)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg2block = 1; end;
end;

function pl2_vybor7 ()
  pl_vybor ( 2, 3, pl1_race3)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg3block = 1; end;
end;

function pl2_vybor8 ()
  pl_vybor ( 2, 4, pl1_race4)
  if GAME_MODE.HALF or GAME_MODE.MIX then reg4block = 1; end;
end;

function pl_vybor(pl, region, race)
  vybor=vybor+1;
--  if GAME_MODE.MATCHUPS then
--    if pl == 1 then hero1race = race; end;
--    if pl == 2 then hero2race = race; end;
--  end;
--  if GAME_MODE.HALF then
--    if pl == 1 then hero2race = race; end;
--    if pl == 2 then hero1race = race; end;
--  end;
  if GAME_MODE.HALF or GAME_MODE.MIX then
    cherk (pl, race, region);
  end;
  if GAME_MODE.SIMPLE_CHOOSE then
    if pl == 1 then hero1race = race; end;
    if (pl == 2 and vybor<3) then hero2race = race; end;
  end;
  if (GAME_MODE.MATCHUPS or GAME_MODE.SIMPLE_CHOOSE) or ((schetchikPl1+schetchikPl2) == 6) then
    x11=41; x12=44; y11=78; y12=78;
    x21=43; x22=41; y21=15; y22=15;
  end;
  if pl == 1 then stop (heroes1[0]); end;
  if pl == 2 and GAME_MODE.MIX then stop (heroes2[0]); end;
  if pl == 2 and GAME_MODE.HALF and (schetchikPl1+schetchikPl2) ~= 4 then stop (heroes2[0]); end;
  if ((GAME_MODE.MATCHUPS or GAME_MODE.SIMPLE_CHOOSE) and vybor == 2) or ((schetchikPl1+schetchikPl2) == 6) then

--    CherkPossibleHeroes();

    SetPossibleHeroes();

--    add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
--    add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
--    unreserve();
  end;
end;

arrayPossibleHeroes = {}
arrayPossibleHeroes[0] = {}
arrayPossibleHeroes[1] = {}
arrayPossibleHeroes[2] = {}
arrayPossibleHeroes[3] = {}

arrayPositionPosterHero = {}
arrayPositionPosterHero[0] = {
   { ["x1"] = 31, ["y1"] = 90, ["x2"] = 46, ["y2"] = 25 },
   { ["x1"] = 32, ["y1"] = 90, ["x2"] = 45, ["y2"] = 25 },
   { ["x1"] = 33, ["y1"] = 90, ["x2"] = 44, ["y2"] = 25 },
   { ["x1"] = 31, ["y1"] = 89, ["x2"] = 46, ["y2"] = 24 },
   { ["x1"] = 32, ["y1"] = 89, ["x2"] = 45, ["y2"] = 24 },
   { ["x1"] = 31, ["y1"] = 88, ["x2"] = 46, ["y2"] = 23 }}
arrayPositionPosterHero[1] = {
   { ["x1"] = 31, ["y1"] = 84, ["x2"] = 46, ["y2"] = 19 },
   { ["x1"] = 32, ["y1"] = 84, ["x2"] = 45, ["y2"] = 19 },
   { ["x1"] = 33, ["y1"] = 84, ["x2"] = 44, ["y2"] = 19 },
   { ["x1"] = 31, ["y1"] = 85, ["x2"] = 46, ["y2"] = 20 },
   { ["x1"] = 32, ["y1"] = 85, ["x2"] = 45, ["y2"] = 20 },
   { ["x1"] = 31, ["y1"] = 86, ["x2"] = 46, ["y2"] = 21 }}
arrayPositionPosterHero[2] = {
   { ["x1"] = 39, ["y1"] = 90, ["x2"] = 38, ["y2"] = 25 },
   { ["x1"] = 38, ["y1"] = 90, ["x2"] = 39, ["y2"] = 25 },
   { ["x1"] = 37, ["y1"] = 90, ["x2"] = 40, ["y2"] = 25 },
   { ["x1"] = 39, ["y1"] = 89, ["x2"] = 38, ["y2"] = 24 },
   { ["x1"] = 38, ["y1"] = 89, ["x2"] = 39, ["y2"] = 24 },
   { ["x1"] = 39, ["y1"] = 88, ["x2"] = 38, ["y2"] = 23 }}
arrayPositionPosterHero[3] = {
   { ["x1"] = 39, ["y1"] = 84, ["x2"] = 38, ["y2"] = 19 },
   { ["x1"] = 38, ["y1"] = 84, ["x2"] = 39, ["y2"] = 19 },
   { ["x1"] = 37, ["y1"] = 84, ["x2"] = 40, ["y2"] = 19 },
   { ["x1"] = 39, ["y1"] = 85, ["x2"] = 38, ["y2"] = 20 },
   { ["x1"] = 38, ["y1"] = 85, ["x2"] = 39, ["y2"] = 20 },
   { ["x1"] = 39, ["y1"] = 86, ["x2"] = 38, ["y2"] = 21 }}

function SetPossibleHeroes()
  if GAME_MODE.MATCHUPS then textForHero = "cherkHero.txt";  varCherkHero = 3; end;
  if GAME_MODE.HALF then textForHero = "cherkHero.txt";  varCherkHero = 3; end;
  if GAME_MODE.MIX then textForHero = "cherkHero.txt";  varCherkHero = 3; end;
  if GAME_MODE.SIMPLE_CHOOSE then
    varCherkHero = random(2) + 1;
    if varCherkHero == 1 then textForHero = "cherkHero1.txt"; end;
    if varCherkHero == 2 then textForHero = "cherkHero2.txt"; end;
    if GetTurnTimeLeft(1) == 0 then textForHero = "cherkHero.txt";  varCherkHero = 3; end;
  end;
  ShowFlyingSign(GetMapDataPath()..textForHero, heroes1[0], 1, 7.0);
  ShowFlyingSign(GetMapDataPath()..textForHero, heroes2[0], 2, 7.0);
--  MoveHeroRealTime(heroes1[0], 35, 87);
--  MoveHeroRealTime(heroes2[0], 42, 22);
  SetObjectPosition(heroes1[0], 35, 87);
  SetObjectPosition(heroes2[0], 42, 22);
  ChangeHeroStat (heroes2[0], STAT_MOVE_POINTS, -5000);
  hodi1(heroes1[0]);
  DeleteRace();
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'no');
--  SetRegionBlocked ('pl1_race3', true);
--  SetRegionBlocked ('pl1_race4', true);
--  SetRegionBlocked ('pl1_race5', true);
--  SetRegionBlocked ('pl1_race6', true);
--  SetRegionBlocked ('pl1_race7', true);
--  SetRegionBlocked ('pl1_race8', true);
--  SetRegionBlocked ('pl2_race1', true);
--  SetRegionBlocked ('pl2_race2', true);
--  SetRegionBlocked ('pl2_race3', true);
--  SetRegionBlocked ('pl2_race4', true);
--  SetRegionBlocked ('pl2_race5', true);
--  SetRegionBlocked ('pl2_race6', true);
--  SetRegionBlocked ('pl2_race7', true);
--  SetRegionBlocked ('pl2_race8', true);

  if GAME_MODE.MIX or GAME_MODE.SIMPLE_CHOOSE then
  RemoveObject     ('red1');
  RemoveObject     ('red2');
  RemoveObject     ('red3');
  RemoveObject     ('red4');
  RemoveObject     ('red5');
  RemoveObject     ('red6');
  -- RemoveObject     ('red7');
  RemoveObject     ('red8');
  RemoveObject     ('red9');
  RemoveObject     ('red12');
  RemoveObject     ('red13');
  RemoveObject     ('red14');
  RemoveObject     ('red15');
  RemoveObject     ('red16');
  RemoveObject     ('red17');
  RemoveObject     ('red18');
  RemoveObject     ('red19');
  RemoveObject     ('red20');

  RemoveObject     ('blue1');
  RemoveObject     ('blue2');
  RemoveObject     ('blue3');
  RemoveObject     ('blue4');
  RemoveObject     ('blue5');
  RemoveObject     ('blue6');
  RemoveObject     ('blue7');
  RemoveObject     ('blue8');
  RemoveObject     ('blue9');
  RemoveObject     ('blue12');
  RemoveObject     ('blue13');
  RemoveObject     ('blue14');
  RemoveObject     ('blue15');
  RemoveObject     ('blue16');
  RemoveObject     ('blue17');
  RemoveObject     ('blue18');
  RemoveObject     ('blue19');
  RemoveObject     ('blue20');
  end;

  for i = 0, 7 do
    num_heroes=11;
    if (i == 5) or (i == 2) then num_heroes=12; end;
    if (i == 0) then num_heroes=13; end;
    for j = 1, num_heroes do
      SetObjectEnabled(array_heroes[i][j].p1, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p1,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p2, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p2,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p3, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p3,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p4, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p4,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p5, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p5,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p6, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p6,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p7, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p7,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p8, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p8,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
    end;
  end;

  ------- BLOCK HERO -----------
--  if hero1race == 3 and hero2race == 3 then array_heroes[2][4].blocked = 1; end;
--  if hero1race == 2 and hero2race == 6 then array_heroes[1][3].blocked = 1; end;
--  if hero2race == 2 and hero1race == 6 then array_heroes[1][3].blocked = 1; end;
--  if hero1race == 2 and hero2race == 3 then array_heroes[1][3].blocked = 1; end;
--  if hero2race == 2 and hero1race == 3 then array_heroes[1][3].blocked = 1; end;
--  if hero1race == 3 and hero2race == 7 then array_heroes[2][9].blocked = 1; end;
--  if hero2race == 3 and hero1race == 7 then array_heroes[2][9].blocked = 1; end;

  num_heroes=11;
  if (hero1race == 6) or (hero1race == 3) then num_heroes=12; end;
  if (hero1race == 1) then num_heroes=13; end;

  for i = 1, 5 do
    rnd = random(num_heroes) + 1;
    while array_heroes[hero1race-1][rnd].blocked == 1 or array_heroes[hero1race-1][rnd].block_temply == 1 do
      rnd = random(num_heroes) + 1;
    end;
    array_heroes[hero1race-1][rnd].block_temply = 1;
    arrayPossibleHeroes[0][i] = rnd;
    SetObjectPosition(array_heroes[hero1race-1][rnd].p1, arrayPositionPosterHero[0][i].x1, arrayPositionPosterHero[0][i].y1, GROUND);
    SetObjectPosition(array_heroes[hero1race-1][rnd].p2, arrayPositionPosterHero[0][i].x2, arrayPositionPosterHero[0][i].y2, GROUND);
    if varCherkHero == 1 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCollection1' ); end;
    if varCherkHero == 2 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCollection1' ); end;
  end;

  k = 0;
--  for i = 1, num_heroes do
--    if random(2) > 0 and k < 3 and array_heroes[hero1race-1][i].block_temply == 1 then
--      array_heroes[hero1race-1][i].block_temply = 0;
--      k = k + 1;
--    end;
--    if k < 3 and i == num_heroes then i = 1; end;
--  end;

  for i = 1, 5 do
    rnd = random(num_heroes) + 1;
    while array_heroes[hero1race-1][rnd].blocked == 1 or array_heroes[hero1race-1][rnd].block_temply == 1 do
      rnd = random(num_heroes) + 1;
    end;
    array_heroes[hero1race-1][rnd].block_temply = 1;
    arrayPossibleHeroes[1][i] = rnd;
    SetObjectPosition(array_heroes[hero1race-1][rnd].p3, arrayPositionPosterHero[1][i].x1, arrayPositionPosterHero[1][i].y1, GROUND);
    SetObjectPosition(array_heroes[hero1race-1][rnd].p4, arrayPositionPosterHero[1][i].x2, arrayPositionPosterHero[1][i].y2, GROUND);
    if varCherkHero == 1 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p3, 'QuestionHeroCollection2' ); end;
    if varCherkHero == 2 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p4, 'QuestionHeroCollection2' ); end;
  end;

  for i = 1, num_heroes do
    array_heroes[hero1race-1][i].block_temply = 0;
  end;

  num_heroes=11;
  if (hero2race == 6) or (hero2race == 3) then num_heroes=12; end;
  if (hero2race == 1) then num_heroes=13; end;

  for i = 1, 5 do
    rnd = random(num_heroes) + 1;
    while array_heroes[hero2race-1][rnd].blocked == 1 or array_heroes[hero2race-1][rnd].block_temply == 1 do
      rnd = random(num_heroes) + 1;
    end;
    array_heroes[hero2race-1][rnd].block_temply = 1;
    arrayPossibleHeroes[2][i] = rnd;
    SetObjectPosition(array_heroes[hero2race-1][rnd].p5, arrayPositionPosterHero[2][i].x1, arrayPositionPosterHero[2][i].y1, GROUND);
    SetObjectPosition(array_heroes[hero2race-1][rnd].p6, arrayPositionPosterHero[2][i].x2, arrayPositionPosterHero[2][i].y2, GROUND);
    if varCherkHero == 2 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCollection3' ); end;
    if varCherkHero == 1 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCollection3' ); end;
  end;

  k = 0;
--  for i = 1, num_heroes do
--    if random(2) > 0 and k < 3 and array_heroes[hero2race-1][i].block_temply == 1 then
--      array_heroes[hero2race-1][i].block_temply = 0;
--      k = k + 1;
--    end;
--    if k < 3 and i == num_heroes then i = 1; end;
--  end;

  for i = 1, 5 do
    rnd = random(num_heroes) + 1;
    while array_heroes[hero2race-1][rnd].blocked == 1 or array_heroes[hero2race-1][rnd].block_temply == 1 do
      rnd = random(num_heroes) + 1;
    end;
    array_heroes[hero2race-1][rnd].block_temply = 1;
    arrayPossibleHeroes[3][i] = rnd;
    SetObjectPosition(array_heroes[hero2race-1][rnd].p7, arrayPositionPosterHero[3][i].x1, arrayPositionPosterHero[3][i].y1, GROUND);
    SetObjectPosition(array_heroes[hero2race-1][rnd].p8, arrayPositionPosterHero[3][i].x2, arrayPositionPosterHero[3][i].y2, GROUND);
    if varCherkHero == 2 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p7, 'QuestionHeroCollection4' ); end;
    if varCherkHero == 1 or varCherkHero == 3 then Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p8, 'QuestionHeroCollection4' ); end;
  end;

  for i = 1, num_heroes do
    array_heroes[hero2race-1][i].block_temply = 0;
  end;

  sleep (3);

  stop (heroes2[0]);

  if GAME_MODE.SIMPLE_CHOOSE and GetTurnTimeLeft(1) == 0 then hodi1(heroes2[0]); end;

end;

HCC1 = 0;
HCC2 = 0;

ChoiseYes = 0;

function ChoiseNo()
 ChoiseYes = 0;
end;

Hotseat = 1;

function QuestionHeroCollection1(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = hero;
    QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroCollection.txt", 'HeroCollectionChoise2', 'ChoiseNo');
  end;
end;

function HeroCollectionChoise1()
  ChoiseYes = 0;
  if HCC1 == 0 or (HCC1 == 1 and GetObjectOwner(H) == 2) then
    stop(H);
    HeroCollectionPlayer1 = 0;
    if H == heroes1[0] then hodi1(heroes2[0]); Hotseat = 0;
    else
      if GAME_MODE.SIMPLE_CHOOSE and Hotseat == 1 and GetTurnTimeLeft(1) == 0 then
        hodi1(heroes2[0]);
        Hotseat = 0;
      else
        add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
        add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
        unreserve();
      end;
    end;
    for i = 1, 5 do
      RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[1][i]].p3);
      RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[1][i]].p4);
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p1, 'no' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p2, 'no' );
    end;
    HCC1 = 1;
  end;
end;

function QuestionHeroCollection2(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = hero;
    QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroCollection.txt", 'HeroCollectionChoise1', 'ChoiseNo');
  end;
end;

function HeroCollectionChoise2()
  ChoiseYes = 0;
  if HCC1 == 0 or (HCC1 == 1 and GetObjectOwner(H) == 2) then
    stop(H);
    HeroCollectionPlayer1 = 1;
    if H == heroes1[0] then hodi1(heroes2[0]); Hotseat = 0;
    else
      if GAME_MODE.SIMPLE_CHOOSE and Hotseat == 1 and GetTurnTimeLeft(1) == 0 then
        hodi1(heroes2[0]);
        Hotseat = 0;
      else
        add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
        add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
        unreserve();
      end;
    end;
    for i = 1, 5 do
      RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p1);
      RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p2);
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[1][i]].p3, 'no' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[1][i]].p4, 'no' );
    end;
    HCC1 = 1;
  end;
end;

function QuestionHeroCollection3(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = hero;
    QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroCollection.txt", 'HeroCollectionChoise4', 'ChoiseNo');
  end;
end;

function HeroCollectionChoise3()
  ChoiseYes = 0;
  if HCC1 == 0 or (HCC1 == 1 and GetObjectOwner(H) == 2) then
    stop(H);
    HeroCollectionPlayer2 = 2;
    if H == heroes1[0] then hodi1(heroes2[0]); Hotseat = 0;
    else
      if GAME_MODE.SIMPLE_CHOOSE and Hotseat == 1 and GetTurnTimeLeft(1) == 0 then
        hodi1(heroes2[0]);
        Hotseat = 0;
      else
        add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
        add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
        unreserve();
      end;
    end;
    for i = 1, 5 do
      RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[3][i]].p7);
      RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[3][i]].p8);
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p5, 'no' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p6, 'no' );
    end;
    HCC1 = 1;
  end;
end;

function QuestionHeroCollection4(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = hero;
    QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroCollection.txt", 'HeroCollectionChoise3', 'ChoiseNo');
  end;
end;

function HeroCollectionChoise4()
  ChoiseYes = 0;
  if HCC1 == 0 or (HCC1 == 1 and GetObjectOwner(H) == 2) then
    stop(H);
    HeroCollectionPlayer2 = 3;
    if H == heroes1[0] then hodi1(heroes2[0]); Hotseat = 0;
    else
      if GAME_MODE.SIMPLE_CHOOSE and Hotseat == 1 and GetTurnTimeLeft(1) == 0 then
        hodi1(heroes2[0]);
        Hotseat = 0;
      else
        add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
        add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
        unreserve();
      end;
    end;
    for i = 1, 5 do
      RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p5);
      RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p6);
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[3][i]].p7, 'no' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[3][i]].p8, 'no' );
    end;
    HCC1 = 1;
  end;
end;

CherkPossibleHeroesEnable = 0;

function CherkPossibleHeroes()
  CherkPossibleHeroesEnable = 1;
  SetObjectPosition(heroes1[0], 35, 87);
  SetObjectPosition(heroes2[0], 42, 22);
  ChangeHeroStat (heroes2[0], STAT_MOVE_POINTS, -5000);
  hodi1(heroes1[0]);
  DeleteRace();
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'no');
  HeroPlusMinus = random(2);

  if HeroPlusMinus == 0 then
    ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes1[0], 1, 7.0);
  else
    ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes1[0], 1, 7.0);
  end;

  if GAME_MODE.MIX or GAME_MODE.SIMPLE_CHOOSE then
  RemoveObject     ('red1');
  RemoveObject     ('red2');
  RemoveObject     ('red3');
  RemoveObject     ('red4');
  RemoveObject     ('red5');
  RemoveObject     ('red6');
  -- RemoveObject     ('red7');
  RemoveObject     ('red8');
  RemoveObject     ('red9');
  RemoveObject     ('red12');
  RemoveObject     ('red13');
  RemoveObject     ('red14');
  RemoveObject     ('red15');
  RemoveObject     ('red16');
  RemoveObject     ('red17');
  RemoveObject     ('red18');
  RemoveObject     ('red19');
  RemoveObject     ('red20');

  RemoveObject     ('blue1');
  RemoveObject     ('blue2');
  RemoveObject     ('blue3');
  RemoveObject     ('blue4');
  RemoveObject     ('blue5');
  RemoveObject     ('blue6');
  RemoveObject     ('blue7');
  RemoveObject     ('blue8');
  RemoveObject     ('blue9');
  RemoveObject     ('blue12');
  RemoveObject     ('blue13');
  RemoveObject     ('blue14');
  RemoveObject     ('blue15');
  RemoveObject     ('blue16');
  RemoveObject     ('blue17');
  RemoveObject     ('blue18');
  RemoveObject     ('blue19');
  RemoveObject     ('blue20');
  end;

  for i = 0, 7 do
    num_heroes=11;
    if (i == 5) or (i == 2) then num_heroes=12; end;
    if (i == 0) then num_heroes=13; end;
    for j = 1, num_heroes do
      SetObjectEnabled(array_heroes[i][j].p1, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p1,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p2, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p2,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p3, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p3,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p4, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p4,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p5, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p5,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p6, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p6,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p7, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p7,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
      SetObjectEnabled(array_heroes[i][j].p8, nil);
      OverrideObjectTooltipNameAndDescription (array_heroes[i][j].p8,  GetMapDataPath()..array_heroes[i][j].txt, array_heroes[i][j].dsc);
    end;
  end;

  ------- BLOCK HERO -----------
--  if hero1race == 3 and hero2race == 3 then array_heroes[2][4].blocked = 1; end;
--  if hero1race == 2 and hero2race == 6 then array_heroes[1][3].blocked = 1; end;
--  if hero2race == 2 and hero1race == 6 then array_heroes[1][3].blocked = 1; end;
--  if hero1race == 2 and hero2race == 3 then array_heroes[1][3].blocked = 1; end;
--  if hero2race == 2 and hero1race == 3 then array_heroes[1][3].blocked = 1; end;
--  if hero1race == 3 and hero2race == 7 then array_heroes[2][9].blocked = 1; end;
--  if hero2race == 3 and hero1race == 7 then array_heroes[2][9].blocked = 1; end;


  num_heroes=11;
  if (hero1race == 6) or (hero1race == 3) then num_heroes=12; end;
  if (hero1race == 1) then num_heroes=13; end;

  for i = 1, 7 do
    rnd = random(num_heroes) + 1;
    while array_heroes[hero1race-1][rnd].blocked == 1 or array_heroes[hero1race-1][rnd].block_temply == 1 do
      rnd = random(num_heroes) + 1;
    end;
    array_heroes[hero1race-1][rnd].block_temply = 1;
    arrayPossibleHeroes[0][i] = rnd;
    SetObjectPosition(array_heroes[hero1race-1][rnd].p1, (31 + i), 85, GROUND);
    SetObjectPosition(array_heroes[hero1race-1][rnd].p2, (38 + i), 23, GROUND);
    if i == 1 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk11' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk11' );
    end;
    if i == 2 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk12' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk12' );
    end;
    if i == 3 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk13' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk13' );
    end;
    if i == 4 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk14' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk14' );
    end;
    if i == 5 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk15' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk15' );
    end;
    if i == 6 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk16' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk16' );
    end;
    if i == 7 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk17' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk17' );
    end;
--    if i == 8 then
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk18' );
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk18' );
--    end;
--    if i == 9 then
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p1, 'QuestionHeroCherk19' );
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][rnd].p2, 'QuestionHeroCherk19' );
--    end;
  end;

  for i = 1, num_heroes do
    array_heroes[hero1race-1][i].block_temply = 0;
  end;

  num_heroes=11;
  if (hero2race == 6) or (hero2race == 3) then num_heroes=12; end;
  if (hero2race == 1) then num_heroes=13; end;

  for i = 1, 7 do
    rnd = random(num_heroes) + 1;
    while array_heroes[hero2race-1][rnd].blocked == 1 or array_heroes[hero2race-1][rnd].block_temply == 1 do
      rnd = random(num_heroes) + 1;
    end;
    array_heroes[hero2race-1][rnd].block_temply = 1;
    arrayPossibleHeroes[2][i] = rnd;
    SetObjectPosition(array_heroes[hero2race-1][rnd].p5, (31 + i), 88, GROUND);
    SetObjectPosition(array_heroes[hero2race-1][rnd].p6, (38 + i), 20, GROUND);
    if i == 1 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk21' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk21' );
    end;
    if i == 2 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk22' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk22' );
    end;
    if i == 3 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk23' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk23' );
    end;
    if i == 4 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk24' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk24' );
    end;
    if i == 5 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk25' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk25' );
    end;
    if i == 6 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk26' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk26' );
    end;
    if i == 7 then
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk27' );
      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk27' );
    end;
--    if i == 8 then
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk28' );
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk28' );
--    end;
--    if i == 9 then
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p5, 'QuestionHeroCherk29' );
--      Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][rnd].p6, 'QuestionHeroCherk29' );
--    end;
  end;

  for i = 1, num_heroes do
    array_heroes[hero2race-1][i].block_temply = 0;
  end;

end;

CherkFinish = 0;
NH1 = 1;
NH2 = 1;
DH1 = 0;
DH2 = 0;

function QuestionHeroCherk11(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 1;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk12(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 2;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk13(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 3;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk14(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 4;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk15(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 5;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk16(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 6;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk17(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 7;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk18(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 8;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk19(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 9;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection1', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection1', 'ChoiseNo');
    end;
  end;
end;


function QuestionHeroCherk21(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 1;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk22(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 2;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk23(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 3;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk24(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 4;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk25(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 5;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk26(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 6;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk27(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 7;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk28(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 8;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;

function QuestionHeroCherk29(hero)
  if ChoiseYes == 0 then
    ChoiseYes = 1;
    pl = GetObjectOwner (hero);
    H = 9;
    if HeroPlusMinus == 1 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroAddQuestion.txt", 'HeroAddToCollection2', 'ChoiseNo');
    end;
    if HeroPlusMinus == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(pl), GetMapDataPath().."HeroDeleteQuestion.txt", 'HeroDeleteFromCollection2', 'ChoiseNo');
    end;
  end;
end;



function HeroAddToCollection1()
  ChoiseYes = 0;
  arrayPossibleHeroes[1][NH1] = arrayPossibleHeroes[0][H];
  SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][NH1]].p1, (31 + H), 84, GROUND);
  SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][NH1]].p2, (38 + H), 24, GROUND);
  Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[1][NH1]].p1, 'no' );
  Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[1][NH1]].p2, 'no' );
  NH1 = NH1 + 1;
  if NH1 == 5 then
    for i = 1, 7 do
      q = 0;
      for j = 1, 5 do
        if arrayPossibleHeroes[0][i] == arrayPossibleHeroes[1][j] then
          q = 1;
        end;
      end;
      if q == 0 and IsObjectExists(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p1) == 1 then
        RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p1);
        RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p2);
      end;
    end;
    CherkFinish = CherkFinish + 1;
  end;
  if CherkFinish < 2 then
    if pl == 1 then
      stop(heroes1[0]);
      hodi1(heroes2[0]);
--      HeroPlusMinus = random(2);
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes2[0], 2, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes2[0], 2, 7.0);
      end;
    end;
    if pl == 2 then
      hodi1(heroes1[0]);
      stop(heroes2[0]);
      if HeroPlusMinus == 0 then HeroPlusMinus = 1; else HeroPlusMinus = 0; end;
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes1[0], 1, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes1[0], 1, 7.0);
      end;
    end;
  else
    arrayPossibleHeroes[0] = arrayPossibleHeroes[1];
    arrayPossibleHeroes[2] = arrayPossibleHeroes[3];
    HeroCollectionPlayer1 = 0;
    HeroCollectionPlayer2 = 2;
    add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
    add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
    unreserve();
    stop(heroes2[0]);
  end;
end;

function HeroAddToCollection2()
  ChoiseYes = 0;
  arrayPossibleHeroes[3][NH2] = arrayPossibleHeroes[2][H];
  SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][NH2]].p5, (31 + H), 89, GROUND);
  SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][NH2]].p6, (38 + H), 19, GROUND);
  Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[3][NH2]].p5, 'no' );
  Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[3][NH2]].p6, 'no' );
  NH2 = NH2 + 1;
  if NH2 == 5 then
    for i = 1, 7 do
      q = 0;
      for j = 1, 5 do
        if arrayPossibleHeroes[2][i] == arrayPossibleHeroes[3][j] then
          q = 1;
        end;
      end;
      if q == 0 and IsObjectExists(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p5) == 1 then
        RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p5);
        RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p6);
      end;
    end;
    CherkFinish = CherkFinish + 1;
  end;
  if CherkFinish < 2 then
    if pl == 1 then
      stop(heroes1[0]);
      hodi1(heroes2[0]);
--      HeroPlusMinus = random(2);
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes2[0], 2, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes2[0], 2, 7.0);
      end;
    end;
    if pl == 2 then
      hodi1(heroes1[0]);
      stop(heroes2[0]);
      if HeroPlusMinus == 0 then HeroPlusMinus = 1; else HeroPlusMinus = 0; end;
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes1[0], 1, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes1[0], 1, 7.0);
      end;
    end;
  else
    arrayPossibleHeroes[0] = arrayPossibleHeroes[1];
    arrayPossibleHeroes[2] = arrayPossibleHeroes[3];
    HeroCollectionPlayer1 = 0;
    HeroCollectionPlayer2 = 2;
    add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
    add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
    unreserve();
    stop(heroes2[0]);
  end;
end;

function HeroDeleteFromCollection1()
  ChoiseYes = 0;
  RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[0][H]].p1);
  RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[0][H]].p2);
  DH1 = DH1 + 1;
  if DH1 == 3 then
    j = 1;
    for i = 1, 7 do
      if IsObjectExists(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p1) == 1 then
        SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p1, (31 + i), 84, GROUND);
        SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p2, (38 + i), 24, GROUND);
        Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p1, 'no' );
        Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero1race-1][arrayPossibleHeroes[0][i]].p2, 'no' );
        arrayPossibleHeroes[1][j] = arrayPossibleHeroes[0][i];
        j = j + 1;
      end;
    end;
    CherkFinish = CherkFinish + 1;
  end;
  if CherkFinish < 2 then
    if pl == 1 then
      stop(heroes1[0]);
      hodi1(heroes2[0]);
      --HeroPlusMinus = random(2);
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes2[0], 2, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes2[0], 2, 7.0);
      end;
    end;
    if pl == 2 then
      hodi1(heroes1[0]);
      stop(heroes2[0]);
      if HeroPlusMinus == 0 then HeroPlusMinus = 1; else HeroPlusMinus = 0; end;
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes1[0], 1, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes1[0], 1, 7.0);
      end;
    end;
  else
    arrayPossibleHeroes[0] = arrayPossibleHeroes[1];
    arrayPossibleHeroes[2] = arrayPossibleHeroes[3];
    HeroCollectionPlayer1 = 0;
    HeroCollectionPlayer2 = 2;
    add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
    add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
    unreserve();
    stop(heroes2[0]);
  end;
end;

function HeroDeleteFromCollection2()
  ChoiseYes = 0;
  RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[2][H]].p5);
  RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[2][H]].p6);
  DH2 = DH2 + 1;
  if DH2 == 3 then
    j = 1;
    for i = 1, 7 do
      if IsObjectExists(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p5) == 1 then
        SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p5, (31 + i), 89, GROUND);
        SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p6, (38 + i), 19, GROUND);
        Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p5, 'no' );
        Trigger( OBJECT_TOUCH_TRIGGER, array_heroes[hero2race-1][arrayPossibleHeroes[2][i]].p6, 'no' );
        arrayPossibleHeroes[3][j] = arrayPossibleHeroes[2][i];
        j = j + 1;
      end;
    end;
    CherkFinish = CherkFinish + 1;
  end;
  if CherkFinish < 2 then
    if pl == 1 then
      stop(heroes1[0]);
      hodi1(heroes2[0]);
      --HeroPlusMinus = random(2);
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes2[0], 2, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes2[0], 2, 7.0);
      end;
    end;
    if pl == 2 then
      hodi1(heroes1[0]);
      stop(heroes2[0]);
      if HeroPlusMinus == 0 then HeroPlusMinus = 1; else HeroPlusMinus = 0; end;
      if HeroPlusMinus == 0 then
        ShowFlyingSign(GetMapDataPath().."HeroMinus.txt", heroes1[0], 1, 7.0);
      else
        ShowFlyingSign(GetMapDataPath().."HeroPlus.txt",  heroes1[0], 1, 7.0);
      end;
    end;
  else
    arrayPossibleHeroes[0] = arrayPossibleHeroes[1];
    arrayPossibleHeroes[2] = arrayPossibleHeroes[3];
    HeroCollectionPlayer1 = 0;
    HeroCollectionPlayer2 = 2;
    add_hero (hero1race, x11, x12, y11, y12, 1, hero2race);
    add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
    unreserve();
    stop(heroes2[0]);
  end;
end;



function SetPosters()
  l = length(arrayPossibleHeroes[HeroCollectionPlayer1])
  for i = 1, l do
    rnd = random(l) + 1;
    arrayPossibleHeroes[HeroCollectionPlayer1][i], arrayPossibleHeroes[HeroCollectionPlayer1][rnd] = arrayPossibleHeroes[HeroCollectionPlayer1][rnd], arrayPossibleHeroes[HeroCollectionPlayer1][i];
  end;
  l = length(arrayPossibleHeroes[HeroCollectionPlayer2])
  for i = 1, l do
    rnd = random(l) + 1;
    arrayPossibleHeroes[HeroCollectionPlayer2][i], arrayPossibleHeroes[HeroCollectionPlayer2][rnd] = arrayPossibleHeroes[HeroCollectionPlayer2][rnd], arrayPossibleHeroes[HeroCollectionPlayer2][i];
  end;
  if HeroCollectionPlayer1 == 0 then
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[0][1]].p1);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][1]].p2, 46, 19, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[0][1]].p2, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[0][1]].p2,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[0][1]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[0][1]].dsc);
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[0][2]].p1);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][2]].p2, 46, 20, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[0][2]].p2, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[0][2]].p2,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[0][2]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[0][2]].dsc);
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[0][3]].p1);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][3]].p2, 46, 21, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[0][3]].p2, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[0][3]].p2,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[0][3]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[0][3]].dsc);
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[0][4]].p1);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][4]].p2, 46, 22, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[0][4]].p2, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[0][4]].p2,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[0][4]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[0][4]].dsc);
    if CherkFinish == 0 and not GAME_MODE.MIX then
      RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[0][5]].p1);
      SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][5]].p2, 46, 23, GROUND);
      SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[0][5]].p2, 180);
      OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[0][5]].p2,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[0][5]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[0][5]].dsc);
    end;
--    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[0][6]].p1);
--    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[0][6]].p2, 10, 59, GROUND);
--    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[0][6]].p2, 180);
  end;
  if HeroCollectionPlayer1 == 1 then
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[1][1]].p3);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][1]].p4, 46, 19, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[1][1]].p4, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[1][1]].p4,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[1][1]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[1][1]].dsc);
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[1][2]].p3);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][2]].p4, 46, 20, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[1][2]].p4, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[1][2]].p4,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[1][2]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[1][2]].dsc);
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[1][3]].p3);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][3]].p4, 46, 21, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[1][3]].p4, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[1][3]].p4,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[1][3]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[1][3]].dsc);
    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[1][4]].p3);
    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][4]].p4, 46, 22, GROUND);
    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[1][4]].p4, 180);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[1][4]].p4,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[1][4]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[1][4]].dsc);
    if CherkFinish == 0 and not GAME_MODE.MIX then
      RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[1][5]].p3);
      SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][5]].p4, 46, 23, GROUND);
      SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[1][5]].p4, 180);
      OverrideObjectTooltipNameAndDescription(array_heroes[hero1race-1][arrayPossibleHeroes[1][5]].p4,  GetMapDataPath()..array_heroes[hero1race-1][arrayPossibleHeroes[1][5]].txt, array_heroes[hero1race-1][arrayPossibleHeroes[1][5]].dsc);
    end;
--    RemoveObject     (array_heroes[hero1race-1][arrayPossibleHeroes[1][6]].p3);
--    SetObjectPosition(array_heroes[hero1race-1][arrayPossibleHeroes[1][6]].p4, 10, 59, GROUND);
--    SetObjectRotation(array_heroes[hero1race-1][arrayPossibleHeroes[1][6]].p4, 180);
  end;

--  for i = 1, 8 do
--    if i == 1 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p1; end;
--    if i == 2 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p2; end;
--    if i == 3 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p3; end;
--    if i == 4 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p4; end;
--    if i == 5 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p5; end;
--    if i == 6 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p6; end;
--    if i == 7 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p7; end;
--    if i == 8 then object = array_heroes[HeroForScouting3Race_Player2][HeroForScouting3Hero_Player2].p8; end;
--    if IsObjectExists(object) == 1 then
--      SetObjectPosition(object, 10, 60, GROUND);
--      SetObjectRotation(object, 180);
--      i = 8;
--    end;
--  end;

  if HeroCollectionPlayer2 == 2 then
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[2][1]].p6);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][1]].p5, 31, 90, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[2][1]].p5,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[2][1]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[2][1]].dsc);
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[2][2]].p6);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][2]].p5, 31, 89, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[2][2]].p5,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[2][2]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[2][2]].dsc);
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[2][3]].p6);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][3]].p5, 31, 88, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[2][3]].p5,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[2][3]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[2][3]].dsc);
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[2][4]].p6);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][4]].p5, 31, 87, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[2][4]].p5,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[2][4]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[2][4]].dsc);
    if CherkFinish == 0 and not GAME_MODE.MIX then
      RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[2][5]].p6);
      SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][5]].p5, 31, 86, GROUND);
      OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[2][5]].p5,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[2][5]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[2][5]].dsc);
    end;
--    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[2][6]].p6);
--    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][6]].p5, 85, 33, GROUND);
  end;

  if HeroCollectionPlayer2 == 3 then
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[3][1]].p8);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][1]].p7, 31, 90, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[3][1]].p7,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[3][1]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[3][1]].dsc);
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[3][2]].p8);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][2]].p7, 31, 89, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[3][2]].p7,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[3][2]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[3][2]].dsc);
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[3][3]].p8);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][3]].p7, 31, 88, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[3][3]].p7,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[3][3]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[3][3]].dsc);
    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[3][4]].p8);
    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][4]].p7, 31, 87, GROUND);
    OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[3][4]].p7,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[3][4]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[3][4]].dsc);
    if CherkFinish == 0 and not GAME_MODE.MIX then
      RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[3][5]].p8);
      SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][5]].p7, 31, 86, GROUND);
      OverrideObjectTooltipNameAndDescription(array_heroes[hero2race-1][arrayPossibleHeroes[3][5]].p7,  GetMapDataPath()..array_heroes[hero2race-1][arrayPossibleHeroes[3][5]].txt, array_heroes[hero2race-1][arrayPossibleHeroes[3][5]].dsc);
    end;
--    RemoveObject     (array_heroes[hero2race-1][arrayPossibleHeroes[3][6]].p8);
--    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[3][6]].p7, 85, 33, GROUND);
  end;

--  for i = 1, 8 do
--    if i == 1 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p1; end;
--    if i == 2 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p2; end;
--    if i == 3 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p3; end;
--    if i == 4 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p4; end;
--    if i == 5 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p5; end;
--    if i == 6 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p6; end;
--    if i == 7 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p7; end;
--    if i == 8 then object = array_heroes[HeroForScouting3Race_Player1][HeroForScouting3Hero_Player1].p8; end;
--    if IsObjectExists(object) == 1 then
--      SetObjectPosition(object, 85, 32, GROUND);
--      i = 8;
--    end;
--  end;

end;

HeroFromTavernActivity1 = 0;
HeroFromTavernActivity2 = 0;

function HeroAdd1(hero)
--  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  3000));
--  StartArmy(hero, hero1race);
  HeroDop1 = hero;
  heroes1[3] = HeroDop1;
  if StartBonus[1] == 'spell' then
    TeachHeroSpell(HeroDop1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
    TeachHeroSpell(HeroDop1, array_spells[BonusSpells[0].m2][BonusSpells[0].sp2].id );
  end;
--  UpHeroStat(hero);
--  if getrace(hero) == 1 and hero1race == 1 and hero2race == 2 then ChangeHeroStat(hero, 4, 4); end;
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroDop1, 'MentorAddSkill1');
  ControlHeroCustomAbility(HeroDop1, CUSTOM_ABILITY_1, CUSTOM_ABILITY_ENABLED);
  Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");
  HeroMage13 = HeroDop1;
  HeroFromTavernActivity1 = 1;
  LockMinHeroSkillsAndAttributes(HeroDop1);
end;

function HeroAdd2(hero)
--  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  3000));
--  StartArmy(hero, hero2race);
  HeroDop2 = hero;
  heroes2[3] = HeroDop2;
  if StartBonus[2] == 'spell' then
    TeachHeroSpell(HeroDop2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
    TeachHeroSpell(HeroDop2, array_spells[BonusSpells[1].m2][BonusSpells[1].sp2].id );
  end;
--  UpHeroStat(hero);
--  if getrace(hero) == 1 and hero2race == 1 and hero1race == 2 then ChangeHeroStat(hero, 4, 4); end;
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroDop2, 'MentorAddSkill2');
  ControlHeroCustomAbility(HeroDop2, CUSTOM_ABILITY_1, CUSTOM_ABILITY_ENABLED);
  Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");
  HeroMage23 = HeroDop2;
  HeroFromTavernActivity2 = 1;
  LockMinHeroSkillsAndAttributes(HeroDop2);
end;

RemStUn1 = 0;
RemStUn2 = 0;

array_StartUnit = {}
array_StartUnit = {{["grade1"] =   1, ["grade2"] = 106},
                   {["grade1"] =  15, ["grade2"] = 131},
                   {["grade1"] =  29, ["grade2"] = 152},
                   {["grade1"] =  43, ["grade2"] = 145},
                   {["grade1"] =  57, ["grade2"] = 159},
                   {["grade1"] =  71, ["grade2"] = 138},
                   {["grade1"] =  92, ["grade2"] = 166},
                   {["grade1"] = 117, ["grade2"] = 173}}


function RemoveStartUnit1()
  while RemStUn1 == 0 do
    Un11, Un12 = GetHeroCreaturesTypes(HeroMax1);
    Un13, Un14 = GetHeroCreaturesTypes(HeroMin1);
    if Un12 > 0 then
      if GetHeroCreatures(HeroMax1, 87) > 0 then
        RemoveHeroCreatures(HeroMax1, 87, GetHeroCreatures(HeroMax1, 87));
        RemStUn1 = 1;
      end;
    end;
    if Un14 > 0 then
      if GetHeroCreatures(HeroMin1, 87) > 0 then
        RemoveHeroCreatures(HeroMin1, 87, GetHeroCreatures(HeroMin1, 87));
        RemStUn1 = 1;
      end;
    end;
    sleep(5);
  end;
end;

function RemoveStartUnit2()
  while RemStUn2 == 0 do
    Un21, Un22 = GetHeroCreaturesTypes(HeroMax2);
    Un23, Un24 = GetHeroCreaturesTypes(HeroMin2);
    if Un22 > 0 then
      if GetHeroCreatures(HeroMax2, 87) > 0 then
        RemoveHeroCreatures(HeroMax2, 87, GetHeroCreatures(HeroMax2, 87));
        RemStUn2 = 1;
      end;
    end;
    if Un24 > 0 then
      if GetHeroCreatures(HeroMin2, 87) > 0 then
        RemoveHeroCreatures(HeroMin2, 87, GetHeroCreatures(HeroMin2, 87));
        RemStUn2 = 1;
      end;
    end;
    sleep(5);
  end;
end;


	--------     HAVEN     INF    NECR     ELF    MAGE    LIGA    GNOM     ORC
	PercentA = {    30,     45,     10,     15,     10,     30,     20,     50};
	PercentD = {    45,     10,     30,     45,     15,     10,     30,     35};
	PercentS = {    10,     15,     45,     10,     30,     45,     30,      5};
	PercentK = {    15,     30,     15,     30,     45,     15,     20,     10};


SetObjectEnabled('stat1', nil);
SetObjectEnabled('stat2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'stat1', 'RegenStatQuestion1' );
Trigger( OBJECT_TOUCH_TRIGGER, 'stat2', 'RegenStatQuestion2' );

arrayStatRegenHero1 = {}
arrayStatRegenHero1 = { 0, 0, 0, 0}
arrayStatRegenHero2 = {}
arrayStatRegenHero2 = { 0, 0, 0, 0}

function RegenStatQuestion1(hero)
  heroRS1 = hero;
  if GetPlayerResource(PLAYER_1, GOLD) >= StatRegenCost then
    QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_1), {GetMapDataPath().."ResetStat.txt"; eq = StatRegenCost}, 'RegenStat1', 'no');
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = StatRegenCost});
  end;
end;

function RegenStatQuestion2(hero)
  heroRS2 = hero;
  if GetPlayerResource(PLAYER_2, GOLD) >= StatRegenCost then
    QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_2), {GetMapDataPath().."ResetStat.txt"; eq = StatRegenCost}, 'RegenStat2', 'no');
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = StatRegenCost});
  end;
end;

function RegenStat1()
  j = 1;
  for k = 0, 2 do
    for i = 1, length(array_arts[k]) do
      if HasArtefact   (heroRS1, array_arts[k][i].id) then
        RemoveArtefact (heroRS1, array_arts[k][i].id);
        artHero1[j] = array_arts[k][i].id;
        j = j + 1;
      end;
    end;
  end;
  sleep(1);
  arrayStatRegenHero1 = { GetHeroStat(heroRS1, 1), GetHeroStat(heroRS1, 2), GetHeroStat(heroRS1, 3), GetHeroStat(heroRS1, 4)};
  if HasHeroSkill(heroRS1, 115) then arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - 2; end;
  if HasHeroSkill(heroRS1, 186) then arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 1; end;
  if HasHeroSkill(heroRS1, 181) then arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 2; end;
  if HasHeroSkill(heroRS1,  87) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2 * SinergyLevel1; end;
  if HasHeroSkill(heroRS1,  81) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2 * SinergyLevel1; end;
--    if SinergyLevel1 == 0 or SinergyLevel1 == 1 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2;
--    elseif SinergyLevel1 == 2 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 3;
--    elseif SinergyLevel1 == 3 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 5;
--    elseif SinergyLevel1 == 4 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 8;
--    end;
--  if HasHeroSkill(heroRS1,  87) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 3; end;
  if HasHeroSkill(heroRS1, 119) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2; end;
  if HasHeroSkill(heroRS1, 127) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2; end;
  if HasHeroSkill(heroRS1,  79) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2; end;
  if HasHeroSkill(heroRS1, 146) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2; end;
  if HasHeroSkill(heroRS1, 185) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2; end;
  if HasHeroSkill(heroRS1, 101) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 1; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 20 then arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 23 then arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 15 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 3  then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 18 then arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - 1; arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 1; arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 1; arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 1; end;
  arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - basicA[getrace(heroRS1)] - statA1;
  arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - basicD[getrace(heroRS1)] - statD1;
  arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - basicS[getrace(heroRS1)] - statS1;
  arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - basicK[getrace(heroRS1)] - statK1;
  ChangeHeroStat( heroRS1, 1, 0 - arrayStatRegenHero1[1]);
  ChangeHeroStat( heroRS1, 2, 0 - arrayStatRegenHero1[2]);
  ChangeHeroStat( heroRS1, 3, 0 - arrayStatRegenHero1[3]);
  ChangeHeroStat( heroRS1, 4, 0 - arrayStatRegenHero1[4]);

  arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][1]; --print(arrayStatRegenHero1[1]);
  arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][2];-- print(arrayStatRegenHero1[2]);
  arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][3]; --print(arrayStatRegenHero1[3]);
  arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][4]; --print(arrayStatRegenHero1[4]);
  StatRegenSum1 = arrayStatRegenHero1[1] + arrayStatRegenHero1[2] + arrayStatRegenHero1[3] + arrayStatRegenHero1[4]; --print(StatRegenSum1);
  for i = 1, StatRegenSum1 do
    UpHeroStat(heroRS1);
  end;
  GenerateStatLearning1(heroRS1);
  LearningLvl1 = 0;
  Learning1(heroRS1);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - StatRegenCost));
  x, y = GetObjectPosition(heroRS1);
  Play2DSoundForPlayers ( 1, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x, y, 0);
  for i = 1, 15 do
    GiveArtefact (heroRS1, artHero1[i]);
  end;
  sleep(1);
  ArrayStatHero(heroRS1);
end;


function RegenStat2()
  j = 1;
  for k = 0, 2 do
    for i = 1, length(array_arts[k]) do
      if HasArtefact   (heroRS2, array_arts[k][i].id) then
        RemoveArtefact (heroRS2, array_arts[k][i].id);
        artHero2[j] = array_arts[k][i].id;
        j = j + 1;
      end;
    end;
  end;
  sleep(1);
  arrayStatRegenHero2 = { GetHeroStat(heroRS2, 1), GetHeroStat(heroRS2, 2), GetHeroStat(heroRS2, 3), GetHeroStat(heroRS2, 4)};
  if HasHeroSkill(heroRS2, 115) then arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - 2; end;
  if HasHeroSkill(heroRS2, 186) then arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 1; end;
  if HasHeroSkill(heroRS2, 181) then arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 2; end;
  if HasHeroSkill(heroRS2,  87) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2 * SinergyLevel2; end;
  if HasHeroSkill(heroRS2,  81) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2 * SinergyLevel2; end;
--    if SinergyLevel2 == 0 or SinergyLevel2 == 1 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2;
--    elseif SinergyLevel2 == 2 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 3;
--    elseif SinergyLevel2 == 3 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 5;
--    elseif SinergyLevel2 == 4 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 8;
--    end;
--  if HasHeroSkill(heroRS2,  87) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 3; end;
  if HasHeroSkill(heroRS2, 119) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2; end;
  if HasHeroSkill(heroRS2, 127) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2; end;
  if HasHeroSkill(heroRS2,  79) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2; end;
  if HasHeroSkill(heroRS2, 146) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2; end;
  if HasHeroSkill(heroRS2, 185) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2; end;
  if HasHeroSkill(heroRS2, 101) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 1; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 20 then arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 23 then arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 15 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 3  then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 18 then arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - 1; arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 1; arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 1; arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 1; end;
  arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - basicA[getrace(heroRS2)] - statA2;
  arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - basicD[getrace(heroRS2)] - statD2;
  arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - basicS[getrace(heroRS2)] - statS2;
  arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - basicK[getrace(heroRS2)] - statK2;
  ChangeHeroStat( heroRS2, 1, 0 - arrayStatRegenHero2[1]);
  ChangeHeroStat( heroRS2, 2, 0 - arrayStatRegenHero2[2]);
  ChangeHeroStat( heroRS2, 3, 0 - arrayStatRegenHero2[3]);
  ChangeHeroStat( heroRS2, 4, 0 - arrayStatRegenHero2[4]);

  arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][1];
  arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][2];
  arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][3];
  arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][4];
  StatRegenSum2 = arrayStatRegenHero2[1] + arrayStatRegenHero2[2] + arrayStatRegenHero2[3] + arrayStatRegenHero2[4];
  for i = 1, StatRegenSum2 do
    UpHeroStat(heroRS2);
  end;
  GenerateStatLearning2(heroRS2);
  LearningLvl2 = 0;
  Learning2(heroRS2);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - StatRegenCost));
  x, y = GetObjectPosition(heroRS2);
  Play2DSoundForPlayers ( 2, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x, y, 0);
  for i = 1, 15 do
    GiveArtefact (heroRS2, artHero2[i]);
  end;
  sleep(1);
  ArrayStatHero(heroRS2);
end;



arrayStatForLearning1 = {}
arrayStatForLearning1[0] = { 0, 0, 0, 0}
arrayStatForLearning1[1] = { 0, 0, 0, 0}
arrayStatForLearning1[2] = { 0, 0, 0, 0}
arrayStatForLearning1[3] = { 0, 0, 0, 0}

arrayStatForLearning2 = {}
arrayStatForLearning2[0] = { 0, 0, 0, 0}
arrayStatForLearning2[1] = { 0, 0, 0, 0}
arrayStatForLearning2[2] = { 0, 0, 0, 0}
arrayStatForLearning2[3] = { 0, 0, 0, 0}

LearningLvl1 = 0;
LearningLvl2 = 0;
GenerateLearningEnable1 = 0;
GenerateLearningEnable2 = 0;



function GenerateStatLearning1(hero)
  race = getrace(hero);
  for i = 1, 3 do
    for j = 1, 4 do
      arrayStatForLearning1[i][j] = arrayStatForLearning1[i - 1][j];
    end;
    for j = 1, 3 do
      rnd = random(100);
      if rnd < PercentA[race] then
        arrayStatForLearning1[i][1] = arrayStatForLearning1[i][1] + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
        arrayStatForLearning1[i][2] = arrayStatForLearning1[i][2] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning1[i][3] = arrayStatForLearning1[i][3] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning1[i][4] = arrayStatForLearning1[i][4] + 1;
      end;
    end;
  end;
--  print(arrayStatForLearning1[0][1], arrayStatForLearning1[0][2], arrayStatForLearning1[0][3], arrayStatForLearning1[0][4])
--  print(arrayStatForLearning1[1][1], arrayStatForLearning1[1][2], arrayStatForLearning1[1][3], arrayStatForLearning1[1][4])
--  print(arrayStatForLearning1[2][1], arrayStatForLearning1[2][2], arrayStatForLearning1[2][3], arrayStatForLearning1[2][4])
--  print(arrayStatForLearning1[3][1], arrayStatForLearning1[3][2], arrayStatForLearning1[3][3], arrayStatForLearning1[3][4])
  GenerateLearningEnable1 = 1;
end;

function GenerateStatLearning2(hero)
  race = getrace(hero);
  for i = 1, 3 do
    for j = 1, 4 do
      arrayStatForLearning2[i][j] = arrayStatForLearning2[i - 1][j];
    end;
    for j = 1, 3 do
      rnd = random(100);
      if rnd < PercentA[race] then
        arrayStatForLearning2[i][1] = arrayStatForLearning2[i][1] + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
        arrayStatForLearning2[i][2] = arrayStatForLearning2[i][2] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning2[i][3] = arrayStatForLearning2[i][3] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning2[i][4] = arrayStatForLearning2[i][4] + 1;
      end;
    end;
  end;
--  print(arrayStatForLearning2[0][1], arrayStatForLearning2[0][2], arrayStatForLearning2[0][3], arrayStatForLearning2[0][4])
--  print(arrayStatForLearning2[1][1], arrayStatForLearning2[1][2], arrayStatForLearning2[1][3], arrayStatForLearning2[1][4])
--  print(arrayStatForLearning2[2][1], arrayStatForLearning2[2][2], arrayStatForLearning2[2][3], arrayStatForLearning2[2][4])
--  print(arrayStatForLearning2[3][1], arrayStatForLearning2[3][2], arrayStatForLearning2[3][3], arrayStatForLearning2[3][4])
  GenerateLearningEnable2 = 1;
end;

function Learning1(hero)
  if GetHeroSkillMastery(hero, 3) > LearningLvl1 then
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning1[LearningLvl1][1];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusAtt.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning1[LearningLvl1][2];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusDef.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning1[LearningLvl1][3];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusSpp.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning1[LearningLvl1][4];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusKnw.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    LearningLvl1 = GetHeroSkillMastery(hero, 3);
  end;
  if GetHeroSkillMastery(hero, 3) < LearningLvl1 then
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning1[LearningLvl1][1];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusAtt.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning1[LearningLvl1][2];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusDef.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning1[LearningLvl1][3];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusSpp.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning1[LearningLvl1][4];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusKnw.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    LearningLvl1 = GetHeroSkillMastery(hero, 3);
  end;
end;

function Learning2(hero)
  if GetHeroSkillMastery(hero, 3) > LearningLvl2 then
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning2[LearningLvl2][1];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusAtt.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning2[LearningLvl2][2];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusDef.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning2[LearningLvl2][3];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusSpp.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning2[LearningLvl2][4];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusKnw.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    LearningLvl2 = GetHeroSkillMastery(hero, 3);
  end;
  if GetHeroSkillMastery(hero, 3) < LearningLvl2 then
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning2[LearningLvl2][1];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusAtt.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning2[LearningLvl2][2];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusDef.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning2[LearningLvl2][3];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusSpp.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning2[LearningLvl2][4];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusKnw.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    LearningLvl2 = GetHeroSkillMastery(hero, 3);
  end;
end;


function UpHeroStat1(hero)
  race = getrace(hero);
  for i = 1, 3 do
    rnd = random(100);
    if rnd < PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] + 1;
    end;
    if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] + 1;
    end;
  end;
end;

function UpHeroStat2(hero)
  race = getrace(hero);
  for i = 1, 3 do
    rnd = random(100);
    if rnd < PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] + 1;
    end;
    if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] + 1;
    end;
  end;
end;


function UpHeroStat(hero)
  race = getrace(hero);
  rnd = random(100);
  if rnd < PercentA[race] then
    ChangeHeroStat(hero, STAT_ATTACK, 1);
  end;
  if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
    ChangeHeroStat(hero, STAT_DEFENCE, 1);
  end;
  if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
    ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
  end;
  if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
  end;
end;



function DownHeroStat1(hero)
  race = getrace(hero);
  for i = 1, 3 do
    rnd = random(100);
    if rnd < PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] + 1;
    end;
    if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] + 1;
    end;
  end;
end;


function add_hero (race, x1, x2, y1, y2, pl, race_opponent)
  looserHero = 0;
  num_heroes = length(array_heroes[race-1]);

--  print(arrayPossibleHeroes[HeroCollectionPlayer2])

  ------- BLOCK HERO -----------
--  if race == 3 and race_opponent == 3 then array_heroes[2][4].blocked = 1; end;
--  if race == 2 and race_opponent == 6 then array_heroes[1][3].blocked = 1; end;
--  if race == 2 and race_opponent == 3 then array_heroes[1][3].blocked = 1; end;


--  if (race == 6) then num_heroes=12; end;
--  if (race == 1) then num_heroes=13; end;

  for i = 0, 7 do
    for j = 1, length(array_heroes[i]) do
      array_heroes[i][j].block_temply = 1;
    end;
  end;

  if pl == 1 then
    l = length(arrayPossibleHeroes[HeroCollectionPlayer1])
    for i = 1, l do
      rnd = random(l) + 1;
      arrayPossibleHeroes[HeroCollectionPlayer1][i], arrayPossibleHeroes[HeroCollectionPlayer1][rnd] = arrayPossibleHeroes[HeroCollectionPlayer1][rnd], arrayPossibleHeroes[HeroCollectionPlayer1][i];
    end;
    DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].name, x1, y1, 0);
    DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].name, x2, y2, 0);
    HeroMax1 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].name;
    HeroMin1 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].name;
    stop(HeroMax1);
    stop(HeroMin1);
    array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].blocked = 1;
    array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].blocked = 1;
    HeroForScouting1_Player1 = arrayPossibleHeroes[HeroCollectionPlayer1][1];
    HeroForScouting2_Player1 = arrayPossibleHeroes[HeroCollectionPlayer1][2];
    LockMinHeroSkillsAndAttributes(HeroMax1);
    LockMinHeroSkillsAndAttributes(HeroMin1);
    StartArmy(HeroMax1, race);
    StartArmy(HeroMin1, race);
    GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer1][1]);
    GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer1][2]);
  end;
  if pl == 2 then
    num = 0;
    l = length(arrayPossibleHeroes[HeroCollectionPlayer2])
    for i = 1, l do
      rnd = random(l) + 1;
      arrayPossibleHeroes[HeroCollectionPlayer2][i], arrayPossibleHeroes[HeroCollectionPlayer2][rnd] = arrayPossibleHeroes[HeroCollectionPlayer2][rnd], arrayPossibleHeroes[HeroCollectionPlayer2][i];
    end;
    for i = 1, length(arrayPossibleHeroes[HeroCollectionPlayer2]) do
      if array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked ~= 1 and num < 2 then
        if num == 0 then
          DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2, x1, y1, 0);
        else
          DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2, x2, y2, 0);
        end;
        if num == 0 then
          HeroMax2 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2;
          LockMinHeroSkillsAndAttributes(HeroMax2);
          GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer2][i]);
          array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked = 1;
          HeroForScouting1_Player2 = arrayPossibleHeroes[HeroCollectionPlayer2][i];
          num = 1;
        else
          HeroMin2 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2;
          LockMinHeroSkillsAndAttributes(HeroMin2);
          GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer2][i]);
          array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked = 1;
          HeroForScouting2_Player2 = arrayPossibleHeroes[HeroCollectionPlayer2][i];
          num = 2;
        end;
      end;
    end;
    stop(HeroMax2);
    stop(HeroMin2);
    StartArmy(HeroMax2, race);
    StartArmy(HeroMin2, race);
  end;
end;

function unreserve ()
  SetObjectEnabled('taverna1',  nil);
  Trigger (OBJECT_TOUCH_TRIGGER, 'taverna1', 'TavernaQ');
  SetRegionBlocked ('tavern1', true);

  rnd1 = hero1race-1;
  rnd2 = random(length(array_heroes[hero1race-1]))+1;
  while array_heroes[rnd1][rnd2].blocked == 1 do
    rnd2 = random(length(array_heroes[hero1race-1])) + 1;
  end;

  DeployReserveHero(array_heroes[rnd1][rnd2].name, 40, 82, 0);
  stop(array_heroes[rnd1][rnd2].name);
  array_heroes[rnd1][rnd2].blocked = 1;
  HeroDop1 = array_heroes[rnd1][rnd2].name;
  LockMinHeroSkillsAndAttributes(HeroDop1);
  GiveStartSkill( 1, rnd1, rnd2);
  StartArmy(HeroDop1, hero1race);
  HeroForScouting3Race_Player1 = rnd1;
  HeroForScouting3Hero_Player1 = rnd2;

  SetObjectEnabled('taverna2',  nil);
  Trigger (OBJECT_TOUCH_TRIGGER, 'taverna2', 'TavernaQ');
  SetRegionBlocked ('tavern2', true);

  rnd1 = hero2race-1;
  rnd2 = random(length(array_heroes[hero2race-1]))+1;
  while array_heroes[rnd1][rnd2].blocked == 1 do
    rnd2 = random(length(array_heroes[hero2race-1])) + 1;
  end;

  DeployReserveHero(array_heroes[rnd1][rnd2].name2, 53, 18, 0);
  stop(array_heroes[rnd1][rnd2].name2);
  array_heroes[rnd1][rnd2].blocked = 1;
  HeroDop2 = array_heroes[rnd1][rnd2].name2;
  LockMinHeroSkillsAndAttributes(HeroDop2);
  GiveStartSkill( 2, rnd1, rnd2);
  StartArmy(HeroDop2, hero1race);
  HeroForScouting3Race_Player2 = rnd1;
  HeroForScouting3Hero_Player2 = rnd2;
  
  for i = 0, 7 do
    for j = 1, length(array_heroes[i]) do
      array_heroes[i][j].block_temply = 0;
    end;
  end;
end;

function GiveStartSkill(player, a, b)
  if player == 1 then
    GiveHeroSkill(array_heroes[a][b].name, array_heroes[a][b].skill1);
    GiveHeroSkill(array_heroes[a][b].name, array_heroes[a][b].skill2);
  end;
  if player == 2 then
    GiveHeroSkill(array_heroes[a][b].name2, array_heroes[a][b].skill1);
    GiveHeroSkill(array_heroes[a][b].name2, array_heroes[a][b].skill2);
  end;
end;

function TavernaQ(hero)
  if GetObjectOwner(hero) == 1 and GetPlayerResource(1, 6) >= TavernCost then
    if DisableBagPlayer1 == 0 then
      DisableBagPlayer1 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), {GetMapDataPath().."Taverna.txt"; eq = TavernCost}, 'Taverna', 'no1');
    end;
  end;
  if GetObjectOwner(hero) == 2 and GetPlayerResource(2, 6) >= TavernCost then
    if DisableBagPlayer2 == 0 then
      DisableBagPlayer2 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), {GetMapDataPath().."Taverna.txt"; eq = TavernCost}, 'Taverna', 'no2');
    end;
  end;
end;

function Taverna(player)
  if player == 1 then
    SetRegionBlocked ('tavern1', false);
    hodi1(HeroDop1);
    Trigger (OBJECT_TOUCH_TRIGGER, 'taverna1', 'no');
    SetPlayerResource(PLAYER_1, 6, GetPlayerResource(1, 6) - TavernCost);
    DisableBagPlayer1 = 0;
  end;
  if player == 2 then
    SetRegionBlocked ('tavern2', false);
    hodi1(HeroDop2);
    Trigger (OBJECT_TOUCH_TRIGGER, 'taverna2', 'no');
    SetPlayerResource(PLAYER_2, 6, GetPlayerResource(2, 6) - TavernCost);
    DisableBagPlayer2 = 0;
  end;
end;




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

function set_player_resources(player, race, k1, k2, k3, k4, k5, k6, k7)

	--------     HAVEN     INF    NECR     ELF    MAGE    LIGA    GNOM     ORC
	woods    = {     0,      0,      0,      0,      0,      0,      0,      0};
	ores     = {     0,      0,      0,      0,      0,      0,      0,      0};
	mercurys = {     0,      0,      0,      0,      0,      0,      0,      0};
	crystals = {     0,      0,      0,      0,      0,      0,      0,      0};
	sulfurs  = {     0,      0,      0,      0,      0,      0,      0,      0};
	gems     = {     0,      0,      0,      0,      0,      0,      0,      0};
	golds    = {135000, 130000, 130000, 130000, 130000, 130000, 130000, 130000};

  if option[NumberBattle] == 5 then
    golds    = { 115000, 115000, 115000, 115000, 115000, 115000, 115000, 115000};
  end;

  Gold = golds[race];

  if option[NumberBattle] == 2 and player == 2 then
    Gold = Gold * (1 + arrayBonusForSiege[hero2race - 1][hero1race]/100);
  end;

  if option[NumberBattle] == 3 and player == 1 then
    Gold = Gold * (1 + arrayBonusForSiege[hero1race - 1][hero2race]/100);
  end;

  if option[NumberBattle] == 7 then
    Gold = Gold * 0.8;
  end;

  if option[NumberBattle] == 8 then
    Gold = Gold * 1.25;
  end;

  if option[NumberBattle] == 9 then
    Gold = Gold * 1.5;
  end;

	SetPlayerResource(player,    GOLD,           Gold);
	SetPlayerResource(player,    WOOD,    woods[race]);
	SetPlayerResource(player,     ORE,     ores[race]);
	SetPlayerResource(player, MERCURY, mercurys[race]);
	SetPlayerResource(player, CRYSTAL, crystals[race]);
	SetPlayerResource(player,  SULFUR,  sulfurs[race]);
	SetPlayerResource(player,     GEM,     gems[race]);

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

function DeleteRace()
  RemoveObject('human1vrag');
  RemoveObject('demon1vrag');
  RemoveObject('nekr1vrag');
  RemoveObject('elf1vrag');
  RemoveObject('mag1vrag');
  RemoveObject('liga1vrag');
  RemoveObject('gnom1vrag');
  RemoveObject('ork1vrag');
  RemoveObject('human2vrag');
  RemoveObject('demon2vrag');
  RemoveObject('nekr2vrag');
  RemoveObject('elf2vrag');
  RemoveObject('mag2vrag');
  RemoveObject('liga2vrag');
  RemoveObject('gnom2vrag');
  RemoveObject('ork2vrag');
  RemoveObject('human1');
  RemoveObject('demon1');
  RemoveObject('nekr1');
  RemoveObject('elf1');
  RemoveObject('mag1');
  RemoveObject('liga1');
  RemoveObject('gnom1');
  RemoveObject('ork1');
  RemoveObject('human2');
  RemoveObject('demon2');
  RemoveObject('nekr2');
  RemoveObject('elf2');
  RemoveObject('mag2');
  RemoveObject('liga2');
  RemoveObject('gnom2');
  RemoveObject('ork2');
end;


arrayGrade1 = {};
arrayGrade2 = {};
arrayGrade1 = {  1,   3,   5,   7,   9,  11,  13,  15,  17,  19,  21,  23,  25,  27,  29,  31,  34,  35,  37,  39,  41,  43,  45,  47,  49,  51,  53,  55,  57,  59,  61,  63,  65,  67,  69,  71,  73,  75,  77,  79,  81,  83,  92,  94,  96,  98, 100, 102, 105, 117, 119, 121, 123, 125, 127, 129}
arrayGrade2 = {106, 107, 108, 109, 110, 111, 112, 131, 132, 133, 134, 135, 136, 137, 152, 153, 154, 155, 156, 157, 158, 145, 146, 147, 148, 149, 150, 151, 159, 160, 161, 162, 163, 164, 165, 138, 139, 140, 141, 142, 143, 144, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179}

function Regrade_CUSTOM_F(hero, CUSTOM_ABILITY)

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

end;

function RegradeUnit1()
  x11, y11 = GetObjectPosition(HeroR1);
  while (x11 == x1 and y11 == y1) do
    RegradeUse1 = 0;
    for a = 1, length(arrayGrade1) do
      if GetObjectCreatures('regrade1', arrayGrade1[a]) > 0 then
        AddHeroCreatures(HeroR1, arrayGrade2[a], GetObjectCreatures('regrade1', arrayGrade1[a]));
        --Play3DSoundForPlayers ( 1, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x1, y1, 0);
        RegradeUse1 = 1;
        delCreat1 = GetObjectCreatures('regrade1', arrayGrade1[a]);
        RemoveObjectCreatures('regrade1', arrayGrade1[a], delCreat1);
        a = length(arrayGrade1);
      end;
    end;
    if RegradeUse1 == 0 then
      for a = 1, length(arrayGrade2) do
        if GetObjectCreatures('regrade1', arrayGrade2[a]) > 0 then
          AddHeroCreatures(HeroR1, arrayGrade1[a], GetObjectCreatures('regrade1', arrayGrade2[a]));
          --Play3DSoundForPlayers ( 1, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x1, y1, 0);
          RegradeUse1 = 1;
          delCreat1 = GetObjectCreatures('regrade1', arrayGrade2[a]);
          RemoveObjectCreatures('regrade1', arrayGrade2[a], delCreat1);
          a = length(arrayGrade2);
        end;
      end;
    end;
    sleep(1);
    x11, y11 = GetObjectPosition(HeroR1);
  end;
end;

function RegradeUnit2()
  x22, y22 = GetObjectPosition(HeroR2);
  while (x22 == x2 and y22 == y2) do
    RegradeUse2 = 0;
    for b = 1, length(arrayGrade1) do
      if GetObjectCreatures('regrade2', arrayGrade1[b]) > 0 then
        AddHeroCreatures(HeroR2, arrayGrade2[b], GetObjectCreatures('regrade2', arrayGrade1[b]));
        RegradeUse2 = 1;
        delCreat2 = GetObjectCreatures('regrade2', arrayGrade1[b]);
        RemoveObjectCreatures('regrade2', arrayGrade1[b], delCreat2);
        b = length(arrayGrade1);
      end;
    end;
    if RegradeUse2 == 0 then
      for b = 1, length(arrayGrade2) do
        if GetObjectCreatures('regrade2', arrayGrade2[b]) > 0 then
          AddHeroCreatures(HeroR2, arrayGrade1[b], GetObjectCreatures('regrade2', arrayGrade2[b]));
          RegradeUse2 = 1;
          delCreat2 = GetObjectCreatures('regrade2', arrayGrade2[b]);
          RemoveObjectCreatures('regrade2', arrayGrade2[b], delCreat2);
          b = length(arrayGrade2);
        end;
      end;
    end;
    sleep(1);
    x22, y22 = GetObjectPosition(HeroR2);
  end;
end;


function NameTown(player)
  if player == 1 then name = 'RANDOMTOWN1'; end;
  if player == 2 then name = 'RANDOMTOWN2'; end;
  return name;
end;


function SetPl1Position ()
  if podvariant == 1 then
    if hero1race == 1 then SetObjectPosition(heroes1[0], 85, 61); end;
    if hero1race == 2 then SetObjectPosition(heroes1[0], 49, 83); end;
    if hero1race == 3 then SetObjectPosition(heroes1[0], 72, 75); end;
    if hero1race == 4 then SetObjectPosition(heroes1[0], 89, 77); end;
    if hero1race == 5 then SetObjectPosition(heroes1[0],  9, 81); end;
    if hero1race == 6 then SetObjectPosition(heroes1[0], 23, 75); end;
    if hero1race == 7 then SetObjectPosition(heroes1[0], 31, 83); end;
    if hero1race == 8 then SetObjectPosition(heroes1[0], 70, 62); end;
  else SetObjectPosition (heroes1[0], 35, 87);
  end;
end;

function SetPl2Position ()
  if podvariant == 1 then
    if hero2race == 1 then SetObjectPosition(heroes2[0], 35, 35); end;
    if hero2race == 2 then SetObjectPosition(heroes2[0], 44, 17); end;
    if hero2race == 3 then SetObjectPosition(heroes2[0], 20, 20); end;
    if hero2race == 4 then SetObjectPosition(heroes2[0], 12, 12); end;
    if hero2race == 5 then SetObjectPosition(heroes2[0], 86, 18); end;
    if hero2race == 6 then SetObjectPosition(heroes2[0], 71, 17); end;
    if hero2race == 7 then SetObjectPosition(heroes2[0], 60, 16); end;
    if hero2race == 8 then SetObjectPosition(heroes2[0], 16, 35); end;
  else SetObjectPosition (heroes2[0], 42, 22);
  end;
end;


------ ELF ARMIES ---------------------------------------------------------------

function elf_arm ()
if hero1race == 4 then
	if hero2race == 1 then SetObjectPosition('havenarmy1', 37, 78); end;
	if hero2race == 2 then SetObjectPosition('infarmy1', 37, 78); end;
	if hero2race == 3 then SetObjectPosition('necroarmy1', 37, 78); end;
	if hero2race == 4 then SetObjectPosition('elfarmy1', 37, 78); end;
	if hero2race == 5 then SetObjectPosition('magearmy1', 37, 78); end;
	if hero2race == 6 then SetObjectPosition('ligaarmy1', 37, 78); end;
	if hero2race == 7 then SetObjectPosition('gnomarmy1', 37, 78); end;
	if hero2race == 8 then SetObjectPosition('orcarmy1', 37, 78); end;
end;

if hero2race == 4 then
	if hero1race == 1 then SetObjectPosition('havenarmy2', 25, 11); end;
	if hero1race == 2 then SetObjectPosition('infarmy2', 25, 11); end;
	if hero1race == 3 then SetObjectPosition('necroarmy2', 25, 11); end;
	if hero1race == 4 then SetObjectPosition('elfarmy2', 25, 11); end;
	if hero1race == 5 then SetObjectPosition('magearmy2', 25, 11); end;
	if hero1race == 6 then SetObjectPosition('ligaarmy2', 25, 11); end;
	if hero1race == 7 then SetObjectPosition('gnomarmy2', 25, 11); end;
	if hero1race == 8 then SetObjectPosition('orcarmy2', 25, 11); end;
end;
end;

---------------------- MINIARTS ----------------------------------------------------

minikUse1 = 0;
minikUse2 = 0;

function MiniArts1()
  if minikUse1 == 0 then
    UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
    pause1 = 0;
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."CreateMinik.txt", 'pause1F');
    while pause1 == 0 do
      sleep(1);
    end;
    -- холодная сталь
--    if (HasHeroSkill(HeroMax1, 104) or HasHeroSkill(HeroMax1, 82)) then
--      DublikatHero1( HeroMax1);
--    end;
    
    if Name(HeroMax1) == "Maahir" then DeltaRes = 15; else DeltaRes = 0; end;
    
    -- Джалиб
    if Name(HeroMax1) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax1,  65); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  65, kolCreatures); AddHeroCreatures(HeroMax1, 68, kolCreatures); end; end;
    if Name(HeroMax1) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax1, 163); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 163, kolCreatures); AddHeroCreatures(HeroMax1, 70, kolCreatures); end; end;

    -- солдатская удача
    if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1,  57); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  57, kolCreatures); AddHeroCreatures(HeroMax1, 60, kolCreatures); end; end;
    if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 165); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 165, kolCreatures); AddHeroCreatures(HeroMax1, 64, kolCreatures); end; end;

    if GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) == 1 then
      SetPlayerResource(1,    WOOD, 10 + DeltaRes);
    	SetPlayerResource(1,     ORE, 10 + DeltaRes);
    	SetPlayerResource(1, MERCURY, 10 + DeltaRes);
    	SetPlayerResource(1, CRYSTAL, 10 + DeltaRes);
    	SetPlayerResource(1,  SULFUR, 10 + DeltaRes);
    	SetPlayerResource(1,     GEM, 10 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) == 2 then
      SetPlayerResource(1,    WOOD, 20 + DeltaRes);
    	SetPlayerResource(1,     ORE, 20 + DeltaRes);
    	SetPlayerResource(1, MERCURY, 20 + DeltaRes);
    	SetPlayerResource(1, CRYSTAL, 20 + DeltaRes);
    	SetPlayerResource(1,  SULFUR, 20 + DeltaRes);
    	SetPlayerResource(1,     GEM, 20 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) >= 3 then
      SetPlayerResource(1,    WOOD, 30 + DeltaRes);
    	SetPlayerResource(1,     ORE, 30 + DeltaRes);
    	SetPlayerResource(1, MERCURY, 30 + DeltaRes);
    	SetPlayerResource(1, CRYSTAL, 30 + DeltaRes);
    	SetPlayerResource(1,  SULFUR, 30 + DeltaRes);
    	SetPlayerResource(1,     GEM, 30 + DeltaRes);
    end;
    minikUse1 = 1;
    SetObjectPosition('port1', 39, 80, 0);
    Trigger( OBJECT_TOUCH_TRIGGER, 'port1', 'TeleportBattleZone1' );
    SetObjectEnabled('port1', nil);
    SetDisabledObjectMode('port1', 2);
  end;
end;

function MiniArts2()
  if minikUse2 == 0 then
    UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
    pause2 = 0;
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."CreateMinik.txt", 'pause2F');
    while pause2 == 0 do
      sleep(1);
    end;
    -- холодная сталь
--    if (HasHeroSkill(HeroMax2, 104) or HasHeroSkill(HeroMax2, 82)) then
--      DublikatHero2( HeroMax2);
--    end;
    
    if Name(HeroMax2) == "Maahir" then DeltaRes = 15; else DeltaRes = 0; end;

    -- Джалиб
    if Name(HeroMax2) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax2,  65); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  65, kolCreatures); AddHeroCreatures(HeroMax2, 68, kolCreatures); end; end;
    if Name(HeroMax2) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax2, 163); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 163, kolCreatures); AddHeroCreatures(HeroMax2, 70, kolCreatures); end; end;

    -- солдатская удача
    if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2,  57); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  57, kolCreatures); AddHeroCreatures(HeroMax2, 60, kolCreatures); end; end;
    if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 165); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 165, kolCreatures); AddHeroCreatures(HeroMax2, 64, kolCreatures); end; end;

    if GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) == 1 then
      SetPlayerResource(2,    WOOD, 10 + DeltaRes);
    	SetPlayerResource(2,     ORE, 10 + DeltaRes);
    	SetPlayerResource(2, MERCURY, 10 + DeltaRes);
    	SetPlayerResource(2, CRYSTAL, 10 + DeltaRes);
    	SetPlayerResource(2,  SULFUR, 10 + DeltaRes);
    	SetPlayerResource(2,     GEM, 10 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) == 2 then
      SetPlayerResource(2,    WOOD, 20 + DeltaRes);
    	SetPlayerResource(2,     ORE, 20 + DeltaRes);
    	SetPlayerResource(2, MERCURY, 20 + DeltaRes);
    	SetPlayerResource(2, CRYSTAL, 20 + DeltaRes);
    	SetPlayerResource(2,  SULFUR, 20 + DeltaRes);
    	SetPlayerResource(2,     GEM, 20 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) >= 3 then
      SetPlayerResource(2,    WOOD, 30 + DeltaRes);
    	SetPlayerResource(2,     ORE, 30 + DeltaRes);
    	SetPlayerResource(2, MERCURY, 30 + DeltaRes);
    	SetPlayerResource(2, CRYSTAL, 30 + DeltaRes);
    	SetPlayerResource(2,  SULFUR, 30 + DeltaRes);
    	SetPlayerResource(2,     GEM, 30 + DeltaRes);
    end;
    minikUse2 = 1;
    SetObjectPosition('port2', 47, 11, 0);
    Trigger( OBJECT_TOUCH_TRIGGER, 'port2', 'TeleportBattleZone2' );
    SetObjectEnabled('port2', nil);
    SetDisabledObjectMode('port2', 2);
  end;
end;

function UpgradeMiniArts1()
  heroes1 = GetPlayerHeroes(PLAYER_1);
  for i = 1, (length(heroes1) - 1) do
    if IsHeroInTown(heroes1[i], 'RANDOMTOWN1', 1, 0) then
      x, y = GetObjectPosition(heroes1[i]);
      MoveHeroRealTime(heroes1[i], x, y - 2);
    end;
  end;
  sleep(2);
  HeroKnowledge1 = GetHeroStat(HeroMax1, 4);
  if HeroMax1 == "Maahir" or HeroMax1 == "Maahir2" then DeltaKnow1 = int(0.25 * GetHeroLevel(HeroMax1)); else DeltaKnow1 = 0; end;
--  DeltaKnow1 = GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) * 5 - 5 - GetHeroStat(HeroMax1, 1) - GetHeroStat(HeroMax1, 2);
--  if (HeroKnowledge1 + DeltaKnow1) < 2 then DeltaKnow1 = 1 - HeroKnowledge1; end;
  ChangeHeroStat(HeroMax1, 4, DeltaKnow1);
  UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
  DisableAutoEnterTown('RANDOMTOWN1', true);
  MakeHeroInteractWithObject (HeroMax1, 'RANDOMTOWN1');
  ChangeHeroStat(HeroMax1, 4, 0 - DeltaKnow1);
  x, y = GetObjectPosition(HeroMax1);

  if x ~= 43 then
    MoveHeroRealTime(HeroMax1, x-1, y);
    MoveHeroRealTime(HeroMax1, x, y);
  else
    MoveHeroRealTime(HeroMax1, x+1, y);
    MoveHeroRealTime(HeroMax1, x, y);
  end;

end;

function UpgradeMiniArts2()
  heroes2 = GetPlayerHeroes(PLAYER_2);
  for i = 1, (length(heroes2) - 1) do
    if IsHeroInTown(heroes2[i], 'RANDOMTOWN2', 1, 0) then
      x, y = GetObjectPosition(heroes2[i]);
      MoveHeroRealTime(heroes2[i], x, y + 2);
    end;
  end;
  sleep(2);
  HeroKnowledge2 = GetHeroStat(HeroMax2, 4);
  if HeroMax1 == "Maahir" or HeroMax1 == "Maahir2" then DeltaKnow2 = int(0.25 * GetHeroLevel(HeroMax1)); else DeltaKnow2 = 0; end;
--  DeltaKnow2 = GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) * 5 - 5 - GetHeroStat(HeroMax2, 1) - GetHeroStat(HeroMax2, 2);
--  if (HeroKnowledge2 + DeltaKnow2) < 2 then DeltaKnow2 = 1 - HeroKnowledge2; end;
  ChangeHeroStat(HeroMax2, 4, DeltaKnow2);
  UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
  DisableAutoEnterTown('RANDOMTOWN2', true);
  MakeHeroInteractWithObject (HeroMax2, 'RANDOMTOWN2');
  ChangeHeroStat(HeroMax2, 4, 0 - DeltaKnow2);
  x, y = GetObjectPosition(HeroMax2);
  if x ~= 43 then
    MoveHeroRealTime(HeroMax2, x-1, y);
    MoveHeroRealTime(HeroMax2, x, y);
  else
    MoveHeroRealTime(HeroMax2, x+1, y);
    MoveHeroRealTime(HeroMax2, x, y);
  end;
end;

function MiniArtsRes1()
  if (GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) == 2 and minikUse1 == 1) or (GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) == 3 and minikUse1 == 2) then
    SetPlayerResource(1,    WOOD, GetPlayerResource(1,    WOOD) + 10);
  	SetPlayerResource(1,     ORE, GetPlayerResource(1,     ORE) + 10);
  	SetPlayerResource(1, MERCURY, GetPlayerResource(1, MERCURY) +  5);
  	SetPlayerResource(1, CRYSTAL, GetPlayerResource(1, CRYSTAL) +  5);
  	SetPlayerResource(1,  SULFUR, GetPlayerResource(1,  SULFUR) +  5);
  	SetPlayerResource(1,     GEM, GetPlayerResource(1,     GEM) +  5);
  	minikUse1 = minikUse1 + 1;
  end;
  if (GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) == 3 and minikUse1 == 1) then
    SetPlayerResource(1,    WOOD, GetPlayerResource(1,    WOOD) + 20);
  	SetPlayerResource(1,     ORE, GetPlayerResource(1,     ORE) + 20);
  	SetPlayerResource(1, MERCURY, GetPlayerResource(1, MERCURY) + 10);
  	SetPlayerResource(1, CRYSTAL, GetPlayerResource(1, CRYSTAL) + 10);
  	SetPlayerResource(1,  SULFUR, GetPlayerResource(1,  SULFUR) + 10);
  	SetPlayerResource(1,     GEM, GetPlayerResource(1,     GEM) + 10);
  	minikUse1 = minikUse1 + 2;
  end;
end;

function MiniArtsRes2()
  if (GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) == 2 and minikUse2 == 1) or (GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) == 3 and minikUse2 == 2) then
    SetPlayerResource(2,    WOOD, GetPlayerResource(2,    WOOD) + 10);
  	SetPlayerResource(2,     ORE, GetPlayerResource(2,     ORE) + 10);
  	SetPlayerResource(2, MERCURY, GetPlayerResource(2, MERCURY) +  5);
  	SetPlayerResource(2, CRYSTAL, GetPlayerResource(2, CRYSTAL) +  5);
  	SetPlayerResource(2,  SULFUR, GetPlayerResource(2,  SULFUR) +  5);
  	SetPlayerResource(2,     GEM, GetPlayerResource(2,     GEM) +  5);
  	minikUse2 = minikUse2 + 1;
  end;
  if (GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) == 3 and minikUse2 == 1) then
    SetPlayerResource(2,    WOOD, GetPlayerResource(2,    WOOD) + 20);
  	SetPlayerResource(2,     ORE, GetPlayerResource(2,     ORE) + 20);
  	SetPlayerResource(2, MERCURY, GetPlayerResource(2, MERCURY) + 10);
  	SetPlayerResource(2, CRYSTAL, GetPlayerResource(2, CRYSTAL) + 10);
  	SetPlayerResource(2,  SULFUR, GetPlayerResource(2,  SULFUR) + 10);
  	SetPlayerResource(2,     GEM, GetPlayerResource(2,     GEM) + 10);
  	minikUse2 = minikUse2 + 2;
  end;
end;

------- BONUS -----------------------------------------------------------------------

function bonus (player, a, b, c, d, e, f)
  KoefBonus1 = 1;
  KoefBonus2 = 1;
-- ЛЮДИ
  if (hero1race == 1 and hero2race == 3) then KoefBonus1 = 1.05; end;
  if (hero2race == 1 and hero1race == 3) then KoefBonus2 = 1.05; end;
  if (hero1race == 1 and hero2race == 2) then KoefBonus1 = 1.10; ChangeHeroStat(HeroMax1, 4, 2); ChangeHeroStat(HeroMin1, 4, 2); end;
  if (hero2race == 1 and hero1race == 2) then KoefBonus2 = 1.10; ChangeHeroStat(HeroMax2, 4, 2); ChangeHeroStat(HeroMin2, 4, 2); end;
  if (hero1race == 1 and hero2race == 6) then KoefBonus1 = 1.05; end;
  if (hero2race == 1 and hero1race == 6) then KoefBonus2 = 1.05; end;
  if (hero1race == 1 and hero2race == 7) then KoefBonus1 = 1.05; end;
  if (hero2race == 1 and hero1race == 7) then KoefBonus2 = 1.05; end;
  if (hero1race == 1 and hero2race == 8) then KoefBonus1 = 1.05; end;
  if (hero2race == 1 and hero1race == 8) then KoefBonus2 = 1.05; end;
-- НЕКРОПОЛИС
  if (hero1race == 3 and hero2race == 2) then KoefBonus1 = 1.05; end;
  if (hero2race == 3 and hero1race == 2) then KoefBonus2 = 1.05; end;
  if (hero1race == 3 and hero2race == 4) then KoefBonus1 = 1.05; end;
  if (hero2race == 3 and hero1race == 4) then KoefBonus2 = 1.05; end;
  if (hero1race == 3 and hero2race == 5) then KoefBonus1 = 1.10; end;
  if (hero2race == 3 and hero1race == 5) then KoefBonus2 = 1.10; end;
-- ЭЛЬФЫ
  if (hero1race == 4 and hero2race == 8) then KoefBonus1 = 1.05; end;
  if (hero2race == 4 and hero1race == 8) then KoefBonus2 = 1.05; end;
-- МАГИ
  if (hero1race == 5 and hero2race == 7) then KoefBonus1 = 1.05; end;
  if (hero2race == 5 and hero1race == 7) then KoefBonus2 = 1.05; end;
  if (hero1race == 5 and hero2race == 8) then KoefBonus1 = 1.05; end;
  if (hero2race == 5 and hero1race == 8) then KoefBonus2 = 1.05; end;
-- ЛИГА
  if (hero1race == 6 and hero2race == 7) then KoefBonus1 = 1.05; end;
  if (hero2race == 6 and hero1race == 7) then KoefBonus2 = 1.05; end;
  if (hero1race == 6 and hero2race == 8) then KoefBonus1 = 1.05; end;
  if (hero2race == 6 and hero1race == 8) then KoefBonus2 = 1.05; end;
-- ГНОМЫ
  if (hero1race == 7 and hero2race == 2) then KoefBonus1 = 1.10; end;
  if (hero2race == 7 and hero1race == 2) then KoefBonus2 = 1.10; end;
  if (hero1race == 7 and hero2race == 3) then KoefBonus1 = 1.10; end;
  if (hero2race == 7 and hero1race == 3) then KoefBonus2 = 1.10; end;
  if (hero1race == 7 and hero2race == 8) then KoefBonus1 = 1.05; end;
  if (hero2race == 7 and hero1race == 8) then KoefBonus2 = 1.05; end;
-- ОРКИ
  if (hero1race == 8 and hero2race == 3) then KoefBonus1 = 1.05; end;
  if (hero2race == 8 and hero1race == 3) then KoefBonus2 = 1.05; end;

  if player == 1 then
    a = intg (a * KoefBonus1);
    b = intg (b * KoefBonus1);
    c = intg (c * KoefBonus1);
    d = intg (d * KoefBonus1);
    e = intg (e * KoefBonus1);
    f = intg (f * KoefBonus1);
  end;
  if player == 2 then
    a = intg (a * KoefBonus2);
    b = intg (b * KoefBonus2);
    c = intg (c * KoefBonus2);
    d = intg (d * KoefBonus2);
    e = intg (e * KoefBonus2);
    f = intg (f * KoefBonus2);
  end;
  return a, b, c, d, e, f;
end;

function BonusForSiege (player, race1, race2, a, b, c, d, e, f, g)
  a = intg (a * (1 + arrayBonusForSiege[race1 - 1][race2]/100));
  b = intg (b * (1 + arrayBonusForSiege[race1 - 1][race2]/100));
  c = intg (c * (1 + arrayBonusForSiege[race1 - 1][race2]/100));
  d = intg (d * (1 + arrayBonusForSiege[race1 - 1][race2]/100));
  e = intg (e * (1 + arrayBonusForSiege[race1 - 1][race2]/100));
  f = intg (f * (1 + arrayBonusForSiege[race1 - 1][race2]/100));
  g = intg (g * (1 + arrayBonusForSiege[race1 - 1][race2]/100));
  return a, b, c, d, e, f, g;
end;

function rnd_plus_minus(ttt)
  rnd_p_m = random (2);
  if rnd_p_m == 0 then rnd_p_m = -1; end;
  return rnd_p_m;
end;

kol_u = {};
price = {};

function rnd_army(race)

  kol_u[0]=0;kol_u[1]=0;kol_u[2]=0;kol_u[3]=0;kol_u[4]=0;kol_u[5]=0;kol_u[6]=0;kol_u[7]=0;

  price[0]=0;price[1]=0;price[2]=0;price[3]=0;price[4]=0;price[5]=0;price[6]=0;price[7]=0;
  price_all = 0;

  kol_u[7] = array_units[race][7].kol;
  price[7] = kol_u[7] * array_units[race][7].price1 - array_units[race][7].kol * array_units[race][7].price1;

  kol_u[6] = random(3) + array_units[race][6].kol - 1;
  price[6] = kol_u[6] * array_units[race][6].price1 - array_units[race][6].kol * array_units[race][6].price1;
  price_all = price[7] + price[6];

  rpm = rnd_plus_minus(1);
  kol_u[5] = rpm * random(array_units[race][5].kol * 0.1) + array_units[race][5].kol;
  price[5] = kol_u[5] * array_units[race][5].price1 - array_units[race][5].kol * array_units[race][5].price1;
  price_all = price_all + price[5];

  rpm = rnd_plus_minus(1);
  kol_u[4] = rpm * random(array_units[race][4].kol * 0.1) + array_units[race][4].kol;
  price[4] = kol_u[4] * array_units[race][4].price1 - array_units[race][4].kol * array_units[race][4].price1;
  price_all = price_all + price[4];

  rpm = rnd_plus_minus(1);
  kol_u[3] = rpm * random(array_units[race][3].kol * 0.1) + array_units[race][3].kol;
  price[3] = kol_u[3] * array_units[race][3].price1 - array_units[race][3].kol * array_units[race][3].price1;
  price_all = price_all + price[3];

  rpm = rnd_plus_minus(1);
  kol_u[2] = rpm * random(array_units[race][2].kol * 0.1) + array_units[race][2].kol;
  price[2] = kol_u[2] * array_units[race][2].price1 - array_units[race][2].kol * array_units[race][2].price1;
  price_all = price_all + price[2];

  u_n = 7;
  price[1] = array_units[race][1].price1 * array_units[race][1].kol * 0.1;

  if price_all < (-price[1]) then
    while u_n > 1 do
      if price[u_n] < 0 then
        price_all = price_all + array_units[race][u_n].price1;
        kol_u[u_n] = kol_u[u_n] + 1;
      end;
      u_n = u_n - 1;
      if u_n == 1 then u_n = 6; end;
      if price_all > (-price[1]) then u_n = 1; end;
    end;
  end;

  if price_all > price[1] then
    while u_n > 1 do
      if price[u_n] > 0 then
        price_all = price_all - array_units[race][u_n].price1;
        kol_u[u_n] = kol_u[u_n] - 1;
      end;
      u_n = u_n - 1;
      if u_n == 1 then u_n = 6; end;
      if price_all < price[1] then u_n = 1; end;
    end;
  end;

  kol_u[1] = intg(array_units[race][1].kol - price_all / array_units[race][1].price1);

  if option[NumberBattle] == 7 then
    kol_u[1] = intg(0.75 * kol_u[1]);
    kol_u[2] = intg(0.75 * kol_u[2]);
    kol_u[3] = intg(0.75 * kol_u[3]);
    kol_u[4] = intg(0.75 * kol_u[4]);
    kol_u[5] = intg(0.75 * kol_u[5]);
    kol_u[6] = intg(0.75 * kol_u[6]);
    kol_u[7] = intg(0.75 * kol_u[7]);
  end;

  if option[NumberBattle] == 8 then
    kol_u[1] = intg(1.25 * kol_u[1]);
    kol_u[2] = intg(1.25 * kol_u[2]);
    kol_u[3] = intg(1.25 * kol_u[3]);
    kol_u[4] = intg(1.25 * kol_u[4]);
    kol_u[5] = intg(1.25 * kol_u[5]);
    kol_u[6] = intg(1.25 * kol_u[6]);
    kol_u[7] = intg(1.25 * kol_u[7]);
  end;

  if option[NumberBattle] == 9 then
    kol_u[1] = intg(1.50 * kol_u[1]);
    kol_u[2] = intg(1.50 * kol_u[2]);
    kol_u[3] = intg(1.50 * kol_u[3]);
    kol_u[4] = intg(1.50 * kol_u[4]);
    kol_u[5] = intg(1.50 * kol_u[5]);
    kol_u[6] = intg(1.50 * kol_u[6]);
    kol_u[7] = intg(1.50 * kol_u[7]);
  end;


  return kol_u[1], kol_u[2], kol_u[3], kol_u[4], kol_u[5], kol_u[6], kol_u[7];

end;



PlayerInTown = 0;
PlayerInBoat = 0;

function TownAndBoat()
  ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED);
  ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED);
  ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED);
  ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED);
  for i = 1, 305 do
    if GetHeroStat(HeroMax1, STAT_EXPERIENCE) > 1000 or GetHeroStat(HeroMax2, STAT_EXPERIENCE) > 1000
    or GetHeroStat(HeroMin1, STAT_EXPERIENCE) > 1000 or GetHeroStat(HeroMin2, STAT_EXPERIENCE) > 1000
    or GetHeroStat(HeroDop1, STAT_EXPERIENCE) > 1000 or GetHeroStat(HeroDop2, STAT_EXPERIENCE) > 1000 or i == 305 then
      ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
      ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
      ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
      ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    end;
    sleep (3);
--    print (i);
  end;
end;


function TownAndBoat_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == heroes1[0]) then
    if (GetPlayerResource(PLAYER_1, GOLD) >= 35000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."TownVopros.txt", 'TownYES1', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == heroes1[0]) then
    if (GetPlayerResource(PLAYER_1, GOLD) >= 15000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."BoatVopros.txt", 'BoatYES1', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == heroes2[0]) then
    if (GetPlayerResource(PLAYER_2, GOLD) >= 35000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."TownVopros.txt", 'TownYES2', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == heroes2[0]) then
    if (GetPlayerResource(PLAYER_2, GOLD) >= 15000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."BoatVopros.txt", 'BoatYES2', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

end;

function TownYES1()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - 35000));
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 35000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."TownInfo.txt" );
    PlayerInTown = 1;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function TownYES2()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - 35000));
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 35000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."TownInfo.txt" );
    PlayerInTown = 2;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function BoatYES1()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - 15000));
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 15000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."BoatInfo.txt" );
    PlayerInBoat = 1;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function BoatYES2()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - 15000));
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 15000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."BoatInfo.txt" );
    PlayerInBoat = 2;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function BattleInTown1()
  DisableAutoEnterTown('RANDOMTOWN1', true);
  MakeHeroInteractWithObject (HeroMax1, 'RANDOMTOWN1'  );
  MakeHeroInteractWithObject (HeroMax2, HeroMax1);
end;

function BattleInTown2()
  DisableAutoEnterTown('RANDOMTOWN2', true);
  MakeHeroInteractWithObject (HeroMax2, 'RANDOMTOWN2'  );
  MakeHeroInteractWithObject (HeroMax1, HeroMax2);
end;

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


function GraalVision(hero, stat)
--  print('1');
  if GetCurrentMoonWeek() == 20 then       --'WEEK_OF_ANTILOPE' НЕДЕЛЯ АТАКИ
    ChangeHeroStat(hero, 1, 3 * stat);
  end;
--  print('2');
  if GetCurrentMoonWeek() == 23 then         --'WEEK_OF_BADGER' НЕДЕЛЯ ЗАЩИТЫ
    ChangeHeroStat(hero, 2, 3 * stat);
  end;
--  print('3');
  if GetCurrentMoonWeek() == 15 then            --'WEEK_OF_BEE' НЕДЕЛЯ КОЛДОВСТВА
    ChangeHeroStat(hero, 3, 3 * stat);
  end;
--  print('4');
  if GetCurrentMoonWeek() == 3 then         --'WEEK_OF_BEETLE' НЕДЕЛЯ ЗНАНИЯ
    ChangeHeroStat(hero, 4, 3 * stat);
  end;
--  print('5');
  if GetCurrentMoonWeek() == 18 then      --'WEEK_OF_BUTTERFLY' НЕДЕЛЯ РАВНОВЕСИЯ
    ChangeHeroStat(hero, 1, stat);
    ChangeHeroStat(hero, 2, stat);
    ChangeHeroStat(hero, 3, stat);
    ChangeHeroStat(hero, 4, stat);
  end;
end;


function GraalVisionOld(hero, race)
--  print('1');
  if GetCurrentMoonWeek() == 20 then       --'WEEK_OF_ANTILOPE' НЕДЕЛЯ АТАКИ
    ChangeHeroStat(hero, 1, 3);
  end;
--  print('2');
  if GetCurrentMoonWeek() == 23 then         --'WEEK_OF_BADGER' НЕДЕЛЯ ЗАЩИТЫ
    ChangeHeroStat(hero, 2, 3);
  end;
--  print('3');
  if GetCurrentMoonWeek() == 15 then            --'WEEK_OF_BEE' НЕДЕЛЯ КОЛДОВСТВА
    ChangeHeroStat(hero, 3, 3);
  end;
--  print('4');
  if GetCurrentMoonWeek() == 3 then         --'WEEK_OF_BEETLE' НЕДЕЛЯ ЗНАНИЯ
    ChangeHeroStat(hero, 4, 3);
  end;
--  print('5');
  if GetCurrentMoonWeek() == 18 then      --'WEEK_OF_BUTTERFLY' НЕДЕЛЯ РАВНОВЕСИЯ
    ChangeHeroStat(hero, 1, 1);
    ChangeHeroStat(hero, 2, 1);
    ChangeHeroStat(hero, 3, 1);
    ChangeHeroStat(hero, 4, 1);
  end;
--  print('6');
  if GetCurrentMoonWeek() == 10 then     --'WEEK_OF_CATERPILLAR' НЕДЕЛЯ СИЛЫ
    if GetHeroStat(hero, 1) >= GetHeroStat(hero, 2) and GetHeroStat(hero, 1) >= GetHeroStat(hero, 3) and GetHeroStat(hero, 1) >= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 1, 3);
    end;
    if GetHeroStat(hero, 2) >= GetHeroStat(hero, 1) and GetHeroStat(hero, 2) >= GetHeroStat(hero, 3) and GetHeroStat(hero, 2) >= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 2, 3);
    end;
    if GetHeroStat(hero, 3) >= GetHeroStat(hero, 1) and GetHeroStat(hero, 3) >= GetHeroStat(hero, 2) and GetHeroStat(hero, 3) >= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 3, 3);
    end;
    if GetHeroStat(hero, 4) >= GetHeroStat(hero, 1) and GetHeroStat(hero, 4) >= GetHeroStat(hero, 2) and GetHeroStat(hero, 4) >= GetHeroStat(hero, 3) then
      ChangeHeroStat(hero, 4, 3);
    end;
  end;
--  print('7');
  if GetCurrentMoonWeek() == 38 then            --'WEEK_OF_DEER' НЕДЕЛЯ РАВНОВЕСИЯ
    if GetHeroStat(hero, 1) <= GetHeroStat(hero, 2) and GetHeroStat(hero, 1) <= GetHeroStat(hero, 3) and GetHeroStat(hero, 1) <= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 1, 5);
    end;
    if GetHeroStat(hero, 2) <= GetHeroStat(hero, 1) and GetHeroStat(hero, 2) <= GetHeroStat(hero, 3) and GetHeroStat(hero, 2) <= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 2, 5);
    end;
    if GetHeroStat(hero, 3) <= GetHeroStat(hero, 1) and GetHeroStat(hero, 3) <= GetHeroStat(hero, 2) and GetHeroStat(hero, 3) <= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 3, 5);
    end;
    if GetHeroStat(hero, 4) <= GetHeroStat(hero, 1) and GetHeroStat(hero, 4) <= GetHeroStat(hero, 2) and GetHeroStat(hero, 4) <= GetHeroStat(hero, 3) then
      ChangeHeroStat(hero, 4, 5);
    end;
  end;
--  print('8');
  if GetCurrentMoonWeek() == 5 then       --'WEEK_OF_DRAGONFLY' НЕДЕЛЯ ГИГАНТА
    for i = 1, length(array_Tier7_ID) do
      if GetHeroCreatures(hero, array_Tier7_ID[i]) > 0 then
        AddHeroCreatures(hero, array_Tier7_ID[i], 2);
        i = length(array_Tier7_ID);
      end;
    end;
  end;
--  print('9');
  if GetCurrentMoonWeek() == 14 then           --'WEEK_OF_EAGLE' НЕДЕЛЯ ЯСНОГО НЕБА
    for i = 1, length(array_Fly_ID) do
      if GetHeroCreatures(hero, array_Fly_ID[i]) > 0 then
        AddHeroCreatures(hero, array_Fly_ID[i], int(0.2 * GetHeroCreatures(hero, array_Fly_ID[i])));
      end;
    end;
  end;
--  print('10');
  if GetCurrentMoonWeek() == 28 then          --'WEEK_OF_FALCON' НЕДЕЛЯ МЕЧА
    ChangeHeroStat(hero, 1, 2);
    ChangeHeroStat(hero, 2, 2);
  end;
--  print('11');
  if GetCurrentMoonWeek() == 24 then        --'WEEK_OF_FLAMINGO' НЕДЕЛЯ МАГИИ
    ChangeHeroStat(hero, 3, 3);
    ChangeHeroStat(hero, 4, 3);
  end;
--  print('12');
  if GetCurrentMoonWeek() == 6 then             --'WEEK_OF_FOX' НЕДЕЛЯ ЭЛЕМЕНТАЛЕЙ
    AddHeroCreatures(hero, 85 + random(4), int(20 + GetHeroStat(hero, 3) + GetHeroStat(hero, 4)));
  end;
--  print('13');
  if GetCurrentMoonWeek() == 11 then         --'WEEK_OF_HAMSTER' НЕДЕЛЯ ФЕНИКСА
    AddHeroCreatures(hero, 91, int(2 + (GetHeroStat(hero, 3) + GetHeroStat(hero, 4)) / 10));
  end;
--  print('14');
  if GetCurrentMoonWeek() == 29 then        --'WEEK_OF_HEDGEHOG' НЕДЕЛЯ НАДЕЖДЫ
    ChangeHeroStat(hero, 5, 1); --GetHeroStat(hero, 5));
    ChangeHeroStat(hero, 6, 1); --GetHeroStat(hero, 6));
  end;
--  print('15');
  if GetCurrentMoonWeek() == 32 then            --'WEEK_OF_LION' НЕДЕЛЯ ПРИРУЧЕНИЯ
    AddHeroCreatures(hero, 113, int(2 * (GetHeroStat(hero, 3) + GetHeroStat(hero, 4))));
  end;
end;


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

SetObjectEnabled('skill1', nil);
SetObjectEnabled('skill2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'skill1', 'PreBuySkill1' );
Trigger( OBJECT_TOUCH_TRIGGER, 'skill2', 'PreBuySkill2' );

array_SkillForBuy = {};
array_SkillForBuy[0] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       } }
array_SkillForBuy[1] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        } }
array_SkillForBuy[2] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        },
    { ["ID"] = 12,  ["text"] = "BuySummoning.txt"   } }
array_SkillForBuy[3] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       } }
array_SkillForBuy[4] = {
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       },
    { ["ID"] = 12,  ["text"] = "BuySummoning.txt"   } }
array_SkillForBuy[5] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 12,  ["text"] = "BuySummoning.txt"   } }
array_SkillForBuy[6] = {
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       } }
array_SkillForBuy[7] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    } }


scorer1 = 0;
scorer2 = 0;

function PreBuySkill1(hero)
  heroBS1 = hero;
  ArrayStatHero(heroBS1);
  scorerSkill1 = 0;
  if GetHeroStat(hero, STAT_EXPERIENCE) < 2000 then SkillCostCurrent1 = SkillCostStart else SkillCostCurrent1 = SkillCost end;
  for i = 1, 12 do
    if GetHeroSkillMastery (hero, i) > 0 then
      scorerSkill1 = scorerSkill1 + 1;
    end;
  end;
  if GetPlayerResource(PLAYER_1, GOLD) >= SkillCostCurrent1 and scorerSkill1 < 5 then
    BuySkill1();
  else
    if scorerSkill1 < 5 then
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = SkillCostCurrent1});
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MaxSkill.txt");
    end;
  end;
end;

function BuySkill1()
  race = getrace(heroBS1);
  scorer1 = scorer1 + 1;
  if scorer1 <= length(array_SkillForBuy[race - 1]) then
    if GetHeroSkillMastery (heroBS1, array_SkillForBuy[race - 1][scorer1].ID) < 1 then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath()..array_SkillForBuy[race - 1][scorer1].text; eq = SkillCostCurrent1}, 'BuySkillReady1', 'BuySkill1');
    else
      BuySkill1();
    end;
  else
    scorer1 = 0;
  end;
end;

function BuySkillReady1()
  if GenerateLearningEnable1 == 0 then GenerateStatLearning1(heroBS1); end;
  GiveHeroSkill(heroBS1, array_SkillForBuy[getrace(heroBS1) - 1][scorer1].ID);
  Trigger( OBJECT_TOUCH_TRIGGER, 'skill1', 'no' );
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - SkillCostCurrent1));
  ChangeLevel(heroBS1, 1);
  sleep(1);
  if array_SkillForBuy[getrace(heroBS1) - 1][scorer1].ID ~= 3 then UpHeroStat(heroBS1); end;
  PerkSum1 = PerkSum1 + 1;
end;

function PreBuySkill2(hero)
  heroBS2 = hero;
  ArrayStatHero(heroBS2);
  scorerSkill2 = 0;
  if GetHeroStat(hero, STAT_EXPERIENCE) < 2000 then SkillCostCurrent2 = SkillCostStart else SkillCostCurrent2 = SkillCost end;
  for i = 1, 12 do
    if GetHeroSkillMastery (hero, i) > 0 then
      scorerSkill2 = scorerSkill2 + 1;
    end;
  end;
  if GetPlayerResource(PLAYER_2, GOLD) >= SkillCostCurrent2 and scorerSkill2 < 5 then
    BuySkill2();
  else
    if scorerSkill2 < 5 then
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = SkillCostCurrent2});
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MaxSkill.txt");
    end;
  end;
end;

function BuySkill2()
  race = getrace(heroBS2);
  scorer2 = scorer2 + 1;
  if scorer2 <= length(array_SkillForBuy[race - 1]) then
    if GetHeroSkillMastery (heroBS2, array_SkillForBuy[race - 1][scorer2].ID) < 1 then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath()..array_SkillForBuy[race - 1][scorer2].text; eq = SkillCostCurrent2}, 'BuySkillReady2', 'BuySkill2');
    else
      BuySkill2();
    end;
  else
    scorer2 = 0;
  end;
end;

function BuySkillReady2()
  if GenerateLearningEnable2 == 0 then GenerateStatLearning2(heroBS2); end;
  GiveHeroSkill(heroBS2, array_SkillForBuy[getrace(heroBS2) - 1][scorer2].ID);
  Trigger( OBJECT_TOUCH_TRIGGER, 'skill2', 'no' );
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - SkillCostCurrent2));
  ChangeLevel(heroBS2, 1);
  sleep(1);
  if array_SkillForBuy[getrace(heroBS2) - 1][scorer2].ID ~= 3 then UpHeroStat(heroBS2); end;
  PerkSum2 = PerkSum2 + 1;
end;


function transferAllArts (heroMain, hero1, hero2)
  for i = 0, 2 do
    for j = 1, length(array_arts[i]) do
      if HasArtefact (hero1, array_arts[i][j].id) then
        GiveArtefact (heroMain, array_arts[i][j].id);
        RemoveArtefact (hero1, array_arts[i][j].id);
      end;
      if HasArtefact (hero2, array_arts[i][j].id) then
        GiveArtefact (heroMain, array_arts[i][j].id);
        RemoveArtefact (hero2, array_arts[i][j].id);
      end;
    end;
  end;
end;

function transferArmy (town, heroMin, heroMax)
  kol = 0;
  for i = 1, 179 do
    if GetObjectCreatures(town, i) > 0 and i ~= 87 then
      AddHeroCreatures(heroMin, i, GetObjectCreatures(town, i));
      RemoveObjectCreatures(town, i, GetObjectCreatures(town, i));
    end;
  end;
  for i = 1, 179 do
    if GetHeroCreatures (heroMin, i) == 1 then
      kol = kol + 1;
    end;
    if GetHeroCreatures (heroMin, i) > 2 then
      kol = 2;
    end;
    if kol == 2 then
      i = 179;
      MakeHeroInteractWithObject (heroMin, heroMax);
      sleep(1);
      if GetObjectOwner(heroMin) == 1 then
        pause1 = 0;
        MessageBoxForPlayers(GetPlayerFilter( GetObjectOwner(heroMin) ), GetMapDataPath().."transferArmy.txt", 'pause1F' );
        while pause1 == 0 do
          sleep(1);
        end;
--        print('wait2');
      end;
      if GetObjectOwner(heroMin) == 2 then
        pause2 = 0;
        MessageBoxForPlayers(GetPlayerFilter( GetObjectOwner(heroMin) ), GetMapDataPath().."transferArmy.txt", 'pause2F' );
        while pause2 == 0 do
          sleep(1);
        end;
--        print('wait2');
      end;
    end;
  end;
  for i = 1, 179 do
    if GetObjectCreatures(heroMin, i) > 1 and i ~= 87 then
      RemoveHeroCreatures(heroMin, i, (GetObjectCreatures(heroMin, i) - 1));
    end;
  end;
end;

function TownBuilding(town, race)
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_1);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_2);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_3);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_4);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_5);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_6);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_7);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_1, 2);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_2, 2);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_3, 2);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_4, 2);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_5, 2);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_6, 2);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_DWELLING_7, 2);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_1);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_2);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_3);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_4);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_5);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_6);
  UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_7);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_TOWN_HALL, 1);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_FORT, 0);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_MARKETPLACE, 0);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_SHIPYARD, 0);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_TAVERN, 0);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_BLACKSMITH, 0);
  SetTownBuildingLimitLevel(town, TOWN_BUILDING_MAGIC_GUILD, 0);
  if race == 1 then UpgradeTownBuilding(town, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS); SetTownBuildingLimitLevel(town, TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0); UpgradeTownBuilding(town, TOWN_BUILDING_HAVEN_FARMS); end;
--  if race == 2 then UpgradeTownBuilding(town, TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
  if race == 5 then UpgradeTownBuilding(town, TOWN_BUILDING_ACADEMY_ARTIFACT_MERCHANT); end;
  if race == 6 then UpgradeTownBuilding(town, TOWN_BUILDING_DUNGEON_TRADE_GUILD); end;
  if race == 6 then SetTownBuildingLimitLevel(town, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE, 0); end;
  if race == 6 then SetTownBuildingLimitLevel(town, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 0); end;
end;

function DestroyBuilding (town)
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_1, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_2, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_3, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_4, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_5, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_6, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_7, 1, 0);
end;



SetObjectEnabled ('oko1', nil);
SetObjectEnabled ('oko2', nil);

Trigger (OBJECT_TOUCH_TRIGGER, 'oko1', 'RaceSkillQ1');
Trigger (OBJECT_TOUCH_TRIGGER, 'oko2', 'RaceSkillQ2');

function RaceSkillQ1(hero)
  if GetHeroLevel(hero) >= StartLevel then
    Hero1 = hero;
    if hero1race == 1 and ExpertTrainerUse1 == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_1), GetMapDataPath().."RaceSkillQuestionHuman.txt", 'RaceSkillHuman1', 'no');
    end;
--    if hero1race == 3 then
--      ShowFlyingSign(GetMapDataPath().."NecroBonus1.txt", Hero1, 1, 5.0);
--      NecroBonus1();
--    end;
    if hero1race == 4 and AvengerUse1 == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_1), GetMapDataPath().."AvengerQuestion.txt", 'Avenger1()', 'no');
    end;
    if hero1race == 5 then
      if minikUse1 == 0 then
        QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_1), GetMapDataPath().."MiniartsQuestion.txt", 'MiniArts1()', 'no');
      else
        if GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) > minikUse1 and GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) ~= 4 then
          QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_1), GetMapDataPath().."MiniartsPlusQuestion.txt", 'MiniArtsRes1()', 'no');
        end;
      end;
    end;
  end;
end;

function RaceSkillQ2(hero)
  if GetHeroLevel(hero) >= StartLevel then
    Hero2 = hero;
    if hero2race == 1 and ExpertTrainerUse2 == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_2), GetMapDataPath().."RaceSkillQuestionHuman.txt", 'RaceSkillHuman2', 'no');
    end;
--    if hero2race == 3 then
--      ShowFlyingSign(GetMapDataPath().."NecroBonus2.txt", Hero2, 1, 5.0);
--      NecroBonus2();
--    end;
    if hero2race == 4 and AvengerUse2 == 0 then
      QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_2), GetMapDataPath().."AvengerQuestion.txt", 'Avenger2()', 'no');
    end;
    if hero2race == 5 then
      if minikUse2 == 0 then
        QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_2), GetMapDataPath().."MiniartsQuestion.txt", 'MiniArts2()', 'no');
      else
        if GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) > minikUse2 and GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) ~= 4 then
          QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_2), GetMapDataPath().."MiniartsPlusQuestion.txt", 'MiniArtsRes2()', 'no');
        end;
      end;
    end;
  end;
end;

ExpertTrainerUse1 = 0;
ExpertTrainerUse2 = 0;

function RaceSkillHuman1()
  UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_HAVEN_TRAINING_GROUNDS);
  Trigger( OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN1', 'Training1' );
  ExpertTrainerUse1 = 1;
end;

function RaceSkillHuman2()
  UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_HAVEN_TRAINING_GROUNDS);
  Trigger( OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN2', 'Training2' );
  ExpertTrainerUse2 = 1;
end;

function BlockBattleZone(race1, race2)
  if race1 == 1 or race2 == 1 or race1 == 4 or race2 == 4 then SetRegionBlocked ('land_block_race1', true); end;
  if race1 == 2 or race2 == 2 then SetRegionBlocked ('land_block_race2', true); end;
  if race1 == 3 or race2 == 3 then SetRegionBlocked ('land_block_race3', true); end;
  if race1 == 5 or race2 == 5 then SetRegionBlocked ('land_block_race5', true); end;
  if race1 == 6 or race2 == 6 then SetRegionBlocked ('land_block_race6', true); end;
  if race1 == 7 or race7 == 2 then SetRegionBlocked ('land_block_race7', true); end;
  if race1 == 8 or race2 == 8 then SetRegionBlocked ('land_block_race8', true); end;
  --SetRegionBlocked ('land_block1', true);
  --SetRegionBlocked ('land_block2', true);
  --SetRegionBlocked ('land_block3', true);
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
    DisableBagPlayer1 = 0;
    DisableBagPlayer2 = 0;

    -- TODO
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
       --SetRegionBlocked ('land_block1', false);
       --SetRegionBlocked ('land_block2', false);
       --SetRegionBlocked ('land_block3', false);
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
     

     -- Орнелла
--     if HeroMax1 == "OrnellaNecro" or HeroMax1 == "OrnellaNecro2" then SpecOrnella(HeroMax1); end;
--     if HeroMax2 == "OrnellaNecro" or HeroMax2 == "OrnellaNecro2" then SpecOrnella(HeroMax2); end;

     -- дипломатия
--     if (HasHeroSkill(HeroMax1, 30)) and GetHeroSkillMastery(HeroMax1, SKILL_NECROMANCY) == 0 and DiplomacyEnable1 == 0 then diplomacy1(HeroMax1); end;
--     if (HasHeroSkill(HeroMax2, 30)) and GetHeroSkillMastery(HeroMax2, SKILL_NECROMANCY) == 0 and DiplomacyEnable2 == 0 then diplomacy2(HeroMax2); end;

--     sleep(1);
     -- некромантия
--     if hero1race == 3 then NecroBonus1(HeroMax1); end;
--     if hero2race == 3 then NecroBonus2(HeroMax2); end;

     -- мститель
--     if hero1race == 4 then Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN1', 'Avenger1'); MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Avenger.txt" ); startThread (AutoTeleportBattleZone1); ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax2, 2, 5.0); end;
--     if hero2race == 4 then Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN2', 'Avenger2'); MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Avenger.txt" ); startThread (AutoTeleportBattleZone2); ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax1, 1, 5.0); end;

     -- мастер артефактов
--     if hero1race == 5 then Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN1', 'MiniArts1'); startThread (AutoTeleportBattleZone1); ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax2, 2, 5.0); end;
--     if hero2race == 5 then Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN2', 'MiniArts2'); startThread (AutoTeleportBattleZone2); ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax1, 1, 5.0); end;

  end;

  if GetDate (DAY) == 5 then

     -- покровительство асхи (неделя наставника)
--     if (HasHeroSkill(HeroMax1, 80)) and GetCurrentMoonWeek() == 23 then GraalVision(HeroMax1, hero1race); end;
--     if (HasHeroSkill(HeroMax2, 80)) and GetCurrentMoonWeek() == 23 then GraalVision(HeroMax2, hero2race); end;

     -- холодная сталь
     --if (HasHeroSkill(HeroMax1, 104) or HasHeroSkill(HeroMax1, 82)) and (hero1race ~= 4 and hero1race ~= 5) and Name(HeroMax1) ~= "RedHeavenHero03" and Name(HeroMax1) ~= "RedHeavenHero033" and Name(HeroMax1) ~= "Brem" and Name(HeroMax1) ~= "Brem3" then DublikatHero1( HeroMax1); end;
     --if (HasHeroSkill(HeroMax2, 104) or HasHeroSkill(HeroMax2, 82)) and (hero2race ~= 4 and hero2race ~= 5) and Name(HeroMax2) ~= "RedHeavenHero03" and Name(HeroMax2) ~= "RedHeavenHero033" and Name(HeroMax2) ~= "Brem" and Name(HeroMax2) ~= "Brem3" then DublikatHero2( HeroMax2); end;

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

     -- кольчуга просвещенности
--     if HasArtefact(HeroMax1, 35, 1) then ChangeLevel(HeroMax1, 8); end;
--     if HasArtefact(HeroMax2, 35, 1) then ChangeLevel(HeroMax2, 8); end;

     -- одеяние просвещения
--     if HasArtefact(HeroMax1, 34, 1) and HasArtefact(HeroMax1, 35, 1) then ChangeLevel(HeroMax2, -3); end;
--     if HasArtefact(HeroMax2, 34, 1) and HasArtefact(HeroMax2, 35, 1) then ChangeLevel(HeroMax1, -3); end;
     
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


     -- Золтан
--     if (HeroMax1 == "Aberrar" or HeroMax1 == "Aberrar2") and GetHeroSkillMastery(HeroMax1, SKILL_DARK_MAGIC) == 3 then SubHero(HeroMax1, "Aberrar3"); HeroMax1 = "Aberrar3"; end;
--     if (HeroMax2 == "Aberrar" or HeroMax2 == "Aberrar2") and GetHeroSkillMastery(HeroMax2, SKILL_DARK_MAGIC) == 3 then SubHero(HeroMax2, "Aberrar4"); HeroMax2 = "Aberrar4"; end;

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
     
     -- защити нас всех
     if (HasHeroSkill(HeroMax1, 181)) and (GetHeroCreatures(HeroMax1, 117) > 0) then AddHeroCreatures(HeroMax1, 117, 30); else
     if (HasHeroSkill(HeroMax1, 181)) and (GetHeroCreatures(HeroMax1, 173) > 0) then AddHeroCreatures(HeroMax1, 173, 30); end; end;
     if (HasHeroSkill(HeroMax2, 181)) and (GetHeroCreatures(HeroMax2, 117) > 0) then AddHeroCreatures(HeroMax2, 117, 30); else
     if (HasHeroSkill(HeroMax2, 181)) and (GetHeroCreatures(HeroMax2, 173) > 0) then AddHeroCreatures(HeroMax2, 173, 30); end; end;
     
     -- лесной лидер
     if (HasHeroSkill(HeroMax1, 115)) and (GetHeroCreatures(HeroMax1,  45) > 0) then AddHeroCreatures(HeroMax1,  45, 10); else
     if (HasHeroSkill(HeroMax1, 115)) and (GetHeroCreatures(HeroMax1, 146) > 0) then AddHeroCreatures(HeroMax1, 146, 10); end; end;
     if (HasHeroSkill(HeroMax2, 115)) and (GetHeroCreatures(HeroMax2,  45) > 0) then AddHeroCreatures(HeroMax2,  45, 10); else
     if (HasHeroSkill(HeroMax2, 115)) and (GetHeroCreatures(HeroMax2, 146) > 0) then AddHeroCreatures(HeroMax2, 146, 10); end; end;

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


     -- мастер артефактов
--     if hero1race == 5 then UpgradeMiniArts1(); end;
--     if hero2race == 5 then UpgradeMiniArts2(); end;

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

     -- Валерия
     if (HeroMax1 == "RedHeavenHero03" or HeroMax1 == "RedHeavenHero032") then SpecValeria(HeroMax1); end;
     if (HeroMax2 == "RedHeavenHero03" or HeroMax2 == "RedHeavenHero032") then SpecValeria(HeroMax2); end;

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

     -- Каспар
--     if Name(HeroMax1) == "Gles" then SpecGles(HeroMax1, HeroMax2); end;
--     if Name(HeroMax2) == "Gles" then SpecGles(HeroMax2, HeroMax1); end;

     -- Илайя
     --if Name(HeroMax1) == "Shadwyn" then SetObjectOwner('Dwel1', PLAYER_1); TransformTown('Dwel1', 3); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_MAGIC_GUILD); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); TeachHeroSpell(HeroMax1, 1); TeachHeroSpell(HeroMax1, 3); TeachHeroSpell(HeroMax1, 4); TeachHeroSpell(HeroMax1, 237); end;
     --if Name(HeroMax2) == "Shadwyn" then SetObjectOwner('Dwel2', PLAYER_2); TransformTown('Dwel2', 3); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_MAGIC_GUILD); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); TeachHeroSpell(HeroMax2, 1); TeachHeroSpell(HeroMax2, 3); TeachHeroSpell(HeroMax2, 4); TeachHeroSpell(HeroMax2, 237); end;

     -- Свея
     if Name(HeroMax1) == "Vegeyr" then SpecVegeyr(HeroMax1); end;
     if Name(HeroMax2) == "Vegeyr" then SpecVegeyr(HeroMax2); end;
     
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

  if IsHeroInTown(HeroMax1, 'RANDOMTOWN1', 0, 1) then SetObjectPosition( HeroMax1, 44, 81); end;
  if IsHeroInTown(HeroMin1, 'RANDOMTOWN1', 0, 1) then SetObjectPosition( HeroMin1, 44, 81); end;
  sleep(2);
  
  DestroyBuilding ('RANDOMTOWN1');

  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_1, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);

  -- темный ритуал
  if DT_use1 == 0 and HasHeroSkill(HeroMax1, 71) then DT_use1 = 1; nap1Plus3Q(HeroMax1); end;

  if hero1race ~= 4 and hero1race ~= 5 then SetObjectPosition (HeroMax1, TELEPORT_BATTLE_ZONE_PLAYER_1_X, TELEPORT_BATTLE_ZONE_PLAYER_1_Y); stop(HeroMax1); end;
  if hero1race ~= 4 and hero1race ~= 5 then OpenCircleFog( 49, 45, 0, 15, 1 ); end;

  SetPlayerResource (PLAYER_1, GOLD, 0);
  SetObjectEnabled('market1', nil);

--  print(PerkSum1);
--  print(PerkSumF(HeroMax1));

--  if (PerkSum1) ~= (PerkSumF(HeroMax1)) and HasHeroSkill(HeroMax1, 104) then
--    pause1 = 0;
--    while (PerkSum1) ~= (PerkSumF(HeroMax1)) do
--      sleep(3);
--    end;
--    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."PerkSum.txt", 'pause1F');
--    while pause1 == 0 do
--      sleep(1);
--    end;
--    print('wait1');
--  end;

  if SpoilsUse1 == 0 and HasHeroSkill(HeroMax1, 129) then Spoils1(); end;
  
  sleep(5);
  stop(HeroMin1);
  stop(HeroDop1);
  
  --TRANSFER ALL TO MAIN
   transferAllArts (HeroMax1, HeroMin1, HeroDop1);
   transferArmy ('RANDOMTOWN1', HeroMin1, HeroMax1);
   transferArmy ('RANDOMTOWN1', HeroDop1, HeroMax1);
  
  -- возврат единички
  if RemStUn1 == 2 then
    if GetHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade1) > 0 then AddHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade1, 1); else
    if GetHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade2) > 0 then AddHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade2, 1); end; end;
  end;

-- холодная сталь и огненная ярость
--  if (HasHeroSkill(HeroMax1, 30) == nil and GetHeroSkillMastery(HeroMax1, SKILL_NECROMANCY) == 0 and (HasHeroSkill(HeroMax1, 104) or HasHeroSkill(HeroMax1, 82)) and (hero1race ~= 4 and hero1race ~= 5)) then
--    DublikatHero1( HeroMax1);
--  end;
--  print('sss1')
  -- мститель
  if hero1race == 4 then Avenger1(); startThread (AutoTeleportBattleZone1); end;
  -- мастер артефактов
  if hero1race == 5 then MiniArts1(); startThread (AutoTeleportBattleZone1); end;
  -- дипломатия
  if (HasHeroSkill(HeroMax1, 30)) then diplomacy1(HeroMax1); end;
  -- некромантия
  if hero1race == 3 and (HasHeroSkill(HeroMax1, 30)) == nil then NecroBonus1(HeroMax1); end;
  
  -- инфо
  if hero2race == 4 and hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax1, 1, 5.0); end;
  if hero2race == 5 and hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax1, 1, 5.0); end;


--  if hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."Wait.txt", HeroMax1, 1, 5.0); end;
end;

function DayFour2()

  if IsHeroInTown(HeroMax2, 'RANDOMTOWN2', 0, 1) then SetObjectPosition( HeroMax2, 44, 12); end;
  if IsHeroInTown(HeroMin2, 'RANDOMTOWN2', 0, 1) then SetObjectPosition( HeroMin2, 44, 12); end;
  sleep(2);
  
  DestroyBuilding ('RANDOMTOWN2');

  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_1, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  
  -- темный ритуал
  if DT_use2 == 0 and HasHeroSkill(HeroMax2, 71) then DT_use2 = 1; nap2Plus3Q(HeroMax2); end;

  if hero2race ~= 4 and hero2race ~= 5 then SetObjectPosition (HeroMax2, TELEPORT_BATTLE_ZONE_PLAYER_2_X, TELEPORT_BATTLE_ZONE_PLAYER_2_Y); end;
  if hero2race ~= 4 and hero2race ~= 5 then OpenCircleFog( 49, 45, 0, 15, 2 ); end;
  
  SetPlayerResource (PLAYER_2, GOLD, 0);
  SetObjectEnabled('market2', nil);
  
--  if (PerkSum2) ~= (PerkSumF(HeroMax2)) and HasHeroSkill(HeroMax2, 104) then
--    pause2 = 0;
--    while (PerkSum2) ~= (PerkSumF(HeroMax2)) do
--      sleep(3);
--    end;
--    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."PerkSum.txt", 'pause2F');
--    while pause2 == 0 do
--      sleep(1);
--    end;
--    print('wait1');
--  end;
  
  if SpoilsUse2 == 0 and HasHeroSkill(HeroMax2, 129) then Spoils2(); end;
  
  sleep(5);
  stop(HeroMin2);
  stop(HeroDop2);

  --TRANSFER ALL TO MAIN
  transferAllArts (HeroMax2, HeroMin2, HeroDop2);
  transferArmy ('RANDOMTOWN2', HeroMin2, HeroMax2);
  transferArmy ('RANDOMTOWN2', HeroDop2, HeroMax2);
  
  -- возврат единички
  if RemStUn2 == 2 then
    if GetHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade1) > 0 then AddHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade1, 1); else
    if GetHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade2) > 0 then AddHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade2, 1); end; end;
  end;

-- холодная сталь и огненная ярость
--  if (HasHeroSkill(HeroMax2, 30) == nil and GetHeroSkillMastery(HeroMax2, SKILL_NECROMANCY) == 0 and (HasHeroSkill(HeroMax2, 104) or HasHeroSkill(HeroMax2, 82)) and (hero2race ~= 4 and hero2race ~= 5)) then
--    DublikatHero2( HeroMax2);
--  end;
  
--  print('sss2')
  -- мститель
  if hero2race == 4 then Avenger2(); startThread (AutoTeleportBattleZone2); end;
  -- мастер артефактов
  if hero2race == 5 then MiniArts2(); startThread (AutoTeleportBattleZone2); end;
  -- дипломатия
  if (HasHeroSkill(HeroMax2, 30)) then diplomacy2(HeroMax2); end;
  -- некромантия
  if hero2race == 3 and (HasHeroSkill(HeroMax2, 30)) == nil then NecroBonus2(HeroMax2); end;
  
  -- инфо
  if hero1race == 4 and hero2race ~= 3 and hero2race ~= 4 and hero2race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax2, 2, 5.0); end;
  if hero1race == 5 and hero2race ~= 3 and hero2race ~= 4 and hero2race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax2, 2, 5.0); end;

--  if hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."Wait.txt", HeroMax1, 1, 5.0); end;
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

array_Gles = {};
array_Gles = {0, 0, 0, 0, 0, 0, 0};

array_GlesOpp = {};
array_GlesOpp = {0, 0, 0, 0, 0, 0, 0};

function SpecGles (hero1, hero2)
  CreaturesGles = 0;
  CreaturesGlesOpp = 0;
  array_Gles[0], array_Gles[1], array_Gles[2], array_Gles[3], array_Gles[4], array_Gles[5], array_Gles[6] = GetHeroCreaturesTypes(hero1);
  array_GlesOpp[0], array_GlesOpp[1], array_GlesOpp[2], array_GlesOpp[3], array_GlesOpp[4], array_GlesOpp[5], array_GlesOpp[6] = GetHeroCreaturesTypes(hero2);
  for i = 0, 6 do
    if array_Gles[i] > 0 and array_Gles[i] < 180 then
      CreaturesGles = CreaturesGles + 1;
    end;
    if array_GlesOpp[i] > 0 and array_GlesOpp[i] < 180 then
      CreaturesGlesOpp = CreaturesGlesOpp + 1;
    end;
  end;
  GiveHeroBattleBonus(hero1, HERO_BATTLE_BONUS_DEFENCE, ((CreaturesGlesOpp - CreaturesGles) * 2 + int((GetHeroLevel(hero1) - GetHeroLevel(hero2)) / 2)));
end;

function SpecVegeyr (hero)
  if KnowHeroSpell (hero, SPELL_LIGHTNING_BOLT) then
    TeachHeroSpell (hero, SPELL_EMPOWERED_LIGHTNING_BOLT);
  end;
  if KnowHeroSpell (hero, SPELL_CHAIN_LIGHTNING) then
    TeachHeroSpell (hero, SPELL_EMPOWERED_CHAIN_LIGHTNING);
  end;
end;

function SpecOrnella(hero)
  MessageBoxForPlayers(GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."OrnellaInfo.txt" );
  if HasHeroSkill(hero, 62) then
    if GetHeroCreatures(hero,  29) > GetHeroCreatures(hero, 152) then
      kolCreatures = GetHeroCreatures(hero,  29) + GetHeroCreatures(hero, 152);
      AddHeroCreatures(hero, 152, GetHeroCreatures(hero,  29));
      RemoveHeroCreatures(hero,  29, GetHeroCreatures(hero,  29));
      AddHeroCreatures(hero,  95, kolCreatures);
    else
      kolCreatures = GetHeroCreatures(hero,  29) + GetHeroCreatures(hero, 152);
      if GetHeroCreatures(hero, 152) > 0 then
        AddHeroCreatures(hero, 29, GetHeroCreatures(hero, 152));
        RemoveHeroCreatures(hero, 152, GetHeroCreatures(hero, 152));
        AddHeroCreatures(hero, 97, kolCreatures);
      end;
    end;
  else
    if GetHeroCreatures(hero,  29) > 0 then
      AddHeroCreatures(hero, 152, GetHeroCreatures(hero,  29));
    end;
    if (GetHeroCreatures(hero, 152) - GetHeroCreatures(hero, 29)) > 0 then
      AddHeroCreatures(hero,  29, GetHeroCreatures(hero, 152) - GetHeroCreatures(hero, 29));
    end;
  end;
end;

function SpecEllaina1()
  Tier1UnitInTown1 = GetObjectDwellingCreatures('RANDOMTOWN1', 1);
  while GetObjectDwellingCreatures('RANDOMTOWN1', 1) > 0 or Ellaina1 == 1 do
    if Tier1UnitInTown1 > GetObjectDwellingCreatures('RANDOMTOWN1', 1) then
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + EllainaDiscount * (Tier1UnitInTown1 - GetObjectDwellingCreatures('RANDOMTOWN1', 1))));
      ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(EllainaDiscount * (Tier1UnitInTown1 - GetObjectDwellingCreatures('RANDOMTOWN1', 1)))}, HeroMax1, 1, random(6) + 3);
      Tier1UnitInTown1 = GetObjectDwellingCreatures('RANDOMTOWN1', 1);
      if GetObjectDwellingCreatures('RANDOMTOWN1', 1) == 0 then Ellaina1 = 2; end;
    end;
    sleep(10);
  end;
end;

function SpecEllaina2()
  Tier1UnitInTown2 = GetObjectDwellingCreatures('RANDOMTOWN2', 1);
  while GetObjectDwellingCreatures('RANDOMTOWN2', 1) > 0 or Ellaina2 == 1 do
    if Tier1UnitInTown2 > GetObjectDwellingCreatures('RANDOMTOWN2', 1) then
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + EllainaDiscount * (Tier1UnitInTown2 - GetObjectDwellingCreatures('RANDOMTOWN2', 1))));
      ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(EllainaDiscount * (Tier1UnitInTown2 - GetObjectDwellingCreatures('RANDOMTOWN2', 1)))}, HeroMax2, 2, random(6) + 3);
      Tier1UnitInTown2 = GetObjectDwellingCreatures('RANDOMTOWN2', 1);
      if GetObjectDwellingCreatures('RANDOMTOWN2', 1) == 0 then Ellaina2 = 2; end;
    end;
    sleep(10);
  end;
end;

function SpecValeria(hero)
  if KnowHeroSpell( hero, 11) then TeachHeroSpell( hero, 210); end;
  if KnowHeroSpell( hero, 12) then TeachHeroSpell( hero, 212); end;
  if KnowHeroSpell( hero, 13) then TeachHeroSpell( hero, 211); end;
  if KnowHeroSpell( hero, 14) then TeachHeroSpell( hero, 214); end;
  if KnowHeroSpell( hero, 15) then TeachHeroSpell( hero, 215); end;
  if KnowHeroSpell( hero, 17) then TeachHeroSpell( hero, 213); end;
end;

array_FreeRunes = {}
array_FreeRunes = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

function SpecInga1()
  if GetHeroLevel(HeroMax1) == IngaLevel then
    kolRunes = 0;
  end;
  if frac(GetHeroLevel(HeroMax1) / IngaLevel) == 0 and (GetDate (DAY) == 3 or GetDate (DAY) == 4) then
    for i = 1, 10 do
      if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
      for j = 15, 19 do
        if i == spells[0][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
      end;
--      print(array_FreeRunes[i]);
    end;
    RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
    while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
      RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
    end;
    TeachHeroSpell(HeroMax1, array_spells[4][RuneForInga].id);
    array_FreeRunes[RuneForInga] = 2;
    kolRunes = kolRunes + 1;
  end;
  if GetDate (DAY) == 5 then
    if GetHeroLevel(HeroMax1) < 4 * IngaLevel then
      k = 3 - kolRunes;
    else
      if GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE) > 1 then
        k = 4 - kolRunes;
      else
        k = 3 - kolRunes;
      end;
    end;
    if k > 0 then
      for i = 1, 10 do
        if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
        for j = 15, 19 do
          if i == spells[0][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
        end;
--        print(array_FreeRunes[i]);
      end;
      for i = 1, k do
        RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
        while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
          RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
        end;
        TeachHeroSpell(HeroMax1, array_spells[4][RuneForInga].id);
        array_FreeRunes[RuneForInga] = 2;
      end;
    end;
  end;
end;

function SpecInga2()
  if GetHeroLevel(HeroMax2) == IngaLevel then
    kolRunes = 0;
  end;
  if frac(GetHeroLevel(HeroMax2) / IngaLevel) == 0 and (GetDate (DAY) == 3 or GetDate (DAY) == 4) then
    for i = 1, 10 do
      if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
      for j = 15, 19 do
        if i == spells[1][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
      end;
--      print(array_FreeRunes[i]);
    end;
    RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
    while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
      RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
    end;
    TeachHeroSpell(HeroMax2, array_spells[4][RuneForInga].id);
    array_FreeRunes[RuneForInga] = 2;
    kolRunes = kolRunes + 1;
  end;
  if GetDate (DAY) == 5 then
    if GetHeroLevel(HeroMax2) < 4 * IngaLevel then
      k = 3 - kolRunes;
    else
      if GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE) > 1 then
        k = 4 - kolRunes;
      else
        k = 3 - kolRunes;
      end;
    end;
    if k > 0 then
      for i = 1, 10 do
        if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
        for j = 15, 19 do
          if i == spells[1][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
        end;
--        print(array_FreeRunes[i]);
      end;
      for i = 1, k do
        RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
        while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
          RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
        end;
        TeachHeroSpell(HeroMax2, array_spells[4][RuneForInga].id);
        array_FreeRunes[RuneForInga] = 2;
      end;
    end;
  end;
end;

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

AvengerUse1 = 0;
AvengerUse2 = 0;

function Avenger1Question(hero)
  QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."AvengerQuestion.txt", 'Avenger1()', 'no');
end;

function Avenger2Question(hero)
  QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."AvengerQuestion.txt", 'Avenger2()', 'no');
end;

function AvengerGenerating1()
  race = hero2race;
  Enemy11 = random (7) + 1;
  Enemy12 = random (7) + 1;
  while Enemy12 == Enemy11 do
    Enemy12 = random (7) + 1;
  end;
  Enemy13 = random (7) + 1;
  while Enemy13 == Enemy11 or Enemy13 == Enemy12 do
    Enemy13 = random (7) + 1;
  end;
  Enemy14 = random (7) + 1;
  while Enemy14 == Enemy11 or Enemy14 == Enemy12 or Enemy14 == Enemy13 do
    Enemy14 = random (7) + 1;
  end;
  Enemy15 = random (7) + 1;
  while Enemy15 == Enemy11 or Enemy15 == Enemy12 or Enemy15 == Enemy13 or Enemy15 == Enemy14 do
    Enemy15 = random (7) + 1;
  end;
  Enemy16 = random (7) + 1;
  while Enemy16 == Enemy11 or Enemy16 == Enemy12 or Enemy16 == Enemy13 or Enemy16 == Enemy14 or Enemy16 == Enemy15 do
    Enemy16 = random (7) + 1;
  end;
  Enemy17 = 28 - Enemy11 - Enemy12 - Enemy13 - Enemy14 - Enemy15 - Enemy16;

-- ЗАКЛЯТЫЕ - ТИР 1-6
  Enemy11 = 1;
  Enemy12 = 2;
  Enemy13 = 3;
  Enemy14 = 4;
  Enemy15 = 5;
  Enemy16 = 6;
  Enemy17 = 7;


--  CreateMonster('Aaa', array_elf_enemy[race][Enemy11].id, array_elf_enemy[race][Enemy11].kol, 37, 78, 0, 1, 2,  0, 0); - ЗАКЛЯТЫЕ СЛУЧАЙНЫ
  CreateMonster('Aaa', array_elf_enemy[race][Enemy11].id, array_elf_enemy[race][Enemy11].kol, 10, 40, 0, 1, 2,  0, 0);
  AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy12].id, array_elf_enemy[race][Enemy12].kol);
  AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy13].id, array_elf_enemy[race][Enemy13].kol);
  AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy14].id, array_elf_enemy[race][Enemy14].kol);
  AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy15].id, array_elf_enemy[race][Enemy15].kol);
  AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy16].id, array_elf_enemy[race][Enemy16].kol);
  AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy17].id, array_elf_enemy[race][Enemy17].kol);

  SetObjectEnabled('Aaa', nil);
  Trigger( OBJECT_TOUCH_TRIGGER, 'Aaa', 'Avenger1Question' );
--  OpenCircleFog( 37, 78, 0, 3, 1);

end;

function AvengerGenerating2()
  race = hero1race;
  Enemy21 = random (7) + 1;
  Enemy22 = random (7) + 1;
  while Enemy22 == Enemy21 do
    Enemy22 = random (7) + 1;
  end;
  Enemy23 = random (7) + 1;
  while Enemy23 == Enemy21 or Enemy23 == Enemy22 do
    Enemy23 = random (7) + 1;
  end;
  Enemy24 = random (7) + 1;
  while Enemy24 == Enemy21 or Enemy24 == Enemy22 or Enemy24 == Enemy23 do
    Enemy24 = random (7) + 1;
  end;
  Enemy25 = random (7) + 1;
  while Enemy25 == Enemy21 or Enemy25 == Enemy22 or Enemy25 == Enemy23 or Enemy25 == Enemy24 do
    Enemy25 = random (7) + 1;
  end;
  Enemy26 = random (7) + 1;
  while Enemy26 == Enemy21 or Enemy26 == Enemy22 or Enemy26 == Enemy23 or Enemy26 == Enemy24 or Enemy26 == Enemy25 do
    Enemy26 = random (7) + 1;
  end;
  Enemy27 = 28 - Enemy21 - Enemy22 - Enemy23 - Enemy24 - Enemy25 - Enemy26;
  
-- ЗАКЛЯТЫЕ - ТИР 1-6
  Enemy21 = 1;
  Enemy22 = 2;
  Enemy23 = 3;
  Enemy24 = 4;
  Enemy25 = 5;
  Enemy26 = 6;
  Enemy27 = 7;

--  CreateMonster('Bbb', array_elf_enemy[race][Enemy21].id, array_elf_enemy[race][Enemy21].kol, 28, 13, 0, 1, 2, 90, 0); - ЗАКЛЯТЫЕ СЛУЧАЙНЫ
  CreateMonster('Bbb', array_elf_enemy[race][Enemy21].id, array_elf_enemy[race][Enemy21].kol, 12, 40, 0, 1, 2, 90, 0);
  AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy22].id, array_elf_enemy[race][Enemy22].kol);
  AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy23].id, array_elf_enemy[race][Enemy23].kol);
  AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy24].id, array_elf_enemy[race][Enemy24].kol);
  AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy25].id, array_elf_enemy[race][Enemy25].kol);
  AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy26].id, array_elf_enemy[race][Enemy26].kol);
  AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy27].id, array_elf_enemy[race][Enemy27].kol);

  SetObjectEnabled('Bbb', nil);
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bbb', 'Avenger2Question' );
--  OpenCircleFog( 28, 13, 0, 3, 2);

end;


function Avenger1()
  pause1 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Avenger.txt", 'pause1F');
  while pause1 == 0 do
    sleep(1);
  end;
  
  -- Аларон
  if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) == 3 then SubHero(HeroMax1, "Ildar3"); HeroMax1 = "Ildar3"; sleep(3); end;
  if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_LIGHT_MAGIC); end;

  -- холодная сталь
--  if (HasHeroSkill(HeroMax1, 104) or HasHeroSkill(HeroMax1, 82)) and Name(HeroMax1) ~= "Ildar" and Name(HeroMax1) ~= "Ildar3" then
--    DublikatHero1( HeroMax1);
--    sleep(3);
--  end;

  hero = HeroMax1;
  race = hero2race;

  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 1 then
    CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
  end;

  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 2 then
    CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol);
  end;

  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 3 then
    CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy16].id, array_elf_enemy[hero2race][Enemy16].kol);
--    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  end;

  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 4 then
    CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy16].id, array_elf_enemy[hero2race][Enemy16].kol);
    AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy17].id, array_elf_enemy[hero2race][Enemy17].kol);
--    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
--    SetObjectOwner('RANDOMTOWN1', 1);
--    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
--    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  end;

--  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 1 then GiveHeroSkill(HeroMax1, SKILL_AVENGER); GiveHeroSkill(HeroMax1, SKILL_AVENGER); end;
--  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 2 then GiveHeroSkill(HeroMax1, SKILL_AVENGER); end;

--  if (HasHeroSkill(HeroMax1, 27) and (Name(HeroMax1) == "GhostFSLord") and GetHeroSkillMastery(HeroMax1, SKILL_SUMMONING_MAGIC) > 1) then TeachHeroSpell(HeroMax1, 43); TeachHeroSpell(HeroMax1, 283); TeachHeroSpell(HeroMax1, 34); end;
--  if HasHeroSkill(HeroMax1, 27) then TeachHeroSpell(HeroMax1, 25); TeachHeroSpell(HeroMax1, 237); TeachHeroSpell(HeroMax1, 3); TeachHeroSpell(HeroMax1, 39); end;
--  GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_INITIATIVE, 30);
  AvengerUse1 = 1;
--  UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);

  Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetHeroCreaturesTypes(HeroMax1);
  for i = 1, 7 do
    if Stek1[i].id > 0 then
       Stek1[i].kol = GetHeroCreatures( HeroMax1, Stek1[i].id);
       RemoveHeroCreatures( HeroMax1, Stek1[i].id, Stek1[i].kol);
       sleep(1);
       if i == 1 then AddHeroCreatures( HeroMax1, 91, 10); end;
    end;
  end;
       
--  sleep(10);

  StartCombat (HeroMax1, nil, 7, array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol,
                             array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol,
                             array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol,
                             array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol,
                             array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol,
                             array_elf_enemy[hero2race][Enemy16].id, array_elf_enemy[hero2race][Enemy16].kol,
                             array_elf_enemy[hero2race][Enemy17].id, array_elf_enemy[hero2race][Enemy17].kol,
                             nil, 'ReturnElfArmy1', nil, true);

--  MakeHeroInteractWithObject (HeroMax1, 'Enemy1');
  sleep(20);
--  RemoveObject('Aaa');

--  MakeHeroInteractWithObject (HeroMax1, 'RANDOMTOWN1');
--  stop(HeroMax1);

  SetObjectPosition('port1', 39, 80, 0);
  Trigger( OBJECT_TOUCH_TRIGGER, 'port1', 'TeleportBattleZone1' );
  SetObjectEnabled('port1', nil);
  SetDisabledObjectMode('port1', 2);
  Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN1', 'no');

end;

function Avenger2()
  pause2 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Avenger.txt", 'pause2F');
  while pause2 == 0 do
    sleep(1);
  end;
  
  -- Аларон
  if (HeroMax2 == "Ildar" or HeroMax2 == "Ildar2") and GetHeroSkillMastery(HeroMax2, SKILL_LIGHT_MAGIC) == 3 then SubHero(HeroMax2, "Ildar4"); HeroMax2 = "Ildar4"; end;
  if (HeroMax2 == "Ildar" or HeroMax2 == "Ildar2") and GetHeroSkillMastery(HeroMax2, SKILL_LIGHT_MAGIC) < 3 and GetHeroSkillMastery(HeroMax2, SKILL_LIGHT_MAGIC) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no'); GiveHeroSkill(HeroMax2, SKILL_LIGHT_MAGIC); end;

  -- холодная сталь
--  if (HasHeroSkill(HeroMax2, 104) or HasHeroSkill(HeroMax2, 82)) and Name(HeroMax2) ~= "Ildar" and Name(HeroMax2) ~= "Ildar3" then
--    DublikatHero2( HeroMax2);
--  end;

--  hero = HeroMax2;
  race = hero1race;

  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 1 then
    CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
  end;

  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 2 then
    CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol);
  end;

  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 3 then
    CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy26].id, array_elf_enemy[hero1race][Enemy26].kol);
--    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  end;

  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 4 then
    CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy26].id, array_elf_enemy[hero1race][Enemy26].kol);
    AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy27].id, array_elf_enemy[hero1race][Enemy27].kol);
--    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
--    SetObjectOwner('RANDOMTOWN2', 2);
--    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
--    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  end;

--  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 1 then GiveHeroSkill(HeroMax2, SKILL_AVENGER); GiveHeroSkill(HeroMax2, SKILL_AVENGER); end;
--  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 2 then GiveHeroSkill(HeroMax2, SKILL_AVENGER); end;

--  if (HasHeroSkill(HeroMax2, 27) and (Name(HeroMax2) == "GhostFSLord") and GetHeroSkillMastery(HeroMax2, SKILL_SUMMONING_MAGIC) > 1) then TeachHeroSpell(HeroMax2, 43); TeachHeroSpell(HeroMax2, 283); TeachHeroSpell(HeroMax2, 34); end;
--  if HasHeroSkill(HeroMax2, 27) then TeachHeroSpell(HeroMax2, 25); TeachHeroSpell(HeroMax2, 237); TeachHeroSpell(HeroMax2, 3); TeachHeroSpell(HeroMax2, 39); end;
--  GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_INITIATIVE, 30);
  AvengerUse2 = 1;
--  UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);

  Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetHeroCreaturesTypes(HeroMax2);
  for i = 1, 7 do
    if Stek2[i].id > 0 then
       Stek2[i].kol = GetHeroCreatures( HeroMax2, Stek2[i].id);
       RemoveHeroCreatures( HeroMax2, Stek2[i].id, Stek2[i].kol);
       sleep(1);
       if i == 1 then AddHeroCreatures( HeroMax2, 91, 10); end;
    end;
  end;

--  sleep(10);

  StartCombat (HeroMax2, nil, 7, array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol,
                             array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol,
                             array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol,
                             array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol,
                             array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol,
                             array_elf_enemy[hero1race][Enemy26].id, array_elf_enemy[hero1race][Enemy26].kol,
                             array_elf_enemy[hero1race][Enemy27].id, array_elf_enemy[hero1race][Enemy27].kol,
                             nil, 'ReturnElfArmy2', nil, true);
                             
  --MakeHeroInteractWithObject (HeroMax2, 'Enemy2');
  sleep(20);

  SetObjectPosition('port2', 47, 11, 0);
  Trigger( OBJECT_TOUCH_TRIGGER, 'port2', 'TeleportBattleZone2' );
  SetObjectEnabled('port2', nil);
  SetDisabledObjectMode('port2', 2);
  Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN2', 'no');
  
--  RemoveObject('Bbb');

--MakeHeroInteractWithObject (hero, 'RANDOMTOWN2');
--stop(HeroMax2);

end;

function ReturnElfArmy1(hero, res)
  for i = 1, 7 do
    if Stek1[i].id > 0 then
       AddHeroCreatures( hero, Stek1[i].id, Stek1[i].kol);
       sleep(1);
       if GetHeroCreatures(hero, 91) > 0 then kolCreatures = GetHeroCreatures(hero, 91); RemoveHeroCreatures(hero, 91, kolCreatures); end;
    end;
  end;
  if GetObjectCreatures('RANDOMTOWN1', 91) > 0 then kolCreatures = GetObjectCreatures('RANDOMTOWN1', 91); RemoveObjectCreatures('RANDOMTOWN1', 91, kolCreatures); end;
--  if HasHeroSkill(hero, 141) then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, -1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
end;

function ReturnElfArmy2(hero, res)
  for i = 1, 7 do
    if Stek2[i].id > 0 then
       AddHeroCreatures( hero, Stek2[i].id, Stek2[i].kol);
       sleep(1);
       if GetHeroCreatures(hero, 91) > 0 then kolCreatures = GetHeroCreatures(hero, 91); RemoveHeroCreatures(hero, 91, kolCreatures); end;
    end;
  end;
  if GetObjectCreatures('RANDOMTOWN2', 91) > 0 then kolCreatures = GetObjectCreatures('RANDOMTOWN2', 91); RemoveObjectCreatures('RANDOMTOWN2', 91, kolCreatures); end;
--  if HasHeroSkill(hero, 141) then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, -1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
end;

SinergyLevelPrevSpellpower1 = 0;
SinergyLevelPrevKnowledge1  = 0;
SinergyLevelPrevSpellpower2 = 0;
SinergyLevelPrevKnowledge2  = 0;


function SinergySpellpower(hero)
  if GetObjectOwner(hero) == PLAYER_1 then
    SinergyLevel1 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if HasHeroSkill(hero, 87) then SinergyLevel1 = SinergyLevel1; else SinergyLevel1 = 0; end;

    if SinergyLevel1 > SinergyLevelPrevSpellpower1 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel1 - SinergyLevelPrevSpellpower1));
      SinergyLevelPrevSpellpower1 = SinergyLevel1;
    end;

    if SinergyLevel1 < SinergyLevelPrevSpellpower1 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel1 - SinergyLevelPrevSpellpower1));
      SinergyLevelPrevSpellpower1 = SinergyLevel1;
    end;
  end;

  if GetObjectOwner(hero) == PLAYER_2 then
    SinergyLevel2 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if HasHeroSkill(hero, 87) then SinergyLevel2 = SinergyLevel2; else SinergyLevel2 = 0; end;

    if SinergyLevel2 > SinergyLevelPrevSpellpower2 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel2 - SinergyLevelPrevSpellpower2));
      SinergyLevelPrevSpellpower2 = SinergyLevel2;
    end;

    if SinergyLevel2 < SinergyLevelPrevSpellpower2 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel2 - SinergyLevelPrevSpellpower2));
      SinergyLevelPrevSpellpower2 = SinergyLevel2;
    end;
  end;
end;


function SinergyKnowledge(hero)
  if GetObjectOwner(hero) == PLAYER_1 then
    SinergyLevel1 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if HasHeroSkill(hero, 81) then SinergyLevel1 = SinergyLevel1; else SinergyLevel1 = 0; end;

    if SinergyLevel1 > SinergyLevelPrevKnowledge1 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel1 - SinergyLevelPrevKnowledge1));
      SinergyLevelPrevKnowledge1 = SinergyLevel1;
    end;

    if SinergyLevel1 < SinergyLevelPrevKnowledge1 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel1 - SinergyLevelPrevKnowledge1));
      SinergyLevelPrevKnowledge1 = SinergyLevel1;
    end;
  end;

  if GetObjectOwner(hero) == PLAYER_2 then
    SinergyLevel2 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if HasHeroSkill(hero, 81) then SinergyLevel2 = SinergyLevel2; else SinergyLevel2 = 0; end;

    if SinergyLevel2 > SinergyLevelPrevKnowledge2 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel2 - SinergyLevelPrevKnowledge2));
      SinergyLevelPrevKnowledge2 = SinergyLevel2;
    end;

    if SinergyLevel2 < SinergyLevelPrevKnowledge2 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel2 - SinergyLevelPrevKnowledge2));
      SinergyLevelPrevKnowledge2 = SinergyLevel2;
    end;
  end;
end;


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
--  print("deltaExp")
--  print( deltaExp )
  WarpHeroExp (hero, heroExp + deltaExp);
--  print(GetHeroStat(hero, STAT_EXPERIENCE));
end;


RevDel1 = 0;
RevDel2 = 0;

DT_use1 = 0;
DT_use2 = 0;
DT_use1prev = 0;
DT_use2prev = 0;

array_DR = {}
array_DR[1] = {0, 0, 0, 0}
array_DR[2] = {0, 0, 0, 0}

function DarkRitual()
  varDT = 0;
  while varDT < 1 and GetDate (DAY) == 3 do
    sleep (10);
    if GetHeroStat(HeroMax1, STAT_MOVE_POINTS) == 0 and GetHeroStat(HeroMax1, STAT_MANA_POINTS) > 0 and DT_use1 == 0 and GetDate (DAY) == 3 then
      DT_use1 = 1;
      nap1Plus3Q(HeroMax1);
    elseif GetHeroStat(HeroMax1, STAT_MANA_POINTS) > 0 and DT_use1 == 0 and GetDate (DAY) == 3 then
      ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax1, STAT_MANA_POINTS));
    end;
    --nap1Plus3Q(HeroMax1); end; /UI/H5A1/Icons/Heroes/Portrets128x128/Giovanni.(Texture).xdb#xpointer(/Texture)
    if GetHeroStat(HeroMax2, STAT_MOVE_POINTS) == 0 and GetHeroStat(HeroMax2, STAT_MANA_POINTS) > 0 and DT_use2 == 0 and GetDate (DAY) == 3 then
      DT_use2 = 1;
      nap2Plus3Q(HeroMax2);
    elseif GetHeroStat(HeroMax2, STAT_MANA_POINTS) > 0 and DT_use2 == 0 and GetDate (DAY) == 3 then
      ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax2, STAT_MANA_POINTS));
    end;
  end;
end;

function Talk1(g1,g2)
  k = 1;
  DT_use1 = g2;
  if HeroMax1 == "Almegir" or HeroMax1 == "Almegir2" then k = 2; end;
  if g2 > 0 and GetDate (DAY) == 3 then
    for i = 1, k do
      for j = 1, 4 do
        if j < 3 then
          if j ~= g2 and GetHeroStat(HeroMax1, j) > 0 then
            ChangeHeroStat(HeroMax1,  j, -1);
            ChangeHeroStat(HeroMax1, g2,  1);
          end;
        else
          if j ~= g2 and GetHeroStat(HeroMax1, j) > 1 then
            ChangeHeroStat(HeroMax1,  j, -1);
            ChangeHeroStat(HeroMax1, g2,  1);
          end;
        end;
      end;
      ChangeHeroStat(HeroMax1, g2,  1);
    end;
  end;
  ChangeHeroStat(HeroMax1, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax1, STAT_MANA_POINTS));
  if g2 == 0 then DT_use1 = 0; end;
end;

function Talk2(g1,g2)
  k = 1;
  DT_use2 = g2;
  if HeroMax2 == "Almegir" or HeroMax2 == "Almegir2" then k = 2; end;
  if g2 > 0 and GetDate (DAY) == 3 then
    for i = 1, k do
      for j = 1, 4 do
        if j < 3 then
          if j ~= g2 and GetHeroStat(HeroMax2, j) > 0 then
            ChangeHeroStat(HeroMax2,  j, -1);
            ChangeHeroStat(HeroMax2, g2,  1);
          end;
        else
          if j ~= g2 and GetHeroStat(HeroMax2, j) > 1 then
            ChangeHeroStat(HeroMax2,  j, -1);
            ChangeHeroStat(HeroMax2, g2,  1);
          end;
        end;
      end;
      ChangeHeroStat(HeroMax2, g2,  1);
    end;
  end;
  ChangeHeroStat(HeroMax2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax2, STAT_MANA_POINTS));
  if g2 == 0 then DT_use2 = 0; end;
end;

function nap1Plus3Q(hero)
  hero1 = hero;
  DT_use1 = 5;
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."napPlus3.txt", 'nap1Plus3', 'zaw1Plus3Q');
end;

function zaw1Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."zawPlus3.txt", 'zaw1Plus3', 'kol1Plus3Q');
end;

function kol1Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."kolPlus3.txt", 'kol1Plus3', 'zna1Plus3Q');
end;

function zna1Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."znaPlus3.txt", 'zna1Plus3', 'noDR');
end;

function nap2Plus3Q(hero)
  hero2 = hero;
  DT_use2 = 5;
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."napPlus3.txt", 'nap2Plus3', 'zaw2Plus3Q');
end;

function zaw2Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."zawPlus3.txt", 'zaw2Plus3', 'kol2Plus3Q');
end;

function kol2Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."kolPlus3.txt", 'kol2Plus3', 'zna2Plus3Q');
end;

function zna2Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."znaPlus3.txt", 'zna2Plus3', 'noDR');
end;

function noDR(player)
  if player == PLAYER_1 then
    ChangeHeroStat(HeroMax1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax1, STAT_MANA_POINTS));
    DT_use1 = 0;
  end;
  if player == PLAYER_2 then
    ChangeHeroStat(HeroMax2, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax2, STAT_MANA_POINTS));
    DT_use2 = 0;
  end;
end;

function nap1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 2) > 0 then
      ChangeHeroStat(hero1, 1,  1);
      ChangeHeroStat(hero1, 2, -1);
      array_DR[1][2] = array_DR[1][2] - 1;
    end;
    if GetHeroStat(hero1, 3) > 1 then
      ChangeHeroStat(hero1, 1,  1);
      ChangeHeroStat(hero1, 3, -1);
      array_DR[1][3] = array_DR[1][3] - 1;
    end;
    if GetHeroStat(hero1, 4) > 1 then
      ChangeHeroStat(hero1, 1,  1);
      ChangeHeroStat(hero1, 4, -1);
      array_DR[1][4] = array_DR[1][4] - 1;
    end;
    ChangeHeroStat(hero1, 1,  1);
    array_DR[1][1] = array_DR[1][1] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 1;
end;

function zaw1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 1) > 0 then
      ChangeHeroStat(hero1, 2,  1);
      ChangeHeroStat(hero1, 1, -1);
      array_DR[1][1] = array_DR[1][1] - 1;
    end;
    if GetHeroStat(hero1, 3) > 1 then
      ChangeHeroStat(hero1, 2,  1);
      ChangeHeroStat(hero1, 3, -1);
      array_DR[1][3] = array_DR[1][3] - 1;
    end;
    if GetHeroStat(hero1, 4) > 1 then
      ChangeHeroStat(hero1, 2,  1);
      ChangeHeroStat(hero1, 4, -1);
      array_DR[1][4] = array_DR[1][4] - 1;
    end;
    ChangeHeroStat(hero1, 2,  1);
    array_DR[1][2] = array_DR[1][2] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 2;
end;

function kol1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 1) > 0 then
      ChangeHeroStat(hero1, 3,  1);
      ChangeHeroStat(hero1, 1, -1);
      array_DR[1][1] = array_DR[1][1] - 1;
    end;
    if GetHeroStat(hero1, 2) > 0 then
      ChangeHeroStat(hero1, 3,  1);
      ChangeHeroStat(hero1, 2, -1);
      array_DR[1][2] = array_DR[1][2] - 1;
    end;
    if GetHeroStat(hero1, 4) > 1 then
      ChangeHeroStat(hero1, 3,  1);
      ChangeHeroStat(hero1, 4, -1);
      array_DR[1][4] = array_DR[1][4] - 1;
    end;
    ChangeHeroStat(hero1, 3,  1);
    array_DR[1][3] = array_DR[1][3] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 3;
end;

function zna1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 1) > 0 then
      ChangeHeroStat(hero1, 4,  1);
      ChangeHeroStat(hero1, 1, -1);
      array_DR[1][1] = array_DR[1][1] - 1;
    end;
    if GetHeroStat(hero1, 2) > 0 then
      ChangeHeroStat(hero1, 4,  1);
      ChangeHeroStat(hero1, 2, -1);
      array_DR[1][2] = array_DR[1][2] - 1;
    end;
    if GetHeroStat(hero1, 3) > 1 then
      ChangeHeroStat(hero1, 4,  1);
      ChangeHeroStat(hero1, 3, -1);
      array_DR[1][3] = array_DR[1][3] - 1;
    end;
    ChangeHeroStat(hero1, 4,  1);
    array_DR[1][4] = array_DR[1][4] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 4;
end;

function nap2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 2) > 0 then
      ChangeHeroStat(hero2, 1,  1);
      ChangeHeroStat(hero2, 2, -1);
      array_DR[2][2] = array_DR[2][2] - 1;
    end;
    if GetHeroStat(hero2, 3) > 1 then
      ChangeHeroStat(hero2, 1,  1);
      ChangeHeroStat(hero2, 3, -1);
      array_DR[2][3] = array_DR[2][3] - 1;
    end;
    if GetHeroStat(hero2, 4) > 1 then
      ChangeHeroStat(hero2, 1,  1);
      ChangeHeroStat(hero2, 4, -1);
      array_DR[2][4] = array_DR[2][4] - 1;
    end;
    ChangeHeroStat(hero2, 1,  1);
    array_DR[2][1] = array_DR[2][1] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 1;
end;

function zaw2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 1) > 0 then
      ChangeHeroStat(hero2, 2,  1);
      ChangeHeroStat(hero2, 1, -1);
      array_DR[2][1] = array_DR[2][1] - 1;
    end;
    if GetHeroStat(hero2, 3) > 1 then
      ChangeHeroStat(hero2, 2,  1);
      ChangeHeroStat(hero2, 3, -1);
      array_DR[2][3] = array_DR[2][3] - 1;
    end;
    if GetHeroStat(hero2, 4) > 1 then
      ChangeHeroStat(hero2, 2,  1);
      ChangeHeroStat(hero2, 4, -1);
      array_DR[2][4] = array_DR[2][4] - 1;
    end;
    ChangeHeroStat(hero2, 2,  1);
    array_DR[2][2] = array_DR[2][2] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 2;
end;

function kol2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 1) > 0 then
      ChangeHeroStat(hero2, 3,  1);
      ChangeHeroStat(hero2, 1, -1);
      array_DR[2][1] = array_DR[2][1] - 1;
    end;
    if GetHeroStat(hero2, 2) > 0 then
      ChangeHeroStat(hero2, 3,  1);
      ChangeHeroStat(hero2, 2, -1);
      array_DR[2][2] = array_DR[2][2] - 1;
    end;
    if GetHeroStat(hero2, 4) > 1 then
      ChangeHeroStat(hero2, 3,  1);
      ChangeHeroStat(hero2, 4, -1);
      array_DR[2][4] = array_DR[2][4] - 1;
    end;
    ChangeHeroStat(hero2, 3,  1);
    array_DR[2][3] = array_DR[2][3] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 3;
end;

function zna2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 1) > 0 then
      ChangeHeroStat(hero2, 4,  1);
      ChangeHeroStat(hero2, 1, -1);
      array_DR[2][1] = array_DR[2][1] - 1;
    end;
    if GetHeroStat(hero2, 2) > 0 then
      ChangeHeroStat(hero2, 4,  1);
      ChangeHeroStat(hero2, 2, -1);
      array_DR[2][2] = array_DR[2][2] - 1;
    end;
    if GetHeroStat(hero2, 3) > 1 then
      ChangeHeroStat(hero2, 4,  1);
      ChangeHeroStat(hero2, 3, -1);
      array_DR[2][3] = array_DR[2][3] - 1;
    end;
    ChangeHeroStat(hero2, 4,  1);
    array_DR[2][4] = array_DR[2][4] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 4;
end;

function RemoveDarkRitual1(hero)
  ChangeHeroStat(hero, 1, 0 - array_DR[1][1]);
  ChangeHeroStat(hero, 2, 0 - array_DR[1][2]);
  ChangeHeroStat(hero, 3, 0 - array_DR[1][3]);
  ChangeHeroStat(hero, 4, 0 - array_DR[1][4]);
  DT_use1prev = DT_use1;
  DT_use1 = 0;
end;

function RemoveDarkRitual2(hero)
  ChangeHeroStat(hero, 1, 0 - array_DR[2][1]);
  ChangeHeroStat(hero, 2, 0 - array_DR[2][2]);
  ChangeHeroStat(hero, 3, 0 - array_DR[2][3]);
  ChangeHeroStat(hero, 4, 0 - array_DR[2][4]);
  DT_use2prev = DT_use2;
  DT_use2 = 0;
end;

function Revelation1()
  if RevDel1 == 1 then
    RevDel1 = 2;
    heroLevel = GetHeroLevel(HeroMax1);
    Exp = array_level[heroLevel - 2];
    WarpHeroExp(HeroMax1, Exp);
    i = 0;
    while i < 3 do
      race = getrace(HeroMax1);
      rnd = random(100);
      if rnd < PercentA[race] and GetHeroStat(HeroMax1, STAT_ATTACK) > 0  then
        ChangeHeroStat(HeroMax1, STAT_ATTACK, -1); i = i + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax1, STAT_DEFENCE) > 0 then
        ChangeHeroStat(HeroMax1, STAT_DEFENCE, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_SPELL_POWER) > 1 then
        ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_KNOWLEDGE) > 1 then
        ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -1); i = i + 1;
      end;
    end;
  end;
  if RevDel1 == 0 then
    RevDel1 = 1;
  end;
  if RevDel1 == 3 then
    if RevUse1 == 3 then
      LevelUpHero(HeroMax1);
      RevDel1 = 4;
--      print(Exp);
    end;
    if RevUse1 == 1 then
      RevUse1 = 3;
      heroLevel = GetHeroLevel(HeroMax1);
      Exp = array_level[heroLevel - 2];
      WarpHeroExp(HeroMax1, Exp);
      i = 0;
      while i < 3 do
        race = getrace(HeroMax1);
        rnd = random(100);
        if rnd < PercentA[race] and GetHeroStat(HeroMax1, STAT_ATTACK) > 0  then
          ChangeHeroStat(HeroMax1, STAT_ATTACK, -1); i = i + 1;
        end;
        if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax1, STAT_DEFENCE) > 0 then
          ChangeHeroStat(HeroMax1, STAT_DEFENCE, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_SPELL_POWER) > 1 then
          ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_KNOWLEDGE) > 1 then
          ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -1); i = i + 1;
        end;
      end;
      LevelUpHero(HeroMax1);
      RevUse1 = 4;
    end;
  end;
end;

function Revelation2()
  if RevDel2 == 1 then
    RevDel2 = 2;
    heroLevel = GetHeroLevel(HeroMax2);
    Exp = array_level[heroLevel - 2];
    WarpHeroExp(HeroMax2, Exp);
    i = 0;
    while i < 3 do
      race = getrace(HeroMax2);
      rnd = random(100);
      if rnd < PercentA[race] and GetHeroStat(HeroMax2, STAT_ATTACK) > 0  then
        ChangeHeroStat(HeroMax2, STAT_ATTACK, -1); i = i + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax2, STAT_DEFENCE) > 0 then
        ChangeHeroStat(HeroMax2, STAT_DEFENCE, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_SPELL_POWER) > 1 then
        ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_KNOWLEDGE) > 1 then
        ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -1); i = i + 1;
      end;
    end;
  end;
  if RevDel2 == 0 then
    RevDel2 = 1;
  end;
  if RevDel2 == 3 then
    if RevUse2 == 3 then
      LevelUpHero(HeroMax2);
      RevDel2 = 4;
--      print(Exp);
    end;
    if RevUse2 == 1 then
      RevUse2 = 3;
      heroLevel = GetHeroLevel(HeroMax2);
      Exp = array_level[heroLevel - 2];
      WarpHeroExp(HeroMax2, Exp);
      i = 0;
      while i < 3 do
        race = getrace(HeroMax2);
        rnd = random(100);
        if rnd < PercentA[race] and GetHeroStat(HeroMax2, STAT_ATTACK) > 0  then
          ChangeHeroStat(HeroMax2, STAT_ATTACK, -1); i = i + 1;
        end;
        if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax2, STAT_DEFENCE) > 0 then
          ChangeHeroStat(HeroMax2, STAT_DEFENCE, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_SPELL_POWER) > 1 then
          ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_KNOWLEDGE) > 1 then
          ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -1); i = i + 1;
        end;
      end;
      LevelUpHero(HeroMax2);
      RevUse2 = 4;
    end;
  end;
end;

function RevelationDel1(hero)
  if RevDel1 == 2 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel1 = 3;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
  if RevDel1 == 4 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel1 = 3;
    RevUse1 = 1;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
end;

function RevelationDel2(hero)
  if RevDel2 == 2 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel2 = 3;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
  if RevDel2 == 4 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel2 = 3;
    RevUse2 = 1;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
end;



Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'town', 'ChangeRandomTown' );

function ChangeRandomTown(hero)
  SetObjectOwner('TOWN', GetObjectOwner(hero));
  if GetObjectOwner(hero) == 1 then race = hero1race; end;
  if GetObjectOwner(hero) == 2 then race = hero2race; end;
  if race == 1 then TransformTown('TOWN', 0); end;
  if race == 2 then TransformTown('TOWN', 5); end;
  if race == 3 then TransformTown('TOWN', 4); end;
  if race == 4 then TransformTown('TOWN', 1); end;
  if race == 5 then TransformTown('TOWN', 2); end;
  if race == 6 then TransformTown('TOWN', 3); end;
  if race == 7 then TransformTown('TOWN', 6); end;
  if race == 8 then TransformTown('TOWN', 7); end;
  Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'town', 'no' );
  UpgradeTownBuilding('TOWN', 1);
  UpgradeTownBuilding('TOWN', 1);
end;

FortunateAdventureEnable1 = 0
FortunateAdventureEnable2 = 0

array_HasArtsSlot1 = {}
array_HasArtsSlot1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_HasArtsSlot2 = {}
array_HasArtsSlot2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

function Spoils1()
    for i = 0, 2 do
      for j = 1, length(array_arts[i]) do
        if HasArtefact(HeroMax1, array_arts[i][j].id) then
          if array_arts[i][j].place == 1 and array_HasArtsSlot1[1] == 2 then array_HasArtsSlot1[1] = 1; end;
          if array_arts[i][j].place == 1 and array_HasArtsSlot1[1] == 0 then array_HasArtsSlot1[1] = 2; end;
          if array_arts[i][j].place ~= 1 then
            array_HasArtsSlot1[array_arts[i][j].place] = 1;
          end;
        end;
      end;
    end;
    ArtNumber1 = random (length(array_arts[1])) + 1;
    while array_arts[1][ArtNumber1].blocked == 1 or HasArtefact(HeroMax1, array_arts[1][ArtNumber1].id, 0) or array_HasArtsSlot1[array_arts[1][ArtNumber1].place] == 1 do
      ArtNumber1 = random (length(array_arts[1])) + 1;
    end;
    GiveArtefact(HeroMax1, array_arts[1][ArtNumber1].id, 1);
    SpoilsUse1 = 1;
end;

function Spoils2()
    for i = 0, 2 do
      for j = 1, length(array_arts[i]) do
        if HasArtefact(HeroMax2, array_arts[i][j].id) then
          if array_arts[i][j].place == 1 and array_HasArtsSlot2[1] == 2 then array_HasArtsSlot2[1] = 1; end;
          if array_arts[i][j].place == 1 and array_HasArtsSlot2[1] == 0 then array_HasArtsSlot2[1] = 2; end;
          if array_arts[i][j].place ~= 1 then
            array_HasArtsSlot2[array_arts[i][j].place] = 1;
          end;
        end;
      end;
    end;
    ArtNumber2 = random (length(array_arts[1])) + 1;
    while array_arts[1][ArtNumber2].blocked == 1 or HasArtefact(HeroMax2, array_arts[1][ArtNumber2].id, 0) or array_HasArtsSlot2[array_arts[1][ArtNumber2].place] == 1 do
      ArtNumber2 = random (length(array_arts[1])) + 1;
    end;
    GiveArtefact(HeroMax2, array_arts[1][ArtNumber2].id, 1);
    SpoilsUse2 = 1;
end;

arrayArtsForFortunateAdventure1 = {}
arrayArtsForFortunateAdventure2 = {}

Trigger( OBJECT_TOUCH_TRIGGER, 'lavka1', 'ArtifactMerchant1' );
Trigger( OBJECT_TOUCH_TRIGGER, 'lavka2', 'ArtifactMerchant2' );

function ArtifactMerchant1(hero)
  if FortunateAdventureEnable1 == 1 then FortunateAdventureEnable1 = 2; end;
  if SpoilsUse1 == 0 and HasHeroSkill(hero, 129) then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Spoils.txt", 'Spoils1', 'no');
  end;
end;

function ArtifactMerchant2(hero)
  if FortunateAdventureEnable2 == 1 then FortunateAdventureEnable2 = 2; end;
  if SpoilsUse2 == 0 and HasHeroSkill(hero, 129) then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Spoils.txt", 'Spoils2', 'no');
  end;
end;

function FortunateAdventureBlockInTower1()
  if FortunateAdventureEnable1 == 1 then FortunateAdventureEnable1 = 2; end;
end;

function FortunateAdventureBlockInTower2()
  if FortunateAdventureEnable2 == 1 then FortunateAdventureEnable2 = 2; end;
end;

function FortunateAdventure1()
  if (hero1race == 5 or hero1race == 6) and IsHeroInTown(HeroMax1, 'RANDOMTOWN1', 1, 0) then
    MoveHeroRealTime(HeroMax1, 55, 80);
    Trigger( OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN1', 'FortunateAdventureBlockInTower1');
  end;
  arrayArtsForFortunateAdventure1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  kol_arts_hero1 = 0
  MakeHeroInteractWithObject (HeroMax1, 'FortunateAdventure1');
  FortunateAdventureEnable1 = 1;
  NewArt1 = 0;
  for lev_art1 = 0, 2 do
    for num_art1 = 1, length(array_arts[lev_art1]) do
      if HasArtefact(HeroMax1, array_arts[lev_art1][num_art1].id) then
        arrayArtsForFortunateAdventure1[kol_arts_hero1] = array_arts[lev_art1][num_art1].id;
        kol_arts_hero1 = kol_arts_hero1 + 1;
      end;
    end;
  end;
  while FortunateAdventureEnable1 == 1 do
    Gold1 = GetPlayerResource(PLAYER_1, GOLD);
    sleep(2);
    for lev_art1 = 0, 2 do
      for num_art1 = 1, length(array_arts[lev_art1]) do
        if HasArtefact(HeroMax1, array_arts[lev_art1][num_art1].id) then
          HasArt1 = 0;
          for i = 0, kol_arts_hero1 do
            if arrayArtsForFortunateAdventure1[i] == array_arts[lev_art1][num_art1].id then
              HasArt1 = 1;
            end;
          end;
        end;
        if HasArtefact(HeroMax1, array_arts[lev_art1][num_art1].id) and HasArt1 == 0 then
          arrayArtsForFortunateAdventure1[kol_arts_hero1] = array_arts[lev_art1][num_art1].id;
          kol_arts_hero1 = kol_arts_hero1 + 1;
          NewArt1 = 1;
        end;
        if NewArt1 == 1 and (Gold1 - GetPlayerResource(PLAYER_1, GOLD)) <= 1.05 * array_arts[lev_art1][num_art1].price and (Gold1 - GetPlayerResource(PLAYER_1, GOLD)) >= 0.95 * array_arts[lev_art1][num_art1].price and FortunateAdventureEnable1 == 1 then
          ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(FortunateAdventureDiscount * array_arts[lev_art1][num_art1].price)}, HeroMax1, 1, random(6) + 3);
          SetPlayerResource (PLAYER_1, GOLD, int(GetPlayerResource (PLAYER_1, GOLD) + FortunateAdventureDiscount * array_arts[lev_art1][num_art1].price));
          NewArt1 = 0;
        end;
      end;
    end;
    if FortunateAdventureEnable1 == 2 then break; end;
  end;
end;

function FortunateAdventure2()
  if (hero2race == 5 or hero2race == 6) and IsHeroInTown(HeroMax2, 'RANDOMTOWN2', 1, 0) then
    MoveHeroRealTime(HeroMax2, 33, 14);
    Trigger( OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN2', 'FortunateAdventureBlockInTower2');
  end;
  arrayArtsForFortunateAdventure2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  kol_arts_hero2 = 0
  MakeHeroInteractWithObject (HeroMax2, 'FortunateAdventure2');
  FortunateAdventureEnable2 = 1;
  NewArt2 = 0;
  for lev_art2 = 0, 2 do
    for num_art2 = 1, length(array_arts[lev_art2]) do
      if HasArtefact(HeroMax2, array_arts[lev_art2][num_art2].id) then
        arrayArtsForFortunateAdventure2[kol_arts_hero2] = array_arts[lev_art2][num_art2].id;
        kol_arts_hero2 = kol_arts_hero2 + 1;
      end;
    end;
  end;
  while FortunateAdventureEnable2 == 1 do
    Gold2 = GetPlayerResource(PLAYER_2, GOLD);
    sleep(2);
    for lev_art2 = 0, 2 do
      for num_art2 = 1, length(array_arts[lev_art2]) do
        if HasArtefact(HeroMax2, array_arts[lev_art2][num_art2].id) then
          HasArt2 = 0;
          for i = 0, kol_arts_hero2 do
            if arrayArtsForFortunateAdventure2[i] == array_arts[lev_art2][num_art2].id then
              HasArt2 = 1;
            end;
          end;
        end;
        if HasArtefact(HeroMax2, array_arts[lev_art2][num_art2].id) and HasArt2 == 0 then
          arrayArtsForFortunateAdventure2[kol_arts_hero2] = array_arts[lev_art2][num_art2].id;
          kol_arts_hero2 = kol_arts_hero2 + 1;
          NewArt2 = 1;
        end;
        if NewArt2 == 1 and (Gold2 - GetPlayerResource(PLAYER_2, GOLD)) <= 1.05 * array_arts[lev_art2][num_art2].price and (Gold2 - GetPlayerResource(PLAYER_2, GOLD)) >= 0.95 * array_arts[lev_art2][num_art2].price and FortunateAdventureEnable2 == 1 then
          ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(FortunateAdventureDiscount * array_arts[lev_art2][num_art2].price)}, HeroMax2, 2, random(6) + 3);
          SetPlayerResource (PLAYER_2, GOLD, int(GetPlayerResource (PLAYER_2, GOLD) + FortunateAdventureDiscount * array_arts[lev_art2][num_art2].price));
          NewArt2 = 0;
        end;
      end;
    end;
    if FortunateAdventureEnable2 == 2 then break; end;
  end;
end;


ScoutingEnable1 = 0;
ScoutingEnable2 = 0;

function Scouting1Q()
  if ScoutingEnable1 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Scouting.txt", 'Scouting1', 'no');
  end;
end;

function Scouting2Q()
  if ScoutingEnable2 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Scouting.txt", 'Scouting2', 'no');
  end;
end;

function Scouting1()
  if ScoutingEnable1 == 0 then
--    for i = 1, 5 do
--      print(array_heroes[hero2race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name);
--    end;
--    print('x');

    for i = 1, length(array_heroes[hero2race-1]) do
      array_heroes[hero2race-1][i].block_temply = 0;
    end;
--    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][1]].p5, 31, 90, GROUND);
    if CherkPossibleHeroesEnable == 1 then k = 4; else k = 5; end;
    for i = 1, k do
      if arrayPossibleHeroes[HeroCollectionPlayer2][i] ~= HeroForScouting1_Player2 and arrayPossibleHeroes[HeroCollectionPlayer2][i] ~= HeroForScouting2_Player2 and arrayPossibleHeroes[HeroCollectionPlayer2][i] > 0 then
        if HeroCollectionPlayer2 == 2 then
          RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].p5);
        end;
        if HeroCollectionPlayer2 == 3 then
          RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].p7);
        end;
      end;
    end;

    if HalfLeveling2 == 1 then
      if HeroTavern2 == 0 then
        for i = 1, length(array_heroes[hero2race-1]) do
          if HeroMin2 == array_heroes[hero2race-1][i].name2 then
            if HeroCollectionPlayer2 == 2 then
              RemoveObject(array_heroes[hero2race-1][i].p5);
            end;
            if HeroCollectionPlayer2 == 3 then
              RemoveObject(array_heroes[hero2race-1][i].p7);
            end;
            array_heroes[hero2race-1][i].block_temply = 1;
            i = length(array_heroes[hero2race-1]);
          end;
        end;
      else
        MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."HeroTavern.txt" );
      end;
    end;
  end;
  ScoutingEnable1 = 1;
  MoveCameraForPlayers( 1, 31, 88, 0, 20, 0, 0, 0, 0, 1);
end;

function Scouting2()
  if ScoutingEnable2 == 0 then
--    for i = 1, 5 do
--      print(array_heroes[hero1race-1][arrayPossibleHeroes[HeroCollectionPlayer1][i]].name);
--    end;
--    print('y');

    for i = 1, length(array_heroes[hero1race-1]) do
      array_heroes[hero1race-1][i].block_temply = 0;
    end;
    if CherkPossibleHeroesEnable == 1 then k = 4; else k = 5; end;
    for i = 1, k do
      if arrayPossibleHeroes[HeroCollectionPlayer1][i] ~= HeroForScouting1_Player1 and arrayPossibleHeroes[HeroCollectionPlayer1][i] ~= HeroForScouting2_Player1 and arrayPossibleHeroes[HeroCollectionPlayer1][i] > 0 then
        if HeroCollectionPlayer1 == 0 then
          RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[HeroCollectionPlayer1][i]].p2);
        end;
        if HeroCollectionPlayer1 == 1 then
          RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[HeroCollectionPlayer1][i]].p4);
        end;
      end;
    end;

    if HalfLeveling1 == 1 then
      if HeroTavern1 == 0 then
        for i = 1, length(array_heroes[hero1race-1]) do
          if HeroMin1 == array_heroes[hero1race-1][i].name then
            if HeroCollectionPlayer1 == 0 then
              RemoveObject(array_heroes[hero1race-1][i].p2);
            end;
            if HeroCollectionPlayer1 == 1 then
              RemoveObject(array_heroes[hero1race-1][i].p4);
            end;
            array_heroes[hero1race-1][i].block_temply = 1;
            i = length(array_heroes[hero1race-1]);
          end;
        end;
      else
        MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."HeroTavern.txt" );
      end;
    end;
  end;
  ScoutingEnable2 = 1;
  MoveCameraForPlayers( 2, 44, 23, 0, 20, 0, 3.14, 0, 0, 1);
end;

function Scouting1DopInfo()
  if HasHeroSkill(HeroMax2, 20) and ScoutingEnable2 == 1 then
    if HeroTavern1 == 0 then
      for i = 1, length(array_heroes[hero1race-1]) do
        if HeroMin1 == array_heroes[hero1race-1][i].name then
          if HeroCollectionPlayer1 == 0 then
            RemoveObject(array_heroes[hero1race-1][i].p2);
            print('hero1 del ', array_heroes[hero1race-1][i].name)
          end;
          if HeroCollectionPlayer1 == 1 then
            RemoveObject(array_heroes[hero1race-1][i].p4);
            print('hero1 del ', array_heroes[hero1race-1][i].name)
          end;
          array_heroes[hero1race-1][i].block_temply = 1;
          i = length(array_heroes[hero1race-1]);
        end;
      end;
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."HeroTop.txt" );
      MoveCameraForPlayers( 2, 44, 23, 0, 20, 0, 3.14, 0, 0, 1);
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."HeroTavern.txt" );
    end;
  end;
end;

function Scouting2DopInfo()
  if HasHeroSkill(HeroMax1, 20) and ScoutingEnable1 == 1 then
    if HeroTavern2 == 0 then
      print('length(array_heroes[hero2race-1] ', length(array_heroes[hero2race-1]))
      for i = 1, length(array_heroes[hero2race-1]) do
        if HeroMin2 == array_heroes[hero2race-1][i].name2 then
          if HeroCollectionPlayer2 == 2 then
            RemoveObject(array_heroes[hero2race-1][i].p5);
            print('hero2 del ', array_heroes[hero2race-1][i].name2)
          end;
          if HeroCollectionPlayer2 == 3 then
            RemoveObject(array_heroes[hero2race-1][i].p7);
            print('hero2 del ', array_heroes[hero2race-1][i].name2)
          end;
          array_heroes[hero2race-1][i].block_temply = 1;
          i = length(array_heroes[hero2race-1]);
        end;
      end;
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."HeroTop.txt" );
      MoveCameraForPlayers( 1, 33, 88, 0, 20, 0, 0, 0, 0, 1);
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."HeroTavern.txt" );
    end;
  end;
end;

DisguiseEnable1 = 0;
DisguiseEnable2 = 0;
DisguiseHero1 = 0;
DisguiseHero2 = 0;

function Disguise1Q()
  if DisguiseEnable1 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Disguise.txt", 'Disguise1', 'no');
  end;
end;

function Disguise2Q()
  if DisguiseEnable2 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Disguise.txt", 'Disguise2', 'no');
  end;
end;

function Disguise1()
  OpenCircleFog( 41, 23, 0, 5, 1 );
  MoveCameraForPlayers( 1, 41, 23, 0, 20, 0, 3.14, 0, 0, 1);
  DisguiseEnable1 = 1;
end;

function Disguise2()
  OpenCircleFog( 36, 88, 0, 5, 2 );
  MoveCameraForPlayers( 2, 36, 86, 0, 20, 0, 0, 0, 0, 1);
  DisguiseEnable2 = 1;
end;



EstatesQ1 = 0;
EstatesQ2 = 0;

function Estates1Q(hero)
  EstatesEnable1 = 1;
  if EstatesDiscountUse1 == 0 and GetHeroLevel(hero) >= HalfLevel and (RemSkSum1 > 0 or GetHeroLevel(hero) > StartLevel) then
    if GetHeroLevel(hero) < StartLevel then
      discount1 = RemSkSum1 * EstatesDiscountMentor;
    else
      discount1 = EstatesDiscountLevel * (GetHeroLevel(hero) - StartLevel) + RemSkSum1 * EstatesDiscountMentor;
    end;
    if EstatesQ1 == 0 then
      EstatesQ1 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."EstatesQ.txt"; eq = discount1}, 'Estates1', 'EstatesNo1');
    end;
  end;
end;

function Estates1()
  if EstatesDiscountUse1 == 0 then
    SetPlayerResource(PLAYER_1, 6, GetPlayerResource(1, 6) + discount1);
    EstatesDiscountUse1 = 1;
  end;
end;

function EstatesNo1()
  EstatesQ1 = 0;
end;

function Estates2Q(hero)
  EstatesEnable2 = 1;
  if EstatesDiscountUse2 == 0 and GetHeroLevel(hero) >= HalfLevel and (RemSkSum2 > 0 or GetHeroLevel(hero) > StartLevel) then
    if GetHeroLevel(hero) < StartLevel then
      discount2 = RemSkSum2 * EstatesDiscountMentor;
    else
      discount2 = EstatesDiscountLevel * (GetHeroLevel(hero) - StartLevel) + RemSkSum2 * EstatesDiscountMentor;
    end;
    if EstatesQ2 == 0 then
      EstatesQ2 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."EstatesQ.txt"; eq = discount2}, 'Estates2', 'EstatesNo2');
    end;
  end;
end;

function Estates2()
  if EstatesDiscountUse2 == 0 then
    SetPlayerResource(PLAYER_2, 6, GetPlayerResource(2, 6) + discount2);
    EstatesDiscountUse2 = 1;
  end;
end;

function EstatesNo2()
  EstatesQ2 = 0;
end;


array_units_for_recruitment = {};
array_units_for_recruitment = { 1, 2, 3, 4, 5, 6, 15, 16, 17, 18, 19, 20, 29, 30, 31, 32, 33, 34, 43, 44, 45, 46, 47, 48, 57, 58, 59, 60, 61, 62, 71, 71, 73, 74, 75, 76, 92, 93, 94, 95, 96, 97, 106, 107, 108, 117, 118, 119, 120, 121, 122, 131, 132, 133, 138, 139, 140, 145, 146, 147, 152, 153, 154, 159, 160, 161, 166, 167, 168, 173, 174, 175};

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

Stek1 = {};
Stek1 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};

Stek2 = {} ;
Stek2 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};

array_necro_kol = {};
array_necro_kol = { 110, 70, 30, 14, 7, 4, 3};

NecroPara = {}
NecroPara = { { ["id1"] = 29, ["id2"] = 152}, { ["id1"] = 31, ["id2"] = 153}, { ["id1"] = 34, ["id2"] = 154}, { ["id1"] = 35, ["id2"] = 155}, { ["id1"] = 37, ["id2"] = 156}, { ["id1"] = 39, ["id2"] = 157}, { ["id1"] = 41, ["id2"] = 158} }

function NecroBonus1(hero)
  ks = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  pause1 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."NecroBonus1.txt"; eq = ks}, 'pause1F');
  while pause1 == 0 do
    sleep(1);
  end;
  Stek1 = { {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison1', 1);
  SetObjectOwner('Garrison1', 1);
  Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetHeroCreaturesTypes(hero);
  kol1 = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  if hero == "Berein" or hero == "Berein2" then NecroCoef1 = 1 + MarkelCoef * GetHeroLevel(hero); else NecroCoef1 = 1; end;
  if HasHeroSkill(hero, NECROMANCER_FEAT_LORD_OF_UNDEAD) then NecroCoef1 = NecroCoef1 * 1.301; end;
  for i = 1, 7 do
    for j = 3, 3 do
      for k = 1, 21 do
        if Stek1[i].id == array_units[j][k].id then
          if Stek1[i].id == 29 or Stek1[i].id == 152 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[1]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 31 or Stek1[i].id == 153 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[2]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 34 or Stek1[i].id == 154 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[3]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 35 or Stek1[i].id == 155 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[4]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 37 or Stek1[i].id == 156 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[5]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 39 or Stek1[i].id == 157 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[6]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 41 or Stek1[i].id == 158 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[7]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          k = 21;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison1');
  Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetObjectCreaturesTypes('Garrison1');
  for i = 1, 7 do
    if Stek1[i].id > 0 then
      Stek1[i].kol = GetObjectCreatures('Garrison1', Stek1[i].id);
    end;
  end;
  while kol1 > 0 do
    for i = 1, 7 do
      if Stek1[i].id > 0 then
        if GetObjectCreatures('Garrison1', Stek1[i].id) < Stek1[i].kol then
          kol1 = kol1 - 1;
          if HasHeroSkill(hero, 62) then
            for j = 1, 7 do
              if Stek1[i].id == NecroPara[j].id1 and GetHeroCreatures(hero, NecroPara[j].id2) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id2, Stek1[i].kol);
                RemoveObjectCreatures('Garrison1', NecroPara[j].id2, Stek1[i].kol);
                for k = 1, 7 do
                  if Stek1[k].id == NecroPara[j].id2 then
                    Stek1[k].kol = 0;
                  end;
                end;
              end;
              if Stek1[i].id == NecroPara[j].id2 and GetHeroCreatures(hero, NecroPara[j].id1) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id1, Stek1[i].kol);
                RemoveObjectCreatures('Garrison1', NecroPara[j].id1, Stek1[i].kol);
                for k = 1, 7 do
                  if Stek1[k].id == NecroPara[j].id1 then
                    Stek1[k].kol = 0;
                  end;
                end;
              end;
            end;
          end;
          Stek1[i].kol = 0;
          if kol1 == 0 then
            for j = 1, 7 do
              if Stek1[j].kol ~= 0 then
                if Stek1[j].id > 0 then
                  RemoveObjectCreatures('Garrison1', Stek1[j].id, Stek1[j].kol);
                end;
              end;
            end;
            i = 7;
          end;
        end;
      end;
    end;
    sleep(1);
  end;
  sleep(3);
--  if HasHeroSkill(hero, 104) or HasHeroSkill(hero, 82) then
--    DublikatHero1( hero);
--  end;
end;

function NecroBonus2(hero)
  ks = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  pause2 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."NecroBonus1.txt"; eq = ks}, 'pause2F');
  while pause2 == 0 do
    sleep(1);
  end;
  Stek2 = { {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison2', 1);
  SetObjectOwner('Garrison2', 2);
  Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetHeroCreaturesTypes(hero);
  kol2 = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  if hero == "Berein" or hero == "Berein2" then NecroCoef2 = 1 + MarkelCoef * GetHeroLevel(hero); else NecroCoef2 = 1; end;
  if HasHeroSkill(hero, NECROMANCER_FEAT_LORD_OF_UNDEAD) then NecroCoef2 = NecroCoef2 * 1.301; end;
  for i = 1, 7 do
    for j = 3, 3 do
      for k = 1, 21 do
        if Stek2[i].id == array_units[j][k].id then
          if Stek2[i].id == 29 or Stek2[i].id == 152 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[1]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 31 or Stek2[i].id == 153 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[2]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 34 or Stek2[i].id == 154 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[3]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 35 or Stek2[i].id == 155 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[4]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 37 or Stek2[i].id == 156 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[5]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 39 or Stek2[i].id == 157 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[6]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 41 or Stek2[i].id == 158 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[7]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          k = 21;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison2');
  Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetObjectCreaturesTypes('Garrison2');
  for i = 1, 7 do
    if Stek2[i].id > 0 then
      Stek2[i].kol = GetObjectCreatures('Garrison2', Stek2[i].id);
    end;
  end;
  while kol2 > 0 do
    for i = 1, 7 do
      if Stek2[i].id > 0 then
        if GetObjectCreatures('Garrison2', Stek2[i].id) < Stek2[i].kol then
          kol2 = kol2 - 1;
          if HasHeroSkill(hero, 62) then
            for j = 1, 7 do
              if Stek2[i].id == NecroPara[j].id1 and GetHeroCreatures(hero, NecroPara[j].id2) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id2, Stek2[i].kol);
                RemoveObjectCreatures('Garrison2', NecroPara[j].id2, Stek2[i].kol);
                for k = 1, 7 do
                  if Stek2[k].id == NecroPara[j].id2 then
                    Stek2[k].kol = 0;
                  end;
                end;
              end;
              if Stek2[i].id == NecroPara[j].id2 and GetHeroCreatures(hero, NecroPara[j].id1) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id1, Stek2[i].kol);
                RemoveObjectCreatures('Garrison2', NecroPara[j].id1, Stek2[i].kol);
                for k = 1, 7 do
                  if Stek2[k].id == NecroPara[j].id1 then
                    Stek2[k].kol = 0;
                  end;
                end;
              end;
            end;
          end;
          Stek2[i].kol = 0;
          if kol2 == 0 then
            for j = 1, 7 do
              if Stek2[j].kol ~= 0 then
                if Stek2[j].id > 0 then
                  RemoveObjectCreatures('Garrison2', Stek2[j].id, Stek2[j].kol);
                end;
              end;
            end;
            i = 7;
          end;
        end;
      end;
    end;
    sleep(1);
  end;
  sleep(3);
--  if HasHeroSkill(hero, 104) or HasHeroSkill(hero, 82) then
--    DublikatHero2( hero);
--  end;
end;

arrayGradeDip1 = {};
arrayGradeDip2 = {};
arrayGradeDip1 = {   7,   9,  11,  13,  21,  23,  25,  27,  35,  37,  39,  41,  49,  51,  53,  55,  63,  65,  67,  68,  69,  77,  79,  81,  83,  98, 100, 102, 105, 123, 125, 127, 129}
arrayGradeDip2 = { 109, 110, 111, 112, 134, 135, 136, 137, 155, 156, 157, 158, 148, 149, 150, 151, 162, 163, 164,  70, 165, 141, 142, 143, 144, 169, 170, 171, 172, 176, 177, 178, 179}


function diplomacy1(hero)
  pause1 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Diplomacy.txt", 'pause1F');
  while pause1 == 0 do
    sleep(1);
  end;
  Stek1 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison3', 1);
  SetObjectOwner('Garrison3', 1);
  Stek1[1].id1, Stek1[2].id1, Stek1[3].id1, Stek1[4].id1, Stek1[5].id1, Stek1[6].id1, Stek1[7].id1 = GetHeroCreaturesTypes(hero);
  for i = 1, 7 do
    if Stek1[i].id1 > 0 then
      for a = 1, length(arrayGradeDip1) do
        if Stek1[i].id1 == arrayGradeDip1[a] then
          if GetHeroCreatures(hero, arrayGradeDip2[a]) < GetHeroCreatures(hero, Stek1[i].id1) then
            Stek1[i].id2 = arrayGradeDip2[a];
          else
            Stek1[i].id2 = -1;
          end;
          a = length(arrayGradeDip1);
        end;
      end;
      if Stek1[i].id2 == 0 then
        for a = 1, length(arrayGradeDip2) do
          if Stek1[i].id1 == arrayGradeDip2[a] then
            if GetHeroCreatures(hero, arrayGradeDip1[a]) <= GetHeroCreatures(hero, Stek1[i].id1) then
              Stek1[i].id2 = arrayGradeDip1[a];
            else
              Stek1[i].id2 = -1;
            end;
            a = length(arrayGradeDip2);
          end;
        end;
      end;
    end;
  end;
  kol1 = 0;
  if HasArtefact( hero, 88, 1) then k1 = CrownOfLeaderBonus; else k1 = 1; end;
  if hero == "Rolf" or hero == "Rolf2" then k1 = 2; end;
  for i = 1, 7 do
    for j = 1, 8 do
      for k = 1, 21 do
        if Stek1[i].id1 == array_units[j][k].id and Stek1[i].id2 > 0 then
          Stek1[i].kol = int(k1 * DiplomacyCoef * kolUnit1[array_units[j][k].lvl]);
          AddObjectCreatures('Garrison3', Stek1[i].id2, Stek1[i].kol );
          k = 21;
          j = 8;
          kol1 = kol1 + 1;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison3');
  Stek1[1].id2, Stek1[2].id2, Stek1[3].id2, Stek1[4].id2, Stek1[5].id2, Stek1[6].id2, Stek1[7].id2 = GetObjectCreaturesTypes('Garrison3');
  for i = 1, 7 do
    if Stek1[i].id2 > 0 then
      Stek1[i].kol = GetObjectCreatures('Garrison3', Stek1[i].id2);
    end;
  end;
  x1, y1 = GetObjectPosition(hero);
  
  pause1 = 0;
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    sleep(2);
    startThread (Confirm1F);
  end;
  
  while kol1 > 0 and pause1 == 0 do
    for i = 1, 7 do
      if Stek1[i].id2 > 0 then
        if GetObjectCreatures('Garrison3', Stek1[i].id2) < Stek1[i].kol then
          for j = 1, 7 do
            if j ~= i then
              if Stek1[j].id2 > 0 then
                RemoveObjectCreatures('Garrison3', Stek1[j].id2, Stek1[j].kol);
              end;
            end;
          end;
          i = 7;
          kol1 = 0;
--          pause1 = 1;
        end;
      end;
    end;
    x1_actual, y1_actual = GetObjectPosition(hero);
    if x1_actual ~= x1 or y1_actual ~= y1 then kol1 = 0; end;
    sleep(1);
  end;
  DiplomacyEnable1 = 1;
  sleep(3);
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    NecroBonus1(hero);
  end;
end;


function diplomacy2(hero)
  pause2 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Diplomacy.txt", 'pause2F');
  while pause2 == 0 do
    sleep(1);
  end;
--  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Diplomacy.txt" );
  Stek2 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison4', 1);
  SetObjectOwner('Garrison4', 2);
  Stek2[1].id1, Stek2[2].id1, Stek2[3].id1, Stek2[4].id1, Stek2[5].id1, Stek2[6].id1, Stek2[7].id1 = GetHeroCreaturesTypes(hero);
  for i = 1, 7 do
    if Stek2[i].id1 > 0 then
      for a = 1, length(arrayGradeDip1) do
        if Stek2[i].id1 == arrayGradeDip1[a] then
          if GetHeroCreatures(hero, arrayGradeDip2[a]) < GetHeroCreatures(hero, Stek2[i].id1) then
            Stek2[i].id2 = arrayGradeDip2[a];
          else
            Stek2[i].id2 = -1;
          end;
          a = length(arrayGradeDip1);
        end;
      end;
      if Stek2[i].id2 == 0 then
        for a = 1, length(arrayGradeDip2) do
          if Stek2[i].id1 == arrayGradeDip2[a] then
            if GetHeroCreatures(hero, arrayGradeDip1[a]) <= GetHeroCreatures(hero, Stek2[i].id1) then
              Stek2[i].id2 = arrayGradeDip1[a];
            else
              Stek2[i].id2 = -1;
            end;
            a = length(arrayGradeDip2);
          end;
        end;
      end;
    end;
  end;
  kol2 = 0;
  if HasArtefact( hero, 88, 1) then k2 = CrownOfLeaderBonus; else k2 = 1; end;
  if hero == "Rolf" or hero == "Rolf2" then k2 = 2; end;
  for i = 1, 7 do
    for j = 1, 8 do
      for k = 1, 21 do
        if Stek2[i].id1 == array_units[j][k].id and Stek2[i].id2 > 0 then
          Stek2[i].kol = int(k2 * DiplomacyCoef * kolUnit2[array_units[j][k].lvl]);
          AddObjectCreatures('Garrison4', Stek2[i].id2, Stek2[i].kol );
          k = 21;
          j = 8;
          kol2 = kol2 + 1;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison4');
  Stek2[1].id2, Stek2[2].id2, Stek2[3].id2, Stek2[4].id2, Stek2[5].id2, Stek2[6].id2, Stek2[7].id2 = GetObjectCreaturesTypes('Garrison4');
  for i = 1, 7 do
    if Stek2[i].id2 > 0 then
      Stek2[i].kol = GetObjectCreatures('Garrison4', Stek2[i].id2);
    end;
  end;
  x2, y2 = GetObjectPosition(hero);
  
  pause2 = 0;
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    sleep(2);
    startThread (Confirm2F);
  end;
  
  while kol2 > 0 and pause2 == 0 do
    for i = 1, 7 do
      if Stek2[i].id2 > 0 then
        if GetObjectCreatures('Garrison4', Stek2[i].id2) < Stek2[i].kol then
          for j = 1, 7 do
            if j ~= i then
              if Stek2[j].id2 > 0 then
                RemoveObjectCreatures('Garrison4', Stek2[j].id2, Stek2[j].kol);
              end;
            end;
          end;
          i = 7;
          kol2 = 0;
--          pause2 = 1;
        end;
      end;
    end;
    x2_actual, y2_actual = GetObjectPosition(hero);
    if x2_actual ~= x2 or y2_actual ~= y2 then kol1 = 0; end;
    sleep(1);
  end;
  DiplomacyEnable2 = 1;
  sleep(3);
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    NecroBonus2(hero);
  end;
end;

function Training1(hero)
  if GetHeroSkillMastery(hero, SKILL_TRAINING) == 4 then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES); end;
end;

function Training2(hero)
  if GetHeroSkillMastery(hero, SKILL_TRAINING) == 4 then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES); end;
end;

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

NavUse1 = 0;
NavUse2 = 0;

array_artNav = {}
array_artNav[1] = {'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10', 'a11', 'a12', 'a13', 'a14', 'a15', 'a16', 'a17', 'a18', 'a19'}
array_artNav[2] = {'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8', 'b9', 'b10', 'b11', 'b12', 'b13', 'b14', 'b15', 'b16', 'b17', 'b18', 'b19'}

function Navigation1()
  SetObjectPosition('red10', 5, 5, UNDERGROUND);
  sleep(1);
  MoveHeroRealTime(heroes1[0], 22, 79);
  for i = 1, length(array_artNav[1]) do
    Trigger (OBJECT_TOUCH_TRIGGER, array_artNav[1][i],   'NavigationUse1');
  end;
end;

function Navigation2()
  SetObjectPosition('blue10', 5, 6, UNDERGROUND);
  sleep(1);
  MoveHeroRealTime(heroes2[0], 42, 29);
  for i = 1, length(array_artNav[2]) do
    Trigger (OBJECT_TOUCH_TRIGGER, array_artNav[2][i],   'NavigationUse2');
  end;
end;

function NavigationUse1()
  for i = 1, length(array_artNav[1]) do
    if IsObjectExists(array_artNav[1][i]) == 1 then
      RemoveObject(array_artNav[1][i]);
    end;
  end;
  if HasHeroSkill(HeroMax1, 21) then transferArt (heroes1[0], HeroMax1); NavUse1 = 1; end
  SetObjectPosition(heroes1[0], 35, 85);
end;

function NavigationUse2()
  for i = 1, length(array_artNav[2]) do
    if IsObjectExists(array_artNav[2][i]) == 1 then
      RemoveObject(array_artNav[2][i]);
    end;
  end;
  if HasHeroSkill(HeroMax2, 21) then transferArt (heroes2[0], HeroMax2); NavUse2 = 1; end;
  SetObjectPosition(heroes2[0], 42, 24);
end;

ForestGuardUse1 = 0;
ForestGuardUse2 = 0;

function ForestGuard1(hero)
  if ForestGuardUse1 == 0 then
    if GetHeroCreatures(hero, 146) > 0 then
      RemoveHeroCreatures(hero, 146, 10);
      ForestGuardUse1 = 1;
    else
      if GetHeroCreatures(hero, 45) > 0 then
        RemoveHeroCreatures(hero, 45, 10);
        ForestGuardUse1 = 1;
      end;
    end;
  end;
end;

function ForestGuard2(hero)
  if ForestGuardUse2 == 0 then
    if GetHeroCreatures(hero, 146) > 0 then
      RemoveHeroCreatures(hero, 146, 10);
      ForestGuardUse2 = 1;
    else
      if GetHeroCreatures(hero, 45) > 0 then
        RemoveHeroCreatures(hero, 45, 10);
        ForestGuardUse2 = 1;
      end;
    end;
  end;
end;


DefendUsAllUse1 = 0;
DefendUsAllUse2 = 0;

function DefendUsAll1(hero)
  if DefendUsAllUse1 == 0 then
    if GetHeroCreatures(hero, 173) > 0 then
      RemoveHeroCreatures(hero, 173, 15);
      DefendUsAllUse1 = 1;
    else
      if GetHeroCreatures(hero, 117) > 0 then
        RemoveHeroCreatures(hero, 117, 15);
        DefendUsAllUse1 = 1;
      end;
    end;
  end;
end;


function DefendUsAll2(hero)
  if DefendUsAllUse2 == 0 then
    if GetHeroCreatures(hero, 173) > 0 then
      RemoveHeroCreatures(hero, 173, 15);
      DefendUsAllUse2 = 1;
    else
      if GetHeroCreatures(hero, 117) > 0 then
        RemoveHeroCreatures(hero, 117, 15);
        DefendUsAllUse2 = 1;
      end;
    end;
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

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and (hero == HeroMax1) and HasHeroSkill(hero, 20) then
    Scouting1Q();
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and (hero == HeroMax2) and HasHeroSkill(hero, 20) then
    Scouting2Q();
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and GetObjectOwner(hero) == 1 and HasHeroSkill(hero, 112) then
    Disguise1Q();
    DisguiseHero1 = hero;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and GetObjectOwner(hero) == 2 and HasHeroSkill(hero, 112) then
    Disguise2Q();
    DisguiseHero2 = hero;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax1) then
    SaleArmyQuestion(HeroMax1)
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax2) then
    SaleArmyQuestion(HeroMax2)
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax1) then
    startThread(FortunateAdventure1)
    --QuestionBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."FortunateAdventure.txt", 'FortunateAdventure1Ok', 'no');
    --SetObjectOwner('Dwel1', PLAYER_1);
    --startThread(HeraldFunction1);
    --MoveCameraForPlayers( 1, 89, 82, 0, 40, 0, 0, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel1');
    --HeraldUse1 = 1;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax2) then
    startThread(FortunateAdventure2)
    --SetObjectOwner('Dwel2', PLAYER_2);
    --startThread(HeraldFunction2);
    --MoveCameraForPlayers( 2, 81, 7, 0, 40, 0, 3.14, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel2');
    --HeraldUse2 = 1;
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


SnatchUse1 = 0;
SnatchUse2 = 0;

function Snatch_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax1) then
    if hero2race == 1 then MakeHeroInteractWithObject (hero, 'lavka16'); end;
    if hero2race == 2 then MakeHeroInteractWithObject (hero, 'lavka12'); end;
    if hero2race == 3 then MakeHeroInteractWithObject (hero, 'lavka13'); end;
    if hero2race == 4 then MakeHeroInteractWithObject (hero, 'lavka14'); end;
    if hero2race == 5 then MakeHeroInteractWithObject (hero, 'lavka9');  end;
    if hero2race == 6 then MakeHeroInteractWithObject (hero, 'lavka10'); end;
    if hero2race == 7 then MakeHeroInteractWithObject (hero, 'lavka11'); end;
    if hero2race == 8 then MakeHeroInteractWithObject (hero, 'lavka15'); end;
    if SnatchUse1 == 0 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 3000)); end;
    SnatchUse1 = 1;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax2) then
    if hero1race == 1 then MakeHeroInteractWithObject (hero, 'lavka7'); end;
    if hero1race == 2 then MakeHeroInteractWithObject (hero, 'lavka4'); end;
    if hero1race == 3 then MakeHeroInteractWithObject (hero, 'lavka5'); end;
    if hero1race == 4 then MakeHeroInteractWithObject (hero, 'lavka6'); end;
    if hero1race == 5 then MakeHeroInteractWithObject (hero, 'lavka1'); end;
    if hero1race == 6 then MakeHeroInteractWithObject (hero, 'lavka2'); end;
    if hero1race == 7 then MakeHeroInteractWithObject (hero, 'lavka3'); end;
    if hero1race == 8 then MakeHeroInteractWithObject (hero, 'lavka8'); end;
    if SnatchUse2 == 0 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 3000)); end;
    SnatchUse2 = 1;
  end;

end;

HeraldUse1 = 0;
HeraldUse2 = 0;

GlesUse1 = 0;
GlesUse2 = 0;

function Herald_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax1) then
    SetObjectOwner('Dwel1', PLAYER_1);
    startThread(HeraldFunction1);
    MoveCameraForPlayers( 1, 89, 82, 0, 20, 0, 0, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel1');
    --HeraldUse1 = 1;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax2) then
    SetObjectOwner('Dwel2', PLAYER_2);
    startThread(HeraldFunction2);
    MoveCameraForPlayers( 2, 81, 7, 0, 20, 0, 3.14, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel2');
    --HeraldUse2 = 1;
  end;

end;

function HeraldFunction1()
  SetObjectOwner('Dwel1', PLAYER_1);
  MoveCameraForPlayers( 1, 89, 82, 0, 20, 0, 0, 0, 0, 1);

  if (HasHeroSkill(HeroMax1, 102)) and HeraldUse1 == 0 then
    SetObjectDwellingCreatures('Dwel1',  90, 16);
  end;
  if (HeroMax1 == "Nikolas" or HeroMax1 == "Nikolas2") and GlesUse1 == 0 then
    SetObjectDwellingCreatures('Dwel1', 116, 40);
    GlesUse1 = 1;
  end;
  while HeraldUse1 ~= 2 do
    sleep(5);
    if GetObjectCreatures('Dwel1', 116) > 0 then
      AddObjectCreatures(HeroMax1, 116, GetObjectCreatures('Dwel1', 116));
      RemoveObjectCreatures('Dwel1', 116, GetObjectCreatures('Dwel1', 116));
    end;
    if GetObjectCreatures('Dwel1',  90) > 0 then
      AddObjectCreatures(HeroMax1,  90, GetObjectCreatures('Dwel1',  90));
      HeraldUse1 = 1;
      RemoveObjectCreatures('Dwel1',  90, GetObjectCreatures('Dwel1',  90));
    end;
  end;
end;

function HeraldFunction2()
  SetObjectOwner('Dwel2', PLAYER_2);
  MoveCameraForPlayers( 2, 81, 7, 0, 40, 0, 3.14, 0, 0, 1);

  if (HasHeroSkill(HeroMax2, 102)) and HeraldUse2 == 0 then
    SetObjectDwellingCreatures('Dwel2',  90, 16);
  end;
  if (HeroMax2 == "Nikolas" or HeroMax2 == "Nikolas2") and GlesUse2 == 0 then
    SetObjectDwellingCreatures('Dwel2', 116, 40);
    GlesUse2 = 1;
  end;
  while HeraldUse2 ~= 2 do
    sleep(5);
    if GetObjectCreatures('Dwel2', 116) > 0 then
      AddObjectCreatures(HeroMax2, 116, GetObjectCreatures('Dwel2', 116));
      RemoveObjectCreatures('Dwel2', 116, GetObjectCreatures('Dwel2', 116));
    end;
    if GetObjectCreatures('Dwel2',  90) > 0 then
      AddObjectCreatures(HeroMax2,  90, GetObjectCreatures('Dwel2',  90));
      HeraldUse2 = 1;
      RemoveObjectCreatures('Dwel2',  90, GetObjectCreatures('Dwel2',  90));
    end;
  end;
end;

SetObjectDwellingCreatures('Dwel1', 116, 0);
SetObjectDwellingCreatures('Dwel1',  90, 0);

SetObjectDwellingCreatures('Dwel2', 116, 0);
SetObjectDwellingCreatures('Dwel2',  90, 0);


GoblinSupportEnable1 = 0;
GoblinSupportEnable2 = 0;

function GoblinSupport1(hero)
  if GoblinSupportEnable1 == 0 then
    AddHeroCreatures(hero, 118, 50);
    GiveHeroWarMachine(hero, WAR_MACHINE_BALLISTA);
    GiveHeroWarMachine(hero, WAR_MACHINE_FIRST_AID_TENT);
    GiveHeroWarMachine(hero, WAR_MACHINE_AMMO_CART);
  end;
  GoblinSupportEnable1 = 1;
end;

function GoblinSupport2(hero)
  if GoblinSupportEnable2 == 0 then
    AddHeroCreatures(hero, 118, 50);
    GiveHeroWarMachine(hero, WAR_MACHINE_BALLISTA);
    GiveHeroWarMachine(hero, WAR_MACHINE_FIRST_AID_TENT);
    GiveHeroWarMachine(hero, WAR_MACHINE_AMMO_CART);
  end;
  GoblinSupportEnable2 = 1;
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


LogisticsEnable1 = 0;
LogisticsEnable2 = 0;
LogisticsNoMoney1 = 0;
LogisticsNoMoney2 = 0;


function Logistics1(hero)
  if hero == HeroMax1 and StLvlUp1 == 1 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + LogisticsSum));
    LogisticsEnable1 = 1;
  end;
end;

function Logistics2(hero)
  if hero == HeroMax2 and StLvlUp2 == 1 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + LogisticsSum));
    LogisticsEnable2 = 1;
  end;
end;

function DelLogistics1(hero)
  if GetPlayerResource (PLAYER_1, GOLD) >= LogisticsSum then
    if GetHeroLevel(hero) > 1 then
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - LogisticsSum));
    end;
    LogisticsNoMoney1 = 0;
  else
    LogisticsNoMoney1 = 1;
  end;
  LogisticsEnable1 = 1;
end;

function DelLogistics2(hero)
  if GetPlayerResource (PLAYER_2, GOLD) >= LogisticsSum then
    if GetHeroLevel(hero) > 1 then
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - LogisticsSum));
    end;
    LogisticsNoMoney2 = 0;
  else
    LogisticsNoMoney2 = 1;
  end;
  LogisticsEnable2 = 1;
end;

LearningEnable1 = 0;
LearningEnable2 = 0;


function DelLearning1(hero)
  if (GetHeroSkillMastery(hero, 3) == 2 or GetHeroSkillMastery(hero, 183) == 2) or (GetHeroSkillMastery(hero, 3) == 0 or GetHeroSkillMastery(hero, 183) == 0) then
    race = getrace(hero);
    rnd = random(100);
    if rnd <= PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
    end;
    if rnd > PercentA[race] and rnd <= (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race]) and rnd <= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
    end;
    LearningEnable1 = LearningEnable1 - 1;
  end;
end;

function DelLearning2(hero)
  if (GetHeroSkillMastery(hero, 3) == 2 or GetHeroSkillMastery(hero, 183) == 2) or (GetHeroSkillMastery(hero, 3) == 0 or GetHeroSkillMastery(hero, 183) == 0) then
    race = getrace(hero);
    rnd = random(100);
    if rnd <= PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
    end;
    if rnd > PercentA[race] and rnd <= (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race]) and rnd <= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
    end;
    LearningEnable2 = LearningEnable2 - 1;
  end;
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



function DublikatHero1(hero1)
--  print('steel1');
  j = 1;
  for i = 1, 26 do
    array_skills_Hero1[i] = GetHeroSkillMastery(hero1, array_skills[i]);
  end;

  for i = 1, 189 do
    if HasHeroSkill(hero1, array_perks[i]) then
      array_perks_Hero1[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero1 = j;
    end;
  end;

  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(hero1, array_arts[i][j].id, 0) then
        array_arts_Hero1[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(hero1, array_arts[i][j].id, 1) then
        array_arts_Hero1[k - 1].Eq = 1;
        RemoveArtefact(hero1, array_arts[i][j].id);
      end;
    end;
  end;

  j = 1;
  for i = 1, 179 do
    if GetHeroCreatures( hero1, i) > 0 then
      array_army_Hero1[j].ID  = i;
      array_army_Hero1[j].kol = GetHeroCreatures( hero1, i);
      j = j + 1;
    end;
  end;

  j = 1;
  for i = 1, 4 do
    if HasHeroWarMachine(hero1, i) and i ~= 2 then
      array_machine_Hero1[j]  = i;
      j = j + 1;
    end;
  end;
  
  expHero1 = GetHeroStat(hero1, STAT_EXPERIENCE);
  attHero1 = GetHeroStat(hero1, STAT_ATTACK);
  defHero1 = GetHeroStat(hero1, STAT_DEFENCE);
  spHero1  = GetHeroStat(hero1, STAT_SPELL_POWER);
  knHero1  = GetHeroStat(hero1, STAT_KNOWLEDGE);

  x, y = GetObjectPosition(hero1);
  RemoveObject(hero1);
  
  for i = 0, 7 do
    for j = 1, length(dublikat_heroes[i]) do
      if (hero1 == dublikat_heroes[i][j].name or hero1 == dublikat_heroes[i][j].name2) then
        HeroMax1 = dublikat_heroes[i][j].name3;
      end;
    end;
  end;

  DeployReserveHero(HeroMax1, x, y, 0);
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no');
  WarpHeroExp(HeroMax1, expHero1);
  for i = 1, 26 do
    for j = 1, array_skills_Hero1[i] do
      if array_skills_Hero1[i] >= j then
        if GetHeroSkillMastery(HeroMax1, array_skills[i]) < array_skills_Hero1[i] then
          GiveHeroSkill(HeroMax1, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero1 do
    GiveHeroSkill(HeroMax1, array_perks_Hero1[i]);
  end;

  k = 0;
  for i = 1, 189 do
    if HasHeroSkill( HeroMax1, array_perks[i]) then
      k = k + 1;
    end;
  end;
  while k < kol_perks_Hero1 do
    for i = 1, kol_perks_Hero1 do
      if HasHeroSkill( HeroMax1, array_perks_Hero1[i]) == nil then
        GiveHeroSkill(HeroMax1, array_perks_Hero1[i]);
        k = k + 1;
        if array_perks_Hero1[i] == 115 and GetHeroCreatures(HeroMax1, 146) > 0 then RemoveHeroCreatures(HeroMax1, 146, 10); end;
        if array_perks_Hero1[i] == 181 and GetHeroCreatures(HeroMax1, 173) > 0 then RemoveHeroCreatures(HeroMax1, 173, 15); end;
      end;
    end;
  end;


  for i = 1, length(array_army_Hero1) do
    if array_army_Hero1[i].ID ~= 0 then
      AddHeroCreatures(HeroMax1, array_army_Hero1[i].ID, array_army_Hero1[i].kol);
      if GetHeroCreatures(HeroMax1, 88) > 0 then kolCreatures1 = GetHeroCreatures(HeroMax1, 88); RemoveHeroCreatures(HeroMax1, 88, kolCreatures1); end;
    end;
  end;

--  print('ttt');

  for i = 1, length(array_machine_Hero1) do
    if array_machine_Hero1[i] ~= 0 then
      GiveHeroWarMachine(HeroMax1, array_machine_Hero1[i]);
    end;
  end;
  
--  print('1');

  if StartBonus[1] == 'spell' then
    TeachHeroSpell(HeroMax1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
    TeachHeroSpell(HeroMax1, array_spells[BonusSpells[0].m2][BonusSpells[0].sp2].id );
  end;
  
--  print('2');

  attHero1 = attHero1 - GetHeroStat(HeroMax1, STAT_ATTACK); --print(attHero2);
  defHero1 = defHero1 - GetHeroStat(HeroMax1, STAT_DEFENCE); --print(defHero2);
  spHero1  = spHero1  - GetHeroStat(HeroMax1, STAT_SPELL_POWER); --print(spHero2);
  knHero1  = knHero1  - GetHeroStat(HeroMax1, STAT_KNOWLEDGE); --print(knHero2);

  if attHero1 > 0 then ChangeHeroStat(HeroMax1, STAT_ATTACK,      attHero1); end;
  if defHero1 > 0 then ChangeHeroStat(HeroMax1, STAT_DEFENCE,     defHero1); end;
  if spHero1  > 0 then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER,  spHero1); end;
  if knHero1  > 0 then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE,    knHero1); end;
  
  for i = 1, length(array_arts_Hero1) do
    if array_arts_Hero1[i].ID ~= 0 and array_arts_Hero1[i].Eq == 1 then
      GiveArtefact(HeroMax1, array_arts_Hero1[i].ID);
    end;
  end;
  
  if Name(HeroMax1) == "Una" then
    for i = 1, 10 do
      if array_FreeRunes[i] == 2 then
        TeachHeroSpell(HeroMax1, array_spells[4][i].id);
      end;
    end;
  end;

--  print('3');

  array_skills_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_perks_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_arts_Hero1 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}
  array_army_Hero1 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};
  array_machine_Hero1 = { 0, 0, 0}
end;

function DublikatHero2(hero2)
  j = 1;
  for i = 1, 26 do
    array_skills_Hero2[i] = GetHeroSkillMastery(hero2, array_skills[i]);
  end;

  for i = 1, 189 do
    if HasHeroSkill(hero2, array_perks[i]) then
      array_perks_Hero2[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero2 = j;
    end;
  end;

  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(hero2, array_arts[i][j].id, 0) then
        array_arts_Hero2[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(hero2, array_arts[i][j].id, 1) then
        array_arts_Hero2[k - 1].Eq = 1;
        RemoveArtefact(hero2, array_arts[i][j].id);
      end;
    end;
  end;

  j = 1;
  for i = 1, 179 do
    if GetHeroCreatures( hero2, i) > 0 then
      array_army_Hero2[j].ID  = i;
      array_army_Hero2[j].kol = GetHeroCreatures( hero2, i);
      j = j + 1;
    end;
  end;

  j = 1;
  for i = 1, 4 do
    if HasHeroWarMachine(hero2, i) and i ~= 2 then
      array_machine_Hero2[j]  = i;
      j = j + 1;
    end;
  end;
  
  expHero2 = GetHeroStat(hero2, STAT_EXPERIENCE);
  attHero2 = GetHeroStat(hero2, STAT_ATTACK);
  defHero2 = GetHeroStat(hero2, STAT_DEFENCE);
  spHero2  = GetHeroStat(hero2, STAT_SPELL_POWER);
  knHero2  = GetHeroStat(hero2, STAT_KNOWLEDGE);

  x, y = GetObjectPosition(hero2);
  RemoveObject(hero2);

  for i = 0, 7 do
    for j = 1, length(dublikat_heroes[i]) do
      if (hero2 == dublikat_heroes[i][j].name or hero2 == dublikat_heroes[i][j].name2) then
        HeroMax2 = dublikat_heroes[i][j].name4;
      end;
    end;
  end;

  DeployReserveHero(HeroMax2, x, y, 0);
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no');
  WarpHeroExp(HeroMax2, expHero2);
  for i = 1, 26 do
    for j = 1, array_skills_Hero2[i] do
      if array_skills_Hero2[i] >= j then
        if GetHeroSkillMastery(HeroMax2, array_skills[i]) < array_skills_Hero2[i] then
          GiveHeroSkill(HeroMax2, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero2 do
    GiveHeroSkill(HeroMax2, array_perks_Hero2[i]);
  end;
  
  k = 0;
  for i = 1, 189 do
    if HasHeroSkill( HeroMax2, array_perks[i]) then
      k = k + 1;
    end;
  end;
  while k < kol_perks_Hero2 do
    for i = 1, kol_perks_Hero2 do
      if HasHeroSkill( HeroMax2, array_perks_Hero2[i]) == nil then
        GiveHeroSkill(HeroMax2, array_perks_Hero2[i]);
        k = k + 1;
        if array_perks_Hero2[i] == 115 and GetHeroCreatures(HeroMax2, 146) > 0 then RemoveHeroCreatures(HeroMax2, 146, 10); end;
        if array_perks_Hero2[i] == 181 and GetHeroCreatures(HeroMax2, 173) > 0 then RemoveHeroCreatures(HeroMax2, 173, 15); end;
      end;
    end;
  end;

  for i = 1, length(array_army_Hero2) do
    if array_army_Hero2[i].ID ~= 0 then
      AddHeroCreatures(HeroMax2, array_army_Hero2[i].ID, array_army_Hero2[i].kol);
      if GetHeroCreatures(HeroMax2, 88) > 0 then kolCreatures2 = GetHeroCreatures(HeroMax2, 88); RemoveHeroCreatures(HeroMax2, 88, kolCreatures2); end;
    end;
  end;

--  print('ttt');

  for i = 1, length(array_machine_Hero2) do
    if array_machine_Hero2[i] ~= 0 then
      GiveHeroWarMachine(HeroMax2, array_machine_Hero2[i]);
    end;
  end;
  
--  print('1');

  if StartBonus[2] == 'spell' then
    TeachHeroSpell(HeroMax2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
    TeachHeroSpell(HeroMax2, array_spells[BonusSpells[1].m2][BonusSpells[1].sp2].id );
  end;
  
--  print('2');
  
  sleep(1);
  
--  print(GetHeroStat(HeroMax2, STAT_ATTACK));
--  print(GetHeroStat(HeroMax2, STAT_DEFENCE))
--  print(GetHeroStat(HeroMax2, STAT_SPELL_POWER))
--  print(GetHeroStat(HeroMax2, STAT_KNOWLEDGE))

  attHero2 = attHero2 - GetHeroStat(HeroMax2, STAT_ATTACK); --print(attHero2);
  defHero2 = defHero2 - GetHeroStat(HeroMax2, STAT_DEFENCE); --print(defHero2);
  spHero2  = spHero2  - GetHeroStat(HeroMax2, STAT_SPELL_POWER); --print(spHero2);
  knHero2  = knHero2  - GetHeroStat(HeroMax2, STAT_KNOWLEDGE); --print(knHero2);

  if attHero2 > 0 then ChangeHeroStat(HeroMax2, STAT_ATTACK,      attHero2); end;
  if defHero2 > 0 then ChangeHeroStat(HeroMax2, STAT_DEFENCE,     defHero2); end;
  if spHero2  > 0 then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER,  spHero2); end;
  if knHero2  > 0 then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE,    knHero2); end;
  
  for i = 1, length(array_arts_Hero2) do
    if array_arts_Hero2[i].ID ~= 0 and array_arts_Hero2[i].Eq == 1 then
      GiveArtefact(HeroMax2, array_arts_Hero2[i].ID);
    end;
  end;
  
  if Name(HeroMax2) == "Una" then
    for i = 1, 10 do
      if array_FreeRunes[i] == 2 then
        TeachHeroSpell(HeroMax2, array_spells[4][i].id);
      end;
    end;
  end;
  
  sleep(2);
  
--  print('3');

  array_skills_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_perks_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_arts_Hero2 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}
  array_army_Hero2 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};
  array_machine_Hero2 = { 0, 0, 0}
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


--Pokupka statov

stat1 = 0;
stat2 = 0;
statA1 = 0;
statD1 = 0;
statS1 = 0;
statK1 = 0;
statA2 = 0;
statD2 = 0;
statS2 = 0;
statK2 = 0;

        --Igrok 1
function napPlus1(hero)
  SetObjectEnabled('napadenie1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'napadenie1'); else MakeHeroInteractWithObject (hero_1, 'dolm1'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie1', 'nap1' );
  SetObjectEnabled('napadenie1', nil);
--  ChangeHeroStat(hero_1, 1, 1);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."nap_plus1.txt", 'napadenie1', 1, 2.0);
  stat1 = stat1 + 1;
  statA1 = statA1 + 1;
  if stat1 < 2 then SetObjectEnabled('napadenie1', nil); end;
end;

function nap1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."napadeniePlus1.txt", 'napPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function defPlus1(hero)
  SetObjectEnabled('zashchita1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'zashchita1'); else MakeHeroInteractWithObject (hero_1, 'dolm2'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita1', 'def1' );
  SetObjectEnabled('zashchita1', nil);
--  ChangeHeroStat(hero_1, 2, 1);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."def_plus1.txt", 'zashchita1', 1, 2.0);
  stat1 = stat1 + 1;
  statD1 = statD1 + 1;
  if stat1 < 2 then SetObjectEnabled('zashchita1', nil); end;
end;

function def1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."zashchitaPlus1.txt", 'defPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function koldPlus1(hero)
  SetObjectEnabled('koldovstvo1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'koldovstvo1'); else MakeHeroInteractWithObject (hero_1, 'dolm3'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo1', 'kold1' );
  SetObjectEnabled('koldovstvo1', nil);
--  ChangeHeroStat(hero_1, 3, 1);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."kold_plus1.txt", 'koldovstvo1', 1, 2.0);
  stat1 = stat1 + 1;
  statS1 = statS1 + 1;
  if stat1 < 2 then SetObjectEnabled('koldovstvo1', nil); end;
end;

function kold1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."koldovstvoPlus1.txt", 'koldPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function znPlus1(hero)
  SetObjectEnabled('znanie1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'znanie1'); else MakeHeroInteractWithObject (hero_1, 'dolm4'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie1', 'zn1' );
  SetObjectEnabled('znanie1', nil);
--  ChangeHeroStat(hero_1, 4, 1);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."zn_plus1.txt", 'znanie1', 1, 2.0);
  stat1 = stat1 + 1;
  statK1 = statK1 + 1;
  if stat1 < 2 then SetObjectEnabled('znanie1', nil); end;
end;

function zn1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."znaniePlus1.txt", 'znPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

        --Igrok 2

function napPlus2(hero)
  SetObjectEnabled('napadenie2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'napadenie2'); else MakeHeroInteractWithObject (hero_2, 'dolm1'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie2', 'nap2' );
  SetObjectEnabled('napadenie2', nil);
--  ChangeHeroStat(hero_2, 1, 1);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."nap_plus1.txt", 'napadenie2', 2, 2.0);
  stat2 = stat2 + 1;
  statA2 = statA2 + 1;
  if stat2 < 2 then SetObjectEnabled('napadenie2', nil); end;
end;

function nap2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."napadeniePlus1.txt", 'napPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function defPlus2(hero)
  SetObjectEnabled('zashchita2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'zashchita2'); else MakeHeroInteractWithObject (hero_2, 'dolm2'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita2', 'def2' );
  SetObjectEnabled('zashchita2', nil);
--  ChangeHeroStat(hero_2, 2, 1);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."def_plus1.txt", 'zashchita2', 2, 2.0);
  stat2 = stat2 + 1;
  statD2 = statD2 + 1;
  if stat2 < 2 then SetObjectEnabled('zashchita2', nil); end;
end;

function def2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."zashchitaPlus1.txt", 'defPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function koldPlus2(hero)
  SetObjectEnabled('koldovstvo2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'koldovstvo2'); else MakeHeroInteractWithObject (hero_2, 'dolm3'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo2', 'kold2' );
  SetObjectEnabled('koldovstvo2', nil);
--  ChangeHeroStat(hero_2, 3, 1);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."kold_plus1.txt", 'koldovstvo2', 2, 2.0);
  stat2 = stat2 + 1;
  statS2 = statS2 + 1;
  if stat2 < 2 then SetObjectEnabled('koldovstvo2', nil); end;
end;

function kold2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."koldovstvoPlus1.txt", 'koldPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function znPlus2(hero)
  SetObjectEnabled('znanie2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'znanie2'); else MakeHeroInteractWithObject (hero_2, 'dolm4'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie2', 'zn2' );
  SetObjectEnabled('znanie2', nil);
--  ChangeHeroStat(hero_2, 4, 1);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
--  ShowFlyingSign(GetMapDataPath().."zn_plus1.txt", 'znanie2', 2, 2.0);
  stat2 = stat2 + 1;
  statK2 = statK2 + 1;
  if stat2 < 2 then SetObjectEnabled('znanie2', nil); end;
end;

function zn2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."znaniePlus1.txt", 'znPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function BoatMove(hero)
  sleep(2);
  MoveHeroRealTime(hero, 9, 19);
end;

TeleportUse1 = 0;
TeleportUse2 = 0;


function TeleportBattleZone1()
  SetObjectPosition (HeroMax1, TELEPORT_BATTLE_ZONE_PLAYER_1_X, TELEPORT_BATTLE_ZONE_PLAYER_1_Y);
  OpenCircleFog( 48, 45, 0, 15, 1 );
  sleep(7);
  stop(HeroMax1);
  TeleportUse1 = 1;
  ShowFlyingSign(GetMapDataPath().."Wait.txt", HeroMax1, 1, 5.0);
end;

function TeleportBattleZone2()
  SetObjectPosition (HeroMax2, TELEPORT_BATTLE_ZONE_PLAYER_2_X, TELEPORT_BATTLE_ZONE_PLAYER_2_Y);
  OpenCircleFog( 48, 45, 0, 15, 2 );
  TeleportUse2 = 1;
end;

function AutoTeleportBattleZone1()
  while TeleportUse1 == 0 do
    if IsPlayerWaitingForTurn(PLAYER_1) then
      TeleportBattleZone1();
    end;
    sleep(20);
  end;
end;

function AutoTeleportBattleZone2()
  while TeleportUse2 == 0 do
    if IsPlayerWaitingForTurn(PLAYER_2) then
      TeleportBattleZone2();
    end;
    sleep(20);
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
--    if i1 == 3 then Load('AutoSave'); sleep(10); end;
    Save(GetMapDataPath().."AutoSave");
--    Save('AutoSave');
  end;
end;


SetObjectEnabled('napadenie1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie1', 'nap1' );

SetObjectEnabled('zashchita1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita1', 'def1' );

SetObjectEnabled('koldovstvo1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo1', 'kold1' );

SetObjectEnabled('znanie1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'znanie1', 'zn1' );

SetObjectEnabled('napadenie2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie2', 'nap2' );

SetObjectEnabled('zashchita2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita2', 'def2' );

SetObjectEnabled('koldovstvo2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo2', 'kold2' );

SetObjectEnabled('znanie2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'znanie2', 'zn2' );

Trigger( OBJECT_TOUCH_TRIGGER, 'port1', 'TeleportStartZone1' ); SetObjectEnabled('port1', nil); SetDisabledObjectMode('port1', 2);
Trigger( OBJECT_TOUCH_TRIGGER, 'port2', 'TeleportStartZone2' ); SetObjectEnabled('port2', nil); SetDisabledObjectMode('port2', 2);

--SetObjectEnabled ('whirlpool1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'boat4', 'BoatMove' );


-- Opisaniya

SetObjectEnabled('bonus1', nil);

SetObjectEnabled('bonus2', nil);

OverrideObjectTooltipNameAndDescription ('port1', GetMapDataPath().."portNAME.txt", GetMapDataPath().."portDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('port2', GetMapDataPath().."portNAME.txt", GetMapDataPath().."portDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('stat1', GetMapDataPath().."regenStatNAME.txt", GetMapDataPath().."regenStatDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('stat2', GetMapDataPath().."regenStatNAME.txt", GetMapDataPath().."regenStatDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('skill1', GetMapDataPath().."buyskillNAME.txt", GetMapDataPath().."buyskillDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('skill2', GetMapDataPath().."buyskillNAME.txt", GetMapDataPath().."buyskillDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('derevo', GetMapDataPath().."derevoNAME.txt", GetMapDataPath().."derevoDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('higina', GetMapDataPath().."higinaNAME.txt", GetMapDataPath().."higinaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('arena', GetMapDataPath().."arenaNAME.txt", GetMapDataPath().."arenaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('hram', GetMapDataPath().."hramNAME.txt", GetMapDataPath().."hramDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('rune', GetMapDataPath().."runeNAME.txt", GetMapDataPath().."runeDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('gorgul', GetMapDataPath().."gorgulNAME.txt", GetMapDataPath().."gorgulDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('heops', GetMapDataPath().."heopsNAME.txt", GetMapDataPath().."heopsDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('treasure', GetMapDataPath().."treasureNAME.txt", GetMapDataPath().."treasureDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('gertva', GetMapDataPath().."gertvaNAME.txt", GetMapDataPath().."gertvaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('magiya', GetMapDataPath().."arenaNAME.txt", GetMapDataPath().."arenaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('utopa', GetMapDataPath().."utopaNAME.txt", GetMapDataPath().."utopaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('obelisk', GetMapDataPath().."obeliskNAME.txt", GetMapDataPath().."obeliskDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('academy', GetMapDataPath().."academyNAME.txt", GetMapDataPath().."academyDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('gizn', GetMapDataPath().."giznNAME.txt", GetMapDataPath().."giznDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('sklep', GetMapDataPath().."sklepNAME.txt", GetMapDataPath().."sklepDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mogila', GetMapDataPath().."mogilaNAME.txt", GetMapDataPath().."mogilaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('oko1', GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
OverrideObjectTooltipNameAndDescription ('oko2', GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
--OverrideObjectTooltipNameAndDescription ('magehelp1', GetMapDataPath().."magehelp1NAME.txt", GetMapDataPath().."magehelp1DSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('magehelp2', GetMapDataPath().."magehelp2NAME.txt", GetMapDataPath().."magehelp2DSCRP.txt");
OverrideObjectTooltipNameAndDescription ('napadenie1', GetMapDataPath().."napadenieNAME.txt", GetMapDataPath().."NapadeniePlus1.txt");
OverrideObjectTooltipNameAndDescription ('zashchita1', GetMapDataPath().."zashchitaNAME.txt", GetMapDataPath().."zashchitaPlus1.txt");
OverrideObjectTooltipNameAndDescription ('koldovstvo1', GetMapDataPath().."koldovstvoNAME.txt", GetMapDataPath().."koldovstvoPlus1.txt");
OverrideObjectTooltipNameAndDescription ('znanie1', GetMapDataPath().."znanieNAME.txt", GetMapDataPath().."znaniePlus1.txt");
OverrideObjectTooltipNameAndDescription ('napadenie2', GetMapDataPath().."napadenieNAME.txt", GetMapDataPath().."NapadeniePlus1.txt");
OverrideObjectTooltipNameAndDescription ('zashchita2', GetMapDataPath().."zashchitaNAME.txt", GetMapDataPath().."zashchitaPlus1.txt");
OverrideObjectTooltipNameAndDescription ('koldovstvo2', GetMapDataPath().."koldovstvoNAME.txt", GetMapDataPath().."koldovstvoPlus1.txt");
OverrideObjectTooltipNameAndDescription ('znanie2', GetMapDataPath().."znanieNAME.txt", GetMapDataPath().."znaniePlus1.txt");
--OverrideObjectTooltipNameAndDescription ('loga1', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga2', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga3', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga4', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga5', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga6', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga7', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga8', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga9', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga10', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga11', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga12', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga13', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga14', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga15', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga16', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga17', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('loga18', GetMapDataPath().."logaNAME.txt", GetMapDataPath().."logaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mumiya', GetMapDataPath().."mumiya.txt", GetMapDataPath().."mumiyaDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('spell_nabor1', GetMapDataPath().."SpellNaborNAME.txt", GetMapDataPath().."SpellNaborDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('spell_nabor2', GetMapDataPath().."SpellNaborNAME.txt", GetMapDataPath().."SpellNaborDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('spell_nabor3', GetMapDataPath().."SpellNaborNAME.txt", GetMapDataPath().."SpellNaborDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('spell_nabor4', GetMapDataPath().."SpellNaborNAME.txt", GetMapDataPath().."SpellNaborDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor11', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor12', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor13', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor14', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor15', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor16', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor17', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor18', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor21', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor22', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor23', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor24', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor25', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor26', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor27', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mentor28', GetMapDataPath().."mentorNAME.txt", GetMapDataPath().."mentorDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('bandit_map', GetMapDataPath().."banditNAME.txt", GetMapDataPath().."bandit_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mostovik_map', GetMapDataPath().."mostovikNAME.txt", GetMapDataPath().."mostovik_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('vsev_map', GetMapDataPath().."vsevNAME.txt", GetMapDataPath().."vsev_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('tari_map', GetMapDataPath().."tariNAME.txt", GetMapDataPath().."tari_mapDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('bandit', GetMapDataPath().."banditNAME.txt", GetMapDataPath().."banditDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('zilo', GetMapDataPath().."ziloNAME.txt", GetMapDataPath().."ziloDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('hustred', GetMapDataPath().."hustredNAME.txt", GetMapDataPath().."hustredDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('valery', GetMapDataPath().."valeryNAME.txt", GetMapDataPath().."valeryDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('kartofun', GetMapDataPath().."kartofunNAME.txt", GetMapDataPath().."kartofunDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('lionup', GetMapDataPath().."lionupNAME.txt", GetMapDataPath().."lionupDSCRP.txt");
--OverrideObjectTooltipNameAndDescription ('champion', GetMapDataPath().."championNAME.txt", GetMapDataPath().."championDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('bonus1', GetMapDataPath().."bonusNAME.txt", GetMapDataPath().."bon.txt");
OverrideObjectTooltipNameAndDescription ('bonus2', GetMapDataPath().."bonusNAME.txt", GetMapDataPath().."bon.txt");

--startThread (SilaStihii1(HeroDop1));


--sleep(50)
--InitCombatExecThread(heroes1[1])
--sleep(5)
--SaveHeroesInfoBeforeCombat{heroes1[1], heroes2[1]}
--sleep(5)

--startThread(RTA_CommonSetCombatScriptThread)

--MakeHeroInteractWithObject (heroes1[1], heroes2[1])

--skill31hero1 = 1;

--sleep(10)

--SetGameVar("skill31hero1", "4")