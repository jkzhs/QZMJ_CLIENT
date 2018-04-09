require "logic/ViewManager"
local global = require("global")
local i18n = global.i18n
PaiGowCtrl = {};
local this = PaiGowCtrl;
PaiGowCtrl.panel = nil;
PaiGowCtrl.Room = nil;
PaiGowCtrl.transform = nil;
PaiGowCtrl.gameObject = nil;
PaiGowCtrl.RoomId = 0

--构建函数--
function PaiGowCtrl.New()
	return this;
end

PaiGowCtrl.IsGameRoom = false
PaiGowCtrl.RoomTitle = ""
function PaiGowCtrl.Awake(roomId,value,title)
	this.RoomId = roomId;
	this.IsGameRoom = value
	this.RoomTitle = title
	panelMgr:CreatePanel('PaiGow', this.OnCreate);
end

PaiGowCtrl.leftAll = {}
PaiGowCtrl.choicePos = 0
--启动事件--
function PaiGowCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	global._view:chat().Awake(global.const.GAME_ID_PAIGOW)
	this.panel = this.transform:GetComponent('UIPanel');
	this.Room = this.transform:GetComponent('LuaBehaviour');
	this.Room:AddClick(PaiGowPanel.push, function ()
		global._view:support().Awake("您确定要推到重新开始？",function ()
       		PaiGowPanel.PushOver()
		   end,function ()

       	end);
	end);
	this.Room:AddClick(PaiGowPanel.backOut, function ()
		global._view:support().Awake("您确定要放弃坐庄？",function ()
       		PaiGowPanel.DropBanker()
		   end,function ()

       	end);
	end);
	this.Room:AddClick(PaiGowPanel.back, this.OnBack);
	this.Room:AddClick(PaiGowPanel.rob, this.OnRob);
	this.Room:AddClick(PaiGowPanel.playlist, this.OnPlayerList);
	this.Room:AddClick(PaiGowPanel.share, this.OnShare);
	this.Room:AddClick(PaiGowPanel.invite, this.OnInvite);
	this.Room:AddClick(PaiGowPanel.rule, function ()
		global._view:rule().Awake(global.const.GAME_ID_PAIGOW)
	end);
	this.Room:AddClick(PaiGowPanel.bank, function ()
		global._view:bank().Awake()
	end);
	this.Room:AddClick(PaiGowPanel.closeshare, this.CloseShare);
	this.Room:AddOnPress(PaiGowPanel.playcard, this.playAnima);
	this.Room:AddClick(PaiGowPanel.uibox, this.closeShowUI);

	this.Room:AddClick(PaiGowPanel.betfive, this.OnBetBtn);
	this.Room:AddClick(PaiGowPanel.betten, this.OnBetBtn);
	this.Room:AddClick(PaiGowPanel.bethund, this.OnBetBtn);
	this.Room:AddClick(PaiGowPanel.betkilo, this.OnBetBtn);
	this.Room:AddClick(PaiGowPanel.bettenshou, this.OnBetBtn);
	this.Room:AddClick(PaiGowPanel.betmill, this.OnBetBtn);
	local rightAll = {PaiGowPanel.rightbet2,PaiGowPanel.rightbet5,PaiGowPanel.rightbet3,
	PaiGowPanel.rightbet6,PaiGowPanel.rightbet1,PaiGowPanel.rightbet4}
	this.leftAll = {PaiGowPanel.leftbet2,PaiGowPanel.leftbet5,PaiGowPanel.leftbet3,
	PaiGowPanel.leftbet6,PaiGowPanel.leftbet1,PaiGowPanel.leftbet4}
	for i=1,#rightAll do
		this.Room:AddClick(rightAll[i], function ()
			this.hideAllLeft()
			this.leftAll[i]:SetActive(true);
			this.choicePos = i
		end);
	end

	this.Room:AddOnPress(PaiGowPanel.btnFilling, function (go,isPress)
		if(this._const == nil) then
			return
		end
		if(this._curState ~= this._const.PAIGOW_STATUS_BET) then
			return
		end
		if(isPress) then
		else
			if(this._IsRoom) then
				return
			end
			if(this.choicePos == 0) then
				PaiGowPanel.setTip("请选择你要下注的区域！")
			end
			if(value == 0) then
				PaiGowPanel.setTip("下注金额不能为零！")
			end
			local value = tonumber(PaiGowPanel.BetCoin_UILabel.text)
			if(value > 0 and this.choicePos > 0) then
				PaiGowPanel.betData(this._allBetCoin,this.choicePos);
			end
		end
	end);
	this.Room:AddClick(PaiGowPanel.btnDel, function (go)
		if(this._curState ~= this._const.PAIGOW_STATUS_BET) then
			return
		end
		if(this._IsRoom) then
			return
		end
		this._allBetCoin = 0
		PaiGowPanel.BetCoin_UILabel.text = 0
		this._betpiecetype = {}
	end)
	if(this.IsGameRoom) then
    	PaiGowPanel.invite_UISprite.color = Color.gray
    	PaiGowPanel.invitefabu_UISprite.color = Color.gray
    	PaiGowPanel.inviteyaoqing_UISprite.color = Color.gray
    end
	this.choicePos = 0
	this.startDeal = false
	this._IsRoom = false
	this._startIndex = 1
    UpdateBeat:Add(this.timeEvent, this)
    this.updateBetAreaCoin()
    if global.player:get_paytype()  == 1 then
		PaiGowPanel.bank:SetActive(false)
		PaiGowPanel.share:SetActive(false)		
    end
end

function PaiGowCtrl.updateBetAreaCoin()
	PaiGowPanel.headdown_UILabel.text = "0"
	PaiGowPanel.headright_UILabel.text = "0"
	PaiGowPanel.headleft_UILabel.text = "0"
	PaiGowPanel.myheaddown_UILabel.text = "0"
	PaiGowPanel.myheadright_UILabel.text = "0"
	PaiGowPanel.myheadleft_UILabel.text = "0"
	PaiGowPanel.backdown_UILabel.text = "0"
	PaiGowPanel.backright_UILabel.text = "0"
	PaiGowPanel.backleft_UILabel.text = "0"
	PaiGowPanel.mybackdown_UILabel.text = "0"
	PaiGowPanel.mybackright_UILabel.text = "0"
	PaiGowPanel.mybackleft_UILabel.text = "0"
end

function PaiGowCtrl.updatePosCoin(pos,coin,who)
	if(pos == 1) then
		local now = tonumber(PaiGowPanel.headleft_UILabel.text) + coin
		PaiGowPanel.headleft_UILabel.text = now
	elseif(pos == 2) then
		local now = tonumber(PaiGowPanel.backleft_UILabel.text) + coin
		PaiGowPanel.backleft_UILabel.text = now
	elseif(pos == 3) then
		local now = tonumber(PaiGowPanel.headdown_UILabel.text) + coin
		PaiGowPanel.headdown_UILabel.text = now
	elseif(pos == 4) then
		local now = tonumber(PaiGowPanel.backdown_UILabel.text) + coin
		PaiGowPanel.backdown_UILabel.text = now
	elseif(pos == 5) then
		local now = tonumber(PaiGowPanel.headright_UILabel.text) + coin
		PaiGowPanel.headright_UILabel.text = now
	elseif(pos == 6) then
		local now = tonumber(PaiGowPanel.backright_UILabel.text) + coin
		PaiGowPanel.backright_UILabel.text = now
	end
	if(who == 0) then
		if(pos == 1) then
			local now = tonumber(PaiGowPanel.myheadleft_UILabel.text) + coin
			PaiGowPanel.myheadleft_UILabel.text = now
		elseif(pos == 2) then
			local now = tonumber(PaiGowPanel.mybackleft_UILabel.text) + coin
			PaiGowPanel.mybackleft_UILabel.text = now
		elseif(pos == 3) then
			local now = tonumber(PaiGowPanel.myheaddown_UILabel.text) + coin
			PaiGowPanel.myheaddown_UILabel.text = now
		elseif(pos == 4) then
			local now = tonumber(PaiGowPanel.mybackdown_UILabel.text) + coin
			PaiGowPanel.mybackdown_UILabel.text = now
		elseif(pos == 5) then
			local now = tonumber(PaiGowPanel.myheadright_UILabel.text) + coin
			PaiGowPanel.myheadright_UILabel.text = now
		elseif(pos == 6) then
			local now = tonumber(PaiGowPanel.mybackright_UILabel.text) + coin
			PaiGowPanel.mybackright_UILabel.text = now
		end
	end
