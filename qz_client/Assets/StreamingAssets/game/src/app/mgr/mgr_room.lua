--
-- Author: wangshaopei
-- Date: 2017-05-27 15:08:56
--
local global = require("global")
local player = global.player
local const = global.const
local table_insert = table.insert
local mt=class("mgr_room")
local mgr_12zhi
local mgr_niuniu

local errcode_util = global.errcode_util

function mt:ctor(player)
	self:reset()
end

function mt:init()
	mgr_12zhi = player:get_mgr("12zhi")
	mgr_niuniu = player:get_mgr("niuniu")
end

function mt:reset()
	self.data=nil
	self.invite_roomlist={}
	self.roomid = "" -- 当前房间id
	self.gameid = nil -- 当前游戏id
end

local gen_hall_list = function ( ls )
	local t = {}
	if not ls then
		return t
	end
	local count = 0
	for k,v in pairs(ls) do
		table.insert(t,{roomid = v.roomid,num=v.num})
		count = count + 1
	end
	return t,count
end

function mt:nw_reg()
	global.network:nw_register("SC_OP_ROOM_ACTION", handler(self,self.on_net_data))
end

function mt:nw_unreg()
	global.network:nw_unregister("SC_OP_ROOM_ACTION")
end

function mt:enter(gameid, roomid,cb)
	global.player:call("CS_ENTER_ROOM",{gameid=gameid,roomid=roomid},function(resp)

			local ec = resp.errcode
			if ec == 0 then
				self:set_roominfo(resp.gameid,0)
				-- self.m_properties.roomid = resp.roomid
				-- logI("CS_ENTER_ROOM roomid "..resp.roomid)
				-- player:set_basedata("roomid",roomid)
				-- self.data.over_time = resp.over_time
			else
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end
			if cb then
					cb(resp)
			end
		end)
end


-- 退出房间
function mt:exit(gameid,cb)
	global.player:call("CS_EXIT_ROOM",{gameid=gameid},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				self:set_roominfo(0,"")
				-- logI("CS_EXIT_ROOM roomid "..resp.gameid)
				if cb then
					cb()
				end
			else
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end
		end)
end

-- 创建房间
--[[
	12支：
	play_type : int 玩法，1:自由坐庄 2:抢庄 11:自由坐庄加可放支 12:抢庄加可放支
	bout_type : int 回合类型 1:10 2:20

	牌九：
	play_type : int 玩法，1:自由坐庄 2:抢庄
	bout_type : int 回合类型 1:10 2:20

	麻将：

	bout_type : int 复合数 （10位代表人数，各位代表局数） 100:2人 200:3人 300：4人--todo   1：5局 2：10局 3：20局

]]
function mt:create( gameid ,cb,play_type,bout_type)
	local t = {play_type or 1 , bout_type or 0}

	global.player:call("CS_CREATE_ROOM",{gameid=gameid,param1=table.concat(t,"|") },function(resp)
		local ec = resp.errcode
		local info = {
			errcode = resp.errcode,
			gameid = resp.gameid,
			roomid = resp.roomid
		}
		if ec == 0 then
			-- logI("CS_CREATE_ROOM gameid = %s roomid = %s ",resp.gameid,resp.roomid)

			self:set_roominfo(resp.gameid,resp.roomid)
			if cb then
				cb(info)
			end
		else
			if cb then
				cb(info)
			end
			local ec=global.errcode_util:get_errcode_CN(ec)
			global._view:getViewBase("Tip").setTip(ec)
			-- logI("CS_CREATE_ROOM errcode "..ec)
		end
	end)
end
function mt:create_room_mj(gameid,cb,people_nu,coin)
	local t = {people_nu or 2 ,coin or 1}
	global.player:call("CS_CREATE_ROOM",{gameid=gameid,param1=table.concat(t,"|") },function(resp)
		local ec = resp.errcode
		local info = {
			errcode = resp.errcode,
			gameid = resp.gameid,
			roomid = resp.roomid
		}
		if ec == 0 then
			-- logI("CS_CREATE_ROOM gameid = %s roomid = %s ",resp.gameid,resp.roomid)

			self:set_roominfo(resp.gameid,resp.roomid)
			if cb then
				cb(info)
			end
		else
			if cb then
				cb(info)
			end
			local ec=global.errcode_util:get_errcode_CN(ec)
			global._view:getViewBase("Tip").setTip(ec)
			-- logI("CS_CREATE_ROOM errcode "..ec)
		end
	end)
end 
--[[
	13水：
	play_type : int 玩法，1:自由坐庄 2:抢庄
	bout_type : int 回合类型 1:10 2:20
	pour_num  : int 最多设置注数
	pour_coin  : int 设置最少的金币
]]
function mt:create_room_water( gameid ,cb,play_type,bout_type, pour_num, pour_coin)
	local t = {play_type or 1 , bout_type or 0,pour_num or 1, pour_coin or 10}

	global.player:call("CS_CREATE_ROOM",{gameid=gameid,param1=table.concat(t,"|") },function(resp)
		local ec = resp.errcode
		local info = {
			errcode = resp.errcode,
			gameid = resp.gameid,
			roomid = resp.roomid
		}
		if ec == 0 then
			-- logI("CS_CREATE_ROOM gameid = %s roomid = %s ",resp.gameid,resp.roomid)

			self:set_roominfo(resp.gameid,resp.roomid)
			if cb then
				cb(info)
			end
		else
			local ec=global.errcode_util:get_errcode_CN(ec)
			global._view:getViewBase("Tip").setTip(ec)
			-- logI("CS_CREATE_ROOM errcode "..ec)
		end
	end)
end

function mt:set_roominfo(gameid,roomid)
	self.gameid = gameid
	self.roomid = roomid
