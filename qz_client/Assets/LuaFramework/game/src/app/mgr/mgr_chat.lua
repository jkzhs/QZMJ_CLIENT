--
-- Author: wsp
-- Date: 2016-02-23 16:38:54
-- Filename: mgr_chat.lua
--
local global = require "global"
local player = global.player
-- local KNMsg = global.KNMsg
local errcode_util = global.errcode_util
local cqueue = require "app.common.queue.queue"
-- local crab = assert(global.crab)
local const = global.const
local i18n = global.i18n
local config = global.config
local string_sub = string.sub
local table_insert = table.insert
local mgr_room

local mt = class("mgr_chat")
function mt:ctor()
	-- global.network:nw_register("SC_MSG", handler(self,self.SC_MSG))
	global.network:nw_register("SC_CHAT", handler(self,self.SC_CHAT))
	self:reset()
end
function mt:reset()
	self.last_chat_world_time = 0

	self.o_cache = {
		[const.CHANNEL_ID_SYSTEM] 	= cqueue.new(), --系统频道
		-- [const.CHANNEL_ID_PERSONAL] = {},			--私聊频道
		-- [const.CHANNEL_ID_WORLD] 	= cqueue.new(), --世界频道
		-- [const.CHANNEL_ID_GUILD] 	= cqueue.new(), --工会频道
		[const.CHANNEL_ID_ROOM] 	= cqueue.new(), --工会频道
	}
	self.o_personal_chat_list = {}

	self.players = {}
	self.data = {}
	self.msg = nil
end

local function __cache(cache, cache_data)

	if cache:size() >= 35  then --超过的话移除第一条
		cache:pop()
	end

	cache:push(cache_data)
end
--[[
	聊天信息缓存
	cache:[
		channel_id
		from_playerid
		msg
		to_palyerid
		receive_time
		voice_time 		: int 消息时长
	]
]]
function mt:mc_cache(channel_id, from_playerid, from_name, from_headid, msg, to_palyerid,msgtype,voice_time)

	local cache_data = {
		channel_id		= channel_id,
		from_playerid	= from_playerid,
		-- from_name		= from_name,
		-- from_headid		= from_headid,
		msg				= msg,
		voice_time 		= voice_time or 0,
		msgtype 		= msgtype or 0,
		to_palyerid		= to_palyerid,
		receive_time	= global.ts_now
	}

	local playerinfo = {
		from_name		= from_name,
		from_headid		= from_headid,
	}
	self.players[from_playerid] = playerinfo

	if channel_id ~= const.CHANNEL_ID_SYSTEM then--世界和公会的聊天 才有主菜单聊天按钮效果
		-- local dot = global.mq_ui:mq_publish2(const.MSG_UI_MAINMENU_DOT)
	 	-- dot.mm_obj = {name="chat", channel_id=channel_id, from_playerid=from_playerid, from_name=from_name, msg=msg}
	end

	--私聊特殊处理
	if channel_id == const.CHANNEL_ID_PERSONAL then
		-- dump(cache_data)
		--私聊缓存处理
		local playerid = from_playerid==player:get_playerid() and to_palyerid or from_playerid
		local pcache = self.o_cache[channel_id][playerid]
		if not pcache or pcache.receive_time then
			pcache = cqueue.new()
			-- cache[from_playerid] = pcache
		end

		__cache(pcache, cache_data)
		self.o_cache[channel_id][playerid] = pcache

		local chat_player = self:get_personal_chat_list(playerid)
		if not chat_player then
			self:insert_personal_chat_list({playerid=playerid, mark = true})
		else
			chat_player.mark = true --设置小红点
		end

		local data = global.mq_ui:mq_publish2(const.MSG_UI_CHAT_MSG)
		data.mm_obj = cache_data
		return
	end

	--缓存
	__cache(self.o_cache[channel_id], cache_data)

	-- local data = global.mq_ui:mq_publish2(const.MSG_UI_CHAT_MSG)
	-- data.mm_obj = cache_data

	-- 这边通知前端
	-- global._view:chat(cache_data)
	if channel_id == const.CHANNEL_ID_ROOM then
		local gameid = mgr_room:get_gameid()
		if gameid == const.GAME_ID_NIUNIU  then
			if(global._view:getViewBase("Room") ~= nil) then
				local playerInfo = self:get_playerinfo(cache_data.from_playerid)
				global._view:getViewBase("Room").getChatData(cache_data,playerInfo)
			end
		elseif gameid == const.GAME_ID_MJ then 
			if(global._view:getViewBase("MaJiang") ~= nil) then
				local playerInfo = self:get_playerinfo(cache_data.from_playerid)
				global._view:getViewBase("MaJiang").getChatData(cache_data,playerInfo)
			end
		else
			if(global._view:getViewBase("Chat") ~= nil) then
				local playerInfo = self:get_playerinfo(cache_data.from_playerid)
				global._view:getViewBase("Chat").getChatData(cache_data,playerInfo)
			end
		end

	end

