local global = require("global")
local transform;
local mgr_room = global.player:get_mgr("room")
local mgr_12zhi = global.player:get_mgr("12zhi")
local const = global.const
local errcode_util = global.errcode_util
ShierzhiRoomPanel = {};
local this = ShierzhiRoomPanel;

ShierzhiRoomPanel.gameObject = nil;
ShierzhiRoomPanel.IsClickBack = false

function ShierzhiRoomPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	--this.timeEvent()
	this.InitPanel();
	global._view:changeLayerAll("ShierzhiRoom")

	mgr_room:nw_reg()
	mgr_12zhi:nw_reg();--后面加上
	this.getPlayerData()
end

function ShierzhiRoomPanel.InitPanel()

	this.PlayBGSound(const.GAME_ID_12ZHI)
	--下注棋子中间面板
	this.ChessList=transform:Find("CenterBG/ChessList");
	this.FourChessList=transform:Find("CenterBG/FourChessList");
	this.VChessList=transform:Find("CenterBG/VChessList");
	this.WChessList=transform:Find("CenterBG/WChessList");
	this.houseChessBox=transform:Find("houseChessBox");
	--右下 下注筹码
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
	--确定 下注
	this.okBtn=transform:Find("bottomRight/OKBtn").gameObject;
	this.okBtn_UISprtie=this.okBtn:GetComponent("UISprite");
	--清除按钮 取消当前的下注
	this.clearBtn=transform:Find("bottomRight/ClearBtn").gameObject;
	this.clearBtn_UISprite=this.clearBtn:GetComponent("UISprite");
	--下庄按钮
	this.loseRob_Btn=transform:Find("bottomleft/loseRob").gameObject;
	this.loseRob_Btn_Sprite=this.loseRob_Btn:GetComponent("UISprite");
	--左下
	this.playlist = transform:Find("bottomleft/playlist").gameObject;
	this.bank = transform:Find("bottomleft/bank").gameObject;
	this.share = transform:Find("bottomleft/share").gameObject;
	this.rule = transform:Find("bottomleft/rule").gameObject;
	this.back = transform:Find("bottomleft/back").gameObject;
	-- this.selectChessBtn=transform:Find("bottomleft/SelectChessBtn").gameObject;--庄家选择棋子界面
	-- this.selectChessBtn_UISprite=this.selectChessBtn:GetComponent("UISprite");
	this.invite = transform:Find("bottomleft/invite").gameObject;
	this.invite_UISprite = this.invite:GetComponent('UISprite');
	this.invitefabu = transform:Find("bottomleft/invite/invitefabu").gameObject;
	this.invitefabu_UISprite = this.invitefabu:GetComponent('UISprite');
	this.inviteyaoqing = transform:Find("bottomleft/invite/inviteyaoqing").gameObject;
	this.inviteyaoqing_UISprite = this.inviteyaoqing:GetComponent('UISprite');

	this.history = transform:Find("bottomleft/history").gameObject
	

	--左上
	this.bankerName = transform:Find("upLeft/bankerName").gameObject;
	this.bankerName_UILabel = this.bankerName:GetComponent('UILabel');
	this.robHead = transform:Find("upLeft/HeadPanel/robHead").gameObject;
	this.robHead_openTwo = transform:Find("upLeft/HeadPanel/robHead_openTwo").gameObject;
	this.robHead_AsyncImageDownload = this.robHead:GetComponent('AsyncImageDownload');
	this.roomId = transform:Find("upLeft/RoomIDBg/roomId").gameObject;
	this.roomId_UILabel = this.roomId:GetComponent('UILabel');
	this.rob = transform:Find("upLeft/rob").gameObject;
	this.rob_UISprite = this.rob:GetComponent('UISprite');
	this.robEffect = transform:Find("upLeft/rob/robEffect").gameObject;
	this.robBg = transform:Find("upLeft/robBg").gameObject;
	this.robBg_UISprite = this.robBg:GetComponent('UISprite');

	--时钟
	this.timeTxt = transform:Find("timebg/timeTxt").gameObject;
	this.timeTxt_UILabel = this.timeTxt:GetComponent('UILabel');
	this.BetState = transform:Find("timebg/BetState").gameObject;
	this.BetState_UILabel = this.BetState:GetComponent('UILabel');
	this.tiprob = transform:Find("timebg/tiprob").gameObject;

	--右上
	this.playerCoin = transform:Find("upRight/playerCoin").gameObject;
	this.playerCoin_UILabel = this.playerCoin:GetComponent('UILabel');
	this.playerName = transform:Find("upRight/playerName").gameObject;
	this.playerName_UILabel = this.playerName:GetComponent('UILabel');
	this.playerSilver = transform:Find("upRight/playerSilver").gameObject;
	this.playerSilver_UILabel = this.playerSilver:GetComponent('UILabel');
	this.PlayerIcon = transform:Find("upRight/PlayerIcon").gameObject;
	this.PlayerIcon_AsyncImageDownload = this.PlayerIcon:GetComponent('AsyncImageDownload');
	--下注总金额显示
	this.sumBetMoney_UILabel=transform:Find("upRight/SumBetMoney/Label"):GetComponent("UILabel");
	this.sumBetMoney_UILabel.text=0;

	this.upRight = transform:Find("upRight");
	this.pattern=this.upRight:Find("Pattern").gameObject;
	this.pattern_group_1 = this.pattern.transform:Find("group1")
	this.pattern_group_2 = this.pattern.transform:Find("group2")
	this.pattern_type_Label=this.pattern_group_1:Find("type"):GetComponent("UILabel");
	this.pattern_number_Label=this.pattern_group_1:Find("number"):GetComponent("UILabel");
	this.pattern_sumNumber_Label=this.pattern_group_1:Find("sumNumber"):GetComponent("UILabel");
	this.pattern_periods_Label = this.pattern_group_2:Find("periods"):GetComponent("UILabel")

	--庄家遮罩
	this.Shade=transform:Find("Shade").gameObject;
	this.ShadePos=this.Shade.transform.localPosition;
	this.Shade_Di=this.Shade.transform:Find("ShadeSprite").gameObject;
	this.Shade_Di_Sprite=this.Shade_Di:GetComponent("UISprite");
	--this.Shade_Anim=this.Shade:GetComponent("Animator");
	this.Shade_Lid=this.Shade.transform:Find("ShadeLid").gameObject;
	this.ShadeChess=this.Shade_Di_Sprite.transform:Find("Chess").gameObject;
	this.ShadeChess_UISprite=this.ShadeChess.transform:Find("Sprite"):GetComponent("UISprite");
	this.ShadeChess_Quan_UISprite=this.ShadeChess.transform:Find("quan"):GetComponent("UISprite");
	--this.ShadeChess_Anim=this.ShadeChess:GetComponent("Animator");
	this.HouseOwnerPanel=transform:Find("showUI/HouseOwner").gameObject;
	this.HouseChessList=transform:Find("showUI/HouseOwner/HouseChessList");
	this.HouseClose=this.HouseOwnerPanel.transform:Find("Close").gameObject;
	-- this.ownerPanelShade=this.HouseOwnerPanel.transform:Find("Shade").gameObject;
	this.ownerPanelShade=this.HouseChessList:Find("Shade").gameObject;
	this.ownerShade_Chess=this.ownerPanelShade.transform:Find("ShadeSprite/Chess").gameObject;
	this.ownerShade_Chess_UISprite=this.ownerShade_Chess.transform:Find("Sprite"):GetComponent("UISprite");
	this.ownerShade_Chess_Quan_UISprite=this.ownerShade_Chess.transform:Find("quan"):GetComponent("UISprite");
	--this.ownerShade_Anima=this.ownerPanelShade:GetComponent("Animator");
	this.ownerShade_Lid=this.ownerPanelShade.transform:Find("ShadeLid").gameObject;
	this.ownerShade_ShadeLid_Rotation=this.ownerShade_Lid.transform.localRotation;
	-- this.ownerPanel_OkBtn=this.HouseOwnerPanel.transform:Find("HouseDI/OkBtn").gameObject;
	this.ownerPanel_OkBtn=this.HouseChessList:Find("OkBtn").gameObject;
	

	--红，黑，顶割，下割
	this.blackBtn=transform:Find("bottomCenter/blackChess/BlackBtn").gameObject;
	this.blackLabel=transform:Find("bottomCenter/blackChess/Label"):GetComponent("UILabel");
	this.RedBtn=transform:Find("bottomCenter/redChess/RedBtn").gameObject;
	this.redLabel=transform:Find("bottomCenter/redChess/Label"):GetComponent("UILabel");
	this.DingGe=transform:Find("bottomCenter/DingGe/DingGe").gameObject;
	this.DingGeLabel=transform:Find("bottomCenter/DingGe/Label"):GetComponent("UILabel");
	this.XiaGe=transform:Find("bottomCenter/XiaGe/XiaGe").gameObject;
	this.XiaGeLabel=transform:Find("bottomCenter/XiaGe/Label"):GetComponent("UILabel");

	--Tip
	this.Tips = transform:Find("Tips").gameObject;
	this.fristenter = transform:Find("Tips/fristenter").gameObject;

	

	--showUI
	this.showUI = transform:Find("showUI").gameObject;
	this.uibox = transform:Find("showUI/uibox").gameObject;

	this.balanceEnter = transform:Find("showUI/balanceEnter").gameObject;
	this.balanceList = transform:Find("showUI/balanceEnter/balanceList").gameObject;
	this.balanceList_UIScrollView = this.balanceList:GetComponent('UIScrollView');
	this.balanceCollider = transform:Find("showUI/balanceEnter/balanceList/balanceCollider").gameObject;
	this.balanceCollider_UISprite = this.balanceCollider:GetComponent('UISprite');

	-- --倒帮动画
	-- this.loseRob=transform:Find("loseRob").gameObject;
	-- this.loseRob_Anima=this.loseRob.transform:GetComponent("Animator");
	-- this.dao=this.loseRob.transform:Find("dao");
	-- this.ban=this.loseRob.transform:Find("ban");
	-- this.loseRob_close=this.loseRob.transform:Find("close").gameObject;

	
