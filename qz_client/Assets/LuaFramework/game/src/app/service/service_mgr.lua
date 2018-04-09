--
-- Author: Albus
-- Date: 2015-10-10 15:19:51
-- Filename: service_mgr.lua
--
local M = {}
function M:sm_init()
	self:_init_service("client")
	self:_init_service("stat")
	-- self:_init_service("item")
	-- self:_init_service("friend")
	return self
end
function M:_init_service(path)
  local s = require("app.service." .. path)
  assert(s)
  s:register()
end

return M
