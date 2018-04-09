--
-- Author: wangshaopei
-- Date: 2017-08-07 11:13:10
--
require "logic/ViewManager"
local global = require("global")
local player = global.player
local const = global.const
local mgr_bank = global.player:get_mgr("bank")
PeopleCtrl = {};
local this = PeopleCtrl;

--构建函数--
function this.New()
	return this;
end

function this.Awake()
	panelMgr:CreatePanel('People', this.OnCreate);
end

PeopleCtrl.uiType = 1 -- 1.转账2.充值3.记录
--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	-- this.panel = this.transform:GetComponent('UIPanel');
	this.uiType = 1
	this.beh= this.transform:GetComponent('LuaBehaviour');

	this.beh:AddClick(PeoplePanel.Container, this.OnClick);
	this.beh:AddClick(PeoplePanel.btn, this.OnClickOK);
	this.beh:AddClick(PeoplePanel.gold, this.OnClickGold);
	this.beh:AddClick(PeoplePanel.silver, this.OnClickSilver);
	this.beh:AddClick(PeoplePanel.roomNum, this.OnClickRoom);
	this.beh:AddClick(PeoplePanel.account, this.OnAccount);
	this.beh:AddClick(PeoplePanel.record, this.OnRecord);
	this.coin_type = 1
	this.update_data()
	this.update_coin_type(this.coin_type)
end

PeopleCtrl.clientIp = ""
function this.getIpAddress(ip)
	if(this.clientIp == "") then
		this.clientIp = ip
	end
end

function this.changeUI()
	PeoplePanel.transfer:SetActive(false)
	PeoplePanel.deal:SetActive(false)
	if(this.uiType == 1) then
		PeoplePanel.transfer:SetActive(true)
	elseif(this.uiType == 3) then
		PeoplePanel.deal:SetActive(true)
	end
end

