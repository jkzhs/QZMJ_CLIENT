--
-- Author: wangshaopei
-- Date: 2017-05-27 15:08:56
--
local global = require("global")
local player = global.player
local const = global.const
local table_insert = table.insert
local mt=class("mgr_12zhi")

local errcode_util = global.errcode_util
--[[
	1:將 2:士 3:象 4:車 5:馬 6:包
	7:帥 8:仕 9:相 10:俥 11:傌 12:佨
]]
local bet_pos = {
				-- 一个
				[1]={10},	[2]={4},	[3]={7},	[4]={8},	[5]={9},	[6]={10},	[7]={4},
				[8]={11},	[9]={5},	[10]={1},	[11]={2},	[12]={3},	[13]={11},	[14]={5},
				[15]={12},	[16]={6},										[17]={12},	[18]={6},

				-- 横二个
				[20]={10,4},[21]={4,7},	[22]={7,8},	[23]={8,9},	[24]={9,10},[25]={10,4},
				[26]={11,5},[27]={5,1},[28]={1,2},[29]={2,3},[30]={3,11},[31]={11,5},
				[32]={12,6},[33]={12,6},

				-- 竖二个
				[40]={10,11},[41]={4,5},[42]={7,1},[43]={8,2},[44]={9,3},[45]={10,11},[46]={4,5},
				[47]={11,12},[48]={5,6},[49]={11,12},[50]={5,6},
				-- 四个
				[70]={10,4,11,5},[71]={4,7,5,1},[72]={7,8,1,2},[73]={8,9,2,3},[74]={9,10,3,11},[75]={10,4,11,5},
				[76]={11,5,12,6},[77]={11,5,12,6},

				-- 顶割
				[100]={3,2,1,9,8,7},
				-- 下割
				[101]={6,5,4,12,11,10},
				-- 红
				[102]={12,11,10,9,8,7},
				-- 黑
				[103]={1,2,3,4,5,6},
			}

local gameid = const.GAME_ID_12ZHI

local function gen_bet( resp )
	local t ={bet_list={},player_name=nil,headimgurl=nil,playerid=nil}
	for k,v in pairs(resp.bet_list) do
		t.bet_list[#t.bet_list+1]={pos = v.pos, money = v.money}
	end
	t.player_name = resp.player_name
	t.headimgurl = resp.headimgurl
	return t
end

local function gen_result_bet_users(resp)
	local t={}
	for k,v in ipairs(resp.bet_users) do
		table_insert(t,{
			player_name = v.player_name,
			playerid = v.playerid,
			result_money = tonumber(("%0.2f"):format(v.result_money)) ,
			headimgurl = v.param1,
		})
	end

	return t
end

local function gen( resp )
	local t = {}
	t.game_status = resp.game_status
	t.over_time = resp.over_time
	t.bout = resp.bout
	t.play_type = resp.play_type
	t.history ={}
	t.bet_users={}
	for i,v in ipairs(resp.history) do
		t.history[i]=v.cardid
	end
	-- dump(resp.bet_users)
	-- for i,v in ipairs(resp.bet_users) do
	-- 	-- t.bet_users[v.pos]={}
	-- 	table_insert(t.bet_users,{pos=v.pos,chouma_index=v.chouma_index})
	-- end
	return t
end

local function gen_members( resp )
	local t={}
	for k,v in pairs(resp.members) do
		t[k]={player_name = v.player_name,
			headimgurl = v.headimgurl,
			playerid = v.playerid,
			RMB =tonumber(("%0.2f"):format(v.RMB)) ,
			money = tonumber(("%0.2f"):format(v.money)) ,
		}
	end
	return t
end

local function clear_banker( data )
	data.banker_name = "" -- 庄家名称
	data.banker_playerid = 0
	data.headimgurl = "" -- 庄家头像
end

function mt:ctor(player)
	self.data={}

end

function mt:nw_reg()
	global.network:nw_register("SC_12ZHI_GETDATA", handler(self,self.on_net_update_data))
	global.network:nw_register("SC_12ZHI_BET", handler(self,self.on_net_update_bet))
	-- global.network:nw_register("SC_OX_CARD_SHOW", handler(self,self.on_net_cardshow))
	global.network:nw_register("SC_OX_PUBLIC_ROB_BANKER", handler(self,self.on_net_rob_banker))

end

function mt:nw_unreg()
	global.network:nw_unregister("SC_12ZHI_GETDATA")
	global.network:nw_unregister("SC_12ZHI_BET")
	global.network:nw_unregister("SC_OX_PUBLIC_ROB_BANKER")
end

--[[
	进入房间请求数据
	data={
			errcode 			: int 错误码
			game_status 		: int 游戏状态
			over_time 			: int 状态结束时间
			play_type 			: int 玩法
			bout 				: int 当前局
			bout_amount 		: int 局数
			result_card 		: int 开的牌
			pos_amount_bet 		:  总的押注信息
			{
				[pos] = money
				..
			}
			history {
	 			{cardid = 牌}
			}
		}
]]
function mt:req_data(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=1},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local data = gen(resp)
				data.bout_amount = resp.bout_amount
				-- data.history
				data.house_owner_name = resp.house_owner_name
				-- dump(data)
				local info=resp.bet_users[1]
				if info then
					data.banker_name = info.player_name -- 庄家名称
				 	data.headimgurl = info.param1 -- 庄家头像
				 	data.player_max_coin = info.param2 -- 玩家最大下注
				end
				if data.game_status == const.TWELVE_STATUS_BET then
					data.pos_amount_bet = {}
					for k,v in pairs(resp.pos_amount_bet) do
						data.pos_amount_bet[v.pos]=v.money
					end
				elseif data.game_status == const.TWELVE_STATUS_OPEN  then
					data.result_card = resp.result_card
				end

				 self.data = data
				 -- dump(data)
				if cb then
					cb(data)
				end
			else
				logI("CS_OP_ROOM errcode "..ec)
			end
		end)
