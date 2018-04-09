--
-- Author: Albus
-- Date: 2016-01-05 11:11:59
-- Filename: socket.lua
--
local string = string
local string_char = string.char
local tonumber = tonumber
local table = table
local t_insert = table.insert
local t_remove = table.remove
local socket_tcp = require("easy.net.SocketTCP")
local bit32 = require "lib.bit32"
local bit_extract = bit32.extract
local bit_lshift = bit32.lshift
local crypt = require "crypt"
local global = require "global"
local config = global.config
local errcode = global.errcode
-- local i18n = global.i18n
-- local KNMsg = assert(global.KNMsg)

local socket = {}

local on_error --error function

--加密
local function package_encode(self, text)
	return crypt.desencode(self.secret, text)
	-- return self.v_rc4_c2s(text)
end
--解密
local function package_decode(self, text)
	return crypt.desdecode(self.secret, text)
	-- return self.v_rc4_s2c(text)
end


local function closefd(self)
	if self.__fd then
		self.__fd:close()
		self.__fd = nil
	end
end
--line
local function read_line(text)
	local from = text:find("\n", 1, true)
	if from then
		return text:sub(1, from-1), text:sub(from+1)
	end
	return
end
--gate 格式
local function read_pack(text)
	local size = #text
	if size < 2 then
		return
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return
	end

	return text:sub(3,2+s), text:sub(3+s)
end

-- 得到一个完整的包
local function recv_package(self)
	local f
	if self.login then
		f = read_line --login server 格式
	else
		f = read_pack --gate server 格式
	end

	local result, text = f(self.__read)
	if result then
		self.__read = text --剩余的下次使用
		return result
	end
end
local function _dispatch_package(self, text )

	self.__read = self.__read..text --放入缓冲区

	-- 执行到不能组成完整包
	-- local count = 0
	local f = self.unpack
	local pack = nil
	while true do
		-- if count >= 10 then --每帧执行包个数
		-- 	return
		-- end

		pack = recv_package(self)
		if not pack then
			break
		end
		-- 执行包
		if f then
			self:_dispatch(f(pack))
		else
			self:_dispatch(pack)
		end

		-- count = count + 1
	end
	-- print("···",count)
end
local function send_request(self, msg, session)
	if not self.__fd then
		return
	end
	local ret, err = self.__fd:send(self.pack(msg,session))
	if not ret then -- 情况1:后端agent退出发送会返回失败，前端切入后台一段时间在点开可能出翔
		-- global.log("send_request error:",err)
		closefd(self)
		on_error(502)
		return
	end
	return true
end

local connect_create = function(self, cb)
	local fd = socket_tcp.new(self.__host,self.__port)
	fd:addEventListener(socket_tcp.EVENT_CONNECTED, cb,5)
	fd:addEventListener(socket_tcp.EVENT_CLOSE, cb)
	fd:addEventListener(socket_tcp.EVENT_CLOSED, function(event)
		if cb then
			cb(event)
		end
		local state = self.__state
		self.__state = 6 --登录game server状态
		--
		-- 5:正在连接游戏服的返回 0:正在连接登录服的返回
		if state ~= 5 and state ~= 0 then --情况1:还处于login连接状态,情况2:服务器断开会调用
			return on_error(500)
		end
	end)
	-- 尝试连接失败调用
	fd:addEventListener(socket_tcp.EVENT_CONNECT_FAILURE, function(event)
		if cb then
			cb(event)
		end
		return on_error(502)
	end)
	fd:addEventListener(socket_tcp.EVENT_DATA, function(event)
		-- print("....connect EVENT_DATA")
		return _dispatch_package(self,event.data)
	end)
	fd:connect(self.__host,self.__port, false)
	return fd
end

-- game server 握手包特殊格式
local function auth_package(text)
	local size = #text
	return 	string_char(bit_extract(size,8,8))..
			string_char(bit_extract(size,0,8))..
			text
end
-- game server 正常包格式
local function gs_package(v, _session)
	local size = #v + 4
	return 	string_char(bit_extract(size,8,8))..
			string_char(bit_extract(size,0,8))..
			v..
			string_char(bit_extract(_session,24,8))..
			string_char(bit_extract(_session,16,8))..
			string_char(bit_extract(_session,8,8))..
			string_char(bit_extract(_session,0,8))
end
-- game server 正常包格式
local function recv_response(v)
	local content = v:sub(1,-6)
	local ok = v:sub(-5,-5):byte()
	local session = 0
	for i=-4,-1 do
		local c = v:byte(i)
		if not c then --没有则退出，等下下包处理
			return false
		end
		session = session + bit_lshift(c,(-1-i) * 8)
	end
	return ok~=0, content, session
