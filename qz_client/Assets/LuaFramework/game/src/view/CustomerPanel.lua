local global = require("global")
local transform;
CustomerPanel = {}
local this = CustomerPanel
local mt = this 
this.gameObject = nil 

function this.Awake(obj)
    this.gameObject = obj 
    transform = obj.transform
    this.InitPanel()
    global._view:changeLayerAll("Customer")
end 

function mt.InitPanel()
    this.close = transform:Find("Close").gameObject
    this.bg = transform:Find("BG/BG")
    this.phone = this.bg:Find("Phone")
    this.phone_label = this.phone:Find("NumberLabel"):GetComponent("UILabel")
    this.qq = this.bg:Find("QQ")
    this.qq_label = this.qq:Find("NumberLabel"):GetComponent("UILabel")
end 

function mt.UpdateInfo(phone,qq)
    this.phone_label.text = phone
    this.qq_label.text = qq 
end 
function mt.ClearView()
    global._view:clearFormulateUI("Customer")
end 

function mt.OnDestroy()
    this.ui.Close()
end 

return CustomerPanel