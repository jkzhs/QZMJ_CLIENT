--
-- Author: wangshaopei
-- Date:
--
local conf    = require("app.etc.ox.ox_money")

local mt = {}
function mt.get(id)
	if id then
		return conf[id]
	else
		return conf
	end
end
return mt