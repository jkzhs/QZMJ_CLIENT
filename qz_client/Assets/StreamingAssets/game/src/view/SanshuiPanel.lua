local global = require("global")

SanshuiPanel = {};
local this = SanshuiPanel;
SanshuiPanel.gameObject = nil;
local transform = nil;
local mgr_water = global.player:get_mgr("water")
local mgr_room = global.player:get_mgr("room")
local mgr_niuniu = global.player:get_mgr("niuniu")
local const = global.const
--启动事件--
function SanshuiPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	this.getPlayerData()
	mgr_water:nw_reg()
	global._view:changeLayerAll("Sanshui")--必加
end

--获取数据
function SanshuiPanel.getPlayerData()
	mgr_water:req("req_data",function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				this.ui.Init(data,const,0,false)
			else
				this.getPlayerData()
			end
		end
	end)
end

--初始化面板--
function SanshuiPanel.InitPanel()
	global._view:PlayBGSound(const.BG_MUSIC_SANSHUI)
	this.backOut = transform:Find("button/backOut").gameObject;
	this.playlist = transform:Find("button/playlist").gameObject;
	this.bank = transform:Find("button/bank").gameObject;
	this.share = transform:Find("button/share").gameObject;
	this.rule = transform:Find("button/rule").gameObject;
	this.back = transform:Find("button/back").gameObject;
	this.invite = transform:Find("button/invite").gameObject;
	this.invite_UISprite = this.invite:GetComponent('UISprite');
	this.invitefabu = transform:Find("button/invite/invitefabu").gameObject;
	this.invitefabu_UISprite = this.invitefabu:GetComponent('UISprite');
	this.inviteyaoqing = transform:Find("button/invite/inviteyaoqing").gameObject;
	this.inviteyaoqing_UISprite = this.inviteyaoqing:GetComponent('UISprite');
	this.betbtn = transform:Find("button/betbtn").gameObject;
	this.rob = transform:Find("button/rob").gameObject;
	this.Pattern = transform:Find("top/Pattern").gameObject;
	this.roomId = transform:Find("top/roomId").gameObject;
	this.roomId_UILabel = this.roomId:GetComponent('UILabel');
	this.roleBetcoin = transform:Find("top/roleBetcoin").gameObject;
	this.roleBetcoin_UILabel = this.roleBetcoin:GetComponent('UILabel');
	this.Pattype = transform:Find("top/Pattern/type").gameObject;
	this.Pattype_UILabel = this.Pattype:GetComponent('UILabel');
	this.allpattern = transform:Find("top/Pattern/allpattern").gameObject;
	this.Patnumber = transform:Find("top/Pattern/number").gameObject;
	this.Patnumber_UILabel = this.Patnumber:GetComponent('UILabel');
	this.PatsumNumber = transform:Find("top/Pattern/allpattern/sumNumber").gameObject;
	this.PatsumNumber_UILabel = this.PatsumNumber:GetComponent('UILabel');
	this.timebg = transform:Find("Tips/timebg").gameObject;
	this.timeTxt = transform:Find("Tips/timebg/timeTxt").gameObject;
	this.timeTxt_UILabel = this.timeTxt:GetComponent('UILabel');
	this.BetState = transform:Find("Tips/timebg/BetState").gameObject;
	this.BetState_UILabel = this.BetState:GetComponent('UILabel');
	this.playerCoin = transform:Find("betDialog/upRight/playerCoin").gameObject;
	this.playerCoin_UILabel = this.playerCoin:GetComponent('UILabel');
	this.playerName = transform:Find("betDialog/upRight/playerName").gameObject;
	this.playerName_UILabel = this.playerName:GetComponent('UILabel');
	this.playerSilver = transform:Find("betDialog/upRight/playerSilver").gameObject;
	this.playerSilver_UILabel = this.playerSilver:GetComponent('UILabel');
	this.PlayerIcon = transform:Find("betDialog/upRight/PlayerIcon").gameObject;
	this.PlayerIcon_AsyncImageDownload = this.PlayerIcon:GetComponent('AsyncImageDownload');
	this.btnFilling = transform:Find("betDialog/bottomRight/btnFilling").gameObject--加注
	this.btnFilling_UISprite = this.btnFilling:GetComponent('UISprite');
	this.btnDel = transform:Find("betDialog/bottomRight/btnDel").gameObject
	this.btnDel_UISprite = this.btnDel:GetComponent('UISprite');
	this.betfive = transform:Find("betDialog/bottomRight/money/betfive").gameObject;
	this.betfive_UISprite = this.betfive:GetComponent('UISprite');
	this.betten = transform:Find("betDialog/bottomRight/money/betten").gameObject;
	this.betten_UISprite = this.betten:GetComponent('UISprite');
	this.bethund = transform:Find("betDialog/bottomRight/money/bethund").gameObject;
	this.bethund_UISprite = this.bethund:GetComponent('UISprite');
	this.betkilo = transform:Find("betDialog/bottomRight/money/betkilo").gameObject;
	this.betkilo_UISprite = this.betkilo:GetComponent('UISprite');
	this.bettenshou = transform:Find("betDialog/bottomRight/money/bettenshou").gameObject;
	this.bettenshou_UISprite = this.bettenshou:GetComponent('UISprite');
	this.betmill = transform:Find("betDialog/bottomRight/money/betmill").gameObject;
	this.betmill_UISprite = this.betmill:GetComponent('UISprite');
	this.BetCoin = transform:Find("betDialog/bottomRight/BetCoin").gameObject;
	this.BetCoin_UILabel = this.BetCoin:GetComponent('UILabel');
	this.betDialog = transform:Find("betDialog").gameObject;
	this.closebet = transform:Find("betDialog/closebet").gameObject;
	this.allRole = transform:Find("allRole").gameObject;
	this.showUI = transform:Find("showUI").gameObject;
	this.uibox = transform:Find("showUI/uibox").gameObject;
	this.collation = transform:Find("collation").gameObject;
	this.headclose = transform:Find("collation/allbtn/headclose").gameObject;
	this.headclose_UISprite = this.headclose:GetComponent('UISprite');
	this.midclose = transform:Find("collation/allbtn/midclose").gameObject;
	this.midclose_UISprite = this.midclose:GetComponent('UISprite');
	this.backclose = transform:Find("collation/allbtn/backclose").gameObject;
	this.backclose_UISprite = this.backclose:GetComponent('UISprite');
	this.closeCollation = transform:Find("collation/allbtn/closeCollation").gameObject;
	this.recovery = transform:Find("collation/allbtn/recovery").gameObject;
	this.paly = transform:Find("collation/allbtn/paly").gameObject;
	this.pairs = transform:Find("collation/allbtn/pairs").gameObject;
	this.pairs_UISprite = this.pairs:GetComponent('UISprite');
	this.twopairs = transform:Find("collation/allbtn/twopairs").gameObject;
	this.twopairs_UISprite = this.twopairs:GetComponent('UISprite');
	this.three = transform:Find("collation/allbtn/three").gameObject;
	this.three_UISprite = this.three:GetComponent('UISprite');
	this.straight = transform:Find("collation/allbtn/straight").gameObject;
	this.straight_UISprite = this.straight:GetComponent('UISprite');
	this.flowers = transform:Find("collation/allbtn/flowers").gameObject;
	this.flowers_UISprite = this.flowers:GetComponent('UISprite');
	this.bottle = transform:Find("collation/allbtn/bottle").gameObject;
	this.bottle_UISprite = this.bottle:GetComponent('UISprite');
	this.Ironbranch = transform:Find("collation/allbtn/Ironbranch").gameObject;
	this.Ironbranch_UISprite = this.Ironbranch:GetComponent('UISprite');
	this.headcollider = transform:Find("collation/backgroud/headcollider").gameObject;
	this.midcollider = transform:Find("collation/backgroud/midcollider").gameObject;
	this.backcollider = transform:Find("collation/backgroud/backcollider").gameObject;
	this.headanima = transform:Find("collation/backgroud/headanima").gameObject;
	this.midanima = transform:Find("collation/backgroud/midanima").gameObject;
	this.backanima = transform:Find("collation/backgroud/backanima").gameObject;
	this.Flush = transform:Find("collation/allbtn/Flush").gameObject;
	this.Flush_UISprite = this.Flush:GetComponent('UISprite');
	this.choicebtn = transform:Find("collation/allbtn/choicebtn").gameObject;
	this.specAnima = transform:Find("specAnima").gameObject;
	this.specIcon = transform:Find("specAnima/specIcon").gameObject;
	this.specIcon_UISprite = this.specIcon:GetComponent('UISprite');
	this.specback = transform:Find("specAnima/specback").gameObject;
	this.cardList = transform:Find("collation/arrayInfo/cardList").gameObject;
	this.cardList_UIScrollView = this.cardList:GetComponent('UIScrollView');
	this.Collider = transform:Find("collation/arrayInfo/cardList/Collider").gameObject;
	this.Collider_UISprite = this.Collider:GetComponent('UISprite');
	this.Tips = transform:Find("Tips").gameObject;
	this.fristenter = transform:Find("Tips/fristenter").gameObject;
	this.cardEffect = transform:Find("showUI/cardEffect").gameObject;
	this.bulletEffect = transform:Find("showUI/bulletEffect").gameObject;
	this.balanceEnter = transform:Find("showUI/balanceEnter").gameObject;
	this.balanceList = transform:Find("showUI/balanceEnter/balanceList").gameObject;
	this.balanceList_UIScrollView = this.balanceList:GetComponent('UIScrollView');
	this.balanceCollider = transform:Find("showUI/balanceEnter/balanceList/balanceCollider").gameObject;
	this.balanceCollider_UISprite = this.balanceCollider:GetComponent('UISprite');