end

PaiGowCtrl.startDeal = false
PaiGowCtrl.endDeal = false--是否翻牌
PaiGowCtrl._startIndex = 1
PaiGowCtrl._endIndex = 0
function PaiGowCtrl.dealCardTime()
	if(this._allCardList ~= nil and this.startDeal)then
		local len = #this._allCardList;
		if(len > 0) then
			local data = this._allCardList[this._startIndex]
			if(data ~= nil and this._startIndex <= this._endIndex) then
				if(this._startIndex == this._endIndex) then
					if(this.endDeal) then
						if(data.duration == 0.2) then
							this.openCardAnima(this._allCardList[2 + 8 * (this.round - 1)].prefab)
							this.openCardAnima(this._allCardList[4 + 8 * (this.round - 1)].prefab)
							this.openCardAnima(this._allCardList[6 + 8 * (this.round - 1)].prefab)
							this.openCardAnima(this._allCardList[8 + 8 * (this.round - 1)].prefab)
						end
						if(data.duration < 0.9) then
							data.duration = data.duration + Time.deltaTime
						else
							this.startDeal = false
							this.endDeal = false
							data.duration = 0.2
							this._startIndex = this._startIndex + 1
							this.showCard()
						end
					end
				else
					if(data.duration > 0) then
						data.duration = data.duration - Time.deltaTime
					else
						this._startIndex = this._startIndex + 1
						soundMgr:PlaySound("card")
						data.duration = 0.2
						this.playCardAnima(data.prefab)
					end
				end
			end
		end
	end
end

function PaiGowCtrl.showCard()
	local space = (this.round - 1)*8
	for i=space + 1,space + 8 do
		local data = this._allCardList[i]
		local go = data.prefab
		if(go.transform:Find(data.sign) ~= nil) then
			local sign = go.transform:Find(data.sign).gameObject;
			sign:SetActive(true);
		end
		local Sprite = go.transform:Find('Sprite').gameObject;
		Sprite:SetActive(false);
		local scale = go:GetComponent('TweenScale')
		scale.from = Vector3(1.5,1.7,0)
		scale.to = Vector3(2.6,2.8,0);
		scale:ResetToBeginning()
	    if(scale.enabled == false) then
	    	scale.enabled = true
	    end
		-- go.transform.localScale = Vector3(2,2.2,0);
	end
end

function PaiGowCtrl.openCardAnima(go)
	local Sprite = go.transform:Find('Sprite');
	local rotation = Sprite:GetComponent('TweenRotation')
	rotation:ResetToBeginning()
	if(rotation.enabled == false) then
    	rotation.enabled = true
    end
end

function PaiGowCtrl.playCardAnima(go)
	local Sprite = go.transform:Find('Sprite');
	Sprite:GetComponent('UISprite').depth = 0;
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
end

PaiGowCtrl.v1 = {x = -148,y = 170}
PaiGowCtrl.v2 = {x = -480,y = -16}
PaiGowCtrl.v3 = {x = -148,y = -168}
PaiGowCtrl.v4 = {x = 184,y = -16}
PaiGowCtrl.p1 = {x = -148,y = -206}
PaiGowCtrl.p2 = {x = 184,y = -16}
PaiGowCtrl.p3 = {x = -148,y = 170}
PaiGowCtrl.p4 = {x = -480,y = -16}
PaiGowCtrl.BettarPos = {}
PaiGowCtrl.robPoint = {}
function PaiGowCtrl.SetPaiStarOrEnd(num,list)
	this.BettarPos = {}
	this._openCardList = {}
	this.robPoint = list
	local allv = {this.v1,this.v2,this.v3,this.v4}
	if(this._IsRoom) then
		allv = {this.p1,this.p2,this.p3,this.p4}
	end
	local start = num % 4
	if(start == 0) then
		start = 4
	end
	for i = start,4 do
		local v = {
			index = i * 2 - 1,
			pos = allv[i],
			gowIndex = i,
		}
		table.insert(this.BettarPos,v);
		local v1 = {
			index = i * 2,
			pos = allv[i],
			gowIndex = i,
		}
		table.insert(this.BettarPos,v1);
		local data = list[i]
		if(data ~= nil) then
			for j=1,#data do
				local card = data[j]
				table.insert(this._openCardList,card)
			end
		end
	end
	for i = 1,start - 1 do
		local v = {
			index = i * 2 - 1,
			pos = allv[i],
			gowIndex = i,
		}
		table.insert(this.BettarPos,v);
		local v1 = {
			index = i * 2,
			pos = allv[i],
			gowIndex = i,
		}
		table.insert(this.BettarPos,v1);
		local data = list[i]
		if(data ~= nil) then
			for j=1,#data do
				local card = data[j]
				table.insert(this._openCardList,card)
			end
		end
	end
	this.SetGowCard()
	local len = #this._allCardList
	for i=1,len do
		local data = this._allCardList[i]
		local go = data.prefab
		if(go ~= nil) then
			local p = i-(this.round - 1)*8
			if(p > 0 and p < 9) then
				data.pos = this.BettarPos[p].index
				data.gowIndex = this.BettarPos[p].gowIndex
				go:GetComponent('TweenPosition').to = Vector3(this.BettarPos[p].pos.x,this.BettarPos[p].pos.y,0);
				go:GetComponent('TweenScale').to = Vector3(1.5,1.7,0)
			end
		end
	end
end

PaiGowCtrl._allCardList = {}
PaiGowCtrl._openCardList = {}
function PaiGowCtrl.OriginCard()
	local parent = PaiGowPanel.paiPanel.transform;
    local bundle = resMgr:LoadBundle("OriginCard");
    local Prefab = resMgr:LoadBundleAsset(bundle,"OriginCard");
    local startPx = -226
    local startPy = 104
    local column = 4
    local space = 23;
	for i = 1, 32 do
		local go = GameObject.Instantiate(Prefab);
		go.name = "OriginCard"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(startPx + math.floor((i - 1) / column) * space, startPy - 8 * ((i - 1) % column), 0);
		local Sprite = go.transform:Find('Sprite');
		Sprite:GetComponent('UISprite').depth = column - ((i - 1) % column);
		resMgr:addAltas(go.transform,"PaiGow")
		local data = {
			prefab = go,
			duration = 0.2,
			pos = 0,
			sign = "GowCard" .. i,
			IsClick = 0,
			gowIndex = i,
		}
		table.insert(this._allCardList,data)
	end
	local data = {
			prefab = nil,
			duration = 0.2,
			pos = 0,
			sign = "",
			IsClick = 0,
			gowIndex = 0,
	}
	table.insert(this._allCardList,data)--多加一个处理动画
end

function PaiGowCtrl.updateMove()
	if(this.isStartMove) then
		local inputPoint = Input.mousePosition;
	    local dist = this.Room:Distance(this.pressPoint.x, this.pressPoint.y, this.pressPoint.z,
		                               inputPoint.x, inputPoint.y, inputPoint.z)

	    if(this.pressPoint.y > inputPoint.y) then
	    	dist = -dist
	    end
    	this.pressPoint = Input.mousePosition
    	local pos = this.curData.transform.localPosition
	    if(math.abs(this.pressVec.y - pos.y) < 130 and math.abs(dist) < 130) then
	    	this.curData.transform.localPosition = Vector3(pos.x,pos.y + dist,0)
	    end
	end
end

