local global = require("global")
local transform;
local mgr_room = global.player:get_mgr("room")
local mgr_mj= global.player:get_mgr("mj")
local const = global.const
MaJiangPanel = {};
local this = MaJiangPanel;
local mt = this

local TWO_PLAYER = 2 
local THREE_PLAYER = 3 
local FOUR_PLAYER = 4 

local CARDS_AMOUNT = 144

--吃碰胡杠的操作ID
local CPHG_TYPE_ANGANG  = 1
local CPHG_TYPE_GANG    = 2
local CPHG_TYPE_PENG    = 3
local CPHG_TYPE_CHI     = 4
local CPHG_TYPE_HU      = 5
local CPHG_TYPE_PASS    = 6
local CPHG_TYPE_BUGANG  = 7
local CPHG_TYPE_YOUJING = 8


-------------------------标志位------------------------------
-- this.IsClickBack = false
this.is_back = false
----------------------初始化---------------------------------
function mt.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel(); 
	global._view:changeLayerAll("MaJiang")
	mgr_mj:nw_reg();--后面加上
	this.GetPlayerData()
end
function mt.InitPanel()
    global._view:PlayBGSound(const.GAME_ID_MJ)
    ----------------functionBtn-----------------------
    this.functionBtn = transform:Find("FunctionBtn")
    this.backBtn = this.functionBtn:Find("BackBtn").gameObject
    this.helpBtn = this.functionBtn:Find("HelpBtn").gameObject
    this.menuBtn = this.functionBtn:Find("MenuBtn").gameObject
    this.menu_di = this.menuBtn.transform:Find("backBtn")
    this.menu_di_sprite = this.menu_di:GetComponent("UISprite")
    this.menu_sprite = this.menu_di:Find("Sprite"):GetComponent("UISprite")
    this.chatBtn = this.functionBtn:Find("ChatBtn").gameObject
    this.voiceBtn = this.functionBtn:Find("VoiceBtn").gameObject
    this.viedo_VoiceChatPlayer = this.voiceBtn:GetComponent("VoiceChatPlayer")
    this.returnBtn = this.functionBtn:Find("ReturnBtn").gameObject
    this.return_di = this.returnBtn.transform:Find("backBtn")
    this.return_di_sprite = this.return_di:GetComponent("UISprite")
    this.return_sprite = this.return_di:Find("Sprite"):GetComponent("UISprite")
    this.btnGroup = this.functionBtn:Find("BtnList/BtnGroup")    
    this.entrustBtn = this.btnGroup:Find("EntrustBtn").gameObject
    this.setBtn = this.btnGroup:Find("SetBtn").gameObject
    this.BankBtn = this.btnGroup:Find("BankBtn").gameObject
    this.inviteBtn = this.btnGroup:Find("InviteBtn").gameObject
    
    this.playBtnList = this.functionBtn:Find("PlayBtnList")
    this.passBtn = this.playBtnList:Find("PassBtn").gameObject
    
    this.play_btn_1 = this.playBtnList:Find("Btn_1").gameObject
    this.play_btn_2 = this.playBtnList:Find("Btn_2").gameObject
    this.play_btn_3 = this.playBtnList:Find("Btn_3").gameObject
    this.play_btn_4 = this.playBtnList:Find("Btn_4").gameObject

    this.prepare_btn = this.functionBtn:Find("PrepareBtn").gameObject
    this.prepare_label = this.prepare_btn.transform:Find("Label"):GetComponent("UILabel")
    ----------------PlayerCards-----------------------
    this.playerCards = transform:Find("PlayerCards")
    this.cardList_1 = this.playerCards:Find("CardList_1")
    this.cardList_2 = this.playerCards:Find("CardList_2")
    this.cardList_3 = this.playerCards:Find("CardList_3")
    this.cardList_4 = this.playerCards:Find("CardList_4")
    ----------------OutCards-----------------------
    this.outCards = transform:Find("OutCards")
    this.out_four_player = this.outCards:Find("Four_Player")
    this.out_three_player = this.outCards:Find("Three_Player")
    this.out_two_player = this.outCards:Find("Two_Player")
    ----------------PenCards-----------------------
    this.penCards = transform:Find("PenCards")
    this.penList_1 = this.penCards:Find("PenList_1")
    this.penList_2 = this.penCards:Find("PenList_2")
    this.penList_3 = this.penCards:Find("PenList_3")
    this.penList_4 = this.penCards:Find("PenList_4")
    ----------------FlowerCards-----------------------
    this.flowerCards = transform:Find("FlowerCards")
    this.flowerList_1 = this.flowerCards:Find("FlowerList_1")
    this.flowerList_2 = this.flowerCards:Find("FlowerList_2")
    this.flowerList_3 = this.flowerCards:Find("FlowerList_3")
    this.flowerList_4 = this.flowerCards:Find("FlowerList_4")
    ----------------Center-----------------------
    this.center = transform:Find("Center")
    this.point_to = this.center:Find("PoinTo")
    this.e_point = this.point_to:Find("E").gameObject
    this.w_point = this.point_to:Find("W").gameObject
    this.n_point = this.point_to:Find("N").gameObject
    this.s_point = this.point_to:Find("S").gameObject

    this.time = this.center:Find("Time")
    this.time_label = this.time:Find("Label"):GetComponent("UILabel")

    this.center_left = this.center:Find("LeftLabel")
    this.left_label = this.center_left:Find("Label"):GetComponent("UILabel")
    -- this.center_right = this.center:Find("RightLabel")
    -- this.bout_label = this.center_right:Find("BoutLabel"):GetComponent("UILabel")
    -- this.amount_label = this.center_right:Find("AmountLabel"):GetComponent("UILabel")

    ----------------TopLeft-----------------------
    this.topLeft = transform:Find("TopLeft")
    this.room_label =  this.topLeft:Find("RoomMessage/Label"):GetComponent("UILabel")
    this.jing = this.topLeft:Find("Jing").gameObject
    this.jing_sprite = this.jing.transform:Find("Sprite"):GetComponent("UISprite")
    
    ----------------HeadImage-----------------------
    this.head_image = transform:Find("HeadImage")

    this.head_1 = this.head_image:Find("Head_1")
    this.head_1_name = this.head_1:Find("NameLabel"):GetComponent("UILabel")
    this.head_1_obj = this.head_1:Find("Head").gameObject
    this.head_1_AsyncImageDownload = this.head_1:Find("Texture"):GetComponent("AsyncImageDownload")
    this.head_1_tuo = this.head_1:Find("Tuo").gameObject
    this.head_1_zhuang = this.head_1:Find("Zhuang").gameObject
    this.head_1_money_obj = this.head_1:Find("MoneyLabel").gameObject
    this.head_1_money_label = this.head_1:Find("MoneyLabel"):GetComponent("UILabel")
    this.head_1_prepare_obj = this.head_1:Find("PrepareLabel").gameObject

    this.head_2 = this.head_image:Find("Head_2")
    this.head_2_name = this.head_2:Find("NameLabel"):GetComponent("UILabel")
    this.head_2_obj = this.head_2:Find("Head").gameObject
    this.head_2_AsyncImageDownload = this.head_2:Find("Texture"):GetComponent("AsyncImageDownload")
    this.head_2_tuo = this.head_2:Find("Tuo").gameObject
    this.head_2_zhuang = this.head_2:Find("Zhuang").gameObject
    this.head_2_money_obj = this.head_2:Find("MoneyLabel").gameObject
    this.head_2_money_label = this.head_2:Find("MoneyLabel"):GetComponent("UILabel")
    this.head_2_prepare_obj = this.head_2:Find("PrepareLabel").gameObject

    this.head_3 = this.head_image:Find("Head_3")
    this.head_3_name = this.head_3:Find("NameLabel"):GetComponent("UILabel")
    this.head_3_obj = this.head_3:Find("Head").gameObject
    this.head_3_AsyncImageDownload = this.head_3:Find("Texture"):GetComponent("AsyncImageDownload")
    this.head_3_tuo = this.head_3:Find("Tuo").gameObject
    this.head_3_zhuang = this.head_3:Find("Zhuang").gameObject
    this.head_3_money_obj = this.head_3:Find("MoneyLabel").gameObject
    this.head_3_money_label = this.head_3:Find("MoneyLabel"):GetComponent("UILabel")
    this.head_3_prepare_obj = this.head_3:Find("PrepareLabel").gameObject

    this.head_4 = this.head_image:Find("Head_4")
    this.head_4_name = this.head_4:Find("NameLabel"):GetComponent("UILabel")
    this.head_4_obj = this.head_4:Find("Head").gameObject
    this.head_4_AsyncImageDownload = this.head_4:Find("Texture"):GetComponent("AsyncImageDownload")
    this.head_4_tuo = this.head_4:Find("Tuo").gameObject
    this.head_4_zhuang = this.head_4:Find("Zhuang").gameObject
    this.head_4_money_obj = this.head_4:Find("MoneyLabel").gameObject
    this.head_4_money_label = this.head_4:Find("MoneyLabel"):GetComponent("UILabel")
    this.head_4_prepare_obj = this.head_4:Find("PrepareLabel").gameObject

    -----------------ShowUI---------------------------------
    this.showUI = transform:Find("showUI")
    this.showCardPanel = this.showUI:Find("ShowCardPanel")
    this.showCardPanel_bg = this.showCardPanel:Find("BG")
    this.showCardPanel_lable = this.showCardPanel_bg:Find("Label"):GetComponent("UILabel")
    this.play_returnBtn = this.showCardPanel:Find("ReturnBtn").gameObject
    --骰子
    this.dicesPanel = this.showUI:Find("Dices").gameObject
    this.dices_anim = this.dicesPanel.transform:Find("Sprite").gameObject
    this.dices_anim_sprite = this.dices_anim:GetComponent("UISprite")
    this.dices_result = this.dicesPanel.transform:Find("ResultDices").gameObject
    this.dices_result_sprite_1 =this.dices_result.transform:Find("Sprite_1"):GetComponent("UISprite")
    this.dices_result_sprite_2 =this.dices_result.transform:Find("Sprite_2"):GetComponent("UISprite")
    this.dices_result_sprite_3 =this.dices_result.transform:Find("Sprite_3"):GetComponent("UISprite")
    --金
    this.gold_effect = this.showUI:Find("GoldEffect").gameObject   
    this.gold_eff_container = this.gold_effect.transform:Find("Container").gameObject
    --委托
    this.entrust = this.showUI:Find("Entrust").gameObject
    this.entrust_cancel_btn = this.entrust.transform:Find("DI_BG/Cancel_Btn").gameObject
    --结果
    this.result = this.showUI:Find("Result").gameObject
    this.title_sprite = this.result.transform:Find("TitleSprite"):GetComponent("UISprite")
    this.result_next_btn = this.result.transform:Find("NextBtn").gameObject
    this.result_next_label = this.result_next_btn.transform:Find("TimeLabel"):GetComponent("UILabel")
    this.result_back_btn = this.result.transform:Find("BackBtn").gameObject

    --特效
    this.cphg_effect = this.showUI:Find("CPHG_Effect").gameObject
    this.cphg_effect_sprite_obj = this.cphg_effect.transform:Find("Sprite").gameObject
    this.cphg_effect_UIsprite = this.cphg_effect_sprite_obj:GetComponent("UISprite")

    -- 对话信息
    this.saydialog = this.showUI.transform:Find("saydialog").gameObject
    this.saylist = this.saydialog.transform:Find("saylist").gameObject
    this.sayCollider = this.saylist.transform:Find("sayCollider").gameObject
    this.sayCollider_UISprite = this.sayCollider:GetComponent("UISprite")
    this.saydialog_close = this.saydialog.transform:Find("Close").gameObject


    this.record = transform:Find("showUI/record").gameObject;
	this.recordProcess = transform:Find("showUI/record/recordProcess").gameObject;
	this.recordProcess_UISprite = this.recordProcess:GetComponent('UISprite');
	this.recard1 = transform:Find("showUI/record/recordcard/recard1").gameObject;
	this.recard2 = transform:Find("showUI/record/recordcard/recard2").gameObject;
	this.recard3 = transform:Find("showUI/record/recordcard/recard3").gameObject;
	this.recard4 = transform:Find("showUI/record/recordcard/recard4").gameObject;

    --TIP
    this.tip = this.showUI.transform:Find("Tip").gameObject
    --------------------------------Chat_UI--------------------------------------
    this.chat_ui = transform:Find("Chat_UI")
    this.say_chat_1 = this.chat_ui:Find("Chat_1")
    this.say_collider_1 = this.say_chat_1:Find("Collider")
    this.say_collider_sprite_1 = this.say_collider_1:GetComponent("UISprite")
    -- this.say_UIScrollView_1 = this.say_chat_1:GetComponent("UIScrollView")
    this.say_chat_2 = this.chat_ui:Find("Chat_2")
    this.say_collider_2 = this.say_chat_2:Find("Collider")
    this.say_collider_sprite_2 = this.say_collider_2:GetComponent("UISprite")
    -- this.say_UIScrollView_2 = this.say_chat_2:GetComponent("UIScrollView")
    this.say_chat_3 = this.chat_ui:Find("Chat_3")
    this.say_collider_3 = this.say_chat_3:Find("Collider")
    this.say_collider_sprite_3 = this.say_collider_3:GetComponent("UISprite")
    -- this.say_UIScrollView_3 = this.say_chat_3:GetComponent("UIScrollView")
    this.say_chat_4 = this.chat_ui:Find("Chat_4")
    this.say_collider_4 = this.say_chat_4:Find("Collider")
    this.say_collider_sprite_4 = this.say_collider_4:GetComponent("UISprite")
    -- this.say_UIScrollView_4 = this.say_chat_4:GetComponent("UIScrollView")

    -- this.test_label = transform:Find("test_label"):GetComponent("UILabel")
