--
-- Author: Albus
-- Date: 2015-10-10 15:00:01
-- Filename: stat.lua
--
local string = string
local global = require "global"
-- local i18n = global.i18n
local const = assert(global.const)
local handler = assert(global.handler)
-- local msg_helper = require("app.ac.msg_helper")
-- local KNMsg = assert(global.KNMsg)
local log = assert(global.log)
local tonumber=tonumber
-- local display = assert(global.display)
local player = assert(global.player)
-- local dataeye_mgr = global.dataeye_mgr


local M = {}
function M:register()
	-- global.network:nw_register("SC_TIME_EVENT", self._time_event)
	global.network:nw_register("SC_UpdateKeys", self.SC_UpdateKeys)
	-- global.network:nw_register("SC_ARTIFACT_BASE", self._artifact_base)

	-- global.network:nw_register("SC_OPEN_SYSTEM", self.SC_OPEN_SYSTEM)

	--活动
	-- global.network:nw_register("SC_FLUSHACTIVITY", self.SC_FLUSHACTIVITY)
	--服务端通知客户端事件
	global.network:nw_register("SC_NOTIFY", self.SC_NOTIFY)

	global.network:nw_register("SC_NOTIFYCHARGERESP", self.SC_NOTIFYCHARGERESP)
end
------------------------------------------------
-- 定点刷新时间事件
function M._time_event(req)
	local time = req.time
	player:get_mgr("artifact"):time_event(time)
	--竞技场
	player:get_mgr("athletic"):on_time_event(time)
end
------------------------------------------------
local function show_reward_effect(id, is_show, old, new)
	-- print("···",id, is_show, old, new)
	old = old or 0
	local quant = new-old
	if 0 >= quant  or not is_show then
		return
	end
	-- print("···",id, is_show, old, new, quant)
	-- return global.ui_facade:uf_show_reward_effect(id, quant)
end
--提示
local function show(is_show,old,new,str)
	if not is_show then
		return
	end

	local add = new - old
	if add > 0 then
		return KNMsg:scene_msg(str,add)
	end
end
--玩家属性变动提示处理
local KEY_EVENT = {}
function KEY_EVENT.money(is_show, old, new)
	show_reward_effect(const.ITEM_MONEY, is_show, old, new)
	-- 更新主场景建筑
	-- msg_helper:sendmsg_to_scene(msg_helper.MSGID_TOSCENE_BUILD_UPDATE)
end
function KEY_EVENT.RMB( is_show, old, new )
	show_reward_effect(const.ITEM_RMB, is_show, old, new)
end
function KEY_EVENT.wood( is_show, old, new )
	show_reward_effect(const.ITEM_WOOD, is_show, old, new)
end
function KEY_EVENT.stone( is_show, old, new )
	show_reward_effect(const.ITEM_STONE, is_show, old, new)
end
function KEY_EVENT.exploit(is_show, old, new)
	show_reward_effect(const.ITEM_EXPLOIT,is_show, old, new)
end
function KEY_EVENT.vigour(is_show, old, new)
	show_reward_effect(const.ITEM_JUNLING,is_show, old, new)
end
function KEY_EVENT.honor(is_show, old, new)
	show_reward_effect(const.ITEM_HONOR,is_show, old, new)
end
function KEY_EVENT.popularity( is_show, old, new )
	show(is_show, old, new,i18n.TEXT_MINXIN.." #G+%d")
end
function KEY_EVENT.levy_count( is_show, old, new )
	show(is_show, old, new, i18n.TEXT_LEVY_COUNT.." #G+%d")
	-- 更新主场景建筑
 	msg_helper:sendmsg_to_scene(msg_helper.MSGID_TOSCENE_BUILD_UPDATE)
end
function KEY_EVENT.level()
	-- 更新主场景建筑等级
	msg_helper:sendmsg_to_scene(msg_helper.MSGID_TOSCENE_BUILD_UPDATE)

	player:get_mgr("stage"):update_mark()
end
function KEY_EVENT.battle_value(is_show, old, new)
	if old ~= new then
		msg_helper:sendmsg_to_ui("UIMainMenuTL", msg_helper.MSGID_TOUI_FLUSH_BATTLE_VALUE,{old = old,new = new})
	end
end

