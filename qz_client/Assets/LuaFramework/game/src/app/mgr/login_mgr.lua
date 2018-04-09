--
-- Author: Albus
-- Date: 2015-10-10 15:26:39
-- Filename: login_mgr.lua
--
local global = require("global")
local _view = require("View")
-- local i18n = global.i18n
local const = assert(global.const)
local handler = assert(global.handler)
-- local KNMsg = assert(global.KNMsg)
-- local ui_loading = assert(global.ui_loading)
local config = global.config
-- local dataeye_mgr = global.dataeye_mgr

local M = {}
function M:lgm_init()

  return self
end

-- 登陆
function M:lgm_login(show_login_ui,cb, reconnect)
	local show_login_ui_v = 0
	if show_login_ui then show_login_ui_v = 1 end
	local reconnect_v = 0
	if reconnect then reconnect_v = 1 end
	-- logI(">> lgm_login begin! %s %s",show_login_ui_v, reconnect_v)

	return self:_req_login(cb,show_login_ui,reconnect)
end

-- 登陆第三方帐号验证，获取账号等
function M:_req_login(cb,show_login_ui, reconnect)
	-- global.logf(">> _req_login begin!")
	-- ui_loading:loading_show()
	global.login_api:login(function (failed)
		-- ui_loading:loading_remove()
		if show_login_ui then
			--回调

			if cb then return cb(failed) end
		end

		if reconnect then
			if cb then return cb(failed) end
		end


		-- global.servers:download_serverlist(function()
		-- 	--回调
		-- 	if cb then return cb(failed) end
		-- end)

		return true
	end,show_login_ui)
end

--登出
function M:lgm_logout(cb)
	global.login_api:logout(function()
		if cb then
			cb()
		end
	end)
end

-- 登入游戏服务器
function M:lgm_login_game()

	-- local chosen_server = global.servers.v_chosen_server
	-- local serverinfo = global.servers:getserverinfo(chosen_server.aid,chosen_server.sid)
	-- if not serverinfo then
	-- 	print("lgm_login_game not has serverinfo!")
	-- 	return
	-- end

	local account = global.account_data:load_account()
	if not account.uid and account.uid == "" then
		-- print("lgm_login_game not has account!")
		return
	end

	-- local lineid, serverid = global.account_data:load_lastserver()
	-- if not lineid then
	-- 	print("lgm_login_game not has selected server!")
	-- 	return
	-- end
	local CMD = {
		onError  = function(error) -- 断开，连接等网络错误会返回
			-- 去掉 loading
			-- ui_loading:loading_remove()
			global._view:hideLoading()

		end,
		onEnterSucc = function(subid, nochange_scene)
			-- 请求登陆
			self:_send_login_request(subid, ac, nochange_scene)

		end,
	}

	global.log("login bengin")
	global.network:login({
			host 	= AppConst.SocketAddress,
			port 	= AppConst.SocketPort,
			server 	=  "game1",
			uid		= account.uid, -- 账号
			token	= account.token,
			serverid = 1, --选择的服务器编号
			plat	= global.login_api:get_platform() or "lwt", --平台标识
			sdkid 	= global.account_data:get_sdkid() or "unsdkid", --sdkid
			sign 	= Util.md5(account.uid..AppConst.login_secret),
		}, CMD)

end

--重连游戏服务器，需要走平台验证
function M:relogin_game(cb)
	self:lgm_login(false,function(failed)
		if not failed then
			self:lgm_login_game()
		end
		if cb then
			cb(failed)
		end
	end,true)
end

function M:set_login_game(b)
	self.is_login_game = b
end

function M:get_login_game()
	return self.is_login_game
end

function M:_send_login_request(uid, user, isreconnect)
	return global.player:call("CS_Login", {uid=uid,acc=user},function(resp)
		self:_on_login(resp,isreconnect)
	end)
end