PaiGowCtrl.pressPoint = nil
PaiGowCtrl.isStartMove = false
PaiGowCtrl.curData = {}
PaiGowCtrl.pressVec = {}
function PaiGowCtrl.OnGowCardPress(go,isPress)
	local index = tonumber(string.sub(go.name,8,string.len(go.name)))
	if(isPress) then
		this.curData = this._allCardList[index].prefab
		if(this._allCardList[index].IsClick == 1) then
			this.pressVec = this.curData.transform.localPosition
			this.isStartMove = true
			this.pressPoint = Input.mousePosition;
		end
	else
		this.isStartMove = false
		if(this._allCardList[index].IsClick ~= 1 or this._IsCome == false) then
			return
		end
		local cp = this.curData.transform.localPosition
		local pos = this.curData:GetComponent('TweenPosition')
		pos.from = cp
		if(math.abs(this.pressVec.y - cp.y) >= 130) then
			local data = this._allCardList[index - 1]
			local go = data.prefab
			data.IsClick = 2
			local got = go:GetComponent('TweenPosition')
			local goPox = go.transform.localPosition
			got.from = goPox
			got.to = Vector3(goPox.x - 32,goPox.y,0);
			got:ResetToBeginning()
			if(got.enabled == false) then
		    	got.enabled = true
		    end
		    this._allCardList[index].IsClick = 2
		    pos.to = Vector3(goPox.x + 32,goPox.y,0);
		    this.showOpenResult(data.gowIndex,goPox)
		else
			pos.to = this.pressVec;
		end
		pos:ResetToBeginning()
		if(pos.enabled == false) then
	    	pos.enabled = true
	    end
	end
end

function PaiGowCtrl.initAllPos()
	PaiGowPanel.Spritec.transform.localScale = Vector3.one
	PaiGowPanel.Caesar:SetActive(false);
    PaiGowPanel.finalc:SetActive(true);
	this.startDeal = false
	this.endDeal = false
	this.IsopenCard = false
	for i = this._endIndex - 8,this._endIndex-1 do
		local data = this._allCardList[i]
		data.duration = 0.2
		if(data.IsClick < 2) then
			local go = data.prefab
			if(go.transform:Find(data.sign) ~= nil) then
				local sign = go.transform:Find(data.sign).gameObject;
				sign:SetActive(true);
			end
			local Sprite = go.transform:Find('Sprite').gameObject;
			Sprite:SetActive(false);
			local p = i-(this.round - 1)*8
			go.transform.localPosition = Vector3(this.BettarPos[p].pos.x,this.BettarPos[p].pos.y,0);
			go.transform.localScale = Vector3(2.6,2.8,0)
		end
	end
end

function PaiGowCtrl.openAllGow() --打开所有牌
	this._IsCome = false
	this.initAllPos()
    for i = this._endIndex - 8,this._endIndex-1 do
		local data = this._allCardList[i]
		if(data.IsClick == 1) then
			local temp = this._allCardList[i - 1]
			local go1 = temp.prefab
			local got1 = go1:GetComponent('TweenPosition')
			local goPox1 = go1.transform.localPosition
			got1.from = goPox1
			got1.to = Vector3(goPox1.x - 32,goPox1.y,0);
			got1:ResetToBeginning()
			if(got1.enabled == false) then
		    	got1.enabled = true
		    end

		    local go = data.prefab
			local got = go:GetComponent('TweenPosition')
			local goPox = go.transform.localPosition
			got.from = goPox
			got.to = Vector3(goPox.x + 32,goPox1.y,0);
			data.IsClick = 2
			got:ResetToBeginning()
			if(got.enabled == false) then
		    	got.enabled = true
		    end
		    this.showOpenResult(data.gowIndex,goPox1)
		end
	end
end

function PaiGowCtrl.hideOpenGow(oldGow) --隐藏开过的牌
    for i = 1,oldGow do
		local data = this._allCardList[i]
		local go = data.prefab
		go:SetActive(false)
	end
end

PaiGowCtrl.BetEndPos = {{x = -382,y = 198},{x = -342,y = 198},{x = -600,y = 130},{x = -560,y = 130},
{x = -380,y = -232},{x = -340,y = -232},{x = 268,y = 130},{x = 308,y = 130}}
PaiGowCtrl.BetEndPos2 = {{x = 40,y = -224},{x = 80,y = -224},{x = 268,y = 130},{x = 308,y = 130},
{x = 40,y = 206},{x = 80,y = 206},{x = -600,y = 130},{x = -560,y = 130}}
function PaiGowCtrl.normalToLast()
	if(this._endIndex == 0) then
		return
	end
	this.clearRecordList()
	local bp = this.BetEndPos
	if(this._IsRoom) then
		bp = this.BetEndPos2
	end
	for i = this._endIndex - 8,this._endIndex-1 do
		local data = this._allCardList[i]
		local go = data.prefab
		local index = data.pos
		local cp = go.transform.localPosition
		local pos = go:GetComponent('TweenPosition')
		pos.from = cp
		pos.to = Vector3(bp[index].x,bp[index].y,0)
		this.loadLastRecord(i,tonumber(this._openCardList[i-(this.round - 1)*8]),Vector3(bp[index].x,bp[index].y,0),index)
		pos:ResetToBeginning()
		if(pos.enabled == false) then
	    	pos.enabled = true
	    end
	    local scale = go:GetComponent('TweenScale')
	    scale.from = go.transform.localScale
	    scale.to = Vector3(1.3,1.5,0)
		scale:ResetToBeginning()
	    if(scale.enabled == false) then
	    	scale.enabled = true
	    end
	end
	global._view:Invoke(0.2,function ()
		this.hideOpenGow(this._endIndex-1)
	end)
end

PaiGowCtrl.lastRecord = {}
function PaiGowCtrl.loadLastRecord(i,data,pos,index)
	local bundle = resMgr:LoadBundle("GowCard");
	local Prefab = resMgr:LoadBundleAsset(bundle,"GowCard");
	local value = data
    local go = GameObject.Instantiate(Prefab);
	go.name = "GowCardLast" .. i;
	go.transform.parent = PaiGowPanel.paiOld.transform;
	go.transform.localScale = Vector3(0.8,0.8,0);
	go.transform.localPosition = pos
	resMgr:addAltas(go.transform,"PaiGow")
	this.compareGow(value,go)
	local lr = {
		Prefab = go,
		pos = index,
	}
	table.insert(this.lastRecord,lr)
end

function PaiGowCtrl.resertLastRecordPos()
	local len = #this.lastRecord
	if(len == 0) then
		return
	end
	local bp = this.BetEndPos
	if(this._IsRoom) then
		bp = this.BetEndPos2
	end
	for i=1,len do
		local go = this.lastRecord[i]
		local index = go.pos
		go.Prefab.transform.localPosition = Vector3(bp[index].x,bp[index].y,0)
	end
end

function PaiGowCtrl.clearRecordList()
	local len = #this.lastRecord
	for i=1,len do
		local go = this.lastRecord[i]
		panelMgr:ClearPrefab(go.Prefab);
	end
	this.lastRecord = {}
end

PaiGowCtrl.lastGowList = {}
function PaiGowCtrl.initLastGow(list)
	this.clearLastGowList()
	local bundle = resMgr:LoadBundle("GowCard");
	local Prefab = resMgr:LoadBundleAsset(bundle,"GowCard");
	local startX = -82
	local startY = 234
	local spaceH = 50
	local space = 22
	local max = #list
	if(this._IsRoom) then
		startX = -212
		startY = -244
		spaceH = -50
		space = -22
	end
	local column = 12
	for i=1,max do
		local value = list[i]
	    local go = GameObject.Instantiate(Prefab);
		go.name = "GowCardOld" .. i;
		go.transform.parent = PaiGowPanel.paiOld.transform;
		go.transform.localScale = Vector3(0.55,0.55,0);
		go.transform.localPosition = Vector3(startX + ((i - 1) % column)* space, startY - spaceH * math.floor((i - 1) / column) ,0)
		resMgr:addAltas(go.transform,"PaiGow")
		this.compareGow(tonumber(value),go)
		table.insert(this.lastGowList,go)
	end
end

function PaiGowCtrl.clearLastGowList()
	local len = #this.lastGowList
	for i=1,len do
		local go = this.lastGowList[i]
		panelMgr:ClearPrefab(go);
	end
	this.lastGowList = {}
