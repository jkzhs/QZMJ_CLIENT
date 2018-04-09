--
-- Author: wangshaopei
-- Date: 2017-11-06 10:48:19
--
local global = require("global")
local player = global.player
local const = global.const
local table_insert = table.insert
local MARK_CMD = {}
local gameid = const.GAME_ID_WATER
local errcode_util = global.errcode_util
local config_water = global.config_mgr.get("water")

local error_code  = global.errcode

local mt=class("mgr_water")

local function gen_bet( resp )
	return {
			bet_money = resp.money,
			player_name = resp.player_name,
			headimgurl = resp.headimgurl,
			own_money = tonumber(("%0.2f"):format(resp.own_money)),
			playerid = resp.playerid,
	}
end

local function gen_card_bet_users(resp)
	local t={}
	for k,v in ipairs(resp.cards) do
		table_insert(t,{
				a_index= v.a_index,
				cardtype=v.type,
				num=v.card,
			})
	end

	return t
end

local function gen_bet_playerids( resp )
	local t={}
	for k,v in ipairs(resp.bet_playerids) do
		table_insert(t,{
				playerid = v.playerid,
			})
	end

	return t
end

local function gen_result_bet_users(resp)
	local t = {}
	for k , v in ipairs(resp.bet_users)do 	
		table_insert (t,{
			player_name = v.player_name,
			playerid = v.playerid,
			result_money = tonumber(("%0.2f"):format(v.result_money)) , -- 当局盈利的金币
			gain_money = tonumber(("%0.2f"):format(v.gain_money)), -- 玩家结余金币
			headimgurl = v.param1,
		})
	end 
	return t
end

local function gen_own_mound( tb)
	local t = {}
	for k, v in pairs(tb) do
		table_insert(t,{
			playerid = v.playerid,
			})
	end
	return t
end

local function gen_result_account( tb )
	local t = {}
	for k, v in pairs(tb) do -- 每个玩家 三墩
		table_insert(t, {
					add_odds=v.add_odds,
					extra_odds=v.extra_odds,
					cards=v.cards,
					card_type=v.card_type,
					a_index=v.odds_index,
				})
	end
	return t
end

local function gen_result_cards_users(resp)
	local t={}
	--[[
		一个人的数据：
		{
			playerid:
			is_spec: int 是否是特殊牌 1 是 0 不是
			card_type: int 特殊牌的牌型（普通牌时是0）
			total_odds: int 普通牌计算后总的注数
			extra_odds: int 特殊牌注数
			mound_odds: int 普通牌打枪注释和
			cards = {}... 特殊牌的牌值
			open_index: int 特殊牌的开牌顺序

			mound:{ 被打枪的数据
				{
				playerid:int
				--score:int （只存放>0）}...
				} 打枪的玩家id
			swat: int 全垒打的数据 >0 全垒打， <0 被全垒打
				
			card_count:{ 普通牌三墩信息
				{
					cards:{ }.. 卡牌信息
					add_odds: int   当前墩获得注数，目前都是1
					extra_odds: int 额外注数，特殊牌型有特殊奖励，如葫芦
					card_type: int 当前牌墩类型 / 特殊牌的类型
					a_index: int 开牌顺序
				}...
			}
		}...
	]]
	for pid, val in pairs(resp.open_result) do
		local each = {}

		each.card_count = {}
		each.mound = {}
		each.swat = {}
		each.playerid = val.playerid
		each.open_index = val.open_order
		each.total_odds = val.comm_odds
		each.extra_odds = val.extra_odds
		each.is_spec = val.is_spec
		each.card_type = val.card_type
		each.mound_odds = val.mound_odds

		each.card_count = gen_result_account(val.account)
		each.mound = gen_own_mound(val.mound)
		each.swat = val.swat
		table_insert(t, each)
	end

	return t
end

local function gen_init_cards(resp)
	local t={}
	for k,v in pairs(resp.cards) do
		local c_card = {a_index=v.a_index, type=v.type, card=v.card}
		table_insert(t, c_card)
	end
	return t
end

local function gen_enter_room(resp)
	local t={errcode=resp.errcode, members={}}
	for k,v in ipairs(resp.members) do
		table_insert(t.members,{
				player_name = v.player_name,
				playerid = v.playerid,
				money =  tonumber(("%0.2f"):format(v.money)) ,
				headimgurl = v.headimgurl,
				RMB =  tonumber(("%0.2f"):format(v.RMB)),
			})
	end

	return t
