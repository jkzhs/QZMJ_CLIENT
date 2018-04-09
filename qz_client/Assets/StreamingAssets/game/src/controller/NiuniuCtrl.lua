require "logic/ViewManager"
local global = require("global")
local const = global.const
NiuniuCtrl = {};
local this = NiuniuCtrl;

NiuniuCtrl.panel = nil;
NiuniuCtrl.Niuniu = nil;
NiuniuCtrl.transform = nil;
NiuniuCtrl.gameObject = nil;
NiuniuCtrl.gameID=nil;
--构建函数--
function NiuniuCtrl.New()
	return this;
end

function NiuniuCtrl.Awake(gameID)
	this.gameID=gameID;
	panelMgr:CreatePanel('Niuniu', this.OnCreate);
end

--启动事件--
function NiuniuCtrl.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.PlayBGSound()
	this.panel = this.transform:GetComponent('UIPanel');
	this.Niuniu = this.transform:GetComponent('LuaBehaviour');
	this.Niuniu:AddClick(NiuniuPanel.createRoom, this.OnCreateRoom);
	this.Niuniu:AddClick(NiuniuPanel.joinRoom, this.OnJoin);
	this.Niuniu:AddClick(NiuniuPanel.joinPublic, this.OnPublic);
	this.Niuniu:AddClick(NiuniuPanel.btnBack, this.OnBack);
	this.update_data()
	NiuniuPanel.joinEffect_Renderer.sortingOrder = 11
	NiuniuPanel.createEffect_Renderer.sortingOrder = 11
	NiuniuPanel.uplight1_Renderer.sortingOrder = 12
	NiuniuPanel.uplight2_Renderer.sortingOrder = 12
	NiuniuPanel.uplight3_Renderer.sortingOrder = 12

	NiuniuPanel.InitPanelTitle(this.gameID);
	NiuniuPanel.InitDayTwoOpen(this.gameID,function()	
		this.Niuniu:AddClick(NiuniuPanel.dayTwoOpen_Btn,this.DayOpenOnClick)
	end);


	
end

NiuniuCtrl._dialog = nil
function NiuniuCtrl.showShiShuiTip()
	if(this._dialog == nil) then
		local bundle = resMgr:LoadBundle("OptionDailog");
		local Prefab = resMgr:LoadBundleAsset(bundle,"OptionDailog");
		this._dialog = GameObject.Instantiate(Prefab);
		this._dialog.name = "OptionDailog1";
		this._dialog.transform.parent = NiuniuPanel.showDialog.transform;
		this._dialog.transform.localScale = Vector3.one;
		this._dialog.transform.localPosition = Vector3.zero;
		resMgr:addAltas(this._dialog.transform,"Niuniu")
		NiuniuPanel.showDialog_UIPanel.sortingOrder = 13
	else
		this._dialog:SetActive(true)
	end
	this.addTipEvent(this._dialog)
end

