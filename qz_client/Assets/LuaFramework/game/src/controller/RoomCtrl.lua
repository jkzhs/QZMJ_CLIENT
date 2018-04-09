require "logic/ViewManager"
local global = require("global")
local i18n = global.i18n
RoomCtrl = {};
local this = RoomCtrl;

RoomCtrl.panel = nil;
RoomCtrl.Room = nil;
RoomCtrl.transform = nil;
RoomCtrl.gameObject = nil;
RoomCtrl.RoomId = 0

local CAN_PAUSE =global._view.CAN_PAUSE --更换CS文件后可以设置为true

--构建函数--
function RoomCtrl.New()
	return this;
end

RoomCtrl.IsGameRoom = false
RoomCtrl.RoomTitle = ""
function RoomCtrl.Awake(roomId,value,title)
	this.RoomId = roomId;
	this.IsGameRoom = value
	this.RoomTitle = title
	panelMgr:CreatePanel('Room', this.OnCreate);
end

RoomCtrl.isStartViedo = false
RoomCtrl.StartViedoTime = 0
RoomCtrl.pressPoint = nil
RoomCtrl.viedodist = 0
function RoomCtrl.OnViedo(go,isPress)
	if(isPress) then
		if(this.StartViedoTime < 8) then
			this.startRecord()
		else
			RoomPanel.viedo_VoiceChatPlayer:getSendAllData()
		end
	else
		RoomPanel.viedo_VoiceChatPlayer:getSendAllData()
		-- this.stopRecord()
		-- if(this.StartViedoTime < 0.1) then
		-- 	RoomPanel.setTip("您说话太快了")
		-- 	return
		-- end
		-- if(this.viedodist < 50) then
		-- 	this.sendChatData()
		-- end
	end
end

function RoomCtrl.sendChatData(chatData)
	-- local chatData = RoomPanel.viedo_MicroPhoneInput:GetClipData()
	-- local chatData = RoomPanel.viedo_VoiceChatPlayer:getSendAllData()
	RoomPanel.sendChat(chatData,1,this.StartViedoTime)
	this.StartViedoTime = 0
	-- local d={coin = 0,
	-- 	player_name = RoomPanel.getPlayerName(),
	-- 	amount_money = 0,
	-- 	content = chatData,
	-- 	url = RoomPanel.getPlayerImg(),
	-- 	viedo = true,
	-- 	viedoTime = this.StartViedoTime,
	-- }
	-- this.StartViedoTime = 0
	-- this.addPlayerBetInfo(d,1)
end

function RoomCtrl.startRecord()
	-- RoomPanel.viedo_VoiceChatPlayer:StartRecording()
	if(this.isStartViedo) then
		return
	end
	RoomPanel.viedo_VoiceChatPlayer:StopRecording()
    RoomPanel.viedo_VoiceChatPlayer:StartRecording()
	this.isStartViedo = true;
	this.StartViedoTime = 0
	this.pressPoint = Input.mousePosition;
	this.viedodist = 0
	this.viedoIndex = 4
	RoomPanel.record:SetActive(true)
	RoomPanel.recard1:SetActive(true)
	RoomPanel.recard2:SetActive(true)
	RoomPanel.recard3:SetActive(true)
	RoomPanel.recard4:SetActive(true)
	this.pauseMusic()
end

RoomCtrl.IsFuncOpen = false
function RoomCtrl.stopRecord(chatData)
	this.animaTime = 0
	this.isStartViedo = false;
	RoomPanel.record:SetActive(false)
	this.PlayBGSound()
	if(this.StartViedoTime < 0.2) then
		RoomPanel.setTip("您说话太快了")
		return
	end
	if(this.viedodist < 50) then
		this.sendChatData(chatData)
	end
end

function RoomCtrl.updateViedo()
	if(this.isStartViedo) then
		this.StartViedoTime = this.StartViedoTime + Time.deltaTime
		this.animaTime = this.animaTime + Time.deltaTime
		RoomPanel.recordProcess_UISprite.fillAmount = 1 - this.StartViedoTime / 7
		if(this.StartViedoTime >= 8) then
			this.StartViedoTime = 8
			this.isStartViedo = false
			RoomPanel.viedo_VoiceChatPlayer:getSendAllData()
		end
		local inputPoint = Input.mousePosition;
	    this.viedodist = this.Room:Distance(this.pressPoint.x, this.pressPoint.y, this.pressPoint.z,
	                               inputPoint.x, inputPoint.y, inputPoint.z)
	    if(this.animaTime >= 0.2) then
	    	this.animaTime = 0
	    	this.playViedoAnima()
	    end
	end
end

RoomCtrl.animaTime = 0
RoomCtrl.viedoIndex = 4
RoomCtrl.allRecard = {}
function RoomCtrl.playViedoAnima()
	if(this.viedoIndex > 4) then
		this.viedoIndex = 1
		RoomPanel.recard1:SetActive(false)
		RoomPanel.recard2:SetActive(false)
		RoomPanel.recard3:SetActive(false)
		RoomPanel.recard4:SetActive(false)
	end
	this.allRecard[this.viedoIndex]:SetActive(true)
	this.viedoIndex = this.viedoIndex + 1
end

--启动事件--
function RoomCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.panel = this.transform:GetComponent('UIPanel');
	this.Room = this.transform:GetComponent('LuaBehaviour');
	this.Room:AddOnPress(RoomPanel.btnFilling, this.OnFilling);
	-- this.Room:AddOnPress(RoomPanel.Roller, this.OnRoller);
	this.Room:AddClick(RoomPanel.back, this.OnBack);
	this.Room:AddClick(RoomPanel.rob, this.OnRob);
	this.Room:AddClick(RoomPanel.cardback, this.onCloseCard);
	this.Room:AddClick(RoomPanel.playlist, this.OnPlayerList);
	--this.Room:AddClick(RoomPanel.closePlayer, this.closePlayerList);
	this.Room:AddClick(RoomPanel.chat, this.OnSay);
	this.Room:AddClick(RoomPanel.express, this.OnExpression);
	this.Room:AddClick(RoomPanel.share, this.OnShare);
	this.Room:AddOnPress(RoomPanel.viedo, this.OnViedo);
	this.Room:AddClick(RoomPanel.invite, this.OnInvite);
	this.Room:AddClick(RoomPanel.rule, function ()
		global._view:rule().Awake(global.const.GAME_ID_NIUNIU)
	end);
	this.Room:AddClick(RoomPanel.bank, function ()
		global._view:bank().Awake()
	end);
	this.Room:AddClick(RoomPanel.closeshare, this.CloseShare);
	this.Room:AddOnPress(RoomPanel.playcard, this.playAnima);
	this.Room:AddClick(RoomPanel.uibox, this.closeShowUI);
	this.Room:AddClick(RoomPanel.backOut, function ()
		global._view:support().Awake("您确定要放弃坐庄？",function ()
       		RoomPanel.DropBanker()
		   end,function ()

       	end);
	end);
	this.Room:AddClick(RoomPanel.betfive, this.OnBetBtn);
	this.Room:AddClick(RoomPanel.betten, this.OnBetBtn);
	this.Room:AddClick(RoomPanel.bethund, this.OnBetBtn);
	this.Room:AddClick(RoomPanel.betkilo, this.OnBetBtn);
	this.Room:AddClick(RoomPanel.bettenshou, this.OnBetBtn);
	this.Room:AddClick(RoomPanel.betmill, this.OnBetBtn);
	this.Room:AddClick(RoomPanel.betall, this.OnBetBtn);
	this.Room:AddClick(RoomPanel.btnDel, function (go)
		if(this._curState ~= this._const.OX_STATUS_BET) then
			return
		end
		if(this._IsRoom) then
			return
		end
		this._allBetCoin = 0
		RoomPanel.betNum_UILabel.text = 0
	end);
	this.loadAllAltas()
	this.allRecard = {RoomPanel.recard1,RoomPanel.recard2,RoomPanel.recard3,
	RoomPanel.recard4}
	RoomPanel.viedo_VoiceChatPlayer.onSendVoice = function(sendLen,SendData)
		if sendLen == 0 then
	        -- RoomPanel.setTip("请在【设置-隐私-麦克风】选项中，\n允许访问麦克风。");
	        this.animaTime = 0
	        this.StartViedoTime = 0
			this.isStartViedo = false;
			RoomPanel.record:SetActive(false)
			this.PlayBGSound()
			RoomPanel.viedo_VoiceChatPlayer:StopRecording()
	        return
	    end
	    this.stopRecord(SendData)
	    RoomPanel.viedo_VoiceChatPlayer:StopRecording()
    end
    --commit voice
    RoomPanel.viedo_VoiceChatPlayer.onCommitVoice = function ()
    	RoomPanel.viedo_VoiceChatPlayer:getSendAllData()
    end
    if(this.IsGameRoom) then
    	RoomPanel.invite_UISprite.color = Color.gray
    	RoomPanel.invitefabu_UISprite.color = Color.gray
    	RoomPanel.inviteyaoqing_UISprite.color = Color.gray
    end
    UpdateBeat:Add(this.timeEvent, this)

    if global.player:get_paytype()  == 1 then
		RoomPanel.bank:SetActive(false)
		RoomPanel.share:SetActive(false)
    end
end

function RoomCtrl.BetBtnColor(color)
	RoomPanel.betfive_UISprite.color = color
	RoomPanel.betten_UISprite.color = color
	RoomPanel.bethund_UISprite.color = color
	RoomPanel.betkilo_UISprite.color = color
	RoomPanel.bettenshou_UISprite.color = color
	RoomPanel.betmill_UISprite.color = color
	RoomPanel.betall_UISprite.color = color
	RoomPanel.btnFilling_UISprite.color = color
	RoomPanel.btnDel_UISprite.color = color
end

