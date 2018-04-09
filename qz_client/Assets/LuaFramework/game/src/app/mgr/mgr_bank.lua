--
-- Author: wangshaopei
-- Date: 2017-05-27 15:08:56
--
local global = require("global")
local player = global.player
local i18n = global.i18n
local const = global.const
local table_insert = table.insert
local mt=class("mgr_bank")

function gen_info(resp)
	t={}
	for i,v in ipairs(resp.members) do
		t[v.dealerid]={
			level = v.level,
			profit_rate = v.profit_rate,
		}
	end
	return t
end

function mt:ctor(player)
	self.data=nil
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
	-- if not self:check_upgrade("ask_watch",{op = 1}) then
	-- 	return false
	-- end
	-- return true
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
		-- return global.ui_facade:uf_show_not_enough_rmb()
	elseif ret == 2 then
		-- print("···222")
		-- print(i18n.TID_COIN_SILVER)
		global._view:getViewBase("Tip").setTip(i18n.TID_COIN_SILVER)
		-- KNMsg:flashShow(i18n.TID_CANCRASH_FLUSH_NOTE2)
	elseif ret == 4 then
		global._view:getViewBase("Tip").setTip(i18n.TID_COIN_TICKET)
	elseif ret == 3 then
		global._view:getViewBase("Tip").setTip(i18n.TID_COMMON_NOT_OPERATE_SELF)
	end
end

--[[
	@param1 mgr self 自己
	@param2 isrequest bool 是否请求类型
	@param3 ... 参数同 mt:req_transfer()
]]
function MARK_CMD.req_transfer(mgr,isrequest,...)
	local t = {...}
	if isrequest then
		return mgr:req_transfer(...)
	else
			local playerid = t[1]
			local coin = t[2]
			local type = t[3]

			if playerid == player:get_playerid() then
				return 3
			end
			if type == 1 then
				if coin and player:get_RMB() < coin then
					return 1
				end
			elseif type == 0 then
				--todo
				if coin and player:get_money() < coin then
					return 2
				end
			elseif type == 2 then
				if coin and player:get_ticket() < coin then
					return 4
				end
			end

	end
	return 0
end

-- 转账
--[[
	type int 0:银币 1:金币 2:房卡
]]
function mt:req_transfer(playerid,coin,type)
	global._view:showLoading();
	global.player:call("CS_Transfer",{playerid=playerid,coin=coin,type=type},function(resp)
			local ec = resp.errcode
			global._view:hideLoading();
			if ec == 0 then
				-- print("转账成功")
				if global._view:getViewBase("People") then
					global._view:getViewBase("People").update_data()
					global._view:getViewBase("Tip").setTip(i18n.TID_BANK_TRAN_SUCCEE)
				end

				if global._view:getViewBase("GameLobby") then
					global._view:getViewBase("GameLobby").update_data()
				end
				-- 更新人物信息
				if(global._view:getViewBase("Room") ~= nil) then
				 	global._view:getViewBase("Room").updatePlayerInfo()
				end

			else
				local ec=global.errcode_util:get_errcode_CN(ec)
				global._view:getViewBase("Tip").setTip(ec)
			end
		end)

end

function mt:get_data()
	return self.data
end



return mt