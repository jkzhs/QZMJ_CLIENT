local global = require("global")
local transform;
ChatPanel = {};
local this = ChatPanel;
ChatPanel.gameObject = nil;
--启动事件--
function ChatPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel()
	global._view:changeLayerAll("Chat")--必加
end

--初始化面板--
function ChatPanel.InitPanel()
	this.singleInfo = transform:Find("singleInfo").gameObject
	this.singleBox = transform:Find("singleInfo/singleBox").gameObject
	this.singleSay = transform:Find("singleInfo/singleSay").gameObject
	this.singleSay_UILabel = this.singleSay:GetComponent('UILabel');
	this.singleLook = transform:Find("singleInfo/singleLook").gameObject
	this.singleLook_UISprite = this.singleLook:GetComponent('UISprite');
	this.singleviedo = transform:Find("singleInfo/singleviedo").gameObject
	this.singleviedoTxt = transform:Find("singleInfo/singleviedo/singleviedoTxt").gameObject
	this.singleviedoTxt_UILabel = this.singleviedoTxt:GetComponent('UILabel');

	this.allInfo = transform:Find("allInfo").gameObject
	this.closeAll = transform:Find("allInfo/closeAll").gameObject
	this.lookBox = transform:Find("allInfo/lookBox").gameObject
	this.txtBox = transform:Find("allInfo/txtBox").gameObject
	this.volmnBox = transform:Find("allInfo/volmnBox").gameObject
	this.volmnBox_VoiceChatPlayer = this.volmnBox:GetComponent('VoiceChatPlayer');
	this.volmnBox_AudioSource = this.volmnBox:GetComponent('AudioSource');

	this.content = transform:Find("allInfo/content").gameObject
	this.allList = transform:Find("allInfo/content/allList").gameObject
	this.allList_UIScrollView = this.allList:GetComponent('UIScrollView');
	this.BarCollider = transform:Find("allInfo/content/allList/BarCollider").gameObject
	this.BarCollider_UISprite = this.BarCollider:GetComponent('UISprite');

	this.showUI = transform:Find("allInfo/showUI").gameObject
	this.uibox = transform:Find("allInfo/showUI/uibox").gameObject
	this.expression = transform:Find("allInfo/showUI/expression").gameObject
	this.expressionlist = transform:Find("allInfo/showUI/expression/expressionlist").gameObject
	this.saydialog = transform:Find("allInfo/showUI/saydialog").gameObject
	this.saylist = transform:Find("allInfo/showUI/saydialog/saylist").gameObject 
	this.sayCollider = transform:Find("allInfo/showUI/saydialog/saylist/sayCollider").gameObject
	this.sayCollider_UISprite = this.sayCollider:GetComponent('UISprite');
	this.record = transform:Find("allInfo/showUI/record").gameObject 
	this.recordProcess = transform:Find("allInfo/showUI/record/recordProcess").gameObject
	this.recordProcess_UISprite = this.recordProcess:GetComponent('UISprite');
	this.recordcard = transform:Find("allInfo/showUI/record/recordcard").gameObject
	this.recard1 = transform:Find("allInfo/showUI/record/recordcard/recard1").gameObject
	this.recard2 = transform:Find("allInfo/showUI/record/recordcard/recard2").gameObject
	this.recard3 = transform:Find("allInfo/showUI/record/recordcard/recard3").gameObject
	this.recard4 = transform:Find("allInfo/showUI/record/recordcard/recard4").gameObject
end

function ChatPanel.getPlayerName()
	return global.player:get_name()
end

function ChatPanel.getPlayerImg()
	return global.player:get_headimgurl()
end

function ChatPanel.sendChat(msg,msgtype,voicetime)
	global.player:get_mgr("chat"):chat2room(msg,msgtype,voicetime)
end

function ChatPanel.getChatData(data,playerInfo)
	local name = playerInfo.from_name
	local Isviedo = false
	if(data.msgtype == 1) then
		Isviedo = true
	end
	local d={coin = 0,
		player_name = name,
		amount_money = 0,
		content = data.msg,
		url = playerInfo.from_headid,
		viedo = Isviedo,
		viedoTime = data.voice_time,
	}

	local who = 0
	if(name == this.getPlayerName()) then
		who = 1
	end
	if(this.ui ~= nil) then
		this.ui.addPlayerBetInfo(d,who)
	end
end

function ChatPanel.UpdateMessage(data,who)
	local d={
		coin = 0,
		player_name = data.player_name,
		amount_money = 0,
		content = data.msg,
		url = data.from_headid,
		viedo = false,
		viedoTime = 0,
	}
	if(this.ui ~= nil) then
		this.ui.addPlayerBetInfo(d,who)
	end
end 

function ChatPanel.OnDestroy()
	this.ui.Close()
end

return ChatPanel