end
--[[
	playerid:联系人玩家编号
]]
function mt:get_cache(channel_id, playerid)
	if not playerid then
		return self.o_cache[channel_id]
	end

	--私聊缓存
	local pcache = self.o_cache[channel_id][playerid]
	if not pcache then
		return
	end
	return pcache
end

--[[
	返回参数
	[
		from_name string 玩家名称
		from_headid string 头像链接
	]
]]
function mt:get_playerinfo(playerid)
	return self.players[playerid]
end
------------------------------------------------------
--服务端发来的消息
function mt:SC_MSG(req)
	-- body
end

function mt:SC_CHAT(req)
	if req.error_code ~= 0 then
		return
	end

	local ch_id = req.ch_id
	if ch_id == const.CHANNEL_ID_SYSTEM then --系统消息
		if req.showtype == const.CHANNEL_SHOW_TYPE_BULLETIN then --广播 游戏控制
			if req.count > 1 then
				for i=1, req.count do --广播次数
					-- KNMsg:msg_bulletin(ch_id,req.msg)
				end
			else
				-- KNMsg:msg_bulletin(ch_id,req.msg)
			end
		elseif req.showtype == const.CHANNEL_SHOW_TYPE_MARQUEE then--跑马灯 后台控制
			if req.count > 1 then
				for i=1, req.count do --跑马灯次数
					-- 显示信息
				end
			else
				-- 显示信息
				-- print("···",req.msg)
				global._view.noticeVec = req.msg
				-- global._view:showNotice()
				if(global._view:getViewBase("Gamelobby") ~= nil) then
				 	global._view:getViewBase("Gamelobby").playNoticeInfo()
				end
			end
		end
	end
	local msgtype = 0
	local voice_time = 0
	local msg = req.msg
	if ch_id == const.CHANNEL_ID_ROOM then
		msgtype = req.showtype
		voice_time = req.count
		if msgtype == 1 then
			msg = Util.stringtobyte(req.msg)
		end
	end
	--cache
	self:mc_cache(ch_id,req.from_playerid,req.from_name,req.from_headid,msg,nil,msgtype,voice_time)
end
------------------------------------------------------
function mt:flush_player_online(is_error, to_playerid)
	local personal_chat = self:get_personal_chat_list(to_playerid)
	if personal_chat and personal_chat.online then--online 0:不在线，1在线
		if (true == is_error and personal_chat.online == 1)--出现错误，当前在线
		or (false == is_error and personal_chat.online == 0) then--没错误，当前不在线
			player:get_mgr("friend"):mgf_friend_research_by_batchId({[1]=to_playerid})
		end
	end
end
--[[
	发送聊天信息
	channel_id 		: int 频道ID
	to_palyerid 	: int
	msg 			: string
	msgtype 		: int 消息类型 1:语音
	voice_time 		: int 语音时长
]]
function mt:chat(channel_id, to_playerid, msg,msgtype,voice_time)
	if channel_id == const.CHANNEL_ID_SYSTEM then
		return
	end
	-- local ret
	-- ret, msg = crab:filter(msg)
	if channel_id == const.CHANNEL_ID_ROOM then
		if msgtype == 1 then
			-- msg = tolua.tolstring(msg)
			-- print("···sdfd",msg)
			msg = Util.bytetostring(msg)
		end
	end
	player:call("CS_CHAT", {ch_id=channel_id, to_playerid=to_playerid,msg = msg,msgtype=msgtype,param1 = voice_time},function(resp)
		if errcode_util:ecu_check_hint(resp.error_code,resp.msg) then
			if channel_id == const.CHANNEL_ID_PERSONAL then
				self:flush_player_online(true, to_playerid)
			end
			return
		end
		--缓存
		if channel_id == const.CHANNEL_ID_PERSONAL then --私聊
			if resp.msg ~= "" then
				msg = resp.msg
			end
			self:mc_cache(channel_id, resp.from_playerid, resp.from_name, resp.from_headid, msg, to_playerid)

			self:flush_player_online(false, to_playerid)
		elseif channel_id == const.CHANNEL_ID_ROOM then --房间
			-- local msg = msg
			if msgtype == 1 then
				msg = Util.stringtobyte(msg)
			end
			self:mc_cache(const.CHANNEL_ID_ROOM, player:get_playerid(), player:get_name(),player:get_headimgurl(), msg,nil,msgtype,voice_time)
		end
	end)
	return true
