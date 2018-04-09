require "logic/ViewManager"
local global = require("global")
local const = global.const 
ChatCtrl = {};
local this = ChatCtrl;

local CAN_PAUSE =global._view.CAN_PAUSE--更换CS文件后可以设置为true
this.gameid = nil 
--构建函数--
function ChatCtrl.New()
	return this;
end

ChatCtrl._text = ""
function ChatCtrl.Awake(gameid)
	panelMgr:CreatePanel('Chat', this.OnCreate);
	this.gameid = gameid 
end

function ChatCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.chat= this.transform:GetComponent('LuaBehaviour');
	this.chat:AddClick(ChatPanel.singleBox, function ()
		if(ChatPanel.volmnBox_AudioSource.clip ~= nil) then
			ChatPanel.volmnBox_AudioSource.enabled = false
		end
		ChatPanel.allInfo:SetActive(true);
	end);
	this.chat:AddClick(ChatPanel.closeAll, function ()
		ChatPanel.allInfo:SetActive(false);
	end);
	this.chat:AddClick(ChatPanel.lookBox, this.OnExpression);
	this.chat:AddClick(ChatPanel.txtBox, this.OnSay);
	this.chat:AddOnPress(ChatPanel.volmnBox, this.OnViedo);
	this.chat:AddClick(ChatPanel.uibox, this.closeShowUI);
	this.allRecard = {ChatPanel.recard1,ChatPanel.recard2,ChatPanel.recard3,
	ChatPanel.recard4}
	ChatPanel.volmnBox_VoiceChatPlayer.onSendVoice = function(sendLen,SendData)
		if sendLen == 0 then
	        this.animaTime = 0
	        this.StartViedoTime = 0
			this.isStartViedo = false;
			ChatPanel.record:SetActive(false)
			this.PlayBGSound()
			ChatPanel.volmnBox_VoiceChatPlayer:StopRecording()
	        return
	    end
	    this.stopRecord(SendData)
	    ChatPanel.volmnBox_VoiceChatPlayer:StopRecording()
    end
    --commit voice
    ChatPanel.volmnBox_VoiceChatPlayer.onCommitVoice = function ()
    	ChatPanel.volmnBox_VoiceChatPlayer:getSendAllData()
    end
    UpdateBeat:Add(this.timeEvent, this)
end

function ChatCtrl.timeEvent()
	this.updateViedo()
	this.startSayAnima()
end

ChatCtrl.isStartViedo = false
ChatCtrl.StartViedoTime = 0
ChatCtrl.pressPoint = nil
ChatCtrl.viedodist = 0
function ChatCtrl.OnViedo(go,isPress)
	ChatPanel.volmnBox_AudioSource.enabled = true
	if(isPress) then
		if(this.StartViedoTime < 8) then
			this.startRecord()
		else
			ChatPanel.volmnBox_VoiceChatPlayer:getSendAllData()
		end
	else
		ChatPanel.volmnBox_VoiceChatPlayer:getSendAllData()
	end
end

function ChatCtrl.sendChatData(chatData)
	ChatPanel.sendChat(chatData,1,this.StartViedoTime)
	this.StartViedoTime = 0
end

function ChatCtrl.startRecord()
	if(this.isStartViedo) then
		return
	end
	ChatPanel.volmnBox_VoiceChatPlayer:StopRecording()
    ChatPanel.volmnBox_VoiceChatPlayer:StartRecording()
	this.isStartViedo = true;
	this.StartViedoTime = 0
	this.pressPoint = Input.mousePosition;
	this.viedodist = 0
	this.viedoIndex = 4
	ChatPanel.record:SetActive(true)
	ChatPanel.recard1:SetActive(true)
	ChatPanel.recard2:SetActive(true)
	ChatPanel.recard3:SetActive(true)
	ChatPanel.recard4:SetActive(true)
	this.pauseMusic()
end

ChatCtrl.IsFuncOpen = false
function ChatCtrl.stopRecord(chatData)
	this.animaTime = 0
	this.isStartViedo = false;
	ChatPanel.record:SetActive(false)
	this.PlayBGSound()
	if(this.StartViedoTime < 0.2) then
		ChatPanel.setTip("您说话太快了")
		return
	end
	if(this.viedodist < 50) then
		this.sendChatData(chatData)
	end
end

