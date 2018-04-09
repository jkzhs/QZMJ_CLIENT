local global = require("global")
local transform;
ShopPanel = {};
local this = ShopPanel;
ShopPanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("Shop")--必加
end

--初始化面板--
function this.InitPanel()
	this.close = transform:Find("backgroup/close").gameObject
	this.shopList = transform:Find("shopInfo/shopList").gameObject
	this.shopCollider = transform:Find("shopInfo/shopList/shopCollider").gameObject
	this.shopCollider_UISprite = this.shopCollider:GetComponent('UISprite');
end

function this.clearView()
	global._view:clearFormulateUI("Shop")
end

function this.OnDestroy()
	this.ui.Close()
end

return ShopPanel