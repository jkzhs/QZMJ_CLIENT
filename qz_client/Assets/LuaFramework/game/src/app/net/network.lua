--
-- Author: wangshaopei
-- Date: 2016-01-05 14:12:40
-- Filename: network.lua
--
--                       _oo0oo_
--                      o8888888o
--                      88" . "88
--                      (| -_- |)
--                      0\  =  /0
--                    ___/`---'\___
--                  .' \\|     |-- '.
--                 / \\|||  :  |||-- \
--                / _||||| -:- |||||- \
--               |   | \\\  -  --/ |   |
--               | \_|  ''\---/''  |_/ |
--               \  .-\__  '-'  ___/-. /
--             ___'. .'  /--.--\  `. .'___
--          ."" '<  `.___\_<|>_/___.' >' "".
--         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--         \  \ `_.   \_ __\ /__ _/   .-` /  /
--     =====`-.____`.___ \_____/___.-`___.-'=====
--                       `=---='
--
--
--     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
--               佛祖保佑         永无BUG
--				 心外无法         法外无心
------------------------------------------------------------------------------
-- cc.utils = require("framework.cc.utils.init")
------------------------------------------------------------------------------
local string = string
local protobuf = require("lib.protobuf")
-- require "3rd/pbc/protobuf"
local socket = require "app.net.socket"
local crypt = require "crypt"
local global = require("global")
-- local KNMsg = assert(global.KNMsg)
local handler = assert(global.handler)
-- local ui_loading = assert(global.ui_loading)
local i18n = assert(global.i18n)
local errcode_util = global.errcode_util
local errcode = global.errcode

------------------------------------------------------------------------------
--
local PACK_FORMAT = "proto.Packet cmd body"

local v_protolist = {}
local function register_files(files)
	for _,v in ipairs(files) do
		-- local addr = io.open(v, "rb")
		-- local buffer = addr:read"*a"
		-- addr:close()
		-- local buffer = cc.FileUtils:getInstance():getStringFromFile(v)
		-- protobuf.register(buffer)
		-- local path,name,suffix = string.match(v, "(.*/)(%w+).(%w+)")
		-- proto[name] = protobuf.decode("google.protobuf.FileDescriptorSet", buffer).file[1]
		local path = Util.DataPath..v;
	    local addr = io.open(path, "rb")
	    local buffer = addr:read "*a"
	    addr:close()
	    protobuf.register(buffer)
	end

	local cmdInfo = require("sys.cmd")
	package.loaded["sys.cmd"] = nil
	-- 注册所有包
	for k,v in ipairs(cmdInfo) do
		-- print(k,dump(v))
		v_protolist[v[2]] = v[1]
		if v_protolist[v[1]] then
			error("had "..v[1].." "..v[2].." msg!!")
		end
		v_protolist[v[1]] = v[2]
	end
end
register_files{"lua/3rd/pbc/packets.pb"}
register_files = nil
------------------------------------------------------------------------------
local mt = {}

function mt:init()
	socket.set_error_cb(handler(self,self.onError))
	--rc4 function
	-- self.v_rc4_s2c = false
	-- self.v_rc4_c2s = false

	self.v_closed = false
	self.v_srvmap = {}
	self:reset(true)
	self.reconnet_404_count = 0
end
-- 重置
function mt:reset(init)
	local client_heartbeat =  global.client_heartbeat
	if client_heartbeat then
		client_heartbeat:chb_set_enable(false)
	end
	self:disconnect()

	if not init then
		if self._fd then
			--保存上一次的request数据，重连login的时候用到
			self.v_last_request = self._fd.__request
			-- dump(self.v_last_request)
			self._fd = nil
		end
	else
		self._fd = nil
		self.v_last_request = nil
	end

	self.o_reconnect = nil
	self.o_nochange_scene = nil
end