function ChatCtrl.updateViedo()
	if(this.isStartViedo) then
		this.StartViedoTime = this.StartViedoTime + Time.deltaTime
		this.animaTime = this.animaTime + Time.deltaTime
		ChatPanel.recordProcess_UISprite.fillAmount = 1 - this.StartViedoTime / 7
		if(this.StartViedoTime >= 8) then
			this.StartViedoTime = 8
			this.isStartViedo = false
			ChatPanel.volmnBox_VoiceChatPlayer:getSendAllData()
		end
		local inputPoint = Input.mousePosition;
	    this.viedodist = this.chat:Distance(this.pressPoint.x, this.pressPoint.y, this.pressPoint.z,
	                               inputPoint.x, inputPoint.y, inputPoint.z)
	    if(this.animaTime >= 0.2) then
	    	this.animaTime = 0
	    	this.playViedoAnima()
	    end
	end
end

ChatCtrl.animaTime = 0
ChatCtrl.viedoIndex = 4
ChatCtrl.allRecard = {}
function ChatCtrl.playViedoAnima()
	if(this.viedoIndex > 4) then
		this.viedoIndex = 1
		ChatPanel.recard1:SetActive(false)
		ChatPanel.recard2:SetActive(false)
		ChatPanel.recard3:SetActive(false)
		ChatPanel.recard4:SetActive(false)
	end
	this.allRecard[this.viedoIndex]:SetActive(true)
	this.viedoIndex = this.viedoIndex + 1
end

ChatCtrl.allList = {}
ChatCtrl.battleInfo = ""
function ChatCtrl.addPlayerBetInfo(info,who)
	ChatPanel.allList_UIScrollView:ResetPosition();
	local playername = info.player_name
	local coin = info.coin
	local amountmoney = info.amount_money
	local txt = nil
	local islook = false
	ChatPanel.singleSay_UILabel.text = GameData.GetShortName(playername,8,8) .. ":";
	local sx = ChatPanel.singleSay_UILabel.width / 2
	ChatPanel.singleLook:SetActive(false);
	ChatPanel.singleviedo:SetActive(false);
	if(info.viedo == false) then
		txt = " 下注:" .. coin .. "  总下注:" .. amountmoney
		if(info.content ~= "") then
			txt = info.content
			islook = this.checkIsLook(txt)
		end
		if(islook) then
			ChatPanel.singleLook.transform.localPosition = Vector3(371 + sx, -320, 0);
			ChatPanel.singleLook:SetActive(true);
			ChatPanel.singleLook_UISprite.spriteName = info.content
		else
			ChatPanel.singleSay_UILabel.text = ChatPanel.singleSay_UILabel.text .. txt
		end
	else
		txt = info.content
		ChatPanel.singleviedo.transform.localPosition = Vector3(371 + sx, -320, 0);
		ChatPanel.singleviedo:SetActive(true);
		ChatPanel.singleviedoTxt_UILabel.text = string.format("%.2f", info.viedoTime) .. "''"
	end
	local len = #this.allList
	this.addBattleInfo(playername,txt,who,len,islook,info.url,info.viedo,info.viedoTime)
	this.checkBattleMax(len + 1)
	local height = this.totalH
	ChatPanel.allList_UIScrollView:ResetPosition();
	if(height > 620) then
		ChatPanel.BarCollider_UISprite.height = height
		ChatPanel.allList_UIScrollView:SetDragAmount(0,1,false)
	else
		ChatPanel.BarCollider_UISprite.height = 620
	end
end