end 

----------------------设置---------------------------------
function mt.SetOutPlayBox(play_type)
    if play_type == 4 then 
        this.outcards_1 = this.out_four_player:Find("OutCards_1")
        this.outcards_2 = this.out_four_player:Find("OutCards_2")
        this.outcards_3 = this.out_four_player:Find("OutCards_3")
        this.outcards_4 = this.out_four_player:Find("OutCards_4")
    elseif play_type == 3 then 
        this.outcards_1 = this.out_three_player:Find("OutCards_1")
        this.outcards_2 = this.out_three_player:Find("OutCards_2")
        this.outcards_3 = this.out_three_player:Find("OutCards_3")
    elseif play_type == 2 then 
        this.outcards_1 = this.out_two_player:Find("OutCards_1")
        this.outcards_3 = this.out_two_player:Find("OutCards_3")
    end 
end 
--设置头像显示个数
function mt.SetShowHead(play_type)
    if play_type == TWO_PLAYER then 
        this.head_1.gameObject:SetActive(true)
        this.head_2.gameObject:SetActive(false)
        this.head_3.gameObject:SetActive(true)
        this.head_4.gameObject:SetActive(false)
    elseif play_type == THREE_PLAYER then 
        this.head_1.gameObject:SetActive(true)
        this.head_2.gameObject:SetActive(true)
        this.head_3.gameObject:SetActive(true)
        this.head_4.gameObject:SetActive(false)
    elseif play_type == FOUR_PLAYER then 
        this.head_1.gameObject:SetActive(true)
        this.head_2.gameObject:SetActive(true)
        this.head_3.gameObject:SetActive(true)
        this.head_4.gameObject:SetActive(true)
    else
        print("MJPANEL:SetShowHead:error play_type!!!",play_type)
    end
