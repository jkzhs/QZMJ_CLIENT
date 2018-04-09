--
-- Author: Anthony
-- Date: 2014-10-22 11:15:52
-- Filename: sys_mgr.lua
-- 服务管理器

local global = require("global")

local M = {}
function M:sm_init()

	local ss = {
		{"scene", 		"mgr_scene"},
		{"room", 		"mgr_room"},
		{"niuniu",		"mgr_niuniu"},
		{"12zhi",		"mgr_12zhi"},
		{"dealer",		"mgr_dealer"},
		{"bank",		"mgr_bank"},
		{"chat", 		"mgr_chat"},
		{"charge", 		"mgr_charge"},
		{"paigow", 		"mgr_paigow"},
		{"yaolezi",     "mgr_yaolezi"},
		{"mail",    	 "mgr_mail"},
		{"water",     	 "mgr_water"},
		{"mj",    	     "mgr_mj"},

	}

	local services = {}
	for k,v in pairs(ss) do
		services[v[1]] = require("app.mgr."..v[2]).new(global.player)
		package.loaded["app.mgr."..v[2]] = nil
	end

	self.services = services

	return self
end

return M
