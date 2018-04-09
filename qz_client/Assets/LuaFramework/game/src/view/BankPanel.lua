--
-- Author: wangshaopei
-- Date: 2017-08-07 11:14:53
--
local global = require("global")
local const = global.const
local transform;
BankPanel = {};
local this = BankPanel;
BankPanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("Bank")--必加
end

--初始化面板--
function this.InitPanel()
	this.Container = transform:Find("Container").gameObject
	this.charge = transform:Find("charge").gameObject
	this.charge_input = transform:Find("charge/charge_money/charge_input"):GetComponent('UIInput')
	this.oKbtn = transform:Find("charge/oKbtn").gameObject
	this.choicecharge = transform:Find("choicecharge").gameObject
	this.choiceBg = transform:Find("choicecharge/choiceBg").gameObject
	this.wechat = transform:Find("choicecharge/wechat").gameObject
	this.Alipay = transform:Find("choicecharge/Alipay").gameObject
	this.UnionPay = transform:Find("choicecharge/UnionPay").gameObject
end

function this.getBankAriPayUrl(paytype,fee)
	global._view:showLoading();
	if paytype == const.PAY_TYPE_BANK then
		global.sdk_mgr:req_pay_info(paytype,fee,function (data)
			global._view:hideLoading();
			if(this.ui ~= nil) then
				this.ui.OpenPayApp(paytype,data.url)
			end
		end)
	else
		global.player:req_order_create(paytype,fee,function (data)
			global._view:hideLoading();
			if(this.ui ~= nil) then
				this.ui.OpenPayApp(paytype,data.qr_code)
			end
		end)

	end

end

function this.OnDestroy()
	this.ui.Close()
end

function this.clearView()
	global._view:clearFormulateUI("Bank")
end

return BankPanel