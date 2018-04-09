require "logic/ViewManager"
local global = require("global")
local i18n = global.i18n
ShierzhiRoomCtrl ={};
local this=ShierzhiRoomCtrl;

local SHADE_STATUS_PLAY = 1
local SHADE_STATUS_NEXT = 2
local SHADE_STATUS_FALL = 3

local SHADE_TIME_PLAY = 0.8
local SHADE_TIME_NEXT = 0.6
local SHADE_TIME_FALL = 0.5

this.shade_timer = 0
this.shade_status = nil  --房主盖子动画状态阶段

this.up_history_list=nil --更新历史记录上移

this.last_state = nil

ShierzhiRoomCtrl.panel = nil;
ShierzhiRoomCtrl.Room= nil;
ShierzhiRoomCtrl.transform = nil;
ShierzhiRoomCtrl.gameObject = nil;
ShierzhiRoomCtrl._const = nil--常量
ShierzhiRoomCtrl._curState = 0--游戏步骤

ShierzhiRoomCtrl._RoomCreate = ""
ShierzhiRoomCtrl.IsGameRoom = false;--是否是房间列表进的房间（福州房，厦门房····）
ShierzhiRoomCtrl.RoomTitle = ""
ShierzhiRoomCtrl._IsOpenGame = false--是否开局
ShierzhiRoomCtrl._IsRoom = false--是否是房主（庄家）
ShierzhiRoomCtrl._IsLiuju = 0--是否刘局，0不流局，1流局
ShierzhiRoomCtrl._robData = nil--庄家信息
ShierzhiRoomCtrl._bigshow = nil--大字体提示（图片）
ShierzhiRoomCtrl.RoomId = 0--房间ID
ShierzhiRoomCtrl._uiPreant = nil

this._isdaoban=nil

--下注
ShierzhiRoomCtrl._totalBetCoin = 0--当局总下注金额
ShierzhiRoomCtrl._allBetCoin = 0--这一局下注金额
ShierzhiRoomCtrl._playerCoin = 0--玩家金币
ShierzhiRoomCtrl._PlayermaxCoin = 0--玩家最大下注金额
ShierzhiRoomCtrl._robBet = 1--抢庄金额

--时间事件
ShierzhiRoomCtrl._FreeTime = 0;

ShierzhiRoomCtrl.panelShadeState=1;--0是关闭，1是打开；
ShierzhiRoomCtrl.houseChessFormerPos=nil ;--庄家棋子原本位置
ShierzhiRoomCtrl.result_card=nil ;--庄家开牌的棋子；
ShierzhiRoomCtrl.isPlayHouseAmina=false;--棋子动画是否在播放，在播放不能关闭庄家面板
ShierzhiRoomCtrl.shadeLidIsPress=false;--遮盖是否按下
this.startPos=nil
ShierzhiRoomCtrl.boxid=1;--更新开牌历史记录计数器
-- ShierzhiRoomCtrl.isUpdateBox=false;--更新开牌记录的标志位
ShierzhiRoomCtrl.historyID=0;
--ShierzhiRoomCtrl.moveSpeed=0;
--ShierzhiRoomCtrl.lidValue=0;
--结果显示
ShierzhiRoomCtrl._startScore = 0;
ShierzhiRoomCtrl._maxScore = 0;
ShierzhiRoomCtrl._startAnima = false;
ShierzhiRoomCtrl._haveBalance = false;
ShierzhiRoomCtrl._userBetVec = nil
ShierzhiRoomCtrl._curBetPoint = 0
ShierzhiRoomCtrl._curBetType = 0
ShierzhiRoomCtrl._playScore = 0
ShierzhiRoomCtrl._finalVec = {}
ShierzhiRoomCtrl._balanceList = {}
ShierzhiRoomCtrl.Speed = 0
ShierzhiRoomCtrl._scoreLen = 0
--一天两开
ShierzhiRoomCtrl._isOpenTwo=false;


--玩法模式
ShierzhiRoomCtrl.play_type=nil;

--下庄
ShierzhiRoomCtrl.loseRob=false;
-- ShierzhiRoomCtrl.ShadeIsFalling=false;--遮罩是否在下落
local chesssTable={}--存储所有的棋子
local selectChess={};--存储押注的棋子
-- local NetBetChess={};--存储整个房间内被下过注的棋子
local isSelect=false;--是否选择棋子的标志
local currentSelect={};--当前选择的棋子
local currentSelectChessPosID=nil;--下注动画
local currentSelectChessPosObj=nil;
local isMoreChessSelect=false;--是否点击顶割，下割，红，黑标志
local signBetSelect=nil;--记录点击顶割，下割，红，黑
--local isHouseChessSelect=false;--记录房主是否已选择棋子的标志
local houseChessList={};--所有庄家的棋子
local currentHouseChess=nil;--记录庄家选择的棋子
local houseChessSelectToNet=nil --记录庄家确定的棋子，发送到服务端

local houseChessBoxList={};--记录庄家选择的棋子的容器显示
local betChessDataListToNet={}--记录单次的金额和选择的棋子集合和服务端交互
local betChessDataAmina={}--下注动画记录
local BetAminaPrefab={}--下注动画Prefab
--ShierzhiRoomCtrl.test=false;
--所有棋子的属性
--[[黑：将、士、象、车、马、炮：1、2、3、4、5、6
红：帅、士、象、车、马、炮：7、8、9、10、11、12
顶割=4,5,6
下割=1,2,3
--]]
local QiPai = {
	Chess1={icon="hongche",number=10,color="red",},
	Chess2={icon="heiche",number=4,color="black",},
	Chess3={icon="hongshuai",number=7,color="red",},
	Chess4={icon="hongshi",number=8,color="red",},
	Chess5={icon="hongxiang",number=9,color="red",},
	Chess6={icon="hongche",number=10,color="red",},
	Chess7={icon="heiche",number=4,color="black",},
	Chess8={icon="hongma",number=11,color="red",},
	Chess9={icon="heima",number=5,color="black",},
	Chess10={icon="heijiang",number=1,color="black",},
	Chess11={icon="heishi",number=2,color="black",},
	Chess12={icon="heixiang",number=3,color="black",},
	Chess13={icon="hongma",number=11,color="red",},
	Chess14={icon="heima",number=5,color="black",},
	Chess15={icon="hongpao",number=12,color="red",},
	Chess16={icon="heipao",number=6,color="black",},
	Chess17={icon="hongpao",number=12,color="red",},
	Chess18={icon="heipao",number=6,color="black",},

}
--四个棋子的选择
local fourChess={
Chess70={'Chess1','Chess2','Chess8','Chess9'},
Chess71={'Chess2','Chess3','Chess9','Chess10'},
Chess72={'Chess3','Chess4','Chess10','Chess11'},
Chess73={'Chess4','Chess5','Chess11','Chess12'},
Chess74={'Chess5','Chess6','Chess12','Chess13'},
Chess75={'Chess6','Chess7','Chess13','Chess14'},
Chess76={'Chess8','Chess9','Chess15','Chess16'},
Chess77={'Chess13','Chess14','Chess17','Chess18'}
}
--竖直棋子的选择
local VChess={
	Chess20={'Chess1','Chess2'},Chess21={'Chess2','Chess3'},
	Chess22={'Chess3','Chess4'},Chess23={'Chess4','Chess5'},
	Chess24={'Chess5','Chess6'},Chess25={'Chess6','Chess7'},
	Chess26={'Chess8','Chess9'},Chess27={'Chess9','Chess10'},
	Chess28={'Chess10','Chess11'},Chess29={'Chess11','Chess12'},
	Chess30={'Chess12','Chess13'},Chess31={'Chess13','Chess14'},
	Chess32={'Chess15','Chess16'},Chess33={'Chess17','Chess18'},
}
--横向棋子的选择
local WChess={
	Chess40={'Chess1','Chess8'},Chess41={'Chess2','Chess9'},
	Chess42={'Chess3','Chess10'},Chess43={'Chess4','Chess11'},
	Chess44={'Chess5','Chess12'},Chess45={'Chess6','Chess13'},
	Chess46={'Chess7','Chess14'},Chess47={'Chess8','Chess15'},
	Chess48={'Chess9','Chess16'},Chess49={'Chess13','Chess17'},
	Chess50={'Chess14','Chess18'},
}
--顶割，下割，红，黑的棋子选择
local MoreChessList={
BlackBtn={'Chess2','Chess7','Chess9','Chess10','Chess11','Chess12','Chess14','Chess16','Chess18',},
RedBtn={'Chess1','Chess3','Chess4','Chess5','Chess6','Chess8','Chess13','Chess15','Chess17',},
DingGe={'Chess3','Chess4','Chess5','Chess10','Chess11','Chess12',},
XiaGe={'Chess1','Chess2','Chess6','Chess7','Chess8','Chess9','Chess13','Chess14','Chess15','Chess16','Chess17','Chess18',}
}

--庄家棋子的属性
local houseChess={
	{icon="heijiang",number=1,color="black"},
	{icon="heishi",number=2,color="black"},
	{icon="heixiang",number=3,color="black"},
	{icon="heiche",number=4,color="black"},
	{icon="heima",number=5,color="black"},
	{icon="heipao",number=6,color="black"},
	{icon="hongshuai",number=7,color="red"},
	{icon="hongshi",number=8,color="red"},
	{icon="hongxiang",number=9,color="red"},
	{icon="hongche",number=10,color="red"},
	{icon="hongma",number=11,color="red"},
	{icon="hongpao",number=12,color="red"},
}
--押注的金额记录
local betChessList={
	redChess=0,blackChess=0,
	DingGe=0,XiaGe=0,
	Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
	Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
}
--全局押注的金额记录
local allBetChessList={
	redChess=0,blackChess=0,
	DingGe=0,XiaGe=0,
	Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
	Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
}
--记录单次押注的棋子和金额
local nowBetChessList={
	redChess=0,blackChess=0,
	DingGe=0,XiaGe=0,
	Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
	Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
}
local chessName={
	redChess="红字",blackChess="黑字",
	DingGe="顶割",XiaGe="下割",
	Chess1="将",Chess2="士",Chess3="象",Chess4="車",Chess5="馬",Chess6="包",
	Chess7="帥",Chess8="仕",Chess9="相",Chess10="俥",Chess11="傌",Chess12="佨",

}
local function Get_len(list)
	local count = 0
	if list then
		for k,v in pairs(list)do
			count = count + 1
		end
	end
	return count
end
--构建函数--
function ShierzhiRoomCtrl.New()
	return this;
end

function ShierzhiRoomCtrl.Awake(roomid,value,title)
	this.RoomId = roomid;
	this.IsGameRoom = value
	this.RoomTitle = title
	-- if(this.RoomTitle=="一日两开")then
	-- 	this._isOpenTwo=true
	-- else 
	-- 	this._isOpenTwo=false
	-- end
	panelMgr:CreatePanel('ShierzhiRoom', this.OnCreate);
