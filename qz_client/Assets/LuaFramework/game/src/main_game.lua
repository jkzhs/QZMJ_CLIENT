--
-- Author: wangshaopei
-- Date: 2017-03-08 18:09:07
-- --

local game_init = require "game_init"
-- Network = require "Network"
-- local json = require "cjson"
-- local crypt = require("crypt")
local global = require("global")
-- local _view = require("View");
-- local socket = require "app.socket"
-- local SceneManager=UnityEngine.SceneManagement.SceneManager
main_game = {}
local this = main_game
local logictimer=logictimer

function main_game.init()
	game_init.stage1()

	-- AppConst.Port1 = 9001;
	Port1 = 9001
	AppConst.SocketPort = 7001;
	AppConst.SocketAddress =  global.config.SocketAddress
    -- print((">> Address:%s Port:%s"):format(AppConst.SocketPort,AppConst.SocketAddress))
	UpdateBeat:Add(update_beat, this)
	this.time_server=Timer.New(this.update_ts,1, -1)
	this.time_server:Start()

    global._view:start();
	-- easy.scenes.scene_loaded(OnSceneLoaded,true)
	-- easy.scenes.scene_unloaded(OnSceneUnLoaded,true)

	-- global.mgr_scene.load_scene("login")


	-- 测试代码
	game_init.stage2()
	-----------------------------------------------

end

function main_game.timeEvent()
	global._view:timeEvent()
end

-- loginscene = require("app.scene.loginscene")
function update_beat()
	local dt = Time.deltaTime
	-- global._view:timeEvent()
	-- print("deltaTime:",dt)

	-- print("unscaledDeltaTime:",Time.unscaledDeltaTime)

	-- 	UpdateBeat:Remove(update_beat, main_game)
	-- 	print("···55556",Time:GetTimestamp(),a)

	logictimer.dispatch_timertask(dt)
end

function main_game.update_ts()
	--更新时间
	local ts_new = global.ts_service:ts_get()
	if ts_new > global.ts_now then
		-- print("···",ts_new)
		global.ts_now = ts_new
	end

	local ok, err = global.network:nw_update()
end

function OnSceneLoaded( scene,mode )
	-- print("···11122",mode:ToInt())
	if scene.name == "login" then
		-- print("login scene loaded!")
		-- LoginPanel = require("app.ui.login.LoginPanel")
		-- loginscene = require("app.scene.loginscene")
		game_init.stage2()
	end
	global.mgr_scene.Loaded(scene.name)

	logI("scene loaded %s",scene.name)
	-- dump(scene)
end

function OnSceneUnLoaded( scene)
	global.mgr_scene.UnLoaded(scene.name)

	logI("scene unloaded %s",scene.name)

end

main_game.init()

return main_game