end

PaiGowCtrl.round = 0
function PaiGowCtrl.SetGowCard()
	local len = #this._allCardList;
	if(len == 0) then
		return
	end
	this._startIndex = (this.round - 1) * 8 + 1
	this._endIndex = this.round * 8 + 1
	for i = this._startIndex,this._endIndex - 1 do
		local data = this._allCardList[i]
		local pp = data.prefab
		data.IsClick = 0
		if(i % 2 == 0) then
			pp = data.prefab.transform:Find('panel')
			local ppl = pp:GetComponent('UIPanel')
			ppl.depth = 13
			ppl.sortingOrder = 10
			data.sign = "panel/GowCard" .. i
			data.IsClick = 1
		else
			pp = data.prefab.transform:Find('panel')
			local ppl = pp:GetComponent('UIPanel')
			ppl.depth = 12
			ppl.sortingOrder = 10
			data.sign = "panel/GowCard" .. i
		end

		this.addOpenCard(pp.transform,i,this._openCardList[i-(this.round - 1)*8])
	end
end

PaiGowCtrl._gowCradList = {}
function PaiGowCtrl.addOpenCard(parent,index,value)
	local ran = math.random(-1,1)
	if(ran == 0) then
		ran = 1
	end
    local bundle = resMgr:LoadBundle("GowCard");
    local Prefab = resMgr:LoadBundleAsset(bundle,"GowCard");
    local go = GameObject.Instantiate(Prefab);
	go.name = "GowCard" .. index;
	go.transform.parent = parent;
	go.transform.localScale = Vector3(0.6,0.55*ran,0);
	go.transform.localPosition = Vector3.zero
	this.Room:AddOnPress(go, this.OnGowCardPress);
	resMgr:addAltas(go.transform,"PaiGow")
	this.compareGow(tonumber(value),go)
	go:SetActive(false);
	table.insert(this._gowCradList,go)
end

function PaiGowCtrl.compareGow(value,go)
	if(value == 1) then
		local six_redbig = go.transform:Find('six_redbig').gameObject;
		six_redbig:SetActive(true);
	elseif(value == 2) then
		local three = go.transform:Find('three').gameObject;
		three:SetActive(true);
	elseif(value == 3) then
		local nine_red = go.transform:Find('nine_red').gameObject;
		nine_red:SetActive(true);
	elseif(value == 4) then
		local nine = go.transform:Find('nine').gameObject;
		nine:SetActive(true);
	elseif(value == 5) then
		local eight_big = go.transform:Find('eight_big').gameObject;
		eight_big:SetActive(true);
	elseif(value == 6) then
		local eight = go.transform:Find('eight').gameObject;
		eight:SetActive(true);
	elseif(value == 7) then
		local seven_redbig = go.transform:Find('seven_redbig').gameObject;
		seven_redbig:SetActive(true);
	elseif(value == 8) then
		local seven = go.transform:Find('seven').gameObject;
		seven:SetActive(true);
	elseif(value == 9) then
		local five_red = go.transform:Find('five_red').gameObject;
		five_red:SetActive(true);
	elseif(value == 10) then
		local five = go.transform:Find('five').gameObject;
		five:SetActive(true);
	elseif(value == 11) then
		local twelve = go.transform:Find('twelve').gameObject;
		twelve:SetActive(true);
	elseif(value == 12) then
		local two = go.transform:Find('two').gameObject;
		two:SetActive(true);
	elseif(value == 13) then
		local eight_redbig = go.transform:Find('eight_redbig').gameObject;
		eight_redbig:SetActive(true);
	elseif(value == 14) then
		local four_red = go.transform:Find('four_red').gameObject;
		four_red:SetActive(true);
	elseif(value == 15) then
		local ten = go.transform:Find('ten').gameObject;
		ten:SetActive(true);
	elseif(value == 16) then
		local six = go.transform:Find('six').gameObject;
		six:SetActive(true);
	elseif(value == 17) then
		local four = go.transform:Find('four').gameObject;
		four:SetActive(true);
	elseif(value == 18) then
		local eleven = go.transform:Find('eleven').gameObject;
		eleven:SetActive(true);
	elseif(value == 19) then
		local ten_red = go.transform:Find('ten_red').gameObject;
		ten_red:SetActive(true);
	elseif(value == 20) then
		local seven_red = go.transform:Find('seven_red').gameObject;
		seven_red:SetActive(true);
	elseif(value == 21) then
		local six_red = go.transform:Find('six_red').gameObject;
		six_red:SetActive(true);
	end
end

function PaiGowCtrl.clearGowCard()
	local len = #this._gowCradList
	for i=1,len do
		local data = this._gowCradList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._gowCradList = {}
end

function PaiGowCtrl.clearAllCard()
	this.clearGowCard()
	local len = #this._allCardList
	for i=1,len do
		local data = this._allCardList[i]
		if(data.prefab ~= nil) then
			panelMgr:ClearPrefab(data.prefab);
		end
	end
	this._allCardList = {}
end

function PaiGowCtrl.hideAllLeft()
	for i=1,#this.leftAll do
		this.leftAll[i]:SetActive(false);
	end
end

PaiGowCtrl.IsopenCard = false
PaiGowCtrl.roll = 0
function PaiGowCtrl.CardAnima()
	if(this.IsopenCard == false) then
		return
	end
    if(this.Speed <= 0.08) then
        this.Speed = this.Speed + Time.deltaTime
    else
        this.Speed = 0
        this.roll = this.roll + 1
        PaiGowPanel.Caesar_UISprite.spriteName = this.roll
        PaiGowPanel.Caesar_UISprite:MakePixelPerfect();
        PaiGowPanel.Caesar_UISprite.transform.localScale = Vector3(0.5,0.5,0);
        if(this.roll == 25) then
        	this.IsopenCard = false
        	PaiGowPanel.Caesar:SetActive(false);
        	PaiGowPanel.finalc:SetActive(true);
		    global._view:Invoke(1,function ()
	        	this.startDeal = true
	        	this.endDeal = true
				PaiGowPanel.Spritec_TweenScale.from = Vector3(2,2,0);
				PaiGowPanel.Spritec_TweenScale.to = Vector3.one
				PaiGowPanel.Spritec_TweenScale:ResetToBeginning()
			    if(PaiGowPanel.Spritec_TweenScale.enabled == false) then
			    	PaiGowPanel.Spritec_TweenScale.enabled = true
			    end
			end)
        end
    end
end

function PaiGowCtrl.BetBtnColor(color)
	PaiGowPanel.betfive_UISprite.color = color
	PaiGowPanel.betten_UISprite.color = color
	PaiGowPanel.bethund_UISprite.color = color
	PaiGowPanel.betkilo_UISprite.color = color
	PaiGowPanel.bettenshou_UISprite.color = color
	PaiGowPanel.betmill_UISprite.color = color
end

PaiGowCtrl._allBetCoin = 0
PaiGowCtrl._totalBetCoin = 0
PaiGowCtrl._IsAllBet = false
function PaiGowCtrl.OnBetBtn(go)
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.OX_STATUS_BET) then
		return
	end
	if(this._IsRoom) then
		return
	end
	if(this._totalBetCoin >= this._PlayermaxCoin) then
		return
	end
	local coin = 0
	local betType = 1
	if(go.name == "betfive") then --10
		coin = 10
		betType = 1
	elseif(go.name == "betten") then --50
		coin = 50
		betType = 2
	elseif(go.name == "bethund") then --100
		coin = 100
		betType = 3
	elseif(go.name == "betkilo") then --500
		coin = 500
		betType = 4
	elseif(go.name == "bettenshou") then --1000
		coin = 1000
		betType = 5
	elseif(go.name == "betmill") then --5000
		coin = 5000
		betType = 6
	end
	local max = this._allBetCoin + coin
	if(max > this._PlayermaxCoin - this._totalBetCoin) then
		PaiGowPanel.setTip("已达到当局最大下注")
		return
	end
	if(max > this._playerCoin) then
		PaiGowPanel.setTip("钱不够咯")
		return
	end
	this.initBetPiece(betType)
	this._allBetCoin = this._allBetCoin + coin
	PaiGowPanel.BetCoin_UILabel.text = this._allBetCoin
