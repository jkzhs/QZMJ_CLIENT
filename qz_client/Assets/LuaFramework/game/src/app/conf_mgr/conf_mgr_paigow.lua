--
-- Author: wangshaopei
-- Date:
--
local conf    = require("app.etc.paigow_cards")
local data={}
local mt = {}
function mt.get(id)
	if id then
		return conf[id]
	else
		return conf
	end
end
function mt.get_name(group)
	-- local group={card1,card2}
	table.sort(group,function ( a,b )
					if a < b then
						return true
					end
				end)
	local type_name = table.concat(group,'_')

	local d = data[type_name]
	if d  then
		if conf[d] then
			return conf[d].name
		end
	else
		logW(("paigow nil name! type = %s "):format(type_name))
	end
end

function mt.init()
	local t = {}
	for i,v in ipairs(conf) do
		if #v.cards > 0 then
			for k,group in pairs(v.cards) do
				table.sort(group,function ( a,b )
					if a < b then
						return true
					end
				end)
				t[table.concat(group,'_')]=i
			end
		end
	end
	data = t
end
return mt