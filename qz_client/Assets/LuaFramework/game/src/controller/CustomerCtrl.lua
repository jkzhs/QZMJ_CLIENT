require "logic/ViewManager"
local global = require("global")
Customer = {}
local this = Customer
local mt = this
local panel = nil  

local PHONE = "0592-6836555"
local QQ = "646703801"

--构建函数--
function this.New()
	return this;
end

function mt.Awake()
    panelMgr:CreatePanel("Customer",this.OnCreate)
end 

function mt.OnCreate(obj)
    this.gameObject = obj
    this.transform = obj.transform
    this.LB = this.transform:GetComponent('LuaBehaviour')
    panel = CustomerPanel

    this.RenderFunc()

    this.LB:AddClick(panel.close,this.OnClose)
end 

function mt.RenderFunc()
    panel.UpdateInfo(PHONE,QQ)
end 

function mt.OnClose()
    panel.ClearView()
end 

function mt.Close()
    panelMgr:ClosePanel(CtrlNames.Customer)
end 

return Customer