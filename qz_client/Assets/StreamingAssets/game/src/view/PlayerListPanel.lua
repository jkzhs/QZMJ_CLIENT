local global = require("global")
local transform;
PlayerListPanel = {};
local this = PlayerListPanel;
PlayerListPanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("PlayerList")--必加
	
end

--初始化面板--
function this.InitPanel()
	this.allplayerInfo = transform:Find("allplayerInfo").gameObject;
	this.closePlayer = transform:Find("closePlayer").gameObject;
	this.playerNum = transform:Find("playerNum").gameObject;
	this.playerNum_UILabel = this.playerNum:GetComponent('UILabel');
	this.playerCollider = transform:Find("allplayerInfo/playerCollider").gameObject;
	this.playerCollider_UISprite = this.playerCollider:GetComponent('UISprite');
	
	this.ui.renderPlayer();
end

function this.clearView()
	if(this.ui ~= nil) then
		this.ui.clearPlayerlist()
	end
	global._view:clearFormulateUI("PlayerList")
end

function this.OnDestroy()
	this.ui.Close()
end

return this