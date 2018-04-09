local global = require("global")
local transform;
-- local mgr_room = global.player:get_mgr("room")
local mgr_mail= global.player:get_mgr("mail")
local const = global.const
MailPanel = {};
local this = MailPanel;
local mt = this

----------------------初始化---------------------------------
function mt.Awake(obj)
    this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel(); 
    global._view:changeLayerAll("Mail")
    -- mgr_mail:nw_reg();--后面加上
    this.GetMaliData()
end
function mt.InitPanel()
    ------------------------MailPanel-------------------------
    this.close = transform:Find("close").gameObject
    ------------------------Mail_1---------------------------
    this.mail_1 = transform:Find("Mail_1").gameObject
    this.centerBG = this.mail_1.transform:Find("CenterBG")
    this.centerBG = this.mail_1.transform:Find("CenterBG")
    this.mailList = this.centerBG:Find("BG/MailList")
    this.mailCollider = this.mailList:Find("BarCollider").gameObject
    this.allDelBtn = this.centerBG:Find("AllDelBtn").gameObject
    this.allGainBtn = this.centerBG:Find("AllGainBtn").gameObject
    ------------------------Mail_2---------------------------
    this.mail_2 = transform:Find("Mail_2").gameObject
    this.textList = this.mail_2.transform:Find("BG/TextList")
    this.textCollider = this.textList:Find("BarCollider").gameObject
    this.title_label = this.textList:Find("TitleLabel"):GetComponent("UILabel")
    this.text_label =  this.textList:Find("Label"):GetComponent("UILabel")
    this.time_label =  this.textList:Find("TimeLabel"):GetComponent("UILabel")
    this.addresser_label =  this.textList:Find("Addresser"):GetComponent("UILabel")
    this.backBtn = this.mail_2.transform:Find("BackBtn").gameObject
    this.backBtn_label = this.backBtn.transform:Find("Label"):GetComponent("UILabel")
    this.get_item = this.textList:Find("GetItem").gameObject
    this.get_item_sprite = this.get_item.transform:Find("BG/Sprite"):GetComponent("UISprite")
    this.get_item_label = this.get_item.transform:Find("Label"):GetComponent("UILabel")

    
end 
----------------------获取数据---------------------------------
function mt.GetMaliData()
    global._view:showLoading()
    mgr_mail:mail_load(function(data)
        global._view:hideLoading()
        if this.ui~= nil then 
            this.ui.Init(data,const)
        end 
    end )
end 

function mt.ReadMail(data)
    global._view:showLoading()
    mgr_mail:mail_read(data,function(info)
        global._view:hideLoading()
        if this.ui~= nil then 
            this.ui.ReadMailCallBack(info)
        end 
    end )
end 

function mt.RemoveMail(sno)
    global._view:showLoading()
    mgr_mail:remove_mail(sno,function(value)
        global._view:hideLoading()
        if value then 
            if this.ui ~=nil then 
                this.ui.RemoveMailCallBack(sno)
            end
        else
            this.SetTip("删除失败")
        end           
    end )
end 
function mt.OneKeyRemoveMail()
    global._view:showLoading()
    mgr_mail:one_key_remove_mail(function(value,...)
        global._view:hideLoading()
        if value then 
            if this.ui~=nil then
                this.ui.DelAllMailCallBack()
            end
        else 
        end  
    end )
end 
----------------------功能---------------------------------
function mt.SetTip(text)
    global._view:getViewBase("Tip").setTip(text)
end 
----------------------关闭---------------------------------
function mt.ClearView()
	global._view:clearFormulateUI("Mail")
end
----------------------销毁---------------------------------
function mt.OnDestroy()
    global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
	-- mgr_yaolezi:nw_unreg();
end
return this