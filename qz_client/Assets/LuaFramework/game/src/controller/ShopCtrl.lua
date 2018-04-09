require "logic/ViewManager"
local global = require("global")
ShopCtrl = {};
local this = ShopCtrl;

--构建函数--
function this.New()
	return this;
end

function this.Awake()
	panelMgr:CreatePanel('Shop', this.OnCreate);
end

--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.beh= this.transform:GetComponent('LuaBehaviour');
	this.beh:AddClick(ShopPanel.close, function ()
		ShopPanel.clearView()
	end);
	this.renderShop({{}})
end

this.shoplist = {}
function this.renderShop(list)
	local bundle = resMgr:LoadBundle("shopBar");
	local Prefab = resMgr:LoadBundleAsset(bundle,"shopBar");
	local startX = -276
	local space = 230
	local len = #list
	for i=1,len do
		local data = list[i]
	    local go = GameObject.Instantiate(Prefab);
		go.name = "shopBar" .. i;
		go.transform.parent = ShopPanel.shopList.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(startX + (i - 1) * space, 0 ,0)
		resMgr:addAltas(go.transform,"Shop")
		local title = 10 * i .. " 张"
		local icon = "tbfk1"
		local coin = i
		if(i == len) then
			title = "堆人气"
			icon = "renqiicon"
			coin = "go"
		end
		go.transform:Find('shopnum'):GetComponent('UILabel').text = title
		local shopIcon_UISprite = go.transform:Find('shopIcon'):GetComponent('UISprite')
		shopIcon_UISprite.spriteName = icon
		shopIcon_UISprite:MakePixelPerfect();
		go.transform:Find('shopCoin'):GetComponent('UILabel').text = coin
		local shopBuy = go.transform:Find('shopBuy').gameObject
		this.beh:AddClick(shopBuy, function ()
			if(i == len) then
				global._view:people().Awake()
			end
		end);
		table.insert(this.shoplist,go)
	end
	local pW = len * space
	if (pW > 800) then
		ShopPanel.shopCollider_UISprite.width = pW
	end
end

function this.clearShopList()
	local len = #this.shoplist
	for i=1,len do
		local data = this.shoplist[i]
		panelMgr:ClearPrefab(data);
	end
	this.shoplist = {}
end

function this.Close()
	this.clearShopList()
	panelMgr:ClosePanel(CtrlNames.Shop);
end

return this