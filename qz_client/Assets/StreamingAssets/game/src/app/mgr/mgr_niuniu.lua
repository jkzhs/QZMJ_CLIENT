--
-- Author: wangshaopei
-- Date: 2017-05-27 15:08:56
--

local global = require("global")
local player = global.player
local const = global.const
local errcode_util = global.errcode_util
local table_insert = table.insert
local tonumber=tonumber
local mt=class("mgr_niuniu")

local gameid = const.GAME_ID_NIUNIU

local function gen( resp )
	local t = {}
	t.game_status = resp.game_status
	t.over_time = resp.over_time
	-- t.bount = resp.bount
	t.bet_users = {}
	return t
end

local function gen_bet_users( resp )
	local t={}
	for k,v in ipairs(resp.bet_users) do
		table_insert(t,{
				player_name = v.player_name,
				playerid = v.playerid,
				cards = v.cards,
				result_money = tonumber(("%0.2f"):format(v.result_money)) ,
				headimgurl = v.param1,
			})
	end
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
	data.headimgurl = "" -- 庄家头像
	data.banker_playerid = nil
	data.player_max_coin = 0
end

function mt:ctor(player)
	self.data=nil

end

function mt:nw_reg()
	global.network:nw_register("SC_NIU_GETDATA", handler(self,self.update_data))
	global.network:nw_register("SC_NIUNIU_BET", handler(self,self.update_bet))
	global.network:nw_register("SC_OX_CARD_SHOW", handler(self,self.on_net_cardshow))
	global.network:nw_register("SC_OX_PUBLIC_ROB_BANKER", handler(self,self.on_net_rob_banker))

end

function mt:nw_unreg()
	global.network:nw_unregister("SC_NIU_GETDATA")
	global.network:nw_unregister("SC_NIUNIU_BET")
	global.network:nw_unregister("SC_OX_CARD_SHOW")
	global.network:nw_unregister("SC_OX_PUBLIC_ROB_BANKER")
end

--[[
	进入房间请求数据
	resp={
			errcode 			: int 错误码
			game_status 		: int 游戏状态
			over_time 			: int 状态结束时间
			amount_money 		: int 总下注的钱
			bet_users 			: arr 列表
					{
				 		player_name 	: string  					下注时间：庄家名称
				 		playerid 		: int 	  					下注时间：庄家的金币
				 		cards 			: string 					下注时间：庄家头像
				 		result_money 	: int 	 					下注时间：玩家最大下注
				 		param1 			: string 				 						 获取数据:房主名称
					}
		}
]]
function mt:req_data(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=1},function(resp)
			local ec = resp.errcode
			local data = nil
			if ec == 0 then
				data = gen(resp)
				local info=resp.bet_users[1]
				if info then
					data.house_owner_name = info.param1
				end
				data.game_status = resp.game_status
			 	data.over_time = resp.over_time
				data.bet_users = {}
				if data.game_status == const.OX_STATUS_BET then
					if info then
					 	data.banker_name = info.player_name -- 庄家名称
					 	data.banker_coin = info.playerid --庄家的金币
					 	data.headimgurl = info.cards -- 庄家头像
					 	data.player_max_coin = info.result_money -- 玩家最大下注
					 end
				end
			else
				logW("CS_OP_ROOM gameid %s errcode %s",gameid,ec)
			end
			if cb then
				cb(data)
			end
		end)
end

--[[
	请求下注

	in [
		@param1 coin int 筹码
		@param2 bet_type int 筹码类型 1:梭哈
	]
	out [
		resp={
			errcode 			: int 错误码，成功＝0
			coin 				: int  				// 下注的亚通币
	  		player_name 		:string
	  		amount_money 		:int32// 总下注的钱
	  		headimgurl 			:string
	   		bet_type  			:int32// 下注类型 1:梭哈
		}
	]

]]
function mt:req_bet(coin,bet_type,cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=2,param1=bet_type,param3=coin},function(resp)
			local ec = resp.errcode
			if cb then
				cb(resp)
			end
			if ec == 0 then
			-- 	self:update_bet(resp)
			-- 	if cb then
			-- 		cb()
			-- 	end
			-- 	-- dump(self.data)
			else
				logW("CS_OP_ROOM op 2 gameid %s errcode %s",gameid,global.errcode_util:get_errcode_CN(ec))
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
			self:on_net_rob_banker({coin=coin,
				player_name=player:get_name(),headimgurl=player:get_headimgurl()})
			if cb then
				cb(resp)
			end
			-- local ec = resp.errcode
			-- if ec == 0 then
			-- 	-- dump(self.data)
			-- else
			-- 	logW("CS_OP_ROOM op 3 gameid %s errcode %s",gameid,ec)
			-- end
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
			-- local ec = resp.errcode
			-- if ec == 0 then
			-- 	-- logI("SC_ROOM_MEMBERS gameid = %s roomid = %s ",resp.gameid,resp.roomid)
				-- local d=gen_members(resp)
				-- dump(d)
			-- 	if cb then
			-- 		cb()
			-- 	end
			-- else
			-- 	logI("CS_OP_ROOM errcode op 4"..ec)
			-- end
		end)
end

