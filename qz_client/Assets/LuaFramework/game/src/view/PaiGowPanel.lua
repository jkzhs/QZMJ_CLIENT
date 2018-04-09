local global = require("global")

PaiGowPanel = {};
local transform;
local mgr_pai = global.player:get_mgr("paigow")
local mgr_room = global.player:get_mgr("room")
local mgr_niuniu = global.player:get_mgr("niuniu")
local const = global.const
local this = PaiGowPanel;
local config_paigow = global.config_mgr.get("paigow")
PaiGowPanel.gameObject = nil;
--启动事件--
function PaiGowPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	this.getPlayerData()
	mgr_pai:nw_reg()
	global._view:changeLayerAll("PaiGow")
end

--获取数据
function PaiGowPanel.getPlayerData()
	mgr_pai:req("req_data",function (data)
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
function PaiGowPanel.InitPanel()
	
	this.PlayBGSound(const.GAME_ID_PAIGOW)
	
	this.push = transform:Find("bottomRight/push").gameObject;
	this.backOut = transform:Find("bottomRight/backOut").gameObject;
	this.btnFilling = transform:Find("bottomRight/btnFilling").gameObject--加注
	this.btnFilling_UISprite = this.btnFilling:GetComponent('UISprite');
	this.btnDel = transform:Find("bottomRight/btnDel").gameObject
	this.btnDel_UISprite = this.btnDel:GetComponent('UISprite');
	this.betfive = transform:Find("bottomRight/money/betfive").gameObject;
	this.betfive_UISprite = this.betfive:GetComponent('UISprite');
	this.betten = transform:Find("bottomRight/money/betten").gameObject;
	this.betten_UISprite = this.betten:GetComponent('UISprite');
	this.bethund = transform:Find("bottomRight/money/bethund").gameObject;
	this.bethund_UISprite = this.bethund:GetComponent('UISprite');
	this.betkilo = transform:Find("bottomRight/money/betkilo").gameObject;
	this.betkilo_UISprite = this.betkilo:GetComponent('UISprite');
	this.bettenshou = transform:Find("bottomRight/money/bettenshou").gameObject;
	this.bettenshou_UISprite = this.bettenshou:GetComponent('UISprite');
	this.betmill = transform:Find("bottomRight/money/betmill").gameObject;
	this.betmill_UISprite = this.betmill:GetComponent('UISprite');
	this.BetCoin = transform:Find("bottomRight/BetCoin").gameObject;
	this.BetCoin_UILabel = this.BetCoin:GetComponent('UILabel');
	this.playlist = transform:Find("bottomleft/playlist").gameObject;
	this.bank = transform:Find("bottomleft/bank").gameObject;
	this.share = transform:Find("bottomleft/share").gameObject;
	this.rule = transform:Find("bottomleft/rule").gameObject;
	this.back = transform:Find("bottomleft/back").gameObject;
	this.invite = transform:Find("bottomleft/invite").gameObject;
	this.invite_UISprite = this.invite:GetComponent('UISprite');
	this.invitefabu = transform:Find("bottomleft/invite/invitefabu").gameObject;
	this.invitefabu_UISprite = this.invitefabu:GetComponent('UISprite');
	this.inviteyaoqing = transform:Find("bottomleft/invite/inviteyaoqing").gameObject;
	this.inviteyaoqing_UISprite = this.inviteyaoqing:GetComponent('UISprite');
	this.bankerName = transform:Find("upLeft/bankerName").gameObject;
	this.bankerName_UILabel = this.bankerName:GetComponent('UILabel');
	this.robHead = transform:Find("upLeft/HeadPanel/robHead").gameObject;
	this.robHead_AsyncImageDownload = this.robHead:GetComponent('AsyncImageDownload');
	this.roomId = transform:Find("upLeft/roomId").gameObject;
	this.roomId_UILabel = this.roomId:GetComponent('UILabel');
	this.rob = transform:Find("upLeft/rob").gameObject;
	this.rob_UISprite = this.rob:GetComponent('UISprite');
	this.robEffect = transform:Find("upLeft/rob/robEffect").gameObject;
	this.robBg = transform:Find("upLeft/robBg").gameObject;
	this.robBg_UISprite = this.robBg:GetComponent('UISprite');
	this.Pattern = transform:Find("upLeft/Pattern").gameObject;
	this.Pattype = transform:Find("upLeft/Pattern/type").gameObject;
	this.Pattype_UILabel = this.Pattype:GetComponent('UILabel');
	this.allpattern = transform:Find("upLeft/Pattern/allpattern").gameObject;
	this.Patnumber = transform:Find("upLeft/Pattern/number").gameObject;
	this.Patnumber_UILabel = this.Patnumber:GetComponent('UILabel');
	this.PatsumNumber = transform:Find("upLeft/Pattern/allpattern/sumNumber").gameObject;
	this.PatsumNumber_UILabel = this.PatsumNumber:GetComponent('UILabel');

	this.timeTxt = transform:Find("timebg/timeTxt").gameObject;
	this.timeTxt_UILabel = this.timeTxt:GetComponent('UILabel');
	this.BetState = transform:Find("timebg/BetState").gameObject;
	this.BetState_UILabel = this.BetState:GetComponent('UILabel');
	this.tiprob = transform:Find("timebg/tiprob").gameObject;
	this.cardPanel = transform:Find("cardPanel");
	this.resultAnima = transform:Find("cardPanel/resultAnima").gameObject;
	this.paiOld = transform:Find("cardPanel/paiOld");
	this.Spritec = transform:Find("cardPanel/paiPanel/Spritec").gameObject;
	this.Spritec_TweenScale = this.Spritec:GetComponent('TweenScale');
	this.Caesar = transform:Find("cardPanel/paiPanel/Spritec/Caesar").gameObject;
	this.Caesar_UISprite = this.Caesar:GetComponent('UISprite');
	this.finalc = transform:Find("cardPanel/paiPanel/Spritec/finalc").gameObject;
	this.finalc1 = transform:Find("cardPanel/paiPanel/Spritec/finalc/finalc1").gameObject;
	this.finalc1_UISprite = this.finalc1:GetComponent('UISprite');
	this.finalc2 = transform:Find("cardPanel/paiPanel/Spritec/finalc/finalc2").gameObject;
	this.finalc2_UISprite = this.finalc2:GetComponent('UISprite');
	this.finalc3 = transform:Find("cardPanel/paiPanel/Spritec/finalc/finalc3").gameObject;
	this.finalc3_UISprite = this.finalc3:GetComponent('UISprite');
	this.paiPanel = transform:Find("cardPanel/paiPanel").gameObject;
	this.paiBox = transform:Find("cardPanel/paiPanel/paiBox").gameObject;
	this.noRobback = transform:Find("cardPanel/noRobback").gameObject;
	this.Robback = transform:Find("cardPanel/Robback").gameObject;
	this.rightbet1 = transform:Find("cardPanel/rightbet1").gameObject;
	this.leftbet1 = transform:Find("cardPanel/rightbet1/leftbet1").gameObject;
	this.rightbet2 = transform:Find("cardPanel/rightbet2").gameObject;
	this.leftbet2 = transform:Find("cardPanel/rightbet2/leftbet2").gameObject;
	this.rightbet3 = transform:Find("cardPanel/rightbet3").gameObject;
	this.leftbet3 = transform:Find("cardPanel/rightbet3/leftbet3").gameObject;
	this.rightbet4 = transform:Find("cardPanel/rightbet4").gameObject;
	this.leftbet4 = transform:Find("cardPanel/rightbet4/leftbet4").gameObject;
	this.rightbet5 = transform:Find("cardPanel/rightbet5").gameObject;
	this.leftbet5 = transform:Find("cardPanel/rightbet5/leftbet5").gameObject;
	this.rightbet6 = transform:Find("cardPanel/rightbet6").gameObject;
	this.leftbet6 = transform:Find("cardPanel/rightbet6/leftbet6").gameObject;
	this.h1 = transform:Find("cardPanel/h1").gameObject;
	this.h2 = transform:Find("cardPanel/h2").gameObject;
	this.h3 = transform:Find("cardPanel/h3").gameObject;
	this.headdown = transform:Find("cardPanel/h1/headdown").gameObject;
	this.headdown_UILabel = this.headdown:GetComponent('UILabel');
	this.headright = transform:Find("cardPanel/h2/headright").gameObject;
	this.headright_UILabel = this.headright:GetComponent('UILabel');
	this.headleft = transform:Find("cardPanel/h3/headleft").gameObject;
	this.headleft_UILabel = this.headleft:GetComponent('UILabel');
	this.myheaddown = transform:Find("cardPanel/h1/myheaddown").gameObject;
	this.myheaddown_UILabel = this.myheaddown:GetComponent('UILabel');
	this.myheadright = transform:Find("cardPanel/h2/myheadright").gameObject;
	this.myheadright_UILabel = this.myheadright:GetComponent('UILabel');
	this.myheadleft = transform:Find("cardPanel/h3/myheadleft").gameObject;
	this.myheadleft_UILabel = this.myheadleft:GetComponent('UILabel');
	this.CoinAnima = transform:Find("cardPanel/CoinAnima").gameObject;
	this.b1 = transform:Find("cardPanel/b1").gameObject;
	this.b2 = transform:Find("cardPanel/b2").gameObject;
	this.b3 = transform:Find("cardPanel/b3").gameObject;
	this.backdown = transform:Find("cardPanel/b1/backdown").gameObject;
	this.backdown_UILabel = this.backdown:GetComponent('UILabel');
	this.backright = transform:Find("cardPanel/b2/backright").gameObject;
	this.backright_UILabel = this.backright:GetComponent('UILabel');
	this.backleft = transform:Find("cardPanel/b3/backleft").gameObject;
	this.backleft_UILabel = this.backleft:GetComponent('UILabel');
	this.mybackdown = transform:Find("cardPanel/b1/mybackdown").gameObject;
	this.mybackdown_UILabel = this.mybackdown:GetComponent('UILabel');
	this.mybackright = transform:Find("cardPanel/b2/mybackright").gameObject;
	this.mybackright_UILabel = this.mybackright:GetComponent('UILabel');
	this.mybackleft = transform:Find("cardPanel/b3/mybackleft").gameObject;
	this.mybackleft_UILabel = this.mybackleft:GetComponent('UILabel');

	this.playerCoin = transform:Find("upRight/playerCoin").gameObject;
	this.playerCoin_UILabel = this.playerCoin:GetComponent('UILabel');
	this.playerName = transform:Find("upRight/playerName").gameObject;
	this.playerName_UILabel = this.playerName:GetComponent('UILabel');
	this.playerSilver = transform:Find("upRight/playerSilver").gameObject;
	this.playerSilver_UILabel = this.playerSilver:GetComponent('UILabel');
	this.PlayerIcon = transform:Find("upRight/PlayerIcon").gameObject;
	this.PlayerIcon_AsyncImageDownload = this.PlayerIcon:GetComponent('AsyncImageDownload');
	this.Tips = transform:Find("Tips").gameObject;
	this.fristenter = transform:Find("Tips/fristenter").gameObject;
	-- this.noRobBox = transform:Find("Tips/noRobBox").gameObject;
	-- this.RobBox = transform:Find("Tips/RobBox").gameObject;

	this.showUI = transform:Find("showUI").gameObject;
	this.uibox = transform:Find("showUI/uibox").gameObject;
	this.balanceEnter = transform:Find("showUI/balanceEnter").gameObject;
	this.balanceList = transform:Find("showUI/balanceEnter/balanceList").gameObject;
	this.balanceList_UIScrollView = this.balanceList:GetComponent('UIScrollView');
	this.balanceCollider = transform:Find("showUI/balanceEnter/balanceList/balanceCollider").gameObject;
	this.balanceCollider_UISprite = this.balanceCollider:GetComponent('UISprite');
end

function PaiGowPanel.getTime()
	return global.ts_now;
end

function PaiGowPanel.getPlayerCoin()
	return global.player:get_money()
end

function PaiGowPanel.getPlayerName()
	return global.player:get_name()
end

function PaiGowPanel.getPlayerId()
	return global.player:get_playerid()
end

function PaiGowPanel.getPlayerRMB()
	return global.player:get_RMB()
end

function PaiGowPanel.getPlayerImg()
	return global.player:get_headimgurl()
end

function PaiGowPanel.getGowName(data)
	return config_paigow.get_name(data)
end

function PaiGowPanel.setTip(text)
	global._view:getViewBase("Tip").setTip(text)
end

PaiGowPanel.IsClickBack = false
function PaiGowPanel.backNiuniu(value)
	this.IsClickBack = value
	if(value) then
		mgr_room:exit(const.GAME_ID_PAIGOW,function ()
		end)
		this.gameScore()
	else
		global._view:niuniu().Awake(const.GAME_ID_PAIGOW);
	end
end


function PaiGowPanel.gameScore()
	global._view:showLoading();
	mgr_room:req_get_hall_list(const.GAME_ID_PAIGOW,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			global._view:gameScore().Awake(list,const.GAME_ID_PAIGOW)
		end
	end)
end

--获取抢庄的信息
function PaiGowPanel.getRobInfo()
	global._view:showLoading();
	mgr_pai:req_rob_banker_info(function (data,ec)
		global._view:hideLoading();
		if(#data > 0 and this.ui ~= nil) then
			this.ui.robCallBack(data[1])
		else
			this.setTip(global.errcode_util:get_errcode_CN(ec))
		end
	end);
end

--抢庄
function PaiGowPanel.robData(coin)
	global._view:showLoading();
	mgr_pai:req_rob_banker(coin,function (data)
		global._view:hideLoading();
		if(data.errcode == 0) then
			if(this.ui ~= nil) then
				this.ui.closeShowUI()
			end
		else
			this.setTip(global.errcode_util:get_errcode_CN(data.errcode))
		end
	end);
end

--下注
function PaiGowPanel.betData(value,pos)
	global._view:showLoading();
	mgr_pai:req_bet(value,pos,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					this.ui.BetFillCallBack(data.bet_money)
					this.ui.updatePlayerInfo()
					this.ui.updatePosCoin(data.bet_pos,data.bet_money,0)
					local posStr = ""
					if(data.bet_pos == 1) then
						posStr = "巡门头水"
					elseif(data.bet_pos == 2) then
						posStr = "巡门后档"
					elseif(data.bet_pos == 3) then
						posStr = "川门头水"
					elseif(data.bet_pos == 4) then
						posStr = "川门后档"
					elseif(data.bet_pos == 5) then
						posStr = "尾门头水"
					elseif(data.bet_pos == 6) then
						posStr = "尾门后档"
					end
					local list ={
						player_name = data.player_name,
						msg = data.player_name.."下注".. posStr .. data.bet_money,
						from_headid=data.headimgurl,
					}
					local who = 0
					if(data.player_name ~= global.player:get_name()) then
						who = 1
					end

					if(global._view:getViewBase("Chat")~=nil)then
						global._view:getViewBase("Chat").UpdateMessage(list,who);
					end
				else
					this.setTip(global.errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)
end

function PaiGowPanel.updateBetAreaCoin(data,who)
	if(this.ui ~= nil) then
		this.ui.updatePosCoin(data.bet_pos,data.bet_money,who)
	end
end

function PaiGowPanel.memberSort(list)
	table.sort(list,function (a,b)
        return a.RMB + a.money > b.RMB + b.money
    end)
    return list
end

function PaiGowPanel.getPlayerList()
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

function PaiGowPanel.PushOver()
	global._view:showLoading();
	mgr_pai:req_push_over(function (data)
		global._view:hideLoading();
	end)
end

function PaiGowPanel.DropBanker()
	global._view:showLoading();
	mgr_pai:req_drop_banker(function (data)
		global._view:hideLoading();
	end)
end

function PaiGowPanel.DownBankerAction(data,op_type)
	if(this.ui ~= nil) then
		this.ui.clearRecordList()
		this.ui.clearLastGowList()
		this.ui.round = 1
		this.Patnumber_UILabel.text = bout
		this.ui.updateBankerInfo(data,op_type);
	end
end

function PaiGowPanel.setRoomBtnState(data)
	if(this.ui ~= nil) then
		this.ui.updateBetState(data,data.liuju,data.daobang)
	end
end

function PaiGowPanel.PlayBGSound(gameid)
	global._view:PlayBGSound(gameid)
end 

function PaiGowPanel.OnDestroy()
	if(this.IsClickBack == false) then
		mgr_room:exit(const.GAME_ID_PAIGOW,function ()
		end)
	end
	mgr_pai:nw_unreg()
	this.ui.Close()
end

return PaiGowPanel