end

function mt:req_bet(bet_list,cb)
	global.player:call("CS_12ZHI_BET",{bet_list=bet_list},function(resp)
		self:on_net_update_bet(resp,player:get_playerid())
		if (cb)then
			cb()
		end

	end)

end

-- 抢庄
--[[
	resp = {
		errcode int
	}
]]
function mt:req_rob_banker(coin,cb)

	global.player:call("CS_OP_ROOM",{gameid=gameid,op=3,param3 = coin},function(resp)
		local ec = resp.errcode
		if ec == 0 then
			self:on_net_rob_banker({coin=coin,
				player_name=player:get_name(),headimgurl=player:get_headimgurl()})
			if cb then
				cb(resp)
			end
		else
			global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			global._view:hideLoading()
		end

	end)
end

--[[
	获取抢庄信息
	resp＝{
		param1: int 庄家最低分
		param2: int 玩家最高下注
	}
]]
function mt:req_rob_banker_info(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=8},function(resp)
			local ec = resp.errcode
			local t = {}
			if ec == 0 then
				local m = {
					banker_min_coin=resp.param1,
					player_max_coin=resp.param2,
				}
				table.insert(t,m)
			else
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
				global._view:hideLoading()
			end
			-- dump(t)
			if cb then
				cb(t,ec)
			end
		end)
end

--[[
	选择牌
]]
function mt:req_select_card(card,cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=11,param1=card},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				self.data.select_card = resp.param1
				if cb then
					cb()
				end
			else
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
				global._view:hideLoading()
			end
			-- dump(t)

		end)
end

--[[
	下庄
]]
function mt:req_drop_banker(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=12},function(resp)
		self:on_net_action({
				errcode = resp.errcode,
				op_type = 3,
				})
			if resp.errcode == 0 then
				if cb then
					cb()
				end
			end

		end)

end

--[[
	下注记录
	record : {
		{
			int time : 时间
			int bout : 回合
			int card : 牌
			int coin : 获得金币
			pos_amount_bet[pos] = money  位置对应的下注金额
		}
	}
]]
function mt:req_get_record(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=13},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local record = {}
				for k,v in pairs(resp.record) do
					local r={}
					r.time = v.time
					r.bout = v.bout
					r.card = v.card
					r.coin = v.coin
					r.pos_amount_bet={}
					for k,e in pairs(v.pos_amount_bet) do
						r.pos_amount_bet[e.pos]=e.money
					end

					table.insert(record,r)
				end
				self.data.record = record
				-- dump(self.data.record)
				if cb then
					cb(record)
				end
			else
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end

		end)
end

--[[
	请求房间玩家
	in [
		@param1 startindex int 开始位置
		@param2	count int 查询数量
	]
	out [
		resp = {
			errcode : int
			members : arr 列表
			 {
	 			  player_name : string
				  playerid : int
				  headimgurl : string
				  RMB  : int
				  money : int
			}
		}
	]

]]
function mt:req_room_members(startindex,count,cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=4,param1=startindex,param2=count},function(resp)
			local t = {}
			t.errcode=resp.errcode
			t.members=gen_members(resp)
			if cb then
				cb(t)
			end
		end)
end

--[[
	玩家抢庄广播
	resp = {
		coin : 抢的币
		player_name : string
		headimgurl : 玩家头像
	}
]]
function mt:on_net_rob_banker( resp )
	if(global._view:getViewBase("ShierzhiRoom") ~= nil) then
	 	global._view:getViewBase("ShierzhiRoom").RobBroadcast(resp)
	end