end

local function gen_history(resp)
	local last_card = {[1]=nil,[2]=nil,[3]=nil,[4]=nil}
	local use_cards={}
	local cards_list = {}
	local amount = #resp.history
	for i,v in ipairs(resp.history) do
		local list_str = string.split(v.cards,"|")
		local arr = string.split(list_str[#list_str],",")
		last_card[v.a_index]=arr

		cards_list[v.a_index]=list_str
	end
	if amount > 0 then
		local count = 1
		while true do
			for k,line in pairs(cards_list) do
				if line[count] then
					local arr = string.split(line[count],",")
					table_insert(use_cards,arr[1])
					table_insert(use_cards,arr[2])

				else
					count = nil
					break
				end
			end
			if not count then
				break
			end
			count = count + 1
		end
	end

	return use_cards,last_card
end

local function gen( resp )
	local t = {}
	t.game_status = resp.game_status
	t.over_time = resp.over_time
	t.bout = resp.bout
	t.bet_users={}
	t.banker_playerid = resp.param_id

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

local function gen_trim_check_card( resp )
	local t = {errcode=resp.errcode, playerid=resp.playerid, deal_ret=resp.deal_ret,cards={}}
	for k,v in pairs(resp.cards) do
		table_insert(t.cards, {a_index=v.a_index, card=v.card, type= v.type})
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

function mt:get_data()
	return self.data
end

function mt:nw_reg()
	global.network:nw_register("SC_WATER_TRIM", handler(self, self.on_net_trim))
	global.network:nw_register("SC_WATER_ENTER_ROOM", handler(self, self.on_net_enter_room))
	global.network:nw_register("SC_WATER_EXIT_ROOM", handler(self, self.on_net_exit_room))
	global.network:nw_register("SC_WATER_GETDATA", handler(self,self.on_net_update_data))
	global.network:nw_register("SC_WATER_BET", handler(self,self.on_net_update_bet))
	global.network:nw_register("SC_OP_WATER_ACTION", function ( resp )
		self:on_net_action({
			errcode = 0,
			op_type = resp.op_type,
			})
	end )
	global.network:nw_register("SC_OX_PUBLIC_ROB_BANKER", handler(self,self.on_net_rob_banker))
end

function mt:nw_unreg()
	global.network:nw_unregister("SC_WATER_TRIM")
	global.network:nw_unregister("SC_WATER_ENTER_ROOM")
	global.network:nw_unregister("SC_WATER_EXIT_ROOM")
	global.network:nw_unregister("SC_WATER_GETDATA")
	global.network:nw_unregister("SC_WATER_BET")
	global.network:nw_unregister("SC_OP_WATER_ACTION")
	global.network:nw_unregister("SC_OX_PUBLIC_ROB_BANKER")

end

-- 请求更新
function mt:request_upgrade(cmd,...)
	local f = MARK_CMD[cmd]
	if not f then
		return
	end
	return f(self,true,...)
end

-- 检测是否更新
function mt:check_upgrade(cmd,showerror,...)
	local f = MARK_CMD[cmd]
	if not f then
		return
	end
	local ret,param = f(self,false,...)
	if ret == 0 then
		return true
	end
	if not showerror then
		return
	end

	if ret == 1 then
		-- print(i18n.TID_COIN_GLOD)
		global._view:getViewBase("Tip").setTip(i18n.TID_COIN_GLOD)
		return global.ui_facade:uf_show_not_enough_rmb()
	elseif ret == 2 then
		-- print("···222")
		-- print(i18n.TID_COIN_SILVER)
		global._view:getViewBase("Tip").setTip(i18n.TID_COIN_SILVER)
		KNMsg:flashShow(i18n.TID_CANCRASH_FLUSH_NOTE2)
	elseif ret == 3 then
		global._view:getViewBase("Tip").setTip(i18n.TID_COMMON_NOT_OPERATE_SELF)
	end
end

-- 更新服务器数据
function mt:req(cmd,...)
	if not self:check_upgrade(cmd,true,...) then
		return false
	end

	return self:request_upgrade(cmd,...)
end

-- 是否改变
function mt:is_mark()
	-- if not self:check_upgrade("ask_watch",{op = 1}) then
	-- 	return false
	-- end
	-- return true
end

-----------------------------------------------------------------------------------------------------
-- 请求接口
function MARK_CMD.req_data(mgr,isrequest,...)
	local t = {...}
	if isrequest then
		return mgr:req_data(...)
	else
			local playerid = t[1]
	end
	return 0
end

--[[
	进入房间请求数据
	data={
			errcode 			: int 错误码
			game_status 		: int 游戏状态
			over_time 			: int 状态结束时间
			bout 				: int 当前局
			bout_amount 		: int 总局数
			play_type 			: int 玩法 1:对比模式 2:抢庄
			max_room_num        ：int 房间的最大限制人数
			pour_num            : int 房间的最大注数
			pour_coin           : int 房间的最小每注金币

			members  {          op = 1
				player_name    : string 
				playerid       : int
				headimgurl     : string
				RMB            : float
				money          : money
			},...
		}
]]
function mt:req_data(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=1},function(resp)

			local ec = resp.errcode
			local data = nil
			local members = nil
			if ec == 0 then
				data = gen(resp)
				data.play_type = resp.play_type
				data.bout_amount = resp.bout_amount
				data.use_cards,data.last_card = gen_history(resp)
				data.house_owner_name = resp.house_owner_name
				local info=resp.bet_users[1]
				if info then
					data.banker_name = info.player_name -- 庄家名称
					data.banker_playerid = info.playerid
				 	data.headimgurl = info.param1 -- 庄家头像
				 	data.player_max_coin = info.param2 -- 玩家最大下注
				end
				self.data = data

				data.pour_num = resp.playerid  -- 房间最大注数
				data.pour_coin = resp.card_type -- 房间下注最小的金币
				data.max_room_num = resp.is_spec -- 房间最大人数限制,
				data.members = gen_members(resp)
				--dump(data)
			else
				logI("CS_OP_ROOM errcode "..ec)
			end

			if cb then
				cb(data)
			end
		end)
end

function MARK_CMD.req_bet(mgr,isrequest,...)

	local t = {...}
	if isrequest then
		return mgr:req_bet(...)
	else
			local playerid = t[1]

	end
	return 0
end



--[[
	请求下注广播

	in [
		@param1 coin int 筹码
	]
	out [

	]

]]
function mt:req_bet(coin,cb)

	global.player:call("CS_OP_ROOM",{gameid=gameid,op=2,param1=coin},function(resp)
			local ec = resp.errcode
			local info = gen_bet(resp)

			info.errcode = ec
			if cb then
				cb(info)
			end
			-- if ec == 0 then
				-- self:on_net_update_bet(resp)
			-- 	self:update_bet(resp)

			-- 	-- dump(self.data)
			-- else

			-- 	logW("CS_OP_ROOM op 2 gameid %s errcode %s",gameid,errcode_util:get_errcode_CN(ec))
			-- end
		end)
end



--[[
	理牌时间：
	in :{
		gameid:  int 玩家id
		param1:  int 卡牌类型种类  3：普通牌  4:特殊牌
		param4:  string   传卡牌位置信息及类型，如普通牌"12,10,3|1,4,2,7,9|5,8,11,6,13#1130|1140|1150"
												特殊牌"12,10,3|1,4,2,7,9|5,8,11,6,13#1298"
	}

	out:{
		errcode 			: int 错误码
		game_status 		: int 游戏状态
		over_time 			: int 状态结束时间
		bout 				: int 当前局
		bout_amount 		: int 总局数
		play_type 			: int 玩法 1:对比模式 2:抢庄
		
		card_ret: { 使用的牌
			[1]:{ 第一位玩家
				playerid    : int
				cards:{
					a_index:  int        -- 返回的结果
					card    ：int
					type    : int
				}
				
				deal_ret : {
					a_index       : int --前中后墩  1,2,3
					win_playerid  : string  str|str1
					lose_playerid : string  str|str1
					bout_type     : int     1:对比 2：抢庄
				}
		}, 
	}
]]
function mt:req_trim_card(cardtype,cards,cb)
	-- param1: 当前墩是普通牌时传3, 特殊牌4, param4:card_value string
	-- local cc = "12,10,3|1,4,2,7,9|5,8,11,6,13#1130|1140|1150"
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=9,param1=cardtype, param4=cards},function(resp)
			local ec = resp.errcode
			 if ec ~= 0 then
				if (ec == error_code.ERROR_WATER_TRIM_CARD1) or (ec == error_code.ERROR_WATER_TRIM_CARD2) then
				    -- 不提示
				else
				    local ec=global.errcode_util:get_errcode_CN(ec)
				    global._view:getViewBase("Tip").setTip(ec)
				end
				logW("CS_OP_ROOM op 9 gameid %s errcode %s",gameid,errcode_util:get_errcode_CN(ec))
			 else
				
			 end
			 if cb then
					cb(ec)
			end
	end)
