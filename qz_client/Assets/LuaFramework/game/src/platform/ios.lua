--
-- Author: wangshaopei
-- Date: 2016-08-19 17:15:30
--
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
local dataeyeConst = require("platform.dataeyeConst")

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

end

function M.login(cb, show_login_ui)

	--不显示界面
	if not show_login_ui then
		-- local account = global.account_data:get_account()
		-- if account then --存在帐号
		-- 	return global.login_api:on_login(account, token,cb)
		-- end
	end
		luaoc.callStaticMethod("RootViewController", "authenticateGameCenterPlayer", {loginListener = function (data)

			if data["code"] ==  tostring(0) then
				dump(data)
				local player_id =data["player_id"]
				local public_key_url = data["public_key_url"]
				local salt = data["salt"]
				local timestamp = data["timestamp"]
				local signature = data["signature"]
				global.account_data:save_account(player_id, signature)
				global.login_api:on_login(player_id, signature,cb)
			end
		end})
		-- global.account_data:save_account("1", "2")
		-- 		global.login_api:on_login("1", "1",cb)

end

function M.logout(cb)

	global.login_api:on_logout(nil,cb)
end

function M.ischage_accout()
	return false
end
function M.is_auto()
	return false
end

function M.get_accounttype()
	return dataeyeConst.DC_Type5
end
-- function M.is_logined()
-- end

return M