--
-- Author: wangshaopei
-- Date: 2017-04-11 18:44:22
--
DEBUG = 1

return {
	--[[
		版本
		LWT_DIST_DEV 				-- 配置文件 dev_config.lua 开发配置
		LWT_DIST_BAISHOU 			-- 配置文件 baishou_config.lua 拜手棋牌
		LWT_DIST_BAISHOU_ON_TEST 	-- 配置文件 baishou_on_test_config.lua 拜手棋牌线上测试服
		LWT_DIST_BAISHOU_DEV		-- 配置文件 baishou_dev_config.lua 牛大大测试
		LWT_DIST_NDD 				-- 配置文件 ndd_config.lua 牛大大棋牌
		LWT_DIST_NDD_DEV 			-- 配置文件 ndd_dev_config.lua 牛大大测试
	]]
	LWT_DIST = "LWT_DIST_DEV",
	-- LWT_DIST = "LWT_DIST_DEV",
	ETC_PATH = "app.etc",
}