local global = require("global")
local const=global.const;
local mgr_room = global.player:get_mgr("room")
GameScorePanel = {};
local this = GameScorePanel;
GameScorePanel.gameObject = nil;
GameScorePanel.transform = nil;
--启动事件--
function GameScorePanel.Awake(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	global._view:changeLayerAll("GameScore")--必加
	this.cubelist = this.transform:Find("cube/cubelist").gameObject;
	this.BarCollider = this.transform:Find("cube/cubelist/BarCollider").gameObject
	this.BarCollider_UISprite = this.BarCollider:GetComponent('UISprite');
	this.back = this.transform:Find("back").gameObject;
	this.playerIcon = this.transform:Find("PlayerInfo/playerIcon").gameObject;
	this.playerIcon_AsyncImageDownload = this.playerIcon:GetComponent('AsyncImageDownload');
	this.diamondTxt = this.transform:Find("PlayerInfo/diamond/diamondTxt").gameObject;
	this.coinTxt = this.transform:Find("PlayerInfo/coin/coinTxt").gameObject;
	this.diamondTxt = this.transform:Find("PlayerInfo/diamond/diamondTxt"):GetComponent('UILabel');
	this.coinTxt = this.transform:Find("PlayerInfo/coin/coinTxt"):GetComponent('UILabel');
end

function GameScorePanel.updatePlayerInfo()
	this.diamondTxt.text = global.player:get_RMB()
	this.coinTxt.text =global.player:get_money()
end

function GameScorePanel.joinRoomPoto(roomId,roomName,gameID)
	global._view:showLoading();
	global.player:get_mgr("room"):enter(gameID,roomId,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					if(gameID==const.GAME_ID_NIUNIU)then
						global._view:room().Awake(roomId,true,roomName)
					elseif(gameID==const.GAME_ID_12ZHI)then
						global._view:ShierzhiRoom().Awake(roomId,true,roomName)
					elseif(gameID==const.GAME_ID_PAIGOW)then
						global._view:paiGow().Awake(roomId,true,roomName)
					elseif(gameID == const.GAME_ID_YAOLEZI)then
						global._view:YaoLeZi().Awake(roomId,true,roomName)
					elseif(gameID == const.GAME_ID_WATER)then
						global._view:sanshui().Awake(roomId,true,roomName)
					elseif(gameID == const.GAME_ID_MJ)then
						global._view:majiang().Awake(roomId,true,roomName)
					end
				else
					global._view:getViewBase("Tip").setTip(global.errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)
end

function GameScorePanel.SanshuiGameScore(gameID,play_type,bet_coin)
	global._view:showLoading();
	mgr_room:req_get_waterhall_list(gameID,play_type,bet_coin,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			this.ui.reloadRotaList(list)
		end
	end)
end


function GameScorePanel.getHeadUrl()
	return global.player:get_headimgurl()
end

function GameScorePanel.get_RMB()
	return global.player:get_RMB()
end

function GameScorePanel.get_money()
	return global.player:get_money()
end

function GameScorePanel.backNiuniu(gameID)
	global._view:niuniu().Awake(gameID)
end

function GameScorePanel.OnDestroy()
	this.ui.Close()
end

return GameScorePanel