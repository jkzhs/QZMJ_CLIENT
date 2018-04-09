local global = require("global")
local game_init = require "game_init"
local transform;
LoginPanel = {};
local this = LoginPanel;
LoginPanel.gameObject = nil;
--启动事件--
function LoginPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.timeEvent()
	this.InitPanel();
	global._view:changeLayerAll("Login")--必加
end

function LoginPanel.timeEvent()
    global._view:addTimeEvent(this.gameObject.name,function()
    	this.ui.timeEvent()
    end)
end

--初始化面板--
function LoginPanel.InitPanel()
	this.btnVisitor = transform:FindChild("Visitor").gameObject;--游客登陆
	-- this.btnLand = transform:FindChild("Land").gameObject;--登陆
	this.btnWeChat = transform:FindChild("WeChat").gameObject;--微信登陆
	this.TxtAcount = transform:Find('TxtAcount');--账号
	this.TxtAcount_UIInput = this.TxtAcount:GetComponent('UIInput');
	this.TxtPwd = transform:Find('TxtPwd'):GetComponent('UIInput');--密码
	this.version_UILabel = transform:Find('version'):GetComponent('UILabel');
end

function LoginPanel.openGameLobby(ac,pw)
	if(global._view.IsFrist) then
		game_init.stage2()
	end
	if this.ui.onlogin_cb then
		this.ui.onlogin_cb(ac,pw)
	end

	-- global.login_mgr:lgm_login_game(ac,pw,plat)

end

function LoginPanel.OnDestroy()
	this.ui.Close()
	global._view:canceTimeEvent(this.gameObject.name)
end

return LoginPanel