--
-- Filename: mgr_charge.lua
-- 充值管理器
local global = require "global"
local KNMsg = global.KNMsg
local const = global.const
local i18n = global.i18n
local config = global.config
-- local conf_recharge = assert(global.config_mgr.get("recharge"))

local player
local mt = class("mgr_charge")
function mt:ctor(owner)
	player = owner
end


--请求充值数据，是否第一次充值
function mt:req_charge_info(cb)
	player:call("CS_AskInfo",{type=101},function(resp)
		local info = {}
		for i,v in ipairs(resp.info) do
			info[v.index] = {
				index = v.index,
				mark = v.mark
			}
		end
		if cb then
			cb(info)
		end
	end)
end

function mt:CheckChargeReq()
	return player:call("CS_AskInfo",{type=100})

end

-- 未领取的订单通知
function mt:OnNotifyChargeResp(ord_list)
	local ord = ord_list[1]
	if not ord then
		return
	end

	local time = ord.create_time
	local diamond = ord.diamond
	local preorddbid = ord.ord_dbid
	local text = (i18n.CHARGE_TIME_DESC):format(os.date(i18n.TID_TEXT_TIME,time),diamond,player:get_name())
	global._view:support().Awake(text,
		function ( ... )
			player:call("CS_WITHDRAW",{ord_dbid=preorddbid})
		end,
		function ( ... )
			-- body
		end)
	-- KNMsg:show_confirm {
	-- 	lab_title 		= i18n.CHARGE_OK_TITLE,
	-- 	text			= (i18n.CHARGE_TIME_DESC):format(os.date(i18n.TID_TEXT_TIME,time),diamond,player:get_name()),
	-- 	btn_left_text	= i18n.CHARGE_TIME_BTN_CANCEL,
	-- 	btn_right_text	= i18n.CHARGE_TIME_BTN_OK,
	-- 	on_btn_right_event = function()

	-- 		player:call("CS_WITHDRAW",{ord_dbid=preorddbid})
	-- 	end
	-- }
end

--充值成功提示
-- ord_dbid订单号
-- diamond元宝
-- amount充值金额 放大100倍
-- rebates充值反利元宝
function mt:OnChargeDiamondResp(ord_dbid,diamond,amount,rebates)
	local text =  string.format(i18n.TID_CHARGE_OK_DESC,amount)
	-- print("···1122",text)
	-- if not global._view:getViewBase("Support") then
		global._view:support().Awake(text,
		function ( ... )
			-- body
		end)
		-- global._view:clearFormulateUI("Support")
	-- end


end

return mt