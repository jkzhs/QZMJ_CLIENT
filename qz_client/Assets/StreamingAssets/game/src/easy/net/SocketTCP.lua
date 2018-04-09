
local SOCKET_TICK_TIME = 0.1 			-- check socket data interval
local SOCKET_RECONNECT_TIME = 5			-- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 3	-- socket failure timeout

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"

-- local scheduler = require("framework.scheduler")
local socket = require "socket"
-- local logictimer = logictimer
local Timer = Timer

local SocketTCP = class("SocketTCP")

SocketTCP.EVENT_DATA = "SOCKET_TCP_DATA"
SocketTCP.EVENT_CLOSE = "SOCKET_TCP_CLOSE"
SocketTCP.EVENT_CLOSED = "SOCKET_TCP_CLOSED"
SocketTCP.EVENT_CONNECTED = "SOCKET_TCP_CONNECTED"
SocketTCP.EVENT_CONNECT_FAILURE = "SOCKET_TCP_CONNECT_FAILURE"

SocketTCP._VERSION = socket._VERSION
SocketTCP._DEBUG = socket._DEBUG

function SocketTCP.getTime()
	return socket.gettime()
end

function SocketTCP:ctor(__host, __port, __retryConnectWhenFailure)
	easy(self):addComponent("easy.components.EventProtocol")

    self.host = __host
    self.port = __port
	self.tickScheduler = nil			-- timer for data
	self.reconnectScheduler = nil		-- timer for reconnect
	self.connectTimeTickScheduler = nil	-- timer for connect timeout
	self.name = 'SocketTCP'
	self.tcp = nil
	self.isRetryConnect = __retryConnectWhenFailure
	self.isConnected = false
end

function SocketTCP:setName( __name )
	self.name = __name
	return self
end

function SocketTCP:setTickTime(__time)
	SOCKET_TICK_TIME = __time
	return self
end

function SocketTCP:setReconnTime(__time)
	SOCKET_RECONNECT_TIME = __time
	return self
end

function SocketTCP:setConnFailTime(__time)
	SOCKET_CONNECT_FAIL_TIMEOUT = __time
	return self
end

function SocketTCP:connect(__host, __port, __retryConnectWhenFailure)
	if __host then self.host = __host end
	if __port then self.port = __port end
	if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
	assert(self.host or self.port, "Host and port are necessary!")
	logI("%s.connect(%s, %d)", self.name, self.host, self.port)

	-- 设置ipv6
	local isipv6_only = false
	local addrinfo, err = socket.dns.getaddrinfo(self.host)
	for i,v in ipairs(addrinfo) do
	 if v.family == "inet6" then
	     isipv6_only = true;
	     break
	 end
	end
	-- print("isipv6_only", isipv6_only)
	-- dump(addrinfo)
	if isipv6_only then
	 self.tcp = socket.tcp6()
	else
	 self.tcp = socket.tcp()
	end

	self.tcp:settimeout(0)

	local function __checkConnect()
		local __succ = self:_connect()
		if __succ then
			self:_onConnected()
		end
		return __succ
	end

	if not __checkConnect() then
		-- check whether connection is success
		-- the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
		local __connectTimeTick = function ()
			--printInfo("%s.connectTimeTick", self.name)
			if self.isConnected then return end
			self.waitConnect = self.waitConnect or 0
			self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
			if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
				self.waitConnect = nil
				self:close()
				self:_connectFailure()
			end
			__checkConnect()
		end
		-- self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)

		-- self.connectTimeTickScheduler = logictimer.add_timer(2,0,SOCKET_TICK_TIME,__connectTimeTick)
		if self.connectTimeTickScheduler then
			error(" connectTimeTickScheduler !")
		end
		self.connectTimeTickScheduler=Timer.New(__connectTimeTick,SOCKET_TICK_TIME, -1)
		self.connectTimeTickScheduler:Start()
	end
end

function SocketTCP:send(__data)
	-- assert(self.isConnected, self.name .. " is not connected.")
	if not self.isConnected then
		return false
	end

	local ret, err = self.tcp:send(__data)
	if not ret then
		return ret, err
	end
	return true
end

