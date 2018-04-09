require "logic/ViewManager"
local global = require("global")
MailCtrl ={};
local this=MailCtrl;
local mt = this
-----------------------------常量--------------------------------
this.const = nil 
this.mail_amount = nil 
this.gameObject = nil 
this.transform = nil 
this.panel = nil 
this.LB = nil 
this.space = nil 
-----------------------------房间属性--------------------------------

-----------------------------传输数据--------------------------------

-----------------------------标志位--------------------------------

-----------------------------列表存储--------------------------------
this.readed_mail = nil --已读邮件
this.not_readed_mail = nil --未读邮件
this.mail_list = nil --邮件列表


--构建函数--
function mt.New()
	return this;
end
function mt.Awake()
	panelMgr:CreatePanel('Mail',this.OnCreate); 
end

function mt.OnCreate(obj)
    this.gameObject = obj;
    this.transform = obj.transform;
    this.MP = MailPanel
    this.panel = this.transform:GetComponent('UIPanel');
    this.LB = this.transform:GetComponent('LuaBehaviour');

    this.LB:AddClick(this.MP.close,this.OnClose)
    this.LB:AddClick(this.MP.allDelBtn,this.OnAllDel)

    UpdateBeat:Add(this.TimeEvent,this)
end 

function mt.Init(data,const)   
   global._view:showLoading()
   this.const = const
   this.MP = MailPanel
   this.mail_amount = #data  
   this.space = 95 
   this.ClearUpMail(data)
   this.RenderFuncMail()
   global._view:hideLoading()
end 
-------------------------------时间事件--------------------------------
function mt.TimeEvent()

end 
-------------------------------功能--------------------------------
function mt.ClearUpMail(data)--整理邮件
    -- dump(data)
    for k,v in pairs(data)do 
       
        if v.state <2 then --未读邮件
            if not this.not_readed_mail then
                this.not_readed_mail = {}
            end 
            table.insert(this.not_readed_mail,v)

        elseif v.state > 1 then --已读邮件
            if not this.readed_mail then
                this.readed_mail = {}
            end 
            table.insert(this.readed_mail,v)
        end 
    end 
end 

function mt.ClearUpMailBar()
    if not this.mail_list then 
        print("报错！！！！！没有邮件列表")
        return
    end 
   
    local space = this.space 
    local start_y = 95
    local len = 0  
    for k,v in pairs(this.mail_list)do 
        local data = {
            time = 0.3,
            from = v.go.transform.localPosition,
            to = v.go.transform.localPosition,    
        }
        data.to.y = start_y - space*len 
        this.TweenPositionAnima(v.go,data)
        len = len + 1
    end 
    local panel = this.MP.mailList:GetComponent("UIPanel")
    local sprite = this.MP.mailCollider:GetComponent('UISprite')
    local ad = sprite.height + panel.clipOffset.y
    local v_3 = this.MP.mailList.transform.localPosition
    local v_2 = this.panel.clipOffset
    if ad <300 and  panel.clipOffset.y<0 then   
        v_3.y = this.MP.mailList.localPosition.y - 95     
        local data ={
            time = 0.3,
            from =this.MP.mailList.localPosition,
            to = v_3 ,
        }       
        -- this.MP.mailList.localPosition= v_3
        this.TweenPositionAnima(this.MP.mailList.gameObject,data)
        v_2.y = panel.clipOffset.y + 95 
        panel.clipOffset = v_2
    end 
    local colliderH = space*len + 15 
    if colliderH >= 300 then 
        sprite.height = colliderH
    end 
end 
function mt.RenderFuncMail()--生成邮件条

    if not this.mail_amount or this.mail_amount<1 then 
        return
    end    
    local bundle = resMgr:LoadBundle("MailBar")
    local prefab = resMgr:LoadBundleAsset(bundle,"MailBar")
    local space = this.space
    -- local go = GameObject.Instantiate(prefab)
    local go = nil 
    local len = 0 
    if this.not_readed_mail then 
        for k,v in pairs(this.not_readed_mail)do
            go = GameObject.Instantiate(prefab)
            resMgr:addAltas(go.transform,"Mail")
            this.InitMailBar(go,v,len)
            len = len+1 
        end 
    end 
    if this.readed_mail then
        for k,v in pairs(this.readed_mail)do 
            go = GameObject.Instantiate(prefab)
            resMgr:addAltas(go.transform,"Mail")
            this.InitMailBar(go,v,len)
            len = len+1
        end 
    end  
   
    local colliderH = space*len + 15 
    local bar_sprite = this.MP.mailCollider:GetComponent('UISprite')
    if colliderH > 300 then 
        bar_sprite.height = colliderH 
    end 
    this.go = go 
