--
-- Author: Albus
-- Date: 2015-11-02 10:57:48
-- Filename: time_service.lua
--
local os = os
local math = math
local print = print
local _get_time = assert(require("global").get_time)
local CORRECT_RATE = 0.3
local M = {}
function M:ts_init()
	self.v_first_sync = true
	self.v_diff = 0
	return self
end
function M:ts_sync(timestamp)
	local t = _get_time()
	local diff = timestamp - t
	local new_diff
	if self.v_first_sync then
		new_diff = diff
		self.v_first_sync = false
	else
		new_diff = self.v_diff * (1 - CORRECT_RATE) + diff * CORRECT_RATE
	end
	-- if self.v_diff ~= new_diff then
		-- print("======== TIME SYNC ========")
		-- print("local:", t)
		-- print("server:", timestamp)
		-- print(self.v_diff, "->", new_diff)
	-- end
	self.v_diff = new_diff
end
function M:ts_get()
		return math.floor(_get_time() + self.v_diff)
end
return M