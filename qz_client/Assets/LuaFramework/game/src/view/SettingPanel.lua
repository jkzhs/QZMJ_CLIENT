local global = require("global")
local transform;
SettingPanel = {};
local this = SettingPanel;
SettingPanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	this.timeEvent();
	global._view:changeLayerAll("Setting")--必加
end

--初始化面板--
function this.InitPanel()
	this.btnOut = transform:Find("btnOut").gameObject
	this.closeUI = transform:Find("closeUI").gameObject
	this.btnvolmn = transform:Find("btnvolmn").gameObject
	this.bgvolmn = transform:Find("bgvolmn").gameObject
	this.btnprocess = transform:Find("backgroup/btnprocess").gameObject
	this.btnprocess_UISprite = this.btnprocess:GetComponent('UISprite');
	this.bgprocess = transform:Find("backgroup/bgprocess").gameObject
	this.bgprocess_UISprite = this.bgprocess:GetComponent('UISprite');
end

function this.timeEvent()
    global._view:addTimeEvent(this.gameObject.name,function()
    	this.ui.timeEvent()
    end)
end

function this.clearView()
	global._view:clearFormulateUI("Setting")
end

function this.OutGame()
	global.network:nw_close()
	global._view:returnToLogin();
end

function this.OnDestroy()
	global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
end

return SettingPanel