end

function PaiGowCtrl.BetFillCallBack(totalCoin)
	this.betFillAnima(this.choicePos)
	this.choicePos = 0
	this._totalBetCoin = totalCoin
	this._allBetCoin = 0;
	PaiGowPanel.BetCoin_UILabel.text = 0
	this.hideAllLeft()
end

PaiGowCtrl._betpieceList = {}
PaiGowCtrl._betpiecetype = {}
function PaiGowCtrl.initBetPiece(cointype)
	local len = #this._betpiecetype
	local isexit = false
	for i=1,len do
		if(cointype == this._betpiecetype[i]) then
			isexit = true
			break
		end
	end
	if(isexit) then
		return
	end
	table.insert(this._betpiecetype,cointype)
	local bundle = resMgr:LoadBundle("GowPiece");
    local Prefab = resMgr:LoadBundleAsset(bundle,"GowPiece");
    local go = GameObject.Instantiate(Prefab);
	go.name = "GowPiece" .. #this._betpieceList;
	go.transform.parent = PaiGowPanel.CoinAnima.transform;
	go.transform.localScale = Vector3.one;
	go.transform.localPosition = Vector3(this.BetStartPos[cointype].x,this.BetStartPos[cointype].y,0)
	local pieceType = go.transform:Find('pieceType').gameObject;
	local pieceType_UISprite = pieceType:GetComponent('UISprite');
	pieceType_UISprite.spriteName = "youbiandikuang_chouma_" .. cointype
	local pos = go:GetComponent('TweenPosition')
	pos.from = Vector3(this.BetStartPos[cointype].x,this.BetStartPos[cointype].y,0)
	resMgr:addAltas(go.transform,"PaiGow")
	table.insert(this._betpieceList,go)
end

function PaiGowCtrl.clearBetPiece()
	local len = #this._betpieceList
	for i=1,len do
		local data = this._betpieceList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._betpieceList = {}
end

PaiGowCtrl.BetStartPos = {{x = 397,y = 2},{x = 493,y = 2},{x = 586,y = 2},
{x = 397,y = -87},{x = 493,y = -87},{x = 586,y = -87}}

PaiGowCtrl.BetAreaPos = {{x = -324,y = -14},{x = -510,y = -14},{x = -147,y = -96},
{x = -147,y = -211},{x = 26,y = -14},{x = 227,y = -14}}
function PaiGowCtrl.betFillAnima(betPos)
	if(betPos == 0) then
		return
	end
	local startx = this.BetAreaPos[betPos].x
	local starty = this.BetAreaPos[betPos].y
    local len = #this._betpieceList
    local mlen = #this._betpiecetype
    for i=len - mlen + 1,len do
    	local go = this._betpieceList[i]
    	if(go ~= nil) then
    		-- local p = resMgr:getRandomUnitCircle()*30;
		    -- local pos = p.normalized*(20+p.magnitude);
		    local pi = math.pi
		  	local rand_r = math.random(0,50) -- 随机半径
			local rand_angle = math.random(0,360) -- 随机方向 0 - 360度
			local x = math.sin(  rand_angle * pi / 180 ) * rand_r;
			local y = math.cos(  rand_angle * pi / 180) * rand_r;
		    local pos = Vector3(x,y,0)
		    local pos2 = Vector3(startx + pos.x,starty + pos.y,0);
	    	local tpos = go:GetComponent('TweenPosition')
	    	tpos.to = pos2
	    	tpos:ResetToBeginning()
			if(tpos.enabled == false) then
		    	tpos.enabled = true
		    end
    	end
    end
    this._betpiecetype = {}
end

function PaiGowCtrl.OnInvite()
	if(this.IsGameRoom) then
		return
	end
	global.player:get_mgr("room"):req_invite_join_room(this._const.GAME_ID_PAIGOW,this.RoomId)
end

function PaiGowCtrl.closeShowUI()
	if(this._uiPreant ~= nil) then
		panelMgr:ClearPrefab(this._uiPreant);
		this._uiPreant = nil;
	end
	this.closeBalanceList()
	PaiGowPanel.uibox:SetActive(false)
	PaiGowPanel.balanceEnter:SetActive(false)
end

function PaiGowCtrl.timeEvent()
	this.FreeTimeEvent()
	this.dealCardTime()
	this.CardAnima()
	this.updateBalanceScore()
	this.updateMove()
end

PaiGowCtrl._IsCome = false;
-- PaiGowCtrl._autoCard = false;
PaiGowCtrl._FreeTime = 0;
function PaiGowCtrl.FreeTimeEvent()
  	if(this._FreeTime > 0) then
        local time = this._FreeTime - PaiGowPanel.getTime()
        if(time >= 0) then
        	local hours = math.floor(time / 3600);
			time = time - hours * 3600;
			local minute = math.floor(time / 60);
			time = time - minute * 60;
			if(time <= 2 and this._curState == this._const.PAIGOW_STATUS_OPEN and this._IsCome) then
				this.openAllGow()
			end
            PaiGowPanel.timeTxt_UILabel.text = GameData.changeFoLimitTime(time);
        else
            this._FreeTime = 0;
            PaiGowPanel.timeTxt_UILabel.text = 0
        end
    end
end

function PaiGowCtrl.OnShare()
	this.showUIprefab("shareUI")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "shareUIbar") then
			local sharefriend = this._uiPreant.transform:Find('sharefriend').gameObject;
			this.Room:AddClick(sharefriend, function ()
				local desc = "同时200人在线牌九,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "牌九[房号:" .. this.RoomId .. "]"
				if(this.IsGameRoom) then
					desc = "同时200人在线牌九,您的好友邀请您进入游戏"
					title = "牌九[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(1,desc,"",title)
			end);
			local shareall = this._uiPreant.transform:Find('shareall').gameObject;
			this.Room:AddClick(shareall, function ()
				local desc = "同时200人在线牌九,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "牌九[房号:" .. this.RoomId .. "]"
				if(this.IsGameRoom) then
					desc = "同时200人在线牌九,您的好友邀请您进入游戏"
					title = "牌九[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(0,desc,"",title)
			end);
		end
	end
end

function PaiGowCtrl.OnPlayerList()
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.PAIGOW_STATUS_OPEN) then
		PaiGowPanel.getPlayerList()
	else
		local str = i18n.TID_COMMON_STATISTC_DATA
		PaiGowPanel.setTip(str)
	end
end

PaiGowCtrl._uiPreant = nil
PaiGowCtrl._uiname = ""
PaiGowCtrl._robBet = 1
function PaiGowCtrl.OnRob(go)
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.PAIGOW_STATUS_BANKER) then
		this._robData = nil
		return
	end
	if(this._robData == nil) then
		PaiGowPanel.getRobInfo()
	else
		this.robCallBack(this._robData)
	end
end