end 
-- 设置出牌区的显示区域
function mt.SetPlayOutCardArea(play_type)
    this.out_four_player.gameObject:SetActive(false)
    this.out_three_player.gameObject:SetActive(false)
    this.out_two_player.gameObject:SetActive(false)
    if play_type == TWO_PLAYER then 
        this.out_two_player.gameObject:SetActive(true)
    elseif play_type == THREE_PLAYER then 
        this.out_three_player.gameObject:SetActive(true)
    elseif play_type == FOUR_PLAYER then 
        this.out_four_player.gameObject:SetActive(true)
    else
        print("MJPANEL:SetPlayOutCardArea:error play_type!!! ",play_type)
    end 
end 
----------------------功能---------------------------------
--更新牌组数值显示
function mt.UpateCardsAmount(count)
    if not count then 
        print ("MJPANEL:UpateCardsAmount:error not count!!!")
    end 
    this.left_label.text = count 
end 
-- 更新庄家头像信息
function mt.UpdateBankerHead(who,is_show)
    local head_data = this.GetHeadImage(who)
    head_data.zhaung:SetActive(is_show)
end 
function mt.ResetHead()
    local is_show = false
    for i =1 ,4 do         
        local head_data = this.GetHeadImage(i)
        head_data.zhaung:SetActive(is_show)
        head_data.tuo:SetActive(is_show)
        head_data.prepare_obj:SetActive(is_show)
    end 
    this.entrust:SetActive(is_show)