end
--
local function auth(self, msg)
	if self.__auth == nil then --开始握手
		-- print("···auth begin")
		-- handshake
		-- base64(uid)@base64(server)#base64(subid):index:base64(hmac)
		local handshake = self.__token .. self.__index
		-- self.__index = self.__index + 1
		local hmac = crypt.hmac64(crypt.hashkey(handshake), self.secret)
		send_request(self,handshake .. ":" .. crypt.base64encode(hmac))
		self.__auth = false
		return false
	else
		--收到握手包
		local code = tonumber(string.sub(msg, 1, 3))
		if code ~= 200 then
			-- 开始握手失败
			self.__auth = nil
			closefd(self)
			self.__state = 5
			return on_error(code)
		end
		-- print("···auth end")
		self.__auth = true
		return true
	end
end
--game server sockect
local function fd_create(self)
	return connect_create(self, function(event)
		-- print("···gameserver",event.name)
		if event.name == socket_tcp.EVENT_CONNECTED then
			self.__state = 0 -- 情况1:断线重连，连接到游戏服务器开始验证
			return auth(self)
		end
	end)
end

local function connect_gameserver(self, conf)
	if not conf then
		error("connect_gameserver must has conf")
	end
	-- global.log("connect game server")

	self.login = nil
	self.__read = ""
	self.__request = conf.request or {}
	self.__auth = nil
	self.__index = 1
	self.__session = 1

	--host and port
	if conf.host then self.__host = conf.host end
	if conf.port then self.__port = conf.port end

	--打包函数
	self.pack = function(msg,session)
		if self.__auth then --已经验证通过、
			--加密
			return gs_package(package_encode(self, msg), session)
		else
			return auth_package(msg)
		end
	end

	--重写self._dispatch
	local f = conf.dispatch
	self._dispatch = function(self, msg)
		if self.__auth then --已经验证通过，处理正常封包
			local ok, content, session = recv_response(msg)
			if ok then
				if content and content ~= "" then
					--解密
					-- print("decode_text is:", crypt.hexencode(content))
					content = package_decode(self, content)
				end

				if session > 0 then
					for k,v in ipairs(self.__request) do
						-- print("··· session > 0",k,v.session,session)
						if v.session == session then
							local cb = v.callback
							t_remove(self.__request, k)
							if f then
								f(session, content, cb)
							end
						end
					end
				else
					if f then
						return f(session, content)
					end
				end
			else
				return on_error(errcode.NETWORK_ERROR_10000)
			end
		else
			if auth(self,msg) then
				-- global.log("connect game server ok")
				--验证通过
				--
				--发送先前队列里面
				for _, v in ipairs(self.__request) do
					-- print("···auth req",v.session)
					if not send_request(self, v.data,v.session) then
						break
					end
				end
				--
				if f then
					return f()
				end

			end
		end
	end

	self.__fd = fd_create(self)
	-- global.logf("connect game server:%s:%d",self.__host,self.__port)
end
local function reconnect_gameserver(self)
	closefd(self)
	self.__read = ""
	self.__auth = nil
	self.__index = self.__index + 1
	self.__fd = fd_create(self)
end

local function request_gameserver(self, req, cb)
	local session = self.__session
	local r = {
		session = session,
		data 	= req,--gs_package(req,session),
		callback = cb,
	}
	t_insert(self.__request, r)
	self.__session = session + 1

	if self.__auth then
		return send_request(self, r.data, session)
	end
	return true
end

local function is_connected(self)
	-- isConnected
	local fd = self.__fd
	if (not fd) then--or (not fd.isConnected) then
		return false
	end
	return true
end

local function connect_loginserver(addr, port)
	local self = {
		__fd = nil,
		__read = "",

		--
		pack = function(msg, _)
			return msg .. "\n" --write_line(msg)
		end,
		-- unpack = function(msg)
		-- 	return msg
		-- end,
		_dispatch = nil,
		-- _dispatch = function(self, msg)
		-- 	-- body
		-- end,

		login = true,
		__state = 0,

		__host = addr,
		__port = port,

		is_connected = is_connected,
	}
	self.__fd = connect_create(self,function(event)
		-- print("···loginserver",event.name)
		if event.name == socket_tcp.EVENT_CONNECTED then
			self.__state = 1
		end
	end)
	return self