function mt:login(token, conf)
	-- print("network:login",host, port)

	self:disconnect()

	if self.CMD == nil then
		self.CMD = {
			onError 	= conf.onError,
			onEnterSucc = conf.onEnterSucc,
		}
	end

	socket.login(token,function(fd)
		-- 连接游戏服
		fd:connect {
			-- host = host,
			-- port = 8888,
			request = self.v_last_request, --上次的包数据
			dispatch = handler(self,self.dispatch)
		}
		self.v_last_request = nil
		self._fd = fd
	end)
end

function mt:disconnect()
	if self._fd then
		self._fd:close()
	-- 	self._fd = nil
	end
end
local count = 0
function mt:reconnect()
	global.client_heartbeat:chb_set_enable(false)
	--显示菊花
	-- print("···显示菊花")
	-- ui_loading:loading_show {text=i18n.TID_UI_CONNET}
	global._view:showLoading()

	local fd = self._fd
	if fd then
		self.o_reconnect = true
		fd:reconnect() -- socket tcp重连
	else
		-- self:login(self.o_token)
		-- if count == 1 then
		-- 	assert(false)
		-- 	return
		-- end
		-- count = count + 1

		global.login_mgr:relogin_game(function(failed)
			if failed then
				return self:onError(errcode.NETWORK_ERROR_600)
			end
		end)
	end
end
--得到已经连上的服务器的ip，既gate server
function mt:get_conneted_server()
	local fd = self._fd
	if not fd then
		return
	end
	return fd.__host, fd.__port
end

function mt:nw_update()
	if self.v_closed then
		return
	end

	local fd = self._fd
	if fd and not fd:is_connected() then
		self:check_reconnect()
	end
	return true
end

function mt:nw_close()
	self:disconnect()
	self:reset()
	self.v_closed = true
end

--[[
	加密发送, 与game server通讯时用到
	cb 回调函数
]]
function mt:nw_call(typename, body, cb)
	if self.v_closed then
		return
	end
	local fd = self._fd
	if not fd then
		error("nw_call fd error")
	end
	local id = v_protolist[typename]
	if id == nil then
		logI("packet_pack typename:%s Unregistered!",typename)
		return
	end
	body = protobuf.encode("proto."..typename, body or {})
	body = protobuf.pack(PACK_FORMAT, id, body)

	if body == nil then
		return
	end
	-- 加密
	-- body = crypt.desencode(fd.secret, body)
	-- body = self.v_rc4_c2s(body)
	-- print("----------------")
	-- print("encode_text is:", typename,cc.utils.ByteArray.toString(body, 16))
	fd:request(body,cb)
	return true
end
--[[
	注册服务端通知函数
	typename: cmd 的name
]]
function mt:nw_register(typename, handler)
	if not handler then
		error("no handler")
	end
	local id = v_protolist[typename]
	if not id then
		error(tostring(typename))
	end
	self.v_srvmap[id] = handler
	-- dump(self.v_srvmap)
end

function mt:nw_unregister(typename)
	local id = v_protolist[typename]
	if not id then
		error(tostring(typename))
	end
	self.v_srvmap[id] = nil
end