end 
-- 更新玩家头像委托标志
function mt.UpdateEntrust(who,is_show)
    local head_data =  this.GetHeadImage(who)
    head_data.tuo:SetActive(is_show)
    if who == 1 then 
        this.entrust:SetActive(is_show)
    end 
end 

-- 更新金牌图像
function mt.UpdateGoldImage(spriteName)
    if spriteName then 
        
        -- print("MJPANEL:UpdateGoldImage:NAME:",spriteName)
        this.jing_sprite.spriteName = spriteName
        this.jing:SetActive(true)
    else 
        this.jing:SetActive(false)
    end
end 

function mt.UpdatePrepareBtn(is_prepare,is_show)   
    if is_prepare then 
        this.prepare_label.text = "取消准备"
    else 
        this.prepare_label.text = "准备开始"
    end 
    this.prepare_btn:SetActive(is_show)
end 
----------------------单击事件---------------------------------
--返回游戏大厅
function mt.OnBackClick(value)
    global._view:showLoading();
    if not value then 
        if this.ui ~= nil then 
            value = this.ui.isGameRoom
        end 
    end 
    -- this.IsClickBack = value
    if (value) then	
        mgr_room:exit(const.GAME_ID_MJ, function ()
            global._view:hideLoading();
            this.is_back = true 
            this.gameScore()
		end)	
        
	else
         global._view:niuniu().Awake(const.GAME_ID_MJ);	
         global._view:hideLoading();	
	end	
	-- mgr_room:exit(const.GAME_ID_MJ,function ()
	-- 	global._view:hideLoading();
    -- end)