RoomCtrl._allBetCoin = 0
RoomCtrl._totalBetCoin = 0
RoomCtrl._IsAllBet = false
function RoomCtrl.OnBetBtn(go)
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.OX_STATUS_BET) then
		return
	end
	if(this._allBetCoin == this._PlayermaxCoin * 10) then
		this._allBetCoin = 0
	end
	if(this._IsRoom) then
		return
	end
	if(this._totalBetCoin >= this._PlayermaxCoin) then
		return
	end
	this._IsAllBet = false
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
	elseif(go.name == "betall") then --梭哈
		if(this._totalBetCoin == 0) then
			coin = 0
			this._allBetCoin = this._PlayermaxCoin * 10
			if(this._playerCoin < this._PlayermaxCoin * 10) then
				this._allBetCoin = this._playerCoin
			end
			this._IsAllBet = true
		else
			return
		end
	end
	local max = this._allBetCoin + coin
	if(max > this._PlayermaxCoin - this._totalBetCoin and go.name ~= "betall") then
		RoomPanel.setTip("已达到当局最大下注")
		return
	end
	if(max > this._playerCoin) then
		RoomPanel.setTip("钱不够咯")
		return
	end
	this._allBetCoin = this._allBetCoin + coin
	RoomPanel.betNum_UILabel.text = this._allBetCoin
end

function RoomCtrl.OnInvite()
	if(this.IsGameRoom) then
		return
	end
	global.player:get_mgr("room"):req_invite_join_room(this._const.GAME_ID_NIUNIU,this.RoomId)
end

function RoomCtrl.closeShowUI()
	if(this._uiPreant ~= nil) then
		panelMgr:ClearPrefab(this._uiPreant);
		this._uiPreant = nil;
	end
	this.closeBalanceList()
	RoomPanel.uibox:SetActive(false)
	RoomPanel.expression:SetActive(false)
	RoomPanel.saydialog:SetActive(false)
	RoomPanel.balanceEnter:SetActive(false)
end

function RoomCtrl.timeEvent()
	this.FreeTimeEvent()
	this.updateAnima()
	this.dealCardTime()
	this.CardAnima()
	this.FristHandle()
	this.updateBomb()
	this.updateBalanceScore()
	this.updateViedo()
	this.startSayAnima()
end

