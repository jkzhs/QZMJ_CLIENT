require "logic/ViewManager"
local global = require("global")
SettingCtrl = {};
local this = SettingCtrl;
this.gameid = nil 
--构建函数--
function this.New()
	return this;
end

function this.Awake(gameid)
	panelMgr:CreatePanel('Setting', this.OnCreate);
	this.gameid = gameid 
end

--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.beh= this.transform:GetComponent('LuaBehaviour');
	this.beh:AddClick(SettingPanel.closeUI, function ()
		SettingPanel.clearView()
	end);
	this.beh:AddClick(SettingPanel.btnOut, this.OnOut);
	this.beh:AddOnPress(SettingPanel.btnvolmn, this.OnBtnRoller);
	this.beh:AddOnPress(SettingPanel.bgvolmn, this.OnBgRoller);
	this.initRollerPos()
	if this.gameid then 
		if this.gameid == global.const.GAME_ID_MJ then 
			SettingPanel.btnOut:SetActive(false)
		end 
	end 
end

function this.timeEvent()
    this.updateMouse()
end

this._IsPress = false
function this.updateMouse()
	if(this._IsPress) then
		if(this.pointType == "Btn") then
			local inputPoint = Input.mousePosition;
		    local dist = this.beh:Distance(this.pressPoint.x, this.pressPoint.y, this.pressPoint.z,
		                               inputPoint.x, inputPoint.y, inputPoint.z)
		    if(this.pressPoint.x > inputPoint.x) then
		    	dist = -dist
		    end
		    local pos = this.startPoint + dist
		    if(pos <= 192 and pos >= -192) then
		    	local curdist = this.startbtn + dist
		    	SettingPanel.btnvolmn.transform.localPosition = Vector3(pos, 83, 0);
		    	SettingPanel.btnprocess_UISprite.width = curdist
		    	soundMgr:setSoundVolmn(curdist / 416)
		    elseif(pos > 192) then
		    	SettingPanel.btnvolmn.transform.localPosition = Vector3(192, 83, 0);
		    	SettingPanel.btnprocess_UISprite.width = 416
		    	soundMgr:setSoundVolmn(1)
		    elseif(pos < -192) then
		    	SettingPanel.btnvolmn.transform.localPosition = Vector3(-192, 83, 0);
		    	SettingPanel.btnprocess_UISprite.width = 20
		    	soundMgr:setSoundVolmn(0)
		    end
		else
			local inputPoint = Input.mousePosition;
		    local dist = this.beh:Distance(this.pressBgPoint.x, this.pressBgPoint.y, this.pressBgPoint.z,
		                               inputPoint.x, inputPoint.y, inputPoint.z)
		    if(this.pressBgPoint.x > inputPoint.x) then
		    	dist = -dist
		    end
		    local pos = this.startBgPoint + dist
		    if(pos <= 192 and pos >= -192) then
		    	local curdist = this.startbg + dist
		    	SettingPanel.bgvolmn.transform.localPosition = Vector3(pos, -37, 0);
		    	SettingPanel.bgprocess_UISprite.width = curdist
		    	soundMgr:setBackSoundVolmn(curdist / 416)
		    elseif(pos > 192) then
		    	SettingPanel.bgvolmn.transform.localPosition = Vector3(192, -37, 0);
		    	SettingPanel.bgprocess_UISprite.width = 416
		    	soundMgr:setBackSoundVolmn(1)
		    elseif(pos < -192) then
		    	SettingPanel.bgvolmn.transform.localPosition = Vector3(-192, -37, 0);
		    	SettingPanel.bgprocess_UISprite.width = 20
		    	soundMgr:setBackSoundVolmn(0)
		    end
		end
	end
end

this.pressPoint = nil
this.startPoint = 0
this.pointType = "Btn"
function this.OnBtnRoller(go,isPress)
	this.pointType = "Btn"
	this._IsPress = isPress;
	this.startPoint = PlayerPrefs.GetInt("BtnRoller")
	this.pressPoint = Input.mousePosition
	if(isPress == false) then
		PlayerPrefs.SetInt("BtnRoller",SettingPanel.btnvolmn.transform.localPosition.x)
		this.initRollerPos()
	end
end

this.pressBgPoint = nil
this.startBgPoint = 0
function this.OnBgRoller(go,isPress)
	this.pointType = "Bg"
	this._IsPress = isPress;
	this.startBgPoint = PlayerPrefs.GetInt("BgRoller")
	this.pressBgPoint = Input.mousePosition
	if(isPress == false) then
		PlayerPrefs.SetInt("BgRoller",SettingPanel.bgvolmn.transform.localPosition.x)
		this.initRollerPos()
	end
end

this.startbg = 0
this.startbtn = 0
function this.initRollerPos()
	local btnvalue = PlayerPrefs.GetInt("BtnRoller")
	local bgvalue = PlayerPrefs.GetInt("BgRoller")
	if(btnvalue == 0) then
		btnvalue = 192
		PlayerPrefs.SetInt("BtnRoller",192)
		PlayerPrefs.SetFloat ("BtnVolmn", 1);
	end
	if(bgvalue == 0) then
		bgvalue = 192
		PlayerPrefs.SetInt("BgRoller",192)
		PlayerPrefs.SetFloat ("BgVolmn",1);
	end
	this.startbtn = btnvalue + 192 + 20
	SettingPanel.btnvolmn.transform.localPosition = Vector3(btnvalue, 83, 0);
	SettingPanel.btnprocess_UISprite.width = this.startbtn
	this.startbg = bgvalue + 192 + 20
	SettingPanel.bgvolmn.transform.localPosition = Vector3(bgvalue, -37, 0);
	SettingPanel.bgprocess_UISprite.width = this.startbg
end



function this.OnOut()
	SettingPanel.OutGame()
end

function this.Close()
	panelMgr:ClosePanel(CtrlNames.Setting);
end

return this