-- 解密且处理 handle
function mt:dispatch(session, body, cb)
	local fd = self._fd
	if not fd then
		-- error("dispatch fd error")
		self:onError(errcode.NETWORK_ERROR_100001)
		return
	end

	if session == nil then --auth ok
		self.reconnet_404_count = 0 --404重连次数
		global.client_heartbeat:chb_set_enable(true)
		if self.o_reconnect then --重连中
			-- ui_loading:loading_remove()
			-- print("···重连中 ")
			global._view:hideLoading()
			self.o_reconnect = nil
			return
		end
		local f = self.CMD.onEnterSucc
		if f then
			local r = self.o_nochange_scene
			self.o_nochange_scene = nil
			return f(fd.subid, r) -- request game login data
		end
		return
	end

	-- print("----------------")
	-- print("sceret is:", cc.utils.ByteArray.toString(self.secret, 16))
	-- print("decode_text is:", cc.utils.ByteArray.toString(body, 16))
	-- print("decode_text is:", crypt.hexencode(body))

	if body == nil or body == "" then
		-- 服务端只要有请求，服务端必定会有回馈，（该特性已经去除！！）
		-- 如果服务端不处理，返回的text为空
		if cb then
			return cb()
		end
		return
	end

	--解包头
	local t, d = protobuf.unpack(PACK_FORMAT, body, #body)
	if t == nil then
		self:onError(errcode.NETWORK_ERROR_601)
		global.log("msg unpack error!!!",session)
		return
	end
	local name = v_protolist[t]
	-- print("...dispatch",t,name)
	if name == nil then
		self:onError(errcode.NETWORK_ERROR_602)
		logI("packet_unpack cmdid:%d Unregistered!",t)
		return
	end
	local dd, err = protobuf.decode("proto."..name, d)
	if not dd then --解析失败
		self:onError(errcode.NETWORK_ERROR_603)
		error(string.format("%s %s",name,tostring(err)))
	end
	if session > 0 then
		if cb then
			-- global.log("dispatch cb",session,t,name)
			return cb(dd)
		end
	elseif session == 0 then
		local handler = self.v_srvmap[t]
		if handler then
			return handler(dd)
		end
	else
		error(("error session:%d"):format(session))
	end
end

function mt:check_reconnect(code)
	if code == errcode.NETWORK_ERROR_404 then
		self.reconnet_404_count = self.reconnet_404_count + 1
		if self.reconnet_404_count >= 2 then
			self:nw_show_alert(i18n.TID_NETWORK_ERROR_404,true)
			return true
		end
	end

	if self.o_reconnect == nil then
		self:reconnect()
		return true
	end
	return false
end

function mt:nw_show_alert(code, restart, param)

	-- 回调
	local f = self.CMD.onError
	if f then
		f(text)
	end

	if restart then
		self:nw_close()
		errcode_util:ecu_check_alert(code,{
			confirmFun = function()
				-- global.account_data:clear()
				-- global.player:reset()
				-- app.restart() --重启app
				global._view:returnToLogin()
			end,
		},param)
	else
		errcode_util:ecu_check_alert(code, {
			confirm_name = i18n.TID_BUTTON_RETRY,
			confirmFun = function()
				 self:reconnect()
			end,
			-- cancel_name = i18n.TID_BUTTON_CANCEL,
			cancelFun = function()
				-- global.account_data:clear()
				-- global.player:reset()
				-- app.restart() --重启app
				self:nw_close()
				global._view:returnToLogin()
			end
		},param)
	end
end
--错误
function mt:onError(code, param)
	if self.v_closed then
		return
	end
	self:disconnect()
	if code == errcode.NETWORK_ERROR_404 then -- 情况1:重连开始握手失败会调用
		--agent已经关闭，需要重新登录loginserver
		self:reset() --先重置
		self.o_nochange_scene = true --设置不切换场景

		if self:check_reconnect(code) then
			return
		end
		return self:nw_show_alert(code)
	elseif code == errcode.NETWORK_ERROR_500 then -- 情况1:游戏中服务器被关闭 情况2:agent退出，后台切回游戏
		if self:check_reconnect() then -- 尝试做连接
			return
		end
		--重连一次失败后
		self:reset()
		return self:nw_show_alert(code)
	elseif code == errcode.NETWORK_ERROR_502 then -- 500处尝试连接失败会调用到这里
		--这里不reset,但取消心跳
		global.client_heartbeat:chb_set_enable(false)
		return self:nw_show_alert(code)
	elseif code == errcode.NETWORK_ERROR_100001 then
		if self:check_reconnect() then
			return
		end
		--重连一次失败后
		self:reset()
		return self:nw_show_alert(code)
	end

	if code == nil or code == "" then
		code = errcode.NETWORK_ERROR_UNKNOW
	end

	return self:nw_show_alert(code,true,param)
end

return mt