end

function SanshuiPanel.getTime()
	return global.ts_now;
end

function SanshuiPanel.getPlayerCoin()
	return global.player:get_money()
end

function SanshuiPanel.getPlayerName()
	return global.player:get_name()
end

function SanshuiPanel.getPlayerId()
	return global.player:get_playerid()
end

function SanshuiPanel.getPlayerRMB()
	return global.player:get_RMB()
end

function SanshuiPanel.getPlayerImg()
	return global.player:get_headimgurl()
end

function SanshuiPanel.setTip(text)
	global._view:getViewBase("Tip").setTip(text)
end

SanshuiPanel.IsClickBack = false
function SanshuiPanel.backNiuniu(value)
	this.IsClickBack = value
	if(value) then
		mgr_room:exit(const.GAME_ID_WATER,function ()
		end)
		this.gameScore()
	else
		global._view:niuniu().Awake(const.GAME_ID_WATER);
	end
end

function SanshuiPanel.gameScore()
	global._view:showLoading();
	mgr_room:req_get_waterhall_list(const.GAME_ID_WATER,nil,nil,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil and list ~= nil) then
			global._view:gameScore().Awake(list,const.GAME_ID_WATER)
		end
	end)
end

function SanshuiPanel.EnterPlayData(data)
	if(this.ui ~= nil) then
		local len = #data.members
		for i=1,len do
			local member = data.members[i]
			local value = this.ui.checkPlayerIsCxist(member.playerid)
			if(value == false) then
				local info = {
					name = GameData.GetShortName(member.player_name,10,7),
					icon = member.headimgurl,
					coin = member.money + member.RMB,
					id = member.playerid,
					betcoin = 0,
				}
				this.ui.InsertPlayerInfo(info)
			end
		end
	end