PeopleCtrl._recordList = {}
function this.renderFunc (list)
	if(this.uiType ~= 3) then
		return
	end
	this.clearRecord()
    local parent = PeoplePanel.recordlist.transform;
    local bundle = resMgr:LoadBundle("recordBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"recordBar");
    local space = 54;
    local len = #list;
	for i = 1, len do
		local data = list[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "recordBar"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0, 152 - space*(i - 1), 0);
		resMgr:addAltas(go.transform,"Bank")
		local toPlayId = data.role_id
		local txt = "转入"
		-- local send = toPlayId
		if(PeoplePanel.getPlayerId() == toPlayId) then
			txt = "转出"
			-- send = PeoplePanel.getPlayerId()
		end
		local date = go.transform:Find('date');
		local time = GameData.getTimeTableForNum(data.log_time)
		date:GetComponent('UILabel').text = time.month.."-"..time.day .." " .. time.hour..":" ..GameData.changeFoLimitTime (time.min);
		local mt = "银币"
		if(data.coin_type == 1) then
			mt = "金币"
		elseif(data.coin_type == 2) then
			mt = "房卡"
		end
		local moneytype = go.transform:Find('moneytype');
		moneytype:GetComponent('UILabel').text = mt;
		local state = go.transform:Find('state');
		state:GetComponent('UILabel').text = txt;
		local money = go.transform:Find('money');
		money:GetComponent('UILabel').text = data.amount;
		local sendPeople = go.transform:Find('sendPeople');
		sendPeople:GetComponent('UILabel').text = GameData.GetShortName(data.role_name,7,7) .. "\n"..toPlayId;
		local revicePeople = go.transform:Find('revicePeople');
		revicePeople:GetComponent('UILabel').text = GameData.GetShortName(data.to_name,7,7) .. "\n"..data.to_playerid;
		table.insert(this._recordList,go)
	end
	local colliderH = space * len
	if(colliderH > 360) then
		PeoplePanel.BarCollider_UISprite.height = colliderH
	else
		PeoplePanel.BarCollider_UISprite.height = 358
	end
end

function this.clearRecord()
	local len = #this._recordList;
	for i=1,len do
		local data = this._recordList[i]
		if(data ~= nil) then
			panelMgr:ClearPrefab(data);
		end
	end
	this._recordList = {}
end

function this.Close()
	this.clearRecord()
	panelMgr:ClosePanel(CtrlNames.People);
end

--功能函数
function this.update_data()
	-- PeoplePanel.lab_gold.text = player:get_RMB()
	-- PeoplePanel.lab_silver.text = player:get_money()
	PeoplePanel.input_money.value = 0

	-- local parent = DealerPanel.dealer_list;
 --    local bundle = resMgr:LoadBundle("DealerBar");
 --    local Prefab = resMgr:LoadBundleAsset(bundle,"DealerBar");
 --    -- local altas = resMgr:LoadUrlAssetAltas("GameLobby");
 --    -- local altObj = GameObject.Instantiate(altasPrefab);
 --    -- local altas = altObj:GetComponent("UIAtlas");

 --    local len = 10;
	-- for i = 1, len do
	-- 	local go = GameObject.Instantiate(Prefab)
	-- 	if i == 1 then
	-- 		local bc = go:GetComponent("BoxCollider")
	-- 		width = bc.size.x
	-- 		height = bc.size.y
	-- 	end

	-- 	go.name = "DealerBar"..i;
	-- 	go.transform.parent = parent;
	-- 	go.transform.localScale = Vector3.one;
	-- 	go.transform.localPosition = Vector3(0,  height/2*(i - 1), 0)
		-- this.lobby:AddClick(go, this.OnItemClick);
		-- local goo = go.transform:Find('iconLobby');
		-- goo:GetComponent('UISprite').atlas = altas;
		-- goo:GetComponent('UISprite').spriteName = list[i];
	-- end
	resMgr:InputEventDeleate(PeoplePanel.input_id,function()
		if(PeoplePanel.input_id.value == "") then
			return
		end
		PeoplePanel.IdToName(PeoplePanel.input_id.value)
	end)
end

function this.update_coin_type(Cointype)
	if Cointype == 0 then --银币
		PeoplePanel.choice.transform.localPosition = Vector3(118,  160, 0)
	elseif(Cointype == 1) then --金币
		PeoplePanel.choice.transform.localPosition = Vector3(-80,  160, 0)
	else
		PeoplePanel.choice.transform.localPosition = Vector3(318,  160, 0)
	end
end

function this.updateBtnState()
	PeoplePanel.account_UISprite.spriteName = "anjian_1"
	PeoplePanel.record_UISprite.spriteName = "anjian_1"
	PeoplePanel.accountImg_UISprite.spriteName = "zi_1"
	PeoplePanel.recordImg_UISprite.spriteName = "zi_5"
	this.changeUI()
end

function this.OnAccount()
	this.uiType = 1
	this.updateBtnState()
	PeoplePanel.account_UISprite.spriteName = "anjian"
	PeoplePanel.accountImg_UISprite.spriteName = "zi"
end

function this.OnRecord()
	this.uiType = 3
	this.updateBtnState()
	PeoplePanel.record_UISprite.spriteName = "anjian"
	PeoplePanel.recordImg_UISprite.spriteName = "zi_4"
	PeoplePanel.getBankDeal()
end

function this.OnClick()
	PeoplePanel.clearView()
end

function this.OnClickOK()
	local coin = tonumber(PeoplePanel.input_money.value) or 0
	local playerid = tonumber(PeoplePanel.input_id.value) or 0
	if playerid == 0 or coin == 0  or not this.coin_type then
		return
	end
	global._view:support().Awake("您确定要堆人气？",function ()
       		mgr_bank:req("req_transfer",playerid,coin,this.coin_type)
	   end,function ()

   	end);
end

function this.OnClickGold()
	this.coin_type = 1
	this.update_coin_type(this.coin_type)
end

function this.OnClickSilver()
	this.coin_type = 0
	this.update_coin_type(this.coin_type)
end

function this.OnClickRoom()
	this.coin_type = 2
	this.update_coin_type(this.coin_type)
end

return this