ChatCtrl.totalH = 0
ChatCtrl.minW = 80
ChatCtrl.maxW = 366
ChatCtrl.chatSpace = 90
ChatCtrl.sigleDialogH = 60
ChatCtrl.sigleTxtH = 36
function ChatCtrl.addBattleInfo(name,txt,IsSelf,len,islook,url,viedo,viedoTime)
	local allH = this.getBattleH();
	local parent = ChatPanel.allList.transform;
    local bundle = resMgr:LoadBundle("chatBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"chatBar");
	local go = GameObject.Instantiate(Prefab);
	go.name = "chatBar"..len;
	go.transform.parent = parent;
	go.transform.localScale = Vector3.one;
	go.transform.localPosition = Vector3(0, 308 - allH, 0);
	resMgr:addAltas(go.transform,"Chat")
	local testTxt = go.transform:Find('testTxt');
	local testTxt_UILabel = testTxt:GetComponent('UILabel')
	local lenght = 100
	if(viedo == false) then
		testTxt_UILabel.text = txt
		lenght = testTxt_UILabel.width
	end
	local H = 0;
	if(IsSelf == 0) then
		go.transform:Find('other').gameObject:SetActive(true);
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
				this.chat:AddClick(updialog, function ()
					if(this.viedoAll ~= nil) then
						if(this.viedoAll.IsPlay == go.name) then
							return
						end
					end
					ChatPanel.volmnBox_AudioSource.enabled = true
					this.pauseMusic()
					ChatPanel.volmnBox_VoiceChatPlayer:Stop();
				    ChatPanel.volmnBox_VoiceChatPlayer:addCacheDataByte(txt)
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
		local low = upH / 34
		H = this.chatSpace + (low - 1) * this.sigleTxtH;
		updialog:GetComponent('UISprite').height = this.sigleDialogH + (low - 1) * this.sigleTxtH
	elseif(IsSelf == 1) then
		go.transform:Find('myself').gameObject:SetActive(true);
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
				this.chat:AddClick(downdialog, function ()
					if(this.viedoAll ~= nil) then
						if(this.viedoAll.IsPlay == go.name) then
							return
						end
					end
					ChatPanel.volmnBox_AudioSource.enabled = true
					this.pauseMusic()
					ChatPanel.volmnBox_VoiceChatPlayer:Stop();
				    ChatPanel.volmnBox_VoiceChatPlayer:addCacheDataByte(txt)
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
		local low = downH / 34
		H = this.chatSpace + (low - 1) * this.sigleTxtH;
		downdialog_UISprite.height = this.sigleDialogH + (low - 1) * this.sigleTxtH
	else
		go.transform:Find('joinInfo').gameObject:SetActive(true);
		local joinName_UILabel = go.transform:Find('joinInfo/joinName'):GetComponent('UILabel')
		joinName_UILabel.text = "[000000]" .. name .. txt
		local jw = joinName_UILabel.width
		local joinbg_UISprite = go.transform:Find('joinInfo/joinbg'):GetComponent('UISprite')
		joinbg_UISprite.width = jw + 54
		H = joinbg_UISprite.height
	end
	local battleInfo = {battle = go,
		battleH = H + 20,
		chat = txt,
		chatType = IsSelf,
		url = url,}
	table.insert(this.allList,battleInfo)
	this.totalH = allH + battleInfo.battleH
	this.loadBattleIcon()
end

function ChatCtrl.startSayAnima()
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

ChatCtrl.viedoAll = nil
ChatCtrl.AllIndex = 3
ChatCtrl.sayTime = 0
ChatCtrl.totalTime = 0
ChatCtrl.IsSay = false
ChatCtrl.StopTime = 0
function ChatCtrl.playViedoData()
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

function ChatCtrl.resertVideo()
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

function ChatCtrl.loadBattleIcon()
	local len = #this.allList;
	for i=1,len do
		local battle = this.allList[i]
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

function ChatCtrl.getBattleH()
	local len = #this.allList
	local battleH = 0
	for i=1,len do
		local battle = this.allList[i]
		if(battle ~= nil) then
			battleH = battleH + battle.battleH
		end
	end
	return battleH
end

function ChatCtrl.checkBattleMax(count)
	if(count > 50) then
		local data = this.allList[1]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data.battle);
			table.remove(this.allList,1);
			local len = #this.allList
			local battleH = 0
			for i=1,len do
				local battleInfo = this.allList[i]
				battleInfo.battle.transform.localPosition = Vector3(0, 228 - battleH, 0);
				battleH = battleH + battleInfo.battleH
			end
			this.totalH = battleH
		end
	end
end

function ChatCtrl.clearBattle()
	local len = #this.allList;
	for i=1,len do
		local data = this.allList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data.battle);
		end
	end
	this.allList = {}
end

function ChatCtrl.closeShowUI()
	if(this._uiPreant ~= nil) then
		panelMgr:ClearPrefab(this._uiPreant);
		this._uiPreant = nil;
	end
	ChatPanel.uibox:SetActive(false)
	ChatPanel.expression:SetActive(false)
	ChatPanel.saydialog:SetActive(false)
end

ChatCtrl._lookVec = {}
function ChatCtrl.OnExpression()
	ChatPanel.uibox:SetActive(true)
	ChatPanel.expression:SetActive(true)
	if(#this._lookVec > 0) then
		return
	end
	local lookExpression = {}
	for i=1,30 do
		local name = "biaoqing_" .. (i - 1)
		table.insert(lookExpression,name)
	end
	local parent = ChatPanel.expressionlist.transform;
    local bundle = resMgr:LoadBundle("lookIcon");
    local Prefab = resMgr:LoadBundleAsset(bundle,"lookIcon");
    local startX = 238
    local startY = 70
    local space = 90
    local height = 60
    local column = 5;
	local len = #lookExpression;
	for i = 1, len do
		local data = lookExpression[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "lookIcon"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(startX + space * ((i - 1) % column), startY - math.floor((i - 1) / column) * height, 0);
		resMgr:addAltas(go.transform,"Chat")
		local expreIcon = go.transform:Find('expreIcon').gameObject
		expreIcon.name = "expreIcon" .. i
		local expreIcon_UISprite = expreIcon:GetComponent('UISprite');
		expreIcon_UISprite.spriteName = data
		expreIcon_UISprite:MakePixelPerfect();
		expreIcon.transform.localScale = Vector3(1,1,1)
		this.chat:AddClick(expreIcon, function ()
			ChatPanel.sendChat(data)
			ChatPanel.uibox:SetActive(false)
			ChatPanel.expression:SetActive(false)
		end);
		table.insert(this._lookVec,go)
	end
end

function ChatCtrl.checkIsLook(text)
	if(string.find(text,"biaoqing_") ~= nil) then
		return true
	end
	return false
end

function ChatCtrl.closeLookList()
	local len = #this._lookVec;
	for i=1,len do
		local data = this._lookVec[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._lookVec = {}
end

ChatCtrl._sayVec = {}
function ChatCtrl.OnSay()
	ChatPanel.uibox:SetActive(true)
	ChatPanel.saydialog:SetActive(true)
	if(#this._sayVec > 0) then
		return
	end
	local sayContent = {"双击666。","扎心了老铁。","厉害了我的哥。","一言不合就好牌。",
	"明明可以靠脸吃饭，偏偏要靠才华","人生就像一场戏，输赢不用在意。","下得多赢得多。",
	"快点啊，都等到我花儿都谢谢了！","怎么又断线了，网络怎么这么差啊！",
	"不要走，决战到天亮！","你的牌打得也太好了！","和你合作真是太愉快了！",
	"大家好，很高兴见到各位！","各位，真是不好意思，我得离开一会儿。","不要吵了，专心玩游戏吧！"}
	local parent = ChatPanel.saylist.transform;
    local bundle = resMgr:LoadBundle("chatSayBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"chatSayBar");
    local startY = 165
    local height = 0
	local len = #sayContent;
	for i = 1, len do
		local data = sayContent[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "chatSayBar"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(-117, startY - height, 0);
		resMgr:addAltas(go.transform,"Chat")
		local saytxt = go.transform:Find('saytxt').gameObject;
		saytxt.name = "saytxt" .. i
		local saytxt_UILabel = saytxt:GetComponent('UILabel');
		this.chat:AddClick(saytxt, function ()
			ChatPanel.sendChat(data)
			ChatPanel.uibox:SetActive(false)
			ChatPanel.saydialog:SetActive(false)
		end);
		saytxt_UILabel.text = data
		local ph = saytxt_UILabel.height
		height = height + ph + 5
		table.insert(this._sayVec,go)
	end
	ChatPanel.sayCollider_UISprite.height = height
end

function ChatCtrl.closeSayList()
	local len = #this._sayVec;
	for i=1,len do
		local data = this._sayVec[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._sayVec = {}
end
function ChatCtrl.pauseMusic()
	if CAN_PAUSE then 
		soundMgr:PauseBackSound()
	else
		soundMgr:StopBackSound()
	end 
end 
function ChatCtrl.PlayBGSound()
	if CAN_PAUSE then 
		soundMgr:PlayMusic()
	else
		if this.gameid == const.GAME_ID_12ZHI then 
			soundMgr:PlayBackSound("shierzhi_music")
		elseif this.gameid == const.GAME_ID_NIUNIU then 
			soundMgr:PlayBackSound("niuniu_music")
		elseif this.gameid == const.GAME_ID_PAIGOW then
			soundMgr:PlayBackSound("paigo_music") 
		elseif this.gameid == const.GAME_ID_YAOLEZI then 
			soundMgr:PlayBackSound("yaolezi_music")
		elseif this.gameid == const.GAME_ID_WATER then 
			soundMgr:PlayBackSound("background")
		elseif this.gameid == const.GAME_ID_MJ then 
			soundMgr:PlayBackSound("background")
		end 
	end 
end 
--关闭事件--
function ChatCtrl.Close()
	this.closeShowUI()
	this.clearBattle()
	this.closeLookList()
	this.closeSayList()
	UpdateBeat:Remove(this.timeEvent, this)
	panelMgr:ClosePanel(CtrlNames.Chat);
end

return ChatCtrl