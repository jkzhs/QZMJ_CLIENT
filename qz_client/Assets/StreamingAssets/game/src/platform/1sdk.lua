--
-- Author: wangshaopei
-- Date: 2016-04-28 11:10:50
-- Filename: 1sdk.lua
--
--[[

]]

local global = require("global")
local i18n = global.i18n
local json = json
local config = global.config
local mgr_1sdk = global.mgr_1sdk
local timer 	= require("common.utils.Timer")
local dataeyeConst = require("platform.dataeyeConst")
local const_1sdk = require("const_1sdk")

local yijie

local M = {}

-- function M.init_user(appid,appkey)
-- 	local args = {
-- 					appid,
-- 					appkey
-- 				}
--     local sigs = "(Ljava/lang/String;Ljava/lang/String;)Z"

--     local ok,ret = luaj.callStaticMethod(molde_classname, "init_user", args, sigs)
--     if not ok then
--         print("==== luaj error init_user ==== ",ret)
--         return false
--     end
--     if not ret then
--     	print("==== The init_user return is:", ret)
--     	return false
--     end
--     return true
-- end

function M.init( )
	mgr_1sdk:init()
	M.last_login_userid=nil
end

local restart = function ()
	timer:runOnce(function(dt,data,timerid)
					app.restart()
				end,nil,0.2)
end

function M.login(cb, show_login_ui)
	if not config.USE_1SDK then
		return
	end
	local function login_cb ( data )
			if data["result"] == "success" then--登录成功
				-- 如何切换账号走登流程重启
				local productCode = data ["productCode"]
				local channelId = data["channelId"]
				local channelId_org = channelId
				local channelUserId = data["channelUserId"]
				local token = data["token"]
				local id = data["id"]
				local userName = data["userName"]
				mgr_1sdk:setChannelid(channelId)
				 channelId= string.gsub(channelId,"{","")
				 channelId= string.gsub(channelId,"-","")
				 channelId= string.gsub(channelId,"}","")
				global.account_data:set_sdkid(channelId)
				global.account_data:save_account(channelUserId, token)
				-- 渠道已登录
				if M.last_login_userid then
					local isre = true
					if M.last_login_userid == channelUserId then
						-- xy渠道会调用两次
						if const_1sdk.CHANNELID_XY == channelId_org then
							isre = false
						end
						if device.platform == "android" then
							isre = false
						end
					end
					if isre then
						restart()
					end
					return
				end
				M.last_login_userid = channelUserId
				-- dump(data)
				global.servers:load_cfg_guild(function (  )
					timer:runOnce(function(dt,data,timerid)
						global.login_api:on_login(channelUserId, token,cb)
					end,nil,0.2)
				end)


			elseif data["result"] == "fail" then--登陆失败
				-- dump(data)
				-- 如何切换账号登录失败
				global.account_data:set_sdkid("")
				if M.islogout then
					M.islogout = false
					app.restart()
					return
				end
				if cb then
					cb(true)
				end
			elseif data["result"] == "logout" then--登出回调
				if device.platform == "ios" then
					local channeid = mgr_1sdk:getChannelid()
					if channeid then
						 if channeid == "{AA41112D-0CCA498D}" -- aisi
						 	or channeid == "{3810E10B-F5E251E5}" -- tools
						 	or channeid == "{10BEDF27-31F29A71}" -- kuaiyong
						 then
							app.restart()
						else
							if const_1sdk.CHANNELID_TONGBU == channeid then
								global.switchscene("logo")
							end
							M.islogout = true
						end
					else
						M.islogout = true
					end
					global.account_data:set_sdkid("")
				else
					-- mgr_1sdk:logout()
					app.restart()
				end
			else
				global.KNMsg:boxShow(i18n.TID_LOGIN_ERROR_3RD_BACK, {
					confirmFun = function()
						app.restart()
					end
				})
			end
	end
	--不显示界面
	if not show_login_ui then
		local channelid = mgr_1sdk:getChannelid()
		if channelid and channelid == const_1sdk.CHANNELID_TONGBU or channelid == const_1sdk.CHANNELID_AYY then -- tongbu
			local account = global.account_data:get_account()
			local sdkid = global.account_data:get_sdkid()
			if account and sdkid and sdkid ~= "" then --存在帐号
				timer:runOnce(function(dt,data,timerid)
						-- restart后需要重新设置回调函数
						mgr_1sdk:set_login_listener(login_cb)
						M.last_login_userid = account.uid
						global.login_api:on_login(account.uid, account.token,cb)
					end,nil,0.2)
				-- return global.login_api:on_login(account, token,cb)
				return
			end
		end
	end

	-- 先退出登录
	local channelid = mgr_1sdk:getChannelid()
	if channelid then
		if channelid == const_1sdk.CHANNELID_AYY then
			local sdkid = global.account_data:get_sdkid()
			if sdkid == "" then
				if mgr_1sdk:ismarklogout() then
					mgr_1sdk:logout()
				else
					mgr_1sdk:set_ismarklogout(true)
				end
			end
		end
	end

	mgr_1sdk:login(login_cb)

end

function M.logout(cb)
	-- M.logout_(function ( msg )
	-- 	local msg = json.decode(msg)
	-- 	assert(msg,"msg nil")

	-- 	if msg.code == const_pf.MI_XIAOMI_GAMECENTER_ERROR_LOGINOUT_SUCCESS then
			-- yijie:logout("logout")
			-- global.login_api:on_logout(nil,cb)
	-- 	end
	-- end)
	mgr_1sdk:logout()
	global.login_api:on_logout(nil,cb)
end

function M.ischage_accout()
	return false
end
function M.is_auto()
	local channelid = mgr_1sdk:getChannelid()
	if channelid then
		-- tongbu
		if channelid == const_1sdk.CHANNELID_TONGBU or channelid == const_1sdk.CHANNELID_AYY then
			return true
		end
	end
	return false
end

function M.get_accounttype()
	local id = mgr_1sdk:getChannelid()
	if id == "{DD72FEA8-BCEE13F4}" then
		id = dataeyeConst.DC_Type1 -- 小米
	elseif id == "{F52F35C5-A04A1876}" then
		id = dataeyeConst.DC_Type2 -- "uc"
	elseif id == "{E7FDED80-15C8FD56}" then
		id = dataeyeConst.DC_Type3 --"360"
	elseif id == "{C826E32D-4F9C1C68}" then
		id = dataeyeConst.DC_Type4 --"hw"
	else
		id = dataeyeConst.DC_Anonymous
	end
	return id
end
-- function M.is_logined()
-- end

return M