PaiGowCtrl._robData = nil
function PaiGowCtrl.robCallBack(data)
	if(this._curState == this._const.PAIGOW_STATUS_BANKER) then --抢庄
		this.showUIprefab("robUI")
		if(this._uiPreant ~= nil) then
			if(this._uiPreant.name == "robUIbar") then
				this._robData = data
				local robOk = this._uiPreant.transform:Find('robOk').gameObject;
				local bottomLine = this._uiPreant.transform:Find('bottomLine').gameObject;
				bottomLine:GetComponent('UISprite').height = 310
				bottomLine.transform.localPosition = Vector3(-225,-87,0);
				local allLabel = this._uiPreant.transform:Find('allLabel').gameObject;
				allLabel:SetActive(false)
				local leftall = this._uiPreant.transform:Find('leftall').gameObject;
				leftall.transform.localPosition = Vector3(75,0,0);
				local allInput = this._uiPreant.transform:Find('allInput').gameObject;
				allInput:SetActive(false)
				this.Room:AddClick(robOk, function ()
					if(this._robBet == 0) then
						PaiGowPanel.setTip("抢庄金额不能低于1")
						return
					end
					PaiGowPanel.robData(this._robBet)
				end);
				local minscore = tonumber(data.banker_min_coin)
				local maxscore = tonumber(data.player_max_coin)
				if(data.player_max_coin == "") then
					maxscore = 0
				end
				if(data.banker_min_coin == "") then
					minscore = 0
				end
				local text =  string.format(i18n.TID_BANKER_INFO,minscore,maxscore)
                this._uiPreant.transform:Find('hint'):GetComponent('UILabel').text =text
				-- this._uiPreant.transform:Find('hint'):GetComponent('UILabel').text =
				-- "提示：庄家最低"..minscore.."分以上才能抢庄设置玩家最高不能超过" .. maxscore
				local minInput = this._uiPreant.transform:Find('minInput').gameObject;
				local minpos = minInput.transform.localPosition
				minInput.transform.localPosition = Vector3(minpos.x + 75,minpos.y,0);
				local maxInput = this._uiPreant.transform:Find('maxInput').gameObject;
				local maxpos = maxInput.transform.localPosition
				maxInput.transform.localPosition = Vector3(maxpos.x + 75,maxpos.y,0);
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

function PaiGowCtrl.showUIprefab(name)
	PaiGowPanel.uibox:SetActive(true)
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
	this._uiPreant.transform.parent = PaiGowPanel.showUI.transform;
	this._uiPreant.transform.localScale = Vector3.one;
	this._uiPreant.transform.localPosition = Vector3.zero;
	resMgr:addAltas(this._uiPreant.transform,"Room")
end

function PaiGowCtrl.OnBack(go)
	local str =i18n.TID_COMMON_BACK_GAME
	global._view:support().Awake(str,function ()
       	soundMgr:PlaySound("go")
		PaiGowPanel.backNiuniu(this.IsGameRoom)
	   end,function ()

   	end);
end

PaiGowCtrl._bigshow = nil
function PaiGowCtrl.ShowBigTime(isdaoban)
	local bundle = resMgr:LoadBundle("bigshow");
	local Prefab = resMgr:LoadBundleAsset(bundle,"bigshow");
	this._bigshow = GameObject.Instantiate(Prefab);
	this._bigshow.name = "bigshowbar";
	this._bigshow.transform.parent = PaiGowPanel.Tips.transform;
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
	
	if (this._curState == this._const.PAIGOW_STATUS_BANKER) then
		prob:SetActive(true)
	elseif (this._curState == this._const.PAIGOW_STATUS_BET) then
		pbet:SetActive(true)
	elseif (this._curState == this._const.PAIGOW_STATUS_OPEN) then
		popen:SetActive(true)
	end
end

function PaiGowCtrl.clearBigShow()
	if(this._bigshow ~= nil) then
		panelMgr:ClearPrefab(this._bigshow);
	end
	this._bigshow = nil
end

PaiGowCtrl._openResultList = {}
function PaiGowCtrl.showOpenResult(index,vec)
	local len = #this._openResultList
	local isexit = false
	for i=1,len do
		local data = this._openResultList[i]
		if(data.pos == index) then
			isexit = true
			break
		end
	end
	local gowdata = {this.robPoint[index][1],this.robPoint[index][2]}
	local name = PaiGowPanel.getGowName(gowdata)
	if(isexit or name == "" or name == nil) then
		return
	end
	local bundle = resMgr:LoadBundle("openResult");
    local Prefab = resMgr:LoadBundleAsset(bundle,"openResult");
    local go = GameObject.Instantiate(Prefab);
	go.name = "openResult" .. index;
	go.transform.parent = PaiGowPanel.resultAnima.transform;
	go.transform.localScale = Vector3.one;
	if(vec.y < -150) then
		go.transform.localPosition = Vector3(vec.x,vec.y + 100,0)
	else
		go.transform.localPosition = Vector3(vec.x,vec.y - 100,0)
	end
	resMgr:addAltas(go.transform,"PaiGow")
	local gowTxt = go.transform:Find("gowTxt"):GetComponent('UILabel');
	gowTxt.text = name
	local data = {
		prefab = go,
		pos = index,
	}
	table.insert(this._openResultList,data)
end

function PaiGowCtrl.clearOpenResult()
	local len = #this._openResultList
	for i=1,len do
		local data = this._openResultList[i]
		panelMgr:ClearPrefab(data.prefab);
	end
	this._openResultList = {}
end

function PaiGowCtrl.updatePattern(playtype,bout,amount)
	PaiGowPanel.Patnumber_UILabel.text = bout
	if(playtype == 1) then --自由抢庄
		PaiGowPanel.allpattern:SetActive(false)
		PaiGowPanel.Patnumber.transform.localPosition = Vector3(0,-3,0);
		PaiGowPanel.Pattype_UILabel.text = "自由抢庄"
	else
		PaiGowPanel.allpattern:SetActive(true)
		PaiGowPanel.Patnumber.transform.localPosition = Vector3(-23,-3,0);
		PaiGowPanel.PatsumNumber_UILabel.text = amount
		PaiGowPanel.Pattype_UILabel.text = "抢庄模式"
	end
end

