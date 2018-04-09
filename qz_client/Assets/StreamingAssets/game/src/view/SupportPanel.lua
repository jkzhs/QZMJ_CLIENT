local global = require("global")

SupportPanel = {};
local this = SupportPanel;
SupportPanel.gameObject = nil;
SupportPanel.transform = nil;
--启动事件--
function SupportPanel.Awake(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	global._view:changeLayerAll("Support")--必加
	this.Ok = this.transform:Find("Ok").gameObject
	this.Cancel = this.transform:Find("Cancel").gameObject
	this.text = this.transform:Find("text").gameObject
	this.text_UILabel = this.text:GetComponent('UILabel');
end

function SupportPanel.clearView()
	if(this.gameObject ~= nil) then
		this.gameObject:SetActive(false)
	end
	global._view._loadShow = false
end

function SupportPanel.OnDestroy()
	this.ui.Close()
end

return SupportPanel