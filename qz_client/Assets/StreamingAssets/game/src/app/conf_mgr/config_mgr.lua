
local config_mgr = {}

function config_mgr:cm_init()
	return self
end

local cm = {}
local cm_pool = {} --pool

--根据type读取相应的配置文件管理器
local get_config = function(type)
	local d = cm_pool[type]
	if d then
		return d
	end

	d = cm[type]
	if d then
		d = d()
		cm_pool[type] = d
		return d
	end
end
config_mgr.get_config = get_config
config_mgr.get = get_config

function cm.ox()
	return require("app.conf_mgr.conf_mgr_ox")
end

function cm.paigow()
	local s = require "app.conf_mgr.conf_mgr_paigow"
	s.init()
	return s
end

return config_mgr