end

function mt:get_gameid()
	return self.gameid
end

--[[
	获取游戏大厅列表
	data = {
		count : 大厅数
		list : arr 数组
		｛
			roomid : string
			num : int 人数
		｝
	}
]]
function mt:req_get_hall_list( gameid ,cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=5},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				if not self.data then
					self.data = {}
				end
				local t = {}
				t.list ,t.count= gen_hall_list(resp.hall_info)
				self.data[gameid]=t
				-- dumpall(self.data)
				if cb then
					cb(self.data[gameid].list)
				end
			else
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end
		end)
end

--[[
	13水游戏大厅
	in:
	gameid:int    5
	op: 5
	play_type:  当获取俩个模式的列表时，为空，，获取对比模式列表：1, 获取坐庄模式时为2
	bet_coin:   当获取俩个模式的列表时，为空， 获取对比模式列表：金币值, 获取坐庄模式时为金币值5
	out:
	data = {{
		play_type: 大厅模式 对比1/ 坐庄2
		list : arr 数组
		｛
			roomid : string
			num : int 人数
		｝
	}...}
]]
function mt:req_get_waterhall_list( gameid , play_type, bet_coin, cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=5, param1=play_type, param2=bet_coin},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				if not self.data then
					self.data = {}
				end
				if play_type then
					local t = {}
					t.play_type = play_type
					if play_type == 1 then
						t.list = gen_hall_list(resp.hall_info1)
					elseif play_type == 2 then
						t.list = gen_hall_list(resp.hall_info2)
					end

					self.data[gameid]={}
					table_insert(self.data[gameid], t)
					-- dumpall(self.data)
					if cb then
						cb(self.data[gameid])
					end
				else
					local t = {}
					local t2 = {}

					t.play_type = 1
					t.list = gen_hall_list(resp.hall_info1)

					t2.play_type = 2
					t2.list = gen_hall_list(resp.hall_info2)

					self.data[gameid]={}
					table_insert(self.data[gameid], t)
					table_insert(self.data[gameid], t2)
					-- dumpall(self.data)
					if cb then
						cb(self.data[gameid])
					end
				end
			else
				if cb then
					cb(nil)
				end
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end
		end)
end

--[[
	处理网络数据
	resp={
		op_type 	: int 操作类型 1:进入房间 2:退出房间
		param1 		: string 玩家名称
	}
]]
function mt:on_net_data(resp)
	local d={coin = 0,
		player_name = resp.param1,
		amount_money = 0,
		content = "",
		url = "",
	}
	if resp.op_type == 1 then
		d.content = "进入房间"
		if(global._view:getViewBase("Room") ~= nil) then
		 	global._view:getViewBase("Room").updateBetInfo(d)
		end
	elseif resp.op_type == 2 then
		d.content = "退出房间"
		if(global._view:getViewBase("Room") ~= nil) then
		 	global._view:getViewBase("Room").updateBetInfo(d)
		end
	elseif resp.op_type == 3 then -- 12支下庄
		mgr_12zhi:on_net_action({
			errcode = 0,
			op_type = resp.op_type
			})
	elseif resp.op_type == 4 then -- 牛牛下庄
		mgr_niuniu:on_net_action({
			errcode = 0,
			op_type = resp.op_type
			})
	end

end

--[[
	邀请玩家到房间
	gameid 		: int 游戏id
	roomid 		: int 房间id
]]
function mt:req_invite_join_room(gameid,roomid)
	global.player:call("CS_OP_ROOM",{gameid=gameid,param4=roomid,op=6},function(resp)
			local ec = resp.errcode
			local t ={errcode=ec}
			if ec == 0 then
				-- invite_roomlist
				local gameid = resp.param1
				-- local roomid = resp.param4
				t.gameid = gameid
				-- t.roomid = roomid
				-- print("···invite_join_room",gameid,roomid)
				global._view:getViewBase("Tip").setTip("发布成功！！！")
			else
				global._view:getViewBase("Tip").setTip(global.errcode_util:get_errcode_CN(ec))
				-- logI("CS_CREATE_ROOM errcode "..ec)
			end
		end)
end

--[[
	接受房间要求
]]
-- function mt:req_accept_join_room(playerid)
-- 	global.player:call("CS_OP_ROOM",{param1 = playerid,op=7},function(resp)
-- 			local ec = resp.errcode
-- 			if ec == 0 then
-- 				-- invite_roomlist
-- 				local gameid = resp.gameid

-- 				-- print("···accept_join_room",gameid)
-- 				if cb then
-- 					cb()
-- 				end
-- 			else
-- 				logI("CS_OP_ROOM op 7 errcode "..ec)
-- 			end
-- 		end)
-- end

local function gen_roomlist(resp)
	local t={}
	for k,v in pairs(resp.list) do
		t[#t+1]={
			playerid=v.playerid,
			player_name=v.player_name,
			gameid=v.gameid,
			roomid=v.roomid,
			onlinecount=v.param1,
			status=v.param2,
		}
	end
	return t
end

--[[
	resp = {
		playerid
		player_name
		gameid
		roomid
		onlinecount
		status
	}
]]
function mt:req_invite_roomlist(gameid,cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=10},function(resp)
			-- local ec = resp.errcode
			local t = {}
			-- if ec == 0 then
				t.list=gen_roomlist(resp)
				self.invite_roomlist = t.list
				if cb then
					cb(self.invite_roomlist)
				end
			-- else
			-- 	if cb then
			-- 		cb(t)
			-- 	end
				-- logI("CS_CREATE_ROOM errcode "..ec)
			-- end
			-- dump(t)
		end)
end

function mt:get_data()
	return self.data
end

function mt:get_invite_list()
	return self.invite_roomlist
end

return mt