--
-- Author: wangshaopei
-- Date: 2017-11-06 10:48:19
--
local global = require("global")
local player = global.player
local const = global.const
local table_insert = table.insert
local MARK_CMD = {}
local gameid = const.GAME_ID_PAIGOW
local errcode_util = global.errcode_util
local config_paigow = global.config_mgr.get("paigow")

local mt=class("mgr_paigow")

-- 武牌
local cards_wu = {1,2, -- 至尊牌，武三，武六
				3,4,5,6,7,8,9,10 -- 武五～武九
			}

-- 文牌
local cards_wen = {
	11,12,13,14,15,16,17,18,19,20,21 -- 对牌，天牌～铜锤
}

local function gen_bet( resp )
	return {
			bet_pos = resp.bet_info.pos,
			bet_money = resp.bet_info.money,
			player_name = resp.player_name,
			headimgurl = resp.headimgurl,
	}
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

local function gen_bet_area( areas_card )
	local t={}
	for k,v in ipairs(areas_card) do
		local c = string.split(v.cards,",")
		t[v.a_index] = {tonumber(c[1]) ,tonumber(c[2]) }
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

function mt:get_data()
	return self.data
end

function mt:nw_reg()
	global.network:nw_register("SC_PAIGOW_GETDATA", handler(self,self.on_net_update_data))
	global.network:nw_register("SC_PAIGOW_BET", handler(self,self.on_net_update_bet))
	global.network:nw_register("SC_OP_PAIGOW_ACTION", function ( resp )
		self:on_net_action({
			errcode = 0,
			op_type = resp.op_type,
			})
	end )
	global.network:nw_register("SC_OX_PUBLIC_ROB_BANKER", handler(self,self.on_net_rob_banker))

end

