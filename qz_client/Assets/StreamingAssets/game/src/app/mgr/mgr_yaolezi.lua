--
-- Author: JK
-- Date: 2017-11-27 15:08:56
--
--[[1:获取数据  2:下注 3:抢庄 4:获取玩家列表
 5:获取大厅房间列表 6:邀请加入房间  8:取得抢庄信息
  9:甩牌 10:获取邀请房间列表 11:12支选择牌 12:12支下庄
  13:摇乐子:获取申支信息 14：申支
  ]]
local global = require("global")
local player = global.player
local const = global.const
local table_insert = table.insert
local mt=class("mgr_yaolezi")

local gameid = const.GAME_ID_YAOLEZI
local errcode_util = global.errcode_util
local function gen( resp )
	local t = {}
	t.game_status = resp.game_status
	t.over_time = resp.over_time
	if resp.bout then 
		t.bout = resp.bout
	end 
	if resp.play_type then 	
		t.play_type = resp.play_type
	end 
	-- t.history ={}
	-- t.bet_users={}
	-- for i,v in ipairs(resp.history) do
	-- 	t.history[i]=v.cardid
	-- end
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
local function gen_result_bet_users (resp)
	local t = {}
	for k , v in ipairs(resp.result_bet)do 	
		table_insert (t,{
			player_name = v.player_name,
			playerid = v.playerid,
			result_money = tonumber(("%0.2f"):format(v.result_money)) ,
			headimgurl = v.param1,
		})
	end 
	return t 
end
local function gen_data_info(info)
	local t={}
	t.name = info.player_name
	t.playerid = info.playerid 
	t.headimgurl = info.param1
	t.max_coin = info.param2 
	return t 
end 
local function gen_result_card (result_cards)
	local data ={}
	data.res1 =result_cards[1].cardid
	data.res2 =result_cards[2].cardid
	data.res3 =result_cards[3].cardid
	return data 
end 

local function gen_history(historys)
	local data = {}
	data.res1 = historys[1].cardid
	data.res2 = historys[2].cardid
	data.res3 = historys[3].cardid

	return data
end 