end


function MARK_CMD.req_rob_banker(mgr,isrequest,...)
	local t = {...}
	if isrequest then
		return mgr:req_rob_banker(...)
	else
			local playerid = t[1]
	end
	return 0
end
-- 抢庄
--[[
	resp = {
		errcode int
	}
]]
function mt:req_rob_banker(coin,cb)
	-- print('----------------上庄----------444------------》', coin)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=3,param3 = coin},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				self:on_net_rob_banker({coin=coin,
					player_name=player:get_name(),headimgurl=player:get_headimgurl()})
				if cb then
					cb(resp)
				end
			else
				local ec=global.errcode_util:get_errcode_CN(ec)
				    global._view:getViewBase("Tip").setTip(ec)
				global._view:hideLoading()
				-- logW("CS_OP_ROOM op 3 gameid %s errcode %s",gameid,ec)
			end
		end)
end

function MARK_CMD.req_rob_banker_info(mgr,isrequest,...)
	local t = {...}
	if isrequest then
		return mgr:req_rob_banker_info(...)
	else
			local playerid = t[1]
	end
	return 0
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
				logI("CS_OP_ROOM errcode op 8 "..ec)
			end

			if cb then
				cb(t,ec)
			end
		end)
end


function MARK_CMD.req_drop_banker(mgr,isrequest,...)
	local t = {...}
	if isrequest then
		return mgr:req_drop_banker(...)
	else
			local playerid = t[1]
	end
	return 0