end 
function mt.Force_Exit()
    local value = nil 
    if this.ui ~= nil then 
        value = this.ui.isGameRoom
    end 
    this.is_back = true 
    if (value) then	
        this.gameScore()	        
	else
         global._view:niuniu().Awake(const.GAME_ID_MJ);	
         global._view:hideLoading();	
	end
end 
function mt.gameScore()
	global._view:showLoading();
	mgr_room:req_get_hall_list(const.GAME_ID_MJ, function (list)
		global._view:hideLoading();
		if (this.ui ~= nil) then
			global._view:gameScore().Awake(list,const.GAME_ID_MJ)
		end
	end)
end
----------------------获取数据---------------------------------
function mt.GetPlayerData()
    global._view:showLoading()
    mgr_mj:req_data(function(data)
        global._view:hideLoading()
        if this.ui~=nil then 
            if data ~= nil then 
                this.ui.Init(data,const)
                -- if data.game_status == const.MJ_STATUS_FREE then 
                --     this.EndStatus(const.MJ_STATUS_FREE)
                -- end 
            else 
                this.GetPlayerData()
            end 
        end             
    end)
end 

function mt.GetChatObjData(who)
    local data = {}
    if who == 1 then 
        data.parent = this.say_chat_1
        data.collider_sprite = this.say_collider_sprite_1
    elseif who == 2 then 
        data.parent = this.say_chat_2
        data.collider_sprite = this.say_collider_sprite_2
        data.timer = this.ui.chat_timer_2
    elseif who == 3 then 
        data.parent = this.say_chat_3
        data.collider_sprite = this.say_collider_sprite_3
    elseif who == 4 then 
        data.parent = this.say_chat_4
        data.collider_sprite = this.say_collider_sprite_4
    else 
        return nil 
    end 
    return data    

