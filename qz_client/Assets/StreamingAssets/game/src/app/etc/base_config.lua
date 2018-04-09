
-- local language_type = require "config.language_type"
local cfg = {
	-- COMMON_VER = "efun",

	--平台类型
	LOGIN_PLATFORM = "lwt",

	-- 禁止自动登录
	NO_AUTO_LOGIN = false,

	-- 1:微信 2:游客  其他:全部
	PACKAGE_TYPE = 3,

	-- app下载地址
	APP_DOWN_URL = "http://127.0.0.1/down/htdocs/",

	SocketAddress = "192.168.1.111",

	-- DEFAULT_LANGUAGE = assert(language_type.ChineseSimplified),
	SETTING = false,
	TEXTS_EXT = false,

	--资源web地址
	-- WEBSERVER_URL = "http://127.0.0.1/ud/",
	-------------
	-- 根据服务器的cfg.json获取 servers.lua
	-- SERVERLIST_URL = "", --服务器列表地址
	-- UPDATE_URL = "", --更新地址
	-- ATIVATE_URL = "", --激活码地址
	-- NOTIFYDATA_URL = "", --更新公告地址
	-- CHARGE_URL = "", --充值地址
	-------------

	--是否可以使用GM命令
	-- USE_GM_COMMAND = false,
	-- 版本更新开关
	-- is_check_update = true,

	--设置信息
	SETTING = {},
	--字典文件（包含多国语言）
	TEXTS_EXT = "app.common.dictionary",
}

return function(config, global)
	for k, v in pairs(cfg) do
		assert(not config[k], k)
		config[k] = v
	end

	-- config.SETTING.conf = require("appdata.setting_conf"):readfile(config.SETTING) --系统设置
end
