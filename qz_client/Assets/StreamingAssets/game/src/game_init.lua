--
-- Author: wangshaopei
-- Date: 2017-03-08 18:09:07
-- --

-- config
require "config"

-- framework int
require "easy.init"

-- game init
-- require "Common.define"
-- require "Common.functions"
require "unity.functions"
local string_gsub = string.gsub

--加载后释放句柄
local _require_ex = function(file)
	local f = require(file)
	package.loaded[file] = nil
	return f
end
require_ex = _require_ex

local global = require("global")

local function init_language()
	-- body
end

local m={}
local this=m

--配置
m.DIST_CONFIG = {
  LWT_DIST_DEV = "dev",
  LWT_DIST_BAISHOU = "baishou",
  LWT_DIST_BAISHOU_ON_TEST = "baishou_on_test",
  LWT_DIST_BAISHOU_DEV = "baishou_dev",
  LWT_DIST_NDD = "ndd",
  LWT_DIST_NDD_DEV = "ndd_dev",
}

function m.init_config( config )
	local cf= require "config"
	global.log(">>>>>>>>>>>>>>>>>>>> LWT_DIST:" .. tostring(cf.LWT_DIST))
	---------------------
	--基本配置
	local base_cfg_path = cf.ETC_PATH ..".base_config"
	local base_cfg_func = require(base_cfg_path)
	assert(type(base_cfg_func) == "function")
	base_cfg_func(config, global)
	--扩展配置
	local target_name = assert(this.DIST_CONFIG[cf.LWT_DIST], cf.LWT_DIST)
	local config_path = ("%s.%s_config"):format(cf.ETC_PATH,target_name)
	local overlay_cfg_func = require(config_path)
	assert(type(overlay_cfg_func) == "function", config_path)
	overlay_cfg_func(config, global)

	---------------------
	--version
	local version = require "version"
	config.script_version = version
	config.texts_path = "app.common.texts_CN"
	-- config.TEXTS_EXT = "app.common.dictionary"
	config.SETTING={
		LANGUAGE="CN"
	}
end

function m.stage1()
	global._view = require "View"
	global.timer = logictimer
	global.timer_sys = Timer
	global.log = print
	global.handler = handler
	global.errcode = require "sys.errcode"
	-- time
	global.get_time = os.time
	global.ts_service = require("sys.time_service"):ts_init()
	global.ts_now = global.ts_service:ts_get()

	-- const
	local const = require "const"
	global.const = const

	-- config
	local config = {}
	this.init_config(config)
	global.config = config

	reload_i18n(config)

	-- 数据配置管理
	local config_mgr = require("app.conf_mgr.config_mgr"):cm_init()
	global.config_mgr = config_mgr

	global.msgqueue = assert(require("app.common.msgqueue"))
	global.mq_msg = global.msgqueue.mq_create_ex(const.E_MSG)

	global.errcode_util = require "app.common.errcode_util"

	global.network = require("app.net.network")

	global.player = require("app.mgr.player")

	global.login_mgr = require("app.mgr.login_mgr"):lgm_init()

	global.mgr_scene = require("app.mgr.mgr_scene")
	package.loaded["app.mgr.mgr_scene"] = nil

	global.ui_mgr = require("app.mgr.ui_mgr")

	global.account_data = require("app.common.account_data")

	global.sdk_mgr = require("app.mgr.sdk_mgr"):sm_init()


	if config.PACKAGE_TYPE == 1 then
		-- 不支持微信或没安装切换为游客
		if not global.sdk_mgr:can_use() then
			config.LOGIN_PLATFORM="lwt"
			config.PACKAGE_TYPE = 2
		end
	end
	global.log(">>>>>>>>>>>>>>>>>>>> LOGIN_PLATFORM:" .. tostring(config.LOGIN_PLATFORM))

	global.login_api = require("platform.login_api"):login_init()

end

function m.stage2( ... )
	--需放到最后
	global.network:init()
	global.client_heartbeat = require("sys.client_heartbeat"):chb_init()
	require("app.service.service_mgr"):sm_init()

	-- stage2
	global.player:init()
end

function reload_i18n( config )

	local texts_path = config.texts_path
	package.loaded[texts_path] = nil
	local i18n = require(texts_path)
	if config.TEXTS_EXT then
		local ext = require_ex(config.TEXTS_EXT)

		local str2i18n = function(str)
			if not str or str == "" then
				return str
			end
			--特殊格式#{}
			return string_gsub(str, "#{(.-)}+",
					function ( s )
						if ext[s] then
							return ext[s][config.SETTING.LANGUAGE]
						else
							return str
						end
					end)
		end

		for k, v in pairs(i18n) do
			i18n[k] = str2i18n(v) or v
		end
	end
	global.i18n = i18n
	-- global.i18n = setmetatable(global.i18n, {
	--   __index = function(mytable, key)
	--   				if key == "TID_NETWORK_ERROR_400" then
	--   					return "sdfd111"
	--   				else
	--   					return "000oooo"
	--   				end
	--   			  -- local k = mytable[key]
	-- 		     --  return  global.str2i18n(k)
	-- 		  end
	-- })
	-- print("···2",global.str2i18n("#{SG000373}"))
	-- print("···1",global.i18n.TID_NETWORK_ERROR_400)
end

return m