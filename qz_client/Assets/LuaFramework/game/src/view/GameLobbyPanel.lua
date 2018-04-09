local global = require("global")
local transform;
GameLobbyPanel = {};
local this = GameLobbyPanel;
GameLobbyPanel.gameObject = nil;
--启动事件--
function GameLobbyPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.timeEvent();
	this.InitPanel();
	global._view:hideLoading();
	global._view:changeLayerAll("GameLobby")--必加
end

function GameLobbyPanel.timeEvent()
    global._view:addTimeEvent(this.gameObject.name,function()
    	this.ui.timeEvent()
    end)
end

--初始化面板--
function GameLobbyPanel.InitPanel()
	this.LobbylList = transform:Find("LobbylList");
	this.LobbylList_UIScrollView = this.LobbylList:GetComponent('UIScrollView');
	this.BarCollider = transform:Find("LobbylList/BarCollider");
	this.btnshare = transform:Find("PlayerInfo/share").gameObject;
	this.btninvite = transform:Find("PlayerInfo/invite").gameObject;
	this.btnbank = transform:Find("PlayerInfo/bank").gameObject;
	this.btnshop = transform:Find("PlayerInfo/shop").gameObject;
	this.btnsetting = transform:Find("PlayerInfo/setting").gameObject;
	this.btncustom = transform:Find("PlayerInfo/custom").gameObject;
	this.diamondTxt = transform:Find("PlayerInfo/diamond/diamondTxt").gameObject;
	this.coinTxt = transform:Find("PlayerInfo/coin/coinTxt").gameObject;
	this.playerIcon = transform:Find("PlayerInfo/playerIcon").gameObject;
	this.playerIcon_AsyncImageDownload = this.playerIcon:GetComponent('AsyncImageDownload');
	this.diamondTxt = transform:Find("PlayerInfo/diamond/diamondTxt"):GetComponent('UILabel');
	this.coinTxt = transform:Find("PlayerInfo/coin/coinTxt"):GetComponent('UILabel');
	this.cardnum = transform:Find("PlayerInfo/cardnum").gameObject;
	this.cardnum_UILabel = this.cardnum:GetComponent('UILabel');
	this.openShop = transform:Find("PlayerInfo/openShop").gameObject;
	this.agent = transform:Find("LobbyUp/agent").gameObject;
	this.bind = transform:Find("LobbyUp/bind").gameObject;
	this.shareall = transform:Find('LobbyUp/shareUI/shareall').gameObject;
	this.sharefriend = transform:Find('LobbyUp/shareUI/sharefriend').gameObject;
	this.closeShare = transform:Find('LobbyUp/shareUI/closeShare').gameObject;
	this.shareUI = transform:Find('LobbyUp/shareUI').gameObject;
	this.notice = transform:Find('notice').gameObject;
	this.noticeInfo = transform:Find('notice/Context/noticeInfo').gameObject;
	this.noticeInfo_UILabel = this.noticeInfo:GetComponent('UILabel');
	this.playerId = transform:Find('PlayerInfo/playerId').gameObject;
	this.playerId_UILabel = this.playerId:GetComponent('UILabel');
	this.playerName = transform:Find('PlayerInfo/playerName').gameObject;
	this.playerName_UILabel = this.playerName:GetComponent('UILabel');
	this.leftpage = transform:Find('LobbyUp/leftpage').gameObject;
	this.rightpage = transform:Find('LobbyUp/rightpage').gameObject;

	this.btnmail = transform:Find("PlayerInfo/mail").gameObject
	this.mail_red = this.btnmail.transform:Find("quan").gameObject
	this.mail_label = this.mail_red.transform:Find("Label"):GetComponent("UILabel")
	
end

function GameLobbyPanel.ReqMailData()
	local mgr_mail= global.player:get_mgr("mail")
    mgr_mail:req_get_uncheck_mail_count()
end 
function GameLobbyPanel.UpdataMailBtn(value)
	if value and value > 0 then 
		this.mail_red:SetActive(true)
		if value >=100 then 
			value = "-"
		end 
		this.mail_label.text = value
	else 
		this.mail_red:SetActive(false)
	end 
end 
function GameLobbyPanel.updatePlayerInfo()
	this.cardnum_UILabel.text = global.player:get_ticket()
	this.diamondTxt.text = global.player:get_RMB()
	this.coinTxt.text = global.player:get_money()
	this.playerId_UILabel.text = global.player:get_playerid()
	this.playerName_UILabel.text = GameData.GetShortName(global.player:get_name(),10,10)
end

function GameLobbyPanel.getNoticeInfo()
	return global._view.noticeVec;
end

function GameLobbyPanel.playNoticeInfo()
	if(this.ui ~= nil) then
		this.ui.loadNoticeInfo()
	end
end

function GameLobbyPanel.openNiuniu(name)
	-- global._view:showLoading();
	-- global.player:get_mgr("dealer"):req_data(function ()
	-- 	global._view:hideLoading();
	if (name=="LobbyBar1")then 
		global._view:niuniu().Awake(global.const.GAME_ID_NIUNIU);
	elseif (name=="LobbyBar2")then
	   global._view:niuniu().Awake(global.const.GAME_ID_12ZHI);
	elseif(name=="LobbyBar3" )then
		global._view:niuniu().Awake(global.const.GAME_ID_PAIGOW);
	elseif(name=="LobbyBar4")then 
        global._view:niuniu().Awake(global.const.GAME_ID_YAOLEZI);
    elseif(name=="LobbyBar5")then 
		global._view:niuniu().Awake(global.const.GAME_ID_WATER);
	elseif(name=="LobbyBar6")then 
		global._view:niuniu().Awake(global.const.GAME_ID_MJ);
	end 
	
	-- end)
end
function GameLobbyPanel.openshierzhi()
	-- global._view:showLoading();
	-- global.player:get_mgr("dealer"):req_data(function ()
	-- 	global._view:hideLoading();
		global._view:Shierzhi().Awake(global.const.GAME_ID_NIUNIU);
	-- end)
end
-- function GameLobbyPanel.openInvation()
-- 	global._view:showLoading();
-- 	global.player:get_mgr("room"):req_invite_roomlist(global.const.GAME_ID_NIUNIU,function (list)
-- 		global._view:hideLoading();

-- 	end)
-- end

function GameLobbyPanel.OnDestroy()
	global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
end

function GameLobbyPanel.update_data()
	this.ui.update_data()
end

return GameLobbyPanel