local function gen_bet(resp)
	local t ={bet_list={},player_name=nil,headimgurl=nil}
	for k,v in pairs(resp.bet_list) do
		t.bet_list[#t.bet_list+1]={pos = v.pos, money = v.money}
	end
	t.player_name = resp.player_name
	t.headimgurl = resp.headimgurl
	t.playerid = resp.playerid 
	return t
end


function mt:nw_reg()
	 global.network:nw_register("SC_YAOLEZI_GETDATA",handler(self,self.on_net_update_data))
	 global.network:nw_register("SC_YAOLEZI_BET",handler(self,self.on_net_update_bet))
	 global.network:nw_register("SC_OX_PUBLIC_ROB_BANKER", handler(self,self.on_net_rob_banker))
	 global.network:nw_register("SC_PUBLIC_SHEN_ZHI",handler(self,self.on_net_shen_zhi))

end
function mt:nw_unreg()
	global.network:nw_unregister("SC_YAOLEZI_GETDATA")
	global.network:nw_unregister("SC_YAOLEZI_BET")
	global.network:nw_unregister("SC_OX_PUBLIC_ROB_BANKER")
	global.network:nw_unregister("SC_PUBLIC_SHEN_ZHI")
end
--[[
	进入房间请求数据
	resp={
		    errcode=,                --int 错误码
			game_status=,            --int 状态
			ovre_time=,              --int 状态时间
			histroy={{cardid=，}}    -- 历史记录
			bout=,                   --int 现在第几局
			bout_amont=,             --int 一轮总局数
			play_type=,              --int 游戏类型：1自由模式 2抢庄模式
			house_owner_name=,       --string
			bet_users={{info}}       --玩家信息：[1]是庄家 		
			shenzhi_bet_users{{info}} --放支人信息

			get_fangzhi_info = {betinfo} --放支下注
			get_nazhi_info = {betinfo}   -- 拿支下注
			get_bet_info = {betinfo}     -- 下注


                              ------------------------------------------------------------------
                              cardid=,                        --int 结果
			                  info = {
			                             player_name=,        --string 
				                         param1=,             --string 头像
				                         param2=,             --int    玩家最大下注
				                         playerid=,           --int 
							  }
							  betinfo = {
								  posid =  int
								  money   =  int 
								  playerid=  int 
							  }
		}
	------------------------------空闲 free---------------------------------
	resp+={
		daobang=,                  --int 1倒帮 0不倒
	}
	------------------------------放支 fangzhi-----------------------------

	------------------------------下注 bet---------------------------------
	resp+={
		result_bet[1]= {info}      
								   -------------------------------------------
								   info = {param2 = ,      --int 单字能拿支数 }

	}
		------------------------------开牌 Open---------------------------------
	resp+={
		result_cards={},              --{cardid=,} *3
		result_bet = info          --开奖结果
									-------------------------------------
									cardid=,        int 
									ifno={
										playerid = 
										player_name = 
										param1 = --头像
										result_money = 

									}
	}
]]
function mt:req_data(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=1},function(resp)	 
		local ec = resp.errcode
		if ec == 0 then
			local data = gen(resp)--game_status , over_time , bout，play_type
			data.bout_amount = resp.bout_amount
			data.house_owner_name = resp.house_owner_name
			--庄家信息
			local info=resp.bet_users[1]			
			if info then
				-- data.banker_name = info.player_name -- 庄家名称
				-- data.headimgurl = info.param1 -- 庄家头像
				-- data.player_max_coin = info.param2 -- 玩家最大下注
				-- data.banker_playerid = info.playerid -- 庄家ID
				data.banker = gen_data_info(info)
			end
			--放支人信息
			local info_2 = resp.shenzhi_bet_users[1]
			if info_2 then 
				data.fangzhi=gen_data_info(info_2)
			end 
			--开牌历史记录
			if #resp.history>0 then				
				data.history =gen_history(resp.history)
			end 	

			--更新下注信息
			local fangzhi_info = resp.get_fangzhi_info 
			if fangzhi_info then 
				data.fangzhi_info = fangzhi_info
			end 
			local bet_info = resp.get_bet_info
			if bet_info then 
				data.bet_info = bet_info 
			end 
			local nazhi_info = resp.get_nazhi_info
			if nazhi_info then 
				data.nazhi_info = nazhi_info
			end 

			if data.game_status == const.YAOLEZI_STATUS_FREE then 
				if resp.daobang==1 then 
					data.daobang=true
				else 
					data.daobang=false
				end 						

			elseif data.game_status == const.YAOLEZI_STATUS_FANGZHI then 
				--todo
				-- local info = resp.bet_users[2]
				-- if info then 
				-- 	-- data.shenzhi_name=info.player_name
				-- 	-- data.shenzhi_headimgurl=info.headimgurl
				-- 	-- data.shenzhi_max_coin=info.param2
				-- 	-- data.shenzhi_playerid=info.playerid

				-- 	data.fangzhi_data=gen_data_info(info)
				-- end 
			elseif data.game_status == const.YAOLEZI_STATUS_BET then 
				-- if resp.can_nazhi ==1 then 
				-- 	data.can_nazhi=true
				-- else 
				-- 	data.can_nazhi=false
				-- end 
				local info_3 = resp.result_bet[1]
				if info_3 then 
					data.fangzhi_max_number = info_3.param2 --单字可拿最大支数
				end 
			elseif data.game_status == const.YAOLEZI_STATUS_OPEN then 
				data.result_cards =gen_result_card(resp.result_cards)
				data.bet_users = gen_result_bet_users(resp) 
			end 

			self.data = data
			 -- dump(data)
			if cb then
				cb(data)
			end
		else
			global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			global._view:hideLoading()
			-- logI("CS_OP_ROOM errcode "..ec)
		end
	end)
end
--[[
	获取申支信息
	resp＝{
		param1: int 申支最低分
		param2: int 申支最高分
	}
]]
function mt:req_Shenzhi_info(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=13},function(resp)
		local ec =resp.errcode
		local t = {}
		if ec == 0 then 
			local m ={
				shenzhi_min_coin = resp.param1,
				shenzhi_max_coin = resp.param2,
			}
			table.insert(t,m)
		else 
			global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			global._view:hideLoading()
			-- logI("CS_OP_ROOM errcode op 8 "..ec)
		end 

		--dump(t)
		if cb then 
			cb(t,ec)
		end 
	end)
end 

