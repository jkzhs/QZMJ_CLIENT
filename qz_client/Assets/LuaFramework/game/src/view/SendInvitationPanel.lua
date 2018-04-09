local global = require("global")

SendInvitationPanel = {};
local this = SendInvitationPanel;
SendInvitationPanel.gameObject = nil;
SendInvitationPanel.transform = nil;
--启动事件--
function SendInvitationPanel.Awake(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	global._view:changeLayerAll("SendInvitation")--必加
	this.closeUI = this.transform:Find("background/closeUI").gameObject;
	this.niuniuBtn = this.transform:Find("niuniuBtn").gameObject;
	this.niuniuBtn_Icon = this.transform:Find("niuniuBtn/Sprite").gameObject;
	this.shierzhiBtn = this.transform:Find("shierzhiBtn").gameObject;
	this.shierzhi_Icon = this.transform:Find("shierzhiBtn/Sprite").gameObject;
	this.GowBtn = this.transform:Find("GowBtn").gameObject;
	this.gow_Icon = this.transform:Find("GowBtn/Sprite").gameObject;
	this.yaoleziBtn=this.transform:Find("yaoleziBtn").gameObject;
	this.yaolezi_Icon=this.transform:Find("yaoleziBtn/Sprite").gameObject;
	this.sanshuiBtn=this.transform:Find("sanshuiBtn").gameObject;
	this.sanshui_Icon=this.transform:Find("sanshuiBtn/Sprite").gameObject;
	this.mjBtn=this.transform:Find("mjBtn").gameObject;
	this.mj_Icon=this.transform:Find("mjBtn/Sprite").gameObject;
	this.InvitationList = this.transform:Find("Info/InvitationList").gameObject;
	this.collider = this.transform:Find("Info/InvitationList/collider").gameObject;
	this.collider_UISprite = this.collider:GetComponent('UISprite');
end

function SendInvitationPanel.joinRoomPoto(roomId,gameID)
	global._view:showLoading();
	global.player:get_mgr("room"):enter(gameID,roomId,function (data)
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					if(global.const.GAME_ID_NIUNIU==gameID)then
						global._view:room().Awake(roomId,false,"")
					elseif(global.const.GAME_ID_12ZHI==gameID)then
						global._view:ShierzhiRoom().Awake(roomId,false,"")
					elseif(global.const.GAME_ID_PAIGOW==gameID)then
						global._view:paiGow().Awake(roomId,false,"")
					elseif(global.const.GAME_ID_YAOLEZI==gameID)then
						global._view:YaoLeZi().Awake(roomId,false,"")
					elseif(global.const.GAME_ID_WATER==gameID)then
						global._view:sanshui().Awake(roomId,false,"")
					elseif(global.const.GAME_ID_MJ==gameID)then
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

function SendInvitationPanel.getInvationList(gameID)
	global._view:showLoading();
	global.player:get_mgr("room"):req_invite_roomlist(gameID,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			this.ui.renderFunc(list,gameID)
		end
	end)
end

function SendInvitationPanel.clearView()
	global._view:clearFormulateUI("SendInvitation")
end

function SendInvitationPanel.OnDestroy()
	this.ui.Close()
end

return SendInvitationPanel