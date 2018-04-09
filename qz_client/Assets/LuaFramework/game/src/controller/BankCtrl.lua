--
-- Author: wangshaopei
-- Date: 2017-08-07 11:13:10
--
require "logic/ViewManager"
local global = require("global")
local const = global.const
BankCtrl = {};
local this = BankCtrl;

--构建函数--
function this.New()
	return this;
end

function this.Awake()
	panelMgr:CreatePanel('Bank', this.OnCreate);
end

--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.beh= this.transform:GetComponent('LuaBehaviour');
	this.beh:AddClick(BankPanel.Container, this.OnClick);
	this.beh:AddClick(BankPanel.oKbtn, function ()
		local coin = tonumber(BankPanel.charge_input.value) or 0
		if(coin == 0) then
			global._view:getViewBase("Tip").setTip("金额不能为零！！！")
			return
		end
		BankPanel.choicecharge:SetActive(true)
	end);
	this.beh:AddClick(BankPanel.choiceBg, function ()
		BankPanel.choicecharge:SetActive(false)
		BankPanel.charge_input.value = 0
	end);
	this.beh:AddClick(BankPanel.wechat, function ()
		local coin = tonumber(BankPanel.charge_input.value)
		BankPanel.getBankAriPayUrl(const.PAY_TYPE_WX,coin)
	end);
	this.beh:AddClick(BankPanel.Alipay, function ()
		local coin = tonumber(BankPanel.charge_input.value)
		BankPanel.getBankAriPayUrl(const.PAY_TYPE_ALIPAY,coin)
	end);
	-- BankPanel.UnionPay:SetActive(false)
	this.beh:AddClick(BankPanel.UnionPay, function ()
		local coin = tonumber(BankPanel.charge_input.value)
		BankPanel.getBankAriPayUrl(const.PAY_TYPE_BANK,coin)

	end);
end

function this.OpenPayApp(apay,url,info)
	global.sdk_mgr:pay(url,apay,function (data)
	end)
end

function this.Close()
	panelMgr:ClosePanel(CtrlNames.Bank);
end

function this.OnClick()
	BankPanel.clearView()
end

return this