-- 申支
--[[
	resp = {
		errcode int
	}
]]
function mt:req_shenzhi(coin,cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=14,param3=coin},function(resp)
		self:on_net_shen_zhi({
			coin=coin,
			player_name=player:get_name(),
			headimgurl=player:get_headimgurl(),
		})
		if cb then 
			cb(resp)
		end 
	end )
end 

--[[
	玩家申支广播
	resp = {
		coin : 抢的币
		player_name : string
		headimgurl : 玩家头像
	}
]]
function mt:on_net_shen_zhi( resp )
	if(global._view:getViewBase("YaoLeZi") ~= nil) then
	 	global._view:getViewBase("YaoLeZi").ShenZhicast(resp)
	end
end

--[[
	获取抢庄信息
	resp＝{
		param1: int 庄家最低分
		param2: int 玩家最高下注
	}
]]
--获取抢庄信息
function mt:req_rob_banker_info(cb)
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=8},function(resp)
		local ec =resp.errcode
		local t = {}
		if ec == 0 then 
			local m ={
				banker_min_coin = resp.param1,
				player_max_coin = resp.param2,
			}
			table.insert(t,m)
		else 
			-- logI("CS_OP_ROOM errcode op 8 "..ec)
			global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			global._view:hideLoading()
		end 

		--dump(t)
		if cb then 
			cb(t,ec)
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
	
	global.player:call("CS_OP_ROOM",{gameid=gameid,op=3,param3=coin},function(resp)
		local ec = resp.errcode 
		if ec == 0 then 
			self:on_net_rob_banker({
				coin=coin,
				player_name=player:get_name(),
				headimgurl=player:get_headimgurl(),
			})
			if cb then 
				cb(resp)
			end 
		else 
			global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
			global._view:hideLoading()
		end 
		
	end )
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
	if(global._view:getViewBase("YaoLeZi") ~= nil) then
		global._view:getViewBase("YaoLeZi").RobBroadcast(resp)
	end
end

--[[下庄]]

function mt:req_drop_banker(cb)
	global.player:call("CS_OP_ROOM",{gameid = gameid , op = 12},function(resp)
		self:on_net_action({
			errcode = resp.errcode,
			op_type = 3,
		})
		if resp.errcode == 0 then 
			if cb then 
				cb()
			end 
		end 
	end )		
end 

function mt:req_shake_shade(cb)
	global.player:call("CS_OP_ROOM",{gameid = gameid , op = 15},function(resp)
		self:on_net_action({
			errcode = resp.errcode,
			op_type = 4, 
			
		})
		if resp.errcode == 0 then 
			if cb then 
				cb ()
			end 
		end 
	end )
end 

--[[
	动作广播
	op_type int 类型 3：下庄广播 4:
]]
function mt:on_net_action(resp)
	local ec = resp.errcode
	local view = global._view:getViewBase("YaoLeZi")
	if ec == 0 then 
		local data = {}
		if resp.op_type == 3 then 
			data.bout = 1 
			data.banker_name = ""
			data.banker_playerid = 0 
			data.headimgurl = ""			
			if (view~=nil)then 
				view .LoseRobCallBack(data)
			end 
		elseif resp.op_type == 4 then 
		end 
	else 
		global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
		global._view:hideLoading()

	end 

end 




