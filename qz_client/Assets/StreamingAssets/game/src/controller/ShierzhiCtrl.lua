require "logic/ViewManager"
ShierzhiCtrl = {};
local this = ShierzhiCtrl;

ShierzhiCtrl.panel = nil;
ShierzhiCtrl.Shierzhi = nil;
ShierzhiCtrl.transform = nil;
ShierzhiCtrl.gameObject = nil;

--构建函数--
function ShierzhiCtrl.New()
	return this;
end

function ShierzhiCtrl.Awake()
	panelMgr:CreatePanel('Shierzhi', this.OnCreate);
end
--启动事件--
function ShierzhiCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.panel = this.transform:GetComponent('UIPanel');
	this.Shierzhi = this.transform:GetComponent('LuaBehaviour');
	this.Shierzhi:AddClick(ShierzhiPanel.createRoom, this.OnCreateRoom);
	this.Shierzhi:AddClick(ShierzhiPanel.joinRoom, this.OnJoin);
	this.Shierzhi:AddClick(ShierzhiPanel.joinPublic, this.OnPublic);
	this.Shierzhi:AddClick(ShierzhiPanel.btnBack, this.OnBack);
	this.update_data()
	ShierzhiPanel.joinEffect_Renderer.sortingOrder = 11
	ShierzhiPanel.createEffect_Renderer.sortingOrder = 11
	ShierzhiPanel.uplight1_Renderer.sortingOrder = 12
	ShierzhiPanel.uplight2_Renderer.sortingOrder = 12
	ShierzhiPanel.uplight3_Renderer.sortingOrder = 12
end
function ShierzhiCtrl.update_data( ... )
	ShierzhiPanel.diamondTxt.text = ShierzhiPanel.get_RMB()
	ShierzhiPanel.coinTxt.text = ShierzhiPanel.get_money()
	ShierzhiPanel.playerIcon_AsyncImageDownload:SetAsyncImage(ShierzhiPanel.getHeadUrl())
end

ShierzhiCtrl.roomId = ""
function ShierzhiCtrl.OnCreateRoom(go)
	ShierzhiPanel.openGame()
end

function ShierzhiCtrl.OnJoin(go)
	ShierzhiPanel.JoinRoom()
end

function ShierzhiCtrl.OnPublic()
	ShierzhiPanel.gameScore()
end

function ShierzhiCtrl.OnBack(go)
	ShierzhiPanel.backLobby()
end

--关闭事件--
function ShierzhiCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Shierzhi);
end

return ShierzhiCtrl