--
-- Author: Albus
-- Date: 2015-10-10 15:28:54
-- Filename: clinet_heartbeat.lua
--
local global = require("global")
-- local timer = require("common.utils.Timer")
local timer = require("easy.logictimer")
local HELLO_INTERVAL = 300--10--60--180
local errcode = global.errcode
local const = global.const

local M = {}

local heartbeat_time

function M:chb_init()

  global.network:nw_register("CSC_SysHeartBeat", self._on_hearbeat)
  return self
end
function M:chb_set_enable(b)

	if b then
		self:chb_newcheck()
	else
		-- timer:kill(self.heartbeat_timeid)
		if self.heartbeat_timeid then
			timer.del_timer(self.heartbeat_timeid)
		end
		self.heartbeat_timeid = nil
		heartbeat_time = 0
	end
end

function M:chb_newcheck()
	heartbeat_time = global.ts_now
	-- 每10秒检测一次
	-- self.heartbeat_timeid = timer:start(function( dt, data, timerId)
	-- 	-- print("···",global.ts_now,heartbeat_time)
	-- 	if global.ts_now - heartbeat_time > HELLO_INTERVAL then
	-- 		global.network:onError(errcode.NETWORK_ERROR_100001)
	-- 	end
	-- end, 2)

	self.heartbeat_timeid = timer.add_timer(const.TIMER_ID_HEARTBEAT,0,2,function ( ... )
			-- print("···",global.ts_now,heartbeat_time)
			if global.ts_now - heartbeat_time > HELLO_INTERVAL then
				global.network:onError(errcode.NETWORK_ERROR_100001)
			end
	end)
end

function M._on_hearbeat(resp)
	-- print("···_on_hearbeat")
	-- global.ts_service:ts_sync(resp.timestamp)
	-- heartbeat_time = global.ts_service:ts_get()
	-- global.ts_now = heartbeat_time
	heartbeat_time = global.ts_now
	return global.player:call("CSC_SysHeartBeat")
end
return M