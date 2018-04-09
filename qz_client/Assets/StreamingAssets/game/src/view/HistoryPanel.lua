require "logic/ViewManager"
local global = require("global")
local transform;
HistoryPanel = {}
local this = HistoryPanel
local mt = this
this.gameObject = nil;

--启动事件--
function mt.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("History")--必加
end

function mt.InitPanel()
	this.closeBtn = transform:Find("Close").gameObject
	this.title_label = transform:Find("TitleLabel"):GetComponent("UILabel")
	this.time = transform:Find("Time")
	this.time_label = this.time:Find("Label"):GetComponent("UILabel")
	this.item_list = transform:Find("Item_List")
	this.barcollider = this.item_list:Find("BarCollider")
	-- this.barcollider_sprite = this.barcollider:GetComponent("UISprite")

end 
----------------跟新界面-------------
function mt.SetTitle(text)
	this.title_label.text = text
end 

function mt.SetTime(value) -- 时间搓
	local time = GameData.getTimeTableForNum(value)
	local str = "%s / %s / %s"
	local text = string.format(str,time.year,time.month,time.day)
	this.time_label = text
end 
-------------------------------------------

function mt.clearView()
	global._view:clearFormulateUI("History")
end

function mt.OnDestroy()
	this.ui.Close()
end

return HistoryPanel