PaiGowCtrl._const = nil
PaiGowCtrl._cards = ""
PaiGowCtrl._curState = 0
PaiGowCtrl._playerCoin = 0
PaiGowCtrl._betCoin = 0
PaiGowCtrl._IsOpenGame = false
PaiGowCtrl._RoomCreate = ""
function PaiGowCtrl.Init(data,const,liuju,daobang)
	this._const = const
	this._RoomCreate = data.house_owner_name
	if(this.IsGameRoom == false) then
		PaiGowPanel.roomId_UILabel.text = "房主:" .. GameData.GetShortName(this._RoomCreate,12,10) .. "\n房间号:" .. this.RoomId
		PaiGowPanel.Pattern:SetActive(true)
		this.updatePattern(data.play_type,data.bout,data.bout_amount)
	else
		PaiGowPanel.Pattern:SetActive(false)
		PaiGowPanel.roomId_UILabel.text = this.RoomTitle
	end
	this._IsRoom = false
	PaiGowPanel.PlayerIcon_AsyncImageDownload:SetAsyncImage(PaiGowPanel.getPlayerImg())
	if data.banker_name == PaiGowPanel.getPlayerName() then
		this._IsRoom = true
	end
	if(data.game_status ~= this._const.PAIGOW_STATUS_FREE) then-- and this._IsRoom == false
		this._IsOpenGame = true
		PaiGowPanel.fristenter:SetActive(true)
		-- if data.game_status == this._const.PAIGOW_STATUS_BET then
		-- 	if data.banker_name == PaiGowPanel.getPlayerName() then
		-- 		this._IsOpenGame = false
		-- 		PaiGowPanel.fristenter:SetActive(false)
		-- 	end
		-- end
	end
	this.OriginCard();
	if(data.use_cards ~= nil and #data.use_cards > 0) then
		local len = #data.use_cards
		this.round = len / 8 + 1
		this.initLastGow(data.use_cards)
		local list = data.last_card
		local bp = this.BetEndPos
		if(this._IsRoom) then
			bp = this.BetEndPos2
		end
		local m = 0
		for i=1,#list do
			local mp = list[i]
			for j=1,#mp do
				m = m + 1
				this.loadLastRecord(m,tonumber(mp[j]),Vector3(bp[m].x,bp[m].y,0),m)
			end
		end
	else
		this.round = 1
	end
	this.updatePlayerIsRoom()
	this._curState = data.game_status
	if(this._curState ~= this._const.PAIGOW_STATUS_OPEN) then
		this.updateBetState(data,liuju,daobang)
	else
		this.updatePlayerInfo()
		PaiGowPanel.push:SetActive(false)
		PaiGowPanel.backOut:SetActive(false)
		this._FreeTime = data.over_time
		PaiGowPanel.robHead:SetActive(true)
		PaiGowPanel.rob:SetActive(false)
		PaiGowPanel.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
		local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n全场最高下注:" .. this._PlayermaxCoin
		PaiGowPanel.bankerName_UILabel.text = bstr
		PaiGowPanel.BetState_UILabel.text = "开牌"
		this.openAnimaShow(data)
	end
end

PaiGowCtrl._IsRoom = false
PaiGowCtrl._bankerPoint = 0
PaiGowCtrl._PlayermaxCoin = 0
PaiGowCtrl._IsLiuju = 0
function PaiGowCtrl.updateBetState(data,liuju,daobang)
	if(this._const == nil) then
		return
	end
	this._FreeTime = data.over_time
	this._curState = data.game_status
	local bet = ""
	PaiGowPanel.tiprob:SetActive(false)
	PaiGowPanel.rob_UISprite.color = Color.gray
	PaiGowPanel.robBg_UISprite.color = Color.gray
	PaiGowPanel.Spritec.transform.localScale = Vector3.one
	PaiGowPanel.robEffect:SetActive(false)
	this.BetBtnColor(Color.gray)
	this.clearBigShow()
	this.hideAllLeft()
	this._IsLiuju = 0
	this._robData = nil
	this.IsopenCard = false
	this.closeShowUI()
	-- this._IsRoom = false
	PaiGowPanel.Caesar:SetActive(true);
    PaiGowPanel.finalc:SetActive(false);
	PaiGowPanel.paiBox:SetActive(true)
	PaiGowPanel.push:SetActive(false)
	PaiGowPanel.backOut:SetActive(false)
	if(this._curState ~= this._const.PAIGOW_STATUS_OPEN) then
		PaiGowPanel.rob:SetActive(true)
		PaiGowPanel.robHead:SetActive(false)
	end
	if(this._curState == this._const.PAIGOW_STATUS_FREE) then --空闲时间
		this._IsLiuju = liuju
		this.updateBankerInfo(data,0)
		this.clearBetPiece()
		if(this._IsLiuju == 1) then
			soundMgr:PlaySound("liuju")
			this.ShowBigTime(false)
		end
		if(daobang) then
			this.ShowBigTime(daobang)
		end
		this.updateBetAreaCoin()
		this.updatePlayerInfo()
		-- if(this._uiPreant ~= nil) then
		-- 	if(this._uiPreant.name == "robUIbar") then
		-- 		this.closeShowUI()
		-- 	end
		-- end
		if(data.banker_name ~= nil and data.banker_name ~= "") then
			PaiGowPanel.rob:SetActive(false)
			PaiGowPanel.robHead:SetActive(true)
			PaiGowPanel.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
			local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n全场最高下注:" .. this._PlayermaxCoin
			PaiGowPanel.bankerName_UILabel.text = bstr
		end
		PaiGowPanel.Patnumber_UILabel.text = data.bout
		this._totalBetCoin = 0
		this._PlayermaxCoin = 0
		this._IsOpenGame = false
		PaiGowPanel.fristenter:SetActive(false)
		PaiGowPanel.BetCoin_UILabel.text = 0
		this._allBetCoin = 0;
		bet = "空闲"
	elseif(this._curState == this._const.PAIGOW_STATUS_BANKER) then --抢庄时间
		this.clearOpenResult()
		this.updatePlayerInfo()
		this.updateBetAreaCoin()
		this.clearBetPiece()
		this._PlayermaxCoin = 0
		this._totalBetCoin = 0
		PaiGowPanel.bankerName_UILabel.text = "庄家:待定\n全场最高下注:0"
		PaiGowPanel.BetCoin_UILabel.text = 0
		this._allBetCoin = 0;
		this.round = 1
		this._IsRoom = false
		this.updatePlayerIsRoom()
		bet = "请抢庄"
		if(this._IsOpenGame == false) then
			soundMgr:PlaySound("prob")
			this.ShowBigTime(false)
			PaiGowPanel.tiprob:SetActive(true)
			PaiGowPanel.rob_UISprite.color = Color.white
			PaiGowPanel.robBg_UISprite.color = Color.white
			PaiGowPanel.robEffect:SetActive(true)
		end
	elseif(this._curState == this._const.PAIGOW_STATUS_BET) then --下注时间
		-- this.hideOpenGow(this.round * 8)
		this.clearOpenResult()
		this.updatePlayerInfo()
		this.updateBetAreaCoin()
		this.closeShowUI()
		this.clearBetPiece()
		this._IsRoom = false
		bet = "请下注"
		if(data.banker_name == PaiGowPanel.getPlayerName()) then --自己是不是庄家
			this._IsRoom = true
			soundMgr:PlaySound("merob")
		else
			if(this._IsOpenGame == false) then
				soundMgr:PlaySound("pbet")
				this.ShowBigTime(false)
				this.BetBtnColor(Color.white)
				PaiGowPanel.paiBox:SetActive(false)
			end
		end
		this.updatePlayerIsRoom()
		this._PlayermaxCoin = data.player_max_coin
		PaiGowPanel.rob:SetActive(false)
		PaiGowPanel.robHead:SetActive(true)
		PaiGowPanel.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
		local bstr = "庄家:" .. GameData.GetShortName(data.banker_name,14,14) .. "\n全场最高下注:" .. this._PlayermaxCoin
		PaiGowPanel.bankerName_UILabel.text = bstr
	elseif(this._curState == this._const.PAIGOW_STATUS_OPEN) then --开牌时间
		if(global._view:getViewBase("Rule") ~= nil) then
		 	global._view:getViewBase("Rule").OnDestroy()
		end
		if(global._view:getViewBase("Bank") ~= nil) then
		 	global._view:getViewBase("Bank").OnDestroy()
		end
		if(global._view:getViewBase("PlayerList")~=nil)then
			global._view:getViewBase("PlayerList").clearView();
		end
		this.clearOpenResult()
		bet = "开牌"
		this.openAnimaShow(data)
	    local len = #data.bet_users
	    this._userBetVec = {}
	    for i=1,len do
			local bankerInfo = data.bet_users[i]
			local name = bankerInfo.player_name
			local vec = {
				betusers = bankerInfo,
				Isopen = 0,
				playerId = bankerInfo.playerid,
			}
			table.insert(this._userBetVec,vec)
		end
	end
	PaiGowPanel.BetState_UILabel.text = bet
end

function PaiGowCtrl.openAnimaShow(data)
	this._IsCome = true
	this._totalBetCoin = 0
	this.Speed = 0
	local list = data.bet_area_cards
	if(list ~= nil) then
		local num = data.dices[1] + data.dices[2] + data.dices[3]
		PaiGowPanel.finalc1_UISprite.spriteName = "c_" .. tonumber(data.dices[1])
		PaiGowPanel.finalc2_UISprite.spriteName = "c_" .. tonumber(data.dices[2])
		PaiGowPanel.finalc3_UISprite.spriteName = "c_" .. tonumber(data.dices[3])
		this.SetPaiStarOrEnd(num,list)
		local time = this._FreeTime - PaiGowPanel.getTime()
        local hours = math.floor(time / 3600);
		time = time - hours * 3600;
		local minute = math.floor(time / 60);
		time = time - minute * 60;
		if(time > 5) then
			this.roll = 0 --开始摇撒子
			this.IsopenCard = true
			soundMgr:PlaySound("paigow_touzi")
			PaiGowPanel.Spritec_TweenScale.from = Vector3.one
			PaiGowPanel.Spritec_TweenScale.to = Vector3(2,2,0);
			PaiGowPanel.Spritec_TweenScale:ResetToBeginning()
		    if(PaiGowPanel.Spritec_TweenScale.enabled == false) then
		    	PaiGowPanel.Spritec_TweenScale.enabled = true
		    end
		elseif(time > 2 and time <= 5) then
			PaiGowPanel.Caesar:SetActive(false);
        	PaiGowPanel.finalc:SetActive(true);
        	this.startDeal = true
        	this.endDeal = true
		end
	end
end

function PaiGowCtrl.updateBankerInfo(data,op_type)--1:下庄 2:推倒
	this._IsRoom = false
	PaiGowPanel.bankerName_UILabel.text = "庄家:无\n全场最高下注:0"
	if(data.banker_name == PaiGowPanel.getPlayerName()) then
		this._IsRoom = true
		PaiGowPanel.push:SetActive(true)
		PaiGowPanel.backOut:SetActive(true)
	end
	if(op_type == 1) then
		this.clearLastGowList()
		PaiGowPanel.Patnumber_UILabel.text = data.bout
	elseif(op_type == 2) then
		this.clearLastGowList()
	end
	local num = 1
	if(data.use_cards ~= nil) then
		local len = #data.use_cards
		if(len > 0) then
			num = len / 8 + 1
			this.initLastGow(data.use_cards)
		else
			this.clearLastGowList()
		end
	else
		this.clearLastGowList()
	end
	if(num ~= this.round) then
		this.normalToLast()
		this.round = num
		if(this._userBetVec ~= nil) then
			if(#this._userBetVec > 0) then
				this.ShowBalance(this._userBetVec)
				this._userBetVec = nil
			end
		end
	else
		this.updatePlayerIsRoom()
	end
end

PaiGowCtrl.ScorePosv = {{x = 77,y = -172},{x = -355,y = 215}}--b1
PaiGowCtrl.ScorePos = {{x = -146,y = -58},{x = -146,y = 110}}--h1
PaiGowCtrl.leftPos2 = {x = 178,y = 117}--b2
PaiGowCtrl.leftPos3 = {x = -475,y = 117}--b3
PaiGowCtrl.rightPos2 = {x = -48,y = -12}--h2
PaiGowCtrl.rightPos3 = {x = -246,y = -12}--h3
function PaiGowCtrl.updatePlayerIsRoom()
	this.resertLastRecordPos()
	this.clearGowCard()
	local len = #this._allCardList
	local startPx = -226
    local startPy = 104
    local column = 4
    local space = 23;
    local tag = 1
	if(this._IsRoom) then
		startPy = -104
		PaiGowPanel.noRobback:SetActive(false)
		PaiGowPanel.Robback:SetActive(true)
		tag = 2
		PaiGowPanel.b2.transform.localPosition = Vector3(this.leftPos3.x,this.leftPos3.y,0)
		PaiGowPanel.h2.transform.localPosition = Vector3(this.rightPos3.x,this.rightPos3.y,0)
		PaiGowPanel.b3.transform.localPosition = Vector3(this.leftPos2.x,this.leftPos2.y,0)
		PaiGowPanel.h3.transform.localPosition = Vector3(this.rightPos2.x,this.rightPos2.y,0)
	else
		PaiGowPanel.noRobback:SetActive(true)
		PaiGowPanel.Robback:SetActive(false)
		PaiGowPanel.b2.transform.localPosition = Vector3(this.leftPos2.x,this.leftPos2.y,0)
		PaiGowPanel.h2.transform.localPosition = Vector3(this.rightPos2.x,this.rightPos2.y,0)
		PaiGowPanel.b3.transform.localPosition = Vector3(this.leftPos3.x,this.leftPos3.y,0)
		PaiGowPanel.h3.transform.localPosition = Vector3(this.rightPos3.x,this.rightPos3.y,0)
	end

	PaiGowPanel.b1.transform.localPosition = Vector3(this.ScorePosv[tag].x,this.ScorePosv[tag].y,0)
	PaiGowPanel.h1.transform.localPosition = Vector3(this.ScorePos[tag].x,this.ScorePos[tag].y,0)
	for i=1,len do
		local data = this._allCardList[i]
		local go = data.prefab
		if(go ~= nil) then
			if(i > (this.round - 1) * 8) then
				if(go.transform:Find(data.sign) ~= nil) then
					local sign = go.transform:Find(data.sign).gameObject;
					sign:SetActive(false);
				end
				local Sprite = go.transform:Find('Sprite').gameObject;
				Sprite:GetComponent('UISprite').depth = column - ((i - 1) % column);
				Sprite:SetActive(true);
				local pos = go:GetComponent('TweenPosition')
				pos.enabled = false
				local scale = go:GetComponent('TweenScale')
				scale.enabled = false
				go.transform.localScale = Vector3.one
				go.transform.localPosition = Vector3(startPx + math.floor((i - 1) / column) * space, startPy - 8 * ((i - 1) % column), 0);
				go:SetActive(true)
			else
				go:SetActive(false)
			end
		end
	end
end

PaiGowCtrl._curBetPoint = 0
PaiGowCtrl._curBetType = 0
function PaiGowCtrl.updatePlayerInfo()
	if(global._view:getViewBase("Support")~=nil)then
		global._view:getViewBase("Support").clearView();
	end
	this._playerCoin = PaiGowPanel.getPlayerCoin() + PaiGowPanel.getPlayerRMB()
	PaiGowPanel.playerCoin_UILabel.text = PaiGowPanel.getPlayerRMB()-- this._betCoin
	PaiGowPanel.playerSilver_UILabel.text = PaiGowPanel.getPlayerCoin()
	this._betCoin = 0
	PaiGowPanel.playerName_UILabel.text = GameData.GetShortName(PaiGowPanel.getPlayerName(),14,12) .. "\nID:" .. PaiGowPanel.getPlayerId()
end

PaiGowCtrl._playScore = 0
PaiGowCtrl.Speed = 0
function PaiGowCtrl.updateBalanceScore()
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

PaiGowCtrl._scoreLen = 0
function PaiGowCtrl.getScoreValue()
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

function PaiGowCtrl.getZeroNum(len)
	local num = 1
	for i=1,len - 1 do
		num = num * 10
	end
	return num
end

PaiGowCtrl._finalVec = {}
function PaiGowCtrl.getScoreFinal()
	this._finalVec = {}
	local len = string.len(this._maxScore)
	this._scoreLen = len
	for i=1,len do
		local value = string.sub(this._maxScore, -i,len - (i-1))
		table.insert(this._finalVec,value)
	end
end

PaiGowCtrl._startScore = 0;
PaiGowCtrl._maxScore = 0;
PaiGowCtrl._startAnima = false;
PaiGowCtrl._haveBalance = false;
PaiGowCtrl._userBetVec = nil
function PaiGowCtrl.ShowBalance(data)
	this._haveBalance = false
	this.closeShowUI()
	this.showUIprefab("balanceInfo")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "balanceInfobar") then
			PaiGowPanel.balanceEnter:SetActive(true)
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
					global.sdk_mgr:share(1,"",files,"牌九")
				end)
			end);
		end
	end
