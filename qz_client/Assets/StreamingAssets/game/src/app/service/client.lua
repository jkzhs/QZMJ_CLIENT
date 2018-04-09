--
-- Author: Albus
-- Date: 2015-10-16 11:53:30
-- Filename: client.lua
--
local global = require "global"
-- local KNMsg = assert(global.KNMsg)
local handler = assert(global.handler)
local i18n = assert(global.i18n)

local M = {}
function M:register()
	global.network:nw_register("SC_OFFLINE_NOTIFY", self.SC_OFFLINE_NOTIFY)
end

function M.SC_OFFLINE_NOTIFY(req)
	local kick_type = req.code
	-- print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	-- print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	-- print(" OFFLINE NOTIFY ",kick_type)
	-- print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	-- print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

	if global.network then
		global.network:nw_close()
	end
	-- local title = i18n.TID_ERROR_POP_UP_AUTO_DISCONNECTED_TITLE
	-- local msg = i18n.TID_ERROR_POP_UP_AUTO_DISCONNECTED
	local msg
	if kick_type == 2 then
		msg = i18n.TID_ERROR_POP_UP_AUTO_DISCONNECTED--i18n.TID_ERROR_KICK_ACOUNT_LOGIN
	elseif kick_type == 1 then
		msg = i18n.TID_ERROR_KICK_SERVER_MAINTENANCE
	else
		msg = i18n.TID_ERROR_POP_UP_AUTO_DISCONNECTED
	end
	if not global._view:getViewBase("Support") then
		global._view:clearFormulateUI("Support")
	end
	local confirmFun = function ( ... )
			global.player:reset()
			global._view:returnToLogin()
			-- app.restart() --重启app
		end
	if not global._view:getViewBase("Support") then
		global._view:support().Awake(msg,
			confirmFun,
			function ( ... )
				global._view:returnToLogin()
			end)
	end

	-- KNMsg:boxShow(msg, {
	-- 	confirmFun = function()
	-- 		global.player:reset()
	-- 		app.restart() --重启app
	-- 	end,
	-- })
end
return M