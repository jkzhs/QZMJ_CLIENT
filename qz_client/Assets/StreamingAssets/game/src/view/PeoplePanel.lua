--
-- Author: wangshaopei
-- Date: 2017-08-07 11:14:53
--
local global = require("global")
local transform;
PeoplePanel = {};
local this = PeoplePanel;
PeoplePanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("People")--必加
end

--初始化面板--
function this.InitPanel()
	this.Container = transform:Find("Container").gameObject
	this.account = transform:Find("account").gameObject
	this.account_UISprite = this.account:GetComponent('UISprite');
	this.record = transform:Find("record").gameObject
	this.record_UISprite = this.record:GetComponent('UISprite');
	-- transfer 
	this.transfer = transform:Find("transfer").gameObject
	this.btn = transform:Find("transfer/btn").gameObject
	this.input_money = transform:Find("transfer/input_money/input"):GetComponent('UIInput')
	this.input_id = transform:Find("transfer/input_id/input"):GetComponent('UIInput')
	this.gold = transform:Find("transfer/gold").gameObject
	this.silver = transform:Find("transfer/silver").gameObject
	this.roomNum = transform:Find("transfer/roomNum").gameObject
	this.choice = transform:Find("transfer/choice").gameObject  
	this.accountImg = transform:Find("account/accountImg").gameObject
	this.accountImg_UISprite = this.accountImg:GetComponent('UISprite');
	this.recordImg = transform:Find("record/recordImg").gameObject
	this.recordImg_UISprite = this.recordImg:GetComponent('UISprite');
	this.playername = transform:Find("transfer/playername").gameObject
	this.playername_UILabel = this.playername:GetComponent('UILabel');
	-- deal 
	this.deal = transform:Find("deal").gameObject
	this.recordlist = transform:Find("deal/recordlist").gameObject 
	this.BarCollider = transform:Find("deal/recordlist/BarCollider").gameObject
	this.BarCollider_UISprite = this.BarCollider:GetComponent('UISprite');
end

function this.IdToName(id)
	global.player:req_query_name(id,function (name)
		if(this.ui ~= nil) then
			if(name ~= "") then
				this.playername_UILabel.text = name
			else
				global._view:getViewBase("Tip").setTip("Id错误")
			end
		end
	end)
end

function this.getTime()
	return global.ts_now;
end

function this.getPlayerId()
	return global.player:get_playerid()
end

function this.getBankDeal()
	global.player:req_query_transfer(this.getPlayerId(),nil,nil,function (list)
		if(this.ui ~= nil) then
			this.ui.renderFunc(list)
		end
	end)
end

function this.OnDestroy()
	this.ui.Close()
end

function this.update_data()
	if(this.ui ~= nil) then
		this.ui.update_data()
	end
end

function this.clearView()
	global._view:clearFormulateUI("People")
end

return PeoplePanel