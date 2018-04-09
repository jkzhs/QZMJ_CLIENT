require "logic/ViewManager"
local global = require("global")
local i18n = global.i18n
SanshuiCtrl = {};
local this = SanshuiCtrl;
--构建函数--
function SanshuiCtrl.New()
	return this;
end

SanshuiCtrl.RoomId = 0
SanshuiCtrl.IsGameRoom = false
SanshuiCtrl.RoomTitle = ""
function SanshuiCtrl.Awake(roomId,value,title)
	this.RoomId = roomId;
	this.IsGameRoom = value
	this.RoomTitle = title
	panelMgr:CreatePanel('Sanshui', this.OnCreate);
end

function SanshuiCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	global._view:chat().Awake()
	this.panel = this.transform:GetComponent('UIPanel');
	this.Room = this.transform:GetComponent('LuaBehaviour');
	this.Room:AddClick(SanshuiPanel.backOut, function ()
		global._view:support().Awake("您确定要放弃坐庄？",function ()
       		SanshuiPanel.DropBanker()
		   end,function ()

       	end);
	end);
	this.Room:AddClick(SanshuiPanel.playlist, this.OnPlayerList);
	this.Room:AddClick(SanshuiPanel.share, this.OnShare);
	this.Room:AddClick(SanshuiPanel.rule, function ()
		global._view:rule().Awake(global.const.GAME_ID_WATER)
	end);
	this.Room:AddClick(SanshuiPanel.bank, function ()
		global._view:bank().Awake()
	end);                                                                                                                      
	this.Room:AddClick(SanshuiPanel.betbtn, function ()
		if(this._const == nil) then
			return
		end
		if(this._curState ~= this._const.WATER_STATUS_BET) then
			return
		end
		SanshuiPanel.betDialog:SetActive(true)
		SanshuiPanel.PlayerIcon_AsyncImageDownload:SetAsyncImage(SanshuiPanel.getPlayerImg())
		SanshuiPanel.playerCoin_UILabel.text = SanshuiPanel.getPlayerRMB()
		SanshuiPanel.playerSilver_UILabel.text = SanshuiPanel.getPlayerCoin()
		SanshuiPanel.playerName_UILabel.text = GameData.GetShortName(SanshuiPanel.getPlayerName(),14,12) .. "\nID:" .. SanshuiPanel.getPlayerId()
	end);
	this.Room:AddClick(SanshuiPanel.closebet, function ()
		SanshuiPanel.betDialog:SetActive(false)
	end);
	this.Room:AddClick(SanshuiPanel.uibox, this.closeShowUI);
	this.Room:AddClick(SanshuiPanel.back, this.OnBack);
	this.Room:AddClick(SanshuiPanel.rob, this.OnRob);
	this.Room:AddClick(SanshuiPanel.invite, this.OnInvite);
	this.Room:AddClick(SanshuiPanel.betfive, this.OnBetBtn);
	this.Room:AddClick(SanshuiPanel.betten, this.OnBetBtn);
	this.Room:AddClick(SanshuiPanel.bethund, this.OnBetBtn);
	this.Room:AddClick(SanshuiPanel.betkilo, this.OnBetBtn);
	this.Room:AddClick(SanshuiPanel.bettenshou, this.OnBetBtn);
	this.Room:AddClick(SanshuiPanel.betmill, this.OnBetBtn);
	this.Room:AddOnPress(SanshuiPanel.btnFilling, function (go,isPress)
		if(this._const == nil) then
			return
		end
		if(this._curState ~= this._const.WATER_STATUS_BET) then
			return
		end
		if(isPress) then
		else
			if(this._IsRoom) then
				return
			end
			if(value == 0) then
				SanshuiPanel.setTip("下注金额不能为零！")
			end
			local value = tonumber(SanshuiPanel.BetCoin_UILabel.text)
			if(value > 0) then
				SanshuiPanel.betData(this._allBetCoin);
			end
		end
	end);
	this.Room:AddClick(SanshuiPanel.btnDel, function (go)
		if(this._curState ~= this._const.WATER_STATUS_BET) then
			return
		end
		if(this._IsRoom) then
			return
		end
		this._allBetCoin = 0
		SanshuiPanel.BetCoin_UILabel.text = 0
	end)
	if(this.IsGameRoom) then
    	SanshuiPanel.invite_UISprite.color = Color.gray
    	SanshuiPanel.invitefabu_UISprite.color = Color.gray
    	SanshuiPanel.inviteyaoqing_UISprite.color = Color.gray
    end
	this._robData = nil
	this.loadAllCollationBtn()
	UpdateBeat:Add(this.timeEvent, this)
end