--[[
	获取抢庄信息
	resp＝{
		param1: int 牛牛:庄家最低分
		param2: int 牛牛:玩家最高下注
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
				-- logI("CS_OP_ROOM errcode op 8 "..ec)
				global._view:hideLoading()
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end
			if cb then
				cb(t,ec)
			end
		end)
end

--[[
	请求甩牌
]]
function mt:req_card_show()
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=9},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				self:on_net_cardshow({playerid=resp.param1})
			else
				-- logI("CS_OP_ROOM errcode op 9 "..ec)
				global._view:hideLoading()
				global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			end
		end)
end

--[[
	下庄
]]
function mt:req_drop_banker(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=12},function(resp)
		self:on_net_action({
				errcode = resp.errcode,
				op_type = 4,
				})
			if resp.errcode == 0 then
				if cb then
					cb()
				end
			end

		end)

end

--[[
	状态改变返回数据
	@param1 resp={
				errcode 			: int 错误码
				game_status 		: int 游戏状态
				over_time 			: int 状态结束时间
				amount_money 		: int 总下注的钱
				bet_users 			: arr 列表
					{
				 		player_name 	: string 开牌时间:玩家名称 					下注时间：庄家名称
				 		playerid 		: int 	 开牌时间:玩家ID 					下注时间：庄家的金币 	空闲:1为流局
				 		cards 			: string 开牌时间:逗号隔开“,” cards[1]~cards[5]为5张牌，cards[6]牛值，cards[7]枚举值OX_VALUE_TYPE 特殊牌类型
				 								 								下注时间：庄家头像
				 		result_money 	: int 	 开牌时间:金币增减					下注时间：玩家最大下注
				 		param1 : int 			开牌时间:头像链接
					}
			}
]]
function mt:update_data( resp )
	local data = self.data
	if not data then
		data = {}
		self.data = data
	end

	if resp.errcode == 0 then
		 -- local d = gen(resp)
		 data.game_status = resp.game_status
		 data.over_time = resp.over_time
		 data.bet_users = {}
		 data.daobang = false
		 data.liuju = 0
		 if data.game_status == const.OX_STATUS_FREE then
		 	local info=resp.bet_users[1]
		 	if info then
		 		data.liuju = info.playerid or 0 -- 1为流局
		 		data.daobang = info.result_money > 0 and true or false
		 	end

		 	local bankerinfo=resp.bet_users[2]
		 	if bankerinfo then
		 		data.banker_name = bankerinfo.player_name -- 庄家名称
		 		data.banker_playerid = bankerinfo.playerid
		 		data.headimgurl = bankerinfo.cards -- 庄家头像
		 		data.player_max_coin = bankerinfo.result_money -- 玩家最大下注
		 	else
		 		clear_banker(data)
		 	end
		 elseif data.game_status == const.OX_STATUS_BET then
		 	local info=resp.bet_users[1]
		 	data.banker_name = info.player_name -- 庄家名称
		 	-- data.banker_coin = info.playerid --庄家的金币
		 	data.headimgurl = info.cards -- 庄家头像
		 	data.player_max_coin = info.result_money -- 玩家最大下注
		 elseif data.game_status == const.OX_STATUS_OPEN then
		 	data.bet_users = gen_bet_users(resp)
		 	-- dump(data)
		 end
		 if(global._view:getViewBase("Room") ~= nil) then
		 	global._view:getViewBase("Room").setRoomBtnState(data)
		 end
		 -- local msg = global.mq_msg:mq_publish2(const.MSG_UI_NIUNIU_UPDATA)
		 -- msg.mm_obj = {op=1}
	end
end

--[[
	下注广播数据
	@param1 resp={
				coin 			: int 下注的亚通币
				player_name 	: string
				amount_money 	: int 总下注的钱
				headimgurl 		: string 头像
				bet_type		: int  下注类型 1:梭哈
			}
]]
function mt:update_bet( resp )
	if resp.errcode == 0 then
		local d={coin = resp.coin,
					player_name = resp.player_name,
					amount_money = resp.amount_money,
					url = resp.headimgurl,
					bet_type = resp.bet_type
				}
		if(global._view:getViewBase("Room") ~= nil) then
		 	global._view:getViewBase("Room").updateBetInfo(d)
		 end
		-- table_insert(self.data.bet_users,{chouma_index = resp.chouma_index})
		-- local msg = global.mq_msg:mq_publish2(const.MSG_UI_NIUNIU_UPDATA)
		-- local bet_users = self.data.bet_users
			-- msg.mm_obj = {
			-- 	-- bet_user = bet_users[#bet_users],
			-- 	bet_user = d,
			-- 	op = 0,
			-- }

		-- dump(d)
	end
end

--[[
	甩牌广播
	resp = {
		playerid:int 玩家id
	}
]]
function mt:on_net_cardshow(resp)
	local playerid = resp.playerid
	-- print("playerid",playerid)
	if(global._view:getViewBase("Room") ~= nil) then
	 	global._view:getViewBase("Room").Cardshow(playerid)
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
	if(global._view:getViewBase("Room") ~= nil) then
	 	global._view:getViewBase("Room").RobBroadcast(resp)
	end
end

--[[
	动作广播
	op_type int 类型 4:下庄广播
]]
function mt:on_net_action(resp)
	local ec = resp.errcode
	if ec == 0 then
		local data = self.data
		if resp.op_type == 4 then
			clear_banker(data)
			--下庄广播调用

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