function M:_on_login(resp,isreconnect)
	local player = global.player

	if resp.errcode == 0 then
		global.ts_service:ts_sync(resp.timestamp)
		global.ts_now = global.ts_service:ts_get()

		-- print("···",os.date("%Y-%m-%d %H:%M:%S",global.ts_now))
		-------------------------------
		-- 玩家基础数据
		-- resp.content.playerid = resp.playerid
		player:init_basedata(resp.basic)
		-- local account = global.account_data:load_account()
		-- local chosen_server = global.servers.v_chosen_server
		-- global.dataeye_mgr:send_event(const.DE_LOGIN,account.uid,chosen_server.servername)

		-- global.dataeye_mgr:send_event(const.DE_ACOUNTTYPE,global.login_api:get_accounttype())


		-- local basedata = player:get_basedata()
		-- for k,v in pairs(basedata) do
		-- 	if k == "level" then
		-- 		global.dataeye_mgr:send_event(const.DE_LEVEL,v)
		-- 	elseif k == "vip" then
		-- 		global.dataeye_mgr:send_event(const.DE_VIP,v)
		-- 	elseif k == "RMB" then
		-- 	elseif k == "money" then
		-- 	end
		-- end

		-- dump(player:get_basedata())

		--系统开放相关数据
		-- local data = {}
		-- for i,v in ipairs(resp.system) do
		-- 	data[v.id] = v.open
		-- end
		-- player:get_mgr("sysopen"):set_info(data)
		-----------------------------
		-- 公告数据
		-- global.log("ask chat")
		player:get_mgr("chat"):client_askinfo(function()
			-- global.log("ask chat ok")
		end)

		-------------------------------
		--放最后 建筑
		-- global.log("ask build")
		-- player:get_mgr("build"):_req_builds(function()
		-- 	global.log("ask builds ok")
		-- 	-- -------------------------------
		-- 	-- 成功 进入主页
		-- 	global.log("change to homescene")
		-- 	if player:isfristlogin() and (not config.NOT_USE_CG) then
		-- 		global.switchscene("cg",{ transitionType = "crossFade", time = 0.5})
		-- 	else
		-- 		local cando
		-- 		if not nochange_scene then --重连的某个处理不需要切换场景
		-- 			cando = true
		-- 		else
		-- 			if resp.basic.name == "" then
		-- 				cando = true
		-- 			end
		-- 		end

		-- 		--进入游戏后事件
		-- 		local function on_enter_game()
		-- 			--检测是否有离线冲值
		-- 			player:get_mgr("charge"):CheckChargeReq()
		-- 		end

		-- 		if cando then
		-- 			global.switchscene("home",{
		-- 					transitionType = "crossFade",
		-- 					time = 0.5,
		-- 					tempdata={
		-- 						callback=on_enter_game
		-- 					}
		-- 				})
		-- 		else
		-- 			on_enter_game()
		-- 		end
		-- 	end
		-- global.mgr_scene.load_scene("home")
		-- 	-- 去掉 loading
		-- 	ui_loading:loading_remove()
		-- end)

		-- 代理数据
		player:get_mgr("dealer"):req_base_data(function ()
			if resp.basic.name == "" then

			end
			-- 重连情况登录
			if isreconnect then
				global._view:hideLoading()
			end
			if not global._view:getViewBase("GameLobby") then
				global._view:gamelobby().Awake()
				--检测是否有离线冲值
				player:get_mgr("charge"):CheckChargeReq()
			end

			logI("login gameserver success, playerid:%d",player:get_playerid() )
		end)

	else
		-- global.KNMsg:boxShow(i18n.TID_NETWORK_ERROR_600, {
		-- 	confirmFun = function()
		-- 		app.restart()
		-- 	end
		-- })
	end
end

function M:lgm_show_login_menu()
  -- global.ui_facade:uf_hide_loading_hint()
  -- global.ui_facade:uf_show_login_menu()
end

--判断是否可以打开第二个故事，该故事在取完名字后。该做事结束后，会创建第一只武将
function M:check_show_second_story()
	local player = global.player
	--如果上次是创建角色时退出
	if not player:get_mgr("hero"):get_hero(const.first_hero) and player:get_name() ~= "" then
		global.ui_facade:uc_show_story_ui(800001,function()
			--未有改武将
			global.request.client:req_createhero(const.first_hero)
		end)
	end
end
-- function M:lgm_create()
--   global.log("call create")
--   -- global.request.login:req_create(global.login_api:get_platform(), global.login_api:get_region(), self._on_create, self)
-- end

return M