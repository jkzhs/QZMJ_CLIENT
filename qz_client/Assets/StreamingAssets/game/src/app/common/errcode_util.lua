--
-- Author: Albus
-- Date: 2016-03-01 14:24:25
-- Filename: errcode_util.lua
--
local global = require("global")
local errcode = global.errcode

local mt = {}

--错误码的描述
function mt:get_errcode_desc(code)
	local ec = errcode[code]
	return ec and ec.desc or ""
end

--错误码的中文描述
function mt:get_errcode_CN(code)
	local ec = errcode[code]
	if ec then
		if ec.CN then
			return ec.CN
		elseif ec.desc then
			return ec.desc
		end
	end
	return code
end

--浮动提示
function mt:ecu_check_hint(code, param)
	if not code or code == 0 then
		return
	end
	local desc = global.i18n[self:get_errcode_desc(code)]
	if not desc then
		desc = code
	else
		if param then
			desc = desc:format(param)
		end
	end

	-- 显示提示窗口
	-- logW(desc)
	-- global.KNMsg:flashShowError(desc)
	global._view:getViewBase("Tip").setTip(desc)
	return true
end
--弹窗提示
function mt:ecu_check_alert(code, alert_args, param)
	if not code or code == 0 then
		return
	end

	local desc = global.i18n[self:get_errcode_desc(code)]
	if not desc then
		desc = code
	end

	if param then
		desc = string.format(desc,param)
	end
	-- 显示提示窗口
	-- logW(desc)
	-- global.KNMsg:boxShow(desc, alert_args)
	if not global._view:getViewBase("Support") then
		global._view:support().Awake(desc,
		alert_args.confirmFun,
		alert_args.cancelFun)
		-- global._view:clearFormulateUI("Support")
	end
	-- global._view:support().Awake(desc,
	-- 	alert_args.confirmFun,
	-- 	alert_args.cancelFun)
	return true
end

return mt