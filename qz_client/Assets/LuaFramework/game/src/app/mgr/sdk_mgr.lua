--
-- Author: Anthony
-- Date: 2014-10-22 11:15:52
-- Filename: sys_mgr.lua
-- 服务管理器

local global = require("global")
local const = global.const
local config = global.config
local player = global.player
local json = require "cjson"
local crypt = require "crypt"

local M = {}
local isandroid
function M:sm_init()
	isandroid = Util.is_android()
	return self
end

function M:share(ntype,desc,filepath,title,url)
	if not url then
		url = config.APP_DOWN_URL
	end
	if isandroid then
		resMgr:share(ntype,desc,filepath,url,title)
	else
		gameMgr:share_msg(ntype,title,desc,url,filepath)
	end
end

function M:can_use()
	if isandroid then
		return true
	else
		local is_installed = gameMgr:is_WXAppInstalled()
		local is_support = gameMgr:is_WXAppSupportApi()
		if is_support and is_installed then
			return true
		end
	end
end

function M:login( cb )
	gameMgr:login_sdk(function ( data )
			if cb then
				cb()
			end
		end)
end

function M:req_pay_info(paytype,fee,cb)
	if paytype == const.PAY_TYPE_BANK then
		local real_fee = fee*100
		if config.TEST_PAY then
			real_fee = fee
		end
		player:call("CS_PAY_INFO",{paytype = paytype},function(resp)
			local ec = resp.errcode
			if ec == 0 then
				local plat = global.login_api:get_platform() or "lwt"
				local account = global.account_data:get_account()
				local data = {
					id = resp.userid,
					fee = real_fee,
					ext = ("%s|%s|%s"):format(player:get_playerid(),plat,account.uid),
				}
				data =  json.encode(data)
				-- print("···1",data)
				data = crypt.base64encode(data)
				-- print("···2",data)
				-- local url = ("%s?id=%s&fee=%s"):format()
				local url = ("%s?data=%s"):format(config.tl_pay,data)

				local t = {
					url = url,
					paytype = resp.paytype
				}
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
	end
end

function M:pay( url,paytype,cb)
	-- local url="https://qr.alipay.com/bax06385q32ssucugqxm00f1"
	if paytype == const.PAY_TYPE_ALIPAY then
		if isandroid then
			resMgr:h5Pay(url)
		else
			gameMgr:pay( url,paytype,"",function ( data )
				if cb then
					cb(data)
				end
			end)
		end
	elseif paytype == const.PAY_TYPE_WX then
		if isandroid then
			resMgr:WxPayH5(url,config.referer_url)
		else
			gameMgr:pay( url,paytype,config.referer_url,function ( data )
				if cb then
					cb(data)
				end
			end)
		end
 	elseif paytype == const.PAY_TYPE_BANK then
 		Application.OpenURL(url)
	end


end

return M
