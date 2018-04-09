local global = require("global")
local transform;
RulePanel = {};
local this = RulePanel;
RulePanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("Rule")--必加
end

--初始化面板--
function this.InitPanel()
	this.close = transform:Find("close").gameObject
	this.rulelist = transform:Find("rulebox/rulelist").gameObject
	this.ruleCollider = transform:Find("rulebox/rulelist/ruleCollider").gameObject
	this.ruleCollider_UISprite = this.ruleCollider:GetComponent('UISprite');
end

function this.clearView()
	global._view:clearFormulateUI("Rule")
end

function this.OnDestroy()
	this.ui.Close()
end

return RulePanel