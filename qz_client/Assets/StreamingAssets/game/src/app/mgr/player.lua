--
-- Author: wangshaopei
-- Date: 2017-04-16 01:50:11
--
local global = require("global")
local const = assert(global.const)
local config = global.config
local tonumber = tonumber


local mt={}
----------------------------------------------------------------
-- function mt:ctor()
-- 	self.m_properties = {}
-- end
----------------------------------------
function mt:init()
	local s = require("app.mgr.sys_mgr"):sm_init()
	sys_mgr = s.services
	for k,v in pairs(sys_mgr) do
		if v.init then
			v:init()
		end
	end
end
----------------------------------------------------------------
--[[
	得到管理器
	用法：	local mgr_heros = mt:get_mgr("hero")
 ]]
function mt:get_mgr( name )
	return sys_mgr[name]
end
----------------------------------------------------------------
-- basedata
function mt:init_basedata(data)
	self.m_properties = {
		playerid = data.playerid,
		-- aid 	= data.lineid,	-- area id
		sid 	= data.serverid,	-- server id
		name	= data.name,
		level 	= data.level,
		gender	= data.gender,
		-- exp 	= data.exp,
		RMB 	= tonumber(("%0.2f"):format(data.RMB)),
		money 	= tonumber(("%0.2f"):format(data.money)),
		ticket  = data.ticket,


		rmb2money_count			= data.rmb2money_count, --点金次数
		-- rmb2money_count_max		= data.rmb2money_count_max, --最大点金次数

		vip 			= data.vip,

		login_day  			= data.login_day, 	--登录天数
		headid  			= data.headid, 	--头像
		charge_sum			= data.charge_sum, 	--总充值
		charge_rmb_sum 				= data.charge_rmb_sum,
		-- day_charge_sum		= data.day_charge_sum,	--日充值
		-- buy_elite_count = data.buy_elite_count, --重置精英关卡次数

		createTime 	= data.createTime, -- 创建时间

		day_lottery_count	= data.day_lottery_count,
		day_ten_lottery_count = data.day_ten_lottery_count,
		daili 			= data.daili,
		headimgurl = data.headimgurl,
	}
	self.paytype = 0
	-- global.mgr_1sdk:setRoleData()
	-- global.mgr_1sdk:enterServer()
	-- dump(self.m_properties)
end

----------------------------------------
-- 玩家编号
function mt:get_playerid()
	return self.m_properties.playerid
end

function mt:get_name()
	return self.m_properties.name
end

-- 亚通银币
function mt:get_money()
	return self.m_properties.money
end

function mt:get_roomid( ... )
	return self.m_properties.roomid
end

-- 玩家头像链接
function mt:get_headimgurl( ... )
	return self.m_properties.headimgurl
end

function mt:get_daili()
	return self.m_properties.daili
end

-- 亚通金币
function mt:get_RMB()
	return self.m_properties.RMB
end

function mt:get_ticket()
	return self.m_properties.ticket
end

-- 亚通币
function mt:get_coin()
	return self:get_money()+self:get_RMB()
end

-- paytype  1:关闭
function mt:get_paytype()
	return self.paytype
end

function mt:set_paytype(type)
	 self.paytype = type
end

----------------------------------------
function mt:get_basedata(key)
	if key == nil then
		return self.m_properties
	end
	return self.m_properties[key]
end
----------------------------------------
function mt:set_basedata( key, value )
	self.m_properties[key] = value
end

function mt:create_role(userid, gender, name, headid, cb)
	-- local ret = crab:filter(name)
	-- if ret then --有使用非法字符
	-- 	return KNMsg:flashShowError(i18n.TID_ERROR_UNKONW_CHARACTER)
	-- end
	local msg = {lineid=nil, serverid=nil, userid=userid, gender=gender,name=name,headid=headid}
	self:call("CS_CREATE_ROLE",msg,function(resp)
		local ec = resp.error_code
		if ec == 0 then
			self.m_properties.name = name
			self.m_properties.gender = gender
			self.m_properties.headid = headid
			-- global.mgr_1sdk:setRoleData()
			-- global.mgr_1sdk:createrole()
			-- global.mgr_1sdk:enterServer()
			if cb then
				cb()
			end
		elseif ec == 1002 then
			-- return KNMsg:flashShowError(i18n.TID_ERROR_NAME_AREADY_USED)
		else--if ec == 1000 then
			-- return KNMsg:flashShowError(i18n.TID_ERROR_UNKONW_CHARACTER)
		end
	end)
end

function mt:create_room( conf ,cb)
	if self:get_roomid() then
		print("已有房间")
		return
	end

	local msg = {type = conf.type,bount = conf.bount}
	self:call("CS_CREATE_ROOM",msg,function(resp)
		local ec = resp.error_code
		if ec == 0 then
			self.m_properties.roomid = resp.roomid
			-- global.mgr_1sdk:setRoleData()
			-- global.mgr_1sdk:createrole()
			-- global.mgr_1sdk:enterServer()
			if cb then
				cb()
			end
		else--if ec == 1000 then
			-- return KNMsg:flashShowError(i18n.TID_ERROR_UNKONW_CHARACTER)
		end
	end)
end

function mt:req_query_name(playerid,cb)
	local playerid = tonumber(playerid) or 0
	if playerid == 0 then
		return
	end
	self:call("CS_QUERY_INFO",{playerid = playerid,op = 1},function(resp)
		-- local ec = resp.error_code
		local name = resp.param1
		if cb then
			cb(name)
		end

	end)