end 

function mt.GetTime()
    return global.ts_now;
end 
--获取自己的ID
function mt.GetPlayerID()
	return global.player:get_playerid()
end
--获取头像框的一系列组件 
function mt.GetHeadImage(who)
    if not who then 
        print("MJPANEL:GetHeadImage:error!!!!")
        return nil 
    end 
    local data = {}
    if who == 1 then 
        data.player_name = this.head_1_name
        data.obj = this.head_1_obj
        data.AsyncImageDownload = this.head_1_AsyncImageDownload
        data.tuo = this.head_1_tuo
        data.zhaung = this.head_1_zhuang
        data.money_obj = this.head_1_money_obj
        data.money_label = this.head_1_money_label
        data.prepare_obj = this.head_1_prepare_obj
    elseif who == 2 then 
        data.player_name = this.head_2_name
        data.obj = this.head_2_obj
        data.AsyncImageDownload = this.head_2_AsyncImageDownload
        data.tuo = this.head_2_tuo
        data.zhaung = this.head_2_zhuang
        data.money_obj = this.head_2_money_obj
        data.money_label = this.head_2_money_label
        data.prepare_obj = this.head_2_prepare_obj
    elseif who == 3 then 
        data.player_name = this.head_3_name
        data.obj = this.head_3_obj
        data.AsyncImageDownload = this.head_3_AsyncImageDownload
        data.tuo = this.head_3_tuo
        data.zhaung = this.head_3_zhuang
        data.money_obj = this.head_3_money_obj
        data.money_label = this.head_3_money_label
        data.prepare_obj = this.head_3_prepare_obj
    elseif who == 4 then 
        data.player_name = this.head_4_name
        data.obj = this.head_4_obj
        data.AsyncImageDownload = this.head_4_AsyncImageDownload
        data.tuo = this.head_4_tuo
        data.zhaung = this.head_4_zhuang
        data.money_obj = this.head_4_money_obj
        data.money_label = this.head_4_money_label
        data.prepare_obj = this.head_4_prepare_obj
    end 
    return data 
end 
----------------------CS信息回传---------------------------------
--结束状态
function mt.EndStatus(status_id,cb)
    global._view:showLoading()
    local playerid = this.GetPlayerID()
    mgr_mj:req_end_status(status_id,playerid,function()
        global._view:hideLoading()
        if cb then 
            cb()
        end 
    end)
end 
--结束状态
function mt.CancelPrepare(cb)
    global._view:showLoading()
    local playerid = this.GetPlayerID()
    mgr_mj:req_cancel_prepare(playerid,function()
        global._view:hideLoading()
        if cb then 
            cb()
        end 
    end)
end 
--出牌请求
function mt.PlayCard(posID,cardid,error_call)
    global._view:showLoading()
    local playerid = this.GetPlayerID()
    mgr_mj:req_play_out_card(posID,cardid,playerid,function(ec)
        global._view:hideLoading()
        if ec ~=0 then 
            this.ui.is_play_card_anima = nil
            if error_call then 
                error_call()
            end 
        end 
    end)
      
end 
--暗杠请求
--CPHG_type: 1 angang 2 gang 3 peng 4 chi 5 hu
function mt.AnGang(id)
    global._view:showLoading()
    local playerid = this.GetPlayerID()    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_ANGANG,id,function(data)
        global._view:hideLoading()
        if this.ui ~= nil then 
        end 
    end)
