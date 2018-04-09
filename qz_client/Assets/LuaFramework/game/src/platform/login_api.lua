
local global = require("global")
local i18n = assert(global.i18n)

local M = {}


function M:_req_login()
	-- global.login_mgr:lgm_platform_login(self.key, self._on_login_resp, self)
end

-- function M:is_login()
-- 	if self.key then
-- 		return true
-- 	end
-- 	return false
-- end


function M:on_login(account, token, cb)
	self.account = account
	self.key = {
		platform = self.platform,
		account = account,
		token = token,
	}
	if cb then
		cb()
	end

	self:_req_login()
end

function M:on_disconnect()
	if self.impl.disconnect then
		self.impl.disconnect()
	end
end

function M:on_login_failed(ignore, errcode, errmsg, cb)
	if cb then
		cb(true)
	end
end

function M:init( ... )
	local init = self.impl.init
	if init then
		init(...)
	end
end

function M:login(...)
	return self.impl.login(...)
end

function M:on_logout(account, cb)
	self.account = nil
	self.key = nil
	if cb then
		cb()
	end
end

function M:logout(...)
	self.impl.logout(...)
end

function M:get_platform()
	return self.platform
end

function M:get_account()
	return self.account
end

-- function M:ischage_accout()
-- 	local fun=self.impl.ischage_accout
-- 	if fun then
-- 		return fun()
-- 	else
-- 		return true
-- 	end
-- end

-- function M:get_accounttype()
-- 	local fun=self.impl.get_accounttype
-- 	if fun then
-- 		return fun()
-- 	else
-- 		return dataeyeConst.DC_Anonymous
-- 	end
-- end

-- function M:is_auto()
-- 	local fun=self.impl.is_auto
-- 	if fun then
-- 		return fun()
-- 	else
-- 		return true
-- 	end
-- end

-- function M:get_name()
-- 	if self.impl.get_name then
-- 		return self.impl.get_name()
-- 	end
-- 	return nil
-- end

-- function M:get_region()
-- 	if self.impl.get_region then
-- 		return self.impl.get_region()
-- 	end
-- 	return nil
-- end

function M:login_init()
	if not global.config.LOGIN_PLATFORM then
		self.impl = {}
		return self
	end
	local platform = global.config.LOGIN_PLATFORM
	printInfo("--------- init platform login: %s", platform)
	local module_name = "platform." .. platform:lower()
	local module = require(module_name)
	assert(module, platform)
	assert(type(module.login) == "function")
	assert(type(module.logout) == "function")
	self.impl = module
	self.platform = platform
	self:init()
	return self
end
return M