RoomCtrl._autoCard = false;
RoomCtrl._FreeTime = 0;
function RoomCtrl.FreeTimeEvent()
  	if(this._FreeTime > 0) then
        local time = this._FreeTime - RoomPanel.getTime()
        if(time >= 0) then
        	local hours = math.floor(time / 3600);
			time = time - hours * 3600;
			local minute = math.floor(time / 60);
			time = time - minute * 60;
			if(time <= 5 and this._curState == this._const.OX_STATUS_OPEN) then
				if(#this.cardList > 0 and this.IsopenCard == false and this._autoCard == false) then
					this.IsopenCard = true
					this._autoCard = true
					if(time > 0 and time < 5) then
						this.roll = 31
					end
				end
			end
            RoomPanel.timeTxt_UILabel.text = GameData.changeFoLimitTime(time);
        else
            this._FreeTime = 0;
            RoomPanel.timeTxt_UILabel.text = 0
        end
    end
end

function RoomCtrl.showAllPlayerPoint()
	-- this.onCloseCard()
	if(this._userBetVec ~= nil) then
    	local len = #this._userBetVec
    	local isshow = false
    	for i=1,len do
    		local data = this._userBetVec[i]
    		local who = 0
			local name = data.betusers.player_name
			if(name == RoomPanel.getPlayerName()) then
				who = 1
				isshow = true
			end
    		if(data.Isopen == 0) then
				if(data.betusers.cards ~= "") then
					local IsBanker = ""
					if(data.betusers.playerid == this._bankerId) then
						IsBanker = "【庄家】"
					end
					local card = string.split(data.betusers.cards, ",")
	        		local info = IsBanker..this.getUserPointValue(card,"")
	        		local imgurl = data.betusers.headimgurl
	    --     		if(isshow) then
					-- 	imgurl = RoomPanel.getPlayerImg()
					-- end
	        		local d={coin = 0,
						player_name = name,
						amount_money = 0,
						content = info,
						url = imgurl,
						viedo = false,
						viedoTime = 0,
						IsCard = card,
						IsBank = IsBanker,
					}
					this.addPlayerBetInfo(d,who)
				end
    		end
    	end
    	if(isshow) then
    		this.ShowBalance(this._userBetVec)
    	end
    	this._userBetVec = nil
    end
end

function RoomCtrl.getPlayerCardInfo(cards)
	local cardStr = ""
	for i=1,5 do
		if(i == 5) then
			cardStr = cardStr .. cards[i]
		else
			cardStr = cardStr .. cards[i] .. "-"
		end
	end
	return cardStr
end

function RoomCtrl.getUserPointValue(cards,wrap)
	local str = ""
	local cardStr = ""
	local len = #cards
	local Ptype = tonumber(cards[len])
	local point = tonumber(cards[len - 1])
	if(wrap ~= "") then
		cardStr = "(" .. this.getPlayerCardInfo(cards) .. ")"
	end
	if(Ptype == this._const.OX_VALUE_TYPE_NONE) then -- 非特殊牌
		str = this.numToBig(point,wrap) .. wrap .. cardStr
	elseif(Ptype == this._const.OX_VALUE_TYPE_3) then -- 牛牛
		str = "[b75f10]牛牛" .. wrap .. cardStr
	elseif(Ptype == this._const.OX_VALUE_TYPE_2) then -- 顺子
		str = "[b75f10]顺子" .. wrap .. cardStr
	elseif(Ptype == this._const.OX_VALUE_TYPE_1) then -- 炸弹
		str = "[b75f10]炸弹" .. wrap .. cardStr
	end
	return str
end

function RoomCtrl.numToBig(num,wrap)
	local str = ""
	local color = "[000000]"
	if(wrap ~= "") then
		color = "[ffffff]"
	end
	if(num == 0) then
		str = color.."无牛"
	elseif(num == 1) then
		str = color.."牛一"
	elseif(num == 2) then
		str = color.."牛二"
	elseif(num == 3) then
		str = color.."牛三"
	elseif(num == 4) then
		str = color.."牛四"
	elseif(num == 5) then
		str = color.."牛五"
	elseif(num == 6) then
		str = "[b75f10]牛六"
	elseif(num == 7) then
		str = "[b75f10]牛七"
	elseif(num == 8) then
		str = "[b75f10]牛八"
	elseif(num == 9) then
		str = "[b75f10]牛九"
	end
	return str
end

-- RoomCtrl._IsPress = false
-- function RoomCtrl.updateMouse()
-- 	if(this._IsPress) then
-- 		local inputPoint = Input.mousePosition;
-- 	    local dist = this.Room:Distance(this.pressPoint.x, this.pressPoint.y, this.pressPoint.z,
-- 	                               inputPoint.x, inputPoint.y, inputPoint.z)
-- 	    if(this.pressPoint.x > inputPoint.x) then
-- 	    	dist = -dist
-- 	    end
-- 	    local pos = this.startPoint + dist*GameData.getMoveRota()
-- 	    if(pos <= 95 and pos >= -95) then
-- 	    	RoomPanel.Roller.transform.localPosition = Vector3(pos, 0, 0);
-- 	    	RoomPanel.betNum_UILabel.text = this._betCoin + math.floor(this._playerCoin / 190 * dist)
-- 	    elseif(pos > 95) then
-- 	    	RoomPanel.Roller.transform.localPosition = Vector3(95, 0, 0);
-- 	    	RoomPanel.betNum_UILabel.text = this._playerCoin
-- 	    elseif(pos < -95) then
-- 	    	RoomPanel.Roller.transform.localPosition = Vector3(-95, 0, 0);
-- 	    	RoomPanel.betNum_UILabel.text = 0
-- 	    end
-- 	end
-- end

RoomCtrl._lookVec = {}
function RoomCtrl.OnExpression()
	RoomPanel.uibox:SetActive(true)
	RoomPanel.expression:SetActive(true)
	if(#this._lookVec > 0) then
		return
	end
	local lookExpression = {}
	for i=1,30 do
		local name = "biaoqing_" .. (i - 1)
		table.insert(lookExpression,name)
	end
	local parent = RoomPanel.expressionlist.transform;
    local bundle = resMgr:LoadBundle("lookIcon");
    local Prefab = resMgr:LoadBundleAsset(bundle,"lookIcon");
    local startX = -77
    local startY = 190
    local space = 98
    local height = 77
    local column = 5;
	local len = #lookExpression;
	for i = 1, len do
		local data = lookExpression[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "lookIcon"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(startX + space * ((i - 1) % column), startY - math.floor((i - 1) / column) * height, 0);
		resMgr:addAltas(go.transform,"Room")
		local expreIcon = go.transform:Find('expreIcon').gameObject
		expreIcon.name = "expreIcon" .. i
		local expreIcon_UISprite = expreIcon:GetComponent('UISprite');
		expreIcon_UISprite.spriteName = data
		expreIcon_UISprite:MakePixelPerfect();
		expreIcon.transform.localScale = Vector3(1,1,1)
		this.Room:AddClick(expreIcon, function ()
			RoomPanel.sendChat(data)
			RoomPanel.uibox:SetActive(false)
			RoomPanel.expression:SetActive(false)
		end);
		table.insert(this._lookVec,go)
	end
end

function RoomCtrl.closeLookList()
	local len = #this._lookVec;
	for i=1,len do
		local data = this._lookVec[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._lookVec = {}
end

RoomCtrl._sayVec = {}
function RoomCtrl.OnSay()
	RoomPanel.uibox:SetActive(true)
	RoomPanel.saydialog:SetActive(true)
	if(#this._sayVec > 0) then
		return
	end
	local sayContent = {"双击666。","扎心了老铁。","厉害了我的哥。","一言不合就好牌。",
	"明明可以靠脸吃饭，偏偏要靠才华","人生就像一场戏，输赢不用在意。","下得多赢得多。",
	"快点啊，都等到我花儿都谢谢了！","怎么又断线了，网络怎么这么差啊！",
	"不要走，决战到天亮！","你的牌打得也太好了！","和你合作真是太愉快了！",
	"大家好，很高兴见到各位！","各位，真是不好意思，我得离开一会儿。","不要吵了，专心玩游戏吧！"}
	local parent = RoomPanel.saylist.transform;
    local bundle = resMgr:LoadBundle("sayBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"sayBar");
    local startY = 220
    local height = 0
	local len = #sayContent;
	for i = 1, len do
		local data = sayContent[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "sayBar"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(-117, startY - height, 0);
		resMgr:addAltas(go.transform,"Room")
		local saytxt = go.transform:Find('saytxt').gameObject;
		saytxt.name = "saytxt" .. i
		local saytxt_UILabel = saytxt:GetComponent('UILabel');
		this.Room:AddClick(saytxt, function ()
			RoomPanel.sendChat(data)
			RoomPanel.uibox:SetActive(false)
			RoomPanel.saydialog:SetActive(false)
		end);
		saytxt_UILabel.text = data
		local ph = saytxt_UILabel.height
		height = height + ph + 10
		table.insert(this._sayVec,go)
	end
	RoomPanel.sayCollider_UISprite.height = height
end

function RoomCtrl.closeSayList()
	local len = #this._sayVec;
	for i=1,len do
		local data = this._sayVec[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._sayVec = {}
end

function RoomCtrl.OnShare()
	-- local card = string.split("3,2,2,1,10,10", ",")
	-- this.renderFunc(card)
	this.showUIprefab("shareUI")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "shareUIbar") then
			local sharefriend = this._uiPreant.transform:Find('sharefriend').gameObject;
			this.Room:AddClick(sharefriend, function ()
				local desc = "同时200人在线牛牛,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "牛牛[房号:" .. this.RoomId .. "]"
				if(this.IsGameRoom) then
					desc = "同时200人在线牛牛,您的好友邀请您进入游戏"
					title = "牛牛[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(1,desc,"",title)

			end);
			local shareall = this._uiPreant.transform:Find('shareall').gameObject;
			this.Room:AddClick(shareall, function ()
				local desc = "同时200人在线牛牛,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "牛牛[房号:" .. this.RoomId .. "]"
				if(this.IsGameRoom) then
					desc = "同时200人在线牛牛,您的好友邀请您进入游戏"
					title = "牛牛[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(0,desc,"",title)
			end);
		end
	end
end

function RoomCtrl.OnPlayerList()
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.OX_STATUS_OPEN) then
		RoomPanel.getPlayerList()
	else
		local str = i18n.TID_COMMON_STATISTC_DATA
		RoomPanel.setTip(str)
	end
end

-- RoomCtrl._playerVec = {}
function RoomCtrl.renderPlayer(list)
	global._view:playerList().Awake(list);
	--[[
	local parent = RoomPanel.allplayerInfo.transform;
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
		resMgr:addAltas(go.transform,"Room")
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
	RoomPanel.playerNum_UILabel.text = len
	RoomPanel.playerList:SetActive(true)
	local pH = len * space
	if(pH > 505) then
		RoomPanel.playerCollider_UISprite.height = pH
	end
	this.loadPlayerIcon()
	]]
end
--[[单独出去了
function RoomCtrl.loadPlayerIcon()
	local len = #this._playerVec;
	for i=1,len do
		local go = this._playerVec[i]
		if(go ~= nil) then
			local img = go.prefab.transform:Find('playerImage');
			local img_AsyncImageDownload = img:GetComponent('AsyncImageDownload');
			img_AsyncImageDownload:SetAsyncImage(go.data.headimgurl);
		end
	end
end

function RoomCtrl.closePlayerList()
	RoomPanel.playerList:SetActive(false)
	local len = #this._playerVec;
	for i=1,len do
		local data = this._playerVec[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data.prefab);
		end
	end
	this._playerVec = {}
end
]]

RoomCtrl._uiPreant = nil
RoomCtrl._uiname = ""
RoomCtrl._robBet = 1
function RoomCtrl.OnRob(go)
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.OX_STATUS_BANKER) then
		this._robData = nil
		return
	end
	if(this._robData == nil) then
		RoomPanel.getRobInfo()
	else
		this.robCallBack(this._robData)
	end
end

RoomCtrl._robData = nil
function RoomCtrl.robCallBack(data)
	if(this._curState == this._const.OX_STATUS_BANKER) then --抢庄
		this.showUIprefab("robUI")
		if(this._uiPreant ~= nil) then
			if(this._uiPreant.name == "robUIbar") then
				this._robData = data
				local robOk = this._uiPreant.transform:Find('robOk').gameObject;
				this.Room:AddClick(robOk, function ()
					if(this._robBet == 0) then
						RoomPanel.setTip("抢庄金额不能低于1")
						return
					end
					RoomPanel.robData(this._robBet)
				end);
				-- local minInput = this._uiPreant.transform:Find('minInput').gameObject;
				-- local minInput_UIInput = minInput:GetComponent('UILabel');
				local minscore = tonumber(data.banker_min_coin)
				local maxscore = tonumber(data.player_max_coin)
				if(data.player_max_coin == "") then
					maxscore = 0
				end
				if(data.banker_min_coin == "") then
					minscore = 0
				end
				-- minInput_UIInput.text = minscore
				this._uiPreant.transform:Find('allInput'):GetComponent('UILabel').text = maxscore * 10
				local text =  string.format(i18n.TID_BANKER_INFO,minscore,maxscore)
				this._uiPreant.transform:Find('hint'):GetComponent('UILabel').text =text
				-- "提示：庄家最低"..minscore.."分以上才能抢庄设置玩家最高不能超过" .. maxscore
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
			end
		end
	end
end

function RoomCtrl.showUIprefab(name)
	RoomPanel.uibox:SetActive(true)
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
	this._uiPreant.transform.parent = RoomPanel.showUI.transform;
	this._uiPreant.transform.localScale = Vector3.one;
	this._uiPreant.transform.localPosition = Vector3.zero;
	resMgr:addAltas(this._uiPreant.transform,"Room")
end

function RoomCtrl.OnFilling(go,isPress)
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.OX_STATUS_BET) then
		return
	end
	if(isPress) then
	else
		if(this._IsRoom) then
			return
		end
		local value = tonumber(RoomPanel.betNum_UILabel.text)
		if(value > 0) then
			if(this._IsAllBet) then
				RoomPanel.betData(this._allBetCoin,1);
			else
				RoomPanel.betData(this._allBetCoin,0);
			end
		end
	end
end

-- RoomCtrl.pressPoint = nil
-- RoomCtrl.startPoint = 0
-- function RoomCtrl.OnRoller(go,isPress)
-- 	if(this._curState == this._const.OX_STATUS_BET) then --下注时间
-- 		this._IsPress = isPress;
-- 		this.startPoint = RoomPanel.Roller.transform.localPosition.x
-- 		this.pressPoint = Input.mousePosition
-- 		if(isPress == false) then
-- 			this._betCoin = RoomPanel.betNum_UILabel.text
-- 		end
-- 	else
-- 		if(isPress == false) then
-- 			RoomPanel.setTip("下注时间才能设置")
-- 		end
-- 	end
-- end

function RoomCtrl.OnBack(go)
	local str =i18n.TID_COMMON_BACK_GAME
	global._view:support().Awake(str,function ()
       	soundMgr:PlaySound("go")
		RoomPanel.backNiuniu(this.IsGameRoom)
	   end,function ()

   	end);
end

RoomCtrl._bigshow = nil
function RoomCtrl.ShowBigTime(isdaoban)
	local bundle = resMgr:LoadBundle("bigshow");
	local Prefab = resMgr:LoadBundleAsset(bundle,"bigshow");
	this._bigshow = GameObject.Instantiate(Prefab);
	this._bigshow.name = "bigshowbar";
	this._bigshow.transform.parent = RoomPanel.Tips.transform;
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
	if (isdaoban) then 
		loseRob:SetActive(true)
		showtip.gameObject:SetActive(false)
	end 
	if (this._IsLiuju == 1) then
		liuju:SetActive(true)
		return
	end
	
	if(this._curState == this._const.OX_STATUS_BANKER) then
		prob:SetActive(true)
	elseif(this._curState == this._const.OX_STATUS_BET) then
		pbet:SetActive(true)
	elseif(this._curState == this._const.OX_STATUS_OPEN) then
		popen:SetActive(true)
	end
end

function RoomCtrl.clearBigShow()
	if(this._bigshow ~= nil) then
		panelMgr:ClearPrefab(this._bigshow);
	end
	this._bigshow = nil
end

RoomCtrl._const = nil
RoomCtrl._cards = ""
RoomCtrl._curState = 0
RoomCtrl._playerCoin = 0
RoomCtrl._betCoin = 0
RoomCtrl._IsOpenGame = false
RoomCtrl._RoomCreate = ""
function RoomCtrl.Init(data,const,liuju,daobang)
	this._const = const
	this._RoomCreate = data.house_owner_name
	if(this.IsGameRoom == false) then
		RoomPanel.roomId_UILabel.text = "房主:" .. GameData.GetShortName(this._RoomCreate,26,20) .. "\n房间号:" .. this.RoomId
	else
		RoomPanel.roomId_UILabel.text = this.RoomTitle
	end
	RoomPanel.PlayerIcon_AsyncImageDownload:SetAsyncImage(RoomPanel.getPlayerImg())
	if(data.game_status ~= this._const.OX_STATUS_FREE) then
		this._IsOpenGame = true
		RoomPanel.fristenter:SetActive(true)
		if data.game_status == this._const.OX_STATUS_BET then
			if data.banker_name == RoomPanel.getPlayerName() then
				this._IsOpenGame = false
				RoomPanel.fristenter:SetActive(false)
			end
		end
	end
	if(data.game_status ~= this._const.OX_STATUS_OPEN) then
		this.updateBetState(data,liuju,daobang)
	else
		RoomPanel.backOut:SetActive(false)
		RoomPanel.rob:SetActive(true)
		RoomPanel.robHead:SetActive(false)
		this._FreeTime = data.over_time
		this._curState = data.game_status
		this.updatePlayerInfo()
		-- local len = #data.bet_users
		-- if(len > 0) then
		-- 	local bankerInfo = data.bet_users[1]
		-- 	RoomPanel.rob:SetActive(false)
		-- 	RoomPanel.robHead:SetActive(true)
		-- 	RoomPanel.robHead_AsyncImageDownload:SetAsyncImage(bankerInfo.cards)
		-- 	RoomPanel.bankerName_UILabel.text = "庄家:" .. GameData.GetShortName(bankerInfo.player_name,14,14) .. "\n单人最高下注:" .. bankerInfo.result_money
		-- end
		RoomPanel.BetState_UILabel.text = "请开牌"
	end
end

RoomCtrl.tarPos = {-360,-120,120,360,0}
RoomCtrl._IsRoom = false
RoomCtrl._bankerPoint = 0
RoomCtrl._PlayermaxCoin = 0
RoomCtrl._IsLiuju = 0
function RoomCtrl.updateBetState(data,liuju,daobang)
	if(this._const == nil) then
		return
	end 
	this._FreeTime = data.over_time
	this._IsRoom = false
	this._curState = data.game_status
	local bet = ""
	RoomPanel.playerPoint_UILabel.text = ""
	RoomPanel.playerPoint:SetActive(false)
	RoomPanel.tiprob:SetActive(false)
	-- RoomPanel.tipbet:SetActive(false)
	RoomPanel.rob_UISprite.color = Color.gray
	RoomPanel.robBg_UISprite.color = Color.gray
	RoomPanel.robEffect:SetActive(false)
	this.BetBtnColor(Color.gray)
	this.clearBigShow()
	this._IsLiuju = 0
	this._robData = nil
	RoomPanel.backOut:SetActive(false)
	RoomPanel.rob:SetActive(true)
	RoomPanel.robHead:SetActive(false)
	this.onCloseCard()
	if(this._curState == this._const.OX_STATUS_FREE) then --空闲时间
		if(data.banker_playerid == RoomPanel.getPlayerId()) then --自己是不是庄家
			this._IsRoom = true
		end
		this._IsLiuju = liuju
		if(this._IsLiuju == 1) then
			soundMgr:PlaySound("liuju")
			this.ShowBigTime(false)
		end
		if(daobang) then
			this.ShowBigTime(daobang)
		end
		this.showAllPlayerPoint()
		this.updatePlayerInfo()
		if(this._uiPreant ~= nil) then
			if(this._uiPreant.name == "robUIbar") then
				this.closeShowUI()
			end
		end
		if(this._IsRoom) then
			RoomPanel.backOut:SetActive(true)
		end
		this._totalBetCoin = 0
		this._PlayermaxCoin = 0
		this._IsOpenGame = false
		RoomPanel.fristenter:SetActive(false)
		RoomPanel.bankerName_UILabel.text = "庄家:无\n单人最高下注:0"
		RoomPanel.betNum_UILabel.text = 0
		this._allBetCoin = 0;
		if(data.banker_name ~= nil and data.banker_name ~= "") then
			RoomPanel.rob:SetActive(false)
			RoomPanel.robHead:SetActive(true)
			RoomPanel.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
			local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n单人最高下注:" .. this._PlayermaxCoin
			RoomPanel.bankerName_UILabel.text = bstr
		end
		bet = "空闲"
	elseif(this._curState == this._const.OX_STATUS_BANKER) then --抢庄时间
		this.updatePlayerInfo()
		this._PlayermaxCoin = 0
		this._totalBetCoin = 0
		RoomPanel.bankerName_UILabel.text = "庄家:待定\n单人最高下注:0"
		RoomPanel.betNum_UILabel.text = 0
		this._allBetCoin = 0;
		bet = "请抢庄"
		if(this._IsOpenGame == false) then
			soundMgr:PlaySound("prob")
			this.ShowBigTime(false)
			RoomPanel.tiprob:SetActive(true)
			RoomPanel.rob_UISprite.color = Color.white
			RoomPanel.robBg_UISprite.color = Color.white
			RoomPanel.robEffect:SetActive(true)
		end
	elseif(this._curState == this._const.OX_STATUS_BET) then --下注时间
		this.updatePlayerInfo()
		this.closeShowUI()
		bet = "请下注"
		if(data.banker_name == RoomPanel.getPlayerName()) then --自己是不是庄家
			this._IsRoom = true
			soundMgr:PlaySound("merob")
		else
			if(this._IsOpenGame == false) then
				-- RoomPanel.tipbet:SetActive(true)
				soundMgr:PlaySound("pbet")
				this.ShowBigTime(false)
				this.BetBtnColor(Color.white)
			end
		end
		this._PlayermaxCoin = data.player_max_coin
		RoomPanel.rob:SetActive(false)
		RoomPanel.robHead:SetActive(true)
		RoomPanel.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
		local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n单人最高下注:" .. this._PlayermaxCoin
		RoomPanel.bankerName_UILabel.text = bstr
	elseif(this._curState == this._const.OX_STATUS_OPEN) then --开牌时间
		if(global._view:getViewBase("Rule") ~= nil) then
		 	global._view:getViewBase("Rule").OnDestroy()
		end
		if(global._view:getViewBase("Bank") ~= nil) then
		 	global._view:getViewBase("Bank").OnDestroy()
		end
		if(global._view:getViewBase("PlayerList")~=nil)then
			global._view:getViewBase("PlayerList").clearView();
		end
		RoomPanel.robHead:SetActive(true)
		RoomPanel.rob:SetActive(false)
		this._totalBetCoin = 0
		this._autoCard = false
		bet = "开牌"
		this._userBetVec = {}
		local len = #data.bet_users
		if(len > 0) then
			local bankerInfo = data.bet_users[1]
			this._bankerId = bankerInfo.playerid
			RoomPanel.bankerName_UILabel.text = "庄家:" .. GameData.GetShortName(bankerInfo.player_name,14,14) .. "\n单人最高下注:" .. this._PlayermaxCoin
			if(bankerInfo.cards ~= "") then
				local card = string.split(bankerInfo.cards, ",")
				local len = #card
				this._bankerPoint = card[len - 1]
			end
			if(bankerInfo.player_name == RoomPanel.getPlayerName()) then --自己是不是庄家
				this._IsRoom = true
			end
		end
		for i=1,len do
			local bankerInfo = data.bet_users[i]
			local name = bankerInfo.player_name
			local vec = {
				betusers = bankerInfo,
				Isopen = 0,
				playerId = bankerInfo.playerid,
			}
			table.insert(this._userBetVec,vec)
			if(name == RoomPanel.getPlayerName()) then
				this._cards = bankerInfo.cards
				if(this._cards ~= "") then
					local card = string.split(this._cards, ",")
					this._curBetPoint = tonumber(card[6])
					this._curBetType = tonumber(card[7])
					this.renderFunc(card)
				end
			end
		end
	end
	RoomPanel.BetState_UILabel.text = bet
end

RoomCtrl._bankerId = 0
function RoomCtrl.CardShow(Id)
	if(this._userBetVec ~= nil and this._FreeTime > 0 and this._curState == this._const.OX_STATUS_OPEN) then
		local len = #this._userBetVec
		for i=1,len do
			local data = this._userBetVec[i]
			if(data.playerId == Id) then
				data.Isopen = 1
				local name = data.betusers.player_name
				local card = string.split(data.betusers.cards, ",")
				local IsBanker = ""
				if(Id == this._bankerId) then
					IsBanker = "【庄家】"
				end
        		local info = IsBanker..this.getUserPointValue(card,"")
        		local who = 0
        		local imgurl = data.betusers.headimgurl
				if(name == RoomPanel.getPlayerName()) then
					who = 1
					imgurl = RoomPanel.getPlayerImg()
				end
        		local d={coin = 0,
					player_name = name,
					amount_money = 0,
					content = info,
					url = imgurl,
					viedo = false,
					viedoTime = 0,
					IsCard = card,
					IsBank = IsBanker,
				}
				this.addPlayerBetInfo(d,who)
				break
			end
		end
	end
end

function RoomCtrl.BetFillCallBack(value)
	this._totalBetCoin = this._totalBetCoin + value
	if(this._IsAllBet) then
		soundMgr:PlaySound("allin")
		this.BetBtnColor(Color.gray)
	else
		soundMgr:PlaySound("bet")
		RoomPanel.betall_UISprite.color = Color.gray
	end
	this._allBetCoin = 0;
	RoomPanel.betNum_UILabel.text = 0
end

RoomCtrl._userBetVec = nil
RoomCtrl._curBetPoint = 0
RoomCtrl._curBetType = 0
function RoomCtrl.updatePlayerInfo()
	this._playerCoin = RoomPanel.getPlayerCoin() + RoomPanel.getPlayerRMB()
	RoomPanel.playerCoin_UILabel.text = RoomPanel.getPlayerRMB()-- this._betCoin
	RoomPanel.playerSilver_UILabel.text = RoomPanel.getPlayerCoin()
	this._betCoin = 0
	RoomPanel.playerName_UILabel.text = GameData.GetShortName(RoomPanel.getPlayerName(),14,12) .. "\nID:" .. RoomPanel.getPlayerId()
end

RoomCtrl.cardname = {"one","two","three","four","five",
					"six","seven","eight","nine","ten"}
RoomCtrl.cardList = {}
function RoomCtrl.renderFunc (list)
	if(#this.cardList > 0) then
		return
	end
    local parent = RoomPanel.cardPanel;
    local bundle = resMgr:LoadBundle("CardBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"CardBar");
    this._startIndex = 1
	this.IsopenCard = false
	this.animaPoint = false
	this.IsShowHanle = false
    RoomPanel.fiveCardNum:SetActive(false)
    local len = #list;
	for i = 1, 5 do
		if(i < 5) then
			local go = GameObject.Instantiate(Prefab);
			go.name = "CardBar"..i;
			go.transform.parent = parent;
			go.transform.localScale = Vector3(0,0,0);
			go.transform.localPosition = Vector3(-540, -175, 0);
			go:GetComponent('TweenPosition').to = Vector3(this.tarPos[i],0,0);
			resMgr:addAltas(go.transform,"Room")
			-- go:GetComponent('TweenPosition').duration = i * 0.5;
			-- go:GetComponent('TweenScale').duration = i * 0.5;
			local str = this.cardname[tonumber(list[i])]
			go.transform:Find(str).gameObject:SetActive(true);
			-- up:GetComponent('UILabel').text = list[i];
			-- local down = go.transform:Find('carddown');
			-- down:GetComponent('UILabel').text = list[i];
			local data = {prefab = go,duration = 0.2,point = list[i],}
			table.insert(this.cardList,data)
		else
			local num = list[i]
			this.loadResultAltas(num)
			local data = {prefab = nil,duration = 0.2,point = num,}
			table.insert(this.cardList,data)
		end
	end
	RoomPanel.playerPoint:SetActive(true)
	-- RoomPanel.playerPoint_UILabel.text = "你的点数 " .. list[len - 1] .. "点"
end

RoomCtrl._startIndex = 1
function RoomCtrl.dealCardTime()
	if(this.cardList ~= nil and this.IsShowHanle == false)then
		local len = #this.cardList;
		if(len > 0) then
			local data = this.cardList[this._startIndex]
			if(data ~= nil) then
				if(data.duration > 0) then
					data.duration = data.duration - Time.deltaTime
				else
					this._startIndex = this._startIndex + 1
					soundMgr:PlaySound("card")
					if(data.prefab == nil) then
						RoomPanel.finalCard:SetActive(true)
						RoomPanel.finalCard.transform.localPosition = Vector3(-540, -175, 0);
						RoomPanel.finalCard.transform.localScale = Vector3(0,0,0);
						RoomPanel.finalCard_TweenPosition:ResetToBeginning()
					    RoomPanel.finalCard_TweenScale:ResetToBeginning()
					    if(RoomPanel.finalCard_TweenPosition.enabled == false) then
					    	RoomPanel.finalCard_TweenPosition.enabled = true
					    end
					    if(RoomPanel.finalCard_TweenScale.enabled == false) then
					    	RoomPanel.finalCard_TweenScale.enabled = true
					    end
					    RoomPanel.animicard:SetActive(true)
					    RoomPanel.cardback:SetActive(true)
					    this.roll = -1
					    this.Speed = 0
					    this.IsShowHanle = true
					else
						this.playCardAnima(data.prefab)
					end
				end
			end
		end
	end
end

function RoomCtrl.playCardAnima(go)
	local pos = go:GetComponent('TweenPosition')
	local scale = go:GetComponent('TweenScale')
	pos:ResetToBeginning()
	scale:ResetToBeginning()
	if(pos.enabled == false) then
    	pos.enabled = true
    end
    if(scale.enabled == false) then
    	scale.enabled = true
    end
 --    if(this._IsOpenGame == false) then
	-- 	this.ShowBigTime(false)
	-- end
end

function RoomCtrl.onCloseCard()
	RoomPanel.cardback:SetActive(false)
	RoomPanel.playerPoint:SetActive(false)
	RoomPanel.fiveCardNum:SetActive(false)
	RoomPanel.finalCard:SetActive(false)
	RoomPanel.cardEffect:SetActive(false)
	this._startIndex = 1
	this.IsopenCard = false
	this.animaPoint = false
	RoomPanel.animicard:SetActive(false)
	this.ClearCardData()
	this.clearEffect()
end

function RoomCtrl.ClearCardData()
	local len = #this.cardList;
	for i=1,len do
		local data = this.cardList[i]
		if(data ~= nil and data.prefab ~= nil) then
			panelMgr:ClearPrefab(data.prefab);
		end
	end
	this.cardList = {}
end

function RoomCtrl.checkIsLook(text)
	if(string.find(text,"biaoqing_") ~= nil) then
		return true
	end
	return false
end

RoomCtrl.battlelist = {}
RoomCtrl.battleInfo = ""
function RoomCtrl.addPlayerBetInfo(info,who)
	RoomPanel.battlelist_UIScrollView:ResetPosition();
	local playername = info.player_name
	local coin = info.coin
	local amountmoney = info.amount_money
	local txt = nil
	local islook = false
	if(info.viedo == false) then
		txt = " 下注:" .. coin .. "  总下注:" .. amountmoney
		if(info.content ~= "") then
			txt = info.content
			islook = this.checkIsLook(txt)
		end
	else
		txt = info.content
	end
	local len = #this.battlelist
	this.addBattleInfo(playername,txt,who,len,islook,info.url,info.viedo,info.viedoTime,info.IsCard,info.IsBank)
	this.checkBattleMax(len + 1)
	local height = this.totalH
	RoomPanel.battlelist_UIScrollView:ResetPosition();
	if(height > 490) then
		RoomPanel.BarCollider_UISprite.height = height
		RoomPanel.battlelist_UIScrollView:SetDragAmount(0,1,false)
	else
		RoomPanel.BarCollider_UISprite.height = 488
	end
end

RoomCtrl.totalH = 0
RoomCtrl.minW = 80
RoomCtrl.maxW = 715
RoomCtrl.chatSpace = 90
RoomCtrl.sigleDialogH = 76
RoomCtrl.sigleTxtH = 42
function RoomCtrl.addBattleInfo(name,txt,IsSelf,len,islook,url,viedo,viedoTime,IsCard,IsBank)
	local allH = this.getBattleH();
	local parent = RoomPanel.battlelist.transform;
    local bundle = resMgr:LoadBundle("battleBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"battleBar");
	local go = GameObject.Instantiate(Prefab);
	go.name = "battleBar"..len;
	go.transform.parent = parent;
	go.transform.localScale = Vector3.one;
	go.transform.localPosition = Vector3(0, 228 - allH, 0);
	resMgr:addAltas(go.transform,"Room")
	local testTxt = go.transform:Find('testTxt');
	local testTxt_UILabel = testTxt:GetComponent('UILabel')
	local lenght = 100
	if(viedo == false) then
		testTxt_UILabel.text = txt
		lenght = testTxt_UILabel.width
	end
	local card = go.transform:Find('card').gameObject
	local IsBankSpace = 0
	card:SetActive(false);
	if(IsCard ~= nil) then
		card:SetActive(true);
		if(IsBank ~= "") then
			IsBankSpace = 130
		end
		this.showChatCardNum(IsCard,go)
		if(IsSelf == 0) then
			card.transform.localPosition = Vector3(IsBankSpace, 0, 0);
		elseif(IsSelf == 1) then
			card.transform.localPosition = Vector3(315 - IsBankSpace, 0, 0);
		end
		lenght = 380 + IsBankSpace
	end
	local H = 0;
	if(IsSelf == 0) then
		go.transform:Find('other').gameObject:SetActive(true);
		-- local otherIcon = go.transform:Find('other/otherIcon')
		-- local otherIcon_AsyncImageDownload = otherIcon:GetComponent('AsyncImageDownload');
		-- otherIcon_AsyncImageDownload:SetAsyncImage(url)
		local otherName_UILabel = go.transform:Find('other/otherName'):GetComponent('UILabel');
		otherName_UILabel.text = name
		local up = go.transform:Find('other/otherTxt').gameObject;
		local up_UILabel = up:GetComponent('UILabel')
		local otherlook = go.transform:Find('other/otherlook').gameObject
		otherlook:SetActive(false)
		local updialog = go.transform:Find('other/otherdialog').gameObject;
		if(islook) then
			otherlook:SetActive(true)
			up:SetActive(false)
			local otherlook_UISprite = otherlook:GetComponent('UISprite')
			otherlook_UISprite.spriteName = txt
			otherlook_UISprite:MakePixelPerfect();
		else
			if(viedo) then
				local otherviedo = go.transform:Find('other/otherviedo').gameObject
				otherviedo:SetActive(true);
				local otherviedoTxt = go.transform:Find('other/otherviedo/otherviedoTxt').gameObject;
				local otherviedoTxt_UILabel = otherviedoTxt:GetComponent('UILabel')
				otherviedoTxt_UILabel.text = string.format("%.2f", viedoTime) .. "''"
				this.Room:AddClick(updialog, function ()
					if(this.viedoAll ~= nil) then
						if(this.viedoAll.IsPlay == go.name) then
							return
						end
					end
					this.pauseMusic()
					-- local chatdata = RoomPanel.viedo_MicroPhoneInput:ByteToInt(txt)
					-- RoomPanel.viedo_MicroPhoneInput:PlayClipData(chatdata)
					RoomPanel.viedo_VoiceChatPlayer:Stop();
				    RoomPanel.viedo_VoiceChatPlayer:addCacheDataByte(txt)
				    -- RoomPanel.viedo_VoiceChatPlayer:PlayRecording(#txt)
					local otherviedo1 = go.transform:Find('other/otherviedo/otherviedo1').gameObject
					local otherviedo2 = go.transform:Find('other/otherviedo/otherviedo2').gameObject
					local otherviedo3 = go.transform:Find('other/otherviedo/otherviedo3').gameObject
					this.resertVideo()
					this.StopTime = viedoTime
					local viedo = {otherviedo1,otherviedo2,otherviedo3}
					this.viedoAll = {viedo = viedo,
					IsPlay = go.name,}
				end);
				up:SetActive(false)
			else
				up_UILabel.text = "[000000]" .. txt;
			end
		end
		local updialog_UISprite = updialog:GetComponent('UISprite')
		local dialogH = updialog_UISprite.height
		local upH = up_UILabel.height
		if(lenght <= this.minW - 20 or islook) then
			updialog_UISprite.width = this.minW
		elseif(lenght >= this.maxW - 20) then
			updialog_UISprite.width = this.maxW
		else
			updialog_UISprite.width = lenght + 20
		end
		local low = upH / 42
		H = this.chatSpace + (low - 1) * this.sigleTxtH;
		updialog:GetComponent('UISprite').height = this.sigleDialogH + (low - 1) * this.sigleTxtH
	elseif(IsSelf == 1) then
		go.transform:Find('myself').gameObject:SetActive(true);
		-- local myIcon = go.transform:Find('myself/myIcon')
		-- local myIcon_AsyncImageDownload = myIcon:GetComponent('AsyncImageDownload');
		-- myIcon_AsyncImageDownload:SetAsyncImage(url)
		local myName_UILabel = go.transform:Find('myself/myName'):GetComponent('UILabel');
		myName_UILabel.text = name
		local down = go.transform:Find('myself/myselfTxt').gameObject;
		local down_UILabel = down:GetComponent('UILabel')
		local mylook = go.transform:Find('myself/mylook').gameObject
		mylook:SetActive(false)
		local downdialog = go.transform:Find('myself/myselfdialog').gameObject;
		if(islook) then
			down:SetActive(false)
			mylook:SetActive(true)
			local mylook_UISprite = mylook:GetComponent('UISprite')
			mylook_UISprite.spriteName = txt
			mylook_UISprite:MakePixelPerfect();
		else
			if(viedo) then
				local myviedo = go.transform:Find('myself/myviedo').gameObject
				myviedo:SetActive(true);
				local myviedoTxt = go.transform:Find('myself/myviedo/myviedoTxt').gameObject;
				local myviedoTxt_UILabel = myviedoTxt:GetComponent('UILabel')
				myviedoTxt_UILabel.text = string.format("%.2f", viedoTime) .. "''"
				this.Room:AddClick(downdialog, function ()
					if(this.viedoAll ~= nil) then
						if(this.viedoAll.IsPlay == go.name) then
							return
						end
					end
					this.pauseMusic()
					-- local chatdata = RoomPanel.viedo_MicroPhoneInput:ByteToInt(txt)
					-- RoomPanel.viedo_MicroPhoneInput:PlayClipData(chatdata)
					RoomPanel.viedo_VoiceChatPlayer:Stop();
				    RoomPanel.viedo_VoiceChatPlayer:addCacheDataByte(txt)
				    -- RoomPanel.viedo_VoiceChatPlayer:PlayRecording(#txt)
					local myviedo1 = go.transform:Find('myself/myviedo/myviedo1').gameObject
					local myviedo2 = go.transform:Find('myself/myviedo/myviedo2').gameObject
					local myviedo3 = go.transform:Find('myself/myviedo/myviedo3').gameObject
					this.resertVideo()
					this.StopTime = viedoTime
					local viedo = {myviedo1,myviedo2,myviedo3}
					this.viedoAll = {viedo = viedo,
					IsPlay = go.name,}
				end);
				down:SetActive(false)
			else
				down_UILabel.text = "[000000]" .. txt;
			end
		end
		local downdialog_UISprite = downdialog:GetComponent('UISprite')
		local dialogH = downdialog_UISprite.height
		local downH = down_UILabel.height
		if(lenght <= this.minW - 20 or islook) then
			downdialog_UISprite.width = this.minW
		elseif(lenght >= this.maxW - 20) then
			downdialog_UISprite.width = this.maxW
		else
			downdialog_UISprite.width = lenght + 20
		end
		local low = downH / 42
		H = this.chatSpace + (low - 1) * this.sigleTxtH;
		downdialog_UISprite.height = this.sigleDialogH + (low - 1) * this.sigleTxtH
	else
		go.transform:Find('joinInfo').gameObject:SetActive(true);
		local joinName_UILabel = go.transform:Find('joinInfo/joinName'):GetComponent('UILabel')
		joinName_UILabel.text = "[000000]" .. name .. txt
		local jw = joinName_UILabel.width
		local joinbg_UISprite = go.transform:Find('joinInfo/joinbg'):GetComponent('UISprite')
		joinbg_UISprite.width = jw + 42
		H = joinbg_UISprite.height
	end
	local battleInfo = {battle = go,
		battleH = H + 30,
		chat = txt,
		chatType = IsSelf,
		url = url,}
	table.insert(this.battlelist,battleInfo)
	this.totalH = allH + battleInfo.battleH
	this.loadBattleIcon()
end

function RoomCtrl.showChatCardNum(cards,go)
	for i=1,5 do
		local str = "card/Card" .. i .. "/" .. this.cardname[tonumber(cards[i])]
		go.transform:Find(str).gameObject:SetActive(true);
	end
end

function RoomCtrl.startSayAnima()
	if(this.IsSay) then
	    this.sayTime = this.sayTime + Time.deltaTime
	    this.totalTime = this.totalTime + Time.deltaTime
	    if(this.sayTime >= 0.1) then
	    	this.sayTime = 0
	    	this.playViedoData()
	    end
	    if(this.totalTime >= tonumber(this.StopTime)) then
	    	this.IsSay = false
	    	this.viedoAll.viedo[1]:SetActive(true)
			this.viedoAll.viedo[2]:SetActive(true)
			this.viedoAll.viedo[3]:SetActive(true)
			this.viedoAll = nil
			this.PlayBGSound()
	    end
	end
end

RoomCtrl.viedoAll = nil
RoomCtrl.AllIndex = 3
RoomCtrl.sayTime = 0
RoomCtrl.totalTime = 0
RoomCtrl.IsSay = false
RoomCtrl.StopTime = 0
function RoomCtrl.playViedoData()
	if(this.viedoAll ~= nil) then
		if(this.AllIndex > 3) then
			this.AllIndex = 1
			this.viedoAll.viedo[1]:SetActive(false)
			this.viedoAll.viedo[2]:SetActive(false)
			this.viedoAll.viedo[3]:SetActive(false)
		end
		this.viedoAll.viedo[this.AllIndex]:SetActive(true)
		this.AllIndex = this.AllIndex + 1
	end
end

function RoomCtrl.resertVideo()
	this.sayTime = 0
	this.totalTime = 0
	this.AllIndex = 3
	this.IsSay = true
	if(this.viedoAll ~= nil) then
		this.viedoAll.viedo[1]:SetActive(true)
		this.viedoAll.viedo[2]:SetActive(true)
		this.viedoAll.viedo[3]:SetActive(true)
	end
end

function RoomCtrl.loadBattleIcon()
	local len = #this.battlelist;
	for i=1,len do
		local battle = this.battlelist[i]
		if(battle ~= nil) then
			if(battle.chatType == 0) then
				local otherIcon = battle.battle.transform:Find('other/otherIcon')
				local otherIcon_AsyncImageDownload = otherIcon:GetComponent('AsyncImageDownload');
				if(otherIcon_AsyncImageDownload.texture.mainTexture == nil) then
					otherIcon_AsyncImageDownload:SetAsyncImage(battle.url)
				end
			elseif(battle.chatType == 1) then
				local myIcon = battle.battle.transform:Find('myself/myIcon')
				local myIcon_AsyncImageDownload = myIcon:GetComponent('AsyncImageDownload');
				if(myIcon_AsyncImageDownload.texture.mainTexture == nil) then
					myIcon_AsyncImageDownload:SetAsyncImage(battle.url)
				end
			end
		end
	end
end

function RoomCtrl.getBattleH()
	local len = #this.battlelist
	local battleH = 0
	for i=1,len do
		local battle = this.battlelist[i]
		if(battle ~= nil) then
			battleH = battleH + battle.battleH
		end
	end
	return battleH
end

function RoomCtrl.checkBattleMax(count)
	if(count > 50) then
		local data = this.battlelist[1]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data.battle);
			table.remove(this.battlelist,1);
			local len = #this.battlelist
			local battleH = 0
			for i=1,len do
				local battleInfo = this.battlelist[i]
				battleInfo.battle.transform.localPosition = Vector3(0, 228 - battleH, 0);
				battleH = battleH + battleInfo.battleH
			end
			this.totalH = battleH
		end
	end
end

function RoomCtrl.clearBattle()
	local len = #this.battlelist;
	for i=1,len do
		local data = this.battlelist[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data.battle);
		end
	end
	this.battlelist = {}
end

RoomCtrl.animacardBg = {"cardbg01"}
RoomCtrl.animaPoint = false
RoomCtrl.PointStart = 0
RoomCtrl.Speed = 0
RoomCtrl.roll = -1
function RoomCtrl.playAnima(go,isPress)
	if(this._startIndex == 6 and this.IsopenCard == false) then
		this.animaPoint = isPress
		this.PointStart = Input.mousePosition
	end
end

function RoomCtrl.updateAnima()
	if(this.animaPoint and this.IsopenCard == false) then
		local inputPoint = Input.mousePosition;
	    local dist = this.Room:Distance(this.PointStart.x, this.PointStart.y, this.PointStart.z,
	                               inputPoint.x, inputPoint.y, inputPoint.z)
	    if(dist > 0 and this.PointStart.y < inputPoint.y) then
	    	this.mouseCard()
	    	this.PointStart = Input.mousePosition
	    end
	end
end

RoomCtrl.IsShowHanle = false
function RoomCtrl.FristHandle()
	if(this.IsShowHanle == false) then
		return
	end
	if(this.Speed <= 0.08) then
        this.Speed = this.Speed + Time.deltaTime
    else
    	if(this.roll < 1) then
    		this.Speed = 0
	        this.roll = this.roll + 1
	        this.updateCardImg(this.roll)
	        this.updateCardNum(this.roll)
	        this.updateLeftHandleImg(this.roll)
	        this.updateRightHandleImg(this.roll + 1)
	    else
	    	this.IsShowHanle = false
    	end
    end
end

function RoomCtrl.mouseCard()
	if(this.Speed <= 0.08) then
        this.Speed = this.Speed + Time.deltaTime
    else
    	if(this.roll >= 18) then
    		this.IsopenCard = true
    		return
    	end
    	RoomPanel.finalCard:SetActive(false)
        this.Speed = 0
        this.roll = this.roll + 1
        this.updateCardImg(this.roll)
        this.updateCardNum(this.roll)
        this.updateLeftHandleImg(this.roll)
        this.updateRightHandleImg(this.roll + 1)
    end
end

RoomCtrl.animaIconList = {}
RoomCtrl.IsopenCard = false
function RoomCtrl.CardAnima()
	if(this.IsopenCard == false) then
		return
	end
    if(this.Speed <= 0.08) then
        this.Speed = this.Speed + Time.deltaTime
    else
    	RoomPanel.finalCard:SetActive(false)
        this.Speed = 0
        this.roll = this.roll + 1
        this.updateCardImg(this.roll)
        this.updateCardNum(this.roll)
        this.updateLeftHandleImg(this.roll)
        this.updateRightHandleImg(this.roll + 1)
        if(this.roll == 32) then
        	this.IsopenCard = false
        	RoomPanel.animicard:SetActive(false)
        	local data = this.cardList[5]
        	local point = data.point
        	this.changeEffect()
        	if(this._FreeTime > 0 and this._autoCard == false) then
        		RoomPanel.SendCardData()
        	end
        	RoomPanel.fiveCardNum:SetActive(true)
        	RoomPanel.fiveCardNum_UISprite.spriteName = "card" .. point
        	RoomPanel.fiveCardNum_UISprite:MakePixelPerfect();
        end
    end
end

function RoomCtrl.ConverStr(roll)
	if(roll < 10) then
    	num = "0" .. roll
    else
    	num = roll
    end
    return num
end

RoomCtrl.cardNumPosX = {0,0,0,0,0,0,1,0,22,0,
						0,0,0,0,0,0,0,0,-20,-20,
						-13,-20,-21,-17,0,0,0,0,-12,-4,}
RoomCtrl.cardNumPosY = {0,0,0,-6,-4,-2,-2,-5,-2,0,
						0,0,0,0,0,0,0,0,-3,0,
						0,2,-2,2,0,0,0,0,-2,-2,}
function RoomCtrl.updateCardNum(roll)
	if(roll >= 19) then
		roll = roll + 1
	end
	local num = this.ConverStr(roll)
    RoomPanel.cardImg_UISprite.spriteName = "card" .. num
    RoomPanel.cardImg_UISprite.transform.localPosition = Vector3(this.cardNumPosX[roll], this.cardNumPosY[roll], 0);
    RoomPanel.cardImg_UISprite:MakePixelPerfect();
end

function RoomCtrl.updateCardImg(roll)
	if(roll >= 19) then
		roll = roll + 1
	end
	local num = this.ConverStr(roll)
    RoomPanel.cardIcon_UISprite.spriteName = "cardbg" .. num
    RoomPanel.cardIcon_UISprite.transform.localPosition = Vector3(this.cardPosX[roll], this.cardPosY[roll], 0);
    RoomPanel.cardIcon_UISprite:MakePixelPerfect();
end

RoomCtrl.cardPosX = {0,0,2,0,0,0,-2,-5,-42,-55,
					-27,-24,-22,-27,-25,-20,-15,19,9,-1,
					-4,0,0,-25,2,-36,-39,18,-14,139}
RoomCtrl.cardPosY = {0,0,6,10,10,15,20,22,9,2,
					0,0,0,0,0,0,-7,0,0,10,
					13,10,10,3,-23,-13,-12,3,112,178}
RoomCtrl.rightHandlePosX = {0,0,0,0,0,0,0,0,0,0,
							0,-52,-65,-22,-14,-14,-15,-13,-24,-34,
							-37,-37,-37,-35,-40,-42,-25,0,0,0,
							299,}
RoomCtrl.rightHandlePosY = {0,0,0,0,0,0,0,0,0,0,
							0,0,0,0,0,0,0,-5,0,2,
							0,0,0,0,2,-3,3,0,0,0,
							-155,}
RoomCtrl.lefthandleSize = {9,16,24}
RoomCtrl.righthandleSize = {10,20,29,36}
function RoomCtrl.updateLeftHandleImg(roll)
	if(roll >= 17) then
		roll = roll - 1
	end
	if(roll == 25) then
		roll = 24
	end
	RoomPanel.cardLeft:SetActive(false)
	RoomPanel.handleft2:SetActive(false)
	RoomPanel.handleft3:SetActive(false)
	local num = this.ConverStr(roll)
	if(roll > this.lefthandleSize[1] and roll <= this.lefthandleSize[2]) then
		RoomPanel.handleft2:SetActive(true)
		RoomPanel.handleft2_UISprite.spriteName = "animihandl" .. num
    	RoomPanel.handleft2_UISprite:MakePixelPerfect();
	elseif(roll > this.lefthandleSize[2] and roll <= this.lefthandleSize[3]) then
		RoomPanel.handleft3:SetActive(true)
		RoomPanel.handleft3_UISprite.spriteName = "animihandl" .. num
    	RoomPanel.handleft3_UISprite:MakePixelPerfect();
	elseif(roll <= this.lefthandleSize[1]) then
		RoomPanel.cardLeft:SetActive(true)
		RoomPanel.cardLeft_UISprite.spriteName = "animihandl" .. num
    	RoomPanel.cardLeft_UISprite:MakePixelPerfect();
	end
end

function RoomCtrl.updateRightHandleImg(roll)
	if(roll >= 24) then
		roll = roll + 1
	end
	RoomPanel.cardRight:SetActive(false)
	RoomPanel.handright2:SetActive(false)
	RoomPanel.handright3:SetActive(false)
	RoomPanel.handright4:SetActive(false)
	local num = this.ConverStr(roll)
	if(roll > this.righthandleSize[1] and roll <= this.righthandleSize[2]) then
		RoomPanel.handright2:SetActive(true)
		RoomPanel.handright2_UISprite.spriteName = "animihandr" .. num
    	RoomPanel.handright2_UISprite:MakePixelPerfect();
    	RoomPanel.handright2_UISprite.transform.localPosition = Vector3(this.rightHandlePosX[roll], this.rightHandlePosY[roll], 0);
	elseif(roll > this.righthandleSize[2] and roll <= this.righthandleSize[3]) then
		RoomPanel.handright3:SetActive(true)
		RoomPanel.handright3_UISprite.spriteName = "animihandr" .. num
    	RoomPanel.handright3_UISprite:MakePixelPerfect();
    	RoomPanel.handright3_UISprite.transform.localPosition = Vector3(this.rightHandlePosX[roll], this.rightHandlePosY[roll], 0);
    elseif(roll > this.righthandleSize[3] and roll <= this.righthandleSize[4]) then
    	RoomPanel.handright4:SetActive(true)
		RoomPanel.handright4_UISprite.spriteName = "animihandr" .. num
    	RoomPanel.handright4_UISprite:MakePixelPerfect();
    	RoomPanel.handright4_UISprite.transform.localPosition = Vector3(this.rightHandlePosX[roll], this.rightHandlePosY[roll], 0);
    	if(roll == 31) then
    		RoomPanel.cardIcon_UISprite.depth = 5
    		RoomPanel.handright4_UISprite.transform.rotation = Quaternion.Euler(Vector3(0,0,30));
    	else
    		RoomPanel.handright4_UISprite.transform.rotation = Quaternion.Euler(Vector3.one);
    	end
	elseif(roll <= this.righthandleSize[1]) then
		RoomPanel.cardRight:SetActive(true)
		RoomPanel.cardRight_UISprite.spriteName = "animihandr" .. num
    	RoomPanel.cardRight_UISprite:MakePixelPerfect();
    	RoomPanel.cardRight_UISprite.transform.localPosition = Vector3(this.rightHandlePosX[roll], this.rightHandlePosY[roll], 0);
	end
	if(roll > this.righthandleSize[4]) then
		this.IsopenCard = false
		RoomPanel.animicard:SetActive(false)
	end
end

RoomCtrl._playScore = 0
function RoomCtrl.updateBalanceScore()
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

RoomCtrl._scoreLen = 0
function RoomCtrl.getScoreValue()
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

function RoomCtrl.getZeroNum(len)
	local num = 1
	for i=1,len - 1 do
		num = num * 10
	end
	return num
end

RoomCtrl._finalVec = {}
function RoomCtrl.getScoreFinal()
	this._finalVec = {}
	local len = string.len(this._maxScore)
	this._scoreLen = len
	for i=1,len do
		local value = string.sub(this._maxScore, -i,len - (i-1))
		table.insert(this._finalVec,value)
	end
end

RoomCtrl._startScore = 0;
RoomCtrl._maxScore = 0;
RoomCtrl._startAnima = false;
RoomCtrl._haveBalance = false;
function RoomCtrl.ShowBalance(data)
	this._haveBalance = false
	this.closeShowUI()
	this.showUIprefab("balanceInfo")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "balanceInfobar") then
			RoomPanel.balanceEnter:SetActive(true)
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
					global.sdk_mgr:share(1,"",files,"牛牛")
				end)
			end);
		end
	end
end

function RoomCtrl.sortPlayerBalance(list)
	local temp = nil
	local len = #list
	for i=1,len do
		local data = list[i]
		if(i ~= 1 and data.betusers.playerid == RoomPanel.getPlayerId()) then
			temp = data
			table.remove(list,i)
			break
		end
	end
	if(temp ~= nil) then
		table.insert(list,2,temp)
	end
	return list
end

RoomCtrl._balanceList = {}
function RoomCtrl.PrefabBalance(list)
	list = this.sortPlayerBalance(list)
	RoomPanel.balanceList_UIScrollView:ResetPosition()
	local bundle = resMgr:LoadBundle("balance");
    local Prefab = resMgr:LoadBundleAsset(bundle,"balance");
    local WinCoin = 0
    local len = #list
    for i=1,len do
    	local data = list[i]
    	local name = data.betusers.player_name
    	local coin = data.betusers.result_money
    	local go = GameObject.Instantiate(Prefab);
		go.name = "balancebar";
		go.transform.parent = RoomPanel.balanceList.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0,92 - (i - 1) * 78,0);
		resMgr:addAltas(go.transform,"Room")
		local special = go.transform:Find('special').gameObject;
		local village = go.transform:Find('village').gameObject;
		if(i == 1) then
			special:SetActive(true)
			village:SetActive(true)
		else
			special:SetActive(false)
			village:SetActive(false)
		end
		local freehome = go.transform:Find('freehome').gameObject;
		freehome:GetComponent('UILabel').text = GameData.GetShortName(name,6,6)
		local bscore = go.transform:Find('bscore').gameObject;
		bscore:GetComponent('UILabel').text = coin
		local card = string.split(data.betusers.cards, ",")
	    local info = this.getUserPointValue(card,"\n")
	    local point = go.transform:Find('point').gameObject;
		point:GetComponent('UILabel').text = info
    	if(name == RoomPanel.getPlayerName()) then
    		freehome:GetComponent('UILabel').text = "[FFCA3CFF]" .. GameData.GetShortName(name,6,6)
    		WinCoin = coin
    		if(coin > 0) then
				bscore:GetComponent('UILabel').text ="[FF0000FF]+"..coin
			else 
				bscore:GetComponent('UILabel').text ="[00FF17FF]"..coin
			end
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
		RoomPanel.balanceCollider_UISprite.height = pH
	end
end

function RoomCtrl.closeBalanceList()
	local len = #this._balanceList;
	for i=1,len do
		local data = this._balanceList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._balanceList = {}
end

function RoomCtrl.changeEffect()
	this.clearEffect()
	if(this._curBetType == this._const.OX_VALUE_TYPE_NONE) then -- 非特殊牌
		this.addPointEffect()
	elseif(this._curBetType == this._const.OX_VALUE_TYPE_3) then -- 牛牛
		this.addNiuniuEffect()
	elseif(this._curBetType == this._const.OX_VALUE_TYPE_2) then -- 顺子
		this.addPlaneEffect()
	elseif(this._curBetType == this._const.OX_VALUE_TYPE_1) then -- 炸弹
		this.addBombEffect()
	end
end

function RoomCtrl.addNiuniuEffect()
	RoomPanel.cardEffect:SetActive(true)
	local bundle = resMgr:LoadBundle("niuniuEffect");
    local Prefab = resMgr:LoadBundleAsset(bundle,"niuniuEffect");
    this._bombEffect = GameObject.Instantiate(Prefab);
	this._bombEffect.name = "niuniuEffectbar";
	this._bombEffect.transform.parent = RoomPanel.cardEffect.transform;
	this._bombEffect.transform.localScale = Vector3.one;
	this._bombEffect.transform.localPosition = Vector3.zero;
	resMgr:addAltas(this._bombEffect.transform,"Room")
	soundMgr:PlaySound("point-ten")
end

function RoomCtrl.addPointEffect()
	RoomPanel.cardEffect:SetActive(true)
	local bundle = resMgr:LoadBundle("PointAnima");
    local Prefab = resMgr:LoadBundleAsset(bundle,"PointAnima");
    this._bombEffect = GameObject.Instantiate(Prefab);
	this._bombEffect.name = "PointAnimabar";
	this._bombEffect.transform.parent = RoomPanel.cardEffect.transform;
	this._bombEffect.transform.localScale = Vector3(0,0,0);
	this._bombEffect.transform.localPosition = Vector3(0,-110,0);
	local forward = this._bombEffect.transform:Find('forward').gameObject;
	local forward_UISprite = forward:GetComponent('UISprite')
	local back = this._bombEffect.transform:Find('back').gameObject;
	local back_UISprite = back:GetComponent('UISprite')
	if(this._curBetPoint == 0) then
		forward_UISprite.spriteName = "zi_0"
		back_UISprite.spriteName = "zi_10"
		soundMgr:PlaySound("nopoint")
	elseif(this._curBetPoint > 0 and this._curBetPoint < 10) then
		forward_UISprite.spriteName = "zi_10"
		back_UISprite.spriteName = "zi_" .. this._curBetPoint
		soundMgr:PlaySound("point-"..this._curBetPoint)
	end
	resMgr:addAltas(this._bombEffect.transform,"Room")

end

function RoomCtrl.addPlaneEffect()
	RoomPanel.cardEffect:SetActive(true)
	local bundle = resMgr:LoadBundle("planeAnima");
    local Prefab = resMgr:LoadBundleAsset(bundle,"planeAnima");
    this._bombEffect = GameObject.Instantiate(Prefab);
	this._bombEffect.name = "planeAnimabar";
	this._bombEffect.transform.parent = RoomPanel.cardEffect.transform;
	this._bombEffect.transform.localScale = Vector3.one;
	this._bombEffect.transform.localPosition = Vector3.zero;
	resMgr:addAltas(this._bombEffect.transform,"Room")
	soundMgr:PlaySound("shunzi")
end

RoomCtrl._bombEffect = nil
RoomCtrl._Isbomb = false
function RoomCtrl.addBombEffect()
	RoomPanel.cardEffect:SetActive(true)
	local bundle = resMgr:LoadBundle("bomb");
    local Prefab = resMgr:LoadBundleAsset(bundle,"bomb");
    this._bombEffect = GameObject.Instantiate(Prefab);
	this._bombEffect.name = "bombbar";
	this._bombEffect.transform.parent = RoomPanel.cardEffect.transform;
	this._bombEffect.transform.localScale = Vector3.one;
	this._bombEffect.transform.localPosition = Vector3.zero;
	resMgr:addAltas(this._bombEffect.transform,"effect")
	soundMgr:PlaySound("bomb")
	this._Isbomb = true
	this.Speed = 0
	this._playBomb = 0
end

function RoomCtrl.clearEffect()
	if(this._bombEffect ~= nil) then
		panelMgr:ClearPrefab(this._bombEffect);
	end
	this._bombEffect = nil
end

RoomCtrl._playBomb = 0
function RoomCtrl.updateBomb()
	if(this._Isbomb == false) then
		return
	end
	if(this.Speed <= 0.08) then
        this.Speed = this.Speed + Time.deltaTime
    else
    	this.Speed = 0
    	if(this._bombEffect ~= nil and this._playBomb < 12) then
    		local bombIcon_UISprite = this._bombEffect.transform:Find('bombIcon'):GetComponent('UISprite');
			bombIcon_UISprite.spriteName = "zhadan_" .. this._playBomb;
			bombIcon_UISprite:MakePixelPerfect();
			this._playBomb = this._playBomb + 1
		else
			this._Isbomb = false
			RoomPanel.cardEffect:SetActive(false)
    	end
    end
end

function RoomCtrl.loadResultAltas(num)
	local astr = "card0" .. num
	local alats = resMgr:LoadUrlAssetAltas(astr);
	RoomPanel.cardImg_UISprite.atlas = alats;
	RoomPanel.cardImg_UISprite.spriteName = ""
end

function RoomCtrl.loadAllAltas()
	local a2 = resMgr:LoadUrlAssetAltas("animicardbg");
	RoomPanel.cardIcon_UISprite.atlas = a2;
	RoomPanel.cardIcon_UISprite.spriteName = ""

	local alt1 = resMgr:LoadUrlAssetAltas("handleft1");
	RoomPanel.cardLeft_UISprite.atlas = alt1;
	RoomPanel.cardLeft_UISprite.spriteName = ""
	local alt2 = resMgr:LoadUrlAssetAltas("handleft2");
	RoomPanel.handleft2_UISprite.atlas = alt2;
	RoomPanel.handleft2_UISprite.spriteName = ""
	local alt3 = resMgr:LoadUrlAssetAltas("handleft3");
	RoomPanel.handleft3_UISprite.atlas = alt3;
	RoomPanel.handleft3_UISprite.spriteName = ""

	local altas1 = resMgr:LoadUrlAssetAltas("handright1");
	RoomPanel.cardRight_UISprite.atlas = altas1;
	RoomPanel.cardRight_UISprite.spriteName = ""
	local altas2 = resMgr:LoadUrlAssetAltas("handright2");
	RoomPanel.handright2_UISprite.atlas = altas2;
	RoomPanel.handright2_UISprite.spriteName = ""
	local altas3 = resMgr:LoadUrlAssetAltas("handright3");
	RoomPanel.handright3_UISprite.atlas = altas3;
	RoomPanel.handright3_UISprite.spriteName = ""
	local altas4 = resMgr:LoadUrlAssetAltas("handright4");
	RoomPanel.handright4_UISprite.atlas = altas4;
	RoomPanel.handright4_UISprite.spriteName = ""
end
function RoomCtrl.pauseMusic()
	if CAN_PAUSE then 
		soundMgr:PauseBackSound()
	else
		soundMgr:StopBackSound()
	end 
end 
function RoomCtrl.PlayBGSound()
	if CAN_PAUSE then 
		soundMgr:PlayMusic()
	else
		soundMgr:PlayBackSound("niuniu_music")
	end 
end 
--关闭事件--
function RoomCtrl.Close()
	this.battlelist = {}
	this._userBetVec = nil
	this.clearBattle()
	this.ClearCardData()
	this.closeLookList()
	this.closeSayList()
	this.clearEffect()
	this.clearBigShow()
	this.closeShowUI()
	UpdateBeat:Remove(this.timeEvent, this)
	panelMgr:ClosePanel(CtrlNames.Room);
end

return RoomCtrl