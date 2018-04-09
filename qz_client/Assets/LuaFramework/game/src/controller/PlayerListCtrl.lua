require "logic/ViewManager"
local global = require("global")
PlayerListCtrl = {};
local this = PlayerListCtrl;
this._playerVec={};--记录玩家信息
this._playerlist={};
--构建函数--
function PlayerListCtrl.New()
	return this;
end

function PlayerListCtrl.Awake(list)
	this._playerlist=list;
	panelMgr:CreatePanel('PlayerList', this.OnCreate);
	
end

function PlayerListCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.beh= this.transform:GetComponent('LuaBehaviour');
	this.beh:AddClick(PlayerListPanel.closePlayer, this.closePlayerList);
	
	
end

function PlayerListCtrl.clearPlayerlist()
	local len = #this._playerVec;
	for i=1,len do
		local data = this._playerVec[i]
		if (data ~= nil) then
			panelMgr:ClearPrefab(data.prefab);
		end
	end
	this._playerVec = {};
end

function PlayerListCtrl.closePlayerList()
	PlayerListPanel.clearView();
end

function PlayerListCtrl.renderPlayer()
	local list =this._playerlist;
	local parent = PlayerListPanel.allplayerInfo.transform;
	local bundle = resMgr:LoadBundle("playerData");
	local Prefab = resMgr:LoadBundleAsset(bundle,"playerData");
	local startY = 180
	local space = 80
	local len = #list;
	for i = 1, len do
		local data = list[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "playerData"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0, startY - (i - 1)*space, 0);
		resMgr:addAltas(go.transform,"PlayerList")
		local name = go.transform:Find('playerName');
		name:GetComponent('UILabel').text = GameData.GetShortName(data.player_name,10,10);
		local playerId = go.transform:Find('playerId');
		local playerId_UILabel = playerId:GetComponent('UILabel');
		playerId_UILabel.text = "ID:" .. data.playerid
		local coin = go.transform:Find('playerMoney');
		coin:GetComponent('UILabel').text = data.RMB;
		local seliver = go.transform:Find('playerseliver');
		seliver:GetComponent('UILabel').text = data.money;
		local prefabInfo = {
		prefab = go,
		data = data,
		}
		table.insert(this._playerVec,prefabInfo)
	end
	PlayerListPanel.playerNum_UILabel.text = len
	--PlayerListPanel.playerList:SetActive(true)
	local pH = len * space
	if (pH > 505) then
		PlayerListPanel.playerCollider_UISprite.height = pH
	end
	this.loadPlayerIcon()
end
function PlayerListCtrl.loadPlayerIcon()
	local len = #this._playerVec;
	for i=1,len do
		local go = this._playerVec[i]
		if (go ~= nil) then
			local img = go.prefab.transform:Find('playerImage');
			local img_AsyncImageDownload = img:GetComponent('AsyncImageDownload');
			img_AsyncImageDownload:SetAsyncImage(go.data.headimgurl);
		end
	end
end
--关闭事件--
function PlayerListCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.PlayerList);
end

return PlayerListCtrl