require "logic/ViewManager"
local global = require("global")
local player = global.player
local mgr_dealer = player:get_mgr("dealer")
-- local mgr_room = player:get_mgr("room")
local const = global.const
GameLobbyCtrl = {};
local this = GameLobbyCtrl;

GameLobbyCtrl.panel = nil;
GameLobbyCtrl.transform = nil;
GameLobbyCtrl.gameObject = nil;
GameLobbyCtrl.lobby = nil;

--构建函数--
function GameLobbyCtrl.New()
	return this;
end

function GameLobbyCtrl.Awake()
	panelMgr:CreatePanel('GameLobby', this.OnCreate);
end

--启动事件--
function GameLobbyCtrl.OnCreate(obj)
	global._view:hideLoading()
	-- soundMgr:PlayBackSound("background")
	soundMgr:PlayBackSound(global.const.BG_MUSIC_HOME)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.panel = this.transform:GetComponent('UIPanel');
	this.lobby = this.transform:GetComponent('LuaBehaviour');
	this.InitListInfo();
	this.renderFunc();
	this.loadImg()
	this.lobby:AddClick(GameLobbyPanel.btnshare, this.OnShare);
	this.lobby:AddClick(GameLobbyPanel.btnsetting, this.OnClick);
	this.lobby:AddClick(GameLobbyPanel.btninvite, this.OnFind);
	this.lobby:AddClick(GameLobbyPanel.btnbank,this.OnClickBank)
	this.lobby:AddClick(GameLobbyPanel.bind,this.OnBind)
	this.lobby:AddClick(GameLobbyPanel.btnshop,function ()
		global._view:shop().Awake()
	end)
	this.lobby:AddClick(GameLobbyPanel.openShop,function ()
		global._view:shop().Awake()
	end)
	this.lobby:AddClick(GameLobbyPanel.btnmail,this.OnMail)
	this.lobby:AddClick(GameLobbyPanel.sharefriend, function ()
		local desc = "拜手棋牌汇集了牛牛、十二支、牌九、摇乐子、十三水、麻将等多款棋牌游戏，人气爆棚，诚信运营，公平公正，好玩棋牌游戏聚集地。"
		global.sdk_mgr:share(1,desc,"","拜手棋牌")


	end);
	this.lobby:AddClick(GameLobbyPanel.shareall, function ()
		local desc = "拜手棋牌汇集了牛牛、十二支、牌九、摇乐子、十三水、麻将等多款棋牌游戏，人气爆棚，诚信运营，公平公正，好玩棋牌游戏聚集地。"
		global.sdk_mgr:share(0,desc,"","拜手棋牌")
	end);
	this.lobby:AddClick(GameLobbyPanel.closeShare, function ()
		GameLobbyPanel.shareUI:SetActive(false)
	end)
	this.lobby:AddClick(GameLobbyPanel.btncustom,function()
		-- global._view:customer().Awake()
	end )
	-- 统一接口发送公告
	local chat_mgr = player:get_mgr("chat")
	local msg =  chat_mgr:get_broadcast()
	if msg ~= "" then
		chat_mgr:SC_CHAT({
		error_code = 0,
		ch_id = const.CHANNEL_ID_SYSTEM,
		showtype = const.CHANNEL_SHOW_TYPE_MARQUEE,
		count = -1,
		msg = msg,
		from_playerid = 0,
		})
	end
	this.IsHaveClick = false
	this.loadNoticeInfo()
	GameLobbyPanel.updatePlayerInfo()
	if player:get_paytype()  == 1 then
		GameLobbyPanel.btnbank:SetActive(false)
		GameLobbyPanel.btnshop:SetActive(false)
		GameLobbyPanel.openShop:SetActive(false)
		GameLobbyPanel.btnshare:SetActive(false)
		GameLobbyPanel.btncustom:SetActive(false)
		GameLobbyPanel.bind:SetActive(false)
	end
	if global._view.offset ~=0 then
		local pos = Vector3.zero 
		pos.x = global._view.offset
		GameLobbyPanel.LobbylList.localPosition = pos 
		local UIPanel = GameLobbyPanel.LobbylList:GetComponent("UIPanel")
		UIPanel.clipOffset = Vector2(global._view.offset * -1,0) 
		global._view.offset = 0
	end 
	this.ReqMailData()
end

function GameLobbyCtrl.ReqMailData()
	GameLobbyPanel.ReqMailData()
end

function GameLobbyCtrl:timeEvent()
	this:TextMove();
end

GameLobbyCtrl.isAnim = false
GameLobbyCtrl.notice_width = 0;
function GameLobbyCtrl:TextMove()
	if (this.isAnim == true) then
		local px = GameLobbyPanel.noticeInfo.transform.localPosition.x;
		if (px > (-245 - this.notice_width)) then
			px = px - Time.deltaTime*30;
			GameLobbyPanel.noticeInfo.transform.localPosition = Vector3(px,0,0);
			if (px <= (-245 - this.notice_width)) then
				this.isAnim = false
				GameLobbyPanel.noticeInfo.transform.localPosition = Vector3(245,0,0);
				this:loadNoticeInfo();
			end
		end
	end
end

function GameLobbyCtrl.loadNoticeInfo()
	if (this.isAnim) then
		return
	end
	local text = GameLobbyPanel.getNoticeInfo()
	if (text ~= "") then
		GameLobbyPanel.noticeInfo_UILabel.text = text
		this.notice_width = GameLobbyPanel.noticeInfo_UILabel.printedSize.x + 20
		this.isAnim = true;
		GameLobbyPanel.notice:SetActive(true)
	else
		this.isAnim = false;
		this.notice_width = 0
		GameLobbyPanel.notice:SetActive(false)
	end
