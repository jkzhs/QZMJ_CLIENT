local global = require("global")

TipPanel = {};
local this = TipPanel;
TipPanel.gameObject = nil;
TipPanel.transform = nil;
--启动事件--
function TipPanel.Awake(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	global._view:changeLayerAll("Tip")--必加
	this.dialog = this.transform:Find("dialog").gameObject;
	this.dialog_UIWidget = this.dialog:GetComponent('UIWidget');
	this.dialog_TweenAlpha = this.dialog:GetComponent('TweenAlpha');
	this.dialog_TweenScale = this.dialog:GetComponent('TweenScale');
	this.tipbg = this.transform:Find("dialog/tipbg").gameObject;
	this.tipbg_UISprite = this.tipbg:GetComponent('UISprite');
	this.tipTxt = this.transform:Find("dialog/tipTxt").gameObject;
	this.tipTxt_UILabel = this.tipTxt:GetComponent('UILabel');
end

TipPanel._tagerT = ""
function TipPanel.setTip(text)
	this._tagerT = text
	if(this.ui ~= nil and this.gameObject ~= nil) then
		this.ui.updateTipInfo(text)
	end
end

function TipPanel.OnDestroy()
	this.ui.Close()
end

return TipPanel