end 

function mt.InitMailBar(go,data,len)
    local parent = this.MP.mailList
    local space = this.space
    -- local item = nil 
    local title = nil 
    local label = nil 
    -- local checkBtn = nil 
    local delBtn = nil 
    go.name = data.sno
    go.transform.parent = parent 
    go.transform.localScale = Vector3.one 
    go.transform.localPosition = Vector3(0,95-space*len,0)
    -- item = go.transform:Find("Item"):GetComponent("UISprite")
    if data.state == 0 then 
        -- item.spriteName = "youxiangtubiao2"
        this.ChangeMailBarItem(go,false)
    elseif data.state ==1 then 
        -- item.spriteName = "youxiangtubiao11"
        this.ChangeMailBarItem(go,true)
    end     
    title = go.transform:Find("Title"):GetComponent("UILabel")
    title.text = GameData.GetShortName(data.sender,15,15)
    label = go.transform:Find("Label"):GetComponent("UILabel")
    label.text = GameData.GetShortName(data.content,40,40)
    -- checkBtn = go.transform:Find("CheckBtn").gameObject
    this.LB:AddClick(go,this.OnCheck)
    delBtn = go.transform:Find("DelBtn").gameObject
    this.LB:AddClick(delBtn,this.OnDel)

    if not this.mail_list then 
        this.mail_list = {}
    end 
    local len = #this.mail_list
    this.mail_list[len+1]= {
        sno = data.sno,
        go = go 
    }
    -- this.mail_list[data.sno] = go     
end 
function mt.InitMailContent(data)
    this.MP.title_label.text = data.title
    this.MP.text_label.text = data.content
    local time = GameData.getTimeTableForNum(data.sendtime)
    this.MP.time_label.text = time.year.."."..time.month.."."..time.day
    -- this.MP.addresser_label.text ="发件人：".. GameData.GetShortName(data.sender,15,15)
    if data.state == this.const.MAIL_STATE_HAVE or
    data.state == this.const.MAIL_STATE_HERE then  -- 有附件
        this.MP.get_item:SetActive(true)
        this.MP.get_item_sprite.spriteName = ""--todo
        this.MP.get_item_label.text = ""--todo
        this.MP.backBtn_label = "领取"
        this.LB:AddClick(this.MP.backBtn,this.OnGetMailItem)
    elseif data.state == this.const.MAIL_STATE_RECE then -- 有附件已领取
        this.MP.backBtn_label = "返回"
        this.LB:AddClick(this.MP.backBtn,this.OnGoBack)
    else -- 无附件
        this.MP.get_item:SetActive(false)
        this.MP.backBtn_label = "返回"
        this.LB:AddClick(this.MP.backBtn,this.OnGoBack)
    end
    --todo barcollider 
    local height = this.MP.text_label.height
    local sprite =  this.MP.textCollider:GetComponent("UISprite")
    if height >= 100 then 
       
        sprite.height = 280 + height - 100 
    else 
        sprite.height = 280
    end 

end 
function mt.ChangeMailBarItem(go,readed)
    local sprite = go.transform:Find("Item"):GetComponent("UISprite") or nil 
    if not sprite then 
        print("要更换Item的物体错误！！")
        return
    end 
    local delBtn = go.transform:Find("DelBtn").gameObject
    if readed then 
        sprite.spriteName = "youxiangtubiao11"
        delBtn:SetActive(true)
    else 
        sprite.spriteName = "youxiangtubiao2"
        delBtn:SetActive(false)
    end 
end 
-------------------------------点击事件--------------------------------
function mt.OnCheck(go) 
    -- local sno = go.transform.parent.name+0
    local sno = go.transform.name +0
    local data = {
        sno = sno 
    }
    this.MP.ReadMail(data)
end 
function mt.OnDel(go)
    local str = "是否删除该邮件？"
    local sno = go.transform.parent.name + 0 
    local support=global._view:support();
    support.Awake(str,function()
        this.MP.RemoveMail(sno)
    end,function()
    end )   
end 
function mt.OnGetMailItem(data)
    --todo
end 
function mt.OnGoBack()
    local data = {
        time = 0.15,
        from = Vector3.one,
        to = Vector3.zero
    }
    this.MP.mail_1:SetActive(true)
    this.TweenScaleAnima(this.MP.mail_2,data)
    data.from = 0
    data.to = 1
    this.TweenAlphaAnima(this.MP.mail_1,data)

end 
function mt.OnAllDel()
    local str= "是否删除所有已读的邮件？"
    local support = global._view:support();
    support.Awake(str,function()
        this.MP.OneKeyRemoveMail()
    end,function()
    end)