end

--[[
	data = {
		bout 				: int 	局数
		game_status 		:
		over_time 			:
		liuju 				: int 	流局
		daobang 			: bool 	倒帮
	}
]]
-- 游戏状态更新
function mt:on_net_update_data( resp )
	local data = self.data
	if not data then
		return
	end
	local ec = resp.errcode
	if ec == 0 then
		local d = gen(resp)
		data.game_status = d.game_status
		 data.over_time = d.over_time
		 data.daobang = false
		 data.liuju = 0
		 -- data.history = d.history

		if d.game_status == const.TWELVE_STATUS_FREE then
		 	data.bout = d.bout
			data.bet_users = {}
		 	local info=resp.bet_users[1]
		 	if info then
		 		data.liuju = info.playerid or 0 -- 1为流局
		 		if info.param2 > 0 then
					 data.player_max_coin = info.param2 -- 玩家最大下注
		 		end
		 	end
		 	-- 倒帮
		 	if resp.result_card == 1 then
		 		data.daobang = true
		 	end
		elseif d.game_status == const.TWELVE_STATUS_SELECT then
			local info=resp.bet_users[1]
		 	data.banker_name = info.player_name -- 庄家名称
		 	data.banker_coin = info.playerid --庄家的金币
		 	data.headimgurl = info.param1 -- 庄家头像
		 	data.player_max_coin = info.param2 -- 玩家最大下注
		elseif d.game_status == const.TWELVE_STATUS_BET then
			-- local info=resp.bet_users[1]
		 -- 	data.banker_name = info.player_name -- 庄家名称
		 -- 	data.banker_coin = info.playerid --庄家的金币
		 -- 	data.headimgurl = info.param1 -- 庄家头像
		 -- 	data.player_max_coin = info.param2 -- 玩家最大下注
		 	data.result_card = resp.result_card --
		 elseif d.game_status == const.TWELVE_STATUS_OPEN then
			data.bet_users = gen_result_bet_users(resp)
			data.result_card = resp.result_card -- 开的牌
			-- if(global._view:getViewBase("ShierzhiRoom")~=nil)then
			-- 	global._view:getViewBase("ShierzhiRoom").UpdateResultBet(data.bet_users);
			-- end
		 end
		 -- dump(data)
		 -- local msg = global.mq_msg:mq_publish2(const.MSG_UI_12ZHI_CHOUMA_UPDATA)
		 -- msg.mm_obj = {op=1}
		 if(global._view:getViewBase("ShierzhiRoom")~=nil)then
			global._view:getViewBase("ShierzhiRoom").setRoomBtnState(data);
		 end
	end
end

--[[
	下注广播
	info = {
		bet_list = {
			{
				pos : int 下注位置，参照 bet_pos，1～100:普通下载 101~104:顶割,下割,红，黑
				money : int 金额
			},
		}
		player_name : string 下注玩家名称
		headimgurl : string 下注玩家链接
		playerid : 玩家id
	}
]]
function mt:on_net_update_bet( resp ,playerid)
	local ec = resp.errcode
	if ec == 0 then
		local info = gen_bet(resp)
		if playerid then
			info.playerid = playerid
		end
        if(global._view:getViewBase("ShierzhiRoom")~=nil)then
            global._view:getViewBase("ShierzhiRoom").UpdateAllBetMessage(info);
        end

		-- dump(info)
	else
		global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
		global._view:hideLoading()
		local shierzhi = global._view:getViewBase("ShierzhiRoom") or nil
		if shierzhi then
			shierzhi.ClearBetMessage(playerid)
		end
	end
	-- if resp.errcode == 0 then
		-- table_insert(self.data.bet_users,{pos = resp.pos,chouma_index = resp.chouma_index})
		-- local msg = global.mq_msg:mq_publish2(const.MSG_UI_12ZHI_CHOUMA_UPDATA)
		-- local bet_users = self.data.bet_users
		-- 	msg.mm_obj = {
		-- 		bet_user = bet_users[#bet_users],
		-- 		op = 0,
		-- 	}

		-- dump(self.data)
	-- end
end

--[[
	动作广播
	op_type int 类型 3:下庄广播
]]
function mt:on_net_action(resp)
	local ec = resp.errcode
	if ec == 0 then
		local data = self.data
		if resp.op_type == 3 then
			data.bout = 1
		 	data.history = {}
			clear_banker(data)
			--下庄广播调用
			if(global._view:getViewBase("ShierzhiRoom")~=nil)then
				global._view:getViewBase("ShierzhiRoom").LoseRobCallBack(data);
			end
		end
	else
		global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
		global._view:hideLoading()

	end
	global._view:hideLoading()
end

function mt:get_data()
	return self.data
end

return mt