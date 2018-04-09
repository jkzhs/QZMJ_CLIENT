
local global = require("global")
local const = global.const
local config = global.config
local json = require "cjson"

require "logic/ViewManager"
LoginCtrl = {};
local this = LoginCtrl;

LoginCtrl.panel = nil;
LoginCtrl.transform = nil;
LoginCtrl.gameObject = nil;
LoginCtrl.Login = nil;

--构建函数--
function LoginCtrl.New()
	return this;
end

function LoginCtrl.Awake(onlogin_cb)
	this.onlogin_cb = onlogin_cb
	panelMgr:CreatePanel('Login', this.OnCreate);
end

--启动事件--
function LoginCtrl.OnCreate(obj)
	soundMgr:PlayBackSound(global.const.BG_MUSIC_LOGIN)
	gameMgr:startAnimEnd()
	this.gameObject = obj;
	this.transform = obj.transform;

	this.panel = this.transform:GetComponent('UIPanel');
	this.Login = this.transform:GetComponent('LuaBehaviour');
	-- Login:AddClick(LoginPanel.btnLand, this.OnLand);
	-- this.Login:AddClick(LoginPanel.btnVisitor, this.OnLand);
	-- this.Login:AddClick(LoginPanel.btnWeChat, this.OnWechat);
	-- this._FreeTime = 0

	LoginPanel.TxtAcount.gameObject:SetActive(false)
	if config.PACKAGE_TYPE == 1 then
		LoginPanel.btnWeChat:SetActive(true)
		LoginPanel.btnVisitor:SetActive(false)
		this.Login:AddClick(LoginPanel.btnWeChat, this.OnWechat);
	elseif config.PACKAGE_TYPE == 2 then
		LoginPanel.btnWeChat:SetActive(false)
		LoginPanel.btnVisitor:SetActive(true)
		LoginPanel.TxtAcount.gameObject:SetActive(true)
		this.Login:AddClick(LoginPanel.btnVisitor, this.OnLand);
	else
		LoginPanel.btnWeChat:SetActive(true)
		LoginPanel.btnVisitor:SetActive(true)
		LoginPanel.TxtAcount.gameObject:SetActive(true)

		this.Login:AddClick(LoginPanel.btnWeChat, this.OnWechat);
		this.Login:AddClick(LoginPanel.btnVisitor, this.OnLand);
	end

	if DEBUG == 0 then
		LoginPanel.TxtAcount.gameObject:SetActive(false)
	end

	local ac,pw
	local account = global.account_data:get_account()
	if account and account.uid and account.uid ~= "" then
		ac = account.uid
		pw = account.token
	else

		ac = "yk"..os.time()..generate_salt(6)
		pw = ac

	end
	LoginPanel.TxtAcount_UIInput.value = ac
	LoginPanel.TxtPwd.value = pw
	-- local name = PlayerPrefs.GetString("LoginName","")
 --    if name ~= "" then
 --        LoginPanel.TxtAcount.value = name
 --    end
 --    local pwd = PlayerPrefs.GetString("LoginPwd","")
 --    if pwd ~= "" then
 --        LoginPanel.TxtPwd.value = pwd
    -- end

    -- local value = LoginPanel.TxtAcount.value;
    -- PlayerPrefs.SetString("LoginName",value)
    -- local Pvalue = LoginPanel.TxtPwd.value;
    -- PlayerPrefs.SetString("LoginPwd",Pvalue)
    if global.login_mgr:get_login_game() and not global.config.NO_AUTO_LOGIN then
    	global.login_mgr:set_login_game(false)
    	if global.login_api:login(nil,nil,true) then
    		global._view:showLoading()
    		global.login_mgr:lgm_login_game()
    	end
  --   	local account = global.account_data:get_account()
		-- if account and account.uid then --存在帐号

		-- 	global._view:showLoading()
		-- 	global.login_api:on_login(account.uid, account.token,cb)

		-- 	global.login_mgr:lgm_login_game()
		-- end
    end
    LoginPanel.version_UILabel.text = "Version ".. PlayerPrefs.GetString("Version")--gameMgr:getApplicationVer()
    -- this.checkVersion()
end

-- function LoginCtrl.checkVersion()
-- 	if(tonumber(Application.version) < 2) then
-- 		global._view:support().Awake("检测到新版本，马上开始更新！",function ()
--        		gameMgr:StartUpdateRes("v1.1/")
--        		global._view:clearFormulateUI("Login")
--        	end,nil);
-- 	end
-- end

function LoginCtrl.timeEvent()
	-- this.FreeTimeEvent()
end

-- LoginCtrl._FreeTime = 0;
-- function LoginCtrl.FreeTimeEvent()
--   	if(this._FreeTime > 0) then
--         this._FreeTime = this._FreeTime - Time.deltaTime
--         if(this._FreeTime <= 0) then
--         	resMgr:weiLogin()
--         	this._FreeTime = 0;
--         end
--     end
-- end

--登陆--
function LoginCtrl.OnWechat(go)
	-- if(this._FreeTime == 0) then
		-- resMgr:weiLogin()
	-- end
	if Util.is_android() then
		resMgr:weiLogin()
	else
		gameMgr:login_sdk(function ( data )
			-- print("···5555",data)
			local msg = json.decode(data)
			if msg.code == "ok" then
				LoginPanel.openGameLobby(msg.openid,msg.access_token)
			else
				print("···openid is nil")
			end

		end)
	end
	-- if Application.platform == const.UE_PLATFORM_ANDROID then

	-- elseif Application.platform == const.UE_PLATFORM_IPHONEPLAYER then

	-- else
	-- 	print("···1111", UnityEngine.RuntimePlatform.IPhonePlayer)
	-- 	-- error(("platform failed %s"):format(Application.platform))
	-- end


end

function LoginCtrl.wechatLogin(response)
	-- print("tokens--------------------",tokens);
	-- this._FreeTime = 0
	if(response ~= "") then
		-- if this.onlogin_cb then
		-- 	this.onlogin_cb(tokens,tokens)
		-- end
		-- global._view:showLoading();
		-- global.account_data:save_account(tokens,tokens)
		local result = string.split(response, ",")
		LoginPanel.openGameLobby(result[2],result[1])
	end
end

--登陆--
function LoginCtrl.OnLand(go)
	if config.PACKAGE_TYPE == 2 or config.PACKAGE_TYPE == 3 then
	else
		logW(" PACKAGE_TYPE failed! ")
		return
	end
	 local ac,pw
	local ac = LoginPanel.TxtAcount_UIInput.value;
    local pw = LoginPanel.TxtPwd.value;

	if(ac == "" or pw == "") then
		logW(" ac or pw is nil ")
		return
	end
	-- local s =Util.stringtobyte("sdfsdfsdf")
	-- print("···111",Util.bytetostring(s))

	LoginPanel.openGameLobby(ac,pw)
end

--登陆--
function LoginCtrl.OnVisitor(go)
end

--关闭事件--
function LoginCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Login);
end

return LoginCtrl