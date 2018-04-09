local global = require("global")
local mgr_room = global.player:get_mgr("room")
local mgr_dealer = global.player:get_mgr("dealer")
local const = global.const
local transform;
JoinRoomPanel = {};
local this = JoinRoomPanel;
JoinRoomPanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("JoinRoom")--必加
end

--初始化面板--
function this.InitPanel()
	this.close = transform:Find("close").gameObject;
	this.oneBtn = transform:Find("oneBtn").gameObject;
	this.twoBtn = transform:Find("twoBtn").gameObject;
	this.threeBtn = transform:Find("threeBtn").gameObject;
	this.fourBtn = transform:Find("fourBtn").gameObject;
	this.fiveBtn = transform:Find("fiveBtn").gameObject;
	this.sixBtn = transform:Find("sixBtn").gameObject;
	this.sevenBtn = transform:Find("sevenBtn").gameObject;
	this.eightBtn = transform:Find("eightBtn").gameObject;
	this.nineBtn = transform:Find("nineBtn").gameObject;
	this.tenBtn = transform:Find("tenBtn").gameObject;
	this.oneTxt = transform:Find("oneTxt").gameObject;
	this.oneTxt_UILabel = this.oneTxt:GetComponent('UILabel');
	this.twoTxt = transform:Find("twoTxt").gameObject;
	this.twoTxt_UILabel = this.twoTxt:GetComponent('UILabel');
	this.threeTxt = transform:Find("threeTxt").gameObject;
	this.threeTxt_UILabel = this.threeTxt:GetComponent('UILabel');
	this.fourTxt = transform:Find("fourTxt").gameObject;
	this.fourTxt_UILabel = this.fourTxt:GetComponent('UILabel');
	this.fiveTxt = transform:Find("fiveTxt").gameObject;
	this.fiveTxt_UILabel = this.fiveTxt:GetComponent('UILabel');
	this.sixTxt = transform:Find("sixTxt").gameObject;
	this.sixTxt_UILabel = this.sixTxt:GetComponent('UILabel');
	this.delBtn = transform:Find("delBtn").gameObject;
	this.RoomTitle = transform:Find("RoomTitle").gameObject;
	this.RoomTitle_UILabel = this.RoomTitle:GetComponent('UILabel');
end

function this.joinRoomPoto(roomId,gameID)
	global._view:showLoading();
	mgr_room:enter(gameID,roomId,function (data)
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					if (gameID==const.GAME_ID_NIUNIU)then
						global._view:room().Awake(roomId,false,"")
					elseif(gameID==const.GAME_ID_12ZHI)then
						global._view:ShierzhiRoom().Awake(roomId,false,"")
					elseif(gameID==const.GAME_ID_PAIGOW)then
						global._view:paiGow().Awake(roomId,false,"")
					elseif(gameID==const.GAME_ID_YAOLEZI)then
						global._view:YaoLeZi().Awake(roomId,false,"")
					elseif(gameID==const.GAME_ID_WATER)then
						global._view:sanshui().Awake(roomId,false,"")
					elseif(gameID==const.GAME_ID_MJ)then
						global._view:majiang().Awake(roomId,false,"")
					end
				else
					global._view:hideLoading();
					global._view:getViewBase("Tip").setTip(global.errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)
end

function this.BindAccontPoto(roomId)
	mgr_dealer:req_agree_invite(roomId,function (data)
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					global._view:getViewBase("Tip").setTip("绑定成功")
				else
					global._view:getViewBase("Tip").setTip(global.errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)
end

function this.clearView()
	global._view:clearFormulateUI("JoinRoom")
end

function this.OnDestroy()
	this.ui.Close()
end

return JoinRoomPanel