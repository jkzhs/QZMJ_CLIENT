--
-- Author: Albus
-- Date: 2016-03-01 14:36:51
-- Filename: errcode.lua
--
local errcode_desc = require_ex "sys.errcode_desc"
local error_code = require_ex "sys.error_code"

local t = {}
for name, code in pairs(error_code) do

	local ec = errcode_desc[code]
	if not ec then
		-- error(("error errcode_desc:%d!!"):format(code))
		logW(("error errcode_desc:%d!!"):format(code))
	else
		t[name] = code
		t[code] = {
			name 	= name,
			code 	= code,
			CN 		= ec.CN,
			ok 		= ec.ok,
			tid 	= ec.tid,
			desc 	= ec.desc
		}
	end

end
return t