--[[
	data={
		errcode=,              --int 
		game_status=,          --int
		over_time=,            --int 

	}
	------------------空闲 free--------------------------
	data+= {
		bout = ,               --int 
		histroy=,              --{{cardid=,}} or nil
		bet_users=,            --{info={}}
		daobang=,              --int 1倒帮 0 不倒 (只发庄家)
						   ------------------------------
						   info={
							   is_liuju=,       --int 1流局 0无
							   param2=,         --int 玩家最大下注
							   --player_name=,    --string 庄家名字

						   }
						   cardid =              int 
	}
	------------------摇奖 shake-------------------------
	data+={
		bet_users=,             --{info={}}
						---------------------------------
						info={
							player_name =           stirng
		                    param1 =                string headimgurl
		                    param2 =                int  user_coin_max
		                    playerid =              int 
						}
	}
	-------------------放支 fangzhi-------------------------
	data+={
			bet_users=,             --{info={}}
						---------------------------------
						info={
							player_name =           stirng
		                    param1 =                string  headimgurl
		                    param2 =                int  user_coin_max
		                    playerid =              int 
						}
	}
	-------------------下注 BET-----------------------------
	data+={
		bet_users = {info}
						-----------------------------------
						info ={
							param2 =               int --单字最大拿取支数
						}
	-------------------开牌 open----------------------------
	data+={
		result_bet = {info}
		result_cards= {{cardid=,},}
						-----------------------------------
						info={  -- [1]为庄家
							playerid =            int 
							player_name =         string 
							param1 =              string   headimgurl
							result_money =        int      showmoney
						}
						cardid =                  int 

	}
	}
]]
-- 游戏状态更新
function mt:on_net_update_data(resp)
	local data =self.data
	if not data then 
		return
	end 
	local ec = resp.errcode
	if ec == 0 then 
		local data = gen (resp) --game_status , over_time ,bout 
		data.daobang = false
		data.liuju = 0 
		if data.game_status == const.YAOLEZI_STATUS_FREE then 
			-- data.bout =resp.bout
			if #resp.history>0 then				
				data.history =gen_history(resp.history)
			end 
			if resp.daobang ==1 then 
				data.daobang=true
			end 
			data.bet_users = {}
			local info = resp.bet_users[1]
			if info then 
				data.liuju = info.is_liuju or 0 
				if info.param2 > 0 then 
					data.player_max_coin = info.param2 --最大下注
				end 
				-- if info.player_name then 
				-- 	data.banker_name =info.player_name
				-- end 
			end	
			
		elseif data.game_status == const.YAOLEZI_STATUS_BANKER then 
		elseif data.game_status == const.YAOLEZI_STATUS_SHAKE then 
			local info =resp.bet_users[1]
			if info then 
				-- data.banker_name = info.player_name -- 庄家名称
				-- data.banker_playerid = info.playerid --庄家的id 
				-- data.headimgurl = info.param1 -- 庄家头像
				-- data.player_max_coin = info.param2 -- 玩家最大下注
				data.banker = gen_data_info(info)
			end 			
		elseif data.game_status == const.YAOLEZI_STATUS_SHENZHI then 

		elseif data.game_status == const.YAOLEZI_STATUS_FANGZHI then 
			local info = resp.bet_users[1]
			if info then 
				-- data.shenzhi_name=info.player_name -- 申支人的名称
				-- data.shenzhi_headimgurl=info.param1 -- 申支人的头像
				-- data.shenzhi_max_coin=info.param2  -- 申支人的冻结金额
				-- data.shenzhi_playerid=info.playerid -- 申支人的ID
				data.fangzhi = gen_data_info(info)
			end 

		elseif data.game_status == const.YAOLEZI_STATUS_BET then 
			local info = resp.bet_users[1]
			if info then 
				data.fangzhi_max_number = info.param2 --单字可拿最大支数
			end 
		elseif data.game_status == const.YAOLEZI_STATUS_OPEN then 
			data.result_cards = gen_result_card(resp.result_cards)
			data.bet_users = gen_result_bet_users(resp)
		end 

		if(global._view:getViewBase("YaoLeZi")~=nil)then
			global._view:getViewBase("YaoLeZi").SetBetState(data);
		end

	end 
		

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
function mt:req_bet(bet_list,op,cb)
	global.player:call("CS_YAOLEZI_BET",{bet_list=bet_list,op=op},function(resp)
		self:on_net_update_bet(resp)
		if (cb)then
			cb(resp,op)
		end
	end)

end
--[[
	下注广播
	info = {
		bet_list = {
			{
				pos : int 下注位置
				money : int 金额
			},
		}
		player_name : string 下注玩家名称
		headimgurl : string 下注玩家链接
		palyerid:    int    下注玩家ID
		op :         int 1:下注 2：放支 3：拿支
	}
]]
function mt:on_net_update_bet(resp)
	local ec = resp.errcode
	if ec == 0 then 
		local info = gen_bet(resp)
		local view = global._view:getViewBase("YaoLeZi")
		if view ~= nil then 
			if resp.op == 1 then --下注
				view.UpdateBetData(info)
			elseif resp.op == 2 then --放支
				view.UpdateFangzhiData(info)
			elseif resp.op == 3 then --拿支
				view.UpdateNaZhiData(info)
			end 
		end 
	else
		
	end 
end

function mt:ctor(player)
	self.data={}
end
function mt:get_data()
	return self.data
end 

return mt