end
function socket.login(token, cb)
	local self = connect_loginserver(token.host, token.port)

	local challenge
	local clientkey
	local function S_EXCHANGE_KEY(msg)
		-- print("···",msg)
		local ok
		ok, challenge = pcall(crypt.base64decode,msg)
		if not ok then --检测是否错误
			on_error(tonumber(string.sub(msg, 1, 3)))
			return
		end

		-- challenge = crypt.base64decode(msg)
		clientkey = crypt.randomkey()
		-- print("..clientkey:",clientkey)
		send_request(self,crypt.base64encode(crypt.dhexchange(clientkey)))
	end

	local function S_SCERET(msg)
		-- print("···S_SCERET",msg,clientkey)
		local ok, ret = pcall(crypt.base64decode,msg)
		if not ok then ----检测是否错误
			on_error(tonumber(string.sub(msg, 1, 3)))
			return
		end

		self.secret = crypt.dhsecret(ret, clientkey)
		-- print("sceret is ", crypt.hexencode(network.secret))

		-- --------------------
		-- --rc4
		-- self.v_rc4_c2s = crypt.rc4(self.secret)
		-- self.v_rc4_s2c = crypt.rc4(self.secret)
		-- --------------------
		--
		local hmac = crypt.hmac64(challenge, self.secret)
		send_request(self,crypt.base64encode(hmac))
	end
	local function S_CHECK_VERSION(msg)
		local code = tonumber(string.sub(msg, 1, 3))
		if code ~= 201 then
			local time
			if code == 410 then --服务器未到开启时间
				time = tonumber(string.sub(msg, 4))
				if time then
					time = os.date(i18n.TID_TXT_TIME_FORMAT,time)
				end
			end
			on_error(code, time)
			return
		end

		send_request(self,crypt.base64encode(config.script_version))
	end
	local function S_AUTH_BEGIN(msg)
		-- print("···S_AUTH_BEGIN",msg)
		local code = tonumber(string.sub(msg, 1, 3))
		if code ~= 201 then
			on_error(code)
			return
		end
		--
		local function encode_token(token)
			return  string.format("%s@%s:%s:%s:%s:%s:%s",
					crypt.base64encode(token.uid),
					crypt.base64encode(token.server),
					crypt.base64encode(token.token),
					crypt.base64encode(token.plat),
					crypt.base64encode(token.sdkid), --sdkid
					crypt.base64encode(token.serverid), --选择的服务器编号
					crypt.base64encode(token.sign)
					)

		end
		local etoken = crypt.desencode(self.secret, encode_token(token))
		send_request(self,crypt.base64encode(etoken))
		return true
	end

	local function S_AUTH(msg)
		-- auth ok
		local code = tonumber(string.sub(msg, 1, 3))
		-- assert(code == 200)
		if code ~= 200 then
			on_error(code)
			return
		end

		-- 取出发过来的gameserver的ip和port
		local result = crypt.base64decode(string.sub(msg, 5))
		self.subid, self.__host, self.__port, self.userid = result:match("([^@]+)@([^:]+):(.+):(.+)")
		if not self.userid then
			on_error(404)
			return
		end
		self.__token = string.format("%s@%s#%s:", crypt.base64encode(self.userid), crypt.base64encode(token.server),crypt.base64encode(self.subid))
		if self.__host == "0.0.0.0" then
			self.__host = token.host
		end
		return true
	end

	--重写 dispatch
	self._dispatch = function(self, msg)
		-- if not self.__fd.isConnected then
		-- 	return
		-- end
		local state = self.__state
		if state == 1 then
			S_EXCHANGE_KEY(msg)
			self.__state = 2
		elseif state == 2 then
			S_SCERET(msg)
			self.__state = 10
		elseif state == 10 then --检测版本
			S_CHECK_VERSION(msg)
			self.__state = 3
		elseif state == 3 then
			if not S_AUTH_BEGIN(msg) then
				self.__state = 6
			end
			self.__state = 4
		elseif state == 4 then
			if not S_AUTH(msg) then
				self.__state = 6
				return
			end
			self.__state = 5 --login 在这个状态太，如果EVENT_CLOSED，不提示

			closefd(self)

			--设置新的处理函数
			self.connect 	= connect_gameserver
			self.reconnect	= reconnect_gameserver
			self.request	= request_gameserver
			self.close		= closefd
			return cb(self)
		-- elseif state == 5 then
		end
	end
end
-- 设置错误回调函数
function socket.set_error_cb(cb)
	on_error = cb
end
return socket