end 
function mt.OnClose(go)
    this.MP.ClearView()
end 
-------------------------------回调事件--------------------------------
function mt.ReadMailCallBack(info)
    if not this.mail_list then 
        print ("报错！！！！没有邮件列表")
        return
    end 
    local data = {
        time = 0.15,
        from = Vector3(0,0,0),
        to = Vector3.one ,
    }
    --更换已读和未读的存储位置 todo
    this.MP.mail_1:SetActive(false)
    this.MP.mail_2:SetActive(true)
    this.InitMailContent(info)
    this.TweenScaleAnima(this.MP.mail_2,data)
    -- local go = this.mail_list[info.sno] or nil
    local go = nil  
    for k,v in pairs (this.mail_list)do 
        if v.sno == info.sno then 
            go = v.go 
            break
        end 
    end
    if not go then 
        print ("报错！！！！邮件列表内没有该邮件")
        return
    end 
    this.ChangeMailBarItem(go,true)
end 
function mt.RemoveMailCallBack(sno)
    if this.mail_list  then 
        -- local go = this.mail_list[sno]
        local go = nil  
        local id = nil 
        for k,v in pairs (this.mail_list)do 
            if v.sno == sno then 
                go = v.go 
                id = k 
                break
            end 
        end
        if not go then 
            print ("报错！！！！邮件列表内没有该邮件")
            return
        end
        local data={
            time = 0.2,
            from = go.transform.localPosition,
            to = go.transform.localPosition
        }
        data.to.x = data.to.x + 850
        this.TweenPositionAnima(go,data,function()            
            table.remove(this.mail_list,id)
            panelMgr:ClearPrefab(go)      
            this.ClearUpMailBar()      
        end)
        
    else 
        print ("报错！！！！没有对应邮件")
    end 
end 

function mt.DelAllMailCallBack()
    if not this.mail_list then 
        return
    end
    local panel = this.MP.mailList:GetComponent("UIPanel")
    local sprite = this.MP.mailCollider:GetComponent('UISprite')
    local v_3 = this.MP.mailList.transform.localPosition
    -- local v_2 = this.panel.clipOffset
    local nu = math.floor((v_3.y)/95)
    local remove_list = {}
    for k,v in pairs(this.mail_list)do
        if not v.go then 
            print("报错！！！！没有对应物体") 
            return
        end 
        if k>=nu+1 and k<=nu+4 then 
            remove_list[k] = {}
            remove_list[k].go = v.go
        else  
            panelMgr:ClearPrefab(v.go)
        end 
    end 
    for k,v in pairs(remove_list)do 
        local data = {
            time = 0.2,
            from = v.go.transform.localPosition,
            to = v.go.transform.localPosition, 
            delay = 0.04 ,
        }
        data.to.x = data.to.x + 850
        data.delay = (k-(nu+1))*data.delay
        this.TweenPositionAnima(v.go,data,function()            
            if k == nu+4 then
                panel.clipOffset = Vector2(0,0)
                this.MP.mailList.localPosition = Vector3.zero
                -- sprite.height = 300
                this.readed_mail = nil 
                this.not_readed_mail = nil 
                this.mail_list = nil 
                this.MP.GetMaliData()
            end 
            panelMgr:ClearPrefab(v.go)
        end)
    end 
    this.mail_list = nil 
    
end 
-------------------------------动画控制--------------------------------
function mt.TweenScaleAnima(go,data)
    local t = go:GetComponent("TweenScale")
    t.duration = data.time
    t.from = data.from
    t.to = data.to
    if data.delay then 
        t.delay = data.delay
    end 
    t:ResetToBeginning()
    t.enabled = true 
end 
function mt.TweenAlphaAnima(go,data)
    local t = go:GetComponent("TweenAlpha")
    t.duration = data.time
    t.from = data.from
    t.to = data.to
    if data.delay then 
        t.delay = data.delay
    end 
    t:ResetToBeginning()
    t.enabled = true 
end 
function mt.TweenPositionAnima(go,data,cb)
    local tp = go:GetComponent("TweenPosition")
    tp.duration = data.time
    tp.from = data.from
    tp.to = data.to
    if data.delay then 
        tp.delay = data.delay
    end 
    tp:ResetToBeginning()
    tp.enabled = true 
    if cb then 
        resMgr:TweenPosEventDeleate(tp,function()
            cb()        
        end )
    end 
end 
-------------------------------关闭------------------------------------
function mt.Close()
    this.readed_mail = nil 
    this.not_readed_mail = nil 
    this.mail_list = nil 


    UpdateBeat:Remove(this.TimeEvent,this)
    panelMgr:ClosePanel(CtrlNames.Mail)
end 

return this
    