end

-- op :3 货币
function mt:req_query_info(op,playerid,cb)
	local playerid = tonumber(playerid) or 0
	if playerid == 0 then
		return
	end
	self:call("CS_QUERY_INFO",{playerid = playerid,op = op},function(resp)
		-- local ec = resp.error_code
		local t = {money=resp.param2,RMB=resp.param3}
		if cb then
			cb(t)
		end

	end)
end

local function gen_transfer_recode(resp)
	local l={}
	for k,v in pairs(resp.members) do
		local t = {}
		 t.to_name = v.to_name
		 t.to_playerid = v.to_playerid
		 t.role_id = v.role_id
		 t.role_name = v.role_name
 		 t.coin_type = v.coin_type
 		 t.amount = v.amount
 		 t.log_time = v.log_time
 		 l[#l+1]=t
	end
	return l
end

--[[
	in = [
		playerid
		count 			: 记录条数
		time 			: 开始时间，格式1505987910，os.time()获取，默认当天记录
	]
	out = [
		resp.members : arr 数组
		{
			to_playerid 			: int32
	 		coin_type 				:int32
	 		account_name 			:string
	 		amount 					:int32
	 		log_time 				:int32
	 		plat_name 				:string
	 		role_id 				:int32   汇款人ID
	 		role_name 				:string  汇款人名称
	 		to_name 				:string  收款人名称
		}
	]

]]
function mt:req_query_transfer(playerid,count,time,cb)
	self:call("CS_QUERY_INFO",{playerid = playerid,op = 2,param1 = count or 50 ,param2 = time},function(resp)
		-- local ec = resp.error_code
		-- local name = resp.param1
		local l = gen_transfer_recode(resp)
		-- dump(l)
		if cb then
			cb(l)
		end

	end)
end

-- local socket = require "socket"
-- function GetAdd(hostname)
--     local ip, resolved = socket.dns.toip(hostname)
--     local ListTab = {}
--     for k, v in ipairs(resolved.ip) do
--         table.insert(ListTab, v)
--     end
--     return ListTab
-- end

--[[
	paytype 				: int 支付类型 0:支付宝 1:微信
	fee 					: int 金额（单位分）
	name 					: string 商品名称
]]

function mt:req_order_create(paytype,fee,cb,name)
	local notify_url = self:get_pay_query_url(paytype)
	-- print("···1112",notify_url)
	local real_fee = fee*100
	if global.config.TEST_PAY then
		real_fee = fee
	end
	if paytype == 0 then
		self:call("CS_ORDER_CREATE",{paytype = paytype,fee=real_fee,notify_url=notify_url,name=name},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local t = {
					qr_code = resp.url,
					paytype = resp.paytype
				}
				-- dump(t)
				if cb then
					cb(t)
				end
			else
				-- logW("CS_ORDER_CREATE ,errcode %s %s",ec,paytype)
				local ec=global.errcode_util:get_errcode_CN(ec)
				global._view:getViewBase("Tip").setTip(ec)
				global._view:hideLoading()

			end

		end)
	elseif paytype == const.PAY_TYPE_WX then
		-- local ip = unpack(GetAdd(socket.dns.gethostname()))
		-- coroutine.start(function ( ... )
		-- 	-- local www = UnityEngine.WWW("http://www.7v66.com/paya/index_wx.php")
		-- 	local www = UnityEngine.WWW("http://www.7v66.com/paya/index_wx.php")
		-- 	coroutine.www(www)
		-- 	if www.error then
		-- 		print("error",www.error)
		-- 	end
		-- 	local t = {
		-- 			url = www.text,
		-- 		}
		-- 	if cb then
		-- 		cb(t)
		-- 	end
		-- 	-- Application.OpenURL(www.text)
		-- end)
		self:call("CS_ORDER_CREATE",{paytype = paytype,fee=real_fee,notify_url=notify_url,name=name},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local t = {
					qr_code = resp.url,
					paytype = resp.paytype
				}
				-- dump(t)
				if cb then
					cb(t)
				end
			else
				-- logW("CS_ORDER_CREATE ,errcode %s,%s",ec,paytype)
				local ec=global.errcode_util:get_errcode_CN(ec)
				global._view:getViewBase("Tip").setTip(ec)
				global._view:hideLoading()
			end
		end)
	elseif paytype == const.PAY_TYPE_BANK then


	end

end

--充值的url地址
function mt:get_charge_url()
	local port1 = Port1
	-- local add = AppConst.SocketAddress
    -- AppConst.SocketAddress = "192.168.1.111";
	-- local lineid,serverid = global.account_data:load_lastserver()
	-- local serverinfo = global.servers:getserverinfo(lineid,serverid)

	local ip, port = global.network:get_conneted_server()
	return ("http://%s:%s/charge_yc"):format(ip ,port1 or 0)
end

function mt:get_pay_query_url(paytype)
	local l
	if paytype == 1 then
		l = config.wx_pay_notify
	else
		l = config.yc_alipay_notify
	end
	-- local ip = "121.43.166.110" -- 正式服
	return l
end


function mt:reset()
	-- body
end

function mt:call(typename, body, cb)
	return global.network:nw_call(typename, body, cb)
end

return mt