end
--吃请求
--CPHG_type: 1 angang 2 gang 3 pen 4 chi 5 hu
function mt.CHI(id)
    global._view:showLoading()
    local playerid = this.GetPlayerID()    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_CHI,id,function(data)
        global._view:hideLoading()
        if this.ui ~= nil then 
            -- this.ui.OnAnGangPlayCallBack(data)
        end 
    end)
end  
--碰请求
function mt.PENG()
    global._view:showLoading()
    local playerid = this.GetPlayerID()    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_PENG,nil,function(data)
        global._view:hideLoading()
        if this.ui ~= nil then 
            -- this.ui.OnAnGangPlayCallBack(data)
        end 
    end)
end 
--杠请求
function mt.GANG()
    global._view:showLoading()
    local playerid = this.GetPlayerID()    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_GANG,nil,function(data)
        global._view:hideLoading()
        if this.ui ~= nil then 
            -- this.ui.OnAnGangPlayCallBack(data)
        end 
    end)
end
--补杠
function mt.BuGang()
    global._view:showLoading()
    local playerid = this.GetPlayerID()    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_BUGANG,nil,function(data)
        global._view:hideLoading()
        if this.ui ~= nil then 
            -- this.ui.OnAnGangPlayCallBack(data)
        end 
    end)
end 
--胡请求
function mt.HU()
    global._view:showLoading()
    local playerid = this.GetPlayerID()    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_HU,nil,function(data)
        global._view:hideLoading()
        if this.ui ~= nil then 
            -- this.ui.OnAnGangPlayCallBack(data)
        end 
    end)
end 
--游金请求
function mt.YOUJING(id)
    global._view:showLoading()
    local playerid = this.GetPlayerID()    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_YOUJING,id,function(data)
        global._view:hideLoading()
        if this.ui ~= nil then 
            -- this.ui.OnAnGangPlayCallBack(data)
        end 
    end)
end 
--pass请求
function mt.PassCPHG()
    global._view:showLoading()
    local playerid = this.GetPlayerID() 
    local id = nil    
    mgr_mj:req_CPHG(playerid,CPHG_TYPE_PASS,id,function(data)
        global._view:hideLoading()
        local ec = data.errcode
        if this.ui ~= nil and ec == 0 then 
            this.ui.OnPassPlayCallBack()
        end 
    end)
end 
--托管请求
function mt.Entrust(type)
    global._view:showLoading()
    local playerid = this.GetPlayerID()
    mgr_mj:req_entrust(type,playerid,function()
    end)
end 

function mt.sendChat(msg,msgtype,voicetime)
    global.player:get_mgr("chat"):chat2room(msg,msgtype,voicetime)
end

-- function mt.DaTing_New_Game()
--     global._view:showLoading()
--     mgr_mj:req_data(function(data)
--         global._view:hideLoading()
--         if this.ui~=nil then 
--             if data ~= nil then 
--                 this.ui.update_Init(data,true)
--             end 
--         end             
--     end)
-- end 
----------------------SC信息回传---------------------------------  
--进入玩家广播更新信息
--[[play_users={
        {
            player_name,
            playerid,
            head_imgurl,
            player_money,
            seatid
        }
    }]]  
function mt.UpdatePlayerEnter(data)
    if this.ui~=nil then 
        local is_enter = true 
        
        if data.play_type then 
            this.ui.update_Init(data,is_enter)
        else 
            for k,v in pairs(data.play_users)do
               
                this.ui.Update_Head(v)
            end
            this.ui.Update_PlayUser(data.play_users,is_enter)
        end 
    else 
        print("MJPANEL:UpdatePlayerEnter:not ui!!!!")
    end 
end 
-- data={seatid,is_prepare}
function mt.UpdatePlayerPrepare(data)
    local seatid = data.seatid 
    if not seatid then 
        return
    end 
    if not this.ui then 
        return
    end 
    local who = this.ui.GetWhoBySeatid(seatid)
    local head_data = this.GetHeadImage(who)    
    head_data.prepare_obj:SetActive(data.is_prepare)
    
    -- local play_users = this.ui.play_users
    for k,v in pairs (this.ui.play_users)do 
        if v.seatid == seatid then 
            v.is_prepare = data.is_prepare
            break             
        end 
    end     