end

function ShierzhiRoomPanel.updatePlayerInfo()
	if this.ui~=nil then 
		if this.ui._curState ~= const.TWELVE_STATUS_OPEN then 
			this.ui.updatePlayerInfo()
		end 
	end 
end 

function ShierzhiRoomPanel.getTime()
	return global.ts_now;
end
--获取数据
function ShierzhiRoomPanel.getPlayerData()
	mgr_12zhi:req_data(function (data)
		global._view:hideLoading();
		if (this.ui ~= nil) then
			if (data ~= nil) then
				this.ui.Init(data,const,0)
			else
				this.getPlayerData()
			end
		end
	end)
end
--获取庄家开牌记录
function ShierzhiRoomPanel.GetHOuseHistory(cb)
	local list=nil;
	global._view:showLoading();
	mgr_12zhi:req_data(function (data)
		global._view:hideLoading();

		list=data.history;
		if (cb~=nil)then
			cb(data);
		end
	end )
end

--获取庄家数据
function ShierzhiRoomPanel.getRobInfo()
	global._view:showLoading();
	mgr_12zhi:req_rob_banker_info(function (data,ec)--banker
		global._view:hideLoading();
		if (#data > 0 and this.ui ~= nil) then
			this.ui.robCallBack(data[1])
		else
			this.setTip(errcode_util:get_errcode_CN(ec))
		end
	end);
end
--抢庄
function ShierzhiRoomPanel.robData(coin)

	global._view:showLoading();
	mgr_12zhi:req_rob_banker(coin, function (data)
		global._view:hideLoading();
		if (data.errcode == 0) then
			if (this.ui ~= nil) then
				this.ui.closeShowUI()
				-- local d={coin = 0,
				-- player_name = this.getPlayerName(),
				-- amount_money = 0,
				-- --content = "抢庄：闲家最高下注" .. coin .. " 梭哈最高下注" .. coin * 10,
				-- content = "抢庄：闲家最高下注" .. coin,
				-- url = this.getPlayerImg(),
				-- viedo = false,
				-- viedoTime = 0,
				-- }
				-- this.ui.addPlayerBetInfo(d,1)
			end
			-- this.setTip("抢庄成功")
		else
			this.setTip(errcode_util:get_errcode_CN(data.errcode))
		end
	end);
end

function ShierzhiRoomPanel.getPlayerImg()
	return global.player:get_headimgurl()
end
function ShierzhiRoomPanel.setRoomBtnState(data)
	if(this.ui ~= nil) then
		this.ui.updateBetState(data,data.liuju)
	end
end
function ShierzhiRoomPanel.UpdateAllBetMessage(info)
	global._view:hideLoading()
	if (this.ui~=nil )then
		
		this.ui.UpdateAllBetMessage(info)
		if info.playerid == this.getPlayerId() then 
			this.ui.BetCallBack()
		end 
	end
end
function ShierzhiRoomPanel.ClearBetMessage(playerid)
	global._view:hideLoading()
	if this.getPlayerId()==playerid then 
		if this.ui~=nil then 
			this.ui.ClearBtnOnClick()
		end 
	end 
end 
	
function ShierzhiRoomPanel.getPlayerName()
	return global.player:get_name()
end

function ShierzhiRoomPanel.getPlayerCoin()
	return global.player:get_money()
end

function ShierzhiRoomPanel.getPlayerRMB()
	return global.player:get_RMB()
end

function ShierzhiRoomPanel.getPlayerId()
	return global.player:get_playerid()
end
function ShierzhiRoomPanel.UpdateResultBet(data)
	if (this.ui ~=nil)then
		this.ui.UpdateResultBet(data);
	end
end
function ShierzhiRoomPanel:GetMoreChessLabel(LabelName)
	if (LabelName=="blackChess")then
		return this.blackLabel;
	elseif (LabelName=="redChess")then
		return this.redLabel;
	elseif (LabelName=="DingGe")then
		return this.DingGeLabel;
	elseif (LabelName=="XiaGe")then
		return this.XiaGeLabel;
	end
end

function ShierzhiRoomPanel.setTip(text)
	global._view:getViewBase("Tip").setTip(text)
end
function ShierzhiRoomPanel.RobBroadcast(data)
	if (this.ui~=nil)then
		this.ui.RobBroadcast(data);
	end
end

function this.UpdatePattern(type,number,SumNuber)
	if (type==1)then
		this.pattern_type_Label.text="自由模式";
		this.pattern_number_Label.text=0;
		this.pattern_sumNumber_Label.text=0;
	elseif(type==2)then
		this.pattern_type_Label.text="抢庄模式";
		this.pattern_number_Label.text=number;
		this.pattern_sumNumber_Label.text=SumNuber;
	end
end
function this.LoseRobOnclick(cb)
	mgr_12zhi:req_drop_banker(function()
		cb();
	end)
end
--data={history= {},bout=1,data.banker_name="",banker_playerid=0,headimgurl=""}
function this.LoseRobCallBack(data)	  
	if this.ui~=nil then 
		this.ui.LoseRobCallBack(data)
	end 
end 

--获取玩家列表
function ShierzhiRoomPanel.getPlayerList()
	global._view:showLoading();
	mgr_12zhi:req_room_members(1,200,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					local list = this.memberSort(data.members)
					this.ui.renderPlayer(list)
				else
					this.setTip(errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)
end
--玩家列表排序
function ShierzhiRoomPanel.memberSort(list)
	table.sort(list,function (a,b)
        return a.RMB + a.money > b.RMB + b.money
    end)
    return list
end
function ShierzhiRoomPanel.backShierzhi(value)
	this.IsClickBack = value
	if (value) then
		mgr_room:exit(const.GAME_ID_12ZHI, function ()
		end)
		this.gameScore()
	else
		 global._view:niuniu().Awake(const.GAME_ID_12ZHI);
		--暂时
		--global._view:gamelobby().Awake()
	end
end
function ShierzhiRoomPanel.ReqRecord()
	global._view:showLoading();
	mgr_12zhi:req_get_record(function(data)
		global._view:hideLoading();
		if (this.ui ~= nil) then
			this.ui.HistoryCallBack(data)
		end
	end)
end

function ShierzhiRoomPanel.gameScore()
	global._view:showLoading();
	mgr_room:req_get_hall_list(const.GAME_ID_12ZHI, function (list)
		global._view:hideLoading();
		if (this.ui ~= nil) then
			global._view:gameScore().Awake(list,const.GAME_ID_12ZHI)
		end
	end)
end
--发送赌注信息到服务端
function ShierzhiRoomPanel.SendBetListToNet(bet_List,cb)
	mgr_12zhi:req_bet(bet_List,function(ec)
		if (this.ui~=nil)then
			this.ui.updatePlayerInfo();
		end
		if cb then 
			cb()
		end 
	end)
end
--发送庄家选择棋子到服务端
function ShierzhiRoomPanel.SendSelectChessToNet(id,cb)
	global._view:showLoading();
	mgr_12zhi:req_select_card(id,function()
		global._view:hideLoading()
		if cb then 
			cb()
		end 
	end)
end

function ShierzhiRoomPanel.PlayBGSound(gameid)
	global._view:PlayBGSound(gameid)
end 

function ShierzhiRoomPanel.OnDestroy()
	global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
	if(this.IsClickBack == false) then
		mgr_room:exit(const.GAME_ID_12ZHI,function ()
		end)
	end
	mgr_room:nw_unreg()
	mgr_12zhi:nw_unreg();
end
return ShierzhiRoomPanel