end
function ShierzhiRoomCtrl.Init(data,const,liuju)
	global._view:showLoading();
	if(#currentSelect>0)then
		this.ResetLastSelectChess();
	end;
	this.play_type=data.play_type;
	this._const = const

	if this.RoomTitle == this._const.ROOMID_12ZHI_DATING2 then 
		this.RoomTitle = "一日两开"
		this._isOpenTwo=true
		ShierzhiRoomPanel.invite:SetActive(false)
		ShierzhiRoomPanel.history:SetActive(true)
	else 
		this._isOpenTwo=false
		ShierzhiRoomPanel.invite:SetActive(true)
		ShierzhiRoomPanel.history:SetActive(false)		
	end 

	this._RoomCreate = data.house_owner_name
	this._PlayermaxCoin=data.player_max_coin;
	--更新标题显示
	if (this.IsGameRoom == false and this._isOpenTwo==false) then
		if (this._RoomCreate~=nil)then
			ShierzhiRoomPanel.roomId_UILabel.text = "房主:" .. GameData.GetShortName(this._RoomCreate,10,10) .. "\n房间号:" .. this.RoomId
		else
			ShierzhiRoomPanel.roomId_UILabel.text ="\n房间号:" .. this.RoomId
		end
		ShierzhiRoomPanel.robHead_openTwo:SetActive(false)
		ShierzhiRoomPanel.roomId_UILabel.fontSize = 25
	else
		if this._isOpenTwo then
			ShierzhiRoomPanel.roomId_UILabel.text =this.RoomTitle
			local time = ShierzhiRoomPanel.getTime() --todo 获取当前时间
			local hours = GameData.getTimeTableForNum(time).hour
			local text_1 = "开奖时间为:14:00和21:30"
			if data.player_max_coin then
				ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:康熙\n单字最高下注:".. this._PlayermaxCoin
			else
				ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:康熙\n单字最高下注:500000"
			end

			ShierzhiRoomPanel.roomId_UILabel.text =this.RoomTitle.."\n"..text_1
			ShierzhiRoomPanel.roomId_UILabel.fontSize = 22

			ShierzhiRoomPanel.robHead:SetActive(false)
			ShierzhiRoomPanel.robHead_openTwo:SetActive(true)

		else
			ShierzhiRoomPanel.roomId_UILabel.text ="\n"..this.RoomTitle
			-- ShierzhiRoomPanel.robHead:SetActive(true)
			ShierzhiRoomPanel.robHead_openTwo:SetActive(false)
			ShierzhiRoomPanel.roomId_UILabel.fontSize = 25
		end
	end
	ShierzhiRoomPanel.PlayerIcon_AsyncImageDownload:SetAsyncImage(ShierzhiRoomPanel.getPlayerImg())
	if (data.banker_name~=nil and this._PlayermaxCoin~=nil and this._isOpenTwo == false)then
		local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n当局最高下注:" .. this._PlayermaxCoin
		ShierzhiRoomPanel.bankerName_UILabel.text = bstr

	else
		if this._isOpenTwo == false then
			ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:无\n当局最高下注:0"
		end
	end
	this.UpdateTypeAndBout(data);

	--更新开牌记录
	if (data.history~=nil)then
		this.historyID=#data.history;
		if (#data.history>0)then
			for i=1,#data.history do
				this.UpdateHouseChessBox(data.history[i]);
			end
		end
	end

	--更新全局下注金额
	if(data.pos_amount_bet~=nil and this._isOpenTwo == false )then
		this.UpdateAllBetByNet(data.pos_amount_bet)
	end
	--游戏是否已开始
	if (data.game_status~=this._const.TWELVE_STATUS_FREE)then
		this._IsOpenGame=true
	end

	-- if data.headimgurl then
	-- 	ShierzhiRoomPanel.rob:SetActive(false)
	-- 	ShierzhiRoomPanel.robHead:SetActive(true)
	-- 	ShierzhiRoomPanel.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
	-- end
	ShierzhiRoomPanel.rob:SetActive(true)
	ShierzhiRoomPanel.robHead:SetActive(false)

	this.updatePlayerInfo();

	this.updateBetState(data,liuju)
	global._view:hideLoading();
end
--更新玩法流程
function ShierzhiRoomCtrl.updateBetState(data,liuju)
	if (this._const == nil) then
		return
	end
	--清空筹码预制体
	this.ClearBetPrefab();

	--初始化界面信息
	this._FreeTime =data.over_time
	this._IsRoom = false--是否是房主
	this._curState =data.game_status--修改步骤将执行不同步骤
	local bet = ""--时钟下的提示信息
	ShierzhiRoomPanel.tiprob:SetActive(false)--箭头提示
	-------- RoomPanel.tipbet:SetActive(false)
	ShierzhiRoomPanel.rob_UISprite.color = Color.gray
	ShierzhiRoomPanel.robBg_UISprite.color = Color.gray
	-- ShierzhiRoomPanel.selectChessBtn_UISprite.color=Color.gray;
	ShierzhiRoomPanel.loseRob_Btn_Sprite.color=Color.gray;
	ShierzhiRoomPanel.loseRob_Btn:SetActive(false)
	ShierzhiRoomPanel.robEffect:SetActive(false)
	this.BetBtnColor(Color.gray)
	this.clearBigShow()
	this._IsLiuju = 0
	this._robData = nil
	if data.headimgurl  then
		ShierzhiRoomPanel.rob:SetActive(false)
		if this._isOpenTwo == false then
			ShierzhiRoomPanel.robHead:SetActive(true)
		end
		ShierzhiRoomPanel.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
	-- else
	-- 	ShierzhiRoomPanel.rob:SetActive(true)
	-- 	ShierzhiRoomPanel.robHead:SetActive(false)
	end
	if (data.player_max_coin~=nil)then
		this._PlayermaxCoin =data.player_max_coin
	end

	if(this._curState == this._const.TWELVE_STATUS_FREE) then --空闲时间

		if(data.banker_name == ShierzhiRoomPanel.getPlayerName()) then --自己是不是庄家
			this._IsRoom = true
			if (this.loseRob==false)then
				ShierzhiRoomPanel.loseRob_Btn_Sprite.color=Color.white;
				ShierzhiRoomPanel.loseRob_Btn:SetActive(true)
			end
		end
		this.ShowWonerPanel()
		this.HouseOwnerPanelAndReset();
		this._isdaoban = data.daobang;
		if (data.daobang)then
			ShierzhiRoomPanel.rob:SetActive(true)
			ShierzhiRoomPanel.robHead:SetActive(false)
			this.ShowBigTime();
		end

		if this.last_state == this._const.TWELVE_STATUS_OPEN then
			ShierzhiRoomPanel.GetHOuseHistory(function(historydata)
				--更新开牌记录
				if (historydata.history~=nil)then
					if this.historyID == 20 then --最多20个记录，会顶替，保证取最后一位更新
						this.historyID = 19
					end
					if (#historydata.history>this.historyID)then
						this.historyID=this.historyID+1
						this.UpdateHouseChessBox(historydata.history[this.historyID]);
					end

				end
			end)
		end
		this.last_state = this._const.TWELVE_STATUS_FREE


		--this._PlayermaxCoin = 0
		this._IsOpenGame=false;
		this.isPlayHouseAmina=false;--避免顿卡，无法关闭面板

		--显示结果
		this.showAllPlayerPoint();
		this.ResetShade();
		this.ClearBetMessage();
		this.ClearBetMoneyMessage();--清空显示金额(下注前清空)
		this.ClearRobChessMessage();--清除庄家棋子的信息
		this.updatePlayerInfo();

		if (this._uiPreant ~= nil) then
			if (this._uiPreant.name == "ShierzhiRobbar") then
				this.closeShowUI()
			end
		end
		this._IsLiuju =liuju
		if (this._IsLiuju == 1) then
			soundMgr:PlaySound("liuju")
			this:ShowBigTime()
		end
		if (data.banker_name~=nil and data.banker_name~=""  and this._PlayermaxCoin~=nil)then
			local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n单字最高下注:" .. this._PlayermaxCoin
			ShierzhiRoomPanel.bankerName_UILabel.text = bstr
		else
			ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:待定\n单字最高下注:0"
		end
		this.UpdateTypeAndBout(data);
		bet = "空闲"

	elseif(this._curState == this._const.TWELVE_STATUS_BANKER) then --抢庄时间

		--清空开牌记录
		this.ClearHouseChessBox();
		ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:待定\n单字最高下注:0"
		bet = "请抢庄"
		this.loseRob=false;
		this._IsOpenGame=false;
		-- this.LoseRobClose();
		this.ShowWonerPanel()

		soundMgr:PlaySound("prob")
		this.ShowBigTime()
		ShierzhiRoomPanel.tiprob:SetActive(true)
		ShierzhiRoomPanel.rob_UISprite.color = Color.white
		ShierzhiRoomPanel.robBg_UISprite.color = Color.white
		ShierzhiRoomPanel.robEffect:SetActive(true)

		ShierzhiRoomPanel.rob:SetActive(true)
		ShierzhiRoomPanel.robHead:SetActive(false)

	elseif(this._curState == this._const.TWELVE_STATUS_SELECT) then --选牌时间
		if(data.banker_name == ShierzhiRoomPanel.getPlayerName()) then --自己是不是庄家
			this._IsRoom = true
			soundMgr:PlaySound("merob")--提示音，你做庄
			this:ShowBigTime()--后期加一个选牌提示
			ShierzhiRoomPanel.loseRob_Btn:SetActive(true)
		end
		--清空押注的信息，然后专家开始选棋子
		bet="选牌"
		this._IsOpenGame=false;
		this.isPlayHouseAmina=false;
		this.HouseOwnerPanelAndReset();
		-- this.isUpdateBox=false;
		this.ShowWonerPanel()
		if (this._uiPreant ~= nil) then
			if (this._uiPreant.name == "ShierzhiRobbar" or this._uiPreant.name=="balanceInfobar") then
				this.closeShowUI()
			end
		end
		--this.updatePlayerInfo()
		if (data.banker_name~=nil and this._PlayermaxCoin~=nil)then
			local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n单字最高下注:" .. this._PlayermaxCoin
			ShierzhiRoomPanel.bankerName_UILabel.text = bstr
		else
			ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:无\n单字最高下注:0"
		end


	elseif(this._curState == this._const.TWELVE_STATUS_BET) then --下注时间
		if(data.banker_name == ShierzhiRoomPanel.getPlayerName()) then --自己是不是庄家
			this._IsRoom = true
			ShierzhiRoomPanel.loseRob_Btn:SetActive(true)
		else
			this._IsOpenGame=false;
		end
		this.ShowWonerPanel()
		bet = "请下注"
		if (this._uiPreant ~= nil) then
			if (this._uiPreant.name == "ShierzhiRobbar" or this._uiPreant.name=="balanceInfobar") then
				this.closeShowUI()
			end
		end
		if(this._IsRoom==false)then
			--this.closeShowUI()
			soundMgr:PlaySound("pbet")
			this.ShowBigTime()
			this.BetBtnColor(Color.white)
		end
		ShierzhiRoomPanel.rob:SetActive(false)
		if this._isOpenTwo == false then
			ShierzhiRoomPanel.robHead:SetActive(true)
		end
		--一天两开todo
		if (this._isOpenTwo)then
			--获取自己的下注情况并显示
			--this._PlayermaxCoin = 0
			this.isPlayHouseAmina=false;--避免顿卡，无法关闭面板
			this.HouseOwnerPanelAndReset();
			this.showAllPlayerPoint();
			this.ResetShade();
			this.ClearBetMessage();
			this.ClearBetMoneyMessage();--清空显示金额(下注前清空)
			this.ClearRobChessMessage();--清除庄家棋子的信息
			this.updatePlayerInfo()
			this.UpdateTypeAndBout(data)--更新期数
			if data.pos_amount_bet then
				this.UpdateAllBetByNet(data.pos_amount_bet)
			end

			-- if(this._PlayermaxCoin~=nil)then
			-- 	if (data.banker_name~=nil)then
			-- 		-- local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n单字最高下注:" .. this._PlayermaxCoin
			-- 		local bstr = "庄家:康熙" .. "\n单字最高下注:" .. this._PlayermaxCoin
			-- 		ShierzhiRoomPanel.bankerName_UILabel.text = bstr

			-- 	else
			-- 		ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:康熙\n单字最高下注:".. this._PlayermaxCoin
			-- 	end
			-- else
			-- 	ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:康熙\n单字最高下注:0"
			-- end
		end

		--系统给的庄家棋子  庄家的
		if (houseChessSelectToNet==nil)then
			if (this._IsRoom)then
				if (data.result_card~=nil)then
					local ChName="HouseChess"..data.result_card;
					for k,v in pairs(houseChessList)do
						if (v.name==ChName)then
							this.result_card=v;
							this.PlayHouseChessAnima(v);

							break;
						end
					end
				end
			else
				ShierzhiRoomPanel.Shade:SetActive(true)
				this.PlayShadeFallAnima();
			end
		end
		--暂时先用
		if(this._IsOpenGame and this._IsRoom)then
			ShierzhiRoomPanel.Shade:SetActive(true)
			this.PlayShadeFallAnima();
		end

	elseif(this._curState == this._const.TWELVE_STATUS_OPEN) then --开牌时间
		if(data.banker_name == ShierzhiRoomPanel.getPlayerName()) then --自己是不是庄家
			this._IsRoom = true
			-- if (this.loseRob==false)then
			-- 	ShierzhiRoomPanel.loseRob_Btn_Sprite.color=Color.white;
			-- end
			ShierzhiRoomPanel.loseRob_Btn:SetActive(true)
		end
		this.ShowWonerPanel()
		this.last_state = this._const.TWELVE_STATUS_OPEN
		if (global._view:getViewBase("Rule") ~= nil) then
			global._view:getViewBase("Rule").OnDestroy()
		end
		if (global._view:getViewBase("Bank") ~= nil) then
			global._view:getViewBase("Bank").OnDestroy()
		end
		if this._isOpenTwo == false then
			ShierzhiRoomPanel.robHead:SetActive(true)
		end
		if(global._view:getViewBase("PlayerList")~=nil)then
			global._view:getViewBase("PlayerList").clearView();
		end
		ShierzhiRoomPanel.rob:SetActive(false)
		bet = "开牌"

		if (this._IsOpenGame and this._IsRoom==false and data.result_card~=nil)then
			ShierzhiRoomPanel.Shade:SetActive(true)
			this.PlayShadeFallAnima();
		end
		if (this._IsOpenGame and this.result_card==nil and this._IsRoom and data.result_card~=nil)then
			ShierzhiRoomPanel.Shade:SetActive(true)
			this.PlayShadeFallAnima();
		end
		this.isPlayHouseAmina=false;--避免顿卡，无法关闭面板
		this.HouseOwnerPanelAndReset();
		if (data.result_card~=nil)then
			local ChName="HouseChess"..data.result_card;
			--播放遮罩上升动画
			for k,v in pairs(houseChessList)do
				if (v.name==ChName)then
					this.result_card=v;
					this.SetShadeChess(v);
					break;
				end
			end
		else
		end
		this.UpdateResultBet(data.bet_users);

		this.PlayShadeUPAnima();
		this.ShowBigTime();
		--this.updatePlayerInfo();--可以放在玩家自己开牌后更新
	end
	ShierzhiRoomPanel.BetState_UILabel.text = bet
end
--
this._bankerId = nil 
function ShierzhiRoomCtrl.UpdateResultBet(data)
	this._userBetVec = {}
	local len = #data
	local self_i = nil -----
	if(len > 0) then
		local bankerInfo = data[1]
		this._bankerId = bankerInfo.playerid
		ShierzhiRoomPanel.bankerName_UILabel.text = "庄家:" .. GameData.GetShortName(bankerInfo.player_name,14,14) .. "\n单字最高下注:" .. this._PlayermaxCoin
		----------
		--庄家信息
		local vec = {}
		vec.betusers = bankerInfo
		vec.playerId = bankerInfo.playerid
		table.insert(this._userBetVec,vec)
		--不是庄家 并且1人以上
		local self_name = ShierzhiRoomPanel.getPlayerName()
		if len > 1 and bankerInfo.player_name ~= self_name then 
			for k,v in pairs(data) do 
				if v.player_name == self_name then 
					self_i = k 
					local vec = {
						betusers = v,
						playerId = v.playerid
					}
					table.insert(this._userBetVec,vec)
				end 
			end 
		end 
		----------
	end
	for i=2,len do
		------
		if i ~= self_i then 
			local bankerInfo = data[i]
			-- local name = bankerInfo.player_name
			local vec = {
				betusers = bankerInfo,
				--Isopen = 0,
				playerId = bankerInfo.playerid,
			}
			table.insert(this._userBetVec,vec)
		end 
		--------
	end
end
function ShierzhiRoomCtrl.ShowBigTime()
	--bigshow Prefab todo
	local bundle = resMgr:LoadBundle("bigshow");
	local Prefab = resMgr:LoadBundleAsset(bundle,"bigshow");
	this._bigshow = GameObject.Instantiate(Prefab);
	this._bigshow.name = "bigshowbar";
	this._bigshow.transform.parent = ShierzhiRoomPanel.Tips.transform;
	this._bigshow.transform.localScale = Vector3.one;
	this._bigshow.transform.localPosition = Vector3(0,32,0);---135
	resMgr:addAltas(this._bigshow.transform,"Room")
	local showtip = this._bigshow.transform:Find("showtip");
	local liuju = showtip:Find('liuju').gameObject;
	local popen = showtip:Find('popen').gameObject;
	local pbet = showtip:Find('pbet').gameObject;
	local prob = showtip:Find('prob').gameObject;
	local pselect=showtip:Find("pselect").gameObject;
	local loseRob=this._bigshow.transform:Find("loserob").gameObject;
	popen:SetActive(false)
	pbet:SetActive(false)
	prob:SetActive(false)
	pselect:SetActive(false)

	if (this._isdaoban) then
		loseRob:SetActive(true)
		showtip.gameObject:SetActive(false)
		this._isdaoban=false
	end
	if (this._IsLiuju == 1) then
		liuju:SetActive(true)
		return
	end


	if (this._curState == this._const.TWELVE_STATUS_BANKER) then
		prob:SetActive(true)
	elseif(this._curState == this._const.TWELVE_STATUS_SELECT) then
		pselect:SetActive(true)
	elseif (this._curState == this._const.TWELVE_STATUS_BET) then
		pbet:SetActive(true)
	elseif (this._curState == this._const.TWELVE_STATUS_OPEN) then
		-- this._bigshow.transform.localPosition = Vector3(0,100,0);
		popen:SetActive(true)
	end
end
function ShierzhiRoomCtrl.clearBigShow()
	if (this._bigshow ~= nil) then
		panelMgr:ClearPrefab(this._bigshow);
	end
	this._bigshow = nil
end
function ShierzhiRoomCtrl.updatePlayerInfo()
	this._playerCoin = ShierzhiRoomPanel.getPlayerCoin() + ShierzhiRoomPanel.getPlayerRMB()
	ShierzhiRoomPanel.playerCoin_UILabel.text = ShierzhiRoomPanel.getPlayerRMB()
	ShierzhiRoomPanel.playerSilver_UILabel.text = ShierzhiRoomPanel.getPlayerCoin()
	ShierzhiRoomPanel.playerName_UILabel.text = GameData.GetShortName(ShierzhiRoomPanel.getPlayerName(),14,12) .. "\nID:" .. ShierzhiRoomPanel.getPlayerId()
end

function ShierzhiRoomCtrl.closeShowUI()
	if (this._uiPreant ~= nil) then
		panelMgr:ClearPrefab(this._uiPreant);
		this._uiPreant = nil;
	end
	this.closeBalanceList()
	ShierzhiRoomPanel.uibox:SetActive(false)
	--ShierzhiRoomPanel.expression:SetActive(false)
	--ShierzhiRoomPanel.saydialog:SetActive(false)
	ShierzhiRoomPanel.balanceEnter:SetActive(false)
	--ShierzhiRoomPanel.balanceEnter:SetActive(false)
	--关闭庄家选棋界面
end
--关闭庄家面板，并还原
function ShierzhiRoomCtrl.HouseOwnerPanelAndReset()

	if (this.isPlayHouseAmina==true)then
		return
	end
	-- ShierzhiRoomPanel.HouseOwnerPanel:SetActive(false)
	ShierzhiRoomPanel.ownerPanelShade:SetActive(false)
	--复位遮罩
	ShierzhiRoomPanel.ownerShade_Lid:GetComponent("TweenPosition").enabled=false;
	ShierzhiRoomPanel.ownerShade_Lid:GetComponent("TweenRotation").enabled=false;
	ShierzhiRoomPanel.ownerShade_Lid.transform.localPosition=Vector3(63,0,0);
	ShierzhiRoomPanel.ownerShade_Lid.transform.localRotation=ShierzhiRoomPanel.ownerShade_ShadeLid_Rotation;
	this.panelShadeState=1;
	--复位棋子
	--todo
	if(this.houseChessFormerPos~=nil  and this.result_card~=nil )then
		this.result_card:GetComponent("TweenPosition").enabled=false;
		this.result_card:GetComponent("TweenScale").enabled=false;
		this.result_card:SetActive(true);
		-- this.result_card.transform.localScale=Vector3.one*0.8;
		this.result_card.transform.localScale=Vector3.one*0.7;
		this.result_card.transform.localPosition=this.houseChessFormerPos;
		local di= this.result_card.transform:Find("DI")
		local sprite =di:Find("Sprite");
		di:GetComponent("UIWidget").depth=45;
		sprite:GetComponent("UIWidget").depth=46;
		-- di:GetComponent("UISprite").color=Color.white;
		di:GetComponent("UISprite").color=Color.gray;
		this.houseChessFormerPos=nil;

		ShierzhiRoomPanel.ownerShade_Chess:SetActive(false);
	end
	if (currentHouseChess~=nil )then
		if houseChessSelectToNet == nil then
			currentHouseChess.transform:Find("DI"):GetComponent("UISprite").color=Color.white;
		else
			currentHouseChess.transform:Find("DI"):GetComponent("UISprite").color=Color.gray;
		end
		currentHouseChess=nil;
	end

end

--更改下注按钮颜色
function ShierzhiRoomCtrl.BetBtnColor(color)
	ShierzhiRoomPanel.betfive_UISprite.color = color
	ShierzhiRoomPanel.betten_UISprite.color = color
	ShierzhiRoomPanel.bethund_UISprite.color = color
	ShierzhiRoomPanel.betkilo_UISprite.color = color
	ShierzhiRoomPanel.bettenshou_UISprite.color = color
	ShierzhiRoomPanel.betmill_UISprite.color = color
	ShierzhiRoomPanel.okBtn_UISprtie.color = color
	ShierzhiRoomPanel.clearBtn_UISprite.color = color

end

--启动事件--
function ShierzhiRoomCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.panel = this.transform:GetComponent('UIPanel');
	this.Room = this.transform:GetComponent('LuaBehaviour');
	--this.Room:AddOnPress(ShierzhiRoomPanel.btnFilling, this.OnFilling);

	global._view:chat().Awake(global.const.GAME_ID_12ZHI);
	this.renderFunc();--布置面板
	this.FourRenderFunc();
	this.VRenderFunc();
	this.WRenderFunc();
	this.HouseChessBoxRenderFunc();

	--布置庄家界面面板
	this.HouseRenderFunc();
	--this.Room:AddClick(ShierzhiRoomPanel.Shade_Di,this.OnShadeClick);改成滑动盖顶，todo
	-- this.Room:AddClick(ShierzhiRoomPanel.HouseClose,this.HouseOwnerPanelClose);
	-- this.Room:AddClick(ShierzhiRoomPanel.selectChessBtn,this.OnselectChessBtnClick);
	this.Room:AddClick(ShierzhiRoomPanel.ownerPanel_OkBtn,this.OwnerPanelOKBtnClick);

	--筹码
	this.Room:AddClick(ShierzhiRoomPanel.betfive, this.OnBetBtn);
	this.Room:AddClick(ShierzhiRoomPanel.betten, this.OnBetBtn);
	this.Room:AddClick(ShierzhiRoomPanel.bethund, this.OnBetBtn);
	this.Room:AddClick(ShierzhiRoomPanel.betkilo, this.OnBetBtn);
	this.Room:AddClick(ShierzhiRoomPanel.bettenshou, this.OnBetBtn);
	this.Room:AddClick(ShierzhiRoomPanel.betmill, this.OnBetBtn);
	--确定按钮
	this.Room:AddClick(ShierzhiRoomPanel.okBtn,this.OkOnclick);
	--取消按钮
	this.Room:AddClick(ShierzhiRoomPanel.clearBtn,this.ClearBtnOnClick);
	--顶割，下割，红，黑
	-- this.Room:AddClick(ShierzhiRoomPanel.blackBtn,this.OnMoreChessClick);
	-- this.Room:AddClick(ShierzhiRoomPanel.RedBtn,this.OnMoreChessClick);
	-- this.Room:AddClick(ShierzhiRoomPanel.DingGe,this.OnMoreChessClick);
	-- this.Room:AddClick(ShierzhiRoomPanel.XiaGe,this.OnMoreChessClick);

	this.Room:AddClick(ShierzhiRoomPanel.back, this.OnBack);
	this.Room:AddClick(ShierzhiRoomPanel.rob, this.OnRob);
	----this.Room:AddClick(ShierzhiRoomPanel.cardback, this.onCloseCard);
	this.Room:AddClick(ShierzhiRoomPanel.playlist, this.OnPlayerList);
	--this.Room:AddClick(ShierzhiRoomPanel.chat, this.OnSay);
	-- this.Room:AddClick(ShierzhiRoomPanel.express, this.OnExpression);
	 this.Room:AddClick(ShierzhiRoomPanel.share, this.OnShare);
	 --this.Room:AddOnPress(ShierzhiRoomPanel.viedo, this.OnViedo);
	 this.Room:AddClick(ShierzhiRoomPanel.invite, this.OnInvite);
	 this.Room:AddClick(ShierzhiRoomPanel.rule, function ()
		global._view:rule().Awake(global.const.GAME_ID_12ZHI)
	 end);
	this.Room:AddClick(ShierzhiRoomPanel.bank, function ()
		global._view:bank().Awake()
	end);
	this.Room:AddClick(ShierzhiRoomPanel.history,this.OnHistory)
	this.Room:AddClick(ShierzhiRoomPanel.closeshare, this.CloseShare);
	-- this.Room:AddOnPress(RoomPanel.playcard, this.playAnima);
    this.Room:AddClick(ShierzhiRoomPanel.uibox, this.closeShowUI);

	if (this.IsGameRoom ) then
		ShierzhiRoomPanel.invite_UISprite.color = Color.gray
		ShierzhiRoomPanel.invitefabu_UISprite.color = Color.gray
		ShierzhiRoomPanel.inviteyaoqing_UISprite.color = Color.gray
	end
	--遮罩
	this.Room:AddOnPress(ShierzhiRoomPanel.Shade_Lid,this.ShadeLidOnPress);

	--倒帮
	-- this.Room:AddClick(ShierzhiRoomPanel.loseRob_close,this.LoseRobClose);
	--下庄
	this.Room:AddClick(ShierzhiRoomPanel.loseRob_Btn,this.LoseRobOnclick);

	UpdateBeat:Add(this.timeEvent, this)
	--隐藏银行
	if global.player:get_paytype() == 1 then
		ShierzhiRoomPanel.bank:SetActive(false)
		ShierzhiRoomPanel.share:SetActive(false)
	end
end

function ShierzhiRoomCtrl.renderFunc()

	local parent = ShierzhiRoomPanel.ChessList;
	local bundle = resMgr:LoadBundle("ChessPieces");
	local Prefab = resMgr:LoadBundleAsset(bundle,"ChessPieces");
	local space = 143;
	for i=1 ,18 do
		local na ="Chess"..i;
		local data= QiPai[na];
		local go = GameObject.Instantiate(Prefab);
		go.name = "Chess"..i;
		go.transform:Find("Nature/Number").name="Chess"..data.number;--data.color..data.number;
		go.transform:Find("Nature/Color").name=data.color;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		if (i<8)then
			go.transform.localPosition = Vector3(-427 + space*(i - 1), 155, 0);
		elseif (i>14)then
			if (i<17)then
				go.transform.localPosition = Vector3(-427 + space*(i - 15), -145, 0);
			else
				go.transform.localPosition = Vector3(-427 + space*(i - 12), -145, 0);
			end
		else
			go.transform.localPosition = Vector3(-427 + space*(i - 8), 5, 0);
		end
		this.Room:AddClick(go,this.OnItemClick);
		resMgr:addAltas(go.transform,"ShierzhiRoom")
		local goo = go.transform:Find('DI/Sprite');
		goo:GetComponent('UISprite').spriteName = data.icon;
		if (data.color=="black") then
			goo:GetComponent('UISprite').color = Color.black;
		else
			goo:GetComponent('UISprite').color = Color.red;
		end

	  table.insert(chesssTable,go);
	end
end

--四棋子按钮布置
function ShierzhiRoomCtrl.FourRenderFunc()
	local parent=ShierzhiRoomPanel.FourChessList;
	local bundle = resMgr:LoadBundle("FourChess");
	local Prefab = resMgr:LoadBundleAsset(bundle,"FourChess");
	local space = 143;
	local len =8;
	local nameStart=69;
	for i=1,len do
		local go =GameObject.Instantiate(Prefab);
		local munber=nameStart+i;
		go.name="Chess"..munber;
		go.transform.parent=parent;
		go.transform.localScale=Vector3.one;
		if (i<7)then
			go.transform.localPosition=Vector3(-360+space*(i-1),83,0);
		elseif (i==7)then
			go.transform.localPosition=Vector3(-360+space*(i-7),-67,0);
		else
			go.transform.localPosition=Vector3(-360+space*(i-3),-67,0);
		end
		this.Room:AddClick(go,this.OnMoreChessClick);
	end
end
--竖直按钮布置（横的棋子2个）
function ShierzhiRoomCtrl.VRenderFunc()
	local parent=ShierzhiRoomPanel.VChessList;
	local bundle = resMgr:LoadBundle("VChess");
	local Prefab = resMgr:LoadBundleAsset(bundle,"VChess");
	local space = 143;
	local len =14;
	local nameStart=19;
	for i=1,len do
		local go =GameObject.Instantiate(Prefab);
		local munber=nameStart+i;
		go.name="Chess"..munber;
		go.transform.parent=parent;
		go.transform.localScale=Vector3.one;
		if (i<7)then
			go.transform.localPosition=Vector3(-360+space*(i-1),155,0);
		elseif (i>12)then
			if (i==13)then
				go.transform.localPosition=Vector3(-360+space*(i-13),-145,0);
			else
				go.transform.localPosition=Vector3(-360+space*(i-9),-145,0);
			end

		else
			go.transform.localPosition=Vector3(-360+space*(i-7),5,0);
		end
		this.Room:AddClick(go,this.OnMoreChessClick);
	end
end
--横向按钮布置(竖的棋子2个)
function ShierzhiRoomCtrl.WRenderFunc()
	local parent=ShierzhiRoomPanel.WChessList;
	local bundle = resMgr:LoadBundle("WChess");
	local Prefab = resMgr:LoadBundleAsset(bundle,"WChess");
	local space = 143;
	local len =11;
	local nameStart=39;
	for i=1,len do
		local go =GameObject.Instantiate(Prefab);
		local munber=nameStart+i;
		go.name="Chess"..munber;
		go.transform.parent=parent;
		go.transform.localScale=Vector3.one;
		if (i<8)then
			go.transform.localPosition=Vector3(-427+space*(i-1),83,0);
		else
			if (i<10)then
				go.transform.localPosition=Vector3(-427+space*(i-8),-67,0);
			else
				go.transform.localPosition=Vector3(-427+space*(i-5),-67,0);
			end
		end
		this.Room:AddClick(go,this.OnMoreChessClick);
	end
end
--庄家选择棋子显示容器
function ShierzhiRoomCtrl.HouseChessBoxRenderFunc()
	local parent=ShierzhiRoomPanel.houseChessBox;
	local bundle=resMgr:LoadBundle("houseChessBox");
	local Prefab=resMgr:LoadBundleAsset(bundle,"houseChessBox");
	local space=40.5;
	local len =20;
	for i=1,len do

		local go =GameObject.Instantiate(Prefab);
		go.name="houseChessBox"..i;
		go.transform.parent=parent;
		go.transform.localScale=Vector3.one;
		resMgr:addAltas(go.transform,"ShierzhiRoom")
		if (i<11)then

			go.transform.localPosition=Vector3(-185+space*(i-1),14,0);

		else
			go.transform.localPosition=Vector3(-185+space*(i-11),-35,0);
		end
		table.insert(houseChessBoxList,go);
	end
end
--更新开牌记录
this.up_history_list=nil
function ShierzhiRoomCtrl.UpdateHouseChessBox(id)
	--更新状态流程里，如果下庄就清空历史记录
	local go =nil ;
	local str ="HouseChess"..id;
	for k ,v in pairs(houseChessList)do
		if (str==v.name)then
			go=v;
		end
	end
	if (this.boxid>20)then
		for i=11,20 do
			houseChessBoxList[i].transform:Find("BG").gameObject:SetActive(false);
		end
		for k,v in pairs(this.up_history_list)do
			local box = houseChessBoxList[v.boxid]
			local spritename = v.name
			local color = v.color
			local ob= box.transform:Find("BG").gameObject;
			local sprite=ob.transform:Find("Sprite"):GetComponent("UISprite");
			sprite.spriteName=spritename;
			sprite.color=color;
			ob:SetActive(true);
		end
		this.up_history_list = nil
		this.boxid = 11
	end
	if (go~=nil)then
		local uisprite=go.transform:Find('DI/Sprite'):GetComponent("UISprite");
		local spriteName=uisprite.spriteName;
		local spriteColor=uisprite.color;

		local box= houseChessBoxList[this.boxid];
		local ob= box.transform:Find("BG").gameObject;
		local sprite=ob.transform:Find("Sprite"):GetComponent("UISprite");
		sprite.spriteName=spriteName;
		sprite.color=spriteColor;
		ob:SetActive(true);
		if not this.up_history_list then
			this.up_history_list ={}
		end
		if this.boxid >10 then
			local boxid = this.boxid - 10
			local data = {
				boxid = boxid,
				name = spriteName,
				color = spriteColor,
			}
			table.insert(this.up_history_list,data)
		end
		this.boxid=this.boxid+1;
		-- if this.boxid >20 then
		-- 	this.boxid = 1
		-- end


	end


end
--清空开牌记录
function this.ClearHouseChessBox()
	for i=1,#houseChessBoxList do
		houseChessBoxList[i].transform:Find("BG").gameObject:SetActive(false);
	end
	this.boxid=1;
	this.up_history_list=nil --更新历史记录上移
	this.historyID=0;
end

--时间时间
function ShierzhiRoomCtrl.timeEvent()
	this.FreeTimeEvent()
	this.updateBalanceScore()
	this.UpdateLidOnPress()
	this.CTBYkeY()
	this.ShadeTimeController()

end

-- --测试
function this.CTBYkeY()
	-- if (Input.GetKeyDown(KeyCode.K))then
	-- 	this.ShowBalance(1)
	-- end
	-- if (Input.GetKeyDown(KeyCode.L))then
	-- 	this._isdaoban=true
	-- 	-- this.ShowBigTime()
	-- end
end
function ShierzhiRoomCtrl.UpdateLidOnPress()

	if(this.shadeLidIsPress==true)then
		local pos =ShierzhiRoomPanel.Shade_Lid.transform.localPosition;

		local value =Input.mousePosition.x-this.startPos.x
		pos.x=value/1.7+pos.x;
		if (pos.x>85)then
			pos.x=85
		elseif (pos.x<-85)then
			pos.x=-85
		end
		ShierzhiRoomPanel.Shade_Lid.transform.localPosition=pos;
		this.startPos.x=this.startPos.x+value;

	end
end
function ShierzhiRoomCtrl.FreeTimeEvent()
	if (this._FreeTime > 0) then
		local time = this._FreeTime - ShierzhiRoomPanel.getTime()
		if (time >= 0) then
			local hours = math.floor(time / 3600);
			time = time - hours * 3600;
			local minute = math.floor(time / 60);
			time = time - minute * 60;
			if (this._isOpenTwo)then
				local s=GameData.changeFoLimitTime(time);
				ShierzhiRoomPanel.timeTxt_UILabel.fontSize=15
				ShierzhiRoomPanel.timeTxt_UILabel.text=hours..":"..minute..":"..s
			else
				ShierzhiRoomPanel.timeTxt_UILabel.fontSize=36
				ShierzhiRoomPanel.timeTxt_UILabel.text = GameData.changeFoLimitTime(time);
			end
		else
			this._FreeTime = 0;
			ShierzhiRoomPanel.timeTxt_UILabel.text ="00"
		end

	end

end

function ShierzhiRoomCtrl.OnItemClick(go)
 --房主不能点击
	if (this._IsRoom)then
		return
   end
   if (this._curState~=this._const.TWELVE_STATUS_BET)then
	return
   end
   currentSelectChessPosID=string.gsub(go.name,"Chess","")+0;
   currentSelectChessPosObj=go;
  --重置标志位
  isMoreChessSelect=false;
  signBetSelect=nil;
  this.ResetLastSelectChess();
  table.insert(currentSelect,go);
  isSelect=true;
  go.transform:Find('DI/Shadow').gameObject:SetActive(true);
   --押注后显示？？
  this.ShowBetMoneyMessage(go);
end

function ShierzhiRoomCtrl.OnMoreChessClick(go)
	if (this._IsRoom)then
		return
	end --房主不能点击
	if (this._curState~=this._const.TWELVE_STATUS_BET)then
		return
	end
	if(go.name=="BlackBtn")then
		currentSelectChessPosID=103;
	elseif(go.name=="RedBtn")then
		currentSelectChessPosID=102;
	elseif (go.name=="DingGe")then
		currentSelectChessPosID=100;
	elseif(go.name=="XiaGe")then
		currentSelectChessPosID=101;
	else
	currentSelectChessPosID=string.gsub(go.name,"Chess","")+0;
	end
	currentSelectChessPosObj=go;
  --重置标志位
  isMoreChessSelect=false;
  signBetSelect=nil;
  local chessList={};
  local str =go.transform.parent.name;
  if (str=="FourChessList")then
	  chessList=fourChess;
  elseif (str=="VChessList")then
	  chessList=VChess;
  elseif (str=="WChessList")then
	  chessList=WChess;
  else
	  chessList=MoreChessList;
	  isMoreChessSelect=true;
	  --signBetSelect=str;
	  signBetSelect=go.transform.parent;
  end
  this.ResetLastSelectChess();
  local tl={};
  for k,v in pairs(chessList)do
	  if (k==go.name)then
		  tl=v;
	  end
  end
  for k,v in pairs(tl)do
	  for k1,v1 in pairs(chesssTable)do
		  if (v==v1.name)then
			  table.insert(currentSelect,v1);
			  v1.transform:Find('DI/Shadow').gameObject:SetActive(true);
			  --押注后显示
			  this.ShowBetMoneyMessage(v1);
		  end
	  end
  end
  isSelect=true;

end
--筹码押注
this.red_bet_list = nil
function ShierzhiRoomCtrl.OnBetBtn(go)
	-- if (isSelect==false)then
	-- 	return
	-- end
	if (this._const == nil) then
		return
	end

	if (this._curState ~= this._const.TWELVE_STATUS_BET) then
		return
	end
	--房主不能下注
	if (this._IsRoom) then
		return
	end

	local coin = 0
	if(go.name == "betfive") then --1
		coin = 1
	elseif(go.name == "betten") then --5
		coin = 5
	elseif(go.name == "bethund") then --10
		coin = 10
	elseif(go.name == "betkilo") then --20
		coin = 20
	elseif(go.name == "bettenshou") then --50
		coin = 50
	elseif(go.name == "betmill") then --100
		coin = 100
	end
	--下注总金额
	this._allBetCoin=this._allBetCoin+coin;
	ShierzhiRoomPanel.sumBetMoney_UILabel.text=this._allBetCoin;
	local data = {
		coin = coin
	}
	if not this.red_bet_list then
		this.red_bet_list = {}
	end
	table.insert(this.red_bet_list,data)
end
-- this.bet_money={}
--检查选择的棋子是否已选过
function ShierzhiRoomCtrl.InspectionTable(value,tableValue)
	for k,v in pairs(tableValue)do
		if (value==v.name)then
			return true
		end
	end
	return false
end
--重置上一次选择的棋子
function ShierzhiRoomCtrl.ResetLastSelectChess()
	if (#currentSelect>0)then
		for k,v in pairs(currentSelect)do
			v.transform:Find('DI/Shadow').gameObject:SetActive(false);
			-- if (#selectChess>0)then
			-- 	if (this.InspectionTable(v.name,selectChess)==false) then
			-- 		v.transform:Find('BlueSprite').gameObject:SetActive(false);
			-- 	end
			-- else
			-- 	v.transform:Find('BlueSprite').gameObject:SetActive(false);
			-- end
			local str=v.transform:Find("Nature"):GetChild(0).name;
			if allBetChessList[str] == 0 then
				v.transform:Find('BlueSprite').gameObject:SetActive(false)
			end
		end
		currentSelect={};
	end
end
--重置所有押注的棋子的信息
function ShierzhiRoomCtrl.RestAllBetChessMessage()
	-- if (#selectChess>0)then
	-- 	for k,v in pairs(selectChess)do
	-- 		v.transform:Find('DI/Shadow').gameObject:SetActive(false);
	-- 		local blueObject= v.transform:Find("BlueSprite").gameObject;
	-- 		blueObject.transform:Find("Sum"):GetComponent('UILabel').text="/"..0;
	-- 		blueObject.transform:Find('Self'):GetComponent('UILabel').text=0;
	-- 		blueObject:SetActive(false);
	-- 	end
	-- 	selectChess={};
	-- end
	-- if (#currentSelect>0)then
	-- 	for k,v in pairs(currentSelect)do
	-- 		v.transform:Find('DI/Shadow').gameObject:SetActive(false);
	-- 		local blueObject= v.transform:Find("BlueSprite").gameObject;
	-- 		blueObject:SetActive(false);
	-- 	end
	-- end
	-- if ( #NetBetChess>0)then
	-- 	 for k ,v in pairs(NetBetChess)do
	-- 		local blueObject= v.transform:Find("BlueSprite").gameObject;
	-- 		blueObject.transform:Find("Sum"):GetComponent('UILabel').text="/"..0;
	-- 		blueObject.transform:Find('Self'):GetComponent('UILabel').text=0;
	-- 		blueObject:SetActive(false);
	-- 	 end
	-- end
	for k,v in pairs(chesssTable)do
		v.transform:Find('DI/Shadow').gameObject:SetActive(false);
		local blueObject= v.transform:Find("BlueSprite").gameObject;
		blueObject.transform:Find("Sum"):GetComponent('UILabel').text="/"..0;
		blueObject.transform:Find('Self'):GetComponent('UILabel').text=0;
		blueObject:SetActive(false);
	end
	selectChess={};
	-- NetBetChess={};
end
--显示押注金额信息
function ShierzhiRoomCtrl.ShowBetMoneyMessage(gam)
	local blueObject=gam.transform:Find('BlueSprite').gameObject;
	blueObject:SetActive(true);
	local str=gam.transform:Find("Nature"):GetChild(0).name;
	local sumMoney_Lable=blueObject.transform:Find('Sum'):GetComponent('UILabel');
	sumMoney_Lable.text="/"..this.GetSumMoney(str);
	local selfMoney_Lable=blueObject.transform:Find('Self'):GetComponent('UILabel');
	selfMoney_Lable.text=this.GetSelfMoney(str);
end
this.is_net_update_bet=nil
function ShierzhiRoomCtrl.UpdateAllBetByNet(data)
	-- local len = #data
	-- for posid ,money in pairs(data) do
	-- 	local info = this.GetDataByPosID(posid)
	this.is_net_update_bet=true
	this.UpdateAllBetMessage(data)

end

--更新全局下注金额信息
function ShierzhiRoomCtrl.UpdateAllBetMessage(data)
	local list={}
	if this.is_net_update_bet then
		list = data
	else
		list=data.bet_list;
	end
	-- local list=data.bet_list;


	local chat_list = {}
	for k,v in pairs(list)do
		local info ={}

		if this.is_net_update_bet then
			info = this.GetDataByPosID(k)
		else
			info = this.GetDataByPosID(v.pos)
		end

		-- local info=this.GetDataByPosID(v.pos);
		if (info=="DingGe" or info=="XiaGe" or info=="redChess" or info=="blackChess")then
			local money = 0
			if this.is_net_update_bet then
				money = v
			else
				money = v.money
			end
			allBetChessList[info]=allBetChessList[info]+money;
			-- if(this._IsRoom)then
			-- 	--更新顶割下割，红黑金额
			-- 	ShierzhiRoomPanel:GetMoreChessLabel(info).text=allBetChessList[info];
			-- end
			-- if this.is_net_update_bet then
			-- 	ShierzhiRoomPanel:GetMoreChessLabel(info).text=allBetChessList[info];
			-- end
			ShierzhiRoomPanel:GetMoreChessLabel(info).text=allBetChessList[info];
			if chat_list[info]then
				chat_list[info]= chat_list[info]+money
			else
				chat_list[info] = money
			end
			betChessList[info]=allBetChessList[info]
		else
			-- local averageMoney=v.money/#info;
			local averageMoney=0;
			if this.is_net_update_bet then
				averageMoney = v/#info
			else
				averageMoney = v.money/#info;
			end
			if info then
				for k1,v1 in pairs(info)do
					local str =v1.transform:Find("Nature"):GetChild(0).name;
					allBetChessList[str]=allBetChessList[str]+averageMoney;
					--庄家更新金额信息
					-- if(this._IsRoom or this.is_net_update_bet)then
					-- 	-- this.ShowBetMoneyMessage(v1);
					-- 	table.insert(NetBetChess,v1);
					-- else

					-- end
					-- for k2,v2 in pairs(selectChess)do
					-- 	if (v2.transform:Find("Nature"):GetChild(0).name==str)then
					-- 		this.ShowBetMoneyMessage(v2);
					-- 	end
					-- end
					this.ShowBetMoneyMessage(v1);
					if chat_list[str]then
						chat_list[str]= chat_list[str]+averageMoney
					else
						chat_list[str] = averageMoney
					end
				end
			end
		end
	end

	if this.is_net_update_bet then
		this.is_net_update_bet=false
		return
	end
	local who =0;
	local name =data.player_name;
	if (name~=ShierzhiRoomPanel.getPlayerName())then
		who=1;
	end
	-- local text = "在%s位置下注%s分"
	for k,v in pairs(chat_list)do
		if v~=0 then
			local chat_info ={
				player_name=data.player_name,
				msg = string.format(i18n.TID_12ZHI_CHAT_INFO,chessName[k],v),
				from_headid=data.headimgurl,
			}
			if(global._view:getViewBase("Chat")~=nil)then
				global._view:getViewBase("Chat").UpdateMessage(chat_info,who);
			end
		end
	end

end
--获取该棋子押注的总额
function ShierzhiRoomCtrl.GetSumMoney(chessName)
	return allBetChessList[chessName];

end

--获取该棋子自己押注的金额
function ShierzhiRoomCtrl.GetSelfMoney(chessName)
	return betChessList[chessName];
end
--发送押注金额到服务端
function ShierzhiRoomCtrl.OkOnclick()
	if (this._IsRoom )then
		return
	end
	if (this._curState~=this._const.TWELVE_STATUS_BET)then
		return
	end
	if isSelect == false then
		local str = "未选择下注棋子"
		ShierzhiRoomPanel.setTip(str)
		return
	end
	if not this.red_bet_list then
		local str = "未选择押注金额"
		ShierzhiRoomPanel.setTip(str)
		return
	end
	global._view:showLoading();

	for k,info in pairs (this.red_bet_list)do
		if (isMoreChessSelect==true)then
			local na =signBetSelect.name;
			betChessList[na]=betChessList[na]+info.coin;
			nowBetChessList[na]=nowBetChessList[na]+info.coin;
			ShierzhiRoomPanel:GetMoreChessLabel(na).text=betChessList[na];
		else
			local averageCoin=info.coin/#currentSelect
			for k,v in pairs(currentSelect)do
				local str= v.transform:Find("Nature"):GetChild(0).name
				for k1,v1 in pairs(betChessList)do
					if (k1==str)then
						betChessList[k1]=betChessList[k1]+averageCoin;
						nowBetChessList[k1]=nowBetChessList[k1]+averageCoin;
					end
				end
				--全局记录押注棋子
				if (#selectChess>0)then
					if (this.InspectionTable(v.name,selectChess)==false)then
						table.insert(selectChess,v)
					end
				else
					table.insert(selectChess,v)
				end
				-- for k2,v2 in pairs(selectChess)do
				-- 	if (v2.transform:Find("Nature"):GetChild(0).name==str)then
				-- 		this.ShowBetMoneyMessage(v2);
				-- 	end
				-- end
			end
		end
		local bet_list={}
		bet_list.pos=currentSelectChessPosID;
		bet_list.money=info.coin;
		table.insert(betChessDataListToNet,bet_list);
		--下注动画
		local bet_list_Amina={}
		bet_list_Amina.obj=currentSelectChessPosObj;
		bet_list_Amina.money=info.coin;
		table.insert (betChessDataAmina,bet_list_Amina);
	end
	if (#betChessDataListToNet>0)then
		ShierzhiRoomPanel.SendBetListToNet(betChessDataListToNet,function()

		end)
	end
	this.red_bet_list = nil
end
function this.BetCallBack()

	--这一局下注总金额
	this._totalBetCoin=this._totalBetCoin+this._allBetCoin;
	--清空单次下注金额记录
	nowBetChessList={
		redChess=0,blackChess=0,
		DingGe=0,XiaGe=0,
		Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
		Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
	}
	betChessDataListToNet={};
	this._allBetCoin=0;
	ShierzhiRoomPanel.sumBetMoney_UILabel.text=this._allBetCoin;
	--播放下注动画
	this.BetAmina(betChessDataAmina)

	betChessDataAmina={};
end
--下注动画
--[[
	{
		{obj=obj , money=int },
	}
]]
function this.BetAmina(list)
	local len =#list
	for i=1 ,len do
		local go=nil

		local obj =list[i].obj;
		local parent =obj.transform.parent;
		obj.transform.parent=ShierzhiRoomPanel.showUI.transform;
		local pos =obj.transform.localPosition;
		obj.transform.parent=parent;
		local money=list[i].money;
		-- for k,v in pairs(BetAminaPrefab)do
		-- 	if (v.name==money )then s
		-- 		go=v.obj;
		-- 		table.remove(BetAminaPrefab,k);
		-- 		break;
		-- 	end
		-- end
		if (go==nil)then

			local bundle=resMgr:LoadBundle("AminaBet");
			local Prefab = resMgr:LoadBundleAsset(bundle,"AminaBet");
			go= GameObject.Instantiate(Prefab);
			go.transform.parent = ShierzhiRoomPanel.showUI.transform;
			go.transform.localPosition = Vector3(505,-70,0);
			go.transform.localScale = Vector3.one;
			resMgr:addAltas(go.transform,"ShierzhiRoom");
			go.name =money;
			local sprite=go:GetComponent("UISprite");
			if (money==1)then
				sprite.spriteName="youbiandikuang_chouma_6"
			elseif (money==5)then
				sprite.spriteName="youbiandikuang_chouma_3"
			elseif (money==10)then
				sprite.spriteName="youbiandikuang_chouma_5"
			elseif (money==20)then
				sprite.spriteName="youbiandikuang_chouma_4"
			elseif (money==50)then
				sprite.spriteName="youbiandikuang_chouma_1"
			elseif (money==100)then
				sprite.spriteName="youbiandikuang_chouma_2"
			end
			-- local data ={}
			-- data.name=money;
			-- data.obj=go ;
			table.insert(BetAminaPrefab,go);
		end
		this.PlayBetAmina(go,pos)
	end


end

function this.PlayBetAmina(go,pos)
	go.gameObject:SetActive(true);
	local tp =go:GetComponent("TweenPosition");
	local ta=go:GetComponent("TweenAlpha");
	tp.from= Vector3(505,-70,0);
	tp.to =pos;
	--ta.from=1;
	--ta.to=1;
	tp.duration=0.4;
	--ta.duration=0.4;
	tp.enabled=true;
	-- ta.enabled=true;
	tp:ResetToBeginning();
	ta:ResetToBeginning();
	tp:PlayForward();
	--ta:PlayForward();
	resMgr:TweenPosEventDeleate(tp,function()
		tp.enabled=false;
		ta.enabled=false;
		this.PlayBetNextAmina(go,pos);

	end)
end
function this.PlayBetNextAmina(go,pos)
	local ta=go:GetComponent("TweenAlpha");
	local tp =go:GetComponent("TweenPosition");
	ta.from=1;
	ta.to=0;
	ta.duration=0.5
	tp.from=pos;
	tp.to=pos;
	tp.duration=0.5
	ta.enabled=true
	tp.enabled=true;
	resMgr:TweenPosEventDeleate(tp,function()
		tp.enabled=false;
		ta.enabled=false;
		tp.gameObject:SetActive(false);
		-- local money =tp.gameObject.name +0;
		-- local data ={}
		-- data.name=money;
		-- data.obj=tp.gameObject ;

	end)
end

--取消棋子上的押金
function ShierzhiRoomCtrl.ClearBtnOnClick()
	if (this._IsRoom)then
		return
	end
	if (this._curState~=this._const.TWELVE_STATUS_BET)then
		return
	end
	betChessDataListToNet={};
	betChessDataAmina={};
	this._allBetCoin=0;
	ShierzhiRoomPanel.sumBetMoney_UILabel.text=this._allBetCoin;
	this.red_bet_list = nil
	for k ,v in pairs(nowBetChessList)do
		if (v>0)then
			betChessList[k]=betChessList[k]-nowBetChessList[k];
			if (k=="DingGe" or k=="XiaGe" or k=="redChess" or k=="blackChess")then
				ShierzhiRoomPanel:GetMoreChessLabel(k).text=betChessList[k];

			else
				for k1,v1 in pairs(selectChess)do
					if (v1.transform:Find("Nature"):GetChild(0).name==k)then
						this.ShowBetMoneyMessage(v1);
						if (betChessList[k]<=0)then
							v1.transform:Find("BlueSprite").gameObject:SetActive(false);
							for i=#selectChess,1,-1 do
								if selectChess[i]==k then
									table.remove(selectChess,i);
								end
							end
						end
					end
				end
			end
		end
	end

	nowBetChessList={
		redChess=0,blackChess=0,
		DingGe=0,XiaGe=0,
		Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
		Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
	}
end
--根据棋子位置获取对应的棋子列表或顶下红黑
function ShierzhiRoomCtrl.GetDataByPosID(id)
	local str ="Chess"..id;
	local chesslist ={};
	if (id<20)then
		for k,v in pairs(chesssTable)do
			if (v.name==str)then
				table.insert(chesslist,v);
				break
			end
		end
	elseif(id<40)then
		for k,v in pairs(VChess[str])do
			for k2,v2 in pairs(chesssTable)do
				if (v2.name==v)then
					table.insert(chesslist,v2);
					break
				end
			end
		end
	elseif(id<60)then
		for k,v in pairs(WChess[str])do
			for k2,v2 in pairs(chesssTable)do
				if (v2.name==v)then
					table.insert(chesslist,v2);
					break
				end
			end
		end
	elseif(id<80)then
		for k,v in pairs(fourChess[str])do
			for k2,v2 in pairs(chesssTable)do
				if (v2.name==v)then
					table.insert(chesslist,v2);
					break
				end
			end
		end
	elseif(id==100)then
		return "DingGe"
	elseif(id==101)then
		return "XiaGe"
	elseif(id==102)then
		return "redChess"
	elseif(id==103)then
		return "blackChess"
	end
	if (#chesslist>0)then
		return chesslist;
	end
end
--清空押注信息(下注前清空)
function ShierzhiRoomCtrl.ClearBetMessage()
	this.RestAllBetChessMessage();--重置所有押注的棋子的信息
	isSelect=false;--是否选择棋子的标志
	currentSelect={};--当前选择的棋子
	isMoreChessSelect=false;--是否点击顶割，下割，红，黑标志
	signBetSelect=nil;--记录点击顶割，下割，红，黑
	currentSelectChessPosID=nil;--当前下注的位置
	currentSelectChessPosObj=nil;--下注动画
    betChessList={
		redChess=0,blackChess=0,
		DingGe=0,XiaGe=0,
		Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
		Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
	}
	nowBetChessList={
		redChess=0,blackChess=0,
		DingGe=0,XiaGe=0,
		Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
		Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
	}
	allBetChessList={
		redChess=0,blackChess=0,
		DingGe=0,XiaGe=0,
		Chess1=0,Chess2=0,Chess3=0,Chess4=0,Chess5=0,Chess6=0,
		Chess7=0,Chess8=0,Chess9=0,Chess10=0,Chess11=0,Chess12=0,
	}

	betChessDataListToNet={};
	betChessDataAmina={};
	this._totalBetCoin=0;
	this._allBetCoin = 0;
	this.red_bet_list = nil
	ShierzhiRoomPanel.sumBetMoney_UILabel.text=0;

end
--清空庄家棋子选择信息
function ShierzhiRoomCtrl.ClearRobChessMessage()
	--if (houseChessSelectToNet~=nil)then
		ShierzhiRoomPanel.ShadeChess.gameObject:SetActive(false);
		ShierzhiRoomPanel.ownerShade_Chess:SetActive(false);
		currentHouseChess=nil;--记录庄家选择的棋子
		houseChessSelectToNet=nil;
	--end
	if(this.panelShadeState==0)then
		ShierzhiRoomPanel.ownerShade_Lid.transform.localPosition=Vector3(63,0,0);
		ShierzhiRoomPanel.ownerShade_Lid.transform.localRotation=Vector3(0,0,-70);
		this.panelShadeState=1;
	end
	--this.result_card=nil;
end
--清空所有棋子的记录
function ShierzhiRoomCtrl.ClearAllChess()
	chesssTable={};
	houseChessList={};
	houseChessBoxList={};
end
--清空显示金额(下注前清空)
function ShierzhiRoomCtrl.ClearBetMoneyMessage()
	ShierzhiRoomPanel.blackLabel.text=0;
	ShierzhiRoomPanel.redLabel.text=0;
	ShierzhiRoomPanel.DingGeLabel.text=0;
	ShierzhiRoomPanel.XiaGeLabel.text=0;
	for k,v in pairs(chesssTable)do
		local blueObject=v.transform:Find('BlueSprite').gameObject;
		local sumMoney_Lable=blueObject.transform:Find('Sum'):GetComponent('UILabel');
		sumMoney_Lable.text="/"..0;
		local selfMoney_Lable=blueObject.transform:Find('Self'):GetComponent('UILabel');
		selfMoney_Lable.text=0;
	end
end
-- function ShierzhiRoomCtrl.OnselectChessBtnClick(go)
function ShierzhiRoomCtrl.ShowWonerPanel()
	if (this._IsRoom==false)then
		ShierzhiRoomPanel.HouseOwnerPanel:SetActive(false)
		return
	end--不是房主无法开打
	if (this._isOpenTwo)then
		return
	end
	-- if (this._curState~=this._const.TWELVE_STATUS_SELECT)then
	if this._curState < this._const.TWELVE_STATUS_SELECT then
		for k,v in pairs(houseChessList)do
			v.transform:Find("DI"):GetComponent("UISprite").color=Color.gray;
		end
		ShierzhiRoomPanel.HouseClose:SetActive(true)
		ShierzhiRoomPanel.ownerPanel_OkBtn:GetComponent("UISprite").color=Color.gray
		return
	elseif this._curState > this._const.TWELVE_STATUS_SELECT then
		ShierzhiRoomPanel.ownerPanel_OkBtn:GetComponent("UISprite").color=Color.gray
		ShierzhiRoomPanel.HouseClose:SetActive(true)
	end
	if (houseChessSelectToNet)then
		return
	end
	ShierzhiRoomPanel.HouseOwnerPanel:SetActive(true);
	ShierzhiRoomPanel.ownerShade_Chess:SetActive(false);

	if (this._curState~=this._const.TWELVE_STATUS_SELECT)then
		return
	end
	for k,v in pairs(houseChessList)do
		v.transform:Find("DI"):GetComponent("UISprite").color=Color.white;
	end
	ShierzhiRoomPanel.HouseClose:SetActive(false)
	ShierzhiRoomPanel.ownerPanel_OkBtn:GetComponent("UISprite").color=Color.white
	--ShierzhiRoomPanel.uibox:SetActive(true);
end

--关闭庄家出牌面板
function ShierzhiRoomCtrl.HouseOwnerPanelClose()
	if (this.isPlayHouseAmina==true)then
		return;
	end
	--1.24修改
	if this._IsRoom then
		return
	end

	ShierzhiRoomPanel.HouseOwnerPanel:SetActive(false);
	--ShierzhiRoomPanel.uibox:SetActive(false);
end
--庄家界面布置
function ShierzhiRoomCtrl.HouseRenderFunc()
	-- local list =houseChess;
	-- local parent = ShierzhiRoomPanel.HouseChessList;
	-- local bundle = resMgr:LoadBundle("HouseChess");
	-- local Prefab = resMgr:LoadBundleAsset(bundle,"HouseChess");
	-- local space = 126;
	-- local len = #list;
	-- for i = 1, len do
	-- 	local data = list[i]
	-- 	local go = GameObject.Instantiate(Prefab);
	-- 	go.name = "HouseChess"..i;
	-- 	go.transform:Find("Nature/Number").gameObject.name=data.number;
	-- 	go.transform:Find("Nature/Color").gameObject.name=data.color;
	-- 	--go.transform:Find("Nature/Color").name=data.color;
	-- 	go.transform.parent = parent;
	-- 	go.transform.localScale = Vector3.one*0.9;
	-- 	if (i<7)then
	-- 		go.transform.localPosition = Vector3(-315 + space*(i - 1), -56, 0);
	-- 	else
	-- 		go.transform.localPosition = Vector3(-315 + space*(i - 7), 68, 0);
	-- 	end
	-- 	this.Room:AddClick(go,this.OnHouseChessClick);
	-- 	resMgr:addAltas(go.transform,"ShierzhiRoom")
	-- 	local goo = go.transform:Find('DI/Sprite');
	-- 	local quan =go.transform:Find("DI/quan");
	-- 	goo:GetComponent('UISprite').spriteName = data.icon;
	-- 	if (data.color=="black") then
	-- 		goo:GetComponent('UISprite').color = Color.black;
	-- 		quan:GetComponent("UISprite").color=Color.red;
	-- 	else
	-- 		goo:GetComponent('UISprite').color = Color.red;
	-- 		quan:GetComponent("UISprite").color=Color.white;
	-- 	end

	-- 	table.insert(houseChessList,go);
	-- end
	local list =houseChess;
	local parent = ShierzhiRoomPanel.HouseChessList;
	local bundle = resMgr:LoadBundle("HouseChess");
	local Prefab = resMgr:LoadBundleAsset(bundle,"HouseChess");
	-- local space = 126;
	local space = 85
	local len = #list;
	for i = 1, len do
		local data = list[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "HouseChess"..i;
		go.transform:Find("Nature/Number").gameObject.name=data.number;
		go.transform:Find("Nature/Color").gameObject.name=data.color;
		--go.transform:Find("Nature/Color").name=data.color;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one*0.7;
		if (i<4)then
			go.transform.localPosition = Vector3(450 + space*(i - 1),35, 0);
		elseif i<7 then
			go.transform.localPosition = Vector3(450 + space*(i - 4),-50, 0);
		elseif i<10 then
			go.transform.localPosition = Vector3(450 + space*(i - 7),-135, 0);
		elseif i<13 then
			go.transform.localPosition = Vector3(450 + space*(i - 10),-220, 0);
		end
		this.Room:AddClick(go,this.OnHouseChessClick);
		resMgr:addAltas(go.transform,"ShierzhiRoom")
		local goo = go.transform:Find('DI/Sprite');
		local quan =go.transform:Find("DI/quan");
		goo:GetComponent('UISprite').spriteName = data.icon;
		if (data.color=="black") then
			goo:GetComponent('UISprite').color = Color.black;
			quan:GetComponent("UISprite").color=Color.red;
		else
			goo:GetComponent('UISprite').color = Color.red;
			quan:GetComponent("UISprite").color=Color.white;
		end

		table.insert(houseChessList,go);
	end
end
function ShierzhiRoomCtrl.OnHouseChessClick(go)
	if(this.houseChessFormerPos~=nil)then
		return
	end
	if (currentHouseChess~=nil)then
		currentHouseChess.transform:Find("DI"):GetComponent("UISprite").color=Color.white;
	end
	go.transform:Find("DI"):GetComponent("UISprite").color=Color.gray;
	-- currentHouseChess=nil;
	currentHouseChess=go;
end

function ShierzhiRoomCtrl.OwnerPanelOKBtnClick()
	if (currentHouseChess==nil)then
		return
	end
	if (this._curState~=this._const.TWELVE_STATUS_SELECT)then
		return
	end
	if houseChessSelectToNet then
		return
	end
	-- houseChessSelectToNet=nil;
	houseChessSelectToNet=currentHouseChess;--向服务端发送庄家选择的棋子
	--向服务器发送庄家选择的牌
	local id =houseChessSelectToNet.transform:Find("Nature"):GetChild(0).name+0;
	ShierzhiRoomPanel.SendSelectChessToNet(id,function()
		this.result_card=currentHouseChess;
		--播放动画
		ShierzhiRoomPanel.ownerPanel_OkBtn:GetComponent("UISprite").color=Color.gray
		this.PlayHouseChessAnima(houseChessSelectToNet);
	end);
end
--播放房主棋子动画
function ShierzhiRoomCtrl.PlayHouseChessAnima(go)
	this.isPlayHouseAmina=true;
	ShierzhiRoomPanel.HouseOwnerPanel:SetActive(true);--庄家面板没打开，帮他打开，播放完动画后关掉；
	--ShierzhiRoomPanel.uibox:SetActive(true);
	ShierzhiRoomPanel.ownerPanelShade:SetActive(true)
	local di= go.transform:Find("DI")
	local sprite =di:Find("Sprite");
	di:GetComponent("UIWidget").depth=60;
	sprite:GetComponent("UIWidget").depth=61;
	local tp=go:GetComponent("TweenPosition");
	local ts=go:GetComponent("TweenScale");
	this.houseChessFormerPos=go.transform.localPosition;

	tp.from=this.houseChessFormerPos;
	tp.to=Vector3(-165,-165,0);
	ts.to=Vector3(0.7,0.7,1);
	tp.duration=SHADE_TIME_PLAY;
	ts.duration=SHADE_TIME_PLAY;
	tp.enabled=true;
	ts.enabled=true;
	tp:ResetToBeginning();
	tp:PlayForward();
	ts:ResetToBeginning();
	ts:PlayForward();
	-- resMgr:TweenPosEventDeleate(tp,function()
	-- 	 this.OwnerShadeNextAnima()
	-- 	 tp.enabled=false;
	-- 	 ts.enabled=false;
	-- end )
	this.shade_status = SHADE_STATUS_PLAY
	this.shade_timer = SHADE_TIME_PLAY
end
--盖子动画
function ShierzhiRoomCtrl.OwnerShadeNextAnima()
	if (this.houseChessFormerPos and this.result_card and this.panelShadeState==1)then
		this.result_card:SetActive(false);
		this.SetShadeChess(this.result_card);
		local tp=ShierzhiRoomPanel.ownerShade_Lid:GetComponent("TweenPosition");
		local tr=ShierzhiRoomPanel.ownerShade_Lid:GetComponent("TweenRotation");
		tp.from=Vector3(63,0,0);
		tp.to=Vector3.zero;

		tp.duration=SHADE_TIME_NEXT
		tr.duration=SHADE_TIME_NEXT
		--tr.from=Vector3(0,0,-70);

		--tr.to=Vector4.zero;
		tp.enabled=true;
		tr.enabled=true;
		tp:ResetToBeginning();
		tp:PlayForward();
		tr:ResetToBeginning();
		tr:PlayForward();
		this.panelShadeState=0;
		-- resMgr:TweenPosEventDeleate(tp,function ()
		-- 	 this.ResetOwnerPanelAndPlayNextAnima()
		-- 	 tp.enabled=false;
		-- 	 tr.enabled=false;
		-- end);
	end
end
function ShierzhiRoomCtrl.SetShadeChess(go)
	local chessNumber=go.transform:Find("Nature"):GetChild(0).name+0;
	local chessNature=nil
	for k,v in pairs(houseChess)do
		if (v.number==chessNumber)then
			chessNature=v
			break
		end
	end
	--初始化遮罩内的棋子
	if(chessNature)then
		ShierzhiRoomPanel.ShadeChess:SetActive(true);
		ShierzhiRoomPanel.ownerShade_Chess:SetActive(true);
		ShierzhiRoomPanel.ShadeChess_UISprite.spriteName=chessNature.icon;
		ShierzhiRoomPanel.ownerShade_Chess_UISprite.spriteName=chessNature.icon;
		if (chessNature.color=="black")then
			ShierzhiRoomPanel.ShadeChess_UISprite.color=Color.black;
			ShierzhiRoomPanel.ownerShade_Chess_UISprite.color=Color.black;
			ShierzhiRoomPanel.ownerShade_Chess_Quan_UISprite.color=Color.red;
			ShierzhiRoomPanel.ShadeChess_Quan_UISprite.color=Color.red;
		else
			ShierzhiRoomPanel.ShadeChess_UISprite.color=Color.red;
			ShierzhiRoomPanel.ownerShade_Chess_UISprite.color=Color.red;
			ShierzhiRoomPanel.ownerShade_Chess_Quan_UISprite.color=Color.white;
			ShierzhiRoomPanel.ShadeChess_Quan_UISprite.color=Color.white;
		end
	end
end
function ShierzhiRoomCtrl.ResetOwnerPanelAndPlayNextAnima()
	if (this.houseChessFormerPos and this.result_card)then
		ShierzhiRoomPanel.Shade:SetActive(true);
		this.isPlayHouseAmina=false;
		this.HouseOwnerPanelAndReset();
		this.PlayShadeFallAnima();

	end
end
--播放遮罩下落动画
function ShierzhiRoomCtrl.PlayShadeFallAnima()
	-- if (this.ShadeIsFalling==true )then
	-- 	return
	-- end

	--this.ShadeIsFalling=true;
	local tp =ShierzhiRoomPanel.Shade:GetComponent("TweenPosition");
	local ts =ShierzhiRoomPanel.Shade:GetComponent("TweenScale");
	tp.from=ShierzhiRoomPanel.ShadePos;
	ts.from=Vector3(1.5,1.5,0);
	tp.to=Vector3(-129,-234,0);
	ts.to=Vector3(1,1,1);
	tp.duration=SHADE_TIME_FALL;
	ts.duration=SHADE_TIME_FALL;
	tp.enabled=true;
	ts.enabled=true;
	tp:ResetToBeginning();
	ts:ResetToBeginning();
	tp:PlayForward();
	ts:PlayForward();
	-- resMgr:TweenPosEventDeleate(tp,function()
	-- 	tp.enabled=false;
	-- 	ts.enabled=false;
	-- end)
end
function ShierzhiRoomCtrl.PlayShadeUPAnima()
	-- if (this._IsOpenGame)then
	-- 	return
	-- end
	-- this.ShadeIsFalling=false;
	ShierzhiRoomPanel.Shade:SetActive(true);
	local tp =ShierzhiRoomPanel.Shade:GetComponent("TweenPosition");
	local ts =ShierzhiRoomPanel.Shade:GetComponent("TweenScale");
	tp.from=Vector3(1.5,1.5,0);
	ts.from=Vector3(1,1,1);
	tp.to=Vector3(-129,75,0);
	ts.to=Vector3(2,2,2);
	tp.duration=0.3;
	ts.duration=0.3;
	tp.enabled=true;
	ts.enabled=true;
	tp:ResetToBeginning();
	ts:ResetToBeginning();
	tp:PlayForward();
	ts:PlayForward();
	-- resMgr:TweenPosEventDeleate(tp,function()
	-- 	tp.enabled=false;
	-- 	ts.enabled=false;
	-- end)
end
function ShierzhiRoomCtrl.ShadeLidOnPress(go,isPress)
	--  if(this._IsOpenGame)then
	-- 	return
	--  end
	if (this._curState~=this._const.TWELVE_STATUS_OPEN)then
		this.shadeLidIsPress=false;
		return
	end
	if (this.shadeLidIsPress==false)then
		this.shadeLidIsPress=true
		this.startPos=Input.mousePosition;
	else
			this.shadeLidIsPress=false
	end
end
function ShierzhiRoomCtrl.ResetShade()
	ShierzhiRoomPanel.Shade:SetActive(false);
	this.shadeLidIsPress=false;
	ShierzhiRoomPanel.Shade.transform.localPosition=ShierzhiRoomPanel.ShadePos;
	ShierzhiRoomPanel.Shade.transform.localScale=Vector3(1.5,1.5,1);
	ShierzhiRoomPanel.Shade_Lid.transform.localPosition=Vector3.zero;
end

--抢庄
function ShierzhiRoomCtrl.OnRob(go)
	if (this._const == nil) then
		return
	end
	if (this._curState ~= this._const.TWELVE_STATUS_BANKER) then
		this._robData = nil
		return
	end
	if (this._robData == nil) then
		ShierzhiRoomPanel.getRobInfo()
	else
		this.robCallBack(this._robData)
	end
end
--抢庄信息回调
--调查庄家设置面板，
function ShierzhiRoomCtrl.robCallBack(data)
	if(this._curState == this._const.TWELVE_STATUS_BANKER) then --抢庄
		this.showUIprefab("ShierzhiRob")
		if(this._uiPreant ~= nil) then
			if(this._uiPreant.name == "ShierzhiRobbar") then
				this._robData = data

				local minscore = tonumber(data.banker_min_coin)
				local maxscore = tonumber(data.player_max_coin)
				if(data.player_max_coin == "") then
					maxscore = 0
				end
				if(data.banker_min_coin == "") then
					minscore = 0
				end
				local text = string.format(i18n.TID_BANKER_INFO,minscore,maxscore)
				this._uiPreant.transform:Find('hint'):GetComponent('UILabel').text = text
				-- "提示：庄家最低"..minscore.."分以上才能抢庄,玩家能设置最高不超过" .. maxscore

				local maxInput = this._uiPreant.transform:Find('maxInput').gameObject;
				local maxInput_UIInput = maxInput:GetComponent('UIInput');
				local maxInput_UILabel = maxInput:GetComponent('UILabel');
				maxInput_UILabel.text = maxscore
				maxInput_UIInput.value = maxscore
				this._robBet = maxscore
				resMgr:InputEventDeleate(maxInput_UIInput,function()
					if(tonumber(maxInput_UIInput.value) > maxscore) then
						maxInput_UIInput.value = maxscore
					elseif(tonumber(maxInput_UIInput.value) < 1) then
						maxInput_UIInput.value = 1
					end
					maxInput_UILabel.text = maxInput_UIInput.value
					this._robBet = maxInput_UIInput.value
				end)

				local robOk = this._uiPreant.transform:Find('robOk').gameObject;
				this.Room:AddClick(robOk, function ()
					if(this._robBet == 0) then
						ShierzhiRoomPanel.setTip("抢庄金额不能低于1")
						return
					end
					this._robBet =  maxInput_UIInput.value
					ShierzhiRoomPanel.robData(this._robBet)
				end);



			end
		end
	end
end

function ShierzhiRoomCtrl.RobBroadcast(data)

	local list ={
		player_name=ShierzhiRoomPanel.getPlayerName(),
		msg="玩家"..data.player_name.."进行抢庄！抢庄积分为："..data.coin,
		from_headid=data.headimgurl,
	}
	if(global._view:getViewBase("Chat")~=nil)then
		global._view:getViewBase("Chat").UpdateMessage(list,0);
	end

end


--分享
function ShierzhiRoomCtrl.OnShare()
	-- local card = string.split("3,2,2,1,10,10", ",")
	-- this.renderFunc(card)
	this.showUIprefab("shareUI")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "shareUIbar") then
			local sharefriend = this._uiPreant.transform:Find('sharefriend').gameObject;
			this.Room:AddClick(sharefriend, function ()
				local desc = "同时200人在线12支,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "12支[房号:" .. this.RoomId .. "]"
				if this.IsGameRoom then
					desc = "同时200人在线12支,您的好友邀请您进入游戏"
					title = "12支[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(1,desc,"",title)

			end);
			local shareall = this._uiPreant.transform:Find('shareall').gameObject;
			this.Room:AddClick(shareall, function ()
				local desc = "同时200人在线12支,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "12支[房号:" .. this.RoomId .. "]"
				if this.IsGameRoom then
					desc = "同时200人在线12支,您的好友邀请您进入游戏"
					title = "12支[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(1,desc,"",title)
				global.sdk_mgr:share(0,desc,"",title)
			end);
		end
	end
end
--历史记录
function ShierzhiRoomCtrl.OnHistory()
	ShierzhiRoomPanel.ReqRecord()
end
--历史记录回调处理数据
function ShierzhiRoomCtrl.HistoryCallBack(data)
	local info = {}
	info.item_list = {}
	for k,v in pairs(data)do
		local list = {}
		local title_str = "第 %s 期"
		list.title_label = string.format(title_str,v.bout )--todo

		local contentLabel_str = "本期开奖："
		list.contentLabel = contentLabel_str

		local content_sprite_name = "tbkaichulaizidiban"
		list.content_sprite_name = content_sprite_name


		local str = "Chess"..v.card
		local chess_name =nil
		if v.card < 7 then
			chess_name = "[000000FF]"..chessName[str]
		else
			chess_name = "[FF0000FF]"..chessName[str]
		end
		list.content_sprite_label = chess_name

		local result_money =nil
		--根据输赢选择颜色的字体
		if v.coin >=0 then
			-- result_money = "[FFEA74FF]".."赢    +"..v.coin
			result_money = "[FFEA74FF]".."+"..v.coin
		else
			local c = -1*v.coin
			-- result_money = "[06FF5AFF]".."输    -"..c
			result_money = "[06FF5AFF]".."-"..c
		end
		list.result_label = result_money

		local image_name = "tbyiriliaokai"
		list.Image_name = image_name
		--循环拼接 ,选择颜色
		local bet_list = v.pos_amount_bet

		local chess_list = {}
		for pos,money in pairs (bet_list)do
			local chess = this.GetDataByPosID(pos)
			if (chess=="DingGe" or chess=="XiaGe" or chess=="redChess" or chess=="blackChess")then
				if not chess_list[chess]then
					chess_list[chess] = 0
				end
				chess_list[chess] = chess_list[chess] + money
			else
				local ave = money/#chess
				for k1,v1 in pairs(chess)do
					local name = v1.transform:Find("Nature"):GetChild(0).name
					if not chess_list[name]then
						chess_list[name] = 0
					end
					chess_list[name] = chess_list[name] + ave
				end
			end
		end
		local text = ""
		local tip_str = "%s:%s%s"--"车：100 ，"
		local len = Get_len(chess_list)
		local count = 0
		for na,money in pairs(chess_list)do
			count = count + 1
			local name = chessName[na]
			if count < len then
				text = text..string.format(tip_str,name,money," ")
			else
				text = text..string.format(tip_str,name,money," ")
			end
		end

		list.tip_label = "本人下注："..text
		table.insert(info.item_list,list)
	end
	global._view:history().Awake(this._const.GAME_ID_12ZHI,info)
end
--邀请
function ShierzhiRoomCtrl.OnInvite()
	-- ShierzhiRoomPanel.ReqRecord()
	if(this.IsGameRoom or this._isOpenTwo) then
		return
	end
	global.player:get_mgr("room"):req_invite_join_room(this._const.GAME_ID_12ZHI,this.RoomId)
end
--玩家列表
function ShierzhiRoomCtrl.OnPlayerList()
	if(this._curState ~= this._const.TWELVE_STATUS_OPEN) then
		ShierzhiRoomPanel.getPlayerList()
	else
		local str = i18n.TID_COMMON_STATISTC_DATA
		ShierzhiRoomPanel.setTip(str)
	end
end
function ShierzhiRoomCtrl.renderPlayer(list)
	global._view:playerList().Awake(list);
end
--关闭PlayerList界面
function ShierzhiRoomCtrl.closePlayerList()
	ShierzhiRoomPanel.playerList:SetActive(false)
	local len = #this._playerVec;
	for i=1,len do
		local data = this._playerVec[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data.prefab);
		end
	end
	this._playerVec = {}
end

function ShierzhiRoomCtrl.showAllPlayerPoint()
	-- this.onCloseCard()
	if(this._userBetVec ~= nil) then
    	local len = #this._userBetVec
		local isshow = false
    	for i=1,len do
    		local data = this._userBetVec[i]
    		local who = 0
			local name = data.betusers.player_name
			if(name == ShierzhiRoomPanel.getPlayerName()) then
				who = 1
				isshow = true
			end
    	end
		if(isshow) then
    		this.ShowBalance(this._userBetVec)
    	end
    	this._userBetVec = nil
    end
end
--显示结果
function ShierzhiRoomCtrl.ShowBalance(data)
	this._haveBalance = false
	this.closeShowUI()
	-- if (this._IsOpenGame and this._IsRoom)then
	-- 	return
	-- end
	this.showUIprefab("balanceInfo")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "balanceInfobar") then
			ShierzhiRoomPanel.balanceEnter:SetActive(true)
			this.closeBalanceList();
			this.PrefabBalance(data)
			this.Room:AddClick(this._uiPreant.transform:Find('sharebalance').gameObject, function ()
				if(this._haveBalance) then
					return
				end
				this._haveBalance = true
				local photo = this._uiPreant.transform:Find('sharebalance'):GetComponent('Photo')
				photo:startCut(function ()
					this._haveBalance = false
					photo:SaveCutImg();
					local files = photo:getCutImgPath()
					global.sdk_mgr:share(1,"",files,"12支")
				end)
			end);
		end
	end
end
function ShierzhiRoomCtrl.updateBalanceScore()
	if(this._startAnima == false) then
		return
	end
	if(this._playScore < 0.45) then
		this._playScore = this._playScore + Time.deltaTime
	else
		if(this.Speed <= 0.03) then
	        this.Speed = this.Speed + Time.deltaTime
	    else
	    	this.Speed = 0
	    	if(this._startScore < this._maxScore) then
	    		if(this._uiPreant ~= nil) then
	    			if(this._uiPreant.name == "balanceInfobar") then
	    				this._startScore = this._startScore + this.getScoreValue()
						local len = string.len(this._startScore)
						local str = ""
						for i=1,8 - len do
							str = str .. "0"
						end
						this._uiPreant.transform:Find('animscale/score'):GetComponent('UILabel').text = str .. this._startScore
	    			end
	    		end
			else
				this._startAnima = false
				local max = string.len(this._maxScore)
				local str = ""
					for i=1,8 - max do
						str = str .. "0"
					end
				if(this._uiPreant ~= nil) then
					this._uiPreant.transform:Find('animscale/score'):GetComponent('UILabel').text = str .. this._maxScore
				end
			end
	    end
	end
end
function ShierzhiRoomCtrl.getScoreValue()
	local max = this._startScore
	local flen = #this._finalVec
	local m = 1
	for i=1,flen do
		if(i > 1) then
			m = m * 10
		end
		if(this._scoreLen == i) then
			local comprare = this._finalVec[i]
			for j=flen,this._scoreLen + 1,-1 do
				max = max - this._finalVec[j] * this.getZeroNum(j)
			end
			if(max < tonumber(this._finalVec[i])*m) then
				return m
			else
				this._scoreLen = this._scoreLen - 1
				return this.getZeroNum(this._scoreLen)
			end
		end
	end
	return 1
end

function ShierzhiRoomCtrl.getZeroNum(len)
	local num = 1
	for i=1,len - 1 do
		num = num * 10
	end
	return num
end
function ShierzhiRoomCtrl.PrefabBalance(list)
	ShierzhiRoomPanel.balanceList_UIScrollView:ResetPosition()
	local bundle = resMgr:LoadBundle("balance_12zhi");
    local Prefab = resMgr:LoadBundleAsset(bundle,"balance_12zhi");
    local WinCoin = 0
    local len = #list
    for i=1,len do
    	local data = list[i]
    	local name = data.betusers.player_name
    	local coin = data.betusers.result_money
    	local go = GameObject.Instantiate(Prefab);
		go.name = "balance_12zhibar";
		go.transform.parent = ShierzhiRoomPanel.balanceList.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0,92 - (i - 1) * 78,0);
		resMgr:addAltas(go.transform,"ShierzhiRoom")
		local chess=go.transform:Find("Chess").gameObject;
		--local special = go.transform:Find('special').gameObject;
		local village = go.transform:Find('village').gameObject;
		if(i == 1) then
			--special:SetActive(true)
			village:SetActive(true)
			chess:SetActive(true);
			if (this.result_card~=nil)then
				local uisprite=this.result_card.transform:Find('DI/Sprite'):GetComponent("UISprite");
				local spriteName=uisprite.spriteName;
				local spriteColor=uisprite.color;
				local sprite=chess.transform:Find("Sprite"):GetComponent("UISprite");
				sprite.spriteName=spriteName;
				sprite.color=spriteColor;
				if spriteColor == Color.black then
					spriteColor = Color.red
				else
					spriteColor = Color.white
				end
				chess.transform:Find("quan"):GetComponent("UISprite").color=spriteColor;
			end

		else
			--special:SetActive(false)
			village:SetActive(false)
		end
		local freehome = go.transform:Find('freehome').gameObject;
		freehome:GetComponent('UILabel').text = GameData.GetShortName(name,6,6)
		local bscore = go.transform:Find('bscore').gameObject;
		bscore:GetComponent('UILabel').text = coin
    	if(name == ShierzhiRoomPanel.getPlayerName()) then
			WinCoin = coin
			if this._IsRoom == false then 
				if coin > 0 then 
					bscore:GetComponent('UILabel').text ="[FF0000FF]+"..coin
				else 
					bscore:GetComponent('UILabel').text ="[00FF17FF]"..coin
				end 
			end 
			freehome:GetComponent('UILabel').text ="[FFCA3CFF]"..GameData.GetShortName(name,6,6)
		end

		table.insert(this._balanceList,go)
    end
    if(WinCoin > 0) then --赢
    	this._startScore = 0
		this._maxScore = 0
		this._playScore = 0
		this._startAnima = true
		this._maxScore = WinCoin
		this.getScoreFinal()
		if(this._uiPreant ~= nil) then
			if(WinCoin > 100) then
				this._uiPreant.transform:Find('animscale/big').gameObject:SetActive(true)
				this._uiPreant.transform:Find('animscale/win').gameObject.transform.localPosition = Vector3(68,89,0)
			end
			this._uiPreant.transform:Find('animscale').gameObject:SetActive(true)
			this._uiPreant.transform:Find('animscale/score'):GetComponent('UILabel').text = "00000000"
			soundMgr:PlaySound("win")
		end
	else
		if(this._uiPreant ~= nil) then
			this._uiPreant.transform:Find('loseanima').gameObject:SetActive(true)
			soundMgr:PlaySound("lose")
		end
    end
    local pH = len * 78
	if(pH > 280) then
		ShierzhiRoomPanel.balanceCollider_UISprite.height = pH
	end
end
function ShierzhiRoomCtrl.closeBalanceList()
	local len = #this._balanceList;
	for i=1,len do
		local data = this._balanceList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._balanceList = {}
end
function ShierzhiRoomCtrl.getScoreFinal()
	this._finalVec = {}
	local len = string.len(this._maxScore)
	this._scoreLen = len
	for i=1,len do
		local value = string.sub(this._maxScore, -i,len - (i-1))
		table.insert(this._finalVec,value)
	end
end
--显示UI
function ShierzhiRoomCtrl.showUIprefab(name)
	ShierzhiRoomPanel.uibox:SetActive(true)
	local pane = name.."bar"
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == pane) then
			return
		end
	end
	local bundle = resMgr:LoadBundle(name);
    local Prefab = resMgr:LoadBundleAsset(bundle,name);
    this._uiPreant = GameObject.Instantiate(Prefab);
	this._uiPreant.name = name .. "bar";
	this._uiPreant.transform.parent = ShierzhiRoomPanel.showUI.transform;
	this._uiPreant.transform.localScale = Vector3.one;
	this._uiPreant.transform.localPosition = Vector3.zero;
	resMgr:addAltas(this._uiPreant.transform,"Room")--暂时先用room的图集
end
--下庄按钮
function this.LoseRobOnclick()
	if (this._curState ~= this._const.TWELVE_STATUS_FREE)then
		return
	end
	if (this._IsRoom==false)then
		return
	end
	if (this._isOpenTwo)then
		return
	end
	if (this.loseRob)then
		return
	end
	local str=i18n.TID_COMMON_GIVEUP_BANKER
	local support=global._view:support();
	support.Awake(str,function()
		ShierzhiRoomPanel.LoseRobOnclick(function()
		--    this.loseRob=true
		--    ShierzhiRoomPanel.loseRob_Btn_Sprite.color=Color.gray;
		end)
	end,
	function()

	end)
end
function this.LoseRobCallBack(data)
   this.loseRob=true
   ShierzhiRoomPanel.loseRob_Btn_Sprite.color=Color.gray;
   ShierzhiRoomPanel.loseRob_Btn:SetActive(false)
end
--跟新模式，局数
function this.UpdateTypeAndBout(data)
	if this._isOpenTwo then
		ShierzhiRoomPanel.pattern_group_1.gameObject:SetActive(false)
		ShierzhiRoomPanel.pattern_group_2.gameObject:SetActive(true)
		local str = "第%s期"
		local text = string.format(str,1)--todo
		if data.bout then
			text = string.format(str,data.bout)--todo
		end
		ShierzhiRoomPanel.pattern_periods_Label.text = text

	else
		ShierzhiRoomPanel.pattern_group_1.gameObject:SetActive(true)
		ShierzhiRoomPanel.pattern_group_2.gameObject:SetActive(false)
		if (this.play_type==1)then
			ShierzhiRoomPanel.pattern_type_Label.text="自由模式"
			if data.bout then
				ShierzhiRoomPanel.pattern_number_Label.text=data.bout
			else
				ShierzhiRoomPanel.pattern_number_Label.text="-"
			end
			ShierzhiRoomPanel.pattern_sumNumber_Label.text="-"
		elseif(this.play_type==2)then
			ShierzhiRoomPanel.pattern_type_Label.text="抢庄模式"
			if(data.bout_amount~=nil)then
				ShierzhiRoomPanel.pattern_sumNumber_Label.text=data.bout_amount
			end
			if (data.bout~=nil)then
				ShierzhiRoomPanel.pattern_number_Label.text=data.bout
			end
		end
	end
end

function this.ShadeTimeController()
	if this.shade_timer > 0 then
		this.shade_timer = this.shade_timer - Time.deltaTime
		if this.shade_timer <=0 then
			this.ShadeOnTimer(this.shade_status)
		end
	end
end

function this.ShadeOnTimer(status)
	if status == SHADE_STATUS_PLAY then
		this.shade_status =SHADE_STATUS_NEXT
		this.shade_timer = SHADE_TIME_NEXT
		this.OwnerShadeNextAnima()
	elseif status == SHADE_STATUS_NEXT then
		this.shade_status =SHADE_STATUS_FALL
		this.shade_timer = SHADE_TIME_FALL
		this.ResetOwnerPanelAndPlayNextAnima()
	elseif status == SHADE_STATUS_FALL then
	end
end
function this.ClearBetPrefab()

	if (#BetAminaPrefab>0)then
		local len =#BetAminaPrefab
		for i=1,len do
		 panelMgr:ClearPrefab(BetAminaPrefab[i]);
		end
		BetAminaPrefab={}
	end

end
--返回
function ShierzhiRoomCtrl.OnBack(go)
	local str =i18n.TID_COMMON_BACK_GAME
	global._view:support().Awake(str,function ()
		soundMgr:PlaySound("go")
		ShierzhiRoomPanel.backShierzhi(this.IsGameRoom)
	   end,function ()

   	end);
	
end
--关闭事件--
function ShierzhiRoomCtrl.Close()

	--this._userBetVec = nil
	this.boxid=1;
	this.result_card=nil;
	this._isOpenTwo=false;
	this.historyID=0;
	this.loseRob=false;
	this.play_type=nil
	this._IsOpenGame=false;
	this.houseChessSelectToNet=nil;
	this._isdaoban=nil
	this.startPos=nil
	this.up_history_list=nil --更新历史记录上移

	this.last_state = nil
	this.red_bet_list = nil
	this.ClearBetPrefab();

	this.is_net_update_bet=nil
	this.clearBigShow()
	this.closeShowUI()
	UpdateBeat:Remove(this.timeEvent, this)
	panelMgr:ClosePanel(CtrlNames.ShierzhiRoom);
	this.ClearAllChess();
	this.ClearBetMessage();
	this.ResetShade();
end
return ShierzhiRoomCtrl