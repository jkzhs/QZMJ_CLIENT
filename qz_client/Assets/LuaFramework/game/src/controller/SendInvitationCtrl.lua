require "logic/ViewManager"
local global=require("global")
SendInvitationCtrl = {};
local this = SendInvitationCtrl;
SendInvitationCtrl.SendInvita = nil;
SendInvitationCtrl.transform = nil;
SendInvitationCtrl.gameObject = nil;
--构建函数--
function SendInvitationCtrl.New()
	return this;
end

function SendInvitationCtrl.Awake()
	panelMgr:CreatePanel('SendInvitation', this.OnCreate);
end

function SendInvitationCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.SendInvita = this.transform:GetComponent('LuaBehaviour');
	this.SendInvita:AddClick(SendInvitationPanel.niuniuBtn,this.OnNiuNiuClick);
	this.SendInvita:AddClick(SendInvitationPanel.shierzhiBtn,this.OnShierZhiClick);
	this.SendInvita:AddClick(SendInvitationPanel.GowBtn,this.OnGowClick);
	this.SendInvita:AddClick(SendInvitationPanel.closeUI, this.OnBack);
	this.SendInvita:AddClick(SendInvitationPanel.yaoleziBtn,this.OnYaoLeZiClick)
	this.SendInvita:AddClick(SendInvitationPanel.mjBtn,this.OnMJClick)
	this.SendInvita:AddClick(SendInvitationPanel.sanshuiBtn,this.OnSanShuiClick)
	SendInvitationPanel.niuniuBtn_Icon:SetActive(true)
	SendInvitationPanel.getInvationList(global.const.GAME_ID_NIUNIU)--开始先刷新牛牛的邀请列表
end

SendInvitationCtrl._InvitationList = {}
function SendInvitationCtrl.renderFunc (list,gameID)
	if(list ~= nil) then
		if(#list == 0) then
			return
		end
	else
		return
	end
	local len = #list;
    local parent = SendInvitationPanel.InvitationList.transform;
    local bundle = resMgr:LoadBundle("InvitationInfo");
    local Prefab = resMgr:LoadBundleAsset(bundle,"InvitationInfo");
    local space = 55;
	for i = 1, len do
		local data = list[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "InvitationInfo"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0, 105 - space*(i - 1), 0);
		resMgr:addAltas(go.transform,"SendInvitation")
		local goo = go.transform:Find('join').gameObject;
		this.SendInvita:AddClick(goo, function ()
			SendInvitationPanel.joinRoomPoto(data.roomid,gameID)
		end);
		local number = go.transform:Find('number').gameObject;
		local name = go.transform:Find('name').gameObject;
		local tag = go.transform:Find('tag').gameObject;
		number:GetComponent('UILabel').text = data.onlinecount;
		name:GetComponent('UILabel').text = GameData.GetShortName(data.player_name,10,10);
		tag:GetComponent('UILabel').text = i;
		table.insert(this._InvitationList,go)
	end
	local colliderH = space * len
	if(colliderH > 270) then
		SendInvitationPanel.collider_UISprite.width = colliderH
	end
end

function SendInvitationCtrl.OnNiuNiuClick()
	this.clearVec();
	SendInvitationPanel.niuniuBtn_Icon:SetActive(true)
	SendInvitationPanel.getInvationList(global.const.GAME_ID_NIUNIU);
end 

function SendInvitationCtrl.OnShierZhiClick()
	this.clearVec();
	SendInvitationPanel.shierzhi_Icon:SetActive(true)
	SendInvitationPanel.getInvationList(global.const.GAME_ID_12ZHI);
end

function SendInvitationCtrl.OnGowClick()
	this.clearVec();
	SendInvitationPanel.gow_Icon:SetActive(true)
	SendInvitationPanel.getInvationList(global.const.GAME_ID_PAIGOW);
end

function SendInvitationCtrl.OnYaoLeZiClick()
	this.clearVec();
	SendInvitationPanel.yaolezi_Icon:SetActive(true)
	SendInvitationPanel.getInvationList(global.const.GAME_ID_YAOLEZI);
end

function SendInvitationCtrl.OnMJClick()
	this.clearVec();
	SendInvitationPanel.mj_Icon:SetActive(true)
	SendInvitationPanel.getInvationList(global.const.GAME_ID_MJ)
end 

function SendInvitationCtrl.OnSanShuiClick()
	this.clearVec();
	SendInvitationPanel.sanshui_Icon:SetActive(true)
	SendInvitationPanel.getInvationList(global.const.GAME_ID_WATER);
end

function SendInvitationCtrl.clearVec()
	SendInvitationPanel.niuniuBtn_Icon:SetActive(false)
	SendInvitationPanel.shierzhi_Icon:SetActive(false)
	SendInvitationPanel.gow_Icon:SetActive(false)
	SendInvitationPanel.yaolezi_Icon:SetActive(false)
	SendInvitationPanel.sanshui_Icon:SetActive(false)
	SendInvitationPanel.mj_Icon:SetActive(false)
	local len = #this._InvitationList;
	for i=1,len do
		local data = this._InvitationList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._InvitationList = {}
end

function SendInvitationCtrl.OnBack()
	SendInvitationPanel.clearView()
end

--关闭事件--
function SendInvitationCtrl.Close()
	this.clearVec()
	panelMgr:ClosePanel(CtrlNames.SendInvitation);
end

return SendInvitationCtrl