function SanshuiCtrl.loadAllCollationBtn()
	this.Room:AddClick(SanshuiPanel.headclose, function ()
		if(#this.headlist > 0) then
			SanshuiPanel.headclose_UISprite.spriteName = "andacha2"
			this.OnCardClose(this.headlist)
			this.headlist = {}
			this.headType = 0
			this.resertCardPos()
		end
	end);
	this.Room:AddClick(SanshuiPanel.midclose, function ()
		if(#this.midlist > 0) then
			SanshuiPanel.midclose_UISprite.spriteName = "andacha2"
			this.OnCardClose(this.midlist)
			this.midlist = {}
			this.midtype = 0 
			this.resertCardPos()
		end
	end);
	this.Room:AddClick(SanshuiPanel.backclose, function ()
		if(#this.backlist > 0) then
			SanshuiPanel.backclose_UISprite.spriteName = "andacha2"
			this.OnCardClose(this.backlist)
			this.backlist = {}
			this.backtype = 0
			this.resertCardPos()
		end
	end);
	this.Room:AddClick(SanshuiPanel.headcollider, this.OnHeadCollider);
	this.Room:AddClick(SanshuiPanel.midcollider, this.OnMidCollider);
	this.Room:AddClick(SanshuiPanel.backcollider, this.OnBackCollider);
	this.Room:AddClick(SanshuiPanel.recovery, function ()
		SanshuiPanel.headclose_UISprite.spriteName = "andacha2"
		SanshuiPanel.backclose_UISprite.spriteName = "andacha2"
		SanshuiPanel.midclose_UISprite.spriteName = "andacha2"
		this.OnCardClose(this.headlist)
		this.headlist = {}
		this.OnCardClose(this.backlist)
		this.backlist = {}
		this.OnCardClose(this.midlist)
		this.midlist = {}
		this.headType = 0
		this.midtype = 0 
		this.backtype = 0
		this.resertCardPos()
	end);
	this.Room:AddClick(SanshuiPanel.paly, function ( )
		this.playCardMgr()
	end);
	this.Room:AddClick(SanshuiPanel.pairs, this.OnPairs);
	this.Room:AddClick(SanshuiPanel.twopairs, this.OnTwoPairs);
	this.Room:AddClick(SanshuiPanel.three, this.OnThree);
	this.Room:AddClick(SanshuiPanel.straight, this.OnStraight);
	this.Room:AddClick(SanshuiPanel.flowers, this.OnFlowers);
	this.Room:AddClick(SanshuiPanel.bottle, this.OnBottle);
	this.Room:AddClick(SanshuiPanel.Ironbranch, this.OnIronbranch);
	this.Room:AddClick(SanshuiPanel.Flush, this.OnFlush);
	this.Room:AddClick(SanshuiPanel.specback, function ()
		if(this.IsCoixtSpeial) then
			SanshuiPanel.TrimCard(4,"");
		else
			SanshuiPanel.specAnima:SetActive(false)
			SanshuiPanel.collation:SetActive(false)
		end
	end);
	this._MinCoin = 0
end

function SanshuiCtrl.playCardMgr()
	if(#this.headlist == 0 or #this.midlist == 0 or #this.backlist == 0) then
		return
	end
	if(this.headType == 0 or this.midtype == 0 or this.backtype == 0) then
		return
	end
	this._IsOutCard = false
	local data = ""
	local cardType = 3
	local hlen = #this.headlist
	local mlen = #this.midlist
	local blen = #this.backlist
	if(#this.headlist > 0) then
		for i=1,hlen do
			local head = this.headlist[i]
			local symbol = ","
			if(i == hlen) then
				symbol = "|"
			end
			data = data .. head.CardData.a_index .. symbol
		end
	end
	if(#this.midlist > 0) then
		for i=1,mlen do
			local mid = this.midlist[i]
			local symbol = ","
			if(i == mlen) then
				symbol = "|"
			end
			data = data .. mid.CardData.a_index .. symbol
		end
	end
	if(#this.backlist > 0) then
		for i=1,blen do
			local back = this.backlist[i]
			local symbol = ","
			if(i == blen) then
				symbol = "#"
			end
			data = data .. back.CardData.a_index .. symbol
		end
	end
	data = data .. this.headType .. "|" .. this.midtype .. "|" .. this.backtype
	SanshuiPanel.TrimCard(cardType,data);
end

function SanshuiCtrl.backPos(poy)
	this.changeChoiceBg()
	SanshuiPanel.choicebtn:SetActive(true)
	SanshuiPanel.choicebtn.transform.localPosition = Vector3(poy, -318 ,0)
	local startX = -550
	local space = 92
	local index = 0
	local count = #this._allCard
	for i=1,count do
		local data = this._allCard[i]
		if(data.IsUp == false) then
			data.IsChoice = false
			data.prefab.transform.localPosition = Vector3(startX + index * space, 0 ,0)
			index = index + 1
		end
	end
end

function SanshuiCtrl.changeAllOpenBtn()
	SanshuiPanel.pairs_UISprite.spriteName = "anhuangniu"
	SanshuiPanel.twopairs_UISprite.spriteName = "anhuangniu"
	SanshuiPanel.Flush_UISprite.spriteName = "anhuangniu"
	SanshuiPanel.Ironbranch_UISprite.spriteName = "anhuangniu"
	SanshuiPanel.bottle_UISprite.spriteName = "anhuangniu"
	SanshuiPanel.flowers_UISprite.spriteName = "anhuangniu"
	SanshuiPanel.straight_UISprite.spriteName = "anhuangniu"
	SanshuiPanel.three_UISprite.spriteName = "anhuangniu"
	this.allflush = {}
	this.allIronbranch = {}
	this.allBottle = {}
	this.allFlowers = {}
	this.allstraight = {}
 	this.allThree = {}
	this.twoPairs = {}
	this.allpairs = {}
end

SanshuiCtrl.allpairs = {}
SanshuiCtrl.clickNum = 1
function SanshuiCtrl.getAllPairs()
	this.clickNum = 1
	local start = 0
	this.allpairs = {}
	local frist = 0
	local endnum = 0
	local count = #this._allCard
	for i=1,count do
		local data = this._allCard[i]
		if(data.IsUp == false) then
			start = data.CardData.num
			frist = i
			for j=frist + 1,count do
				local data2 = this._allCard[j]
				if(data2.IsUp == false) then
					local num = data2.CardData.num
					if(start == num) then
						endnum = j
						start = 0
						local md = {frist = frist,endnum = endnum}
						table.insert(this.allpairs,md)
						break
					end
				end
			end
		end
	end
	if(#this.allpairs > 0) then
		SanshuiPanel.pairs_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.pairs_UISprite.spriteName = "anhuangniu"
	end
end

function SanshuiCtrl.OnPairs()--对子
	if(#this.allpairs > 0) then
		this.choiceNum = 2
		this.backPos(-573)
		if(this.clickNum > #this.allpairs) then
			this.clickNum = 1
		end
		local ap = this.allpairs[this.clickNum]
		local af = this._allCard[ap.frist]
		local ed = this._allCard[ap.endnum]
		af.IsChoice = true
		ed.IsChoice = true
		local apox = af.prefab.transform.localPosition
		local epox = ed.prefab.transform.localPosition
		af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		ed.prefab.transform.localPosition = Vector3(epox.x, 20 ,0)
		this.clickNum = this.clickNum + 1
	end
end

function SanshuiCtrl.getTwoPairs()
	this.twoPairs = {}
	this.twoNum = 1
	GameData.deepCopy(this.twoPairs,this.allpairs)
	local value = 0
	for i=#this.twoPairs,1,-1 do
		local data = this.twoPairs[i]
		local af = this._allCard[data.frist]
		if(value ~= af.CardData.num) then
			value = af.CardData.num
		elseif(value == af.CardData.num) then
			table.remove(this.twoPairs,i)
		end
	end
	if(#this.twoPairs > 1) then
		SanshuiPanel.twopairs_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.twopairs_UISprite.spriteName = "anhuangniu"
	end
end

SanshuiCtrl.twoPairs = {}
SanshuiCtrl.twoNum = 1
function SanshuiCtrl.OnTwoPairs()--两对
	if(#this.twoPairs > 1) then
		this.choiceNum = 4
		this.backPos(-451)
		if(this.twoNum > #this.twoPairs) then
			this.twoNum = 1
		end
		local ap = this.twoPairs[this.twoNum]
		local af = this._allCard[ap.frist]
		local ed = this._allCard[ap.endnum]
		af.IsChoice = true
		ed.IsChoice = true
		local apox = af.prefab.transform.localPosition
		local epox = ed.prefab.transform.localPosition
		af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		ed.prefab.transform.localPosition = Vector3(epox.x, 20 ,0)
		local num = this.twoNum + 1
		if(num > #this.twoPairs) then
			num = 1
		end
		local ap2 = this.twoPairs[num]
		local af2 = this._allCard[ap2.frist]
		local ed2 = this._allCard[ap2.endnum]
		af2.IsChoice = true
		ed2.IsChoice = true
		local apox2 = af2.prefab.transform.localPosition
		local epox2 = ed2.prefab.transform.localPosition
		af2.prefab.transform.localPosition = Vector3(apox2.x, 20 ,0)
		ed2.prefab.transform.localPosition = Vector3(epox2.x, 20 ,0)
		this.twoNum = this.twoNum + 1
	end
end

SanshuiCtrl.allThree = {}
function SanshuiCtrl.getAllThree()
	local start = 0
	this.threeNum = 1
	this.allThree = {}
	local frist = 0
	local twonum = 0
	local endnum = 0
	local count = #this._allCard
	for i=1,count do
		local data = this._allCard[i]
		if(data.IsUp == false) then
			start = data.CardData.num
			frist = i
			local index = 1
			for j=frist + 1,count do
				local data2 = this._allCard[j]
				if(data2.IsUp == false) then
					local num = data2.CardData.num
					if(start == num) then
						index = index + 1
						if(index == 2) then
							twonum = j
						elseif(index == 3) then
							endnum = j
							start = 0
							local md = {frist = frist,twonum = twonum,endnum = endnum}
							table.insert(this.allThree,md)
							break
						end
					end
				end
			end
		end
	end
	if(#this.allThree > 0) then
		SanshuiPanel.three_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.three_UISprite.spriteName = "anhuangniu"
	end
end

SanshuiCtrl.threeNum = 1
function SanshuiCtrl.OnThree()--三条
	if(#this.allThree > 0) then
		this.choiceNum = 3
		this.backPos(-329)
		if(this.threeNum > #this.allThree) then
			this.threeNum = 1
		end
		local ap = this.allThree[this.threeNum]
		local af = this._allCard[ap.frist]
		local td = this._allCard[ap.twonum]
		local ed = this._allCard[ap.endnum]
		af.IsChoice = true
		td.IsChoice = true
		ed.IsChoice = true
		local apox = af.prefab.transform.localPosition
		local tpox = td.prefab.transform.localPosition
		local epox = ed.prefab.transform.localPosition
		af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		td.prefab.transform.localPosition = Vector3(tpox.x, 20 ,0)
		ed.prefab.transform.localPosition = Vector3(epox.x, 20 ,0)
		this.threeNum = this.threeNum + 1
	end
end

SanshuiCtrl.allstraight = {}
SanshuiCtrl.straightNum = 1
function SanshuiCtrl.checkStraight() 
 	this.allstraight = {}
 	this.straightNum = 1
    local temp = {};
    local sptemp = {};
    local result = {}
    local sp = {}
    local spresult = {}
    local count = 0;
    local begin = 0;
    local count = #this._allCard
    for i=1,count do
		local data = this._allCard[i]
		if(data.IsUp == false) then
			local start = data.CardData.num
			frist = i
			temp = {}
			sptemp = {}
			table.insert(temp,i)
			table.insert(sptemp,i)
			local index = 1
			local spIndex = 1
			for j=frist + 1,count do
				local data2 = this._allCard[j]
				if(data2.IsUp == false) then
					local num = data2.CardData.num
					if(start == 14) then
						if(num == 6 - spIndex and spIndex < 5) then
							spIndex = spIndex + 1
							if(spIndex == 5) then
								table.insert(sptemp,j)
								table.insert(sp,sptemp)
							elseif(spIndex < 5) then
								table.insert(sptemp,j)
							end
						elseif(num == 6 - spIndex + 1 and spIndex > 1) then
							local tt = {head = i,pos = spIndex,repace = j}
							table.insert(spresult,tt)
						end
					end
					if(num == start - index and index < 5) then
						index = index + 1
						if(index == 5) then
							table.insert(temp,j)
							table.insert(this.allstraight,temp)
						elseif(index < 5) then
							table.insert(temp,j)
						end
					elseif(num == start - index + 1 and index > 1) then
						local tt = {head = i,pos = index,repace = j}
						table.insert(result,tt)
					end
				end
			end
		end
	end
	local final = {}
	GameData.deepCopy(final,this.allstraight)
	local alen = #final
	local rlen = #result
	for i=1,alen do
		local data = final[i]
		for j=1,rlen do
			local tt = result[j]
			if(tt.head == data[1]) then
				local tp = data
				if(this._allCard[tp[tt.pos]].CardData.num == this._allCard[tt.repace].CardData.num) then
					tp[tt.pos] = tt.repace
					table.insert(this.allstraight,tp)
				end
			end
		end
	end

	local spfinal = {}
	GameData.deepCopy(spfinal,sp)
	local alen = #spfinal
	local rlen = #spresult
	for i=1,alen do
		local data = spfinal[i]
		for j=1,rlen do
			local tt = spresult[j]
			if(tt.head == data[1]) then
				local tp = data
				if(this._allCard[tp[tt.pos]].CardData.num == this._allCard[tt.repace].CardData.num) then
					tp[tt.pos] = tt.repace
					table.insert(this.allstraight,tp)
				end
			end
		end
		table.insert(this.allstraight,data)
	end

	if(#this.allstraight > 0) then
		SanshuiPanel.straight_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.straight_UISprite.spriteName = "anhuangniu"
	end
end

function SanshuiCtrl.OnStraight()--顺子
	if(#this.allstraight > 0) then
		this.choiceNum = 5
		this.backPos(-207)
		if(this.straightNum > #this.allstraight) then
			this.straightNum = 1
		end
		local all = this.allstraight[this.straightNum]
		local len = #all
		for i=1,len do
			local af = this._allCard[all[i]]
			af.IsChoice = true
			local apox = af.prefab.transform.localPosition
			af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		end
		this.straightNum = this.straightNum + 1
	end
end

SanshuiCtrl.allFlowers = {}
function SanshuiCtrl.getAllFlowers()
	this.allFlowers = {}
	this.flowerNum = 1
	local temp = {};
    local result = {}
    local count = 0;
    local begin = 0;
    local count = #this._allCard
    for i=1,count do
		local data = this._allCard[i]
		if(data.IsUp == false) then
			local start = data.CardData.cardtype
			frist = i
			temp = {}
			table.insert(temp,i)
			local index = 1
			for j=frist + 1,count do
				local data2 = this._allCard[j]
				if(data2.IsUp == false) then
					local num = data2.CardData.cardtype
					if(num == start) then
						index = index + 1
						if(index == 5) then
							table.insert(temp,j)
							table.insert(this.allFlowers,temp)
							break
						else
							table.insert(temp,j)
						end
					end
				end
			end
		end
	end
	if(#this.allFlowers > 0) then
		SanshuiPanel.flowers_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.flowers_UISprite.spriteName = "anhuangniu"
	end
end

SanshuiCtrl.flowerNum = 1
function SanshuiCtrl.OnFlowers()--同花
	if(#this.allFlowers > 0) then
		this.choiceNum = 5
		this.backPos(-85)
		if(this.flowerNum > #this.allFlowers) then
			this.flowerNum = 1
		end
		local all = this.allFlowers[this.flowerNum]
		local len = #all
		for i=1,len do
			local af = this._allCard[all[i]]
			af.IsChoice = true
			local apox = af.prefab.transform.localPosition
			af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		end
		this.flowerNum = this.flowerNum + 1
	end
end

SanshuiCtrl.allBottle = {}
function SanshuiCtrl.getAllBottle()
	this.allBottle = {}
	this.bottleNum = 1
    local count = 0;
    local count = #this.allThree
    local len = #this.allpairs
    for i=1,count do
		local data = this.allThree[i]
		local start = this._allCard[data.frist].CardData.num
		for j=1,len do
			local pair = this.allpairs[j]
			local af = this._allCard[pair.frist].CardData.num
			if(af ~= start) then
				local temp = {};
				table.insert(temp,data.frist)
				table.insert(temp,data.twonum)
				table.insert(temp,data.endnum)
				table.insert(temp,pair.frist)
				table.insert(temp,pair.endnum)
				table.insert(this.allBottle,temp)
			end
		end
	end
	if(#this.allBottle > 0) then
		SanshuiPanel.bottle_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.bottle_UISprite.spriteName = "anhuangniu"
	end
end

SanshuiCtrl.bottleNum = 1
function SanshuiCtrl.OnBottle()--葫芦
	if(#this.allBottle > 0) then
		this.choiceNum = 5
		this.backPos(37)
		if(this.bottleNum > #this.allBottle) then
			this.bottleNum = 1
		end
		local all = this.allBottle[this.bottleNum]
		local len = #all
		for i=1,len do
			local af = this._allCard[all[i]]
			af.IsChoice = true
			local apox = af.prefab.transform.localPosition
			af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		end
		this.bottleNum = this.bottleNum + 1
	end
end

SanshuiCtrl.allIronbranch = {}
function SanshuiCtrl.getAllIronbranch()
	this.allIronbranch = {}
	this.IronNum = 1
	local temp = {};
    local count = #this._allCard
    for i=1,count do
		local data = this._allCard[i]
		if(data.IsUp == false) then
			local start = data.CardData.num
			frist = i
			temp = {}
			table.insert(temp,i)
			local index = 1
			for j=frist + 1,count do
				local data2 = this._allCard[j]
				if(data2.IsUp == false) then
					local num = data2.CardData.num
					if(num == start) then
						index = index + 1
						if(index == 4) then
							table.insert(temp,j)
							for z=1,count do
								local vd = this._allCard[z]
								if(vd.IsUp == false) then
									local vTable = {}
									if(z ~= temp[1] and z ~= temp[2] and z ~= temp[3] and z ~= temp[4]) then
										table.insert(vTable,temp[1])
										table.insert(vTable,temp[2])
										table.insert(vTable,temp[3])
										table.insert(vTable,temp[4])
										table.insert(vTable,z)
										table.insert(this.allIronbranch,vTable)
									end
								end
							end
							break
						else
							table.insert(temp,j)
						end
					end
				end
			end
		end
	end
	if(#this.allIronbranch > 0) then
		SanshuiPanel.Ironbranch_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.Ironbranch_UISprite.spriteName = "anhuangniu"
	end
end

SanshuiCtrl.IronNum = 1
function SanshuiCtrl.OnIronbranch()--铁支
	if(#this.allIronbranch > 0) then
		this.choiceNum = 5
		this.backPos(159)
		if(this.IronNum > #this.allIronbranch) then
			this.IronNum = 1
		end
		local all = this.allIronbranch[this.IronNum]
		local len = #all
		for i=1,len do
			local af = this._allCard[all[i]]
			af.IsChoice = true
			local apox = af.prefab.transform.localPosition
			af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		end
		this.IronNum = this.IronNum + 1
	end
end

function SanshuiCtrl.checkFlushCard()
	this.allflush = {}
	this.flushNum = 1
	local len = #this.allstraight
	for i=1,len do
		local all = this.allstraight[i]
		local alen = #all
		local starttype = 0
		for j=1,alen do
			local data = this._allCard[all[j]]
			local cardtype = data.CardData.cardtype
			if(starttype == 0) then
				starttype = cardtype
			elseif(starttype ~= cardtype) then
				break
			elseif(starttype == cardtype and j == alen) then
				table.insert(this.allflush,all)
			end
		end
	end
	if(#this.allflush > 0) then
		SanshuiPanel.Flush_UISprite.spriteName = "anhuangseanniu"
	else
		SanshuiPanel.Flush_UISprite.spriteName = "anhuangniu"
	end
end
SanshuiCtrl.allflush = {}
SanshuiCtrl.flushNum = 1
function SanshuiCtrl.OnFlush()--同花顺
	if(#this.allflush > 0) then
		this.choiceNum = 5
		this.backPos(281)
		if(this.flushNum > #this.allflush) then
			this.flushNum = 1
		end
		local all = this.allflush[this.flushNum]
		local len = #all
		for i=1,len do
			local af = this._allCard[all[i]]
			af.IsChoice = true
			local apox = af.prefab.transform.localPosition
			af.prefab.transform.localPosition = Vector3(apox.x, 20 ,0)
		end
		this.flushNum = this.flushNum + 1
	end
end

-- SanshuiCtrl.samedragon = false --清一色一条龙
-- SanshuiCtrl.nodragon = false --草龙
-- SanshuiCtrl.sixpairs = false --6对半
-- SanshuiCtrl.samecolor = false --3同花
-- SanshuiCtrl.threedragon = false --3顺子
-- function SanshuiCtrl.checkAdragon(list)
-- 	this.samedragon = false
-- 	this.nodragon = false
-- 	this.samecolor = false
-- 	local count = #list
-- 	if(count == 0) then
-- 		return
-- 	end
-- 	local data = list[1]
-- 	local start = data.cardtype
-- 	local startnum = data.num
-- 	local index = 1
-- 	local tyIndex = 1
-- 	for j=2,count do
-- 		local data2 = list[j]
-- 		local type2 = data2.cardtype
-- 		local num2 = data2.num
-- 		if(num2 == startnum - index) then
-- 			index = index + 1
-- 			if(index == 13) then
-- 				this.nodragon = true
-- 			end
-- 		end
-- 		if(type2 == start) then
-- 			tyIndex = tyIndex + 1
-- 			if(tyIndex == 13) then
-- 				if(this.nodragon) then
-- 					this.samedragon = true
-- 				else
-- 					this.samecolor = true
-- 				end
-- 			end
-- 		end
-- 	end
-- 	this.checkSixPairs(list)
-- 	if(this.samecolor == false) then
-- 		this.checkThreeFlush(list)
-- 	end
-- end

-- function SanshuiCtrl.checkSixPairs(list)
-- 	this.sixpairs = false
-- 	local frist = 0
-- 	local count = #list
-- 	local index = 0
-- 	for i=1,count do
-- 		if(i > frist and i < count) then
-- 			local data = list[i]
-- 			local startnum = data.num
-- 			local data2 = list[i + 1]
-- 			local num2 = data2.num
-- 			if(num2 == startnum) then
-- 				index = index + 1
-- 				frist = i + 1
-- 				if(index == 6) then
-- 					this.sixpairs = true
-- 					break
-- 				end
-- 			else
-- 				frist = i
-- 			end
-- 		end
-- 	end
-- end

-- function SanshuiCtrl.checkThreeFlush(list) --3 5 8 10
-- 	local temp = {}
-- 	GameData.deepCopy(temp,list)
-- 	table.sort(temp,function (a,b)
--         return a.cardtype > b.cardtype
--     end)
--     this.samecolor = true
-- 	local frist = 0
-- 	local count = #temp
-- 	for i=1,count do
-- 		if(frist == 0 or frist == 3 or frist == 5 or frist == 8 or frist == 10) then
-- 			if(i > frist) then
-- 				local data = temp[i]
-- 				local startnum = data.cardtype
-- 				local index = 1
-- 				for j= i+1,count do
-- 					local data2 = temp[j]
-- 					local num2 = data2.cardtype
-- 					if(num2 == startnum) then
-- 						index = index + 1
-- 					else
-- 						frist = frist + index
-- 						break
-- 					end
-- 				end
-- 			end
-- 		else
-- 			this.samecolor = false
-- 			break
-- 		end
-- 	end
-- end

-- function SanshuiCtrl.checkThreeStraight(list)
	
-- end

function SanshuiCtrl.playShootAnima()
	this._gunNum = 1
	this._IsPlayShoot = true
end

SanshuiCtrl._gunVec = {}
SanshuiCtrl._gunNum = 0
SanshuiCtrl._gunEffect = nil
SanshuiCtrl._Isgun = false
SanshuiCtrl._IsPlayShoot = false
SanshuiCtrl.bulleSpeed = 0
function SanshuiCtrl.addShootEffect(pos,endpos)
	if(#endpos == 0) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	soundMgr:PlaySound("FireGun_Nv")
	SanshuiPanel.cardEffect:SetActive(true)
	if(this._gunEffect == nil) then
		local bundle = resMgr:LoadBundle("shootCard");
	    local Prefab = resMgr:LoadBundleAsset(bundle,"shootCard");
	    this._gunEffect = GameObject.Instantiate(Prefab);
		this._gunEffect.name = "shootCardBar";
		this._gunEffect.transform.parent = SanshuiPanel.cardEffect.transform;
		resMgr:addAltas(this._gunEffect.transform,"Sanshui")
	end
	this._gunEffect.transform.rotation = Quaternion.Euler(Vector3(0,0,endpos[1]));
	this._gunEffect.transform.localScale = Vector3(endpos[2],endpos[3],1);
	this._gunEffect.transform.localPosition = pos;
	this._Isgun = true
	this.bulleSpeed = 0
	this._playGun = 1
end

function SanshuiCtrl.clearGunEffect()
	if(this._gunEffect ~= nil) then
		panelMgr:ClearPrefab(this._gunEffect);
	end
	this._gunEffect = nil
end

SanshuiCtrl._playGun = 0
function SanshuiCtrl.updateShoot()
	if(this._IsPlayShoot == false) then
		return
	end

	local len = #this._gunVec
	if(len == 0) then
		return
	end
	for i=1,len do
		local data = this._gunVec[i]
		if(this._gunNum == i) then
			if(data.time > 0) then
				data.time = data.time - Time.deltaTime
			else
				this._gunNum = this._gunNum + 1
				if(data.myself == -1) then
					this._BulletPos = Vector3(data.endver.x + 100,data.endver.y,0)
				else
					this._BulletPos = Vector3(data.endver.x - 100,data.endver.y,0)
				end
				this.addShootEffect(data.pos,data.endpos)
				if(this._gunNum > len) then
					this._IsPlayShoot = false
				end
			end
		end
	end
end

SanshuiCtrl._BulletPos = {}
function SanshuiCtrl.shootAnima()
	if(this._Isgun == false) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	if(this.bulleSpeed <= 0.08) then
        this.bulleSpeed = this.bulleSpeed + Time.deltaTime
    else
    	this.bulleSpeed = 0
    	if(this._gunEffect ~= nil and this._playGun <= 6) then
    		local gunIcon_UISprite = this._gunEffect.transform:Find('gunIcon'):GetComponent('UISprite');
			gunIcon_UISprite.spriteName = "a" .. this._playGun;
			if(this._playGun % 2 == 0) then
				this.addShootResult(this._gunNum..this._playGun,this._BulletPos)
			end
			gunIcon_UISprite:MakePixelPerfect();
			this._playGun = this._playGun + 1
		else
			this._Isgun = false
			SanshuiPanel.cardEffect:SetActive(false)
			if(this._IsPlayShoot == false) then
				this.replayAllScoreAnima(true)
			end
    	end
    end
end

SanshuiCtrl.bulletList = {}
function SanshuiCtrl.addShootResult(tag,pos)
	soundMgr:PlaySound("GAME_GUN")
	local pi = math.pi
  	local rand_r = math.random(0,50) -- 随机半径
	local rand_angle = math.random(0,360) -- 随机方向 0 - 360度
	local x = math.sin(rand_angle * pi / 180 ) * rand_r;
	local y = math.cos(rand_angle * pi / 180) * rand_r;
	local bundle = resMgr:LoadBundle("shootResult");
    local Prefab = resMgr:LoadBundleAsset(bundle,"shootResult");
    local bomb = GameObject.Instantiate(Prefab);
	bomb.name = "shootResult"..tag;
	bomb.transform.parent = SanshuiPanel.bulletEffect.transform;
	bomb.transform.localScale = Vector3.one;
	bomb.transform.localPosition = Vector3(pos.x + x,pos.y + y,0);
	resMgr:addAltas(bomb.transform,"Sanshui")
	table.insert(this.bulletList,bomb);
end

function SanshuiCtrl.clearBullet()
	local len = #this.bulletList
	for i=1,len do
		local go = this.bulletList[i]
		panelMgr:ClearPrefab(go);
	end
	this.bulletList = {}
end

function SanshuiCtrl.timeEvent()
	this.FreeTimeEvent()
	this.dealCardTime()
	this.updateBalanceScore()
	this.updateShoot()
	this.shootAnima()
end

SanshuiCtrl._IsCome = true;
SanshuiCtrl._IsOutCard = true;
SanshuiCtrl._FreeTime = 0;
function SanshuiCtrl.FreeTimeEvent()
  	if(this._FreeTime > 0) then
        local time = this._FreeTime - SanshuiPanel.getTime()
        if(time >= 0) then
        	local hours = math.floor(time / 3600);
			time = time - hours * 3600;
			-- local minute = math.floor(time / 60);
			-- time = time - minute * 60;
			if(time < this.animatime and this._curState == this._const.WATER_STATUS_OPEN and this._IsCome) then
				this.stopAllAnima(this._openCards)
			end
			SanshuiPanel.timeTxt_UILabel.text = GameData.changeFoLimitTime(time);
			if(this._curState == this._const.WATER_STATUS_TRIM and time == 1 and this._IsOutCard) then
        		this.playCardMgr()
        	end
        else
            this._FreeTime = 0;
            SanshuiPanel.timeTxt_UILabel.text = 0
        end
    end
end


SanshuiCtrl.EnterPos = {{x = 94,y = -176,z = 0},{x = -260,y = -176,z = 1},{x = 455,y = -176,z = 1},
{x = 580,y = 2,z = 1},{x = -580,y = 2,z = -1},{x = -260,y = 192,z = 1},{x = 94,y = 192,z = 1},
{x = 455,y = 192,z = 1}}
SanshuiCtrl.allPlayerList = {}
SanshuiCtrl.allEuler = {
	{{},{20,1,1},{-20,-1,1},{0,-1,1},{0,1,1},{-10,1,1},{-70,1,1},{30,-1,1}},
	{{-20,-1,1},{},{-20,-1,1},{-10,-1,1},{-10,1,1},{-70,1,1},{30,-1,1},{10,-1,1}},
	{{20,1,1},{20,1,1},{},{-70,1,1},{0,1,1},{0,1,1},{10,1,1},{-40,1,1}},
	{{45,1,1},{40,1,1},{80,1,1},{},{20,1,1},{0,1,1},{0,1,1},{-20,1,1}},
	{{-50,-1,1},{-80,-1,1},{-40,-1,1},{-20,-1,1},{},{30,-1,1},{10,-1,1},{0,-1,1}},
	{{-80,-1,1},{60,1,-1},{116,1,-1},{140,1,-1},{60,1,1},{},{-20,-1,1},{20,-1,1}},
	{{100,1,1},{60,1,1},{-70,-1,1},{-50,-1,1},{50,1,1},{20,1,1},{},{-20,-1,1}},
	{{65,1,1},{50,1,1},{98,1,1},{110,1,1},{40,1,1},{20,1,1},{20,1,1},{}},
}
function SanshuiCtrl.initAllPlayer()
	local bundle = resMgr:LoadBundle("RoleData");
	local Prefab = resMgr:LoadBundleAsset(bundle,"RoleData");
	local max = #this.EnterPos
	for i=1,max do
		local value = list[i]
	    local go = GameObject.Instantiate(Prefab);
		go.name = "RoleData" .. i;
		go.transform.parent = SanshuiPanel.allRole.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(this.EnterPos[i].x, this.EnterPos[i].y ,0)
		resMgr:addAltas(go.transform,"Sanshui")
		local closebrand = go.transform:Find('sameBody/closebrand').gameObject;
		local branding = go.transform:Find('sameBody/branding').gameObject;
		local openbrand = go.transform:Find('sameBody/openbrand').gameObject;
		local headScore = go.transform:Find('sameBody/score/headScore').gameObject;
		local midScore = go.transform:Find('sameBody/score/midScore').gameObject;
		local backScore = go.transform:Find('sameBody/score/backScore').gameObject;
		local allScore = go.transform:Find('sameBody/score/allScore').gameObject;
		local betIcon = go.transform:Find('sameBody/betIcon'):GetComponent('UISprite');
		if(this.patterntype == 1) then
			betIcon.spriteName = "shangduibijine"
		else
			betIcon.spriteName = "shangbajilu"
		end
		if(this.EnterPos[i].z == -1) then
			closebrand.transform.localPosition = Vector3(254, 0 ,0)
			branding.transform.localPosition = Vector3(250, 0 ,0)
			openbrand.transform.localPosition = Vector3(242, 0 ,0)
			headScore.transform.localPosition = Vector3(210, 65 ,0)
			midScore.transform.localPosition = Vector3(210, 0 ,0)
			backScore.transform.localPosition = Vector3(210, -65 ,0)
			allScore.transform.localPosition = Vector3(90, -72 ,0)
		else
			closebrand.transform.localPosition = Vector3.zero
			branding.transform.localPosition = Vector3.zero
			openbrand.transform.localPosition = Vector3(-12, 0 ,0)
			headScore.transform.localPosition = Vector3(35, 65 ,0)
			midScore.transform.localPosition = Vector3(35, 0 ,0)
			backScore.transform.localPosition = Vector3(35, -65 ,0)
			allScore.transform.localPosition = Vector3(-165, -72 ,0)
		end 
		local data = {
			prefab = go,
			playerInfo = nil,
			myself = this.EnterPos[i].z,
			allEuler = this.allEuler[i],
			mound = {},
			mound_odds = 0,
			total_odds = 0,
			extra_odds = 0,
			swat = 0,
			headIndex = 0,
			midIndex = 0,
			backIndex = 0,
			headName = 0,
			midName = 0,
			backName = 0,
			specName = 0,
			specIndex = 0,
			duration = 0.4,
		}
		table.insert(this.allPlayerList,data)
	end
	local info = {
		name = GameData.GetShortName(SanshuiPanel.getPlayerName(),10,7),
		icon = SanshuiPanel.getPlayerImg(),
		coin = SanshuiPanel.getPlayerCoin() + SanshuiPanel.getPlayerRMB(),
		id = SanshuiPanel.getPlayerId(),
		betcoin = 0,
	}
	this.InsertPlayerInfo(info)
end

function SanshuiCtrl.clearPlayerList()
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		panelMgr:ClearPrefab(data.prefab);
	end
	this.allPlayerList = {}
end

SanshuiCtrl.myPlayerInfo = nil
function SanshuiCtrl.getMyPlayerInfo()
	local value = nil
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil and data.playerInfo.id == SanshuiPanel.getPlayerId()) then
			value = data
			break
		end
	end
	this.myPlayerInfo = value
	return value
end

function SanshuiCtrl.checkPlayerIsCxist(id)
	local value = false
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil and data.playerInfo.id == id) then
			value = true
			break
		end
	end
	return value
end

function SanshuiCtrl.setPlayerBanker(playerid)
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			local banker = data.prefab.transform:Find('sameBody/banker').gameObject;
			if(data.playerInfo.id == playerid) then
				banker:SetActive(true)
			else
				banker:SetActive(false)
			end
		end
	end
end

SanshuiCtrl._ownIsCard = false
function SanshuiCtrl.cleanPlayerCard(value,list)
	local len = #this.allPlayerList
	local count = #list
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			for j=1,count do
				local playerData = list[j]
				if(playerData.playerid == data.playerInfo.id) then
					if(playerData.playerid == SanshuiPanel.getPlayerId()) then
						this._ownIsCard = true
					end
					local closebrand = data.prefab.transform:Find('sameBody/closebrand').gameObject;
					local branding = data.prefab.transform:Find('sameBody/branding').gameObject;
					branding:SetActive(value)
					if(value == false) then
						local oneclose = data.prefab.transform:Find('sameBody/closebrand/oneclose').gameObject;
						oneclose:SetActive(true)
						local twoclose = data.prefab.transform:Find('sameBody/closebrand/twoclose').gameObject;
						twoclose:SetActive(true)
						local threeclose = data.prefab.transform:Find('sameBody/closebrand/threeclose').gameObject;
						threeclose:SetActive(true)
					end
					closebrand:SetActive(value ~= true)
					break
				end
			end
		end
	end
end

function SanshuiCtrl.toCleanPlayerCard(playerid)
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			if(data.playerInfo.id == playerid) then
				local closebrand = data.prefab.transform:Find('sameBody/closebrand').gameObject;
				local branding = data.prefab.transform:Find('sameBody/branding').gameObject;
				local oneclose = data.prefab.transform:Find('sameBody/closebrand/oneclose').gameObject;
				oneclose:SetActive(true)
				local twoclose = data.prefab.transform:Find('sameBody/closebrand/twoclose').gameObject;
				twoclose:SetActive(true)
				local threeclose = data.prefab.transform:Find('sameBody/closebrand/threeclose').gameObject;
				threeclose:SetActive(true)
				closebrand:SetActive(true)
				branding:SetActive(false)
				break
			end
		end
	end
end

function SanshuiCtrl.addMoundBullet(data)
	local len = #this.allPlayerList
	local size = #data.mound
	for m=1,size do
		local moundid = data.mound[m].playerid
		local endpos = {}
		local endver = Vector3.zero
		local myself = 1
		for n=1,len do
			local alldata = this.allPlayerList[n]
			if(alldata.playerInfo ~= nil) then
				if(alldata.playerInfo.id == moundid) then
					endpos = data.allEuler[n]
					endver = alldata.prefab.transform.localPosition
					myself = alldata.myself
					break
				end
			end
		end
		local vec = {
			pos = data.prefab.transform.localPosition,
			endpos = endpos,
			endver = endver,
			myself = myself,
			time = 1,
		}
		table.insert(this._gunVec,vec)
	end
end

SanshuiCtrl.animatime = 0
SanshuiCtrl._IsSpec = 0
function SanshuiCtrl.openPlayerCard(list,time)
	this._allOnlinePlay = 0
	this._IsSpec = 0
	local count = #list
	if(count == 0) then
		return
	end
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		data.duration = 1
		data.headIndex = 0
		data.midIndex = 0
		data.backIndex = 0
		data.headName = 0
		data.midName = 0
		data.backName = 0
		data.specName = 0
		data.specIndex = 0
		data.mound = {}
		data.mound_odds = 0
		data.swat = 0
		data.total_odds = 0
		data.extra_odds = 0
		if(data.playerInfo ~= nil) then
			for j=1,count do
				local playerData = list[j]
				if(data.playerInfo.id == playerData.playerid) then
					data.mound = playerData.mound
					data.mound_odds = playerData.mound_odds
					data.swat = playerData.swat
					data.total_odds = playerData.total_odds
					data.extra_odds = playerData.extra_odds
					this.addMoundBullet(data)
					if(playerData.is_spec == 1) then --特殊牌型
						this.animatime = this.animatime + 1
						this._IsSpec = this._IsSpec + 1
						local special = data.prefab.transform:Find('sameBody/closebrand/special').gameObject;
						local specialIcon = data.prefab.transform:Find('sameBody/closebrand/special/specialIcon').gameObject;
						local cardName = data.prefab.transform:Find('sameBody/closebrand/special/cardName'):GetComponent('UISprite');
						special:SetActive(true)
						specialIcon:SetActive(true)
						data.specIndex = playerData.open_index
						if(data.specIndex == 1 and this.IsCoixtSpeial == false) then
							data.duration = 1.5
						end
						data.specName = playerData.card_type
						cardName.spriteName = this.CardToName(playerData.card_type)
						cardName:MakePixelPerfect();
						local one = data.prefab.transform:Find('sameBody/openbrand/one').gameObject;
						local two = data.prefab.transform:Find('sameBody/openbrand/two').gameObject;
						local three = data.prefab.transform:Find('sameBody/openbrand/three').gameObject;
						local headScore = data.prefab.transform:Find('sameBody/score/headScore').gameObject;
						local midScore = data.prefab.transform:Find('sameBody/score/midScore').gameObject;
						local backScore = data.prefab.transform:Find('sameBody/score/backScore').gameObject;
						one:SetActive(false)
						two:SetActive(false)
						three:SetActive(false)
						headScore:SetActive(false)
						midScore:SetActive(false)
						backScore:SetActive(false)
						local allScore = data.prefab.transform:Find('sameBody/score/allScore').gameObject;
						local allScore_UILabel = allScore:GetComponent('UILabel');
						local totalodds = playerData.total_odds + playerData.extra_odds
						if(totalodds >= 0) then
							totalodds = "+" .. totalodds
						end
						allScore_UILabel.text = totalodds
						this.SpecialCardData(playerData,data.prefab)
					else
						this.animatime = this.animatime + 3
						this._allOnlinePlay = this._allOnlinePlay + 1
						this.setPlayerCardData(data,data.prefab,playerData)
					end
					break
				end
			end
		end
	end
	this.getMyPlayerInfo()
	this.animatime = this.animatime + 2
	if(time < this.animatime) then
		this.stopAllAnima(list)
	else
		this._startIndex = 1
		if(this._allOnlinePlay > 0) then
			this._startPox = 1
		else
			this._startPox = 4
		end
		this.startDeal = true
	end
end

function SanshuiCtrl.SpecialCardData(playerData,go)
	local headData = playerData.card_count[1]
	local one_bg1 = go.transform:Find('sameBody/openbrand/one/bg1'):GetComponent('UISprite');
	local one_bg2 = go.transform:Find('sameBody/openbrand/one/bg2'):GetComponent('UISprite');
	local one_bg3 = go.transform:Find('sameBody/openbrand/one/bg3'):GetComponent('UISprite');
	one_bg1.depth = 17 + 10;
	one_bg2.depth = 19 + 10;
	one_bg3.depth = 21 + 10;
	local one1_cardtype1 = go.transform:Find('sameBody/openbrand/one/bg1/cardtype1'):GetComponent('UISprite');
	local one1_cardtype2 = go.transform:Find('sameBody/openbrand/one/bg1/cardtype2'):GetComponent('UISprite');
	local one1_card = go.transform:Find('sameBody/openbrand/one/bg1/card'):GetComponent('UILabel');
	one1_cardtype1.spriteName = this.checkCardType(headData.cards[1].type)
	one1_cardtype1.depth = 18 + 10;
	one1_cardtype2.spriteName = this.checkCardType(headData.cards[1].type)
	one1_cardtype2.depth = 18 + 10;
	one1_card.text = this.CardToImg(headData.cards[1].card)
	one1_card.depth = 18 + 10;
	local one2_cardtype1 = go.transform:Find('sameBody/openbrand/one/bg2/cardtype1'):GetComponent('UISprite');
	local one2_cardtype2 = go.transform:Find('sameBody/openbrand/one/bg2/cardtype2'):GetComponent('UISprite');
	local one2_card = go.transform:Find('sameBody/openbrand/one/bg2/card'):GetComponent('UILabel');
	one2_cardtype1.spriteName = this.checkCardType(headData.cards[2].type)
	one2_cardtype1.depth = 20 + 10;
	one2_cardtype2.spriteName = this.checkCardType(headData.cards[2].type)
	one2_cardtype2.depth = 20 + 10;
	one2_card.text = this.CardToImg(headData.cards[2].card)
	one2_card.depth = one2_card.depth + 10;
	local one3_cardtype1 = go.transform:Find('sameBody/openbrand/one/bg3/cardtype1'):GetComponent('UISprite');
	local one3_cardtype2 = go.transform:Find('sameBody/openbrand/one/bg3/cardtype2'):GetComponent('UISprite');
	local one3_card = go.transform:Find('sameBody/openbrand/one/bg3/card'):GetComponent('UILabel');
	one3_cardtype1.spriteName = this.checkCardType(headData.cards[3].type)
	one3_cardtype1.depth = 22 + 10;
	one3_cardtype2.spriteName = this.checkCardType(headData.cards[3].type)
	one3_cardtype2.depth = 22 + 10;
	one3_card.text = this.CardToImg(headData.cards[3].card)
	one3_card.depth = 22 + 10;
	local oneEffect = go.transform:Find('sameBody/openbrand/one/oneEffect').gameObject;
	local oneEffect_UISprite = oneEffect:GetComponent('UISprite');
	oneEffect_UISprite.spriteName = ""
	oneEffect_UISprite.alpha = 0
	oneEffect_UISprite:MakePixelPerfect();
	local midData = playerData.card_count[2]
	local two_bg1 = go.transform:Find('sameBody/openbrand/two/bg1'):GetComponent('UISprite');
	local two_bg2 = go.transform:Find('sameBody/openbrand/two/bg2'):GetComponent('UISprite');
	local two_bg3 = go.transform:Find('sameBody/openbrand/two/bg3'):GetComponent('UISprite');
	local two_bg4 = go.transform:Find('sameBody/openbrand/two/bg4'):GetComponent('UISprite');
	local two_bg5 = go.transform:Find('sameBody/openbrand/two/bg5'):GetComponent('UISprite');
	two_bg1.depth = 27 + 10;
	two_bg2.depth = 29 + 10;
	two_bg3.depth = 31 + 10;
	two_bg4.depth = 33 + 10;
	two_bg5.depth = 35 + 10;
	local two1_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg1/cardtype1'):GetComponent('UISprite');
	local two1_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg1/cardtype2'):GetComponent('UISprite')
	local two1_card = go.transform:Find('sameBody/openbrand/two/bg1/card'):GetComponent('UILabel');
	two1_cardtype1.spriteName = this.checkCardType(midData.cards[1].type)
	two1_cardtype1.depth = 28 + 10;
	two1_cardtype2.spriteName = this.checkCardType(midData.cards[1].type)
	two1_cardtype2.depth = 28 + 10;
	two1_card.text = this.CardToImg(midData.cards[1].card)
	two1_card.depth = 28 + 10;
	local two2_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg2/cardtype1'):GetComponent('UISprite');
	local two2_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg2/cardtype2'):GetComponent('UISprite');
	local two2_card = go.transform:Find('sameBody/openbrand/two/bg2/card'):GetComponent('UILabel');
	two2_cardtype1.spriteName = this.checkCardType(midData.cards[2].type)
	two2_cardtype1.depth = 30 + 10;
	two2_cardtype2.spriteName = this.checkCardType(midData.cards[2].type)
	two2_cardtype2.depth = 30 + 10;
	two2_card.text = this.CardToImg(midData.cards[2].card)
	two2_card.depth = 30 + 10;
	local two3_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg3/cardtype1'):GetComponent('UISprite');
	local two3_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg3/cardtype2'):GetComponent('UISprite');
	local two3_card = go.transform:Find('sameBody/openbrand/two/bg3/card'):GetComponent('UILabel');
	two3_cardtype1.spriteName = this.checkCardType(midData.cards[3].type)
	two3_cardtype1.depth = 32 + 10;
	two3_cardtype2.spriteName = this.checkCardType(midData.cards[3].type)
	two3_cardtype2.depth = 32 + 10;
	two3_card.text = this.CardToImg(midData.cards[3].card)
	two3_card.depth = 32 + 10;
	local two4_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg4/cardtype1'):GetComponent('UISprite');
	local two4_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg4/cardtype2'):GetComponent('UISprite');
	local two4_card = go.transform:Find('sameBody/openbrand/two/bg4/card'):GetComponent('UILabel');
	two4_cardtype1.spriteName = this.checkCardType(midData.cards[4].type)
	two4_cardtype1.depth = 34 + 10;
	two4_cardtype2.spriteName = this.checkCardType(midData.cards[4].type)
	two4_cardtype2.depth = 34 + 10;
	two4_card.text = this.CardToImg(midData.cards[4].card)
	two4_card.depth = 34 + 10;
	local two5_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg5/cardtype1'):GetComponent('UISprite');
	local two5_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg5/cardtype2'):GetComponent('UISprite');
	local two5_card = go.transform:Find('sameBody/openbrand/two/bg5/card'):GetComponent('UILabel');
	two5_cardtype1.spriteName = this.checkCardType(midData.cards[5].type)
	two5_cardtype1.depth = 36 + 10;
	two5_cardtype2.spriteName = this.checkCardType(midData.cards[5].type)
	two5_cardtype2.depth = 36 + 10;
	two5_card.text = this.CardToImg(midData.cards[5].card)
	two5_card.depth = 36 + 10;
	local twoEffect = go.transform:Find('sameBody/openbrand/two/twoEffect').gameObject;
	local twoEffect_UISprite = twoEffect:GetComponent('UISprite');
	twoEffect_UISprite.spriteName = ""
	twoEffect_UISprite.alpha = 0
	local backData = playerData.card_count[3]
	local three1_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg1/cardtype1'):GetComponent('UISprite');
	local three1_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg1/cardtype2'):GetComponent('UISprite');
	local three1_card = go.transform:Find('sameBody/openbrand/three/bg1/card'):GetComponent('UILabel');
	three1_cardtype1.spriteName = this.checkCardType(backData.cards[1].type)
	three1_cardtype2.spriteName = this.checkCardType(backData.cards[1].type)
	three1_card.text = this.CardToImg(backData.cards[1].card)
	local three2_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg2/cardtype1'):GetComponent('UISprite');
	local three2_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg2/cardtype2'):GetComponent('UISprite');
	local three2_card = go.transform:Find('sameBody/openbrand/three/bg2/card'):GetComponent('UILabel');
	three2_cardtype1.spriteName = this.checkCardType(backData.cards[2].type)
	three2_cardtype2.spriteName = this.checkCardType(backData.cards[2].type)
	three2_card.text = this.CardToImg(backData.cards[2].card)
	local three3_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg3/cardtype1'):GetComponent('UISprite');
	local three3_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg3/cardtype2'):GetComponent('UISprite');
	local three3_card = go.transform:Find('sameBody/openbrand/three/bg3/card'):GetComponent('UILabel');
	three3_cardtype1.spriteName = this.checkCardType(backData.cards[3].type)
	three3_cardtype2.spriteName = this.checkCardType(backData.cards[3].type)
	three3_card.text = this.CardToImg(backData.cards[3].card)
	local three4_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg4/cardtype1'):GetComponent('UISprite');
	local three4_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg4/cardtype2'):GetComponent('UISprite');
	local three4_card = go.transform:Find('sameBody/openbrand/three/bg4/card'):GetComponent('UILabel');
	three4_cardtype1.spriteName = this.checkCardType(backData.cards[4].type)
	three4_cardtype2.spriteName = this.checkCardType(backData.cards[4].type)
	three4_card.text = this.CardToImg(backData.cards[4].card)
	local three5_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg5/cardtype1'):GetComponent('UISprite');
	local three5_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg5/cardtype2'):GetComponent('UISprite');
	local three5_card = go.transform:Find('sameBody/openbrand/three/bg5/card'):GetComponent('UILabel');
	three5_cardtype1.spriteName = this.checkCardType(backData.cards[5].type)
	three5_cardtype2.spriteName = this.checkCardType(backData.cards[5].type)
	three5_card.text = this.CardToImg(backData.cards[5].card)
	local threeEffect = go.transform:Find('sameBody/openbrand/three/threeEffect').gameObject;
	local threeEffect_UISprite = threeEffect:GetComponent('UISprite');
	threeEffect_UISprite.spriteName = ""
	threeEffect_UISprite.alpha = 0
end

function SanshuiCtrl.CardToName(id)
	local value = ""
	if(id == this._const.WATER_VALUE_TYPE_190) then
		value = "zitonghuashun"
	elseif(id == this._const.WATER_VALUE_TYPE_175 or id == this._const.WATER_VALUE_TYPE_174) then
		value = "zitiezhi"
	elseif(id == this._const.WATER_VALUE_TYPE_160) then
		value = "zihulu"
	elseif(id == this._const.WATER_VALUE_TYPE_150) then
		value = "zitonghua"
	elseif(id == this._const.WATER_VALUE_TYPE_140) then
		value = "zishunzhi"
	elseif(id == this._const.WATER_VALUE_TYPE_130) then
		value = "zisantiao"
	elseif(id == this._const.WATER_VALUE_TYPE_120) then
		value = "ziliangdui"
	elseif(id == this._const.WATER_VALUE_TYPE_110) then
		value = "ziduizhi"
	elseif(id == this._const.WATER_VALUE_TYPE_100) then
		value = "zigaopai"
	elseif(id == this._const.WATER_VALUE_TYPE_298) then
		value = "zizhizhunqinglong"
	elseif(id == this._const.WATER_VALUE_TYPE_297) then
		value = "ziyitiaolong"
	elseif(id == this._const.WATER_VALUE_TYPE_270) then
		value = "ziliuduibang"
	elseif(id == this._const.WATER_VALUE_TYPE_260) then
		value = "zisantonghua"
	elseif(id == this._const.WATER_VALUE_TYPE_250) then
		value = "zisanshunzi"
	end
	return value
end

function SanshuiCtrl.PlayCardSound(id)
	local value = ""
	if(id == this._const.WATER_VALUE_TYPE_190) then
		value = "TongHuaShun_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_175 or id == this._const.WATER_VALUE_TYPE_174) then
		value = "TieZhi_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_160) then
		value = "HuLu_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_150) then
		value = "TongHua_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_140) then
		value = "ShunZi_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_130) then
		value = "SanTiao_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_120) then
		value = "LiangDui_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_110) then
		value = "DuiZi_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_100) then
		value = "WuLong_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_298) then
		value = "ZhiZunQingLong_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_297) then
		value = "YiTiaoLong_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_270) then
		value = "LiuDuiBan_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_260) then
		value = "SanTongHua_Nv"
	elseif(id == this._const.WATER_VALUE_TYPE_250) then
		value = "SanShunZi_Nv"
	end
	soundMgr:PlaySound(value)
end

function SanshuiCtrl.CardToImg(num)
	local value = num
	if(value == 11) then
		value = "J"
	elseif(value == 12) then
		value = "Q"
	elseif(value == 13) then
		value = "K"
	elseif(value == 14) then
		value = "A"
	end
	return value
end

SanshuiCtrl._allOnlinePlay = 0
function SanshuiCtrl.setPlayerCardData(data,go,playerData)
	local headData = playerData.card_count[1]
	data.headIndex = headData.a_index
	data.headName = headData.card_type
	local one_bg1 = go.transform:Find('sameBody/openbrand/one/bg1'):GetComponent('UISprite');
	local one_bg2 = go.transform:Find('sameBody/openbrand/one/bg2'):GetComponent('UISprite');
	local one_bg3 = go.transform:Find('sameBody/openbrand/one/bg3'):GetComponent('UISprite');
	one_bg1.depth = 17 + 10;
	one_bg2.depth = 19 + 10;
	one_bg3.depth = 21 + 10;
	local one1_cardtype1 = go.transform:Find('sameBody/openbrand/one/bg1/cardtype1'):GetComponent('UISprite');
	local one1_cardtype2 = go.transform:Find('sameBody/openbrand/one/bg1/cardtype2'):GetComponent('UISprite');
	local one1_card = go.transform:Find('sameBody/openbrand/one/bg1/card'):GetComponent('UILabel');
	one1_cardtype1.spriteName = this.checkCardType(headData.cards[1].type)
	one1_cardtype1.depth = 18 + 10;
	one1_cardtype2.spriteName = this.checkCardType(headData.cards[1].type)
	one1_cardtype2.depth = 18 + 10;
	one1_card.text = this.CardToImg(headData.cards[1].card)
	one1_card.depth = 18 + 10;
	local one2_cardtype1 = go.transform:Find('sameBody/openbrand/one/bg2/cardtype1'):GetComponent('UISprite');
	local one2_cardtype2 = go.transform:Find('sameBody/openbrand/one/bg2/cardtype2'):GetComponent('UISprite');
	local one2_card = go.transform:Find('sameBody/openbrand/one/bg2/card'):GetComponent('UILabel');
	one2_cardtype1.spriteName = this.checkCardType(headData.cards[2].type)
	one2_cardtype1.depth = 20 + 10;
	one2_cardtype2.spriteName = this.checkCardType(headData.cards[2].type)
	one2_cardtype2.depth = 20 + 10;
	one2_card.text = this.CardToImg(headData.cards[2].card)
	one2_card.depth = one2_card.depth + 10;
	local one3_cardtype1 = go.transform:Find('sameBody/openbrand/one/bg3/cardtype1'):GetComponent('UISprite');
	local one3_cardtype2 = go.transform:Find('sameBody/openbrand/one/bg3/cardtype2'):GetComponent('UISprite');
	local one3_card = go.transform:Find('sameBody/openbrand/one/bg3/card'):GetComponent('UILabel');
	one3_cardtype1.spriteName = this.checkCardType(headData.cards[3].type)
	one3_cardtype1.depth = 22 + 10;
	one3_cardtype2.spriteName = this.checkCardType(headData.cards[3].type)
	one3_cardtype2.depth = 22 + 10;
	one3_card.text = this.CardToImg(headData.cards[3].card)
	one3_card.depth = 22 + 10;
	local oneEffect = go.transform:Find('sameBody/openbrand/one/oneEffect').gameObject;
	local oneEffect_UISprite = oneEffect:GetComponent('UISprite');
	oneEffect_UISprite.spriteName = this.CardToName(headData.card_type)
	oneEffect_UISprite.alpha = 1
	oneEffect_UISprite:MakePixelPerfect();
	local midData = playerData.card_count[2]
	data.midIndex = midData.a_index
	data.midName = midData.card_type
	local two_bg1 = go.transform:Find('sameBody/openbrand/two/bg1'):GetComponent('UISprite');
	local two_bg2 = go.transform:Find('sameBody/openbrand/two/bg2'):GetComponent('UISprite');
	local two_bg3 = go.transform:Find('sameBody/openbrand/two/bg3'):GetComponent('UISprite');
	local two_bg4 = go.transform:Find('sameBody/openbrand/two/bg4'):GetComponent('UISprite');
	local two_bg5 = go.transform:Find('sameBody/openbrand/two/bg5'):GetComponent('UISprite');
	two_bg1.depth = 27 + 10;
	two_bg2.depth = 29 + 10;
	two_bg3.depth = 31 + 10;
	two_bg4.depth = 33 + 10;
	two_bg5.depth = 35 + 10;
	local two1_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg1/cardtype1'):GetComponent('UISprite');
	local two1_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg1/cardtype2'):GetComponent('UISprite')
	local two1_card = go.transform:Find('sameBody/openbrand/two/bg1/card'):GetComponent('UILabel');
	two1_cardtype1.spriteName = this.checkCardType(midData.cards[1].type)
	two1_cardtype1.depth = 28 + 10;
	two1_cardtype2.spriteName = this.checkCardType(midData.cards[1].type)
	two1_cardtype2.depth = 28 + 10;
	two1_card.text = this.CardToImg(midData.cards[1].card)
	two1_card.depth = 28 + 10;
	local two2_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg2/cardtype1'):GetComponent('UISprite');
	local two2_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg2/cardtype2'):GetComponent('UISprite');
	local two2_card = go.transform:Find('sameBody/openbrand/two/bg2/card'):GetComponent('UILabel');
	two2_cardtype1.spriteName = this.checkCardType(midData.cards[2].type)
	two2_cardtype1.depth = 30 + 10;
	two2_cardtype2.spriteName = this.checkCardType(midData.cards[2].type)
	two2_cardtype2.depth = 30 + 10;
	two2_card.text = this.CardToImg(midData.cards[2].card)
	two2_card.depth = 30 + 10;
	local two3_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg3/cardtype1'):GetComponent('UISprite');
	local two3_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg3/cardtype2'):GetComponent('UISprite');
	local two3_card = go.transform:Find('sameBody/openbrand/two/bg3/card'):GetComponent('UILabel');
	two3_cardtype1.spriteName = this.checkCardType(midData.cards[3].type)
	two3_cardtype1.depth = 32 + 10;
	two3_cardtype2.spriteName = this.checkCardType(midData.cards[3].type)
	two3_cardtype2.depth = 32 + 10;
	two3_card.text = this.CardToImg(midData.cards[3].card)
	two3_card.depth = 32 + 10;
	local two4_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg4/cardtype1'):GetComponent('UISprite');
	local two4_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg4/cardtype2'):GetComponent('UISprite');
	local two4_card = go.transform:Find('sameBody/openbrand/two/bg4/card'):GetComponent('UILabel');
	two4_cardtype1.spriteName = this.checkCardType(midData.cards[4].type)
	two4_cardtype1.depth = 34 + 10;
	two4_cardtype2.spriteName = this.checkCardType(midData.cards[4].type)
	two4_cardtype2.depth = 34 + 10;
	two4_card.text = this.CardToImg(midData.cards[4].card)
	two4_card.depth = 34 + 10;
	local two5_cardtype1 = go.transform:Find('sameBody/openbrand/two/bg5/cardtype1'):GetComponent('UISprite');
	local two5_cardtype2 = go.transform:Find('sameBody/openbrand/two/bg5/cardtype2'):GetComponent('UISprite');
	local two5_card = go.transform:Find('sameBody/openbrand/two/bg5/card'):GetComponent('UILabel');
	two5_cardtype1.spriteName = this.checkCardType(midData.cards[5].type)
	two5_cardtype1.depth = 36 + 10;
	two5_cardtype2.spriteName = this.checkCardType(midData.cards[5].type)
	two5_cardtype2.depth = 36 + 10;
	two5_card.text = this.CardToImg(midData.cards[5].card)
	two5_card.depth = 36 + 10;
	local twoEffect = go.transform:Find('sameBody/openbrand/two/twoEffect').gameObject;
	local twoEffect_UISprite = twoEffect:GetComponent('UISprite');
	twoEffect_UISprite.spriteName = this.CardToName(midData.card_type)
	twoEffect_UISprite.alpha = 1
	twoEffect_UISprite:MakePixelPerfect();
	local backData = playerData.card_count[3]
	data.backIndex = backData.a_index
	data.backName = backData.card_type
	local three1_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg1/cardtype1'):GetComponent('UISprite');
	local three1_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg1/cardtype2'):GetComponent('UISprite');
	local three1_card = go.transform:Find('sameBody/openbrand/three/bg1/card'):GetComponent('UILabel');
	three1_cardtype1.spriteName = this.checkCardType(backData.cards[1].type)
	three1_cardtype2.spriteName = this.checkCardType(backData.cards[1].type)
	three1_card.text = this.CardToImg(backData.cards[1].card)
	local three2_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg2/cardtype1'):GetComponent('UISprite');
	local three2_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg2/cardtype2'):GetComponent('UISprite');
	local three2_card = go.transform:Find('sameBody/openbrand/three/bg2/card'):GetComponent('UILabel');
	three2_cardtype1.spriteName = this.checkCardType(backData.cards[2].type)
	three2_cardtype2.spriteName = this.checkCardType(backData.cards[2].type)
	three2_card.text = this.CardToImg(backData.cards[2].card)
	local three3_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg3/cardtype1'):GetComponent('UISprite');
	local three3_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg3/cardtype2'):GetComponent('UISprite');
	local three3_card = go.transform:Find('sameBody/openbrand/three/bg3/card'):GetComponent('UILabel');
	three3_cardtype1.spriteName = this.checkCardType(backData.cards[3].type)
	three3_cardtype2.spriteName = this.checkCardType(backData.cards[3].type)
	three3_card.text = this.CardToImg(backData.cards[3].card)
	local three4_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg4/cardtype1'):GetComponent('UISprite');
	local three4_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg4/cardtype2'):GetComponent('UISprite');
	local three4_card = go.transform:Find('sameBody/openbrand/three/bg4/card'):GetComponent('UILabel');
	three4_cardtype1.spriteName = this.checkCardType(backData.cards[4].type)
	three4_cardtype2.spriteName = this.checkCardType(backData.cards[4].type)
	three4_card.text = this.CardToImg(backData.cards[4].card)
	local three5_cardtype1 = go.transform:Find('sameBody/openbrand/three/bg5/cardtype1'):GetComponent('UISprite');
	local three5_cardtype2 = go.transform:Find('sameBody/openbrand/three/bg5/cardtype2'):GetComponent('UISprite');
	local three5_card = go.transform:Find('sameBody/openbrand/three/bg5/card'):GetComponent('UILabel');
	three5_cardtype1.spriteName = this.checkCardType(backData.cards[5].type)
	three5_cardtype2.spriteName = this.checkCardType(backData.cards[5].type)
	three5_card.text = this.CardToImg(backData.cards[5].card)
	local threeEffect = go.transform:Find('sameBody/openbrand/three/threeEffect').gameObject;
	local threeEffect_UISprite = threeEffect:GetComponent('UISprite');
	threeEffect_UISprite.spriteName = this.CardToName(backData.card_type)
	threeEffect_UISprite.alpha = 1
	threeEffect_UISprite:MakePixelPerfect();
	local headScore = go.transform:Find('sameBody/score/headScore').gameObject;
	local headScore_UILabel = headScore:GetComponent('UILabel');
	local headadd = headData.add_odds + headData.extra_odds
	-- local headext = headData.extra_odds
	if(headadd >= 0) then
		headadd = "+" .. headadd
	end
	-- if(headData.extra_odds >= 0) then
	-- 	headext = "+" .. headData.extra_odds
	-- end
	headScore_UILabel.text = headadd --.. " (" .. headext ..")"
	local midScore = go.transform:Find('sameBody/score/midScore').gameObject;
	local midScore_UILabel = midScore:GetComponent('UILabel');
	local midadd = midData.add_odds + midData.extra_odds
	-- local midext = midData.extra_odds
	if(midadd >= 0) then
		midadd = "+" .. midadd
	end
	-- if(midData.extra_odds >= 0) then
	-- 	midext = "+" .. midData.extra_odds
	-- end
	midScore_UILabel.text = midadd --.. " (" .. midext ..")"
	local backScore = go.transform:Find('sameBody/score/backScore').gameObject;
	local backScore_UILabel = backScore:GetComponent('UILabel');
	local backadd = backData.add_odds + backData.extra_odds
	-- local backext = backData.extra_odds
	if(backadd >= 0) then
		backadd = "+" .. backadd
	end
	-- if(backData.extra_odds >= 0) then
	-- 	backext = "+" .. backData.extra_odds
	-- end
	backScore_UILabel.text = backadd --.. " (" .. backext ..")"
	local allScore = go.transform:Find('sameBody/score/allScore').gameObject;
	local allScore_UILabel = allScore:GetComponent('UILabel');
	local totalodds = playerData.total_odds + playerData.extra_odds
	if(totalodds >= 0) then
		totalodds = "+" .. totalodds
	end
	allScore_UILabel.text = totalodds
end

SanshuiCtrl.startDeal = false
SanshuiCtrl._startPox = 0
SanshuiCtrl._startIndex = 1
function SanshuiCtrl.dealCardTime()
	if(this.allPlayerList ~= nil and this.startDeal)then
		local len = #this.allPlayerList;
		if(len > 0) then
			for i=1,len do
				local data = this.allPlayerList[i]
				if(this._startPox == 1 and data.playerInfo ~= nil) then --头
					if(this._startIndex == data.headIndex) then
						if(data.duration > 0) then
							data.duration = data.duration - Time.deltaTime
						else
							this.animatime = this.animatime - 1
							this._startIndex = this._startIndex + 1
							if(data.midIndex == 1 and this.IsCoixtSpeial == false) then
								data.duration = 1.5
							else
								data.duration = 1
							end
							this.playHeadCardAnima(data.prefab)
							this.PlayCardSound(data.headName)
							if(this._startIndex > this._allOnlinePlay) then
								this.animatime = this.animatime - 1
								this._startIndex = 1
								this._startPox = this._startPox + 1
								local oneclose = data.prefab.transform:Find('sameBody/closebrand/oneclose').gameObject;
								oneclose:SetActive(false)
								if(this.IsCoixtSpeial == false and this._ownIsCard) then
									global._view:Invoke(0.8,function ()
										this.playHeadScoreAnima()
									end)
								end
							end
							break
						end
					end
				elseif(this._startPox == 2 and data.playerInfo ~= nil) then --中
					if(this._startIndex == data.midIndex) then
						if(data.duration > 0) then
							data.duration = data.duration - Time.deltaTime
						else
							this.animatime = this.animatime - 1
							this._startIndex = this._startIndex + 1
							if(data.backIndex == 1 and this.IsCoixtSpeial == false) then
								data.duration = 1.5
							else
								data.duration = 1
							end
							this.playMidCardAnima(data.prefab)
							this.PlayCardSound(data.midName)
							if(this._startIndex > this._allOnlinePlay) then
								this.animatime = this.animatime - 1
								this._startIndex = 1
								this._startPox = this._startPox + 1
								local twoclose = data.prefab.transform:Find('sameBody/closebrand/twoclose').gameObject;
								twoclose:SetActive(false)
								if(this.IsCoixtSpeial == false and this._ownIsCard) then
									global._view:Invoke(0.8,function ()
										this.playMidScoreAnima()
									end)
								end
							end
							break
						end
					end
				elseif(this._startPox == 3 and data.playerInfo ~= nil) then --尾
					if(this._startIndex == data.backIndex) then
						if(data.duration > 0) then
							data.duration = data.duration - Time.deltaTime
						else
							this.animatime = this.animatime - 1
							this._startIndex = this._startIndex + 1
							data.duration = 1
							this.playBackCardAnima(data.prefab)
							this.PlayCardSound(data.backName)
							if(this._startIndex > this._allOnlinePlay) then
								this._startIndex = 1
								this._startPox = this._startPox + 1
								local threeclose = data.prefab.transform:Find('sameBody/closebrand/threeclose').gameObject;
								threeclose:SetActive(false)
								if(this._IsSpec == 0) then
									this.startDeal = false
								end
								if(this.IsCoixtSpeial == false and this._ownIsCard) then
									global._view:Invoke(0.8,function ()
										this.playBackScoreAnima()
										if(this._IsSpec == 0) then
											global._view:Invoke(0.8,function ()
												this.playAllScoreAnima()
											end)
										end
									end)
								end
							end
							break
						end
					end
				elseif(this._startPox == 4 and data.playerInfo ~= nil) then --特殊牌
					if(this._startIndex == data.specIndex) then
						if(data.duration > 0) then
							data.duration = data.duration - Time.deltaTime
						else
							this.animatime = this.animatime - 1
							this._startIndex = this._startIndex + 1
							data.duration = 1
							this.playSpecAnima(data.prefab)
							this.PlayCardSound(data.specName)
							if(this._startIndex > this._IsSpec) then
								this._startIndex = 1
								this._startPox = this._startPox + 1
								this.startDeal = false
								if(this._ownIsCard) then
									global._view:Invoke(0.8,function ()
										this.playAllScoreAnima()
									end)
								end
							end
							break
						end
					end
				end
			end
		end
	end
end

function SanshuiCtrl.playAnim()
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			if(data.playerInfo.id == playerid) then
				
			end
		end
	end
end

function SanshuiCtrl.stopAllAnima(list)
	this._IsCome = false
	this.startDeal = false
	local count = #list
	if(count > 0) then
		local len = #this.allPlayerList
		for i=1,len do
			local data = this.allPlayerList[i]
			if(data.playerInfo ~= nil) then
				for j=1,count do
					local playerData = list[j]
					if(data.playerInfo.id == playerData.playerid) then
						-- this.addMoundBullet(data)
						local go = data.prefab
						data.mound_odds = playerData.mound_odds
						data.swat = playerData.swat
						data.total_odds = playerData.total_odds
						data.extra_odds = playerData.extra_odds
						if(playerData.is_spec == 1) then --特殊牌型
							this.SpecialCardData(playerData,go)
							this.stopSpecAnima(go,playerData.card_type)
						else
							this.setPlayerCardData(data,data.prefab,playerData)
							this.stopHeadCardAnima(go)
							this.stopMidCardAnima(go)
							this.stopBackCardAnima(go)
						end
						break
					end
				end
			end
		end
		if(this.myPlayerInfo == nil) then
			this.getMyPlayerInfo()
		end
	end
	if(this.IsCoixtSpeial == false) then
		this.stopHeadScoreAnima()
		this.stopMidScoreAnima()
		this.stopBackScoreAnima()
	end
	this.stopAllScoreAnima()
end

function SanshuiCtrl.playHeadScoreAnima()
	if(this._IsCome == false) then
		return
	end
	if(this.myPlayerInfo == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local go = this.myPlayerInfo.prefab
	local headScore = go.transform:Find('sameBody/score/headScore').gameObject;
	local headScore_TweenScale = headScore:GetComponent('TweenScale');
	headScore:SetActive(true)
	headScore_TweenScale:ResetToBeginning()
	if(headScore_TweenScale.enabled == false) then
    	headScore_TweenScale.enabled = true
    end
end

function SanshuiCtrl.stopHeadScoreAnima()
	if(this.myPlayerInfo == nil) then
		return
	end
	local go = this.myPlayerInfo.prefab
	local headScore = go.transform:Find('sameBody/score/headScore').gameObject;
	local headScore_TweenScale = headScore:GetComponent('TweenScale');
	headScore:SetActive(true)
	headScore.transform.localScale = Vector3.one
    headScore_TweenScale.enabled = false
end

function SanshuiCtrl.playMidScoreAnima()
	if(this._IsCome == false) then
		return
	end
	if(this.myPlayerInfo == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local go = this.myPlayerInfo.prefab
	local midScore = go.transform:Find('sameBody/score/midScore').gameObject;
	local midScore_TweenScale = midScore:GetComponent('TweenScale');
	midScore:SetActive(true)
	midScore_TweenScale:ResetToBeginning()
	if(midScore_TweenScale.enabled == false) then
    	midScore_TweenScale.enabled = true
    end
end

function SanshuiCtrl.stopMidScoreAnima()
	if(this.myPlayerInfo == nil) then
		return
	end
	local go = this.myPlayerInfo.prefab
	local midScore = go.transform:Find('sameBody/score/midScore').gameObject;
	local midScore_TweenScale = midScore:GetComponent('TweenScale');
	midScore:SetActive(true)
	midScore.transform.localScale = Vector3.one
    midScore_TweenScale.enabled = false
end

function SanshuiCtrl.playBackScoreAnima()
	if(this._IsCome == false) then
		return
	end
	if(this.myPlayerInfo == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local go = this.myPlayerInfo.prefab
	local backScore = go.transform:Find('sameBody/score/backScore').gameObject;
	local backScore_TweenScale = backScore:GetComponent('TweenScale');
	backScore:SetActive(true)
	backScore_TweenScale:ResetToBeginning()
	if(backScore_TweenScale.enabled == false) then
    	backScore_TweenScale.enabled = true
    end
end

function SanshuiCtrl.stopBackScoreAnima()
	if(this.myPlayerInfo == nil) then
		return
	end
	local go = this.myPlayerInfo.prefab
	local backScore = go.transform:Find('sameBody/score/backScore').gameObject;
	local backScore_TweenScale = backScore:GetComponent('TweenScale');
	backScore:SetActive(true)
	backScore.transform.localScale = Vector3.one
    backScore_TweenScale.enabled = false
end

function SanshuiCtrl.replayAllScoreAnima(IsShoot)
	if(this._IsCome == false) then
		return
	end
	if(this.myPlayerInfo == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local score = 0
	if(IsShoot) then
		score = this.myPlayerInfo.total_odds + this.myPlayerInfo.extra_odds + this.myPlayerInfo.mound_odds
	else
		score = this.myPlayerInfo.total_odds + this.myPlayerInfo.extra_odds + this.myPlayerInfo.mound_odds + this.myPlayerInfo.swat
	end
	local go = this.myPlayerInfo.prefab
	local allScore = go.transform:Find('sameBody/score/allScore').gameObject;
	local allScore_UILabel = allScore:GetComponent('UILabel');
	local start = score
	if(start >= 0) then
		allScore_UILabel.text = "+" .. start
	else
		allScore_UILabel.text = start
	end
	local allScore_TweenScale = allScore:GetComponent('TweenScale');
	allScore:SetActive(true)
	allScore_TweenScale:ResetToBeginning()
	if(allScore_TweenScale.enabled == false) then
    	allScore_TweenScale.enabled = true
    end
    if(this.myPlayerInfo.swat ~= 0 and IsShoot) then
    	global._view:Invoke(0.5,function ()
    		if(this._curState == this._const.WATER_STATUS_OPEN) then
    			soundMgr:PlaySound("QuanLeiDa_Nv")
    			SanshuiPanel.specAnima:SetActive(true)
				SanshuiPanel.specIcon_UISprite.spriteName = "tbquangleida"
				SanshuiPanel.specIcon_UISprite:MakePixelPerfect()
				this.replayAllScoreAnima(false)
    		end
		end)
    end
end

function SanshuiCtrl.playAllScoreAnima()
	if(this._IsCome == false) then
		return
	end
	if(this.myPlayerInfo == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local go = this.myPlayerInfo.prefab
	local allScore = go.transform:Find('sameBody/score/allScore').gameObject;
	local allScore_TweenScale = allScore:GetComponent('TweenScale');
	allScore:SetActive(true)
	allScore_TweenScale:ResetToBeginning()
	if(allScore_TweenScale.enabled == false) then
    	allScore_TweenScale.enabled = true
    end
    global._view:Invoke(0.5,function ()
    	if(this._curState == this._const.WATER_STATUS_OPEN) then
			this.playShootAnima()
		end
	end)
end

function SanshuiCtrl.stopAllScoreAnima()
	if(this.myPlayerInfo == nil) then
		return
	end
	local score = this.myPlayerInfo.total_odds + this.myPlayerInfo.extra_odds + this.myPlayerInfo.mound_odds + this.myPlayerInfo.swat
	local go = this.myPlayerInfo.prefab
	local allScore = go.transform:Find('sameBody/score/allScore').gameObject;
	local allScore_UILabel = allScore:GetComponent('UILabel');
	local start = score
	if(start >= 0) then
		allScore_UILabel.text = "+" .. start
	else
		allScore_UILabel.text = start
	end
	local allScore_TweenScale = allScore:GetComponent('TweenScale');
	allScore:SetActive(true)
	allScore.transform.localScale = Vector3.one
    allScore_TweenScale.enabled = false
end

function SanshuiCtrl.playHeadCardAnima(go)
	if(this._IsCome == false) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local one = go.transform:Find('sameBody/openbrand/one').gameObject;
	local one_TweenScale = one:GetComponent('TweenScale');
	local oneEffect = go.transform:Find('sameBody/openbrand/one/oneEffect').gameObject;
	local oneEffect_TweenAlpha = oneEffect:GetComponent('TweenAlpha');
	one:SetActive(true)
	one_TweenScale:ResetToBeginning()
	if(one_TweenScale.enabled == false) then
    	one_TweenScale.enabled = true
    end
    oneEffect_TweenAlpha:ResetToBeginning()
	if(oneEffect_TweenAlpha.enabled == false) then
    	oneEffect_TweenAlpha.enabled = true
    end
end

function SanshuiCtrl.stopHeadCardAnima(go)
	local one = go.transform:Find('sameBody/openbrand/one').gameObject;
	local one_TweenScale = one:GetComponent('TweenScale');
	local oneEffect = go.transform:Find('sameBody/openbrand/one/oneEffect').gameObject;
	local oneEffect_TweenAlpha = oneEffect:GetComponent('TweenAlpha');
	one:SetActive(true)
	one.transform.localScale = Vector3.one
	oneEffect:GetComponent('UISprite').alpha = 0;
	one_TweenScale.enabled = false
	oneEffect_TweenAlpha.enabled = false
end

function SanshuiCtrl.playMidCardAnima(go)
	if(this._IsCome == false) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local two = go.transform:Find('sameBody/openbrand/two').gameObject;
	local two_TweenScale = two:GetComponent('TweenScale');
	local twoEffect = go.transform:Find('sameBody/openbrand/two/twoEffect').gameObject;
	local twoEffect_TweenAlpha = twoEffect:GetComponent('TweenAlpha');
	two:SetActive(true)
	two_TweenScale:ResetToBeginning()
	if(two_TweenScale.enabled == false) then
    	two_TweenScale.enabled = true
    end
    twoEffect_TweenAlpha:ResetToBeginning()
	if(twoEffect_TweenAlpha.enabled == false) then
    	twoEffect_TweenAlpha.enabled = true
    end
end

function SanshuiCtrl.stopMidCardAnima(go)
	local two = go.transform:Find('sameBody/openbrand/two').gameObject;
	local two_TweenScale = two:GetComponent('TweenScale');
	local twoEffect = go.transform:Find('sameBody/openbrand/two/twoEffect').gameObject;
	local twoEffect_TweenAlpha = twoEffect:GetComponent('TweenAlpha');
	two:SetActive(true)
	two.transform.localScale = Vector3.one
	twoEffect:GetComponent('UISprite').alpha = 0;
	two_TweenScale.enabled = false
	twoEffect_TweenAlpha.enabled = false
end

function SanshuiCtrl.playBackCardAnima(go)
	if(this._IsCome == false) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local three = go.transform:Find('sameBody/openbrand/three').gameObject;
	local three_TweenScale = three:GetComponent('TweenScale');
	local threeEffect = go.transform:Find('sameBody/openbrand/three/threeEffect').gameObject;
	local threeEffect_TweenAlpha = threeEffect:GetComponent('TweenAlpha');
	three:SetActive(true)
	three_TweenScale:ResetToBeginning()
	if(three_TweenScale.enabled == false) then
    	three_TweenScale.enabled = true
    end
    threeEffect_TweenAlpha:ResetToBeginning()
	if(threeEffect_TweenAlpha.enabled == false) then
    	threeEffect_TweenAlpha.enabled = true
    end
end

function SanshuiCtrl.stopBackCardAnima(go)
	local three = go.transform:Find('sameBody/openbrand/three').gameObject;
	local three_TweenScale = three:GetComponent('TweenScale');
	local threeEffect = go.transform:Find('sameBody/openbrand/three/threeEffect').gameObject;
	local threeEffect_TweenAlpha = threeEffect:GetComponent('TweenAlpha');
	three:SetActive(true)
	three.transform.localScale = Vector3.one
	threeEffect:GetComponent('UISprite').alpha = 0;
	three_TweenScale.enabled = false
	threeEffect_TweenAlpha.enabled = false
end

function SanshuiCtrl.playSpecAnima(go)
	if(this._IsCome == false) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		return
	end
	local specialIcon = go.transform:Find('sameBody/closebrand/special/specialIcon').gameObject;
	specialIcon:SetActive(false)
	local cardName = go.transform:Find('sameBody/closebrand/special/cardName').gameObject;
	local cardName_TweenScale = cardName:GetComponent('TweenScale');
	cardName:SetActive(true)
	cardName_TweenScale:ResetToBeginning()
	if(cardName_TweenScale.enabled == false) then
    	cardName_TweenScale.enabled = true
    end
    local one = go.transform:Find('sameBody/openbrand/one').gameObject;
	one:SetActive(true)
    local two = go.transform:Find('sameBody/openbrand/two').gameObject;
	two:SetActive(true)
    local three = go.transform:Find('sameBody/openbrand/three').gameObject;
	three:SetActive(true)
end

function SanshuiCtrl.stopSpecAnima(go,card_type)
	local special = go.transform:Find('sameBody/closebrand/special').gameObject;
	local specialIcon = go.transform:Find('sameBody/closebrand/special/specialIcon').gameObject;
	special:SetActive(true)
	specialIcon:SetActive(false)
	local cardName = go.transform:Find('sameBody/closebrand/special/cardName').gameObject;
	local cardName_UISprite = cardName:GetComponent('UISprite');
	local cardName_TweenScale = cardName:GetComponent('TweenScale');
	cardName:SetActive(true)
	cardName_UISprite.spriteName = this.CardToName(card_type)
	cardName_UISprite:MakePixelPerfect();
	cardName.transform.localScale = Vector3.one
    cardName_TweenScale.enabled = false
    local one = go.transform:Find('sameBody/openbrand/one').gameObject;
	one:SetActive(true)
    local two = go.transform:Find('sameBody/openbrand/two').gameObject;
	two:SetActive(true)
    local three = go.transform:Find('sameBody/openbrand/three').gameObject;
	three:SetActive(true)
end

function SanshuiCtrl.InsertPlayerInfo(info)
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo == nil) then
			data.playerInfo = info
			this.setPlayerData(data.prefab,info,0)
			break;
		end
	end
	this.totalOnlinePlayer()
end

function SanshuiCtrl.totalOnlinePlayer()
	local len = #this.allPlayerList
	local num = 0
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			num = num + 1
			if(this.patterntype == 1) then
				this.updatePosCoin(data.playerInfo.id,data.playerInfo.coin,this._MinCoin)
			end
		end
	end
	if(this.patterntype == 1) then
		if(num > 1) then
			SanshuiPanel.timebg:SetActive(true)
		else
			SanshuiPanel.timebg:SetActive(false)
		end
	else
		SanshuiPanel.timebg:SetActive(true)
	end
end

function SanshuiCtrl.changePlayerState()
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			data.playerInfo.betcoin = 0
			local go = data.prefab
			this.updateCardInfo(go)
		end
	end
end

function SanshuiCtrl.updateCardInfo(go)
	local special = go.transform:Find('sameBody/closebrand/special').gameObject;
	local specialIcon = go.transform:Find('sameBody/closebrand/special/specialIcon').gameObject;
	local cardName = go.transform:Find('sameBody/closebrand/special/cardName').gameObject;
	special:SetActive(false)
	specialIcon:SetActive(true)
	cardName:SetActive(false)
	local closebrand = go.transform:Find('sameBody/closebrand').gameObject;
	local branding = go.transform:Find('sameBody/branding').gameObject;
	closebrand:SetActive(false)
	branding:SetActive(false)
	local one = go.transform:Find('sameBody/openbrand/one').gameObject;
	local two = go.transform:Find('sameBody/openbrand/two').gameObject;
	local three = go.transform:Find('sameBody/openbrand/three').gameObject;
	one:SetActive(false)
	two:SetActive(false)
	three:SetActive(false)
	local headScore = go.transform:Find('sameBody/score/headScore').gameObject;
	local midScore = go.transform:Find('sameBody/score/midScore').gameObject;
	local backScore = go.transform:Find('sameBody/score/backScore').gameObject;
	local allScore = go.transform:Find('sameBody/score/allScore').gameObject;
	headScore:SetActive(false)
	midScore:SetActive(false)
	backScore:SetActive(false)
	allScore:SetActive(false)
end

function SanshuiCtrl.updatePosCoin(id,playerCoin,betCoin)
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			if(data.playerInfo.id == id) then
				data.playerInfo.coin = playerCoin
				if(this.patterntype == 1) then
					data.playerInfo.betcoin = betCoin
				else
					data.playerInfo.betcoin = data.playerInfo.betcoin + betCoin
				end
				local sbetCoin = data.prefab.transform:Find('sameBody/betCoin').gameObject;
				local betCoin_UILabel = sbetCoin:GetComponent('UILabel');
				betCoin_UILabel.text = data.playerInfo.betcoin;
				local roleCoin = data.prefab.transform:Find('sameBody/roleCoin').gameObject;
				local roleCoin_UILabel = roleCoin:GetComponent('UILabel');
				roleCoin_UILabel.text = playerCoin
				break;
			end
		end
	end
end

function SanshuiCtrl.DeletePlayerInfo(playerid)
	local len = #this.allPlayerList
	for i=1,len do
		local data = this.allPlayerList[i]
		if(data.playerInfo ~= nil) then
			if(data.playerInfo.id == playerid) then
				local go = data.prefab
				this.updateCardInfo(go)
				local nohead = go.transform:Find('nohead').gameObject;
				nohead:SetActive(true)
				local sameBody = go.transform:Find('sameBody').gameObject;
				sameBody:SetActive(false)
				local PlayerIcon = go.transform:Find('sameBody/PlayerIcon').gameObject;
				local PlayerIcon_AsyncImageDownload = PlayerIcon:GetComponent('AsyncImageDownload');
				PlayerIcon_AsyncImageDownload:SetAsyncImage("")
				local rolename = go.transform:Find('sameBody/rolename').gameObject;
				local rolename_UILabel = rolename:GetComponent('UILabel');
				rolename_UILabel.text = ""
				local betCoin = go.transform:Find('sameBody/betCoin').gameObject;
				local betCoin_UILabel = betCoin:GetComponent('UILabel');
				betCoin_UILabel.text = 0;
				local roleCoin = go.transform:Find('sameBody/roleCoin').gameObject;
				local roleCoin_UILabel = roleCoin:GetComponent('UILabel');
				roleCoin_UILabel.text = 0
				data.playerInfo = nil
				data.headIndex = 0
				data.midIndex = 0
				data.backIndex = 0
				data.duration = 0.4
				data.mound = {}
				data.mound_odds = 0
				data.total_odds = 0
				data.extra_odds = 0
				data.swat = 0
				break;
			end
		end
	end
	this.totalOnlinePlayer()
end

function SanshuiCtrl.setPlayerData(go,info)
	local nohead = go.transform:Find('nohead').gameObject;
	nohead:SetActive(false)
	local sameBody = go.transform:Find('sameBody').gameObject;
	sameBody:SetActive(true)
	local PlayerIcon = go.transform:Find('sameBody/PlayerIcon').gameObject;
	local PlayerIcon_AsyncImageDownload = PlayerIcon:GetComponent('AsyncImageDownload');
	PlayerIcon_AsyncImageDownload:SetAsyncImage(info.icon)
	local rolename = go.transform:Find('sameBody/rolename').gameObject;
	local rolename_UILabel = rolename:GetComponent('UILabel');
	rolename_UILabel.text = info.name
	local betCoin = go.transform:Find('sameBody/betCoin').gameObject;
	local betCoin_UILabel = betCoin:GetComponent('UILabel');
	betCoin_UILabel.text = 0;
	local roleCoin = go.transform:Find('sameBody/roleCoin').gameObject;
	local roleCoin_UILabel = roleCoin:GetComponent('UILabel');
	roleCoin_UILabel.text = info.coin
end

SanshuiCtrl._uiPreant = nil
function SanshuiCtrl.showUIprefab(name)
	SanshuiPanel.uibox:SetActive(true)
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
	this._uiPreant.transform.parent = SanshuiPanel.showUI.transform;
	this._uiPreant.transform.localScale = Vector3.one;
	this._uiPreant.transform.localPosition = Vector3.zero;
	resMgr:addAltas(this._uiPreant.transform,"Room")
end

function SanshuiCtrl.cardSort(list)
	table.sort(list,function (a,b)
        return a.num > b.num
    end)
    return list
end

function SanshuiCtrl.OnShare()
	this.showUIprefab("shareUI")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "shareUIbar") then
			local sharefriend = this._uiPreant.transform:Find('sharefriend').gameObject;
			this.Room:AddClick(sharefriend, function ()
				local desc = "同时200人在线批批卢,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "批批卢[房号:" .. this.RoomId .. "]"
				if(this.IsGameRoom) then
					desc = "同时200人在线批批卢,您的好友邀请您进入游戏"
					title = "批批卢[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(1,desc,"",title)
			end);
			local shareall = this._uiPreant.transform:Find('shareall').gameObject;
			this.Room:AddClick(shareall, function ()
				local desc = "同时200人在线批批卢,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "批批卢[房号:" .. this.RoomId .. "]"
				if(this.IsGameRoom) then
					desc = "同时200人在线批批卢,您的好友邀请您进入游戏"
					title = "批批卢[大厅:" .. this.RoomTitle .. "]"
				end
				global.sdk_mgr:share(0,desc,"",title)
			end);
		end
	end
end

SanshuiCtrl._allBetCoin = 0
SanshuiCtrl._totalBetCoin = 0
SanshuiCtrl._PlayermaxCoin = 0
SanshuiCtrl._playerCoin = 0
SanshuiCtrl._IsAllBet = false
function SanshuiCtrl.OnBetBtn(go)
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_BET) then
		return
	end
	if(this._IsRoom) then
		return
	end
	if(this._totalBetCoin > this._PlayermaxCoin) then
		return
	end
	local coin = 0
	local betType = 1
	if(go.name == "betfive") then --1
		coin = 1
		betType = 1
	elseif(go.name == "betten") then --5
		coin = 5
		betType = 2
	elseif(go.name == "bethund") then --10
		coin = 10
		betType = 3
	elseif(go.name == "betkilo") then --20
		coin = 20
		betType = 4
	elseif(go.name == "bettenshou") then --50
		coin = 50
		betType = 5
	elseif(go.name == "betmill") then --100
		coin = 100
		betType = 6
	end
	local max = this._allBetCoin + coin
	if(max > this._PlayermaxCoin - this._totalBetCoin) then
		SanshuiPanel.setTip("已达到当局最大下注")
		return
	end
	if(max > this._playerCoin) then
		SanshuiPanel.setTip("钱不够咯")
		return
	end
	this._allBetCoin = this._allBetCoin + coin
	SanshuiPanel.BetCoin_UILabel.text = this._allBetCoin
end

function SanshuiCtrl.BetFillCallBack(totalCoin)
	this._totalBetCoin = this._totalBetCoin + totalCoin
	this._allBetCoin = 0;
	SanshuiPanel.BetCoin_UILabel.text = 0
end

function SanshuiCtrl.updatePlayerInfo()
	if(global._view:getViewBase("Support")~=nil)then
		global._view:getViewBase("Support").clearView();
	end
	this._playerCoin = SanshuiPanel.getPlayerCoin() + SanshuiPanel.getPlayerRMB()
	SanshuiPanel.playerCoin_UILabel.text = SanshuiPanel.getPlayerRMB()
	SanshuiPanel.playerSilver_UILabel.text = SanshuiPanel.getPlayerCoin()
	this._betCoin = 0
	SanshuiPanel.playerName_UILabel.text = GameData.GetShortName(SanshuiPanel.getPlayerName(),14,12) .. "\nID:" .. SanshuiPanel.getPlayerId()
end

function SanshuiCtrl.OnInvite()
	if(this.IsGameRoom) then
		return
	end
	if(this._const == nil) then
		return
	end
	global.player:get_mgr("room"):req_invite_join_room(this._const.GAME_ID_WATER,this.RoomId)
end

SanshuiCtrl._const = nil
SanshuiCtrl._curState = 0
function SanshuiCtrl.OnRob(go)
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_BANKER) then
		this._robData = nil
		return
	end
	if(this._robData == nil) then
		SanshuiPanel.getRobInfo()
	else
		this.robCallBack(this._robData)
	end
end

SanshuiCtrl._robData = nil
function SanshuiCtrl.robCallBack(data)
	if(this._curState == this._const.WATER_STATUS_BANKER) then --抢庄
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
						SanshuiPanel.setTip("抢庄金额不能低于1")
						return
					end
					SanshuiPanel.robData(this._robBet)
				end);
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

function SanshuiCtrl.OnBack(go)
	local str =i18n.TID_COMMON_BACK_GAME
	global._view:support().Awake(str,function ()
       	soundMgr:PlaySound("go")
		SanshuiPanel.backNiuniu(this.IsGameRoom)
	   end,function ()

   	end);
end

function SanshuiCtrl.OnPlayerList()
	if(this._const == nil) then
		return
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		SanshuiPanel.getPlayerList()
	else
		local str = i18n.TID_COMMON_STATISTC_DATA
		SanshuiPanel.setTip(str)
	end
end

function SanshuiCtrl.closeShowUI()
	if(this._uiPreant ~= nil) then
		panelMgr:ClearPrefab(this._uiPreant);
		this._uiPreant = nil;
	end
	this.closeBalanceList()
	SanshuiPanel.uibox:SetActive(false)
	SanshuiPanel.balanceEnter:SetActive(false)
end

SanshuiCtrl._bigshow = nil
function SanshuiCtrl.ShowBigTime(isdaoban)
	local bundle = resMgr:LoadBundle("bigshow");
	local Prefab = resMgr:LoadBundleAsset(bundle,"bigshow");
	this._bigshow = GameObject.Instantiate(Prefab);
	this._bigshow.name = "bigshowbar";
	this._bigshow.transform.parent = SanshuiPanel.Tips.transform;
	this._bigshow.transform.localScale = Vector3.one;
	this._bigshow.transform.localPosition = Vector3(0,32,0);---135
	resMgr:addAltas(this._bigshow.transform,"Room")
	local showtip = this._bigshow.transform:Find("showtip");
	local liuju = showtip:Find('liuju').gameObject;
	local popen = showtip:Find('popen').gameObject;
	local pbet = showtip:Find('pbet').gameObject;
	local prob = showtip:Find('prob').gameObject;
	local pcard = showtip:Find('pcard').gameObject;
	local pselect=showtip:Find("pselect").gameObject;
	local loseRob=this._bigshow.transform:Find("loserob").gameObject;
	popen:SetActive(false)
	pbet:SetActive(false)
	prob:SetActive(false)
	pcard:SetActive(false)
	pselect:SetActive(false)
	if (isdaoban) then 
		loseRob:SetActive(true)
		showtip.gameObject:SetActive(false)
	end 
	if (this._IsLiuju == 1) then
		liuju:SetActive(true)
		return
	end
	
	if (this._curState == this._const.WATER_STATUS_BANKER) then
		prob:SetActive(true)
	elseif (this._curState == this._const.WATER_STATUS_BET) then
		pbet:SetActive(true)
	elseif (this._curState == this._const.WATER_STATUS_TRIM) then
		pcard:SetActive(true)
	elseif (this._curState == this._const.WATER_STATUS_OPEN) then
		popen:SetActive(true)
	end
end

function SanshuiCtrl.clearBigShow()
	if(this._bigshow ~= nil) then
		panelMgr:ClearPrefab(this._bigshow);
	end
	this._bigshow = nil
end

SanshuiCtrl.patterntype = 1
function SanshuiCtrl.updatePattern(playtype,bout,amount)
	SanshuiPanel.Patnumber_UILabel.text = bout
	this.patterntype = playtype
	if(playtype == 1) then --自由抢庄
		SanshuiPanel.allpattern:SetActive(false)
		SanshuiPanel.Patnumber.transform.localPosition = Vector3(0,-3,0);
		SanshuiPanel.Pattype_UILabel.text = "对比模式"
		SanshuiPanel.betbtn:SetActive(false)
	else
		SanshuiPanel.allpattern:SetActive(true)
		SanshuiPanel.Patnumber.transform.localPosition = Vector3(-23,-3,0);
		SanshuiPanel.PatsumNumber_UILabel.text = amount
		SanshuiPanel.Pattype_UILabel.text = "抢庄模式"
		SanshuiPanel.betbtn:SetActive(true)
	end
end

function SanshuiCtrl.BetBtnColor(color)
	SanshuiPanel.betfive_UISprite.color = color
	SanshuiPanel.betten_UISprite.color = color
	SanshuiPanel.bethund_UISprite.color = color
	SanshuiPanel.betkilo_UISprite.color = color
	SanshuiPanel.bettenshou_UISprite.color = color
	SanshuiPanel.betmill_UISprite.color = color
end

SanshuiCtrl._const = nil
SanshuiCtrl._cards = ""
SanshuiCtrl._curState = 0
SanshuiCtrl._playerCoin = 0
SanshuiCtrl._betCoin = 0
SanshuiCtrl._MinCoin = 0
SanshuiCtrl._IsOpenGame = false
SanshuiCtrl._RoomCreate = ""
function SanshuiCtrl.Init(data,const,liuju,daobang)
	this._const = const
	this._RoomCreate = data.house_owner_name
	local roomMod = "坐庄"
	if(data.play_type == 1) then
		this._MinCoin = data.pour_coin
		roomMod = "对比"
	end
	if(this.IsGameRoom == false) then
		SanshuiPanel.roomId_UILabel.text = roomMod.."/批批卢/8人   房主:" .. GameData.GetShortName(this._RoomCreate,12,10)
		 .. "房号:" .. this.RoomId .. " 最大倍数:" .. data.pour_num .. " 每注金额:" .. data.pour_coin
		SanshuiPanel.Pattern:SetActive(true)
		this.updatePattern(data.play_type,data.bout,data.bout_amount)
	else
		SanshuiPanel.Pattern:SetActive(true)
		SanshuiPanel.roomId_UILabel.text = roomMod .. "/批批卢/8人  " .. this.RoomTitle.. " 最大倍数:" .. data.pour_num .. " 每注金额:" .. data.pour_coin
		this.updatePattern(data.play_type,data.bout,data.bout_amount)
	end
	this.initAllPlayer()
	local len = #data.members
	for i=1,len do
		local member = data.members[i]
		local info = {
			name = GameData.GetShortName(member.player_name,10,7),
			icon = member.headimgurl,
			coin = member.money + member.RMB,
			id = member.playerid,
			betcoin = 0,
		}
		this.InsertPlayerInfo(info)
	end
	this._FreeTime = data.over_time
	this._curState = data.game_status
	if(this._curState ~= this._const.WATER_STATUS_FREE) then
		this._IsOpenGame = true
		SanshuiPanel.fristenter:SetActive(true)
	end
	if(this._curState ~= this._const.WATER_STATUS_OPEN) then
		this.updateBetState(data,liuju,daobang)
	else
		this.updateAllState()
		SanshuiPanel.BetState_UILabel.text = "请开牌"
	end
end

function SanshuiCtrl.updateAllState()
	SanshuiPanel.roleBetcoin_UILabel.text = ""
	this._IsLiuju = 0
	this.IsopenCard = false
	this.startDeal = false
	this._ownIsCard = false
	this._IsRoom = false
	this._IsCome = true
	this._totalBetCoin = 0
	this._PlayermaxCoin = 0
	this.animatime = 0
	this._robData = nil
	this.myPlayerInfo = nil
	this._openCards = {}
	this._gunVec = {}
	this._IsPlayShoot = false
	this._Isgun = false
	this._IsOutCard = true
	this.clearBullet()
end

SanshuiCtrl._IsRoom = false
SanshuiCtrl._bankerPoint = 0
SanshuiCtrl._PlayermaxCoin = 0
SanshuiCtrl._IsLiuju = 0
function SanshuiCtrl.updateBetState(data,liuju,daobang)
	if(this._const == nil) then
		return
	end
	this._FreeTime = data.over_time
	this._curState = data.game_status
	local bet = ""
	SanshuiPanel.rob:SetActive(false)
	this.BetBtnColor(Color.gray)
	this.clearBigShow()
	this.clearEffect()
	SanshuiPanel.backOut:SetActive(false)
	SanshuiPanel.collation:SetActive(false)
	SanshuiPanel.specAnima:SetActive(false)
	SanshuiPanel.cardEffect:SetActive(false)
	this.setPlayerBanker(data.banker_playerid)
	if(this._curState ~= this._const.WATER_STATUS_COUNT and this._curState ~= this._const.WATER_STATUS_OPEN) then
		this.changePlayerState()
	end
	this.updateAllState()
	if(data.banker_playerid == SanshuiPanel.getPlayerId()) then --自己是不是庄家
		this._IsRoom = true
	end
	if(this._curState == this._const.WATER_STATUS_FREE) then --空闲时间
		this._IsLiuju = liuju
		if(this._userBetVec ~= nil) then
			this.ShowBalance(this._userBetVec)
			this._userBetVec = nil
		end
		if(this._IsLiuju == 1) then
			soundMgr:PlaySound("liuju")
			this.ShowBigTime(false)
		end
		if(daobang) then
			this.ShowBigTime(daobang)
		end
		if(this._uiPreant ~= nil) then
			if(this._uiPreant.name == "robUIbar") then
				this.closeShowUI()
			end
		end
		if(this._IsRoom) then
			SanshuiPanel.backOut:SetActive(true)
		end
		this.updatePlayerInfo()
		SanshuiPanel.fristenter:SetActive(false)
		SanshuiPanel.Patnumber_UILabel.text = data.bout
		this._IsOpenGame = false
		SanshuiPanel.BetCoin_UILabel.text = 0
		this._allBetCoin = 0;
		bet = "空闲"
	elseif(this._curState == this._const.WATER_STATUS_BANKER) then --抢庄时间
		this._allBetCoin = 0;
		SanshuiPanel.rob:SetActive(true)
		bet = "请抢庄"
		this.updatePlayerInfo()
		if(this._IsOpenGame == false) then
			soundMgr:PlaySound("prob")
			this.ShowBigTime(false)
		end
	elseif(this._curState == this._const.WATER_STATUS_BET) then --下注时间
		this.closeShowUI()
		this.updatePlayerInfo()
		bet = "请下注"
		if(this._IsRoom) then
			soundMgr:PlaySound("merob")
		else
			if(this._IsOpenGame == false) then
				soundMgr:PlaySound("pbet")
				this.ShowBigTime(false)
				this.BetBtnColor(Color.white)
			end
		end
		this._PlayermaxCoin = data.player_max_coin
		local bstr = "全场最高下注:" .. this._PlayermaxCoin
		SanshuiPanel.roleBetcoin_UILabel.text = bstr
	elseif(this._curState == this._const.WATER_STATUS_TRIM) then --理牌时间
		this.closeOtherDialog()
		this.closeShowUI()
		this.ShowBigTime(false)
		bet = "请理牌"
		if(data.water_cards ~= nil and #data.water_cards > 0) then
			this.cleanPlayerCard(true,data.bet_playerids)
			SanshuiPanel.collation:SetActive(true)
			this.LicenSingPlayer(data.water_cards,data.card_type)
		end
	elseif(this._curState == this._const.WATER_STATUS_COUNT) then --数据统计
		bet = "正在统计"
		this.closeOtherDialog()
	elseif(this._curState == this._const.WATER_STATUS_OPEN) then --开牌时间
		bet = "请开牌"
		this.closeOtherDialog()
		this._openCards = data.cards_users
		this.cleanPlayerCard(false,this._openCards)
		local time = this._FreeTime - SanshuiPanel.getTime()
        local hours = math.floor(time / 3600);
		time = time - hours * 3600;
		-- local minute = math.floor(time / 60);
		-- time = time - minute * 60;
		if(time > 5) then
			soundMgr:PlaySound("StartCompearCard_Nv")
			this.waterOpenAnima()
			global._view:Invoke(1.5,function ()
				if(this._IsCome) then
					this.openPlayerCard(this._openCards,time)
				end
			end)
		else
			this.stopAllAnima(this._openCards)
		end
		local len = #data.bet_users
	    this._userBetVec = {}
	    for i=1,len do
			local bankerInfo = data.bet_users[i]
			local name = bankerInfo.player_name
			local vec = {
				betusers = bankerInfo,
				Isopen = 0,
				playerId = bankerInfo.playerid,
				allBet = this.getUserBetValue(bankerInfo.playerid,this._openCards)
			}
			table.insert(this._userBetVec,vec)
		end
	end
	SanshuiPanel.BetState_UILabel.text = bet
end

function SanshuiCtrl.getUserBetValue(id,list)
	local value = 0
	local len = #list
	for i=1,len do
		local data = list[i]
		if(data.playerid == id) then
			value = data.total_odds + data.extra_odds + data.mound_odds + data.swat
			break
		end
	end
	return value
end

function SanshuiCtrl.closeOtherDialog()
	if(global._view:getViewBase("Rule") ~= nil) then
	 	global._view:getViewBase("Rule").OnDestroy()
	end
	if(global._view:getViewBase("Bank") ~= nil) then
	 	global._view:getViewBase("Bank").OnDestroy()
	end
	if(global._view:getViewBase("PlayerList")~=nil)then
		global._view:getViewBase("PlayerList").clearView();
	end
	SanshuiPanel.betDialog:SetActive(false)
end

SanshuiCtrl._ratioEffect = nil;
function SanshuiCtrl.waterOpenAnima()
	if(this._ratioEffect == nil) then
		local bundle = resMgr:LoadBundle("ratioAnima");
	    local Prefab = resMgr:LoadBundleAsset(bundle,"ratioAnima");
	    this._ratioEffect = GameObject.Instantiate(Prefab);
		this._ratioEffect.name = "ratioAnimabar";
		this._ratioEffect.transform.parent = SanshuiPanel.Tips.transform;
		this._ratioEffect.transform.localScale = Vector3.one;
		this._ratioEffect.transform.localPosition = Vector3.zero;
		resMgr:addAltas(this._ratioEffect.transform,"Sanshui")
	end
end

function SanshuiCtrl.clearEffect()
	if(this._ratioEffect ~= nil) then
		panelMgr:ClearPrefab(this._ratioEffect);
	end
	this._ratioEffect = nil
end

SanshuiCtrl._openCards = {}
SanshuiCtrl._allCard = {}
SanshuiCtrl.IsCoixtSpeial = false
SanshuiCtrl.choiceNum = 0
function SanshuiCtrl.LicenSingPlayer(list,speial)--发牌
	this.clearCardList()
	this.clearFiveCard()
	list = this.cardSort(list)
	-- this.checkAdragon(list)
	SanshuiPanel.betDialog:SetActive(false)
	local bundle = resMgr:LoadBundle("plate");
	local Prefab = resMgr:LoadBundleAsset(bundle,"plate");
	local startX = -550
	local space = 92
	local len = #list
	local dp = 20
	for i=1,len do
		local data = list[i]
	    local go = GameObject.Instantiate(Prefab);
		go.name = "plate" .. i;
		go.transform.parent = SanshuiPanel.collation.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(startX + (i - 1) * space, 0 ,0)
		resMgr:addAltas(go.transform,"Sanshui")
		local cardnum = go.transform:Find('cardbg').gameObject;
		this.Room:AddClick(cardnum, function ()
			if(this.IsCoixtSpeial) then
				return
			end
			local temp = this._allCard[i]
			local pos = temp.prefab.transform.localPosition
			if(pos.y == 0) then
				this.choiceNum = this.choiceNum + 1
				temp.IsChoice = true
				temp.prefab.transform.localPosition = Vector3(pos.x, 20 ,0)
			else
				this.choiceNum = this.choiceNum - 1
				temp.IsChoice = false
				temp.prefab.transform.localPosition = Vector3(pos.x, 0 ,0)
			end
			this.changeChoiceBg()
		end);
		cardnum:GetComponent('UISprite').depth = dp;
		local num = go.transform:Find('cardnum'):GetComponent('UILabel')
		local value = data.num
		if(value == 11) then
			value = "J"
		elseif(value == 12) then
			value = "Q"
		elseif(value == 13) then
			value = "K"
		elseif(value == 14) then
			value = "A"
		end
		num.text = value
		num.depth = dp + 1;
		local type1 = go.transform:Find('cardtype1'):GetComponent('UISprite')
		type1.spriteName = this.checkCardType(data.cardtype)
		type1.depth = dp + 1;
		local type2 = go.transform:Find('cardtype2'):GetComponent('UISprite')
		type2.spriteName = this.checkCardType(data.cardtype)
		type2.depth = dp + 1;
		dp = dp + 2
		local card = {
			prefab = go,
			CardData = data,
			IsChoice = false,
			IsUp = false,
			findType = false,
			Index = i,
		}
		table.insert(this._allCard,card)
	end
	SanshuiPanel.backclose_UISprite.spriteName = "andacha2"
	SanshuiPanel.midclose_UISprite.spriteName = "andacha2"
	SanshuiPanel.headclose_UISprite.spriteName = "andacha2"
	this.IsCoixtSpeial = false
	if(speial > 0) then
		this.IsCoixtSpeial = true
		this.changeAllOpenBtn()
		SanshuiPanel.specAnima:SetActive(true)
		SanshuiPanel.specIcon_UISprite.spriteName = this.getSpecAnimaIcon(speial)
		SanshuiPanel.specIcon_UISprite:MakePixelPerfect()
	else
		SanshuiPanel.specAnima:SetActive(false)
		this.getAllCardType()
		this.allCardToType(this._allCard)
		this.renderAllFiveCard()
	end
end

function SanshuiCtrl.getSpecAnimaIcon(id)
	local value = ""
	if(id == this._const.WATER_VALUE_TYPE_298) then
		value = "tbzhizunqinglong"
	elseif(id == this._const.WATER_VALUE_TYPE_297) then
		value = "yitiaolong"
	elseif(id == this._const.WATER_VALUE_TYPE_270) then
		value = "tbliuduiban"
	elseif(id == this._const.WATER_VALUE_TYPE_260) then
		value = "tbsantonghua"
	elseif(id == this._const.WATER_VALUE_TYPE_250) then
		value = "tbsanshunzhi"
	end
	return value
end

SanshuiCtrl._fiveCard = {}
function SanshuiCtrl.renderAllFiveCard()
	local len = #this.allFiveCard
	if(len == 0) then
		return
	end
	SanshuiPanel.cardList_UIScrollView:ResetPosition()
	local parent = SanshuiPanel.cardList.transform;
	local bundle = resMgr:LoadBundle("ArrayCard");
	local Prefab = resMgr:LoadBundleAsset(bundle,"ArrayCard");
	local space = 60;
	local len = #this.allFiveCard
	for i=1,len do
		local data = this.allFiveCard[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "ArrayCard"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0,105 - space*(i - 1), 0);
		this.Room:AddClick(go, function ()
			this.OnCardClose(this.headlist)
			this.headlist = {}
			this.OnCardClose(this.backlist)
			this.backlist = {}
			this.OnCardClose(this.midlist)
			this.midlist = {}
			this.headType = this.evaluateType(data.htype)
			this.midtype = this.evaluateType(data.mtype)
			this.backtype = this.evaluateType(data.btype)
			local head = {}
			local mid = {}
			local back = {}
			local hlen = #data.head
			local mlen = #data.mid
			local blen = #data.back
			for i=1,#this._allCard do
				for j=1,hlen do
					if(this._allCard[i].Index == data.head[j].Index) then
						this._allCard[i].IsChoice = true
						this._allCard[i].IsUp = true
						table.insert(head,this._allCard[i])
					end
				end
				for z=1,mlen do
					if(this._allCard[i].Index == data.mid[z].Index) then
						this._allCard[i].IsChoice = true
						this._allCard[i].IsUp = true
						table.insert(mid,this._allCard[i])
					end
				end
				for m=1,blen do
					if(this._allCard[i].Index == data.back[m].Index) then
						this._allCard[i].IsChoice = true
						this._allCard[i].IsUp = true
						table.insert(back,this._allCard[i])
					end
				end
			end
			back = this.sortFiveCard(back)
			this.backListInfo(back)
			mid = this.sortFiveCard(mid)
			this.midListInfo(mid)
			head = this.sortFiveCard(head)
			this.headListInfo(head)
			this.resertCardPos()
			this.changeAllOpenBtn()
		end);
		resMgr:addAltas(go.transform,"Sanshui")
		local cardtext = go.transform:Find('cardtext'):GetComponent('UILabel');
		cardtext.text = this.evaluateName(data.htype) .. "+" .. this.evaluateName(data.mtype) .. "+" .. this.evaluateName(data.btype)
		table.insert(this._fiveCard,go)
	end
end

function SanshuiCtrl.clearFiveCard()
	local len = #this._fiveCard
	for i=1,len do
		local data = this._fiveCard[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._fiveCard = {}
end

function SanshuiCtrl.evaluateName(num)
	local value = ""
	if(num == 0) then
		value = "乌龙"
	elseif(num == 1) then
		value = "对子"
	elseif(num == 2) then
		value = "两对"
	elseif(num == 3) then
		value = "三条"
	elseif(num == 4) then
		value = "顺子"
	elseif(num == 5) then
		value = "同花"
	elseif(num == 6) then
		value = "葫芦"
	elseif(num == 7) then
		value = "铁支"
	elseif(num == 8) then
		value = "铁支"
	elseif(num == 9) then
		value = "同花顺"
	end
	return value
end

function SanshuiCtrl.changeChoiceBg()
	SanshuiPanel.headanima:SetActive(false)
	SanshuiPanel.midanima:SetActive(false)
	SanshuiPanel.backanima:SetActive(false)
	if(this.choiceNum == 3 and #this.headlist == 0) then
		SanshuiPanel.headanima:SetActive(true)
	elseif(this.choiceNum == 5) then
		if(#this.midlist == 0) then
			SanshuiPanel.midanima:SetActive(true)
		end
		if(#this.backlist == 0) then
			SanshuiPanel.backanima:SetActive(true)
		end
	end
end
function SanshuiCtrl.getAllCardType()
	this.getAllPairs()
	this.getTwoPairs()
	this.getAllThree()
	this.checkStraight()
	this.checkFlushCard()
	this.getAllFlowers()
	this.getAllBottle()
	this.getAllIronbranch()
end

function SanshuiCtrl.checkCardType(value)
	local name = ""
	if(value == 1) then
		name = "tacaohua"
	elseif(value == 2) then
		name = "tafangkuai"
	elseif(value == 3) then
		name = "taheitao"
	elseif(value == 4) then
		name = "tahongxin"
	end
	return name
end

function SanshuiCtrl.clearCardList()
	this.allFiveCard = {}
	local len = #this._allCard
	for i=1,len do
		local data = this._allCard[i]
		panelMgr:ClearPrefab(data.prefab);
	end
	this._allCard = {}
	this.headlist = {}
	this.backlist = {}
	this.midlist = {}
	this.headType = 0
	this.midtype = 0 
	this.backtype = 0
end

function SanshuiCtrl.allCardToType(list)
	this.getPairsType(list) -- 是否有对子
	this.getThreeType(list)
	this.getStraightType(list)
	this.getFlowersType(list)
	this.getBottleType(list)
	this.getIronbranch(list)
	this.getFlushType(list)
	local num = 0
	local allpairs = {}
	local twopairs = {}
	local allthree = {}
	local allstraight = {}
	local allflowers = {}
	local allbottle = {}
	local allIronbranch = {}
	local allbomb = {}
	local allflush = {}
	GameData.deepCopy(allpairs,this.arrypairs)
	GameData.deepCopy(twopairs,this.arrytwoPairs)
	GameData.deepCopy(allthree,this.arryThree)
	GameData.deepCopy(allstraight,this.arrystraight)
	GameData.deepCopy(allflowers,this.arryFlowers)
	GameData.deepCopy(allbottle,this.arryBottle)
	GameData.deepCopy(allIronbranch,this.arryIronbranch)
	GameData.deepCopy(allbomb,this._IronBomb)
	GameData.deepCopy(allflush,this.arryflush)
	if(#allflush > 0) then
		num = 9
		this.setFivecard(allflush,num)
	end
	if(#allbomb > 0) then
		num = 8
		this.setFivecard(allbomb,num)
	end
	if(#allIronbranch > 0) then
		num = 7
		this.setFivecard(allIronbranch,num)
	end
	if(#allbottle > 0) then
		num = 6
		this.setFivecard(allbottle,num)
	end
	if(#allflowers > 0) then
		num = 5
		this.setFivecard(allflowers,num)
	end
	if(#allstraight > 0) then
		num = 4
		this.setFivecard(allstraight,num)
	end
	if(#allthree > 0) then
		num = 3
		this.setFivecard(allthree,num)
	end
	if(#twopairs > 0) then
		num = 2
		this.setFivecard(twopairs,num)
	end
	if(#allpairs > 0) then
		num = 1
		this.setFivecard(allpairs,num)
	end
end

function SanshuiCtrl.setFivecard(list,num)
	local len = #list
	for i=1,len do
		local comp = {}
		local cl = list[i]
		for m=1,#cl do
			table.insert(comp,this._allCard[cl[m]])
		end
		local data = {
			head = nil,
			mid = nil,
			back = comp,
		}
		local two = this.getCardToType(comp,this._allCard)
		local twoData = this.checkCardToType(two,5)
		if(num > twoData.index) then
			for j=1,#twoData.data do
				data.mid = twoData.data[j]
				local temp = this.mergeList(comp,twoData.data[j])
				local three = this.getCardToType(temp,two)
				local threeData = this.checkCardToType(three,3)
				if(twoData.index > threeData.index and threeData.index < 4) then
					for z=1,#threeData.data do
						data.head = threeData.data[z]
						local ftmp = this.mergeList(temp,threeData.data[z])
						local four = this.getCardToType(ftmp,three)
						this.supplementCard(four,data,num,twoData.index,threeData.index)
					end
				elseif(twoData.index == threeData.index and threeData.index < 4) then
					for z=1,#threeData.data do
						local tvalue = this.uronCompareSize(threeData.data[z],twoData.data[j])
						if(tvalue) then
							data.head = threeData.data[z]
							local ftmp = this.mergeList(temp,threeData.data[z])
							local four = this.getCardToType(ftmp,three)
							this.supplementCard(four,data,num,twoData.index,threeData.index)
						end
					end
				end
			end
		elseif(num == twoData.index) then
			for j=1,#twoData.data do
				local value = this.uronCompareSize(twoData.data[j],comp)
				if(value) then
					data.mid = twoData.data[j]
					local temp = this.mergeList(comp,twoData.data[j])
					local three = this.getCardToType(temp,two)
					local threeData = this.checkCardToType(three,3)
					if(twoData.index > threeData.index and threeData.index < 4) then
						for z=1,#threeData.data do
							data.head = threeData.data[z]
							local ftmp = this.mergeList(temp,threeData.data[z])
							local four = this.getCardToType(ftmp,three)
							this.supplementCard(four,data,num,twoData.index,threeData.index)
						end
					elseif(twoData.index == threeData.index and threeData.index < 4) then
						for z=1,#threeData.data do
							local tvalue = this.uronCompareSize(threeData.data[z],twoData.data[j])
							if(tvalue) then
								data.head = threeData.data[z]
								local ftmp = this.mergeList(temp,threeData.data[z])
								local four = this.getCardToType(ftmp,three)
								this.supplementCard(four,data,num,twoData.index,threeData.index)
							end
						end
					end
				end
			end
		end
	end
end

function SanshuiCtrl.supplementCard(list,data,backtype,midtype,headtype)
	local hlen = #data.head
	local mlen = #data.mid
	local blen = #data.back
	local hdata = {}
	local mdata = {}
	local bdata = {}
	local count = 5 - blen
	for i=1,blen do
		table.insert(bdata,data.back[i])
	end
	for i=1,5 - blen do
		table.insert(bdata,list[i])
	end
	for i=1,mlen do
		table.insert(mdata,data.mid[i])
	end
	for i=count + 1,5 - mlen + count do
		table.insert(mdata,list[i])
	end
	count = 10 - blen - mlen
	for i=1,hlen do
		table.insert(hdata,data.head[i])
	end
	for i=count + 1,3 - hlen + count do
		table.insert(hdata,list[i])
	end
	local info = {
		head = hdata,
		mid = mdata,
		back = bdata,
		htype = headtype,
		mtype = midtype,
		btype = backtype,
	}
	table.insert(this.allFiveCard,info)
end

function SanshuiCtrl.mergeList(start,endlist)
	local temp = {}
	local len = #start
	local count = #endlist
	for i=1,len do
		table.insert(temp,start[i])
	end
	for i=1,count do
		table.insert(temp,endlist[i])
	end
	return temp
end

SanshuiCtrl.allFiveCard = {}
function SanshuiCtrl.checkCardToType(list,count)
	this.getPairsType(list) -- 是否有对子
	this.getThreeType(list)
	this.getStraightType(list)
	this.getFlowersType(list)
	this.getBottleType(list)
	this.getIronbranch(list)
	this.getFlushType(list)
	local temp = {}
	local num = 0
	if(#this.arrypairs > 0) then
		temp = this.arrypairs
		num = 1
	end
	if(#this.arrytwoPairs > 0) then
		temp = this.arrytwoPairs
		num = 2
	end
	if(#this.arryThree > 0) then
		temp = this.arryThree
		num = 3
	end
	if(#this.arrystraight > 0) then
		temp = this.arrystraight
		num = 4
	end
	if(#this.arryFlowers > 0) then
		temp = this.arryFlowers
		num = 5
	end
	if(#this.arryBottle > 0) then
		temp = this.arryBottle
		num = 6
	end
	if(#this.arryIronbranch > 0) then
		temp = this.arryIronbranch
		num = 7
	end
	if(#this._IronBomb > 0) then
		temp = this._IronBomb
		num = 8
	end
	if(#this.arryflush > 0) then
		temp = this.arryflush
		num = 9
	end
	local all = {}
	local len = #temp
	if(len > 0) then
		for i=1,len do
			local tdata = temp[i]
			local comp = {}
			for j=1,#tdata do
				local tag = tdata[j]
				table.insert(comp,list[tag])
			end
			if(#comp > 0) then
				table.insert(all,comp);
			end
		end
	else
		local comp = {}
		for i=1,count do
			table.insert(comp,list[i])
		end
		if(#comp > 0) then
			table.insert(all,comp);
		end
	end
	local data = {
		index = num,
		data = all,
	}
	return data
end

function SanshuiCtrl.getCardToType(list,all)
	local temp = {}
	GameData.deepCopy(temp,all)
	local len = #temp
	local count = #list
	for i=#temp,1,-1 do
		local data = temp[i]
		for j=1,count do
			local md = list[j]
			if(data.Index == md.Index) then
				table.remove(temp,i)
				break
			end
		end
	end
	return temp
end

function SanshuiCtrl.uronCompareSize(startlist,endlist) --乌龙大小
	local len = #startlist
	local elen = #endlist
	if(len > elen) then
		len = elen
	end
	local value = true
	for i=1,len do
		local sv = startlist[i]
		local ev = endlist[i]
		if(sv.CardData.num > ev.CardData.num) then
			value = false
			break
		elseif(sv.CardData.num < ev.CardData.num) then
			break
		end
	end
	return value
end

function SanshuiCtrl.comparePairSize(list,complist,value)
	local can = true
	local num = this.noUronCard(complist)
	if(num == 0) then
		if(value == 0) then
			can = this.uronCompareSize(list,complist)
		else
			can = false
		end
	else
		if(value == 1) then
			if(num == 1) then
				can = this.uronCompareSize(list,complist)
			end
		elseif(value == 3) then
			if(num == 3) then
				can = this.uronCompareSize(list,complist)
			elseif(num < value) then
				can = false
			end
		end
	end
	return can
end

function SanshuiCtrl.evaluateType(num)
	local value = 0
	if(num == 0) then
		value = this._const.WATER_VALUE_TYPE_100
	elseif(num == 1) then
		value = this._const.WATER_VALUE_TYPE_110
	elseif(num == 2) then
		value = this._const.WATER_VALUE_TYPE_120
	elseif(num == 3) then
		value = this._const.WATER_VALUE_TYPE_130
	elseif(num == 4) then
		value = this._const.WATER_VALUE_TYPE_140
	elseif(num == 5) then
		value = this._const.WATER_VALUE_TYPE_150
	elseif(num == 6) then
		value = this._const.WATER_VALUE_TYPE_160
	elseif(num == 7) then
		value = this._const.WATER_VALUE_TYPE_174
	elseif(num == 8) then
		value = this._const.WATER_VALUE_TYPE_175
	elseif(num == 9) then
		value = this._const.WATER_VALUE_TYPE_190
	end
	return value
end

function SanshuiCtrl.noUronCard(list)
	this.getPairsType(list) -- 是否有对子
	this.getThreeType(list)
	this.getStraightType(list)
	this.getFlowersType(list)
	this.getBottleType(list)
	this.getIronbranch(list)
	this.getFlushType(list)
	local num = 0
	if(#this.arrypairs > 0) then
		num = 1
	end
	if(#this.arrytwoPairs > 0) then
		num = 2
	end
	if(#this.arryThree > 0) then
		num = 3
	end
	if(#this.arrystraight > 0) then
		num = 4
	end
	if(#this.arryFlowers > 0) then
		num = 5
	end
	if(#this.arryBottle > 0) then
		num = 6
	end
	if(#this.arryIronbranch > 0) then
		num = 7
	end
	if(#this._IronBomb > 0) then
		num = 8
	end
	if(#this.arryflush > 0) then
		num = 9
	end
	return num
end

function SanshuiCtrl.compareCard(list,enter)
	local can = true
	local len = #list
	local num = this.noUronCard(list)
	if(len == 3) then
		if(#this.midlist > 0) then
			can = this.comparePairSize(list,this.midlist,num)
		end
		if(#this.backlist > 0) then
			can = this.comparePairSize(list,this.backlist,num)
		end
	elseif(len == 5) then
		if(#this.headlist > 0 and #this.midlist == 0) then
			this.getPairsType(this.headlist) -- 是否有对子
			this.getThreeType(this.headlist)
			local IsUron = false
			if(#this.arrypairs == 0) then
				IsUron = true
			end
			local IsThree = false
			if(#this.arryThree == 0) then
				IsThree = true
			end
			if(num == 0) then
				if(IsUron and IsThree) then
					can = this.uronCompareSize(this.headlist,list)
				else
					can = false
				end
			else
				if(num == 1) then
					if(IsThree) then
						if(IsUron == false) then
							can = this.uronCompareSize(this.headlist,list)
						else
							can = true
						end
					else
						can = false
					end
				elseif(num == 2) then
					if(IsThree == false) then
						can = false
					else
						can = true
					end
				elseif(num == 3) then
					if(IsThree == false) then
						can = this.uronCompareSize(this.headlist,list)
					else
						can = true
					end
				end
			end
		end
		if(#this.midlist > 0 and can) then
			local backnum = this.noUronCard(this.midlist)
			if(num < backnum) then
				can = false
			elseif(num == backnum) then
				can = this.noUronCard(this.midlist,list)
			end
		elseif(#this.backlist > 0 and can) then
			local backnum = this.noUronCard(this.backlist)
			if(num > backnum) then
				can = false
			elseif(num == backnum) then
				can = this.uronCompareSize(list,this.backlist)
			end
		end
	end
	if(enter == 0) then
		this.headType = this.evaluateType(num)
	elseif(enter == 1) then
		this.midtype = this.evaluateType(num)
	elseif(enter == 2) then
		this.backtype = this.evaluateType(num)
	end
	return can
end

function SanshuiCtrl.resertCardPos()
	this.choiceNum = 0
	this.changeChoiceBg()
	if(#this.headlist > 0 and #this.midlist > 0 and #this.backlist > 0) then
		SanshuiPanel.recovery:SetActive(true)
		SanshuiPanel.paly:SetActive(true)
		return
	end
	this.getAllCardType()
	SanshuiPanel.recovery:SetActive(false)
	SanshuiPanel.paly:SetActive(false)
	local startX = -550
	local space = 92
	local index = 0
	local dp = 20
	local count = #this._allCard
	for i=1,count do
		local data = this._allCard[i]
		if(data.IsUp == false) then
			data.IsChoice = false
			data.prefab.transform.localPosition = Vector3(startX + index * space, 0 ,0)
			data.prefab.transform:Find('cardbg'):GetComponent('UISprite').depth = dp;
			data.prefab.transform:Find('cardnum'):GetComponent('UILabel').depth = dp + 1;
			data.prefab.transform:Find('cardtype1'):GetComponent('UISprite').depth = dp + 1;
			data.prefab.transform:Find('cardtype2'):GetComponent('UISprite').depth = dp + 1;
			index = index + 1
			dp = dp + 2
		end
	end
end

function SanshuiCtrl.getAllChioceCard()
	local list = {}
	local len = #this._allCard
	for i=1,len do
		local data = this._allCard[i]
		if(data.IsChoice and data.IsUp == false) then
			table.insert(list,data)
		end
	end
	return list
end

function SanshuiCtrl.sortFiveCard(list)
	local temp = {}
	local all = {}
	local down = {}
	local len = #list
	local m = 1
	while(m <= len) do
		local data = list[m]
		local num = data.CardData.num
		table.insert(all,m)
		for j=m + 1,len do
			local data2 = list[j]
			if(num == data2.CardData.num) then
				table.insert(all,j)
			end
		end
		local alen = #all
		if(alen > 1) then
			local rr = {
				alen = alen,
				md = all,
			}
			table.insert(temp,rr)
		else
			table.insert(down,m)
		end
		m = m + alen
		all = {}
	end
	table.sort(temp,function (a,b)
        return a.alen > b.alen
    end)
    local clist = {}
	for i=1,#temp do
		local data = temp[i]
		for j=1,data.alen do
			local md = data.md[j]
			table.insert(clist,list[md])
		end
	end
	for i=1,#down do
		table.insert(clist,list[down[i]])
	end
	return clist
end

SanshuiCtrl.headlist = {}
SanshuiCtrl.headType = 0
function SanshuiCtrl.OnHeadCollider()
	local len = #this.headlist
	if(len == 0 and this.choiceNum == 3 and this.IsCoixtSpeial == false) then
		this.headType = 0
		local list = this.getAllChioceCard()
		list = this.sortFiveCard(list)
		local can = this.compareCard(list,0)
		if(can) then
			-- local index = 0
			-- local dp = 7
			-- local alen = #list
			-- for i=1,alen do
			-- 	local data = list[i]
			-- 	-- if(data.IsChoice and data.IsUp == false) then
			-- 		data.IsUp = true
			-- 		data.prefab.transform.localPosition = Vector3(-246 + 72*index, 402 ,0)
			-- 		this.resertCardDepth(data.prefab,dp)
			-- 		table.insert(this.headlist,data)
			-- 		index = index + 1
			-- 		dp = dp + 3
			-- 	-- end
			-- end
			-- SanshuiPanel.headclose_UISprite.spriteName = "andacha"
			this.headListInfo(list);
			this.resertCardPos()
		else
			SanshuiPanel.setTip("头道牌不能比中道或尾道的大！")
		end
	end
end

function SanshuiCtrl.headListInfo(list)
	local index = 0
	local dp = 7
	local alen = #list
	for i=1,alen do
		local data = list[i]
		data.IsUp = true
		data.prefab.transform.localPosition = Vector3(-246 + 72*index, 402 ,0)
		this.resertCardDepth(data.prefab,dp)
		table.insert(this.headlist,data)
		index = index + 1
		dp = dp + 3
	end
	SanshuiPanel.headclose_UISprite.spriteName = "andacha"
end

SanshuiCtrl.midlist = {}
SanshuiCtrl.midtype = 0
function SanshuiCtrl.OnMidCollider()
	local len = #this.midlist
	if(len == 0 and this.choiceNum == 5 and this.IsCoixtSpeial == false) then
		this.midtype = 0
		local list = this.getAllChioceCard()
		list = this.sortFiveCard(list)
		local can = this.compareCard(list,1)
		if(can) then
			-- local index = 0
			-- local dp = 20
			-- local alen = #list
			-- for i=1,alen do
			-- 	local data = list[i]
			-- 	-- if(data.IsChoice and data.IsUp == false) then
			-- 		data.IsUp = true
			-- 		data.prefab.transform.localPosition = Vector3(-298 + 61*index, 306 ,0)
			-- 		this.resertCardDepth(data.prefab,dp)
			-- 		table.insert(this.midlist,data)
			-- 		index = index + 1
			-- 		dp = dp + 3
			-- 	-- end
			-- end
			-- SanshuiPanel.midclose_UISprite.spriteName = "andacha"
			this.midListInfo(list)
			this.resertCardPos()
		else
			SanshuiPanel.setTip("中道牌不能比尾道的大比头道的小！")
		end
	end
end

function SanshuiCtrl.midListInfo(list)
	local index = 0
	local dp = 20
	local alen = #list
	for i=1,alen do
		local data = list[i]
		data.IsUp = true
		data.prefab.transform.localPosition = Vector3(-298 + 61*index, 306 ,0)
		this.resertCardDepth(data.prefab,dp)
		table.insert(this.midlist,data)
		index = index + 1
		dp = dp + 3
	end
	SanshuiPanel.midclose_UISprite.spriteName = "andacha"
end

SanshuiCtrl.backlist = {}
SanshuiCtrl.backtype = 0
function SanshuiCtrl.OnBackCollider()
	local len = #this.backlist
	if(len == 0 and this.choiceNum == 5 and this.IsCoixtSpeial == false) then
		this.backtype = 0
		local list = this.getAllChioceCard()
		list = this.sortFiveCard(list)
		local can = this.compareCard(list,2)
		if(can) then
			-- local index = 0
			-- local dp = 35
			-- local alen = #list
			-- for i=1,alen do
			-- 	local data = list[i]
			-- 	-- if(data.IsChoice and data.IsUp == false) then
			-- 		data.IsUp = true
			-- 		data.prefab.transform.localPosition = Vector3(-332 + 78*index, 204 ,0)
			-- 		this.resertCardDepth(data.prefab,dp)
			-- 		table.insert(this.backlist,data)
			-- 		index = index + 1
			-- 		dp = dp + 3
			-- 	-- end
			-- end
			-- SanshuiPanel.backclose_UISprite.spriteName = "andacha"
			this.backListInfo(list)
			this.resertCardPos()
		else
			SanshuiPanel.setTip("尾道牌不能比头道或中道的小！")
		end
	end
end

function SanshuiCtrl.backListInfo(list)
	local index = 0
	local dp = 35
	local alen = #list
	for i=1,alen do
		local data = list[i]
		data.IsUp = true
		data.prefab.transform.localPosition = Vector3(-332 + 78*index, 204 ,0)
		this.resertCardDepth(data.prefab,dp)
		table.insert(this.backlist,data)
		index = index + 1
		dp = dp + 3
	end
	SanshuiPanel.backclose_UISprite.spriteName = "andacha"
end

function SanshuiCtrl.OnCardClose(list)
	local len = #list
	for i=1,len do
		local data = list[i]
		data.IsChoice = false
		data.IsUp = false
	end
end

function SanshuiCtrl.resertCardDepth(go,dp)
	go.transform:Find('cardbg'):GetComponent('UISprite').depth = dp;
	go.transform:Find('cardnum'):GetComponent('UILabel').depth = dp + 1;
	go.transform:Find('cardtype1'):GetComponent('UISprite').depth = dp + 1;
	go.transform:Find('cardtype2'):GetComponent('UISprite').depth = dp + 1;
end

SanshuiCtrl.arrypairs = {}
function SanshuiCtrl.getPairsType(list)--对子
	this.arrypairs = {}
	local start = 0
	local frist = 0
	local endnum = 0
	local count = #list
	for i=1,count do
		local data = list[i]
		start = data.CardData.num
		frist = i
		for j=frist + 1,count do
			local data2 = list[j]
			local num = data2.CardData.num
			if(start == num) then
				endnum = j
				start = 0
				local md = {frist,endnum}
				table.insert(this.arrypairs,md)
				break
			end
		end
	end
	this.getTwoPairsArry(list)
end

SanshuiCtrl.arrytwoPairs = {}
function SanshuiCtrl.getTwoPairsArry(list)
	this.arrytwoPairs = {}
	GameData.deepCopy(this.arrytwoPairs,this.arrypairs)
	local value = 0
	for i=#this.arrytwoPairs,1,-1 do
		local data = this.arrytwoPairs[i]
		local af = list[data[1]]
		if(value ~= af.CardData.num) then
			value = af.CardData.num
		elseif(value == af.CardData.num) then
			table.remove(this.arrytwoPairs,i)
		end
	end
	local result = {}
	local len = #this.arrytwoPairs
	if(len > 1) then
		local count = 0
		for i=1,len do
			local two = this.arrytwoPairs[i]
			count = i
			for j=count + 1,len do
				local temp = {}
				table.insert(temp,two[1])
				table.insert(temp,two[2])
				local data = this.arrytwoPairs[j]
				for z=1,#data do
					table.insert(temp,data[z])
				end
				if(#temp == 4) then
					table.insert(result,temp)
				end
			end
		end
	end
	this.arrytwoPairs = result
end

SanshuiCtrl.arryThree = {}
function SanshuiCtrl.getThreeType(list)--三条
	this.arryThree = {}
	local start = 0
	local frist = 0
	local twonum = 0
	local endnum = 0
	local count = #list
	for i=1,count do
		local data = list[i]
		start = data.CardData.num
		frist = i
		local index = 1
		for j=frist + 1,count do
			local data2 = list[j]
			local num = data2.CardData.num
			if(start == num) then
				index = index + 1
				if(index == 2) then
					twonum = j
				elseif(index == 3) then
					endnum = j
					start = 0
					local md = {frist,twonum,endnum}
					table.insert(this.arryThree,md)
					break
				end
			end
		end
	end
end

SanshuiCtrl.arrystraight = {}
function SanshuiCtrl.getStraightType(list)--顺子
	this.arrystraight = {}
	local temp = {};
	local sptemp = {}
    local result = {}
    local sp = {}
    local spresult = {}
    local count = 0;
    local begin = 0;
    local count = #list
    for i=1,count do
		local data = list[i]
		local start = data.CardData.num
		frist = i
		temp = {}
		sptemp = {}
		table.insert(temp,i)
		table.insert(sptemp,i)
		local index = 1
		local spIndex = 1
		for j=frist + 1,count do
			local data2 = list[j]
			local num = data2.CardData.num
			if(start == 14) then
				if(num == 6 - spIndex and spIndex < 5) then
					spIndex = spIndex + 1
					if(spIndex == 5) then
						table.insert(sptemp,j)
						table.insert(sp,sptemp)
					elseif(spIndex < 5) then
						table.insert(sptemp,j)
					end
				elseif(num == 6 - spIndex + 1 and spIndex > 1) then
					local tt = {head = i,pos = spIndex,repace = j}
					table.insert(spresult,tt)
				end
			end
			if(num == start - index and index < 5) then
				index = index + 1
				if(index == 5) then
					table.insert(temp,j)
					table.insert(this.arrystraight,temp)
				elseif(index < 5) then
					table.insert(temp,j)
				end
			elseif(num == start - index + 1 and index > 1) then
				local tt = {head = i,pos = index,repace = j}
				table.insert(result,tt)
			end
		end
	end

	local final = {}
	GameData.deepCopy(final,this.arrystraight)
	local alen = #final
	local rlen = #result
	for i=1,alen do
		local data = final[i]
		for j=1,rlen do
			local tt = result[j]
			if(tt.head == data[1]) then
				local tp = data
				if(list[tp[tt.pos]].CardData.num == list[tt.repace].CardData.num) then
					tp[tt.pos] = tt.repace
					table.insert(this.arrystraight,tp)
				end
			end
		end
	end

	local spfinal = {}
	GameData.deepCopy(spfinal,sp)
	local alen = #spfinal
	local rlen = #spresult
	for i=1,alen do
		local data = spfinal[i]
		for j=1,rlen do
			local tt = spresult[j]
			if(tt.head == data[1]) then
				local tp = data
				if(list[tp[tt.pos]].CardData.num == list[tt.repace].CardData.num) then
					tp[tt.pos] = tt.repace
					table.insert(this.arrystraight,tp)
				end
			end
		end
		table.insert(this.arrystraight,data)
	end
end

SanshuiCtrl.arryFlowers = {}
function SanshuiCtrl.getFlowersType(list)--同花
	this.arryFlowers = {}
	local temp = {};
    local count = #list
    for i=1,count do
		local data = list[i]
		local start = data.CardData.cardtype
		frist = i
		temp = {}
		table.insert(temp,i)
		local index = 1
		for j=frist + 1,count do
			local data2 = list[j]
			local num = data2.CardData.cardtype
			if(num == start) then
				index = index + 1
				if(index == 5) then
					table.insert(temp,j)
					table.insert(this.arryFlowers,temp)
					break
				else
					table.insert(temp,j)
				end
			end
		end
	end
end

SanshuiCtrl.arryBottle = {}
function SanshuiCtrl.getBottleType(list)--葫芦
	this.arryBottle = {}
    local count = #this.arryThree
    local len = #this.arrypairs
    for i=1,count do
		local data = this.arryThree[i]
		local start = list[data[1]].CardData.num
		for j=1,len do
			local pair = this.arrypairs[j]
			local af = list[pair[1]].CardData.num
			if(af ~= start) then
				local temp = {};
				table.insert(temp,data[1])
				table.insert(temp,data[2])
				table.insert(temp,data[3])
				table.insert(temp,pair[1])
				table.insert(temp,pair[2])
				table.insert(this.arryBottle,temp)
			end
		end
	end
end

SanshuiCtrl._IronBomb = {}
SanshuiCtrl.arryIronbranch = {}
function SanshuiCtrl.getIronbranch(list)--铁支
	this.arryIronbranch = {}
	this._IronBomb = {}
	local temp = {};
    local count = #list
    for i=1,count do
		local data = list[i]
		local start = data.CardData.num
		frist = i
		temp = {}
		table.insert(temp,i)
		local index = 1
		for j=frist + 1,count do
			local data2 = list[j]
			local num = data2.CardData.num
			if(num == start) then
				index = index + 1
				if(index == 4) then
					table.insert(temp,j)
					for z=1,count do
						local vd = list[z]
						local vTable = {}
						if(z ~= temp[1] and z ~= temp[2] and z ~= temp[3] and z ~= temp[4]) then
							-- table.insert(vTable,temp[1])
							-- table.insert(vTable,temp[2])
							-- table.insert(vTable,temp[3])
							-- table.insert(vTable,temp[4])
							-- table.insert(vTable,z)
							vTable = {temp[1],temp[2],temp[3],temp[4],z}
							if(vd.CardData.num == start) then
								table.insert(this._IronBomb,vTable)
							else
								table.insert(this.arryIronbranch,vTable)
							end
						end
					end
					break
				else
					table.insert(temp,j)
				end
			end
		end
	end
end

SanshuiCtrl.arryflush = {}
function SanshuiCtrl.getFlushType(list)--同花顺
	this.arryflush = {}
	local straight = {}
	local len = #this.arrystraight
	for i=1,len do
		local all = this.arrystraight[i]
		local alen = #all
		local starttype = 0
		for j=1,alen do
			local data = list[all[j]]
			local cardtype = data.CardData.cardtype
			if(starttype == 0) then
				starttype = cardtype
			elseif(starttype ~= cardtype) then
				table.insert(straight,all)
				break
			elseif(starttype == cardtype and j == alen) then
				table.insert(this.arryflush,all)
			end
		end
	end
	this.arrystraight = straight
end

SanshuiCtrl._playScore = 0
SanshuiCtrl.Speed = 0
function SanshuiCtrl.updateBalanceScore()
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

SanshuiCtrl._scoreLen = 0
function SanshuiCtrl.getScoreValue()
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

function SanshuiCtrl.getZeroNum(len)
	local num = 1
	for i=1,len - 1 do
		num = num * 10
	end
	return num
end

SanshuiCtrl._finalVec = {}
function SanshuiCtrl.getScoreFinal()
	this._finalVec = {}
	local len = string.len(this._maxScore)
	this._scoreLen = len
	for i=1,len do
		local value = string.sub(this._maxScore, -i,len - (i-1))
		table.insert(this._finalVec,value)
	end
end

SanshuiCtrl._startScore = 0;
SanshuiCtrl._maxScore = 0;
SanshuiCtrl._startAnima = false;
SanshuiCtrl._haveBalance = false;
SanshuiCtrl._userBetVec = nil
function SanshuiCtrl.ShowBalance(data)
	this._haveBalance = false
	this.closeShowUI()
	this.showUIprefab("balanceInfo")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "balanceInfobar") then
			SanshuiPanel.balanceEnter:SetActive(true)
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
					global.sdk_mgr:share(1,"",files,"批批卢")
				end)
			end);
		end
	end
end

function SanshuiCtrl.sortPlayerBalance(list)
	local temp = nil
	local len = #list
	for i=1,len do
		local data = list[i]
		if(i ~= 1 and data.betusers.playerid == SanshuiPanel.getPlayerId()) then
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

SanshuiCtrl._balanceList = {}
function SanshuiCtrl.PrefabBalance(list)
	list = this.sortPlayerBalance(list)
	SanshuiPanel.balanceList_UIScrollView:ResetPosition()
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
		go.transform.parent = SanshuiPanel.balanceList.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0,92 - (i - 1) * 78,0);
		resMgr:addAltas(go.transform,"Room")
		local special = go.transform:Find('special').gameObject;
		local village = go.transform:Find('village').gameObject;
		if(i == 1 and this.patterntype ~= 1) then
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
		-- if(i == 1) then
			local point = go.transform:Find('point').gameObject;
			local ab = ""
			if(data.allBet >= 0) then
				ab = "+"
			end
			point:GetComponent('UILabel').text = ab .. data.allBet .. " 注"
		-- end
    	if(name == SanshuiPanel.getPlayerName()) then
    		WinCoin = coin
    		freehome:GetComponent('UILabel').text = "[FFCA3CFF]" .. GameData.GetShortName(name,6,6)
    		if(coin > 0) then
				bscore:GetComponent('UILabel').text ="[FF0000FF]+"..coin
			else 
				bscore:GetComponent('UILabel').text ="[00FF17FF]"..coin
			end
		end
		if(this.patterntype == 1) then
			this.updatePosCoin(data.betusers.playerid,data.betusers.gain_money,this._MinCoin)
		else
			this.updatePosCoin(data.betusers.playerid,data.betusers.gain_money,0)
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
			soundMgr:PlaySound("victory")
		end
	else
		if(this._uiPreant ~= nil) then
			this._uiPreant.transform:Find('loseanima').gameObject:SetActive(true)
			soundMgr:PlaySound("fail")
		end
    end
    local pH = len * 78
	if(pH > 280) then
		SanshuiPanel.balanceCollider_UISprite.height = pH
	end
end

function SanshuiCtrl.closeBalanceList()
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
function SanshuiCtrl.Close()
	UpdateBeat:Remove(this.timeEvent, this)
	this._userBetVec = nil
	this.myPlayerInfo = nil
	this.closeBalanceList()
	this.clearFiveCard()
	this.clearCardList()
	this.clearPlayerList()
	this.clearBigShow()
	this.closeShowUI()
	this.clearEffect()
	this.clearBullet()
	this.clearGunEffect()
	panelMgr:ClosePanel(CtrlNames.Sanshui);
end

return SanshuiCtrl