end 
--更新游戏状态
function mt.SetBetState(data)
    if this.ui~= nil then 
        if this.ui.is_play_clearup_anima  then 
            global._view:Invoke(0.2,function()
                this.waitSetBetState()
            end)
            -- this.waitSetBetState()
        else 
            this.ui.UpdateBetState(data)
        end 
        -- this.ui.UpdateBetState(data)
    end 
end 
function mt.waitSetBetState()    
    if this.ui~= nil then       
        if this.ui.is_play_clearup_anima  then 
            global._view:Invoke(0.2,function()
                this.waitSetBetState()
            end)
            -- this.waitSetBetState()
        else 
            local data = mgr_mj:get_update_data()
            this.ui.UpdateBetState(data)
        end 
    end 
end 

function mt.Play_Out_Card(data)
    if this.ui~=nil then 
        if not this.ui.is_init then 
        --     this.playoutcard_data = data 
            global._view:Invoke(0.2,function()
                this.Wait_Play_Out_Card()
            end)           
        else 
            this.ui.PlayOutCardCallBack(data)
        end 
        -- this.ui.PlayOutCardCallBack(data)
    end 
end 
-- this.playoutcard_data = nil 
function mt.Wait_Play_Out_Card()
    if this.ui ~= nil then 
        if this.ui.is_play_clearup_anima  then 
            global._view:Invoke(0.2,function()
                this.Wait_Play_Out_Card()
            end)
        else 
            local data = mgr_mj:get_play_out_data()
            this.ui.PlayOutCardCallBack(data)
        end 
    end 
end 

function mt.DO_CPHG(data,do_type)
    global._view:hideLoading()
    if this.ui~=nil then 
        if do_type == CPHG_TYPE_ANGANG then 
            this.ui.OnAnGangPlayCallBack(data)
        elseif do_type == CPHG_TYPE_GANG then 
            this.ui.OnGangPlayCallBack(data)  
        elseif do_type == CPHG_TYPE_PENG then
            this.ui.OnPengPlayCallBack(data)  
        elseif do_type == CPHG_TYPE_CHI then
            this.ui.OnChiPlayCallBack(data) 
        elseif do_type == CPHG_TYPE_HU then 
            this.ui.OnHuPlayCallBack(data)
        elseif do_type == CPHG_TYPE_PASS then 
        elseif do_type == CPHG_TYPE_BUGANG then 
            this.ui.OnBuGangPlayCallBack(data)
        end 
    end 
end 

function mt.Entrust_CallBack(data)
    global._view:hideLoading()
    if this.ui ~= nil then 
        this.ui.Entrust_CallBack(data)
    end 
end 
--聊天信息更新
function mt.getChatData(data,playerInfo)
	local name = playerInfo.from_name
	local Isviedo = false
	if(data.msgtype == 1) then
		Isviedo = true
	end
	local d={coin = 0,
		player_name = name,
		amount_money = 0,
		content = data.msg,
		url = playerInfo.from_headid,
		viedo = Isviedo,
		viedoTime = data.voice_time,
		IsCard = nil,
		IsBank = "",
	}

	-- local who = 0
	-- if(name == this.getPlayerName()) then
	-- 	who = 1
	-- end
	if(this.ui ~= nil) then
		this.ui.addPlayerBetInfo(d)
	end
end

function mt.Broad_Exit(data)
    global._view:hideLoading()
    if this.ui ~= nil then 

        local is_enter = false
        local list = {}
        local info = {
            seatid = data.seatid
        }
        table.insert(list,info)
        this.ui.Update_PlayUser(list,is_enter)
        this.ui.Update_Head(data) 
        if data.play_type then 
            this.ui.play_users = nil 
            this.ui.update_Init(data,true)             
        end        
    end 
end 
----------------------销毁---------------------------------
function mt.OnDestroy()
    global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
    if this.is_back == false then 
        mgr_room:exit(const.GAME_ID_MJ,function ()
        end)
    end 
    mgr_mj:nw_unreg();
    this.is_back =false
end
return this