end
--[[
	下庄
]]
function mt:req_drop_banker(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=12},function(resp)
			self:on_net_action({
				errcode = resp.errcode,
				op_type = 1,
				})

		end)
end

function MARK_CMD.req_push_over(mgr,isrequest,...)
	local t = {...}
	if isrequest then
		return mgr:req_push_over(...)
	else
		local playerid = t[1]
	end
	return 0
end

-- 推倒
function mt:req_push_over(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=13},function(resp)
		self:on_net_action({
				errcode = resp.errcode,
				op_type = 2,
				})
		end)
end


--[[
	状态改变返回数据
	data = {
		bout 				: int 	局数
		game_status 		:
		over_time 			:
		liuju 				: int 	流局
		daobang 			: bool 	倒帮
		player_max_coin 	: int 玩家最大下注

		bet_users :{
			{
				player_name
				playerid
				result_money
				headimgurl
			}
		}

		bet_playerids:{
			playerid :int 
		}
	}
]]
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
		data.banker_playerid = d.banker_playerid

		if d.game_status == const.WATER_STATUS_FREE then
		 	data.bout = d.bout
		 	data.use_cards,data.last_card = gen_history(resp)
			data.bet_users = {}
		 	local info=resp.bet_users[1]
		 	if info then
		 		data.liuju = info.playerid or 0 -- 1为流局
		 		-- if info.param2 > 0 then
		 			data.player_max_coin = info.param2 -- 玩家最大下注
		 		-- end
		 	end
		 	local bankerinfo=resp.bet_users[2]
		 	if bankerinfo then
		 		-- data.banker_name = bankerinfo.player_name -- 庄家名称
		 		-- data.banker_playerid = bankerinfo.playerid
		 		-- data.headimgurl = bankerinfo.param1 -- 庄家头像
		 		data.player_max_coin = bankerinfo.param2 -- 玩家最大下注
		 	end

		 	-- 倒帮
		 	if resp.result_card == 1 then
		 		data.daobang = true
		 	end
		elseif d.game_status == const.WATER_STATUS_BET then
			local info=resp.bet_users[1]
		 	-- data.banker_name = info.player_name -- 庄家名称
		 	-- data.banker_playerid = info.playerid
		 	-- data.headimgurl = info.param1       -- 庄家头像
		 	data.player_max_coin = info.param2 -- 玩家最大下注

		elseif d.game_status == const.WATER_STATUS_TRIM then -- 理牌阶段
			-- 服务端牌的信息
			data.water_cards = gen_card_bet_users(resp)
			data.bet_playerids = gen_bet_playerids(resp)
			data.card_type = resp.card_type -- 特殊牌型，0表示普通牌型
				-- print('------------------理牌时段----------')
		-- dump(data)
		elseif d.game_status == const.WATER_STATUS_COUNT then -- 开牌前的数据统计
		elseif d.game_status == const.WATER_STATUS_OPEN then
		 	-- 发牌时段
			data.bet_users = gen_result_bet_users(resp)
			data.cards_users = gen_result_cards_users(resp)

		
		 end

		 if(global._view:getViewBase("Sanshui")~=nil)then
			global._view:getViewBase("Sanshui").setRoomBtnState(data);
		 end
	end