function SocketTCP:close( ... )
	--printInfo("%s.close", self.name)
	self.tcp:close();
	-- if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
	-- if self.connectTimeTickScheduler then
	-- 	logictimer.del_timer(self.connectTimeTickScheduler)
	-- 	self.connectTimeTickScheduler = nil
	-- end
	if self.connectTimeTickScheduler then
		self.connectTimeTickScheduler:Stop()
		self.connectTimeTickScheduler = nil
	end
	-- if self.tickScheduler then scheduler.unscheduleGlobal(self.tickScheduler) end
	-- if self.tickScheduler then
	-- 	logictimer.del_timer(self.tickScheduler)
	-- 	self.tickScheduler =nil
	-- end
	if self.tickScheduler then
		self.tickScheduler:Stop()
		self.tickScheduler = nil
	end
	self:dispatchEvent({name=SocketTCP.EVENT_CLOSE})
end

-- disconnect on user's own initiative.
function SocketTCP:disconnect()
	self:_disconnect()
	self.isRetryConnect = false -- initiative to disconnect, no reconnect.
end

--------------------
-- private
--------------------

--- When connect a connected socket server, it will return "already connected"
-- @see: http://lua-users.org/lists/lua-l/2009-10/msg00584.html
function SocketTCP:_connect()
	local __succ, __status = self.tcp:connect(self.host, self.port)
	-- print("SocketTCP._connect:", __succ, __status,self.host, self.port)
	return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end

function SocketTCP:_disconnect()
	self.isConnected = false
	self.tcp:shutdown()
	self:dispatchEvent({name=SocketTCP.EVENT_CLOSED})
end

-- 服务器关闭后调用
function SocketTCP:_onDisconnect()
	--printInfo("%s._onDisConnect", self.name);
	self.isConnected = false
	self:dispatchEvent({name=SocketTCP.EVENT_CLOSED})
	self:_reconnect();
end

-- connecte success, cancel the connection timerout timer
-- 连接成功后call
function SocketTCP:_onConnected()
	--printInfo("%s._onConnectd", self.name)
	self.isConnected = true
	self:dispatchEvent({name=SocketTCP.EVENT_CONNECTED})
	-- if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
	-- if self.connectTimeTickScheduler then
	-- 	logictimer.del_timer(self.connectTimeTickScheduler)
	-- 	self.connectTimeTickScheduler = nil
	-- end
	if self.connectTimeTickScheduler then
		self.connectTimeTickScheduler:Stop()
		self.connectTimeTickScheduler = nil
	end

	local __tick = function()
		while true do
			-- if use "*l" pattern, some buffer will be discarded, why?
			local __body, __status, __partial = self.tcp:receive("*a")	-- read the package body
			--print("body:", __body, "__status:", __status, "__partial:", __partial)
    	    if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
		    	self:close()
		    	if self.isConnected then
		    		self:_onDisconnect() -- 情况1:前端一段时间从后台切回会调用(agent退出)
		    	else
		    		self:_connectFailure()
		    	end
		   		return
	    	end
		    if 	(__body and string.len(__body) == 0) or
				(__partial and string.len(__partial) == 0)
			then return end
			if __body and __partial then __body = __body .. __partial end
			self:dispatchEvent({name=SocketTCP.EVENT_DATA, data=(__partial or __body), partial=__partial, body=__body})
		end
	end

	-- start to read TCP data
	-- self.tickScheduler = scheduler.scheduleGlobal(__tick, SOCKET_TICK_TIME)
	-- self.tickScheduler = logictimer.add_timer(3,0,SOCKET_TICK_TIME,__tick)
	if not self.tickScheduler then
		self.tickScheduler=Timer.New(__tick,SOCKET_TICK_TIME, -1)
		self.tickScheduler:Start()
	else
		logW("tickScheduler is exist！")
	end
end

function SocketTCP:_connectFailure(status)
	--printInfo("%s._connectFailure", self.name);
	self:dispatchEvent({name=SocketTCP.EVENT_CONNECT_FAILURE})
	self:_reconnect();
end

-- if connection is initiative, do not reconnect
function SocketTCP:_reconnect(__immediately)
	if not self.isRetryConnect then return end
	printInfo("%s._reconnect", self.name)
	if __immediately then self:connect() return end
	-- if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
	if self.reconnectScheduler then
		self.reconnectScheduler:Stop()
		self.reconnectScheduler = nil
	end
	local __doReConnect = function ()
		self:connect()
	end
	-- self.reconnectScheduler = scheduler.performWithDelayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
	self.reconnectScheduler=Timer.New(__doReConnect,SOCKET_TICK_TIME, -1)
	self.reconnectScheduler:Start()
end

return SocketTCP
