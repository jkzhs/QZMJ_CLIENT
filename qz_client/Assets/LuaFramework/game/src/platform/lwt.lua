--
local global = require("global")
local i18n = global.i18n

local M = {}

-- 平台登录
function M.login(cb, show_login_ui,is_no_call_3rd_sdk)
	global.account_data:set_sdkid(0)
	if not show_login_ui then --不显示登录界面，自动登录
		local account = global.account_data:get_account()
		if account and account.uid then --存在帐号
			global.login_api:on_login(account.uid, account.token,cb)
			return true
		end
	end

	-- 不调用第三方sdk
	if is_no_call_3rd_sdk then
		return
	end

	--显示登录界面
	global._view:login().Awake(function ( ac,pw )
		global._view:showLoading()
		global.account_data:save_account(ac,pw)
		global.login_api:on_login(ac,pw,cb)
		global.login_mgr:lgm_login_game()
	end)

end

function M.logout(cb)
	global.login_api:on_logout(nil,cb)
end

return M