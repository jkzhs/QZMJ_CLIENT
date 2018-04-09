--
-- Author: wangshaopei
-- Date: 2017-05-27 15:08:56
--
local global = require("global")
local player = global.player
local const = global.const
local table_insert = table.insert
local tonumber=tonumber
local mt=class("mgr_dealer")

function gen_info(resp)
	local t={}
	for i,v in ipairs(resp.members) do
		t[v.dealerid]={
			level = v.level,
			profit_rate = v.profit_rate,

		}
	end
	return t
end

function gen_member( resp )
	return {
		dealerid = resp.dealerid,
		level = resp.level,
		profit_rate = resp.profit_rate,
		invite_code = resp.invite_code,
		today_profit = tonumber(("%0.2f"):format(resp.today_profit)),
		all_profit = tonumber(("%0.2f"):format(resp.all_profit)),

	}
end

function gen_dealer_users( resp )
	local t={}
	for k,v in pairs(resp.members) do
		t[#t+1]=
		{
		  	playerid = v.playerid,
  			player_name = v.player_name,
  			coin = v.coin,
  			online = v.online,
		}
	end
	return t
end

function mt:ctor(player)
	self.data=nil
	self.myinfo=nil
	self.bills=nil
	self.data_users={}
end

function mt:clear()
	self.data_users={}
end

----------------------------------------------------------------
-- 数据更新相关
local MARK_CMD = {}
-- 请求更新
function mt:request_upgrade(cmd,...)
	local f = MARK_CMD[cmd]
	if not f then
		return
	end
	return f(self,true,...)
end

------------------------------------------------
-- 外部接口
-- 更新服务器数据
function mt:req(cmd,...)
	if not self:check_upgrade(cmd,true,...) then
		return false
	end
	return self:request_upgrade(cmd,...)
end

function mt:is_mark()
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
		-- return global.ui_facade:uf_show_not_enough_rmb()
	elseif ret == 2 then
		-- print("···222")
		-- print(i18n.TID_COIN_SILVER)
		-- KNMsg:flashShow(i18n.TID_CANCRASH_FLUSH_NOTE2)
	end
end

function mt:req_dealer_list(cb)
	global.player:call("CS_OP_DEALER",{op=1},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				-- print("···sddfff111")
				self.data = gen_info(resp)
				-- dump(self.data)
				if cb then
					cb()
				end
			else
				logI("CS_OP_DEALER errcode "..ec)
			end
		end)

end

function mt:req_dealer_users(start,count,cb)
	global.player:call("CS_OP_DEALER",{param1=start,param2=count,op=5},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local data_users=self.data_users
				-- self.data_users = gen_dealer_users(resp)
				for k,v in pairs(resp.members) do
					data_users[#data_users+1]=
					{
					  	playerid = v.playerid,
			  			player_name = v.player_name,
			  			coin = v.coin,
			  			online = v.online,
					}
				end
				if cb then
					cb()
				end
			else
				logI("CS_OP_DEALER errcode op 5"..ec)
			end
		end)

end

function mt:req_add_dealer(attach_playerid,profit_rate,cb)
	global.player:call("CS_OP_DEALER",{op=2,param1=attach_playerid,param2=profit_rate},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				if not self.data then
					self.data={}
				end
				local info = gen_member(resp.member)
				self.data[info.dealerid]=info
				if cb then
					cb()
				end
				global._view:getViewBase("Tip").setTip(global.i18n.TID_COMMON_OP_SUCCEE)
				 -- dump(self.data)
			else
				-- logI("CS_OP_DEALER op 2 errcode "..ec)
				global._view:getViewBase("Tip").setTip("错误："..ec)
			end
		end)
end

-- 绑定邀请码
function mt:req_agree_invite(code,cb)
	global.player:call("CS_OP_DEALER",{op=4,param1=code},function(resp)
			local ec = resp.errcode
			-- if ec == 0 then
				if cb then
					cb(resp)
				end
			-- else
				logI("CS_OP_DEALER op 4 errcode "..ec)
			-- end
		end)
end

function mt:req_base_data(cb)
	global.player:call("CS_OP_DEALER",{op=3},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				self.myinfo = gen_member(resp.member)
				if cb then
					cb()
				end
			else
				logI("CS_OP_DEALER op 3 errcode "..ec)
			end
		end)
end

function mt:req_data(cb)
	global.player:call("CS_OP_DEALER",{op=6},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local t = gen_member(resp.member)
				self.myinfo = t
				self.myinfo.dealer_num = resp.member.dealer_num
				self.myinfo.user_num = resp.member.user_num

				if cb then
					cb()
				end
			else
				logI("CS_OP_DEALER op 6 errcode "..ec)
			end
		end)
end

function mt:req_dealer_bills(cb)
	global.player:call("CS_OP_DEALER",{op=7},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local t = {}
				for k,v in pairs(resp.dealers) do
					local bills = {}
					for k,e in pairs(v.bills) do
						local coins = {}
						for k, coininfo in pairs(e.coins) do
							coins[coininfo.level]=coininfo.coin
						end
						bills[e.date] = coins
					end
					t[v.dealerid]={level=v.level,bills=bills}
				end
				self.bills = t

				-- dump(self.bills)

				if cb then
					cb()
				end
			else
				logI("CS_OP_DEALER op 7 errcode "..ec)
			end
		end)
end

function mt:is_dealer()
	if self.myinfo and self.myinfo.level > 0 then
		return true
	end
end

function mt:get_data()
	return self.data
end

function mt:get_info()
	return self.myinfo
end

function mt:get_bills()
	return self.bills
end

function mt:get_data_users()
	return self.data_users
end

function MARK_CMD.req_add_dealer(mgr,isrequest,...)
	if isrequest then
		return mgr:req_add_dealer(...)
	else

	end
	return 0
end

function MARK_CMD.req_dealer_list(mgr,isrequest,...)
	if isrequest then
		return mgr:req_dealer_list(...)
	else

	end
	return 0
end

function MARK_CMD.req_dealer_users( mgr,isrequest,... )
	if isrequest then
		return mgr:req_dealer_users(...)
	else

	end
	return 0
end

function MARK_CMD.req_dealer_bills( mgr,isrequest,...  )
	if isrequest then
		return mgr:req_dealer_bills(...)
	else

	end
	return 0
end

return mt