end

function PaiGowCtrl.sortPlayerBalance(list)
	local temp = nil
	local len = #list
	for i=1,len do
		local data = list[i]
		if(i ~= 1 and data.betusers.playerid == PaiGowPanel.getPlayerId()) then
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

PaiGowCtrl._balanceList = {}
function PaiGowCtrl.PrefabBalance(list)
	list = this.sortPlayerBalance(list)
	PaiGowPanel.balanceList_UIScrollView:ResetPosition()
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
		go.transform.parent = PaiGowPanel.balanceList.transform;
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
		if(i == 1) then
			local point = go.transform:Find('point').gameObject;
			point:GetComponent('UILabel').text = PaiGowPanel.getGowName(this.robPoint[1])
		end
    	if(name == PaiGowPanel.getPlayerName()) then
    		freehome:GetComponent('UILabel').text = "[FFCA3CFF]"..GameData.GetShortName(name,6,6)
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
		PaiGowPanel.balanceCollider_UISprite.height = pH
	end
end

function PaiGowCtrl.closeBalanceList()
	local len = #this._balanceList;
	for i=1,len do
		local data = this._balanceList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._balanceList = {}
end

--关闭事件--
function PaiGowCtrl.Close()
	this._userBetVec = nil
	this.clearGowCard()
	this.closeBalanceList()
	this.clearBetPiece()
	this.clearOpenResult()
	this.clearBigShow()
	this.clearRecordList()
	this.closeShowUI()
	this.clearAllCard()
	this.clearLastGowList()
	UpdateBeat:Remove(this.timeEvent, this)
	panelMgr:ClosePanel(CtrlNames.PaiGow);
end

return PaiGowCtrl