end

--跟服务器请求物品
local ret_error_cfg= {
	GM_SUCCESSFUL = 0,
	GM_COMMAND_NOT_FOUNT = 1,
	GM_COMMAND_ACCOUNT_NOT_IN_GROUP = 2, --账户无该权限
	GM_COMMAND_NOT_GM = 3, --账户无该权限
	GM_COMMAND_TOO_SHORT = 4, --GM命令 太短
	GM_COMMAND_NOT_HAS_CMD = 5, --该组没有该cmd命令
	GM_COMMAND_PARAM_FORMAT_ERROR = 6,	--参数格式错误
	GM_COMMAND_SU_GROUP_NOT_FOUND = 7, --提权组未找到
	GM_COMMAND_SU_YOU_NOT_IN_GROUP = 8, --账号不在该组内，提权失败
	GM_COMMAND_DISPATCHER_NOT_FOUND	 = 9, --处理器未找到
}
local function GM_Command(str)
	if string_sub(str, 1, 2) == "!!" then
		local content_ = string_sub(str,3)
		player:call("CS_Command", {content = table.concat(string.split(content_," ")," ")},function(resp)
			-- print("···",resp.errcode)
		end)
		return true
	end
end
--世界频道
function mt:chat2wold(msg)

	if config.USE_GM_COMMAND then --正式版本不可用
		if GM_Command(msg) then
			self:mc_cache(const.CHANNEL_ID_WORLD, player:get_playerid(), player:get_name(),player:get_headid(), msg)
			return
		end
	end

	--检查cd时间
	local now = global.ts_now
	if self.last_chat_world_time > now then
		return  KNMsg:flashShowError((i18n.TID_CHAT_OFTEN):format(math.abs(now-self.last_chat_world_time)))
	end

	local cd = const._CD_TIME_CHANNEL[const.CHANNEL_ID_WORLD]
	self.last_chat_world_time = global.ts_now + cd

	return self:chat(const.CHANNEL_ID_WORLD,0,msg)
end
--工会
function mt:chat2guild(msg)
	return self:chat(const.CHANNEL_ID_GUILD,0,msg)
end
--私人
function mt:chat2personal(to_playerid, msg)
	return self:chat(const.CHANNEL_ID_PERSONAL,to_playerid,msg)
end
--系统
function mt:chat2System(to_playerid, msg)
	return self:mc_cache(const.CHANNEL_ID_SYSTEM, player:get_playerid(), player:get_name(), player:get_headid(), msg, to_playerid)
end

--[[
	房间
	@param msgtype int 发送消息的数据类型，msgtype:1 为语音数据 msgtype:nil 表情
	@param msg 数据，msgtype:1 为btye[]类型
	@param voice_time int 消息时长
]]
function mt:chat2room(msg,msgtype,voice_time)
	return self:chat(const.CHANNEL_ID_ROOM,0,msg,msgtype,voice_time)
end

local function get_data(data, id)
	if id then
		for i,v in pairs(data) do
			if v.playerid == id or v.from_id == id then
				return v, i
			end
		end
		return
	end
	return data
end
--[[
	私聊列表
]]
function mt:get_personal_chat_list(playerid)
	return get_data(self.o_personal_chat_list, playerid)
end

function mt:insert_personal_chat_list(data)
	return table_insert(self.o_personal_chat_list, data)
end

function mt:remove_personal_chat_list(index)
	return table.remove(self.o_personal_chat_list, index)
end
--私聊是否有小红点
function mt:is_personal_mark()
	for i,v in ipairs(self.o_personal_chat_list) do
		if v.mark then
			return true
		end
	end
end

function mt:client_askinfo(cb)
	mgr_room = player:get_mgr("room")
	global.player:call("CS_AskInfo",{type=1},function(resp)
			-- local ec = resp.errcode
			-- if ec == 0 then
				self.msg = resp.param1
				player:set_paytype(resp.param2)
				if cb then
					cb()
				end
			-- else
				-- logW("CS_AskInfo type 1,errcode %s",ec)
			-- end

		end)
end

function mt:get_broadcast()
	return self.msg or ""
end

return mt