function M.SC_UpdateKeys(req)
	local is_show
	-- local run_scene = display.getRunningScene()
	-- if run_scene and run_scene.name == "home_scene" then
	-- 	-- 界面打开中不显示提示
	-- 	local f= run_scene.UIlayer
	-- 	if not ( f:getUI("UIBattleReady")
	-- 		or f:getUI("UIHeroStageResult")
	-- 		or f:getUI("UIMineral")
	-- 		or f:getUI("UIWatch")
	-- 		or f:getUI("UIDraw")
	-- 		or f:getUI("UIBattleResult")) then
	-- 		is_show = true
	-- 	end
	-- end

	-- print("SC_UpdateKeys",req.hero_dataId)
	-- if req.hero_dataId > 0 then
	-- 	local hero = player:get_mgr("hero"):get_hero(req.hero_dataId)

	-- 	local t={}
	-- 	for i,v in ipairs(req.kvs) do
	-- 		local old = hero:get(v.key)
	-- 		if old ~= v.value then
	-- 			hero:setkey(v.key,v.value)
	-- 		end

	-- 		if is_show then
	-- 			if v.key == "exp" then
	-- 				t[#t+1] = {i18n.TEXT_EXP.." #G+%d",v.param1}
	-- 			elseif v.key == "level" then
	-- 				t[#t+1] = {i18n.TEXT_HERO_LEVEL_UP..": #G%d",v.value}
	-- 				msg_helper:sendmsg_to_ui("UIHero",msg_helper.MSGID_TOUI_UP_HERO,{heroid = req.hero_dataId})
	-- 			end
	-- 		end
	-- 	end
	-- 	if #t > 0 then
	-- 		local msg = global.mq_ui:mq_publish2(const.MSG_UI_HERO_ATTR)
	-- 		msg.mm_obj = t
	-- 	end
	-- else
		-- 玩家属性
		for i,v in ipairs(req.kvs) do
			-- print("..",i,v.key,v.value)
			local value
			if v.key == "money" or v.key == "RMB" then
				value =  tonumber(("%0.2f"):format(v.fvalue))
			else
				value = v.value
			end
			local old = player:get_basedata(v.key)
			player:set_basedata(v.key, value)

			-- 提示
			if v.param1 ~= 0 then --标志为0时才显示
				is_show = false
			end
			--
			local f = KEY_EVENT[v.key]
			if f then
				f(is_show, old, value)
			end
			-- dataeye_mgr:record_coin(0,v.key,old,v.value)
		end
		global._view:updatePlayerData()
		-- global.mq_msg:mq_publish2(const.MSG_UI_UPDATAROLEINFO)
	-- end
end
------------------------------------------------
function M._artifact_base(req)
	local mgr = player:get_mgr("artifact")
	mgr:set_max_plunder_count(req.max_plunder_count)
	mgr:set_plunder_count(req.plunder_count)
	mgr:set_pc_cd(req.pc_cd)
	mgr:set_cur_buy_count(req.buy_count)
end
------------------------------------------------
--系统开放通知
function M.SC_OPEN_SYSTEM(req)
	return player:get_mgr("sysopen"):update(req.id,1)
end
------------------------------------------------
--活动数据刷新
function M.SC_FLUSHACTIVITY(req)
	if req.del_id > 0 then
		return player:get_mgr("activity"):ma_delete(req.del_id)
	end
	return player:get_mgr("activity"):ma_update(req.info)
end

function M.SC_NOTIFY(req)
	-- if req.type == const.NOTIFY_TYPE_ATHLETIC_REPORT then --通知有新的战报
	-- 	player:get_mgr("athletic"):notify_report()
	-- elseif req.type == const.NOTIFY_TYPE_CHARGE_OK then --充值成功提示
	-- 	player:get_mgr("charge"):OnChargeDiamondResp(req.param3,req.param1,req.param4,req.param2)
	-- elseif req.type == const.NOTIFY_TYPE_SOMEONE_REQ_JOIN_GUILD then --有人申请加公会提示
	-- 	player:get_mgr("guild"):someone_req_join_guild()
	-- elseif req.type == const.NOTIFY_TYPE_APPLY_JOIN_GUILD then --通过加入公会
	-- 	player:get_mgr("guild"):apply_guild_ok()
	-- elseif req.type == const.NOTIFY_TYPE_GUILD_EXPEL then --被开除公会通知
	-- 	player:get_mgr("guild"):be_expel(req.param1)
	-- elseif req.type == const.NOTIFY_TYPE_WORLDBOSS then --世界boss
	-- 	player:get_mgr("worldboss"):worldboss_notify(req.param1,req.param2, req.param4, req.param5, req.param6)
	-- end
	if req.type == const.NOTIFY_TYPE_CHARGE_OK then --充值成功提示
		player:get_mgr("charge"):OnChargeDiamondResp(req.param3,req.param1,req.param4,req.param2)
	end
end

-- 有未领取订单通知
function M.SC_NOTIFYCHARGERESP(req)
	player:get_mgr("charge"):OnNotifyChargeResp(req.ord_list)
end
return M