end

function GameLobbyCtrl.loadImg()
	GameLobbyPanel.playerIcon_AsyncImageDownload:SetAsyncImage(global.player:get_headimgurl())
end

function GameLobbyCtrl.InitListInfo()
	local list = {}
	local o = {
	icon = "niuniu_logo",
	isopen = true,
	}
	table.insert(list,o)
	local o2 = {
	icon = "shierzhi",
	isopen = true,
	}
	table.insert(list,o2)
	if global.player:get_paytype() ~= 1 then

		local o1 = {
		icon = "tbpaijiutubiao",
		isopen = true,
		}
		table.insert(list,o1)
		local o4 ={
	        icon="yaolezi",
	        isopen=true,
	    }
	    table.insert(list,o4)
		local o3 = {
		icon = "shisanshui",
		isopen = true,
		}
		table.insert(list,o3)
		local o5 = {
		icon = "majiangtubiao",
		isopen = true,
		}
		table.insert(list,o5)

	end

	return list
end

GameLobbyCtrl._LobbyList = {}
function GameLobbyCtrl.renderFunc ()
	-- this.clearLobby()
	local list = this.InitListInfo();
	local parent = GameLobbyPanel.LobbylList;
	local bundle = resMgr:LoadBundle("LobbyBar");
	local Prefab = resMgr:LoadBundleAsset(bundle,"LobbyBar");
	local space = 400;
	local len = #list;
	for i = 1, len do
		local data = list[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "LobbyBar"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(-390 + space*(i - 1), 0, 0);
		this.lobby:AddClick(go, this.OnItemClick);
		resMgr:addAltas(go.transform,"GameLobby")
		local goo = go.transform:Find('iconLobby');
		goo:GetComponent('UISprite').spriteName = data.icon;
		goo:GetComponent('UISprite'):MakePixelPerfect();
		local gameDown = go.transform:Find('gameDown').gameObject;
		if (data.isopen == false) then
			goo:GetComponent('UISprite').color = Color.gray
			gameDown:SetActive(true)
		else
			gameDown:SetActive(false)
		end
		-- this.lobby:AddClick(gameDown, function ()
		-- 	local loadBg = go.transform:Find('loadBg');
		-- 	local loading = go.transform:Find('loadBg/loading');
		-- 	local precent = go.transform:Find('loadBg/precent').gameObject;
		-- 	local precent_UILabel = precent:GetComponent('UILabel');
		-- end);
		table.insert(this._LobbyList,go)
	end
	local colliderW = space * len
	if (colliderW > 1280) then
		GameLobbyPanel.BarCollider:GetComponent('UISprite').width = colliderW
	end
	GameLobbyPanel.rightpage:SetActive(true)
	GameLobbyPanel.LobbylList_UIScrollView.onStoppedMoving = function ()
		local px = GameLobbyPanel.LobbylList.transform.localPosition.x
		GameLobbyPanel.leftpage:SetActive(true)
		GameLobbyPanel.rightpage:SetActive(true)
		if(px > -200) then
			GameLobbyPanel.leftpage:SetActive(false)
		elseif(px < 1280 - colliderW + 200) then
			GameLobbyPanel.rightpage:SetActive(false)
		end
	end
	this.update_data()
end

function GameLobbyCtrl.clearLobby()
	local len = #this._LobbyList;
	for i=1,len do
		local data = this._LobbyList[i]
		if (data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._LobbyList = {}
end

function GameLobbyCtrl.update_data( ... )
	local dealer = mgr_dealer:is_dealer()
	if dealer then
		GameLobbyPanel.agent:SetActive(true)
		this.lobby:AddClick(GameLobbyPanel.agent, function ()
			mgr_dealer:req_data(function ()
				global._view:dealer().Awake()
			end)

		end);
	else
		GameLobbyPanel.agent:SetActive(false)
	end
end

--滚动项单击事件--
function GameLobbyCtrl.OnItemClick(go)
	-- if (go.name == "LobbyBar1") then
	-- 	GameLobbyPanel.openNiuniu()
	-- end
	-- if (go.name=="LobbyBar3")then
	-- 	--global._view:ShierzhiRoom().Awake(111,false,"");
	-- 	global._view:ShierzhiRoom().Awake();
	-- 	return;
	-- end

	--麻将测试
	-- if go.name == "LobbyBar6" then
	-- 	global._view:majiang().Awake(111,false,"")
	-- 	return
	-- end
	global._view.offset = GameLobbyPanel.LobbylList.localPosition.x 
	GameLobbyPanel.openNiuniu(go.name);
	

end

GameLobbyCtrl.IsHaveClick = false
--单击事件--
function GameLobbyCtrl.OnClick(go)
	global._view:setting().Awake();
end

function GameLobbyCtrl.OnShare()
	GameLobbyPanel.shareUI:SetActive(true)
end

function GameLobbyCtrl.OnFind(go)
	-- GameLobbyPanel.openInvation()
	global._view:sendInvitation().Awake()
end

function GameLobbyCtrl.OnBind()
	GameLobbyPanel.shareUI:SetActive(false)
	global._view:joinroom().Awake(2)
end

function GameLobbyCtrl.OnClickBank( go )
	GameLobbyPanel.shareUI:SetActive(false)
	global._view:bank().Awake()
end
function GameLobbyCtrl.OnMail(go)
	GameLobbyPanel.mail_red:SetActive(false)
	GameLobbyPanel.shareUI:SetActive(false)
	global._view:mail().Awake()
end

--关闭事件--
function GameLobbyCtrl.Close()
	this.isAnim = false
	this.clearLobby()
	panelMgr:ClosePanel(CtrlNames.GameLobby);
end

return GameLobbyCtrl