function mt:nw_unreg()
	global.network:nw_unregister("SC_PAIGOW_GETDATA")
	global.network:nw_unregister("SC_PAIGOW_BET")
	global.network:nw_unregister("SC_OP_PAIGOW_ACTION")
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
		-- global._view:getViewBase("Tip").setTip(i18n.TID_COIN_GLOD)
		-- return global.ui_facade:uf_show_not_enough_rmb()
	elseif ret == 2 then
		-- print("···222")
		-- print(i18n.TID_COIN_SILVER)
		-- global._view:getViewBase("Tip").setTip(i18n.TID_COIN_SILVER)
		-- KNMsg:flashShow(i18n.TID_CANCRASH_FLUSH_NOTE2)
	elseif ret == 3 then
		-- global._view:getViewBase("Tip").setTip(i18n.TID_COMMON_NOT_OPERATE_SELF)
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
			play_type 			: int 玩法 1:自由坐庄 2:抢庄
			headimgurl 			: string 玩家头像链接
			player_max_coin 	: int  	 玩家最大下注
			banker_name 		； string 庄家名称
			banker_playerid 	: int  庄家头像
			house_owner_name 	： string 房主名称
			last_card { 		: 上一次出的牌
				[1]={[1] = 牌id,[2]}
				...
				[4]={[1] = 牌id,[2]}
			}
			use_cards {[1]...} : 使用的牌
			bet_area_cards  	:
			{
				[1] = {[1]=牌点数,[2]=牌点数} 庄家牌点数
				[2] 以下为下注区域牌点数
				..
				[4]
			}
			dices  				: table 骰子数
			{
				[1] = 骰子数
				[2]
				[3]
			}
		}
]]
function mt:req_data(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=1},function(resp)

			local ec = resp.errcode
			local data = nil
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
				if data.game_status == const.PAIGOW_STATUS_OPEN then

					data.bet_area_cards = gen_bet_area(resp.areas_card)

					local dices= resp.result_card -- 骰子数
					data.dices = {
						[1]=math.floor(dices/100) ,
						[2]=math.floor(dices%100/10),
						[3]=math.floor(dices%10) ,
					}
				 end
				self.data = data

			else
				global._view:hideLoading()
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
				-- logI("CS_OP_ROOM errcode "..ec)
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
	请求下注

	in [
		@param1 coin int 筹码
		@param2 pos int 位置
	]
	out [

	]

]]
function mt:req_bet(coin,pos,cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=2,param1=pos,param3=coin},function(resp)

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
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=3,param3 = coin},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				self:on_net_rob_banker({coin=coin,
					player_name=player:get_name(),headimgurl=player:get_headimgurl()})
			end
			if cb then
				cb(resp)
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
				-- dump(m)
				table.insert(t,m)
			else
				-- logI("CS_OP_ROOM errcode op 8 "..ec)
				global._view:hideLoading()
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end
			-- dump(t)
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
		dices  				: table 骰子数
		{
			[1] = 骰子数
			[2]
			[3]
		}
		bet_users :{
			{
				player_name
				playerid
				result_money
				headimgurl
			}
		}
		bet_area_cards:{
			[1] = {[1]=牌点数,[2]=牌点数} 庄家牌点数
			[2] 以下为下注区域牌点数
			..
			[4]
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

		if d.game_status == const.PAIGOW_STATUS_FREE then
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
		 		data.banker_name = bankerinfo.player_name -- 庄家名称
		 		data.banker_playerid = bankerinfo.playerid
		 		data.headimgurl = bankerinfo.param1 -- 庄家头像
		 		data.player_max_coin = bankerinfo.param2 -- 玩家最大下注
		 	else
		 		data.banker_name = nil
		 		data.banker_playerid = nil
		 		data.headimgurl = nil
		 		data.player_max_coin = nil
		 	end

		 	-- 倒帮
		 	if resp.result_card == 1 then
		 		data.daobang = true
		 	end
		elseif d.game_status == const.PAIGOW_STATUS_BET then
			local info=resp.bet_users[1]
		 	data.banker_name = info.player_name -- 庄家名称
		 	data.banker_playerid = info.playerid
		 	data.headimgurl = info.param1 -- 庄家头像
		 	data.player_max_coin = info.param2 -- 玩家最大下注

		 elseif d.game_status == const.PAIGOW_STATUS_OPEN then
			data.bet_users = gen_result_bet_users(resp)
			data.bet_area_cards = gen_bet_area(resp.history)

			local dices= resp.result_card -- 骰子数
			data.dices = {
				[1]=math.floor(dices/100) ,
				[2]=math.floor(dices%100/10),
				[3]=math.floor(dices%10) ,
			}
			-- dump(data)
		 end
		 -- dump(data)

		 if(global._view:getViewBase("PaiGow")~=nil)then
			global._view:getViewBase("PaiGow").setRoomBtnState(data);
		 end
	end
end

--[[
	下注广播
	info = {
		bet_pos  	: 		int 下注位置
		bet_money 	: 		int 下注金额
		player_name : 		string 下注玩家名称
		playerid 	: 		int 玩家id
		headimgurl 	: 		string 下注玩家链接
	}
]]
function mt:on_net_update_bet( resp )
		local info = gen_bet(resp)
		local posStr = ""
		if(info.bet_pos == 1) then
			posStr = "巡门头水"
		elseif(info.bet_pos == 2) then
			posStr = "巡门后档"
		elseif(info.bet_pos == 3) then
			posStr = "川门头水"
		elseif(info.bet_pos == 4) then
			posStr = "川门后档"
		elseif(info.bet_pos == 5) then
			posStr = "尾门头水"
		elseif(info.bet_pos == 6) then
			posStr = "尾门后档"
		end
		-- dump(info)
		local list ={
			player_name = info.player_name,
			msg = info.player_name.."下注".. posStr .. info.bet_money,
			from_headid=info.headimgurl,
		}
		local who = 0
		if(info.player_name ~= global.player:get_name()) then
			who = 1
		end

		if(global._view:getViewBase("PaiGow")~=nil)then
			global._view:getViewBase("PaiGow").updateBetAreaCoin(info,who);
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
		if(global._view:getViewBase("PaiGow")~=nil)then
			global._view:getViewBase("PaiGow").DownBankerAction(data,resp.op_type);
		 end
	else
		global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
		-- logI("CS_OP_ROOM errcode op 12 "..ec)
	end
	global._view:hideLoading()
end

-----------------------------------------------------------------------------------------------------

return mt