end

function SanshuiPanel.OutPlayData(id)
	if(this.ui ~= nil) then
		this.ui.DeletePlayerInfo(id)
	end
end

function SanshuiPanel.updateBetAreaCoin(data)
	if(this.ui ~= nil) then
		this.ui.updatePosCoin(data.playerid,data.own_money,data.bet_money)
	end
end

function SanshuiPanel.DownBankerAction(data,op_type)
	if(this.ui ~= nil) then
		if(op_type == 1) then
			this.Patnumber_UILabel.text = data.bout
			this.backOut:SetActive(false)
		end
	end
end

function SanshuiPanel.TrimAction(id)
	if(this.ui ~= nil) then
		this.ui.toCleanPlayerCard(id)
	end
end

--获取抢庄的信息
function SanshuiPanel.getRobInfo()
	global._view:showLoading();
	mgr_water:req_rob_banker_info(function (data,ec)
		global._view:hideLoading();
		if(#data > 0 and this.ui ~= nil) then
			this.ui.robCallBack(data[1])
		else
			this.setTip(global.errcode_util:get_errcode_CN(ec))
		end
	end);
end

--抢庄
function SanshuiPanel.robData(coin)
	global._view:showLoading();
	mgr_water:req_rob_banker(coin,function (data)
		global._view:hideLoading();
		if(data.errcode == 0) then
			if(this.ui ~= nil) then
				this.ui.closeShowUI()
			end
		else
			this.setTip("抢庄失败")
		end
	end);
end

--下注
function SanshuiPanel.betData(value)
	global._view:showLoading();
	mgr_water:req_bet(value,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					this.ui.BetFillCallBack(data.bet_money)
					local all = global.player:get_money() + global.player:get_RMB()
					this.ui.updatePosCoin(global.player:get_playerid(),all,data.bet_money)
					this.ui.updatePlayerInfo()
				else
					this.setTip(global.errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)
end

function SanshuiPanel.memberSort(list)
	table.sort(list,function (a,b)
        return a.RMB + a.money > b.RMB + b.money
    end)
    return list
end

function SanshuiPanel.getPlayerList()
	global._view:showLoading();
	mgr_niuniu:req_room_members(1,200,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					local list = this.memberSort(data.members)
					global._view:playerList().Awake(list);
				else
					this.setTip(global.errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)
end

--出牌
function SanshuiPanel.TrimCard(cardtype,cards)
	global._view:showLoading();
	mgr_water:req_trim_card(cardtype,cards,function (errcode)
		global._view:hideLoading();
		if(errcode == 0) then
			if(this.ui ~= nil) then
				this.specAnima:SetActive(false)
				this.collation:SetActive(false)
				this.ui.toCleanPlayerCard(global.player:get_playerid())
			end
		else
			this.setTip(global.errcode_util:get_errcode_CN(errcode))
		end
	end);
end

function SanshuiPanel.DropBanker()
	global._view:showLoading();
	mgr_water:req_drop_banker(function (data)
		global._view:hideLoading();
	end)
end

function SanshuiPanel.setRoomBtnState(data)
	if(this.ui ~= nil) then
		this.ui.updateBetState(data,data.liuju,data.daobang)
	end
end

function SanshuiPanel.PlayerToCard(id)
	if(this.ui ~= nil) then
		this.ui.toCleanPlayerCard(id)
	end
end

function SanshuiPanel.OnDestroy()
	if(this.IsClickBack == false) then
		mgr_room:exit(const.GAME_ID_WATER,function ()
		end)
	end
	this.ui.Close()
	mgr_water:nw_unreg()
end

return SanshuiPanel