end

--[[
	理牌成功后广播
	info = {
		playerid:int  玩家id
	}
]]
function mt:on_net_trim( resp )
	local playerid = resp.playerid
		if(global._view:getViewBase("Sanshui")~=nil)then
		global._view:getViewBase("Sanshui").PlayerToCard(playerid);
	end
end

--[[
	退出房间成功后广播
	info = {
		playerid:int  玩家id
	}
]]
function mt:on_net_exit_room( resp )
	local playerid = resp.playerid
	if(global._view:getViewBase("Sanshui")~=nil)then
		global._view:getViewBase("Sanshui").OutPlayData(playerid);
	end
end

--[[
	进入房间广播
	{
		["errcode"] = 0,
	  	["members"] = {
	    [1] = {
	      ["player_name"] = "yk_1513680107",  string
	      ["headimgurl"] =                    string
	      ["RMB"] = 148.4,                    float
	      ["money"] = 1909,                   float
	      ["playerid"] = 10028,               int
	    },... 
	    当进入是自己本人时，将返回所有在房间内的所有人的信息
	    其他人将返回刚进入房间的人的信息
  }
]]
function mt:on_net_enter_room(resp )
	local ret = gen_enter_room(resp)
	if(global._view:getViewBase("Sanshui")~=nil)then
		global._view:getViewBase("Sanshui").EnterPlayData(ret);
	end
end

--[[
	下注广播
	info = {
		--bet_pos  	: 		int 下注位置
		money 	: 		int 下注金额
		own_money:      int 剩余的钱
		player_name : 		string 下注玩家名称
		playerid 	: 		int 玩家id
		headimgurl 	: 		string 下注玩家链接
	}
]]
function mt:on_net_update_bet( resp )
		local info = gen_bet(resp)
		local list ={
			player_name = info.player_name,
			msg = info.player_name.."下注" .. info.bet_money,
			from_headid=info.headimgurl,
			own_money = info.own_money,
			playerid = info.playerid,
		}

		local who = 0
		if(info.player_name ~= global.player:get_name()) then
			who = 1
		end

		if(global._view:getViewBase("Sanshui")~=nil)then
			global._view:getViewBase("Sanshui").updateBetAreaCoin(info);
		end

		if(global._view:getViewBase("Chat")~=nil)then
			global._view:getViewBase("Chat").UpdateMessage(list,who);
		end
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
	local list ={
		player_name = resp.player_name,
		msg = resp.player_name.."抢庄！抢庄金額:"..resp.coin,
		from_headid=resp.headimgurl,
	}

	if(global._view:getViewBase("Chat")~=nil)then
		local who = 0
		if(resp.player_name ~= global.player:get_name()) then
			who = 1
		end
		global._view:getViewBase("Chat").UpdateMessage(list,who);
	end
end

--[[
	广播下庄，推倒
	op_type int 类型 1:下庄 2:推倒
]]
function mt:on_net_action(resp)

	local ec = resp.errcode
	if ec == 0 then
		local data = self.data
		if resp.op_type == 1 then -- 下庄
			data.bout = 1
		 	data.use_cards = {}

	 		clear_banker(data)
		elseif resp.op_type == 2 then -- 推倒
			data.use_cards={}
			if data.play_type == 1 then
				clear_banker(data)
			elseif data.play_type == 2 then -- 抢庄
				data.bout = data.bout + 1

				if data.bout > data.bout_amount then
					data.bout = 1
					clear_banker(data)
				end
			end

		end
		-- ui处理逻辑
		if(global._view:getViewBase("Sanshui")~=nil)then
			global._view:getViewBase("Sanshui").DownBankerAction(data,resp.op_type);
		 end
	else
		global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
		-- logI("CS_OP_ROOM errcode op 12 "..ec)
	end
	global._view:hideLoading()
end

-----------------------------------------------------------------------------------------------------

return mt