NiuniuCtrl._tag = 1
NiuniuCtrl._maxIndex = 1
NiuniuCtrl._robIndex = 1
function NiuniuCtrl.addTipEvent(go)
	local gouhead = go.transform:Find('gouhead').gameObject;
	local goumax = go.transform:Find('goumax').gameObject;
	local gourob = go.transform:Find('gourob').gameObject;
	local okBtn = go.transform:Find('okBtn').gameObject;
	local trasthead = go.transform:Find('contrast/trasthead').gameObject;
	local tmin = go.transform:Find('contrast/min').gameObject;
	local tmax = go.transform:Find('contrast/max').gameObject;
	local tInput = go.transform:Find('contrast/Input').gameObject;
	local tInput_UIInput = tInput:GetComponent('UIInput');
	local tInput_BoxCollider2D = tInput:GetComponent('BoxCollider2D');
	local tInput_UILabel = tInput:GetComponent('UILabel');
	local robhead = go.transform:Find('rob/robhead').gameObject;
	local rmax = go.transform:Find('rob/max').gameObject;
	local rmin = go.transform:Find('rob/min').gameObject;
	local rInput = go.transform:Find('rob/Input').gameObject;
	local rInput_UIInput = rInput:GetComponent('UIInput');
	local rInput_BoxCollider2D = rInput:GetComponent('BoxCollider2D');
	local rInput_UILabel = rInput:GetComponent('UILabel');
	local ten = go.transform:Find('rob/ten').gameObject;
	local two = go.transform:Find('rob/two').gameObject;
	local close = go.transform:Find('close').gameObject;
	this.Niuniu:AddClick(okBtn, function ()
		local value = 0
		if(this._tag == 1) then
			value = tonumber(tInput_UILabel.text)
		else
			value = tonumber(rInput_UILabel.text)
		end
		if(value > 0) then
			NiuniuPanel.openShiSanShui(this._tag,this._robIndex,this._maxIndex,value)
		else
			NiuniuPanel.setTip("请检测输入金额！")
		end
	end);
	this.Niuniu:AddClick(close, function ()
		this._dialog:SetActive(false)
	end);
	if(this._tag == 1) then
		rInput_BoxCollider2D.enabled = false
		tInput_BoxCollider2D.enabled = true
	else
		rInput_BoxCollider2D.enabled = true
		tInput_BoxCollider2D.enabled = false
	end
	this.Niuniu:AddClick(trasthead, function ()
		this._tag = 1
		this._maxIndex = 1
		this._robIndex = 1
		gourob:SetActive(false)
		local v = trasthead.transform.localPosition
		gouhead.transform.localPosition = Vector3(v.x,v.y,0)
		local tv = tmin.transform.localPosition
		goumax.transform.localPosition = Vector3(tv.x,tv.y,0)
		rInput_BoxCollider2D.enabled = false
		tInput_BoxCollider2D.enabled = true
		rInput_UILabel.text = 0
		rInput_UIInput.value = 0
	end);
	this.Niuniu:AddClick(robhead, function ()
		this._tag = 2
		this._maxIndex = 1
		this._robIndex = 1
		local v = robhead.transform.localPosition
		gouhead.transform.localPosition = Vector3(v.x + 295,v.y,0)
		local rv = rmin.transform.localPosition
		goumax.transform.localPosition = Vector3(rv.x + 295,rv.y,0)
		gourob:SetActive(true)
		local tv = ten.transform.localPosition
		gourob.transform.localPosition = Vector3(tv.x + 295,tv.y,0)
		tInput_BoxCollider2D.enabled = false
		rInput_BoxCollider2D.enabled = true
		tInput_UILabel.text = 0
		tInput_UIInput.value = 0
	end);
	resMgr:InputEventDeleate(tInput_UIInput,function()
		if(this._tag == 1) then
			tInput_UILabel.text = tInput_UIInput.value
		end	
	end)
	this.Niuniu:AddClick(tmin, function ()
		if(this._tag == 1) then
			this._maxIndex = 1
			local tv = tmin.transform.localPosition
			goumax.transform.localPosition = Vector3(tv.x,tv.y,0)
		end
	end);
	this.Niuniu:AddClick(tmax, function ()
		if(this._tag == 1) then
			this._maxIndex = 2
			local tv = tmax.transform.localPosition
			goumax.transform.localPosition = Vector3(tv.x,tv.y,0)
		end
	end);
	this.Niuniu:AddClick(rmax, function ()
		if(this._tag == 2) then
			this._maxIndex = 2
			local rv = rmax.transform.localPosition
			goumax.transform.localPosition = Vector3(rv.x + 295,rv.y,0)
		end
	end);
	this.Niuniu:AddClick(rmin, function ()
		if(this._tag == 2) then
			this._maxIndex = 1
			local rv = rmin.transform.localPosition
			goumax.transform.localPosition = Vector3(rv.x + 295,rv.y,0)
		end
	end);
	resMgr:InputEventDeleate(rInput_UIInput,function()
		if(this._tag == 2) then
			rInput_UILabel.text = rInput_UIInput.value
		end	
	end)
	this.Niuniu:AddClick(ten, function ()
		if(this._tag == 2) then
			this._robIndex = 1
			local tv = ten.transform.localPosition
			gourob.transform.localPosition = Vector3(tv.x + 295,tv.y,0)
		end
	end);
	this.Niuniu:AddClick(two, function ()
		if(this._tag == 2) then
			this._robIndex = 2
			local tv = two.transform.localPosition
			gourob.transform.localPosition = Vector3(tv.x + 295,tv.y,0)
		end
	end);
end

function NiuniuCtrl.update_data( ... )
	NiuniuPanel.diamondTxt.text = NiuniuPanel.get_RMB()
	NiuniuPanel.coinTxt.text = NiuniuPanel.get_money()
	NiuniuPanel.playerIcon_AsyncImageDownload:SetAsyncImage(NiuniuPanel.getHeadUrl())
end

NiuniuCtrl.roomId = ""
function NiuniuCtrl.OnCreateRoom(go)
	NiuniuPanel.openGame(this.gameID)
end

function NiuniuCtrl.OnJoin(go)
	NiuniuPanel.JoinRoom(this.gameID)
end

function NiuniuCtrl.OnPublic()
	if this.gameID == const.GAME_ID_WATER then
		NiuniuPanel.SanshuiGameScore(this.gameID)
	else
		NiuniuPanel.gameScore(this.gameID)
	end
end

function NiuniuCtrl.OnBack(go)
	NiuniuPanel.backLobby()
end

function this.DayOpenOnClick(go)
	NiuniuPanel.DayOpenOnClick(this.gameID)
end

function this.PlayBGSound()
	-- if this.gameID == const.GAME_ID_12ZHI then
	-- 	soundMgr:PlayBackSound("shierzhi_music") 
	-- elseif this.gameID == const.GAME_ID_NIUNIU then		
	-- 	soundMgr:PlayBackSound("niuniu_music")
	-- elseif this.gameID == const.GAME_ID_PAIGOW then
	-- 	soundMgr:PlayBackSound("paigo_music")
	-- elseif this.gameID == const.GAME_ID_YAOLEZI then
	-- 	soundMgr:PlayBackSound("yaolezi_music")
	-- elseif this.gameID == const.GAME_ID_WATER then
	-- elseif this.gameID == const.GAME_ID_MJ then
	-- end 
	NiuniuPanel.PlayBGSound(this.gameID)
end 
--关闭事件--
function NiuniuCtrl.Close()
	if(this._dialog ~= nil) then
		panelMgr:ClearPrefab(this._dialog);
		this._dialog = nil
	end
	this._tag = 1
	this.gameID=nil;
	panelMgr:ClosePanel(CtrlNames.Niuniu);
end

return NiuniuCtrl