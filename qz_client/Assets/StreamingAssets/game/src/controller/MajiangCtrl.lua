require "logic/ViewManager"
local global = require("global")
local i18n = global.i18n
MaJiangCtrl ={};
local CAN_PAUSE =global._view.CAN_PAUSE --更换CS文件后可以设置为true
local this=MaJiangCtrl;
local mt = this

local TWO_PLAYER = 2           --两人玩家类型
local THREE_PLAYER = 3         --三人玩家类型
local FOUR_PLAYER = 4          --四人玩家类型
--------------------------------------------------
local ANIMA_STATUS_FREE = 1     --空闲
local ANIMA_STATUS_DICES =2     --摇骰子
local ANIMA_STATUS_DEAL = 3     --发牌
local ANIMA_STATUS_DRAW =4      --抽牌
local ANIMA_STATUS_ADD = 5      -- 补花
local ANIMA_STATUS_OTHERADD = 6 --其他人补花
local ANIMA_STATUS_GOLD = 7     --摸金
local ANIMA_STATUS_CLEARUP = 8  --理牌
local ANIMA_STATUS_CPHG = 9     --吃碰胡杠
local ANIMA_STATUS_END = 10     --结束
--------------------------------------------------
local FUN_ID_ADDFLOWER = 1
-- local FUN_ID_TWEEN = 10000
local FUN_ID_DRAW = 20000
local FUN_ID_CPHG = 30000
local FUN_ID_CLEARUP = 40000
local FUN_ID_Anim = 50000
------------------------------------------------------
local DEALCARD_TIMER = 0.5                  --发牌间隔时间
local BASICTWEN_TIMER = 0.2                 --初始Tween动画运动时间
local ADDFLOWER_WAIT_TIMER = BASICTWEN_TIMER--开始补花动画滞后时间
local CLEARUP_TIMER = 0.09                  --理牌间隔动画切换
--------------------------------------------------------
local SELF_PAI_DI_NAME = "bengjialipai"
----------------------------------------------------------
local SHOW_CHAT_TIME = 5
----------------------------------------------------------
--区域位置ID--
local AREA_ID_HAND = 1         -- 手牌区
local AREA_ID_OUT = 2          -- 出牌区
local AREA_ID_PEN = 3          -- 碰牌区
local AREA_ID_FLOWER = 4       -- 花牌区
local AREA_ID_EFFECT = 5       -- 特效区
local AREA_ID_CHAT   = 6       -- 聊天区
---------------------------------------------------------
--特效ID
local EFFECT_ID_FLOWER  = 1     -- 补花特效
local EFFECT_ID_CHI     = 2     -- 吃牌特效
local EFFECT_ID_PENG    = 3     -- 碰牌特效
local EFFECT_ID_HU      = 4     -- 胡牌特效
local EFFECT_ID_GANG    = 5     -- 杠牌特效
local EFFECT_ID_YOUJING = 6     -- 杠牌游金

---------------------------------------------------------
--tween 基础值 ---
local BASIC_TWEEN_TYPE_POS = 1    --Tween位置类
local BASIC_TWEEN_TYPE_SCALE = 2  --Tween大小类
---------------------------------------------------------
-- tween 上升值
local TWEEN_UP_WHO_1 = 30       -- 主位上升高度
--------------------------------------------------------
--showCardPanel data type
local SHOWCARD_TYPE_ANGANG = 1  --显示杠类型
local SHOWCARD_TYPE_CHI = 2     --显示吃类型
local SHOWCARD_TYPE_YOUJING = 3 --显示游金类型
--------------------------------------------------------
--DO CPHG
local DO_TYPE_ANGANG = 1      --执行暗杠
local DO_TYPE_GANG = 2        --执行杠
local DO_TYPE_CHI = 3         --执行吃
local DO_TYPE_PENG = 4        --执行碰
---------------------------------------------------------
local ANIMA_SPACE_TIMER = 0.03  --动画间隔时间
---------------------------------------------------------
local INVOKE_TIME_DICES = 0.5   --摇骰子延迟时间
local INVOKE_TIME_GOLD  = 0.5   --摸金延迟时间
local INVOKE_TIME_FLOWER = 0.5  --补花子延迟时间
---------------------------------------------------------
local ENTRUST_TYPE_SET = 1    --托管
local ENTRUST_TYPE_CANCEL = 0 --取消托管
---------------------------------------------------------
--胡类型
local HU_TYPE_PING = 1 --平胡
local HU_TYPE_SELF = 2 --自摸
local HU_TYPE_GOLD = 2 --游金
---------------------------广播类型--------------------------------
local BROADCAST_TYPE_FORCEEXIT           = 1  --强制退出房间
local BROADCAST_TYPE_EXIT                = 2  --退出房间
local BROADCAST_TYPE_CANCEL_PREPARE      = 3  --取消准备
local BROADCAST_TYPE_PREPARE             = 4  --准备
-----------------------------常量--------------------------------
this.gameObject = nil 
this.transform = nil 
this.panel = nil 
this.LB = nil 
this.MP = nil 
this.const = nil 

-- this.KEYCTRL = false  --测试用
this.WHO=1 --测试用
this.sprite_name= { 
    --梅兰竹菊 春夏秋冬
    [1]="p01s_0000_zmei",[2]="p01s_0001_zlan",[3]="p01s_0002_zzhizi",[4]="p01s_0003_zju",    
    [5]="p01s_0007_schun",[6]="p01s_0006_sxia",[7]="p01s_0005_sqiu",[8]="p01s_0004_sdong",
    --万 1-9
    [11]="p04s_0008_1wan",[12]="p04s_0007_2wan",[13]="p04s_0006_3wan",[14]="p04s_0005_4wan",
    [15]="p04s_0004_5wan",[16]="p04s_0003_6wan",[17]="p04s_0002_7wan",[18]="p04s_0001_8wan",[19]="p04s_0000_9wan",
    --条 1-9
    [21]="p03s_0008_1tiao",[22]="p03s_0007_2tiao",[23]="p03s_0006_3tiao",[24]="p03s_0005_4tiao",
    [25]="p03s_0004_5tiao",[26]="p03s_0003_6tiao",[27]="p03s_0002_7tiao",[28]="p03s_0001_8tiao",[29]="p03s_0000_9tiao",
    --筒 1-9
    [31]="p02s_0008_1bing",[32]="p02s_0007_2bing",[33]="p02s_0006_3bing",[34]="p02s_0005_4bing",
    [35]="p02s_0004_5bing",[36]="p02s_0003_6bing",[37]="p02s_0002_7bing",[38]="p02s_0001_8bing",[39]="p02s_0000_9bing", 
    --东南西北中发白
    [41]="p00s_0002_fdong",[42]="p00s_0000_fnan",[43]="p00s_0001_fxi",[44]="p00s_0006_fbei",
    [45]="p00s_0005_fzhong",[46]="p00s_0004_ffa",[47]="p00s_0003_fbaibang",     
     
}
this.btnSpriteName={
    --吃、明杠、胡、碰、暗杠、游金
    [1]="anchits",[2]="anminggangts",[3]="anhuts",[4]="anpengts",[5]="anangangts",
    [6]="anyoujin",

}
this.hu_type_sprite = {
    [1]="hu_1",[2]="hu_2",[3]="hu_3",
}
this.out_box_data = nil -- {star_pos1 = , len_1 = ......} 
this.space_1 = 70
this.space_2 = 25
this.space_3 = 40
this.space_4 = 27
-----------------------------数据信息--------------------------------
--========公共数据======
this.play_type = nil --int
this.roomid = nil  --int
this.isGameRoom = nil --bool
this.roomTitle = nil --string
this.bet_coin = nil -- int 
this.seatid = nil --int
this.over_time = nil  --int 
this.game_status = nil  -- int 
this.play_users = nil--[[{ [1]={
    player_name,
    playerid,
    head_imgurl,
    player_money,
    seatid,
},}]]
--===wait======
this.dices = nil -- {{id},}
--===prepare===
this.banker = nil --{seatid,playerid}
this.goldid = nil -- int 

this.flower_list = nil --{{seatid,posid,cardid},}
this.deal_list = nil --{[posid]=cardid,}
this.hand_list = nil --{[posid]=cardid,}
this.add_flower_data = nil --{[posid]={{poscard_id,addcard_id},}
--===play===
--this.flower_list
this.play_seatid = nil --int
--this.add_flower_data
this.angang_list = nil --{{[posid]=cardid,},}--4个一组
this.drawCard_id = nil --int
this.can_hu = nil --bool cardid
this.youjing_list = nil --{[posid]=cardid,} 
--===CPHG===
-- this.can_hu     -- cardid
this.gang_list = nil --{{[posid]=cardid,},}
this.pen_list = nil --{{[posid]=cardid,},}
this.chi_list = nil --{{[posid]=cardid,},}
--===END===
this.result_list = nil --结果列表
this.result = nil --结果情况 -- 1、获胜 2、失败 3、流局
--==================================================
this.co_render_cards = nil  -- 发牌协同程序
this.cur_data = nil --测试用
-----------------------------标志位--------------------------------
this.is_play_list_anima = nil     --播放按钮列表动画中(按键列表) --close
this.is_play_card_anima = nil     --播放出牌动画中          --close
this.is_play_clearup_anima = nil  --播放理牌动画中          --close
this.is_play_clearup_drawcard_anima = nil ----播放抽牌理牌动画中 
this.is_play_glod_anima = nil     --播放金牌动画中
this.is_play_addflwer_anima = nil --播放补花动画中
this.is_play_drawcard_anima = nil --播放抽牌动画中



this.is_play_effect_anima = nil   --播放特效动画中

this.can_play_deices_anima = nil --播放摇骰子动画

this.clearup_data = nil       -- 理牌数据

this.isPress = nil            --按压牌

this.str_render_timer = 0     -- 发牌时间计数
this.press_time = 0           -- 按压时间

this.cur_card = nil           -- 当前选中的牌
this.last_card = nil          -- 上次选中的牌 
this.out_card = nil           -- 打出去的牌 

this.clearup_tiemr = 0         --理牌计时器
this.clearup_count = 0         --理牌计数器
this.star_clearup_timer = nil  --理牌开始标记位
--骰子
this.anima_timer = 0          --动画计时器
this.anima_index = 1          --动画换图计数
--cphg flower
this.effect_str = nil          -- 特效图片名称
this.effect_amount = nil       -- 特效图片总数
this.effect_count = 1          -- 特效图片计数
this.on_play_effect = nil      -- 播放特效开关
this.effect_anima_timer = 0    -- 特效计时器

this.last_game_status = nil 

this.anima_status = nil        -- 动画播放阶段

this.is_start_game = nil       -- 游戏是否已开始

this.chat_timer_1 = 0          -- 聊天显示计时器
this.chat_timer_2 = 0          -- 聊天显示计时器
this.chat_timer_3 = 0          -- 聊天显示计时器
this.chat_timer_4 = 0          -- 聊天显示计时器

this.play_out_card_data = nil --[[
    data = {
            seatid = resp.seatid,
            posid = resp.posid,
            cardid = resp.cardid,
            to_posid = to_posid
        }
]] 
this.is_prepare = nil  -- 是否准备
this.is_init = nil     -- 初始化完成 
-----------------------------列表存储--------------------------------
this.card_list_1 = nil --{[posID]=obj}
this.card_list_2 = nil --{[posID]=obj}
this.card_list_3 = nil --{[posID]=obj}
this.card_list_4 = nil --{[posID]=obj}

-- this.card_list = nil   --{[posID]=card_id}

this.out_card_list_1 = nil --{[posID]=obj}
this.out_card_list_2 = nil --{[posID]=obj}
this.out_card_list_3 = nil --{[posID]=obj}
this.out_card_list_4 = nil --{[posID]=obj}

this.pen_list_1 = nil --{[posID]=obj}
this.pen_list_2 = nil --{[posID]=obj}
this.pen_list_3 = nil --{[posID]=obj}
this.pen_list_4 = nil --{[posID]=obj}

this.flower_List_1 = nil --{[posID]=obj}
this.flower_List_2 = nil --{[posID]=obj}
this.flower_List_3 = nil --{[posID]=obj}
this.flower_List_4 = nil --{[posID]=obj}

this.chat_list_1 = nil --{obj}
this.chat_list_2 = nil --{obj}
this.chat_list_3 = nil --{obj}
this.chat_list_4 = nil --{obj}

this.head_texture_list = nil --{{texture(obj),head_imgurl(string)},}

this.bu_peng_list_1 = nil --{[cardid]=obj}
this.bu_peng_list_2 = nil --{[cardid]=obj}
this.bu_peng_list_3 = nil --{[cardid]=obj}
this.bu_peng_list_4 = nil --{[cardid]=obj}

this.result_item_list = nil --{obj}

this.seat_order=nil --{[seatid]=who,}

this.call_fun_list = nil --[[{
    [fun_id]={
        fun,data,timer_to,timer_from,index,count,is_finish,finish_fun
    }
}]]

this.show_cphg_message_list = nil --{obj}
this.gold_effect_obj = nil
this.cphg_pre_list = nil 

this.clearup_anima_data_list = nil -- {{timer,data},} 执行列表
this.clearup_data_list = nil -- {{timer,data},}执行列表


--获取长度
local function get_len(list)
    local len = 0 
    for k,v in pairs(list)do 
        if v then 
            len = len + 1 
        end 
    end 
    return len 
end 

local function new_table(list)
    local data = {}
    for k,v in pairs(list)do 
        data[k]= v 
    end 
    return data 
end 

--构建函数--
function mt.New()
	return this;
end
function mt.Awake(roomid,value,title)
    this.roomid = roomid;
	this.isGameRoom = value
    this.roomTitle = title  
    panelMgr:CreatePanel('MaJiang',this.OnCreate);  

    
end

function mt.OnCreate(obj)
    this.gameObject = obj 
    this.transform = obj.transform
    this.panel = this.transform:GetComponent("UIPanel")
    this.LB = this.transform:GetComponent("LuaBehaviour")
    this.MP = MaJiangPanel

    this.LB:AddClick(this.MP.backBtn,this.OnBack)
    this.LB:AddClick(this.MP.helpBtn,this.OnHelp)
    this.LB:AddClick(this.MP.menuBtn,this.OnMenu)
    this.LB:AddClick(this.MP.chatBtn,this.OnChat)
    this.LB:AddOnPress(this.MP.voiceBtn,this.OnVoice)
    this.LB:AddClick(this.MP.returnBtn,this.OnReturn)
    this.LB:AddClick(this.MP.entrustBtn,this.OnEntrust)
    this.LB:AddClick(this.MP.entrust_cancel_btn,this.OnCancelEntrust)
    this.LB:AddClick(this.MP.setBtn,this.OnSet)
    this.LB:AddClick(this.MP.BankBtn,this.BankBtn)
    this.LB:AddClick(this.MP.inviteBtn,this.OnInvite)

    this.LB:AddClick(this.MP.passBtn,this.OnPass)
    this.LB:AddClick(this.MP.play_returnBtn,this.OnPlayReturn)

    this.LB:AddClick(this.MP.result_back_btn,this.OnBack)
    this.LB:AddClick(this.MP.result_next_btn,this.OnNext)

    this.LB:AddClick(this.MP.prepare_btn,this.OnPrepare)

    UpdateBeat:Add(this.TimeEvent,this)
    this.Render_Chat()

    if this.isGameRoom then 
        this.MP.inviteBtn:SetActive(false)
    end 

    this.allRecard = {this.MP.recard1,this.MP.recard2,this.MP.recard3,
	this.MP.recard4}
	this.MP.viedo_VoiceChatPlayer.onSendVoice = function(sendLen,SendData)
		if sendLen == 0 then
	        -- RoomPanel.setTip("请在【设置-隐私-麦克风】选项中，\n允许访问麦克风。");
	        this.animaTime = 0
	        this.StartViedoTime = 0
			this.isStartViedo = false;
			this.MP.record:SetActive(false)
			this.PlayBGSound()
			this.MP.viedo_VoiceChatPlayer:StopRecording()
	        return
	    end
	    this.stopRecord(SendData)
	    RoomPanel.viedo_VoiceChatPlayer:StopRecording()
    end
    
end 

function mt.Init(data,const)
    this.const = const 
    this.cur_data = data --测试用
    this.MP = MaJiangPanel
    ----------数据赋值----------------
    this.play_type = data.play_type
    this.game_status = data.game_status
    if data.game_status ~= this.const.MJ_STATUS_FREE or
    data.game_status ~= this.const.MJ_STATUS_END then 
        this.is_start_game = data.game_status
        if this.isGameRoom then 
            if data.play_type == 5 then --缓存玩家 
                this.play_type = 4 
                this.is_start_game  = 0
                this.MP.tip:SetActive(true)
            end 
        end 
    end    
    this.play_users = data.play_users

    this.bet_coin = data.bet_coin

    this.MP.SetShowHead(this.play_type)
    this.MP.SetPlayOutCardArea(this.play_type)
    this.Set_Seat(this.play_users)
    
    this.InitOutBox(data.play_type)  
    this.UpdataRoomLabel()
    -- this.MP.UpateCardsAmount(data.cards_amount)   
    --发牌
    if data.game_status == this.const.MJ_STATUS_PREPARE then 
        this.OnAnimaStatus(ANIMA_STATUS_DICES)
    end 
    if this.is_start_game then 
        if this.is_start_game == 0 then 

        end
        if data.goldid then 
            this.goldid = data.goldid 
            this.UpdateGoldImage()
        end
        if this.is_start_game >= this.const.MJ_STATUS_PLAY and 
        this.is_start_game < this.const.MJ_STATUS_END then 
            --初始化桌面信息
            this.Start_Render()
            --当前打出的牌 -- todo 
            if data.cur_out_seatid then 
                for k,v in pairs(this.play_users)do 
                    if v.seatid == data.cur_out_seatid then 
                        local who = this.GetWhoBySeatid(v.seatid)
                        local list = this.GetCardList(AREA_ID_OUT,who)
                        local area_data = this.GetOutCardToAreaData(AREA_ID_OUT,who)
                        local posid = this.out_box_data.amount - area_data.len +1
                        this.out_card = this.GetCardObj(AREA_ID_OUT,who,posid) or nil 
                        if this.out_card then
                            this.out_card.transform:Find("Target").gameObject:SetActive(true)
                        end 
                        break
                    end 
                end 
            end 
            --初始化花区
            if data.flower_list then
                for k,v in pairs(data.flower_list)do 
                    local who = this.GetWhoBySeatid(v.seatid)
                    local flower_data = this.GetCardData(who,9,AREA_ID_FLOWER)
                    -- local area_data = this.GetOutCardToAreaData(AREA_ID_FLOWER,who)
                    -- flower_data.card_name = flower_data.posID
                    -- flower_data.pos = area_data.card_pos
                    flower_data.card_id = v.cardid
                    local go = this.CreateCard(flower_data)
                    local info = {}
                    local posID = go.name + 0
                    info[posID]=go
                    if who == 4 or who == 3  then 
                        this.ClearUpCardDepth(info,9)
                    else 
                        this.ClearUpCardDepth(info)
                    end 
                end 
            end
           
        end 
         
    end    
    local is_show = false
    if data.game_status == this.const.MJ_STATUS_END then 
        is_show = true 
    end    
    this.MP.prepare_btn:SetActive(is_show) 

    

    this.UpdateBetState(data)
    global._view:hideLoading();
    this.is_init = true 
end 

function mt.UpdateBetState(data)
    if this.const == nil then 
        print ("MJCTRL:UpdateBetState:not const")
        return 
    end 
    this.over_time = data.over_time
    this.SetLastGameStatus(this.game_status)
    this.game_status = data.game_status    
    this.MP.UpateCardsAmount(data.cards_amount)
   
    if this.game_status == this.const.MJ_STATUS_FREE then 
        if this.last_game_status == this.const.MJ_STATUS_END then 
            local is_show = false
            for who = 1 , 4 do 
                this.MP.UpdateEntrust(who,is_show)
            end             
            this.NewGameResetData()
        end 
        this.MP.prepare_btn:SetActive(true)
    elseif this.game_status == this.const.MJ_STATUS_WAIT then 
        if this.is_start_game  == 0 then 
            return
        end 
        if this.last_game_status == this.const.MJ_STATUS_END then 
            this.NewGameResetData()
            local is_show = false
            for who = 1 , 4 do 
                this.MP.UpdateEntrust(who,is_show)   
            end 
        end
        if this.last_game_status == this.const.MJ_STATUS_END or 
        this.last_game_status == this.const.MJ_STATUS_FREE then 
        --隐藏头像准备标记
            for i = 1 , 4 do 
                local prepare_data = {
                    seatid = who ,
                    is_prepare = false
                }
                this.MP.UpdatePlayerPrepare(prepare_data)
            end 
            this.MP.ResetHead()
            --隐藏准备按钮
            local is_show = false
            this.is_prepare = nil 
            this.MP.UpdatePrepareBtn(this.is_prepare,is_show)
            for k,v in pairs(this.play_users)do 
                if v.is_prepare then 
                    v.is_prepare = false 
                end 
            end
        end 
        this.MP.time_label.text = "..."
        if data.dices then 
            this.dices = data.dices 
            
            -- this.PlayDices(data.dices)
            this.SetAnimaStatus(ANIMA_STATUS_DICES)
        end 
    elseif this.game_status == this.const.MJ_STATUS_PREPARE then
        --重置信息
        if this.is_start_game  == 0 then 
            return
        end 
        this.banker = nil 
        this.goldid = nil 
        this.flower_list = nil 
        this.deal_list = nil 
        this.hand_list = nil 
        this.add_flower_data = nil 
        this.Gen_Net_Data(data) -- 更新数据                
        this.DealCard(data.deal_list)

        -- if this.is_start_game then 
        --     this.OnAnimaStatus(ANIMA_STATUS_DICES)
        -- end 
   
    elseif this.game_status == this.const.MJ_STATUS_PLAY then
        if this.is_start_game  == 0 then 
            return
        end 
         --重置信息
        --  this.ClosePlayBtn()--隐藏吃碰胡杠按钮
         this.CloseShowCPHGPanel()
         
         this.flower_list = nil 
         this.play_seatid = nil 
         this.add_flower_data = nil         
         this.drawCard_id = nil 
         this.can_hu = nil 
         this.angang_list = nil 
         this.gang_list = nil --{{[posid]=cardid,},}
         this.pen_list = nil --{{[posid]=cardid,},}
         this.chi_list = nil --{{[posid]=cardid,},}       
         this.youjing_list = nil --{[posid]=cardid,} 
        this.Gen_Net_Data(data) --更新数据
        --更新指向指示器
        this.WHO = this.GetWhoBySeatid(this.play_seatid)
        this.PonintController(this.WHO)
        if this.is_start_game then 
            if this.WHO == 1 and not this.GetCardObj(AREA_ID_HAND,1,17) 
            and data.play_status ~= 1 then 
                this.SetAnimaStatus(ANIMA_STATUS_DRAW)
            else 
                this.SetAnimaStatus(ANIMA_STATUS_FREE)
            end 
        else 
            if this.last_game_status == this.const.MJ_STATUS_PREPARE then
                --碰吃胡杠
                if this.WHO == 1 then 
                    this.SetAnimaStatus(ANIMA_STATUS_CPHG)
                end 
            else 
                --先抽卡 ==>补花 ==>碰吃胡杠
                if data.play_status~= 1 then --不是吃碰状态
                    this.SetAnimaStatus(ANIMA_STATUS_DRAW)  
                else 
                    if this.WHO == 1 then 
                        this.SetAnimaStatus(ANIMA_STATUS_CPHG)   
                    end 
                end      
            end
        end 
        --出牌 
    elseif this.game_status == this.const.MJ_STATUS_CPHG then 
        if this.is_start_game  == 0 then 
            return
        end 
         --重置信息
        this.can_hu = nil 
        this.angang_list = nil 
        this.gang_list = nil 
        this.pen_list = nil 
        this.chi_list = nil 
        this.Gen_Net_Data(data) --更新数据
        this.WHO = this.GetWhoBySeatid(this.play_seatid)   
        this.PonintController(this.WHO)      
        if this.WHO and this.WHO == 1 then                    
            this.SetAnimaStatus(ANIMA_STATUS_CPHG)
        end 
    elseif this.game_status == this.const.MJ_STATUS_YOUJING then
        if this.is_start_game  == 0 then 
            return
        end 
        -- this.ClosePlayBtn()--隐藏吃碰胡杠按钮
        this.CloseShowCPHGPanel()
        this.flower_list = nil 
        this.play_seatid = nil 
        this.add_flower_data = nil         
        this.drawCard_id = nil 
        this.can_hu = nil 
        this.angang_list = nil 
        this.gang_list = nil --{{[posid]=cardid,},}
        this.pen_list = nil --{{[posid]=cardid,},}
        this.chi_list = nil --{{[posid]=cardid,},}       
        this.youjing_list = nil --{[posid]=cardid,} 
       this.Gen_Net_Data(data) --更新数据
       --更新指向指示器
       this.WHO = this.GetWhoBySeatid(this.play_seatid)
       this.PonintController(this.WHO)
       if this.is_start_game then 
            this.SetAnimaStatus(ANIMA_STATUS_FREE)
       else 
            this.SetAnimaStatus(ANIMA_STATUS_DRAW)
       end 

    elseif this.game_status == this.const.MJ_STATUS_END then --结束        
        -- if this.isGameRoom then 
        --     this.play_users = nil 
        --     this.MP.DaTing_New_Game()        
        -- end 
        -- this.MP.head_1_prepare_obj:SetActive(false)
        -- this.MP.head_2_prepare_obj:SetActive(false)
        -- this.MP.head_3_prepare_obj:SetActive(false)
        -- this.MP.head_4_prepare_obj:SetActive(false)
        if data.play_users then
             this.play_users = nil 
            this.update_Init(data,true )
        end 
        this.MP.UpdateGoldImage(nil)

        if this.is_start_game == 0 then 
            local is_show = true 
            this.is_prepare = nil 
            this.MP.tip:SetActive(false)
            this.MP.UpdatePrepareBtn(this.is_prepare,is_show)
            this.is_start_game = nil         
            return
        end 

        this.MP.gold_effect:SetActive(false)

        this.Gen_Net_Data(data)
        this.result_list = data.result_list
        this.result = data.result
        if this.last_game_status ~= this.const.MJ_STATUS_END then 
            this.ClearAllResultPrefab()--先清空Item
            this.SetAnimaStatus(ANIMA_STATUS_END)
        end
    end     

end 
-------------------------------功能--------------------------------
--初始化出牌区数值
function mt.InitOutBox(play_type)
    
    this.MP.SetOutPlayBox(play_type)
    this.out_box_data = {}
    if play_type == 4 then 
        this.out_box_data.star_pos_1 = Vector3(-160,25,0)
        this.out_box_data.star_pos_2 = Vector3(-50,-120,0)
        this.out_box_data.star_pos_3 = Vector3(160,-25,0)
        this.out_box_data.star_pos_4 = Vector3(50,120,0)

        this.out_box_data.len_1 = 10
        this.out_box_data.len_2 = 8
        this.out_box_data.len_3 = 10
        this.out_box_data.len_4 = 8

        this.out_box_data.amount = 20

    elseif play_type == 3 then 
        this.out_box_data.star_pos_1 = Vector3(-160,45,0)
        this.out_box_data.star_pos_2 = Vector3(-50,-150,0)
        this.out_box_data.star_pos_3 = Vector3(160,-45,0)

        this.out_box_data.len_1 = 10
        this.out_box_data.len_2 = 10
        this.out_box_data.len_3 = 10

        this.out_box_data.amount = 30
    elseif play_type == 2 then 
        -- this.out_box_data.star_pos_1 = Vector3(-315,45,0)
        this.out_box_data.star_pos_1 = Vector3(-300,45,0)
        this.out_box_data.star_pos_3 = Vector3(284,-45,0)

        this.out_box_data.len_1 = 18
        this.out_box_data.len_3 = 18

        this.out_box_data.amount = 53
    end 
end 
-- 重新初始化桌面信息
function mt.update_Init(data,is_enter)
    this.play_type = data.play_type
    -- print ("**********************")
    -- print ("******play_type********",this.play_type)
    if data.play_users then 
        this.Update_PlayUser(data.play_users,is_enter)
    end 
    --测试
    -- local len = get_len(this.play_users)
    -- for k,v in pairs(this.play_users)do 
    --     print ("---------------------")
    --     print ("====playerid:",v.playerid)
    --     print ("====seatid:",v.seatid)
    --     print ("====is_prepare:",v.is_prepare)
    --     print ("====player_money:",v.player_money)
    -- end 
    ----------------------
    this.MP.SetShowHead(this.play_type)
    this.MP.SetPlayOutCardArea(this.play_type)
    this.Set_Seat(this.play_users)
    this.InitOutBox(data.play_type)
    -- this.UpdataRoomLabel()
end 
-- function mt.udpate_player_prepare(playerid,is_prepare)
--     if this.play_users then 
--         for k,v in pairs(this.play_users)do 
--             if playerid == v.playerid then 
--                 v.is_prepare = is_prepare
--                 break
--             end 
--         end 
--     end 
-- end 
--更新房间内玩家存储信息
function mt.Update_PlayUser(data,is_enter)
    if this.play_users == nil then 
        this.play_users = {}
    end 
    for k,v in pairs(data)do 
        local is_find = false 
        for k2,v2 in pairs(this.play_users)do 
            if v.seatid == v2.seatid then 
                if is_enter == false then 
                    v2 = nil 
                else 
                    v2 = v 
                end 
                is_find = true       
            end 
        end
        if is_find == false and is_enter then 
            table.insert(this.play_users,v)
        end 
    end 
end 
--布置
function mt.RenderFuncCards(card_list)
    local id = 16   
    for i=1,4 do     
        for j = 1 , 4 do 
            this.PlaySound(this.const.AUDIO_MJ_FAPAI)
            --1  
            local data_1 = this.GetCardData(1,id,AREA_ID_HAND)
            if card_list then 
                data_1.card_id=card_list[id] 
            end 

            this.CreateCard(data_1)
            --2
            if this.play_type == THREE_PLAYER
            or this.play_type == FOUR_PLAYER then 
                local data_2 = this.GetCardData(2,id,AREA_ID_HAND)
                if card_list then 
                    data_2.card_id=card_list[id] 
                end 

                this.CreateCard(data_2)
            end 
            --3
            local data_3 = this.GetCardData(3,id,AREA_ID_HAND)
            if card_list then 
                data_3.card_id=card_list[id] 
            end
            this.CreateCard(data_3)
            --4
            if this.play_type == FOUR_PLAYER then 
                local data_4 = this.GetCardData(4,id,AREA_ID_HAND)
                if card_list then 
                    data_4.card_id=card_list[id] 
                end 
                this.CreateCard(data_4)
            end 
            id = id - 1 

        end 
        this.ClearUpCardDepth(this.card_list_2,18)
        this.ClearUpCardDepth(this.card_list_4)       
        this.ClearUpCardDepth(this.card_list_1,nil,1)
        coroutine.yield()  
    end 
    this.OnAnimaStatus(ANIMA_STATUS_DEAL)

    
end 
function mt.Start_Render()
    if this.game_status >= this.const.MJ_STATUS_PLAY and 
    this.game_status < this.const.MJ_STATUS_END then 
        for k,v in pairs(this.play_users)do 
            --手牌
            local who = this.GetWhoBySeatid(v.seatid)
            if v.hand_list then 
                this.CreateHandCard(who,v.hand_list)  
            end
            --暗杠
            if v.angang_len then
                for i = v.angang_len,1 ,-1 do 
                    this.Create_CPG_Card(who,1,DO_TYPE_ANGANG) 
                end 
            end 
            --明杠
            if v.minggang_list then 
                local minggang_list = this.Deal_Create_CPG_Data(v.minggang_list,DO_TYPE_GANG)
                if minggang_list then 
                    for k1,v1 in pairs(minggang_list)do 
                        this.Create_CPG_Card(who,v1,DO_TYPE_GANG)
                    end 
                end 
            end 
            --碰吃
            if v.pengchi_list then 
                local pengchi_list = this.Deal_Create_CPG_Data(v.pengchi_list,DO_TYPE_PENG)
                if pengchi_list then 
                    for k1,v1 in pairs(pengchi_list)do 
                        this.Create_CPG_Card(who,v1,DO_TYPE_PENG)
                    end 
                end 
            end 
            --出牌区
            if v.out_list then 
                
                for k,v in pairs(v.out_list)do 
                    local data_card = this.GetCardData(who,this.out_box_data.amount,AREA_ID_OUT)
                    -- local area_data = this.GetOutCardToAreaData(AREA_ID_OUT,who)
                    data_card.card_id = v.cardid 
                    -- data_card.posID = data_card.posID - area_data.len
                    -- data_card.card_name = data_card.posID   
                    -- data_card.pos = area_data.card_pos
                    local go =  this.CreateCard(data_card)
                    this.CheckGold(go,v.cardid)
                    local info = {}
                    info[data_card.posID]=go 
                    -- print ("----------------------who----------------------:",who)
                    if who == 1 or who == 4 then
                        this.ClearUpCardDepth(info,this.out_box_data.amount+1) 
                    else 
                        this.ClearUpCardDepth(info) 
                    end                    
                end 
            end 
            
        end          

    end 

end 
function mt.Render_Chat()
    local sayContent = {"双击666。","扎心了老铁。","厉害了我的哥。","一言不合就好牌。",
	"明明可以靠脸吃饭，偏偏要靠才华","人生就像一场戏，输赢不用在意。","下得多赢得多。",
	"快点啊，等到花儿都谢了！","怎么又断线了，网络怎么这么差啊！",
	"不要走，决战到天亮！","你的牌打得也太好了！","和你合作真是太愉快了！",
    "大家好，很高兴见到各位！","各位，真是不好意思，我得离开一会儿。","不要吵了，专心玩游戏吧！"}
    local parent = this.MP.saylist.transform;
    local bundle = resMgr:LoadBundle("sayBar");
    local Prefab = resMgr:LoadBundleAsset(bundle,"sayBar");
    local startY = 220
    local height = 0
	local len = #sayContent;
	for i = 1, len do
		local data = sayContent[i]
		local go = GameObject.Instantiate(Prefab);
		go.name = "sayBar"..i;
		go.transform.parent = parent;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(-117, startY - height, 0);
		resMgr:addAltas(go.transform,"Room")
		local saytxt = go.transform:Find('saytxt').gameObject;
		saytxt.name = "saytxt" .. i
		local saytxt_UILabel = saytxt:GetComponent('UILabel');
		this.LB:AddClick(saytxt, function ()
			this.MP.sendChat(data)
			this.MP.saydialog:SetActive(false)
		end);
		saytxt_UILabel.text = data
		local ph = saytxt_UILabel.height
		height = height + ph + 10
		-- table.insert(this._sayVec,go)
	end
    this.MP.sayCollider_UISprite.height = height
    this.LB:AddClick(this.MP.saydialog_close,function()
        this.MP.saydialog:SetActive(false)
    end)
end     
function mt.CreateHandCard(who,data)
    if not data then 
        return
    end 
    if not who then 
        return
    end 
    for k,v in pairs(data)do 
        local hand_data = this.GetCardData(who,v.posid,AREA_ID_HAND)
        if v.cardid then
            hand_data.card_id = v.cardid
        end 
        local go = this.CreateCard(hand_data)
        this.CheckGold(go,v.cardid)
    end 
    -- print ("----------------------who----------------------:",who)
    if who == 2 or who == 4 then 
        this.ClearUpCardDepth(this.card_list_2,18)
        this.ClearUpCardDepth(this.card_list_4)  
    end 
end 
-- return {{id,id,},}
function mt.Deal_Create_CPG_Data(data,type)
    local step = nil 
    if type == DO_TYPE_CHI or type == DO_TYPE_PENG then 
        step = 3
    elseif type == DO_TYPE_GANG then 
        step = 4
    end 
    local len = #data
    local info = {}
    if len > 0 then 
        local int_len,float_len = math.modf( len/step )
        if float_len == 0 then 
            for i = 1 , int_len do 
                local list = {}
                for j = step , 1, -1 do 
                    local va = i*step - j + 1
                    table.insert(list,data[va].id)
                end 
                table.insert(info,list)
            end 
        end 
    end 
    if #info > 0 then 
        return info 
    else 
        return nil 
    end 
end 
-- 一次性整理自己手牌
function mt.UpdateHandList(card_list,to_list)
    for posid,cardid in pairs(to_list)do 
        local obj = card_list[posid]
        repeat
            if not obj then 
                print("MJCTRL:UpdateHandList:NOT OBJ")
                break
            end 
        until true 
        local sprite_obj = obj.transform:Find("Sprite").gameObject
        sprite_obj:SetActive(true)
        local sprite =sprite_obj:GetComponent("UISprite")
        local sprite_name = this.sprite_name[cardid]
        sprite.spriteName = sprite_name
        -- this.CheckGold(obj,cardid)
    end 
end  
--更新房间标题
function mt.UpdataRoomLabel()
    -- if data and not data.bet_coin then 
    --     return
    -- end 
    local text = ""
    if this.roomid ~= nil then 
        if this.isGameRoom then 
            text = this.roomTitle.."\n每水金额："..this.bet_coin
        else 
            text = "普通/麻将/"..this.play_type.."人".."\n"..
            "房号:"..this.roomid.."\n每水金额："..this.bet_coin
        end        
    end 
    this.MP.room_label.text = text 
end   
--点亮金的标志
function mt.CheckGold(obj,cardid)
    
    if not this.goldid then 
        return 
    end 
    if cardid == this.goldid then
        local gold_obj = obj.transform:Find("Jing").gameObject
        if gold_obj then 
            gold_obj:SetActive(true)
        end 
    end 
end 
--更新头像信息
--[[
    data={
        player_name
        playerid
        head_imgurl
        player_money
        seatid
        is_prepare
    }   ]]
function mt.Update_Head(data)
    if not data then  
    end  
    local who = this.GetWhoBySeatid(data.seatid)
    local head_data = this.MP.GetHeadImage(who)
    if not head_data or get_len(head_data) <=0 then 
        return
    end 
    
    if data.player_name then 
        local name_text = GameData.GetShortName(data.player_name,6,6)
        head_data.player_name.text = name_text
    else 
        head_data.player_name.text = "玩家"
    end 
    -- this.test_label = data.head_imgurl
   
    if data.head_imgurl then 
        -- print ("=========头像框==========:",data.head_imgurl)
        head_data.obj:SetActive(false)
        head_data.AsyncImageDownload:SetAsyncImage(data.head_imgurl)
    else
        head_data.obj:SetActive(true)
    end 
    if data.player_money then 
        print ("===========money",data.player_money)
        local money = string.format("%0.2f",data.player_money)
        head_data.money_label.text = money
        head_data.money_obj:SetActive(true) 
    else 
        head_data.money_obj:SetActive(false) 
    end 
    if data.is_prepare then
        local prepare_data = {
            seatid = data.seatid,
            is_prepare = data.is_prepare
        }
        this.MP.UpdatePlayerPrepare(prepare_data)
    else 
        local prepare_data = {
            seatid = data.seatid,
            is_prepare = false
        }
        this.MP.UpdatePlayerPrepare(prepare_data)
    end 

    if data.type then 
        if data.type == BROADCAST_TYPE_EXIT then 
            if this.game_status ==  this.const.MJ_STATUS_END
            or this.game_status == this.const.MJ_STATUS_FREE then 
                head_data.tuo:SetActive(false)
                head_data.zhaung:SetActive(false)
                head_data.prepare_obj:SetActive(false)
            end 
        end 
    end 
end 
--更新金牌图像信息
function mt.UpdateGoldImage()
    if not this.goldid then 
        return
    end
    local spriteName = this.GetImageNameByID(this.goldid)
    this.MP.UpdateGoldImage(spriteName)
end 
--更新庄家头像信息
function mt.UpdateBankerHead(is_show)
    if not this.banker then 
        print ("MJCTRL:UpdateBankerHead:not banker")
        return
    end 
    local who = this.GetWhoBySeatid(this.banker.seatid)
    this.MP.UpdateBankerHead(who,is_show)
end 
-- 发牌
function mt.DealCard(card_list)
    this.co_render_cards = coroutine.create(function()
        this.RenderFuncCards(card_list)    
    end )
end 
-- 更新网络传输数据
function mt.Gen_Net_Data(data)
    -----------------WAIT----------------
    -- if data.dices then 
    --     this.dices = data.dices 
    -- end
    -----------------PREPARE-------------
    if data.hand_list then 
        this.hand_list = data.hand_list
    end 
    if data.deal_list then 
        this.deal_list = data.deal_list
    end 
    if data.add_flower_data then 
        this.add_flower_data =data.add_flower_data
    end 
    if data.flower_list then 
        this.flower_list = data.flower_list
    end 
    
    if data.goldid then 
        this.goldid = data.goldid 
    end 
    if data.banker then 
        this.banker = data.banker 
    end 
    -----------------PLAY-------------
    if data.play_seatid then 
        this.play_seatid = data.play_seatid
    else 
        this.play_seatid = nil 
    end 
    if data.angang_list then 
        this.angang_list = data.angang_list
    end 
    if data.drawCard_id and data.drawCard_id~=0  then 
        this.drawCard_id = data.drawCard_id
    else 
        this.drawCard_id = nil 
    end 
    if data.can_hu then 
        this.can_hu = data.can_hu
    else 
        this.can_hu = nil 
    end 
    if data.youjing_list then 
        this.youjing_list = data.youjing_list 
    end
    -----------------CPHG-------------
    if data.gang_list then 
        this.gang_list = data.gang_list
    end 
    if data.pen_list then 
        this.pen_list = data.pen_list
    end 
    if data.chi_list then 
        this.chi_list = data.chi_list
    end 
     
end 
-- 抬高手牌上的卡
function mt.UPHandCard(list)
    if list then 
        for posid,cardid in pairs (list)do 
            local go = this.GetCardObj(AREA_ID_HAND,this.WHO,posid)
            local to_data = this.GetBasicTwenData(go,BASIC_TWEEN_TYPE_POS)
            if not to_data then 
                return
            end 
            to_data.to.y = to_data.to.y + TWEEN_UP_WHO_1
            this.PosTweenAnima(go,to_data)
        end 
    end 
end 
--生成卡牌
--posID,bundel_name,parent,scale,pos,card_name,card_id,--list_id,out_list_id,rotation,
function mt.CreateCard(data)
    local str = data.bundle_name
    local bundle = resMgr:LoadBundle(str)
    local prefab = resMgr:LoadBundleAsset(bundle,str)
    -- local parent = data.parent 
    local go = GameObject.Instantiate(prefab)
    go.transform.parent = data.parent    
    go.transform.localScale = data.scale 
    go.transform.localPosition = data.pos
    if not data.rotation then
        go.transform.localRotation = Quaternion.Euler(Vector3.zero)
    else 
        local x = data.rotation.x
        local y = data.rotation.y
        local z = data.rotation.z 
        go.transform.localRotation = Quaternion.Euler(Vector3(x,y,z))
    end 
    go.name = data.card_name 
    resMgr:addAltas(go.transform,"MaJiang");
    local sprite_obj = nil 
    local list = data.list 
    ------暂时使用----------
    -- if data.posID == 17 then 
    --     local dealobj = list [data.posID]
    --     if dealobj then 
    --         list[data.posID]=nil
    --         panelMgr:ClearPrefab(dealobj)   
    --         dealobj:SetActive(false)      
    --     end 
    -- end 
    ---------------------
    list[data.posID]=go 
    -- if data.list_id   then
    if data.list_id <= 4 then  --手牌
        if data.list_id == 1 then 
            sprite_obj = go.transform:Find("Sprite")
            local sprite = sprite_obj:GetComponent("UISprite")
            sprite.spriteName = this.GetImageNameByID(data.card_id)
            -- if not this.card_list_1 then 
            --     this.card_list_1 = {}w
            -- end 
            if data.card_id and data.card_id > 10 then 
                this.LB:AddOnPress(go,this.PlayCard)
            end 
            -- this.card_list_1[data.posID]=go    
        elseif data.list_id == 2 then 
            -- if not this.card_list_2 then 
            --     this.card_list_2 = {}
            -- end 
            -- this.card_list_2[data.posID]=go
        elseif data.list_id == 3 then  
            -- if not this.card_list_3 then 
            --     this.card_list_3 = {}
            -- end         
            -- this.card_list_3[data.posID]=go
        elseif data.list_id == 4 then 
            -- if not this.card_list_4 then 
            --     this.card_list_4 = {}
            -- end 
            -- this.card_list_4[data.posID]=go
        end  
    elseif data.list_id >=5 and data.list_id<=8 then  --出牌区
        sprite_obj = go.transform:Find("Sprite")
        local sprite=sprite_obj:GetComponent("UISprite")
        sprite.spriteName = this.GetImageNameByID(data.card_id)
        if data.list_id == 5 then 
            -- if not this.out_card_list_1 then 
            --     this.out_card_list_1 = {}
            -- end 
            -- this.out_card_list_1[data.posID]=go
        elseif data.list_id == 6 then 
            sprite_obj.localRotation = Quaternion.Euler(Vector3(0,0,90))
        elseif data.list_id == 7 then  
            sprite_obj.localRotation = Quaternion.Euler(Vector3(0,0,180))
        elseif data.list_id == 8 then  
            -- if not this.out_card_list_1 then 
            --     this.out_card_list_1 = {}
            -- end 
            -- this.out_card_list_4[data.posID]=go
        end
        
    
    elseif data.list_id >=9 and data.list_id<=12 then --碰牌区
        local ming = go.transform:Find("Ming")
        local is_peng = false 
        if data.card_1 and data.card_2 and data.card_3 then --碰，吃
           
            local sprite_1 = ming.transform:Find("DI_1/Sprite"):GetComponent("UISprite")
            local sprite_2 = ming.transform:Find("DI_2/Sprite"):GetComponent("UISprite")
            local sprite_3 = ming.transform:Find("DI_3/Sprite"):GetComponent("UISprite")
            sprite_1.spriteName = this.GetImageNameByID(data.card_1) 
            sprite_2.spriteName = this.GetImageNameByID(data.card_2)
            sprite_3.spriteName = this.GetImageNameByID(data.card_3)
            if data.card_4 then 
                local DI_4 = ming.transform:Find("DI_4").gameObject
                DI_4:SetActive(true)
                local sprite_4 = DI_4.transform:Find("Sprite"):GetComponent("UISprite")
                sprite_4.spriteName = this.GetImageNameByID(data.card_4)
            else 
                if data.card_1 == data.card_2 and data.card_2 == data.card_3 then 
                    is_peng = true 
                end 
            end 
        else
            ming.gameObject:SetActive(false)
            local an = go.transform:Find("An").gameObject
            an:SetActive(true)
        end  
        if data.list_id == 9 then 
            if is_peng then 
                if not this.bu_peng_list_1 then 
                    this.bu_peng_list_1 = {}   
                end 
                this.bu_peng_list_1[data.card_1] = go 
            end 
        elseif data.list_id ==10 then 
            if is_peng then 
                if not this.bu_peng_list_2 then 
                    this.bu_peng_list_2 = {}   
                end 
                this.bu_peng_list_2[data.card_1] = go 
            end 
        elseif data.list_id ==11 then
            if is_peng then 
                if not this.bu_peng_list_3 then 
                    this.bu_peng_list_3 = {}   
                end 
                this.bu_peng_list_3[data.card_1] = go 
            end 
        elseif data.list_id ==12 then
            if is_peng then 
                if not this.bu_peng_list_4 then 
                    this.bu_peng_list_4 = {}   
                end 
                this.bu_peng_list_4[data.card_1] = go 
            end 
        end 
      
    elseif data.list_id >=13 and data.list_id<=16 then  --花区
        sprite_obj = go.transform:Find("Sprite")
        local sprite=sprite_obj:GetComponent("UISprite")
        sprite.spriteName = this.GetImageNameByID(data.card_id)
        if data.list_id == 13 then 
            -- this.pen_list_1[data.posID]=go             
        elseif data.list_id ==14 then 
            sprite_obj.transform.localRotation =  Quaternion.Euler(Vector3(0,0,90))
        elseif data.list_id ==15 then
            sprite_obj.transform.localRotation =  Quaternion.Euler(Vector3(0,0,180))  
        elseif data.list_id ==16 then
            -- this.pen_list_4[data.posID]=go  
        end 
    else --其他
       
    end 

    return go 
end 
--处理深度
function mt.ClearUpCardDepth(list,figure,who)    
    if not list then 
        return
    end      
    for id,v in pairs(list) do 
        local obj = list[id] or nil 
        
        local ret,errMessage = pcall(function()
            return obj.name 
        end)
        if ret then 
            -- print ("=======ClearUpCardDepth=======id:",id)

            local sprite = obj:GetComponent("UISprite")
            local chi_obj = obj.transform:Find("Sprite")
            local chi_sprite =nil 
            if chi_obj then
                chi_sprite = chi_obj:GetComponent("UISprite")
            end        
            if figure then 
                sprite.depth = math.abs(id-figure) 
            else 
                local va = id 
                if who and who == 1 then 
                    va = va + 30
                end 
                sprite.depth = va 
            end 
            if chi_sprite then 
                chi_sprite.depth = sprite.depth+1
            end
        else 
            -- print("-----------------------------------------")
            -- print ("报错，没有要改变深度的物体id :",id)     
            -- print ("报错，没有要改变深度的物体:",errMessage)            
        end 
                
    end 
end 
--出牌
function mt.PlayCard(obj,isPress)
    if this.is_play_card_anima then 
        -- print ("动画未播放结束")
        return
    end 
    if this.game_status == this.const.MJ_STATUS_YOUJING then 
        return
    end 
    if this.game_status ~= this.const.MJ_STATUS_PLAY then 
        return
    end 
    if this.anima_status ~= ANIMA_STATUS_FREE then 
        return
    end 
    local data = {
        time = 0.1,
        from = obj.transform.localPosition,
        to = obj.transform.localPosition,
    }
    data.to.y =  20
    this.cur_card = obj 
    this.isPress = isPress
    local posID = obj.name + 0 
    local cardid = this.GetCardidByObj(obj)
    if isPress then --按下
    else --抬起
        local y = obj.transform.localPosition.y 
        if y <= 21 then  -- 没有拖拽
            if this.last_card then
                if this.cur_card == this.last_card then 
                    --把牌打出去
                    if this.WHO == 1 then  --自己阶段才能出牌
                        this.is_play_card_anima = true
                        this.MP.PlayCard(posID,cardid)    
                    end              
                else   
                    this.ResetCardPos(this.last_card)
                    this.PosTweenAnima(obj,data) 
                    this.last_card = this.cur_card                   
                end 
            else 
                this.PosTweenAnima(obj,data)
                this.last_card = this.cur_card
            end 
        else 
            if this.last_card  then 
                if this.cur_card ~= this.last_card then 
                    this.ResetCardPos(this.last_card)
                end                 
            end 
            --把牌打出去
            if this.WHO == 1 then 
                this.is_play_card_anima = true
                this.MP.PlayCard(posID,cardid,function()
                    this.ResetCardPos(this.cur_card)
                end)   
            else 
                this.ResetCardPos(this.cur_card)
            end 
        end 
        this.press_time = 0
    end           
end 
--单张理牌 -- tar_id = nil 就整个移动
--who,tar_id,del_id   ,D_card_id
function mt.ClearUpCardList(data)    
    if not data then 
        return
    end 
    ----------------------数据整理----------------------
    local who = data.who
    local tar_id = nil 
    if data.tar_id then        
        tar_id = data.tar_id 
    else 
        tar_id= 0
    end     
    local del_id = data.del_id or nil 
    local list = this.GetCardList(AREA_ID_HAND,who) --area,who
    if list[17]== nil then --测试
        tar_id = 0 
    end 
    local drawCard = list[17] 
    -- local space = this.GetCardSpace(AREA_ID_HAND,who) 
    this.ClearCard(who,AREA_ID_HAND,del_id)
    if del_id == 17 then 
        -- if this.cur_card then 
        --     this.ResetCardPos(this.cur_card)
        --     this.cur_card = nil 
        -- end 
        if this.last_card then 
            this.ResetCardPos(this.last_card)        
            this.last_card = nil   
        end 
        this.is_play_card_anima = nil 
        this.clearup_data = nil 
        this.is_play_clearup_drawcard_anima = nil 
        -- this.is_play_clearup_anima = nil
        return --中途结束
    end 
    
    local m_list = {}
    if tar_id and del_id then
        local ab = tar_id - del_id 
        if ab >0 then --left
            for k,v in pairs(list)do
                if k > del_id and k<=tar_id then 
                    local m_data = {
                        id = k-1,
                        go = v,
                        -- posid = k,
                    }
                    table.insert(m_list,m_data)
                    -- list[k]=nil 
                end 
            end 
            -- space = space * (-1)
        else--right
            for k,v in pairs(list)do
                if k >= tar_id and k<del_id then 
                    local m_data = {
                        id = k+1,
                        go = v,
                        -- posid = k,
                    }
                    table.insert(m_list,m_data)
                    -- list[k]=nil 
                end 
            end
            -- space = space
        end
    elseif tar_id then --left
        for k,v in pairs(list)do
            if  k<=tar_id then 
                local m_data = {
                    id = k-1,
                    go = v,
                    -- posid = k,
                }
                table.insert(m_list,m_data)
                -- list[k]=nil 
            end 
        end 
        -- space = space * (-1)    
    end  
    ----------------------理牌动画----------------------
    local move_data= {
        -- time = BASICTWEN_TIMER,
        time = 0.05,
        from = Vector3.zero,
        to = Vector3.zero,
    }    
    local clearUpdata = {
        move_data = move_data,
        move_list = m_list ,
        who = who ,
        -- space = space,
    }
    -- if not this.is_play_clearup_anima then 
    --     if #m_list>=0 then 
    --         this.is_play_clearup_anima = true 
    --         this.ClearUpCardAnima(clearUpdata) -- 移动牌组
    --     end 
    --     --drawcard 动画
         
    --     if #m_list>=0 and drawCard~=nil then  -- 移动抽牌
    --         -- local cardid = this.GetCardidByObj(drawCard)
    --         -- this.ClearCard(who,AREA_ID_HAND,17)
            
    --         this.Play_Drawcard_Anima(move_data,who,tar_id,cardid)
    --     else 
    --         this.is_play_clearup_drawcard_anima = nil  
    --         this.clearup_data = nil 
    --         this.is_play_card_anima = nil   
    --     end 
    -- else 
    --     this.is_play_clearup_anima = true 
    --     global._view:Invoke(BASICTWEN_TIMER+0.3,function()
    --         if #m_list>=0 then 
    --             this.ClearUpCardAnima(clearUpdata) -- 移动牌组
    --         end 
    --         if #m_list>=0 and drawCard~=nil then  -- 移动抽牌
    --             -- local cardid = this.GetCardidByObj(drawCard)
    --             -- this.ClearCard(who,AREA_ID_HAND,17)
                
    --             this.Play_Drawcard_Anima(move_data,who,tar_id)
    --         else 
    --             this.is_play_clearup_drawcard_anima = nil 
    --             this.clearup_data = nil 
    --             this.is_play_card_anima = nil  
    --         end 
    --     end)

    -- end 
    if #m_list>=0 then 
        this.is_play_clearup_anima = true 
        this.ClearUpCardAnima(clearUpdata) -- 移动牌组

        -- this.AddClearUpAnima(clearUpdata)
    end 
    --drawcard 动画
     
    if #m_list>=0 and drawCard~=nil then  -- 移动抽牌
        -- local cardid = this.GetCardidByObj(drawCard)
        -- this.ClearCard(who,AREA_ID_HAND,17)
        
        this.Play_Drawcard_Anima(move_data,who,tar_id,cardid)
    else 
        this.is_play_clearup_drawcard_anima = nil  
        this.clearup_data = nil 
        this.is_play_card_anima = nil   
    end 
    -- if this.cur_card then 
    --     this.ResetCardPos(this.cur_card)
    --     this.cur_card = nil 
    -- end 
    -- if this.last_card then 
    --     this.ResetCardPos(this.last_card)        
    --     this.last_card = nil   
    -- end 
    -- this.cur_card = nil 
    -- this.last_card = nil      
end
function mt.Play_Drawcard_Anima(move_data,who,tar_id)
    local list = this.GetCardList(AREA_ID_HAND,who)
    -- local create_data = this.GetCardData(who,17,AREA_ID_HAND)
    -- create_data.card_id = cardid
    local drawCard = list[17] 
    -- local drawCard = this.CreateCard(create_data)
    local drawCard_y = nil 
    local figure = nil 
    local sign = 1 
    if who == 1 then
        drawCard_y = 120
    elseif who == 2 then 
        figure = 18 
        drawCard_y = 20
    elseif who == 3 then
        drawCard_y = 50 
        sign = -1
    elseif who == 4 then 
        drawCard_y = 20
        sign = -1
    end 
    local star_pos = this.GetCardStartPos(AREA_ID_HAND,who)
    local space = this.GetCardSpace(AREA_ID_HAND,who) 
    local tar_pos = star_pos - space*(16-tar_id)*sign 

    move_data.from = drawCard.transform.localPosition
    move_data.to = drawCard.transform.localPosition
    move_data.to.y = drawCard_y+move_data.to.y               
    -- if who ~= 1 then 
    --     local cl_depth_list = this.GetCardList(AREA_ID_HAND,who)
    --     this.ClearUpCardDepth(cl_depth_list,figure)
    -- end 

    local cl_depth_list = this.GetCardList(AREA_ID_HAND,who)
    -- print ("----------------------who----------------------:",who)
    this.ClearUpCardDepth(cl_depth_list,figure,who)

    this.PosTweenAnima(drawCard,move_data)--上升
    global._view:Invoke(move_data.time+0.1,function()
        local move_data_2 = this.GetBasicTwenData(drawCard,BASIC_TWEEN_TYPE_POS)            
        if who == 1 then
            move_data_2.to.x = tar_pos.x
        elseif who == 2 then 
        elseif who == 3 then 
        elseif who == 4 then 
        end
        this.PosTweenAnima(drawCard,move_data_2)--移动
    end)

    global._view:Invoke(move_data.time*2+0.1,function()
        if not drawCard then
            return 
        end 
        drawCard.name = tar_id
        list[tar_id] = drawCard
        list[17]=nil 
        local move_data_3 = this.GetBasicTwenData(drawCard,BASIC_TWEEN_TYPE_POS) 
        move_data_3.to = tar_pos 
        this.PosTweenAnima(drawCard,move_data_3)--下落
        if who == 1 then 
            this.PlaySound(this.const.AUDIO_MJ_CLICK)
        end 
        this.is_play_card_anima = nil
        this.clearup_data = nil 
        this.is_play_clearup_drawcard_anima = nil
    end )
end 
function mt.OnCPHGPress(list,isPress)
    if list then 
        if isPress then  
            -- 上升抬起
            for k,v in pairs (list)do 
                this.UPHandCard(v)
            end 

        else 
            -- 下降复原
            local star_y = this.GetCardStartPos(AREA_ID_HAND,this.WHO)
            for k,v in pairs (list)do 
                for posid,cardid in pairs (v)do 
                    if this.WHO then 
                        local go = this.GetCardObj(AREA_ID_HAND,this.WHO,posid)
                        if go then 
                            this.ResetCardPos(go)
                        end 
                    end 
                end 
            end 
        end 
    end 
end 
--101吃、102碰、103杠、104胡
function mt.PlaySound(str)
    if not str then 
        return
    end 
    soundMgr:PlaySound(str)
end 

function mt.DealResulText(data)
    local hu_type = data.hu_type
    local hand_list = data.hand_list
    local flower_list = data.flower_list
    local angang_len = data.angang_len
    local gang_len = data.gang_len
    local hu_cardid = data.hu_cardid
    local str = ""
    if hu_type == HU_TYPE_PING then
        str = str.."平胡X1  "
    elseif hu_type == HU_TYPE_SELF then 
        str = str.."自摸X2  "
    elseif hu_type == HU_TYPE_GOLD then 
        str = str.."游金X3  "
    end
    local gold_num = 0
    if hand_list then 
        for k,v in pairs (hand_list)do 
            if v.id == this.goldid then 
                gold_num = gold_num + 1
            end 
        end 
    end 
    -- if hu_cardid == this.goldid then 
    --     gold_num = gold_num + 1
    -- end 
    if hu_type == HU_TYPE_SELF or hu_type == HU_TYPE_GOLD  then 
        if hu_cardid == this.goldid then 
            gold_num = gold_num + 1
        end 
    end 
    if gold_num > 0 then 
        str = str.."金牌+"..gold_num.."  "
    end 
    if angang_len > 0 then 
        local  va = angang_len*2
        str = str.."暗杠+"..va.."  "
    end 
    if gang_len > 0 then 
        str = str.."明杠+"..gang_len.."  "
    end 
    if flower_list then 
        if #flower_list == 8 then 
            str = str.."纯花+4"
        elseif #flower_list >= 4 then
            local list = flower_list
            -- for k,v in pairs(flower_list)do 
            --     table.insert(list,v.id)
            -- end  
            table.sort(list,function(a,b)
                if a.id < b.id then 
                    return true 
                end 
            end )
            local len = #list 
            local c_f_len = 0
            for i = 1, len-3 do 
                local step = 1
                local j = i
                while true do 
                    local id_1 = list[j].id
                    local id_2 = list[j+1].id
                    if id_1 == id_2 - 1 then 
                        step = step + 1
                        if step > 3 then 
                            if id_2 == 4 or id_2 == 8 then 
                                c_f_len = c_f_len + 1
                            end 
                            break
                        end 
                        j = j +1 
                        if j >= len then
                            break
                        end  
                    else 
                        break 
                    end 
                end 
            end 
            if c_f_len > 0 then 
                str = str.."纯花+2"
            else 
                str = str.."乱花+1"
            end 
        end 
    end 
    return str 
end 

--播放特效
function mt.Play_Effect(who,effect_id)
    if this.is_play_effect_anima then 
        return
    end 
    local data =  this.GetEffectData(who,effect_id)
    if not data then 
        return
    end 
    this.is_play_effect_anima = true 
    if effect_id == EFFECT_ID_FLOWER then 
        this.PlaySound(this.const.SOUND_MJ_BUHUA)
    end 
    resMgr:addAltas(this.MP.cphg_effect.transform,"AnimaMJ") 
    this.MP.cphg_effect_sprite_obj.transform.localPosition = data.pos
    -- if this.game_status ~= this.const.MJ_STATUS_PREPARE then 
    --     this.MP.cphg_effect_sprite_obj.transform.localPosition = data.pos
    -- elseif effect_id == EFFECT_ID_FLOWER and this.game_status == this.const.MJ_STATUS_PREPARE then 
    --     this.MP.cphg_effect_sprite_obj.transform.localPosition = Vector3(0,-100,0)
    -- end 
    this.effect_str = data.str 
    this.effect_amount = data.amount
    this.on_play_effect = true     
end 
-- 特效动画图片更新
function mt.Update_Effect_Sprite()
    if not this.effect_str then 
        return
    end 
    if not this.effect_count then 
        return
    end 

    local str = this.effect_str .."".. this.effect_count 
    this.MP.cphg_effect_UIsprite.spriteName = str 
    this.MP.cphg_effect_UIsprite:MakePixelPerfect()
end

-------------------------------设置功能--------------------------------
--设置动画状态
function mt.SetAnimaStatus(status)
    if status == ANIMA_STATUS_FREE then 
        this.is_start_game = nil 
    elseif status == ANIMA_STATUS_DICES then 
        resMgr:addAltas(this.MP.dicesPanel.transform,"AnimaMJ")
        this.MP.dicesPanel:SetActive(true)
        this.MP.dices_anim:SetActive(true)
        this.MP.dices_result:SetActive(false)
        this.MP.dices_result.transform.localScale = Vector3.one 
    elseif status == ANIMA_STATUS_DEAL then 
        
    elseif status == ANIMA_STATUS_DRAW then 
        if this.WHO == 1 then  
            this.is_play_card_anima = true 
        end        
    elseif status == ANIMA_STATUS_ADD then 
        if this.WHO == 1 then  
            this.is_play_card_anima = true 
        end 
        this.is_play_addflwer_anima = true 
    elseif status == ANIMA_STATUS_OTHERADD then 
    elseif status == ANIMA_STATUS_GOLD then
        this.is_play_glod_anima = nil 
        this.Set_Gold()
    elseif status == ANIMA_STATUS_CLEARUP then 
        this.star_clearup_timer = true 
    elseif status == ANIMA_STATUS_CPHG then  
    elseif status == ANIMA_STATUS_END then 
        this.head_texture_list = nil 
    end 
    this.anima_status = status 
end 
--设置金牌
function mt.Set_Gold()
    resMgr:addAltas(this.MP.gold_effect.transform,"AnimaMJJing")
    if this.gold_effect_obj then 
        panelMgr:ClearPrefab(this.gold_effect_obj)
        this.gold_effect_obj = nil 
    end 
    local str = "Player_Card"
    local bundle = resMgr:LoadBundle(str)
    local prefab = resMgr:LoadBundleAsset(bundle,str)
    local go = GameObject.Instantiate(prefab)
    resMgr:addAltas(go.transform,"MaJiang")
    -- go:SetActive(false)
    go.transform.parent = this.MP.gold_eff_container.transform
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3(0,-20,0)
    local obj_sprite = go:GetComponent("UISprite")
    obj_sprite.depth = 20
    local sprite = go.transform:Find("Sprite"):GetComponent("UISprite")
    sprite.spriteName =  this.sprite_name[this.goldid]
    sprite.depth = 25
    this.gold_effect_obj = go  
    this.MP.gold_eff_container.transform.localPosition = Vector3.zero
    this.MP.gold_eff_container.transform.localScale = Vector3.one 
    local tp = this.MP.gold_eff_container:GetComponent("TweenPosition")
    tp.from = Vector3.zero
    tp.to = Vector3.zero
end 
--设置座位
--play_users
function mt.Set_Seat(data)
    local self_id = this.MP:GetPlayerID()    
    --设置座位顺序
    local is_find = nil 
    for k,v in pairs(data)do 
        if v.playerid == self_id then
            this.seatid = v.seatid 
            this.Set_Seat_Order(this.seatid)
            is_find = true 
            break
        end 
    end 
    -- 更新头像信息
    for k,v in pairs(data)do 
        this.Update_Head(v)
    end
end 
--设置座位顺序
function mt.Set_Seat_Order(seatid)
    this.seat_order = {}
    this.seat_order[seatid]=1
    local next = seatid + 1
    if this.play_type == TWO_PLAYER then     
        if next > TWO_PLAYER then 
            next = next - TWO_PLAYER 
        end 
        this.seat_order[next] = 3
    elseif this.play_type == THREE_PLAYER then 
        if next > THREE_PLAYER then 
            next = next - THREE_PLAYER
        end 
        this.seat_order[next] = 2 
        next = next + 1 
        if next > THREE_PLAYER then 
            next = next - THREE_PLAYER
        end 
        this.seat_order[next] = 3 
    elseif this.play_type == FOUR_PLAYER then
        if next > FOUR_PLAYER then 
            next = next - FOUR_PLAYER
        end 
        this.seat_order[next] = 2 
        next = next + 1 
        if next > FOUR_PLAYER then 
            next = next - FOUR_PLAYER
        end 
        this.seat_order[next] = 3 
        next = next + 1 
        if next > FOUR_PLAYER then 
            next = next - FOUR_PLAYER
        end 
        this.seat_order[next] = 4 
    end 
end 
--设置上一次游戏状态
function mt.SetLastGameStatus(game_status)

    this.last_game_status = game_status
end 
--设置结果庄家头像
this.head_texture_list = nil 
function mt.SetResultHead(go,data)    
    local head = go.transform:Find("Head").gameObject
    head:SetActive(true)
    --庄头像图片
    local head_imgurl = data.param1        
    if head_imgurl and head_imgurl~="" then 
        if not this.head_texture_list then 
            this.head_texture_list = {}
        end 
        local head_obj = head.transform:Find("Head").gameObject
        head_obj:SetActive(false)
        local head_texture_obj = head.transform:Find("Texture").gameObject
        head_texture_obj:SetActive(true)
        local head_texture = head_texture_obj:GetComponent("AsyncImageDownload") 
        local info = {
            texture = head_texture,
            head_imgurl = head_imgurl,
        }
        table.insert(this.head_texture_list,info)     
        -- head_texture:SetAsyncImage(head_imgurl)
        
    end 
    --庄标志
    local playerid = data.playerid 
    local zhuang_image = head.transform:Find("Zhuang").gameObject
    if playerid == this.banker.playerid then 
        zhuang_image:SetActive(true)
    else 
        zhuang_image:SetActive(false)
    end 
    --庄家名字
    local player_name = data.player_name
    local name_label = head.transform:Find("NameLabel"):GetComponent("UILabel")
    if player_name and player_name~="" then 
        player_name = GameData.GetShortName(player_name,6,6)
        name_label.text = player_name
    end 
end 
--设置结果金额
function mt.SetResultMoney(go,coin)
    local zf = nil 
    local value_obj = go.transform:Find("Value").gameObject
    value_obj:SetActive(true)
    -- local num = value_obj.transform:Find("num")
    -- local zf_image = num:Find("zf"):GetComponent("UISprite")
    local str = nil 
    local str_2 = nil 
    if coin > 0 then 
        -- zf = true 
        -- zf_image.spriteName = "z"
        str = "Z_Label"   
        str_2 = "+"     
    else 
        -- zf = false
        -- zf_image.spriteName = "f"
        str = "F_Label"
        str_2 = ""
    end 
    local label_obj = value_obj.transform:Find(str).gameObject
    label_obj:SetActive(true)
    local label = label_obj:GetComponent("UILabel");
    label.text = str_2..""..coin 
   
end 
--设置结果花牌
function mt.SetResultFlower(go,list)
    if not list then 
        return
    end 
    local len = #list 
    if len < 1 then 
        return 
    end 
    local f_list = list
    -- for k,v in pairs(list) do 
    --     _f_list[#_f_list+1] = v.id 
    --     -- table.insert(f_list,v.id)
    -- end 
    table.sort(f_list,function(a,b)
        if a.id < b.id then 
            return true 
        else 
            return false
        end 
    end)    
    local parent = go.transform:Find("FlowerList")
    local bundle = resMgr:LoadBundle("V_OutCard")
    local prefab = resMgr:LoadBundleAsset(bundle,"V_OutCard")
    local space = 67
    local space_2 = 12
    for i = 1, len do 
        local id = f_list[i].id     
        local f_obj = GameObject.Instantiate(prefab)
        local tr = f_obj.transform
        resMgr:addAltas(f_obj.transform,"MaJiang")
        tr.parent = parent
        tr.localScale = Vector3.one
        local star_pos = Vector3(-110,0,0)
        if i < 5 then 
            star_pos.x = star_pos.x + space*(i-1)
        else 
            star_pos.x = star_pos.x + space*(i-1) + space_2
        end 
        tr.localPosition = star_pos
        local sprite = f_obj.transform:Find("Sprite"):GetComponent("UISprite")
        local sprite_name = this.sprite_name[id]
        sprite.spriteName = sprite_name
    end 
end 
--设置结果CPHG
function mt.SetResultCPHG(go,list,type,cphg_len)
    if not list then 
        return 0
    end 
    local step = nil 
    if type == DO_TYPE_ANGANG or type == DO_TYPE_GANG then 
        step = 4
    elseif type == DO_TYPE_CHI or type == DO_TYPE_PENG then         
        step = 3 
    else 
        return 0
    end
    local len = #list 
    if len < 1 then 
        return 0
    end     
    --信息处理
    local int_len,float_len = math.modf( len/step )
    if float_len ~= 0 then 
        return 0
    end 
    local bundle = resMgr:LoadBundle("V_Pen")
    local prefab = resMgr:LoadBundleAsset(bundle,"V_Pen")
    local parent = go.transform:Find("Peng")
    local space = 110
    for i = 1 ,int_len do 
        local id_list = {}
        for j = step,1,-1 do 
            local va = i*step - j + 1 
            table.insert(id_list,list[va].id)
        end             
        local id = list[i].id 
        local obj = GameObject.Instantiate(prefab)    
        local tr = obj.transform
        resMgr:addAltas(obj.transform,"MaJiang")
        tr.parent = parent
        tr.localScale = Vector3.one * 0.5
        local star_pos = Vector3(-270,-30,0)
        star_pos.x = star_pos.x + space * (i+cphg_len-1)
        tr.localPosition = star_pos
        local ming_tr = tr:Find("Ming")
        local an_obj = tr:Find("An").gameObject
        for k,id in pairs(id_list)do 
            local str = "DI_"..k.."/Sprite"
            if type == DO_TYPE_ANGANG and k<4 then   
                ming_tr:Find(str).gameObject:SetActive(false)
                an_obj:SetActive(true)
            else 
                local sprite = ming_tr:Find(str):GetComponent("UISprite")
                local name = this.sprite_name[id]
                sprite.spriteName = name 
            end 
        end 
        if step == 4 then 
            ming_tr:Find("DI_4").gameObject:SetActive(true)
        end 
        
    end 
    return int_len
end 
--设置结果手牌
function mt.SetResultHand(go,list,cphg_len)
    if not list then 
        return
    end 
    local len = #list
    if len < 1 then 
        return
    end 
    if not go then 
        return
    end 
    if not cphg_len then 
        return
    end 
    local parent = go.transform:Find("CardList")
    local bundle = resMgr:LoadBundle("V_OutCard")
    local prefab = resMgr:LoadBundleAsset(bundle,"V_OutCard")
    local space = 67
    local star_x = -1079 + 220*cphg_len
    for i = 1,len do 
        local id = list[i].id 
        local obj = GameObject.Instantiate(prefab)
        resMgr:addAltas(obj.transform,"MaJiang")
        local tr = obj.transform
        tr.parent = parent
        obj.name = ""..i
        -- tr.localScale = Vector3.one*0.55
        tr.localScale = Vector3.one
        local star_pos = Vector3(star_x,-60,0)
        star_pos.x = star_pos.x + space*(i-1)
        tr.localPosition = star_pos
        local sprite = obj.transform:Find("Sprite"):GetComponent("UISprite")
        local sprite_name = this.sprite_name[id]
        sprite.spriteName = sprite_name
        this.CheckGold(obj,id)
    end 
end 
-------------------------------获取数据--------------------------------
--卡牌对应图标
function mt.GetImageNameByID(id)
    if not id then 
        print ("GetImageNameByID:error!!!!!!")
    end 
    return this.sprite_name[id]
end 
--通过座位号获取对应位置
function mt.GetWhoBySeatid(id)
    if id then 
        local who = this.seat_order[id]
        --测试用
        return who
    else 

        return nil 
    end 
end 
--area 1、手牌 2、出牌区、3碰牌区、4补花区
function mt.GetCardData(who,posID,area)
    local card_data = {       
        posID = posID,
        bundle_name =this.GetBundleName(area,who),
        parent = this.GetCardParent(area,who),
        pos = this.GetCardStartPos(area,who),
        scale = this.GetCardScale(area,who) ,
        card_name = posID,
        rotation = this.GetCardRotation(area,who),
        -- 1-4 手牌，5-8 出牌区，9-11 碰区 12-15 花区
        list_id = this.GetCardListID(area,who),
        list = this.GetCardList(area,who) ,       
        card_id = 1 ,--默认 外面赋值
    }
    if area == AREA_ID_HAND then --手牌
        local hand_space = this.GetCardSpace(AREA_ID_HAND,who)
        local space = nil
        if posID == 17 then 
            card_data.pos = this.GetDrawCardStartPos(who)
        else 
            if who == 1 then 
                space = hand_space.x 
            elseif who == 2 then 
                space = hand_space.y 
            elseif who == 3 then 
                space = hand_space.x * -1 
            elseif who == 4 then 
                space = hand_space.y * -1
            end 
            if who == 1 or who == 3 then 
                card_data.pos.x = card_data.pos.x - space*(16-posID)
            elseif who == 2 or who == 4 then 
                card_data.pos.y = card_data.pos.y - space*(16-posID)
            end 
        end 
    elseif area == AREA_ID_OUT then -- 出牌区
        local area_data = this.GetOutCardToAreaData(AREA_ID_OUT,who)
        card_data.posID = this.out_box_data.amount - area_data.len
        card_data.card_name = card_data.posID
        card_data.pos = area_data.card_pos
        -- card_data.to = area_data.to_pos
    elseif area == AREA_ID_FLOWER then -- 出牌区
        local area_data = this.GetOutCardToAreaData(AREA_ID_FLOWER,who)
        card_data.posID = 9
        card_data.posID = card_data.posID - area_data.len 
        card_data.card_name = card_data.posID
        card_data.pos = area_data.card_pos
    end 
    return card_data 
end 
--area 1、手牌 2、出牌区、3碰牌区、4补花区
function mt.GetBundleName(area,who)
    local bundle_name = {}
    if area == AREA_ID_HAND then 
        bundle_name = {[1]="Player_Card",[2]="Left_Card",[3]="Back_Card",[4]="Left_Card"}
    elseif area == AREA_ID_OUT or area == AREA_ID_FLOWER then 
        bundle_name = {[1]="V_OutCard",[2]="H_OutCard",[3]="V_OutCard",[4]="H_OutCard"}
    elseif area == AREA_ID_PEN then 
        bundle_name = {[1]="V_Pen",[2]="H_Pen",[3]="V_Pen",[4]="H_Pen",}
    end
    return bundle_name[who]
end
--area 1、手牌 2、出牌区、3碰牌区、4补花区
function mt.GetCardParent(area,who)
    local parent ={} 
    if area == AREA_ID_HAND then 
        parent = {
            [1]=this.MP.cardList_1,[2]=this.MP.cardList_2,
            [3]=this.MP.cardList_3,[4]=this.MP.cardList_4,
        }
    elseif area == AREA_ID_OUT then 
        parent = {
            [1]=this.MP.outcards_1,[2]=this.MP.outcards_2,
            [3]=this.MP.outcards_3,[4]=this.MP.outcards_4,
        }
    elseif area == AREA_ID_PEN then    
        parent = {
            [1]=this.MP.penList_1,[2]=this.MP.penList_2,
            [3]=this.MP.penList_3,[4]=this.MP.penList_4,
        }
    elseif area == AREA_ID_FLOWER then 
        parent = {
            [1]=this.MP.flowerList_1,[2]=this.MP.flowerList_2,
            [3]=this.MP.flowerList_3,[4]=this.MP.flowerList_4,
        } 
    -- elseif area == AREA_ID_CHAT then 
    --     parent = {
    --         [1]=this.MP.say_chat_1,[2]=this.MP.say_chat_2,
    --         [3]=this.MP.say_chat_3,[4]=this.MP.say_chat_4,
    --     } 
    end 
    return parent[who]
end 
--area 1、手牌 2、出牌区、3碰牌区、4补花区、5特效区、6聊天区
function mt.GetCardStartPos(area,who)
    local startPos = {}
    if area == AREA_ID_HAND then 
        startPos={
            [1]=Vector3(480,0,0),[2]= Vector3(0,175,0),
            [3]=Vector3(-275,0,0),[4]= Vector3(0,-175,0),
        }
    elseif area == AREA_ID_OUT then 
        box_data = this.out_box_data
        startPos={
            [1]=box_data.star_pos_1,[2]= box_data.star_pos_2,
            [3]=box_data.star_pos_3,[4]= box_data.star_pos_4,
        }
    elseif area == AREA_ID_PEN then 
        startPos={
            [1]=Vector3(-500,0,0),[2]= Vector3(0,-225,0),
            [3]=Vector3(300,0,0),[4]= Vector3(0,225,0),
        }
    elseif area == AREA_ID_FLOWER then 
        startPos={
            [1]=Vector3(-55,-25,0),[2]= Vector3(25,-50,0),
            [3]=Vector3(55,22,0),[4]= Vector3(-25,50,0),
        }
    elseif area == AREA_ID_EFFECT then 
        startPos={
            [1]=Vector3(0,-150,0),[2]= Vector3(300,0,0),
            [3]=Vector3(0,200,0),[4]= Vector3(-300,0,0),
        }
    elseif area == AREA_ID_CHAT then 
        startPos={
            [1]=Vector3(-400,-120,0),[2]= Vector3(180,70,0),
            [3]=Vector3(0,300,0),[4]= Vector3(-400,135,0),
        }
    end 
    if not startPos[who] then 
        print ("报错！没有对应的初始位置")
        return nil 
    end 
    local x = startPos[who].x
    local y = startPos[who].y
    return Vector3(x,y,0)
end 
--area 1、手牌 2、出牌区、3碰牌区、4补花区
function mt.GetCardScale(area,who)
    local scale = {}
    if area == AREA_ID_HAND then 
        return Vector3.one
    elseif area == AREA_ID_OUT then 
        scale={
            [1]=Vector3.one*0.55,[2]= Vector3.one,
            [3]=Vector3.one*0.55,[4]= Vector3.one,
        }
    elseif area == AREA_ID_PEN then 
        scale={
            [1]=Vector3.one,[2]= Vector3.one,
            [3]=Vector3.one*0.55,[4]= Vector3.one,
        }
    elseif area == AREA_ID_FLOWER then 
        scale={
            [1]=Vector3.one*0.55,[2]= Vector3.one,
            [3]=Vector3.one*0.55,[4]= Vector3.one,
        }
    end 
    if not scale[who] then 
        print ("报错！没有对应的scale")
        return nil 
    end 
    local x = scale[who].x
    local y = scale[who].y
    return Vector3(x,y,0)
end    
--area 1、手牌 2、出牌区、3碰牌区、4补花区
function mt.GetCardRotation(area,who)
    local rotation = {}
    if area == AREA_ID_HAND then 
        rotation={
            [1]=Vector3.zero,[2]= Vector3(0,180,0),
            [3]=Vector3.zero,[4]=Vector3.zero,
        }
    elseif area == AREA_ID_OUT then 
        return Vector3.zero
    elseif area == AREA_ID_PEN then 
        return Vector3.zero
    elseif area == AREA_ID_FLOWER then 
        return Vector3.zero
    end 
    if not rotation[who] then 
        print ("报错！没有对应的初始角度")
        return nil 
    end 
    local x = rotation[who].x 
    local y = rotation[who].y 
    return Vector3(x,y,0)
end
--area 1、手牌 2、出牌区、3碰牌区、4补花区 、6聊天区
function mt.GetCardList(area,who)
    if not who then 
        return nil 
    end 
    if area == AREA_ID_HAND then        
        if who == 1 then 
            if this.card_list_1 ==nil then 
                this.card_list_1 = {}
            end 
            return this.card_list_1
        elseif who ==  2 then 
            if this.card_list_2 ==nil then 
                this.card_list_2 = {}
            end 
            return this.card_list_2
        elseif who ==  3 then 
            if this.card_list_3 ==nil then 
                this.card_list_3 = {}
            end 
            return this.card_list_3
        elseif who ==  4 then 
            if this.card_list_4 ==nil then 
                this.card_list_4 = {}
            end 
            return this.card_list_4
        end      
    elseif area == AREA_ID_OUT then 
        if who == 1 then 
            if this.out_card_list_1 ==nil then 
                this.out_card_list_1 = {}
            end 
            return this.out_card_list_1
        elseif who ==  2 then 
            if this.out_card_list_2 ==nil then 
                this.out_card_list_2 = {}
            end 
            return this.out_card_list_2
        elseif who ==  3 then 
            if this.out_card_list_3 ==nil then 
                this.out_card_list_3 = {}
            end 
            return this.out_card_list_3
        elseif who ==  4 then 
            if this.out_card_list_4 ==nil then 
                this.out_card_list_4 = {}
            end 
            return this.out_card_list_4
        end 
    elseif area == AREA_ID_PEN then
        if who == 1 then 
            if this.pen_list_1 ==nil then 
                this.pen_list_1 = {}
            end 
            return this.pen_list_1
        elseif who ==  2 then 
            if this.pen_list_2 ==nil then 
                this.pen_list_2 = {}
            end 
            return this.pen_list_2
        elseif who ==  3 then 
            if this.pen_list_3 ==nil then 
                this.pen_list_3 = {}
            end 
            return this.pen_list_3
        elseif who ==  4 then 
            if this.pen_list_4 ==nil then 
                this.pen_list_4 = {}
            end 
            return this.pen_list_4
        end 
    elseif area == AREA_ID_FLOWER then 
        if who == 1 then 
            if this.flower_List_1 ==nil then 
                this.flower_List_1 = {}
            end 
            return this.flower_List_1
        elseif who ==  2 then 
            if this.flower_List_2 ==nil then 
                this.flower_List_2 = {}
            end 
            return this.flower_List_2
        elseif who ==  3 then 
            if this.flower_List_3 ==nil then 
                this.flower_List_3 = {}
            end 
            return this.flower_List_3
        elseif who ==  4 then 
            if this.flower_List_4 ==nil then 
                this.flower_List_4 = {}
            end 
            return this.flower_List_4
        end 
    elseif area == AREA_ID_CHAT then 
        if who == 1 then 
            if this.chat_list_1 ==nil then 
                this.chat_list_1 = {}
            end 
            return this.chat_list_1
        elseif who ==  2 then 
            if this.chat_list_2 ==nil then 
                this.chat_list_2 = {}
            end 
            return this.chat_list_2
        elseif who ==  3 then 
            if this.chat_list_3 ==nil then 
                this.chat_list_3 = {}
            end 
            return this.chat_list_3
        elseif who ==  4 then 
            if this.chat_list_4 ==nil then 
                this.chat_list_4 = {}
            end 
            return this.chat_list_4
        end 
    end 
    print("报错，没有找到对应的列表:area:"..area.."who:"..who)
    return nil 
end 
--area 1、手牌 2、出牌区、3碰牌区、4补花区
function mt.GetCardListID(area,who)
    local id = {}
    if area ==AREA_ID_HAND then 
        id = {
            [1]=1,[2]=2,[3]=3,[4]=4,
        }
    elseif area ==AREA_ID_OUT then
        id = {
            [1]=5,[2]=6,[3]=7,[4]=8,
        } 
    elseif area ==AREA_ID_PEN then 
        id = {
            [1]=9,[2]=10,[3]=11,[4]=12,
        }
    elseif area ==AREA_ID_FLOWER then 
        id = {
            [1]=13,[2]=14,[3]=15,[4]=16,
        }
    end 
    return id[who]
end 
--area 1、手牌 2、出牌区、3碰牌区、4补花区
function mt.GetCardObj(area,who,posID)
    local list = this.GetCardList(area,who)
    if list then 
        local card = list[posID] or nil 
        if not card then            
            -- print ("报错,没有对应位置的卡,who:"..who.."posid:"..posID.."area:"..area)
            -- pinrt(card.name)
            return nil
        end 
        return card 
    end 
    return nil 
end 
--area 1、手牌 2、出牌区、3碰牌区、4补花区、6聊天区
function mt.GetCardSpace(area,who)
    local space = {}
    if area == AREA_ID_HAND then 
        space = {
            [1]=Vector3(70,0,0),[2]=Vector3(0,25,0),
            [3]=Vector3(36,0,0),[4]=Vector3(0,27,0),
        }
    elseif area == AREA_ID_OUT then 
        space = {
            [1]=Vector3(38,45,0),[2]=Vector3(50,30,0),
            [3]=Vector3(38,45,0),[4]=Vector3(50,25,0),
        }
    elseif area == AREA_ID_PEN then
        space = {
            [1]=Vector3(220,0,0),[2]=Vector3(0,100,0),
            [3]=Vector3(115,0,0),[4]=Vector3(0,100,0),
        }
    elseif area == AREA_ID_FLOWER then
        space = {
            [1]=Vector3(40,45,0),[2]=Vector3(50,35,0),
            [3]=Vector3(40,45,0),[4]=Vector3(50,35,0),
        }
    elseif area == AREA_ID_CHAT then 
        space = {
            [1]=Vector3(0,70,0),[2]=Vector3(0,70,0),
            [3]=Vector3(0,70,0),[4]=Vector3(0,70,0),
        }
    end 
    if not space[who]then 
        print ("报错，没有对应的间距")
        return nil 
    end 
    local x = space[who].x 
    local y = space[who].y 
    return Vector3(x,y,0)
end 
-- type 1 pos, 2 scale
function mt.GetBasicTwenData(go,type)
    if not go then 
        return nil 
    end 
    local data = {
        time =BASICTWEN_TIMER,
        from = nil,
        to = nil,
        delay = nil  ,
    }
    if type == BASIC_TWEEN_TYPE_POS then 
        data.from = go.transform.localPosition or Vector3.zero
        data.to = go.transform.localPosition or Vector3.zero
    elseif type == BASIC_TWEEN_TYPE_SCALE then 
        data.from = go.transform.localScale or Vector3.zero
        data.to = go.transform.localScale or Vector3.zero
    end 
    return data 
end 
-- type 1 angang, 2 chi
--return data = {BG,card}
--BG={size}
--card={pos1,pos2,pos3,pos4}
function mt.GetShowCardPanelData(type,value)    
    local data = {}
    data.BG = {}
    data.card = {}
    if type == SHOWCARD_TYPE_ANGANG then  
        if value == 1 then 
            data.BG.size = Vector3(350,110,0)
            data.card[1] = Vector3(-145,-55,0)
        elseif value == 2 then 
            data.BG.size = Vector3(630,110,0)
            data.card[1] = Vector3(-145,-55,0)
            data.card[2] = Vector3(-430,-55,0)
        elseif value == 3 then 
            data.BG.size = Vector3(630,220,0)
            data.card[1] = Vector3(-145,-55,0)
            data.card[2] = Vector3(-430,-55,0)
            data.card[3] = Vector3(-430,-160,0)
        elseif value == 4 then 
            data.BG.size = Vector3(630,220,0)
            data.card[1] = Vector3(-145,-55,0)
            data.card[2] = Vector3(-430,-55,0)
            data.card[3] = Vector3(-430,-160,0)
            data.card[4] = Vector3(-145,-160,0)
        else 
            print("============MJMGR:GetShowCardPanelData:超出范围===============")
            return nil 
        end 
        data.bundel_name="ShowCard"
        data.text = "暗杠"
    elseif type == SHOWCARD_TYPE_CHI then
        if value == 1 then 
            data.BG.size = Vector2(280,110)
            data.card[1] = Vector3(-105,-55,0)
        elseif value == 2 then 
            data.BG.size = Vector2(490,110)
            data.card[1] = Vector3(-105,-55,0)
            data.card[2] = Vector3(-315,-55,0)
        elseif value == 3 then 
            data.BG.size = Vector2(700,110)
            data.card[1] = Vector3(-105,-55,0)
            data.card[2] = Vector3(-315,-55,0)
            data.card[3] = Vector3(-525,-55,0)
        else
            print("============MJMGR:GetShowCardPanelData:超出范围===============")
            return nil 
        end 
        data.bundel_name="V_Pen"
        data.text = "吃牌"

        -- data.bundel_name="Player_Card"
        -- data.text = "吃牌"
        -- data.BG.size = Vector2(190,110)
        -- data.card[1] = Vector3(-65,-55,0)
    elseif type == SHOWCARD_TYPE_YOUJING then
        local space = 80
        local basic_bg =  Vector2(150,110)
        basic_bg.x = basic_bg.x +(value -1)*space
        data.BG.size = basic_bg
        for i = 1, value do 
            local pos =Vector3(-45,-55,0)
            pos.x = pos.x - (i-1)*space
            data.card[i] = pos 
        end

        data.bundel_name="Player_Card"
        data.text = "游金"
    else 
        print("============MJMGR:GetShowCardPanelData:超出范围===============")
        return nil 
    end 
    return data
end 
--area  2、出牌区、3碰牌区、4补花区
function mt.GetOutCardAmountLen(area,who)
    local len = {}
    if area == AREA_ID_OUT then 
        local box_data=this.out_box_data
        len = {
            [1]=box_data.len_1,[2]=box_data.len_2,
            [3]=box_data.len_3,[4]=box_data.len_4,
        }
    elseif area == AREA_ID_PEN then 
        return 4
    elseif area == AREA_ID_FLOWER then 
        return 4 
    end      
    if not len[who] then 
        print ("报错！没有对应的总长度")
    end 
    return len[who]
end 
function mt.GetDrawCardStartPos(who)
    local pos = nil 
    if who == 1 then 
        pos = Vector3(570,0,0)
    elseif who == 2 then 
        pos = Vector3(0,240,0)
    elseif who == 3 then 
        pos = Vector3(-330,0,0)
    elseif who == 4 then 
        pos = Vector3(0,-240,0)
    end 
    if not pos then 
        print("报错，没有对应的初始位置")
    end 
    return pos 
end 
--获取补花信息
-- add_flower_data = {[posid]={{poscard_id,addcard_id},}
--return{[i]={[posid]={cardid,cardid}}} 
function mt.GetAddFlowerData()
    if not this.add_flower_data then 
        print ("MJMGR:GetAddFlowerData:NOT ADD FLOWER DATA")
    end 
    local max_len = 0 
    for posid,v in pairs(this.add_flower_data)do 
        if get_len(v) > max_len then 
            max_len = get_len(v)
        end 
    end 
    local add_data = {}
    if max_len > 0 then 
        for i= 1 ,max_len do
            add_data[i]={}
            for posid,v in pairs(this.add_flower_data)do 
                if v[i] then 
                    local poscard_id = v[i].poscard_id
                    local addcard_id = v[i].addcard_id
                    add_data[i][posid]={
                        poscard_id =poscard_id,
                        addcard_id =addcard_id,
                    }
                end 
            end                      
        end 
    end   
    return add_data
end 
--获取出牌区域位置
-- return len , create_card_pos , to_pos 
function mt.GetOutCardToAreaData(area,who)
    local len = 1 
    local amount = 1 
    local area_list = this.GetCardList(area,who)
    local card_list = this.GetCardList(AREA_ID_HAND,who)
    for k,v in pairs(area_list)do 
        len = len +1 
    end 
    amount = len
    local vector3_space = this.GetCardSpace(area,who)
    local space_x = vector3_space.x 
    local space_y = vector3_space.y 
    local len_amount = this.GetOutCardAmountLen(area,who)
    local star_pos = this.GetCardStartPos(area,who)
    local area_list_pos = this.GetCardParent(area,who).localPosition
    -- print("area_list_pos",area_list_pos.name)
    local card_list_pos = this.GetCardParent(AREA_ID_HAND,who).localPosition
    local def_pos = area_list_pos - card_list_pos
    local sign = 1 
    if area == AREA_ID_FLOWER   then 
        sign = -1 
    end 
    local card_x = nil
    local card_y = nil
    if who == 1  or who == 3 then 
        if len <= len_amount then 
            space_y = 0         
        elseif len <= len_amount*2 then 
            len = len - len_amount
            space_y = space_y
        else 
            len = len - len_amount*2
            space_y = space_y*2
        end 
        if who == 1 then 
            card_x = star_pos.x + space_x*(len-1)
            card_y = star_pos.y -space_y*sign
        else 
            card_x = star_pos.x - space_x*(len-1)
            card_y = star_pos.y +space_y*sign
        end 
        
    else 
        if who == 2 or who == 4 then 
            if len <= len_amount then 
                space_x = 0         
            elseif len <= len_amount*2 then 
                len = len - len_amount
                space_x = space_x
            else 
                len = len - len_amount*2
                space_x = space_x*2
            end 
            if who == 2 then   
                card_y = star_pos.y + space_y*(len-1)
                card_x = star_pos.x +space_x*sign
            else
                card_y = star_pos.y - space_y*(len-1)
                card_x = star_pos.x -space_x*sign
            end 
           
        end 
    end     
    -- local card_x = star_pos.x - space_x*(len-1)*sign
    -- local card_y = star_pos.y -space_y*sign
    local to_pos = Vector3(card_x+def_pos.x,card_y+def_pos.y,0)
    local to_area_data = {
        len = amount ,
        card_pos = Vector3(card_x,card_y,0),
        to_pos = to_pos,        
    }  
    return to_area_data
end
--获取上升高度
function mt.GetCardUpToPos(who)
    local up_y = nil 
    if who ==1 then        
        up_y=80
    elseif who == 2 then 
        up_y=20
    elseif who == 3 then 
        up_y=50
    elseif who == 4 then 
        up_y=20
    end 
    return up_y
end 
function mt.GetCardidByObj(obj)
    local sprite_obj = obj.transform:Find("Sprite")    
    if sprite_obj then 
        local sprite = sprite_obj:GetComponent("UISprite")
        if sprite then 
            local name = sprite.spriteName
            local cardid = nil 
            for id,v in pairs (this.sprite_name)do 
                if name == v then 
                    cardid = id 
                    break
                end 
            end 
            if cardid then 
                return cardid 
            end 
        end 
    end 
    print("!!!!!!!!!!MJCTRL:GetCardidByObj:NOT FIND CARDID")
    return nil 
end 
-- 获取特效数据
function mt.GetEffectData(who,effect_id)
    local str = nil 
    local amount = nil 
    if effect_id == EFFECT_ID_FLOWER then 
        str = "buhua_"
        amount = 11
    elseif effect_id == EFFECT_ID_CHI then 
        str = "chi_"
        amount = 6
    elseif effect_id == EFFECT_ID_PENG then
        str = "peng_"
        amount = 6
    elseif effect_id == EFFECT_ID_HU then
        str = "hudonghua_"
        amount = 6
    elseif effect_id == EFFECT_ID_GANG then
        str = "gang_"
        amount = 6
    elseif effect_id == EFFECT_ID_YOUJING then
        str = "youjing_"
        amount = 6
    end 
    local pos = this.GetCardStartPos(AREA_ID_EFFECT,who)
    local data = {}
    if str and pos then 
        data.str = str 
        data.amount = amount
        data.pos = pos 
    else 
        return nil 
    end     
    return data
end 

function mt.GetChatData(who)
    local data = this.MP.GetChatObjData(who)
    if not data then 
        return nil 
    end     
    local list = this.GetCardList(AREA_ID_CHAT,who)
    local space = this.GetCardSpace(AREA_ID_CHAT,who)
    local star_pos =  this.GetCardStartPos(AREA_ID_CHAT,who)
    local bundel_name = nil 
    local collider = nil 
    local label_star_pos = nil 
    if who == 1 then 
        data.timer = this.chat_timer_1
        bundel_name = "MJ_Chat_Bar_L"
        collider = this.MP.say_collider_1
        label_star_pos = Vector3(-220,15,0)
    elseif who ==  2 then 
        data.timer = this.chat_timer_2
        bundel_name = "MJ_Chat_Bar_R"
        collider = this.MP.say_collider_2
        label_star_pos = Vector3(220,15,0)
    elseif who == 3 then 
        data.timer = this.chat_timer_3
        bundel_name = "MJ_Chat_Bar_R"
        collider = this.MP.say_collider_3
        label_star_pos = Vector3(220,15,0)
    elseif who == 4 then 
        data.timer = this.chat_timer_4
        bundel_name = "MJ_Chat_Bar_L"
        collider = this.MP.say_collider_4
        label_star_pos = Vector3(-220,15,0)
    else 
        return nil 
    end 
    data.list = list
    data.space = space
    data.star_pos = star_pos 
    data.bundel_name = bundel_name 
    data.collider = collider
    data.label_star_pos = label_star_pos
    -- print("==================timer:",data.timer)
    return data 
end 

-------------------------------回调--------------------------------

function mt.PlayOutCardCallBack(data)
    local who = this.GetWhoBySeatid(data.seatid)
    local list = this.GetCardList(AREA_ID_HAND,who)
    if data.youjing_seatid then 
        local tar_posid = 18
        --消除尾巴牌
        for posid,obj in pairs (list)do 
            if posid < tar_posid then 
                tar_posid = posid
            end 
        end 
        local gold_obj = list[tar_posid]
       this.OnYouJingPlayCallBack(data,gold_obj)
       list[tar_posid] = nil 
    end 
    local posID = data.posid
   
    local obj = this.GetCardObj(AREA_ID_HAND,who,posID)   
    data.obj = obj 
    list[posID] = nil 
    if this.cur_card then 
        this.ResetCardPos(this.cur_card)        
        this.cur_card = nil   
    end 
    if this.last_card then 
        this.ResetCardPos(this.last_card)        
        this.last_card = nil   
    end 
    this.play_out_card_data = data 
end 

--抽卡
function mt.DrawCard()
    local who = this.WHO
    local list = this.GetCardList(AREA_ID_HAND,who)
  
    local posid = 17
    local card_data = this.GetCardData(who,posid,AREA_ID_HAND)
    -- card_data.pos = this.GetDrawCardStartPos(who)
    if this.KeyCode then 
        -- card_data.card_id = math.random(21,29)--测试
    elseif who == 1 and this.game_status == this.const.MJ_STATUS_PREPARE then 
        if list[17]~=nil then 
            print ("已经抽牌过")
            return
        end
        card_data.card_id = this.deal_list[17]
    elseif who == 1 and this.game_status ~= this.const.MJ_STATUS_PREPARE then 
        if this.is_start_game and this.is_start_game == this.const.MJ_STATUS_PREPARE then 
            if list[17]~=nil then 
                print ("已经抽牌过")
                return
            end
            card_data.card_id = this.deal_list[17]
        else 
            card_data.card_id = this.drawCard_id
        end 
    end   
    local go = nil
    if who == 1 then 
        card_data.pos.y = 90        
    elseif who == 2 then 
    elseif who == 3 then
    elseif who == 4 then
    end     
    go = this.CreateCard(card_data)
    if this.game_status ~= this.const.MJ_STATUS_PREPARE then 
        this.CheckGold(go,card_data.card_id)
    end 
    local to_data = this.GetBasicTwenData(go,1)
    to_data.to = this.GetDrawCardStartPos(who)
    local tr = go:GetComponent("TweenRotation")
    tr.duration = to_data.time 
    if who == 1 then 
        tr:ResetToBeginning()
        tr.enabled = true 
    end  
    local info = {
        data = nil ,
        time = 0 ,
        count = 1 ,
        id = FUN_ID_DRAW,
    }
    this.AddCallFunByTimer(info,function()
        this.PosTweenAnima(go,to_data)
    end,function()
        global._view:Invoke(to_data.time,function()
            this.OnAnimaStatus(ANIMA_STATUS_DRAW)
        end)        
    end )   
    -- this.PosTweenAnima(go,to_data)
    -- this.OnAnimaStatus(ANIMA_STATUS_DRAW)    
end 
--更新按钮
--data={{id},} 1chi 2gang  3hu  4pen 5angang
function mt.ShowPlayBtn()
    -- if this.play_out_card_data then --防止被关闭
    --     return
    -- end 
    this.OnAnimaStatus(ANIMA_STATUS_CPHG)
    if this.cur_card then 
        this.ResetCardPos(this.cur_card)
        this.cur_card = nil 
    end 
    if this.last_card then 
        this.ResetCardPos(this.last_card)        
        this.last_card = nil   
    end 
    -- this.ClosePlayBtn()  
    this.ShowPlay_Reset()
    local btn_list = {}  
    --胡
    if this.can_hu then 
        table.insert(btn_list,{id=3})
    end 
    --暗杠
    if this.angang_list then 
        table.insert(btn_list,{id=5})
    end 
    --明杠
    if this.gang_list then 
        table.insert(btn_list,{id=2})
    end 
    --碰
    if this.pen_list then 
        table.insert(btn_list,{id=4})
    end 
    --吃
    if this.chi_list then
        table.insert(btn_list,{id=1})
    end 
    --游金
    if this.youjing_list then 
        table.insert(btn_list,{id=6})
    end 
    if #btn_list>0 then 
        this.MP.passBtn:SetActive(true)
        this.MP.play_returnBtn:SetActive(false)
        this.UpdatePlayBtn(btn_list)
    end 
    
end 
--显示CPHG信息面板
function mt.ShowCPHGPanel(data,type)
    if not data then 
        return
    end 
    this.ClosePlayBtn()
    this.MP.passBtn:SetActive(false)
    this.MP.play_returnBtn:SetActive(true)
    this.MP.showCardPanel.gameObject:SetActive(true)

    local text = data.text
    this.MP.showCardPanel_lable.text = text 
    local bg = data.BG
    if bg then 
        local bg_sprite = this.MP.showCardPanel_bg:GetComponent("UISprite")
        bg_sprite.height = bg.size.y 
        bg_sprite.width = bg.size.x
    end 
    local bundel_name = data.bundel_name
    local card_pos_list = data.card
    if card_pos_list then 
        for k,v in pairs(card_pos_list)do 
            local bundle = resMgr:LoadBundle(bundel_name)
            local prefab = resMgr:LoadBundleAsset(bundle,bundel_name)
            local go = GameObject.Instantiate(prefab)
            resMgr:addAltas(go.transform,"MaJiang")
            go.transform.parent = this.MP.showCardPanel_bg
            go.transform.localScale = Vector3.one 
            go.transform.localPosition = v 
            go.name = k 
            local widget = go:GetComponent("UIWidget")
            widget.depth = 20
            local id_list = data.card_id_list[k]
            if type == SHOWCARD_TYPE_ANGANG then 
                local di_1_sprite = go.transform:Find("DI_1/Sprite"):GetComponent("UISprite")
                di_1_sprite.spriteName = this.sprite_name[id_list[1]]
                local di_2_sprite = go.transform:Find("DI_2/Sprite"):GetComponent("UISprite")
                di_2_sprite.spriteName = this.sprite_name[id_list[2]]
                local di_3_sprite = go.transform:Find("DI_3/Sprite"):GetComponent("UISprite")
                di_3_sprite.spriteName = this.sprite_name[id_list[3]]
                local di_4_sprite = go.transform:Find("DI_4/Sprite"):GetComponent("UISprite")
                di_4_sprite.spriteName = this.sprite_name[id_list[4]]
                this.LB:AddClick(go,function()
                    this.MP.AnGang(k)--第几组暗杠标记
                end)
                local gang_list = this.angang_list[k]
                if not this.cphg_pre_list then 
                    this.cphg_pre_list = {}
                end 
                this.cphg_pre_list[k]=gang_list
                this.LB:AddOnPress(go,this.ShowPanelPress)
            elseif type == SHOWCARD_TYPE_CHI then 
                local di_1_sprite = go.transform:Find("Ming/DI_1/Sprite"):GetComponent("UISprite")
                di_1_sprite.spriteName = this.sprite_name[id_list[1]]
                local di_2_sprite = go.transform:Find("Ming/DI_2/Sprite"):GetComponent("UISprite")
                di_2_sprite.spriteName = this.sprite_name[id_list[2]]
                local di_3_sprite = go.transform:Find("Ming/DI_3/Sprite"):GetComponent("UISprite")
                di_3_sprite.spriteName = this.sprite_name[id_list[3]]            
                
                this.LB:AddClick(go,function()
                    this.MP.CHI(k)
                end)
                local chi_list = this.chi_list[k]
                if not this.cphg_pre_list then 
                    this.cphg_pre_list = {}
                end 
                this.cphg_pre_list[k]=chi_list
                this.LB:AddOnPress(go,this.ShowPanelPress)
                local di_obj = nil 
                if id_list[1] == data.out_cardid then 
                    di_obj = go.transform:Find("Ming/DI_1").gameObject
                elseif id_list[2] == data.out_cardid then
                    di_obj = go.transform:Find("Ming/DI_2").gameObject 
                elseif id_list[3] == data.out_cardid then 
                    di_obj = go.transform:Find("Ming/DI_3").gameObject                     
                end 
                if di_obj then 
                    di_obj.transform:Find("warn").gameObject:SetActive(true)
                end    
            elseif type == SHOWCARD_TYPE_YOUJING then 
                local sprite = go.transform:Find("Sprite"):GetComponent("UISprite")
                sprite.spriteName = this.sprite_name[id_list[1]]
                sprite.depth = 25
                local posid = data.posid_list[k][1]
                this.LB:AddClick(go,function()
                    this.MP.YOUJING(posid)
                end)
                local youjing_list={}
                youjing_list[posid]= this.youjing_list[posid]
                if not this.cphg_pre_list then 
                    this.cphg_pre_list = {}
                end 
                this.cphg_pre_list[k]=youjing_list
                this.LB:AddOnPress(go,this.ShowPanelPress)
            end 
            
            if not this.show_cphg_message_list then 
                this.show_cphg_message_list = {}
            end 
            table.insert(this.show_cphg_message_list,go)           
        end 
    end 
end   
function mt.ShowWarn(data,is_show)
    this.ClosePlayBtn()
    if is_show then 
        this.MP.passBtn:SetActive(false)
        this.MP.play_returnBtn:SetActive(true)
        this.MP.showCardPanel.gameObject:SetActive(true)
        local text = data.text
        this.MP.showCardPanel_lable.text = text 
        local bg = data.BG
        if bg then 
            local bg_sprite = this.MP.showCardPanel_bg:GetComponent("UISprite")
            bg_sprite.height = bg.size.y 
            bg_sprite.width = bg.size.x
        end
        local bundel_name = data.bundel_name
        local card_pos_list = data.card
        if card_pos_list then 
            local bundle = resMgr:LoadBundle(bundel_name)
            local prefab = resMgr:LoadBundleAsset(bundle,bundel_name)
            local go = GameObject.Instantiate(prefab)
            resMgr:addAltas(go.transform,"MaJiang")
            go.transform.parent = this.MP.showCardPanel_bg
            go.transform.localScale = Vector3.one 
            go.transform.localPosition = v 
            go.name = k
            local sprite = go.transform:Find("Sprite"):GetComponent("UISprite")
            sprite.spriteName = this.sprite_name[data.out_cardid]
        end 
    end 
    local hand_list = this.GetCardList(AREA_ID_HAND,1)
    
    for posid,v in pairs(this.show_chi_list)do 
        local obj = hand_list[posid]
        if not obj then 
            return
        end 
        local warn = obj.transform:Find("WarnSprite").gameObject
        if warn then 
            warn:SetActive(is_show)
        end 
        if is_show then
            this.LB:AddOnPress(obj,this.OnChiPlayClick)
        else 
            this.LB:AddOnPress(obj,this.PlayCard)
        end 
    end 
end 
-- -- 显示吃碰胡杠特效
function mt.UpdatePlayBtn(data)
    local list = data
    local len = 1
    local btn_list = {
        [1]= this.MP.play_btn_1,
        [2]= this.MP.play_btn_2,
        [3]= this.MP.play_btn_3,
        [4]= this.MP.play_btn_4,
    }
    for k,v in pairs(list)do 
        local btn =btn_list[len]
        while true do 
            if not btn then 
                print("============MJCTRL:UpdatePlayBtn:out lime!!")
                break
            end 
            btn:SetActive(true)
            local sprite = btn:GetComponent("UISprite")
            local id = v.id 
            sprite.spriteName = this.btnSpriteName[id]
            if id == 1 then 
                this.LB:AddClick(btn,this.OnChi)
            elseif id == 2 then 
                this.LB:AddClick(btn,this.OnGang)
                this.LB:AddOnPress(btn,this.OnGangPress)
            elseif id == 3 then 
                this.LB:AddClick(btn,this.OnHu)
            elseif id == 4 then 
                this.LB:AddClick(btn,this.OnPeng)
                this.LB:AddOnPress(btn,this.OnPenPress)
            elseif id == 5 then 
                this.LB:AddClick(btn,this.OnAnGang)
            elseif id == 6 then 
                this.LB:AddClick(btn,this.OnYouJing)
            end 
            len = len + 1
            break
        end 
    end 
    this.MP.playBtnList.gameObject:SetActive(true)
end 
function mt.OnPassPlayCallBack()
    -- to_do __游金
    this.ClosePlayBtn()
end 
--data={play_seatid,delete_list,by_seatid}
--delete_list = {[posid]=cardid,} --[0]=carid 为out_cardid
function mt.OnChiPlayCallBack(data)
    if not this.out_card then 
        return
    end 
    this.CloseShowCPHGPanel()
    this.PlaySound(this.const.SOUND_MJ_CHI)--播放声音
    -- global._view:Invoke(this.const.SOUND_DELAY_MJ_CHI+0.1,function()
    --     this.PlaySound(this.const.AUDIO_MJ_GUAFENG)
    -- end )

    local who = this.GetWhoBySeatid(data.play_seatid)
    if who ==  1 then 
        this.ClosePlayBtn()
        this.CloseShowCPHGPanel()
    end 
    --吃牌特效 todo
    
    this.Play_Effect(who,EFFECT_ID_CHI)
    --数据处理    
    local del_who = this.GetWhoBySeatid(data.by_seatid)
    local del_data = {}
    del_data.delID_list = {} -- posid
    del_data.card_id_list = {} -- cardid
    for posid,cardid in pairs(data.delete_list)do 
        if posid ~= 0 then 
            table.insert(del_data.delID_list,posid)
        end 
        table.insert(del_data.card_id_list,cardid)
    end
    table.sort(del_data.delID_list,function(a,b)
        if a<b then 
            return true 
        end 
    end)
    table.sort(del_data.card_id_list,function(a,b)
        if a<b then 
            return true 
        end 
    end)
    -- local info = {
    --     data = nil ,
    --     time = 0,
    --     count = 1,
    --     id = FUN_ID_CPHG
    -- } 
    -- -- this.is_play_clearup_anima = true 
    -- this.AddCallFunByTimer(info,function()
    --     this.DealChiPenGang(del_data,who,del_who,DO_TYPE_CHI)--测试
    -- end,function()
    -- end)

    this.DealChiPenGang(del_data,who,del_who,DO_TYPE_CHI)--测试
end 
function mt.OnGangPlayCallBack(data)
   
    if not this.out_card then 
        print ("没有打出牌，无法吃牌！！！！！！")
        return
    end 
    this.PlaySound(this.const.SOUND_MJ_GANG)--播放声音
    global._view:Invoke(this.const.SOUND_DELAY_MJ_GANG+0.1,function()
        this.PlaySound(this.const.AUDIO_MJ_GUAFENG)
    end)
    local who = this.GetWhoBySeatid(data.play_seatid)
    if who ==  1 then 
        this.ClosePlayBtn()
    end 
    --吃牌特效 todo
    this.Play_Effect(who,EFFECT_ID_GANG)
    --数据处理   
    local del_who = this.GetWhoBySeatid(data.by_seatid)
    local del_data = {}
    del_data.delID_list = {} -- posid
    del_data.card_id_list = {} -- cardid
    for posid,cardid in pairs(data.delete_list)do 
        if posid ~= 0 then 
            table.insert(del_data.delID_list,posid)
        end 
        table.insert(del_data.card_id_list,cardid)
    end
    table.sort(del_data.delID_list,function(a,b)
        if a<b then 
            return true 
        end 
    end)
    -- local info = {
    --     data = nil ,
    --     time = 0,
    --     count = 1,
    --     id = FUN_ID_CPHG
    -- } 
    -- -- this.is_play_clearup_anima = true 
    -- this.AddCallFunByTimer(info,function()
    --     this.DealChiPenGang(del_data,who,del_who,DO_TYPE_GANG)--测试
    -- end,function()
    -- end)
    this.DealChiPenGang(del_data,who,del_who,DO_TYPE_GANG)--测试
end 

function mt.OnBuGangPlayCallBack(data)
    this.PlaySound(this.const.SOUND_MJ_GANG)--播放声音
    global._view:Invoke(this.const.SOUND_DELAY_MJ_GANG+0.1,function()
        this.PlaySound(this.const.AUDIO_MJ_GUAFENG)
    end)
    this.ClosePlayBtn()
    local who = this.GetWhoBySeatid(data.play_seatid)
    --吃牌特效 todo
    this.Play_Effect(who,EFFECT_ID_GANG)
    -- del_data.delID_list = {}
    -- del_data.card_id_list = {}
    this.is_play_clearup_drawcard_anima = true
    for posid,cardid in pairs(data.delete_list)do 
        -- table.insert(del_data.delID_list,posid)
        -- table.insert(del_data.card_id_list,cardid)
        this.ClearCard(who,AREA_ID_HAND,posid)
        local bu_peng_list = nil 
        if who == 1 then 
            bu_peng_list =this.bu_peng_list_1 
        elseif who == 2 then 
            bu_peng_list =this.bu_peng_list_2 
        elseif who == 3 then
            bu_peng_list =this.bu_peng_list_3 
        elseif who == 4 then
            bu_peng_list =this.bu_peng_list_4 
        end 
        if bu_peng_list then 
            local go = bu_peng_list[cardid]
            local ming = go.transform:Find("Ming")
            local DI_4 = ming.transform:Find("DI_4").gameObject
            DI_4:SetActive(true)
            local sprite_4 = DI_4.transform:Find("Sprite"):GetComponent("UISprite")
            sprite_4.spriteName = this.GetImageNameByID(cardid)
            -- local scale_data = this.GetBasicTwenData(go,BASIC_TWEEN_TYPE_SCALE)
            -- local scale = scale_data.to 
            -- local change = 1.5
            -- scale =  scale  * change
            -- scale_data.to  = scale
            -- this.ScaleTweenAnima(go,scale_data)
            -- global._view:Invoke(scale_data.time,function()
            --     scale_data.from = scale_data.to
            --     scale =  scale / change 
            --     scale_data.to = scale
            --     this.ScaleTweenAnima(go,scale_data)
            -- end)
        end 
    end
    this.is_play_clearup_drawcard_anima = nil 
end 
--data={play_seatid,posid,delete_list}
--delete_list = {[posid]=0,}
function mt.OnAnGangPlayCallBack(data)
    
    this.CloseShowCPHGPanel()
    this.PlaySound(this.const.SOUND_MJ_GANG)--播放声音
    global._view:Invoke(this.const.SOUND_DELAY_MJ_GANG+0.1,function()
        this.PlaySound(this.const.AUDIO_MJ_RAIN)
    end )
    local who = this.GetWhoBySeatid(data.play_seatid)
    if who ==  1 then 
        this.ClosePlayBtn()
        this.CloseShowCPHGPanel()
    end 
    --吃牌特效 todo
    this.Play_Effect(who,EFFECT_ID_GANG)
    --数据处理   
    local del_data = {}
    del_data.delID_list = {}
    del_data.card_id_list = {}
    for posid,cardid in pairs(data.delete_list)do 
        table.insert(del_data.delID_list,posid)
        table.insert(del_data.card_id_list,cardid)
    end
    local clearup_data = {
        who = who ,
        tar_id = data.posid,
        del_id = nil
    }

    -- local info = {
    --     data = nil ,
    --     time = 0,
    --     count = 1,
    --     id = FUN_ID_CPHG
    -- } 
    -- -- this.is_play_clearup_anima = true 
    -- this.AddCallFunByTimer(info,function()        
    --     this.DealChiPenGang(del_data,who,nil,DO_TYPE_ANGANG)
    -- end,function()
    -- end)
    this.DealChiPenGang(del_data,who,nil,DO_TYPE_ANGANG)
    
    -- global._view:Invoke(BASICTWEN_TIMER+0.2,function()
    --     this.clearup_data = clearup_data
    --     this.is_play_clearup_drawcard_anima = true
    --     this.play_clearup = true 
    -- end) 

    -- this.clearup_data = clearup_data

    -- this.is_play_clearup_drawcard_anima = true   
    this.AddClearUpCardListData(clearup_data)

    -- local once = true 
    -- global._view:Invoke(BASICTWEN_TIMER+0.3,function()
    --     if once then 
    --         once = false
    --         this.ClearUpCardList(clearup_data)
    --     end 
    -- end)
end

function mt.OnYouJingPlayCallBack(data,glod_obj)
    -- this.is_do_youjing = true 
    this.CloseShowCPHGPanel()
    --音效
    this.PlaySound(this.const.SOUND_MJ_YOUJING)
    local who = this.GetWhoBySeatid(data.youjing_seatid)
    if who ==  1 then 
        this.ClosePlayBtn()
        this.CloseShowCPHGPanel()
    end 
    --特效
    this.Play_Effect(who,EFFECT_ID_YOUJING)
    
    local obj = glod_obj -- 金牌
    --生成金牌
    if obj then 
        this.Set_Gold() 
        -- ths.gold_effect_obj:SetActive(true)       
        local pos_data = this.GetBasicTwenData(obj,BASIC_TWEEN_TYPE_POS)
        this.MP.gold_eff_container.transform.localPosition = pos_data.from
        -- local to_area = this.GetOutCardToAreaData(AREA_ID_FLOWER,who)
        local to_pos = nil 
        if who == 1 then 
            to_pos = Vector3(0,-220,0)
        elseif who == 2 then 
            to_pos = Vector3(400,0,0)
        elseif who == 3 then 
            to_pos = Vector3(0,220,0)
        elseif who == 4 then 
            to_pos = Vector3(-400,0,0)
        end 
        pos_data.to = to_pos
        local scale_data = this.GetBasicTwenData(this.MP.gold_eff_container,BASIC_TWEEN_TYPE_SCALE)
        scale_data.from = Vector3.one * 0.7
        scale_data.to = Vector3.one * 0.5
        this.PosTweenAnima(this.MP.gold_eff_container,pos_data)
        this.ScaleTweenAnima(this.MP.gold_eff_container,scale_data)
        -- this.ClearCard(who,AREA_ID_HAND,tar_posid)
        panelMgr:ClearPrefab(obj)
        this.MP.gold_effect:SetActive(true)
    end 
end 

function mt.OnPengPlayCallBack(data)
   
    if not this.out_card then 
        print ("没有打出牌，无法吃牌！！！！！！")
        return
    end 
    this.PlaySound(this.const.SOUND_MJ_PENG)--播放声音
    -- global._view:Invoke(this.const.SOUND_DELAY_MJ_PENG+0.1,function()
    --     this.PlaySound(this.const.AUDIO_MJ_PENG)
    -- end )
    local who = this.GetWhoBySeatid(data.play_seatid)
    if who ==  1 then 
        this.ClosePlayBtn()
    end 
    --吃牌特效 todo
    this.Play_Effect(who,EFFECT_ID_PENG)
    --数据处理    
    local del_who = this.GetWhoBySeatid(data.by_seatid)
    local del_data = {}
    del_data.delID_list = {} -- posid
    del_data.card_id_list = {} -- cardid
    for posid,cardid in pairs(data.delete_list)do 
        if posid ~= 0 then 
            table.insert(del_data.delID_list,posid)
        end 
        table.insert(del_data.card_id_list,cardid)
    end
    table.sort(del_data.delID_list,function(a,b)
        if a<b then 
            return true 
        end 
    end)
    -- local info = {
    --     data = nil ,
    --     time = 0,
    --     count = 1,
    --     id = FUN_ID_CPHG
    -- } 
    -- -- this.is_play_clearup_anima = true 
    -- this.AddCallFunByTimer(info,function()
    --     this.DealChiPenGang(del_data,who,del_who,DO_TYPE_PENG)--测试
    -- end,function()
    -- end)
    this.DealChiPenGang(del_data,who,del_who,DO_TYPE_PENG)
end 

function mt.OnHuPlayCallBack(data)
    -- this.PlaySound(104)--播放声音    
    local who = this.GetWhoBySeatid(data.play_seatid)
    if who ==  1 then 
        this.ClosePlayBtn()
    end 
    local clip = nil 
    local wait_time = nil 
    if data.hu_type == 1 then -- 平胡	
        clip = this.const.SOUND_MJ_HU
        wait_time = this.const.SOUND_DELAY_MJ_HU
    elseif data.hu_type == 2 then --自摸
        clip = this.const.SOUND_MJ_ZIMO
        wait_time = this.const.SOUND_DELAY_MJ_ZIMO
    elseif data.hu_type == 3 then --油金 
        clip = this.const.SOUND_MJ_YOUJING
        wait_time = this.const.SOUND_DELAY_MJ_YOUJING
    end 
    this.PlaySound(clip)
    local result_clip = nil 
    if who == 1 then 
        result_clip = this.const.AUDIO_MJ_WIN
    else 
        result_clip = this.const.AUDIO_MJ_LOST
    end 
    global._view:Invoke(wait_time+0.1,function()
        this.PlaySound(result_clip)
    end)
    local del_who = this.GetWhoBySeatid(data.by_seatid)
    -- this.ClosePlayBtn()--隐藏吃碰胡杠按钮
    --播放特效，把桌面上的牌消掉，生成胡牌 todo 
    this.Play_Effect(who,EFFECT_ID_HU)
end 
--[[
    data= {
        result = int  1、获胜 2、失败 3、流局
        message _result_list{
        repeated _play_user play_users                    =1; //玩家信息
        repeated _id hand_list                   =2; //手牌信息 
        repeated _id flower_list                 =3; //花牌信息 
        repeated _id angang_list                 =4; //暗杠信息 
        repeated _id minggang_list               =5; //明杠信息 
        repeated _id pengchi_list                =6; //碰吃信息  
        optional int32 hu_cardid                          =7; //胡牌ID
        optional int32 hu_type                            =8; //胡牌模式 0无、1平胡、2自摸、3油金
        optional int32 param1                             =9; //拓展 共%s水
        optional int32 param2                    =10; //结果金币
        }
    }
]]
function mt.ShowResult(data)
    -- this.MP.result:SetActive(true) -- 暂时
    --标题
    local title_name = nil 
    if data.result == 1 then 
        title_name = "zishenglijg"
        this.PlaySound(this.const.AUDIO_MJ_WIN)
    elseif data.result == 2 then 
        title_name = "zishibaijg"
        this.PlaySound(this.const.AUDIO_MJ_LOST)
    elseif data.result == 3 then 
        title_name = "ziliujujg"
        this.PlaySound(this.const.AUDIO_MJ_LOST)
    end 
    if title_name then 
        this.MP.title_sprite.spriteName = title_name
    end 
    local step = 1
    for k,v in pairs(data.result_list)do 
        --Item 初始化
        local bundle = resMgr:LoadBundle("MJ_Item")
        local prefab = resMgr:LoadBundleAsset(bundle,"MJ_Item")
        local go = GameObject.Instantiate(prefab)
        resMgr:addAltas(go.transform,"MaJiang")
        go.transform.parent = this.MP.result.transform
        go.transform.localScale = Vector3.one         
        local item_star_pos = Vector3(0,212,0)
        local item_space = 140
        item_star_pos.y = item_star_pos.y - item_space*(step-1)        
        go.transform.localPosition = item_star_pos 
        step = step + 1       
        --头像信息        
        local play_users = v.play_users[1]
        this.SetResultHead(go,play_users)
        --金额结果 
        if v.param2 then 
        -- local money = play_users[1].player_money
            if type(v.param2) == "number" then 
                local money =string.format("%0.2f",v.param2) + 0  
                this.SetResultMoney(go,money)
            else 
                -- this.SetResultMoney(go,v.param2)
            end 
        end 
        -- 胡类型
        local hu_type = v.hu_type
        local BG_TR = go.transform:Find("BG")
        local bg_sp_1 = BG_TR:Find("Sprite1"):GetComponent("UISprite")
        local bg_sp_2 = BG_TR:Find("Sprite2"):GetComponent("UISprite")
        local hu_obj = go.transform:Find("HU").gameObject       
        if hu_type == 0 then 
            hu_obj:SetActive(false)
            bg_sp_1.spriteName = "yinghongsedk2"
            bg_sp_2.spriteName = "yinghongsedk2"
        else 
            hu_obj:SetActive(true)
            bg_sp_1.spriteName = "yinghongsedk1"
            bg_sp_2.spriteName = "yinghongsedk1"
            local hu_Sprite = hu_obj.transform:Find("Sprite"):GetComponent("UISprite")
            hu_Sprite.spriteName = this.hu_type_sprite[hu_type]
        end 
        local show_card = go.transform:Find("ShowCard").gameObject
        --花牌
        local flower_list = v.flower_list
        this.SetResultFlower(show_card,flower_list)
        --CPHG
        local cphg_len = 0
        local angang_list = v.angang_list
        local angang_len = this.SetResultCPHG(show_card,angang_list,DO_TYPE_ANGANG,cphg_len)
        cphg_len = cphg_len + angang_len
        local gang_list = v.minggang_list
        local gang_len = this.SetResultCPHG(show_card,gang_list,DO_TYPE_GANG,cphg_len) 
        cphg_len = cphg_len + gang_len
        local pengchi_list = v.pengchi_list
        local cp_len = this.SetResultCPHG(show_card,pengchi_list,DO_TYPE_PENG,cphg_len) 
        cphg_len = cphg_len + cp_len
        --手牌
        -- local cphg_len = angang_len + gang_len + cp_len
        local hand_list = v.hand_list
        this.SetResultHand(show_card,hand_list,cphg_len)
        --胡牌
        if v.hu_cardid and v.hu_cardid~=0 then 
            local hu_obj = show_card.transform:Find("HU").gameObject
            local hu_Sprite = hu_obj.transform:Find("Card/Sprite"):GetComponent("UISprite")
            hu_Sprite.spriteName = this.sprite_name[v.hu_cardid]
            hu_obj:SetActive(true)
        end 
        --文字说明
        local str_data = {
            hu_type = hu_type,
            hand_list = hand_list,
            flower_list = flower_list,
            angang_len = angang_len ,
            gang_len = gang_len,
            hu_cardid = v.hu_cardid
        }
        -- local str = this.DealResulText(hu_type,hand_list,flower_list,angang_len,gang_len,v.hu_cardid)
        local str = this.DealResulText(str_data)
        local label_1_obj = go.transform:Find("Label_1").gameObject
        label_1_obj:SetActive(true)
        local label_1 = label_1_obj:GetComponent("UILabel")
        label_1.text = str 
        local label_2_obj = go.transform:Find("Label_2").gameObject
        if v.param1 then 
            label_2_obj:SetActive(true)
            local label_2 = label_2_obj:GetComponent("UILabel")
            local str_2 = string.format( "共%s水",v.param1 )
            label_2.text = str_2
        else 
            label_2_obj:SetActive(false)
        end 
        if not this.result_item_list then 
            this.result_item_list = {}
        end 
        table.insert(this.result_item_list,go)
    end 
    for i = step , 4 do 
        local bundle = resMgr:LoadBundle("MJ_Item")
        local prefab = resMgr:LoadBundleAsset(bundle,"MJ_Item")
        local go = GameObject.Instantiate(prefab)
        go.transform.parent = this.MP.result.transform
        go.transform.localScale = Vector3.one         
        local item_star_pos = Vector3(0,212,0)
        local item_space = 140
        item_star_pos.y = item_star_pos.y - item_space*(i-1)        
        go.transform.localPosition = item_star_pos 
        local BG_TR = go.transform:Find("BG")
        local bg_sp_1 = BG_TR:Find("Sprite1"):GetComponent("UISprite")
        local bg_sp_2 = BG_TR:Find("Sprite2"):GetComponent("UISprite")
        bg_sp_1.spriteName = "yinghongsedk2"
        bg_sp_2.spriteName = "yinghongsedk2"
        go.transform:Find("Head").gameObject:SetActive(false)
        if not this.result_item_list then 
            this.result_item_list = {}
        end 
        table.insert(this.result_item_list,go)
    end 
    this.MP.result:SetActive(true)
end 

function mt.CloseResult()
    this.MP.result:SetActive(false)
    this.ClearAllResultPrefab()--先清空Item
end 
------------------补花----------------
--list={[pos_id]={poscard_id,addcard_id}} 
function mt.AddFlowerCallBack(data,who)
    local who = who
    local fl_list = data
    for pos_id,v in pairs(fl_list)do         
        local area_data = this.GetOutCardToAreaData(AREA_ID_FLOWER,who)
        local posid = 9
        local card_data = this.GetCardData(who,posid,AREA_ID_FLOWER)
        -- card_data.posID = card_data.posID - area_data.len 
        -- card_data.card_name = card_data.posID
        -- card_data.pos = area_data.card_pos
        card_data.card_id = v.poscard_id
        local go = this.GetCardObj(AREA_ID_HAND,who,pos_id)
        ----zhanshi------
        if not go then 
            local cre_data = this.GetCardData(who,pos_id,AREA_ID_HAND)
            cre_data.cardid = v.poscard_id
            if pos_id == 17 then 
                -- cre_data.pos = this.GetDrawCardStartPos(who)
                if who == 1 then 
                    cre_data.y = 90
                end 
            else 

            end 
            go = this.CreateCard(cre_data)
        end 
        ----------------
        local p_data = this.GetBasicTwenData(go,1)
        p_data.delay = 0.3
        p_data.to = area_data.to_pos
        local s_data = this.GetBasicTwenData(go,2)
        s_data.delay = p_data.delay
        s_data.to = this.GetCardScale(AREA_ID_FLOWER,who)
        local h_go = this.CreateCard(card_data)
        h_go:SetActive(false)
        card_data.posID = pos_id
        -- card_data.pos = go.transform.localPosition
        local play_out_data = {
            go  =go ,
            to_data =p_data,
            scale_data = s_data,
            card_data = card_data,
            who = who ,
            -- tar_id = nil,
            ----补花数据-----
            addFlower = true,
            addFlowerID = v.addcard_id,
            flower_obj = h_go
        }
        this.PlayOutCardAnima(play_out_data)
    end
    
end

function mt.Entrust_CallBack(data)
    local who = nil 
    local is_show = nil 
    if data.seatid then 
        who = this.GetWhoBySeatid(data.seatid)
    end 
    if data.entrust then 
        is_show = data.entrust
    end 
    if who then 
        this.MP.UpdateEntrust(who,is_show)
    end 
end 
-- 生成聊天条框
function mt.addPlayerBetInfo(info)
    local playername = info.player_name
    local txt = nil
    local who = nil 
    for k,v in pairs(this.play_users)do 
        if v.player_name == playername then 
            who = this.GetWhoBySeatid(v.seatid)
            break
        end 
    end 
    if not who then 
        return
    end 

    if info.viedo ==  false then 
        if info.content ~= "" then 
            txt = info.content
        end

    else 
        txt = info.content
    end 

    this.addBattleInfo(who,txt,info.viedo)
end 
function mt.addBattleInfo(who,txt,viedo)
    local chat_data = this.GetChatData(who)
    if not chat_data then 
        return
    end 
    local list = chat_data.list 
    local space = chat_data.space
    local parent = chat_data.parent
    local bundel_name = chat_data.bundel_name
    local timer = chat_data.timer 
    local collider = chat_data.collider
    local collider_sprite = chat_data.collider_sprite
    if timer <= 0 then 
        this.ClearChat(who)
        parent:GetComponent("UIScrollView"):ResetPosition()
        collider.localPosition = Vector3(109,-95,0)
        collider_sprite.height = 150
        chat_data.parent.localPosition = chat_data.star_pos  
        chat_data.parent:GetComponent("UIPanel").clipOffset = Vector2.zero     
    end 
    if who ==  1 then 
        this.chat_timer_1 = SHOW_CHAT_TIME
    elseif who == 2 then 
        this.chat_timer_2 = SHOW_CHAT_TIME
    elseif who == 3 then 
        this.chat_timer_3 = SHOW_CHAT_TIME
    elseif who == 4 then 
        this.chat_timer_4 = SHOW_CHAT_TIME
    end    
    
    local bundle = resMgr:LoadBundle(bundel_name)
    local prefab = resMgr:LoadBundleAsset(bundle,bundel_name)
    local go = GameObject.Instantiate(prefab) 
    local len = #list 
    go.name = "chat_bar_"..len
    go.transform.parent = chat_data.parent
    go.transform.localScale =Vector3.one 
    go.transform.localPosition = Vector3(110,-55,0)
    resMgr:addAltas(go.transform,"MaJiang")
    local label_obj = go.transform:Find("Label").gameObject
    label_obj.transform.localPosition = chat_data.label_star_pos
    local label = label_obj:GetComponent("UILabel")
    local sprite_obj = go.transform:Find("Label/Sprite").gameObject
    -- local timer = nil 
  
    for k,obj in pairs(list)do 
        if obj then 
            local pos = obj.transform.localPosition
            pos.y = pos.y + space.y 
            obj.transform.localPosition = pos
        end
    end     
    if viedo == false then 
        label.text = txt
    elseif viedo  then 
    end 
   
    local height = (len+1) * 75
    height = height + space.y 
    if height > 150 then 
        collider_sprite.height = height 
    else 
        collider_sprite.height = 150
    end  
    table.insert(list,go)
    chat_data.parent.gameObject:SetActive(true)
end 
-------------------------------重置-----------------------------------
function mt.ResetCardPos(go)
    if not go then 
        return 
    end 
    local data = {
        time = BASICTWEN_TIMER,
        from = go.transform.localPosition,
        to = go.transform.localPosition ,
    }
    local tp = go:GetComponent("TweenPosition")
    if tp.enabled == true then 
        data.to.x = tp.to.x 
    end 
    data.to.y = 0 
    this.PosTweenAnima(go,data) 
end 
function mt.ResetPoint()
    this.MP.e_point:SetActive(false)
    this.MP.w_point:SetActive(false)
    this.MP.n_point:SetActive(false)
    this.MP.s_point:SetActive(false)
end 
function mt.NewGameResetData()
    --===wait======
    this.dices = nil -- {{id},}
    --===prepare===
    this.banker = nil --{seatid,playerid}
    this.goldid = nil -- int 

    this.flower_list = nil --{{seatid,posid,cardid},}
    this.deal_list = nil --{[posid]=cardid,}
    this.hand_list = nil --{[posid]=cardid,}
    this.add_flower_data = nil --{[posid]={{poscard_id,addcard_id},}
    --===play===
    --this.flower_list
    this.play_seatid = nil --int
    --this.add_flower_data
    this.angang_list = nil --{{[posid]=cardid,},}
    this.drawCard_id = nil --int
    this.can_hu = nil --bool
    --===CPHG===
    -- this.can_hua   -- cardid
    this.gang_list = nil --{{[posid]=cardid,},}
    this.pen_list = nil --{{[posid]=cardid,},}
    this.chi_list = nil --{{[posid]=cardid,},}

    this.str_render_timer = 0 
    this.clearup_count = 0

    --骰子
    this.anima_timer = 0          --动画计时器
    this.anima_index = 1          --动画换图计数
    --cphg flower
    this.effect_str = nil          -- 特效图片名称
    this.effect_amount = nil       -- 特效图片总数
    this.effect_count = 1          -- 特效图片计数
    this.on_play_effect = nil      -- 播放特效开关
    this.effect_anima_timer = 0    -- 特效计时器

    this.play_out_card_data = nil

    this.ResetChat()
    -- this.MP.ResetHead()

    -- this.is_prepare = nil 
    -- this.is_do_youjing = nil 
    this.is_start_game = nil 
end 
function mt.ResetData()
    --==--------------------------数据信息--------------------------------
    --========公共数据======
    this.play_type = nil --int
    this.roomid = nil  --int
    this.isGameRoom = nil --bool
    this.bet_coin = nil 
    this.roomTitle = nil --string
    this.seatid = nil --int
    this.over_time = nil  --int 
    this.game_status = nil  -- int 
    this.play_users = nil--[[{ [1]={
        player_name,
        playerid,
        head_imgurl,
        player_money,
        seatid,
    },}]]
    --===wait======
    this.dices = nil -- {{id},}
    --===prepare===
    this.banker = nil --{seatid,playerid}
    this.goldid = nil -- int 

    this.flower_list = nil --{{seatid,posid,cardid},}
    this.deal_list = nil --{[posid]=cardid,}
    this.hand_list = nil --{[posid]=cardid,}
    this.add_flower_data = nil --{[posid]={{poscard_id,addcard_id},}
    --===play===
    --this.flower_list
    this.play_seatid = nil --int
    --this.add_flower_data
    this.angang_list = nil --{{[posid]=cardid,},}
    this.drawCard_id = nil --int
    this.can_hu = nil --bool
    --===CPHG===
    -- this.can_hua   -- cardid
    this.gang_list = nil --{{[posid]=cardid,},}
    this.pen_list = nil --{{[posid]=cardid,},}
    this.chi_list = nil --{{[posid]=cardid,},}
    --===END===
    this.result_list = nil --结果列表
    this.result = nil --结果情况 -- 1、获胜 2、失败 3、流局
--==================================================
    this.co_render_cards = nil  -- 发牌协同程序
    this.cur_data = nil --测试用

    -----------------------------标志位--------------------------------
    this.is_play_list_anima = nil     --播放按钮列表动画中(按键列表) --close
    this.is_play_card_anima = nil     --播放出牌动画中          --close
    this.is_play_clearup_anima = nil  --播放理牌动画中          --close
    this.is_play_clearup_drawcard_anima = nil ----播放抽牌理牌动画中 
    this.is_play_glod_anima = nil 
    this.is_play_addflwer_anima = nil --播放补花动画中
    this.is_play_effect_anima = nil   --播放特效动画中
    
    this.can_play_deices_anima = nil --播放摇骰子动画
    
    this.clearup_data = nil       -- 理牌数据
    
    this.isPress = nil            --按压牌
    
    this.str_render_timer = 0     -- 发牌时间计数
    this.press_time = 0           -- 按压时间
    
    this.cur_card = nil           -- 当前选中的牌
    this.last_card = nil          -- 上次选中的牌 
    this.out_card = nil           -- 打出去的牌 
    
    this.clearup_tiemr = 0         --理牌计时器
    this.clearup_count = 0         --理牌计数器
    this.star_clearup_timer = nil  --理牌开始标记位
    
    this.anima_timer = 0          --动画计时器
    this.anima_index = 1          --动画换图计数

    --cphg flower
    this.effect_str = nil          -- 特效图片名称
    this.effect_amount = nil       -- 特效图片总数
    this.effect_count = 1          -- 特效图片计数
    this.on_play_effect = nil      -- 播放特效开关
    this.effect_anima_timer = 0    -- 特效计时器
    
    this.last_game_status = nil    
    
    this.anima_status = nil        -- 动画播放阶段

    this.is_start_game = nil       -- 游戏是否已开始

    this.play_out_card_data = nil --[[
    data = {
            seatid = resp.seatid,
            posid = resp.posid,
            cardid = resp.cardid,
            to_posid = to_posid
        }
]] 
    this.is_prepare = nil
    this.is_init = nil 
    -- this.is_do_youjing = nil 
    -----------------------------列表存储--------------------------------
    this.card_list_1 = nil --{[posID]=obj}
    this.card_list_2 = nil --{[posID]=obj}
    this.card_list_3 = nil --{[posID]=obj}
    this.card_list_4 = nil --{[posID]=obj}

    -- this.card_list = nil   --{[posID]=card_id}

    this.out_card_list_1 = nil --{[posID]=obj}
    this.out_card_list_2 = nil --{[posID]=obj}
    this.out_card_list_3 = nil --{[posID]=obj}
    this.out_card_list_4 = nil --{[posID]=obj}

    this.pen_list_1 = nil --{[posID]=obj}
    this.pen_list_2 = nil --{[posID]=obj}
    this.pen_list_3 = nil --{[posID]=obj}
    this.pen_list_4 = nil --{[posID]=obj}

    this.flower_List_1 = nil --{[posID]=obj}
    this.flower_List_2 = nil --{[posID]=obj}
    this.flower_List_3 = nil --{[posID]=obj}
    this.flower_List_4 = nil --{[posID]=obj}

    this.result_item_list = nil 

    this.seat_order=nil --{[seatid]=who,}

    this.call_fun_list = nil --[[{
        [fun_id]={
            fun,data,timer_to,timer_from,index,count,is_finish,finish_fun
        }
    }]]
    this.show_cphg_message_list = nil --{obj}
    this.gold_effect_obj = nil -- {obj}

    this.ResetChat()
end 
    
function mt.ResetChat()
    for i = 1, 4 do 
        local data = this.GetChatData(i)
        this.ClearChat(i)
        data.collider.localPosition = Vector3(109,-95,0)
        data.collider_sprite.height = 150
        data.parent.localPosition = data.star_pos  
        data.parent:GetComponent("UIPanel").clipOffset = Vector2.zero 
    end 
    this.chat_timer_1 = 0  
    this.chat_timer_2 = 0  
    this.chat_timer_3 = 0  
    this.chat_timer_4 = 0  
    this.MP.say_chat_1.gameObject:SetActive(false)
    this.MP.say_chat_2.gameObject:SetActive(false)
    this.MP.say_chat_3.gameObject:SetActive(false)
    this.MP.say_chat_4.gameObject:SetActive(false)
end 
-------------------------------时间事件--------------------------------
function mt.TimeEvent()
    -- this.ControllerByKey()

    --发牌控制
    -- this.RenderCardsByTimeCtr()
    this.ClearupHandAnima()
    this.AnimaController()

    this.CardPressTime()
    this.TimeController()

    this.CallFunByTimer()
    -- this.CallFunTimer()
    this.PlayOutCard()

    this.Play_Effect_Anima()
    
    this.ShowChatController()

    this.ClearUpCardListController()
    -- this.ClearUpAnimaController()
    
end 
function mt.CardPressTime()
    if this.isPress then 
        this.press_time = this.press_time + Time.deltaTime
        if this.press_time > 0.1 then 
            if this.last_card then 
                this.ResetCardPos(this.last_card)
                this.last_card = nil 
            end
            if this.cur_card then 
                local pos =  this.cur_card.transform.localPosition
                pos.y = Input.mousePosition.y-49.5
                this.cur_card.transform.localPosition = pos 
            end 
        end 
    end 
end 
-------------------------------控制器--------------------------------
--按键控制
-- function mt.ControllerByKey()
--     if Input.GetKeyDown(KeyCode.K)then --发牌
--         this.co_render_cards = coroutine.create(function()
--             this.RenderFuncCards()    
--         end )

--         this.SetAnimaStatus(ANIMA_STATUS_DEAL)

--         -- local data_1 = this.GetCardData(4,16,1)
--         -- this.CreateCard(data_1)

--         -- if this.card_list_1 ~= nil then 
--         --     print ("已经发牌")
--         --     return
--         -- end 
--         ---- this.str_renderCard = true
--         -- this.SetAnimaStatus(ANIMA_STATUS_DEAL)
--         -- this.RenderFuncCards()

--     end 
--     if Input.GetKeyDown(KeyCode.L)then  --清理桌面
--         this.ClearAllCardsPrefab()
--     end 
--     if Input.GetKeyDown(KeyCode.J)then  --抽牌

--         SetAnimaStatus(ANIMA_STATUS_DRAW)
--     end
--     if Input.GetKeyDown(KeyCode.Q)then  --触发特殊技能
--         local data = {
--             {id = 1},
--             {id = 4},
--             {id = 2},
--             -- {id = 3},
--         }
--         this.UpdatePlayBtn(data)
--     end
--     if Input.GetKeyDown(KeyCode.A)then  --补花
--         local data = {
--             list = {
--                 --posid   drawcardid  flowercardid
--                 [1]={addcard_id=31,poscard_id = 11},
--                 [13]={addcard_id=33,poscard_id = 12},
--                 [10]={addcard_id=25,poscard_id = 13},
--                 [3]={addcard_id=25,poscard_id = 14},
--             },
--         }
--         this.AddFlowerCallBack(data,this.WHO)
--     end
--     if Input.GetKeyDown(KeyCode.Z)then  --控制出牌区域位置
--         this.WHO =  this.WHO + 1
--         if this.WHO > 4 then 
--             this.WHO = 1 
--         end 
--         -- this.DrawCard(this.WHO)
--         this.SetAnimaStatus(ANIMA_STATUS_DRAW)
--         this.PonintController(this.WHO)

--     end
-- end 

function mt.ClearUpCardListController()
    -- if not this.play_clearup then 
    --     return 
    -- end 
    -- this.play_clearup = nil 
    if not this.clearup_data_list then 
        return
    end 
    for k, v in pairs(this.clearup_data_list)do 
        if v.timer > 0 then 
            v.tiemr = v.timer - Time.deltaTime
        else
            this.is_play_clearup_drawcard_anima = true 
            this.ClearUpCardList(v.data)
            this.clearup_data_list[k]=nil 
        end 
    end 
    local len = get_len(this.clearup_data_list)
    if len < 1 then 
        -- print ("============ClearUpCardListController===========")
        this.clearup_data_list = nil 
    end  
end 
-- function mt.ClearUpAnimaController()
--     if not this.clearup_anima_data_list then 
--         return
--     end 
--     for k, v in pairs(this.clearup_anima_data_list)do 
--         if v.timer > 0 then 
--             v.tiemr = v.timer - Time.deltaTime
--         else
--             this.is_play_clearup_anima = true 
--             this.ClearUpCardAnima(v.data)
--             this.clearup_anima_data_list[k]=nil 
--         end 
--     end 
--     local len = get_len(this.clearup_anima_data_list)
--     if len < 1 then 
--         -- print ("============ClearUpCardListController===========")
--         this.clearup_anima_data_list = nil 
--     end  
-- end
--指向控制
function mt.PonintController(who)
    this.ResetPoint()
    if not who then
        this.MP.s_point:SetActive(true)
        this.MP.e_point:SetActive(true)
        this.MP.n_point:SetActive(true)
        this.MP.w_point:SetActive(true)
    else 
        if who == 1 then 
            this.MP.s_point:SetActive(true)
        elseif who == 2 then 
            this.MP.e_point:SetActive(true)
        elseif who == 3 then
            this.MP.n_point:SetActive(true)
        elseif who == 4 then
            this.MP.w_point:SetActive(true)
        end 
    end 
    -- this.over_time = 20+this.MP.GetTime() --测试
end 
--时间显示控制
function mt.TimeController()
    if not this.game_status then 
        return
    end 
    -- if this.game_status == this.const.MJ_STATUS_FREE then 
    --     this.MP.time_label.text = "等"
    if this.game_status == this.const.MJ_STATUS_WAIT then 
        this.MP.time_label.text = "..."
    else 
        if this.over_time ~= nil and this.over_time > 0 then 
            local time =  this.over_time - this.MP.GetTime()
            if time >= 0 then 
                local hours = math.floor(time / 3600);
                time = time - hours * 3600;
                local minute = math.floor(time / 60);
                time = time - minute * 60; 
                if this.game_status == this.const.MJ_STATUS_END then 
                    local str = string.format("(%s)",GameData.changeFoLimitTime(time))
                    this.MP.result_next_label.text = str
                end 
                this.MP.time_label.text = GameData.changeFoLimitTime(time)
            else 
                this.MP.time_label.text = "00"
                if this.game_status == this.const.MJ_STATUS_END then 
                    local str = string.format("(%s)","00")
                    this.MP.result_next_label.text = str
                end 
            end 
        end 
    end     
end 
--吃牌胡控制
--data={delID_list,card_id_list}
--delID_list= {posid,}消除的位置卡牌
--card_id_list ={cardid} 
function mt.DealChiPenGang(data,who,del_who,type)
    local delID_list = data.delID_list
    table.sort(delID_list,function(a,b)
        if a<b then 
            return true 
        end 
    end )

    this.Clear_Out_Card(del_who)
    this.Clear_Hand_Card_By_CPG(who,delID_list,type)
    this.Create_CPG_Card(who,data.card_id_list,type)
end  
function mt.Clear_Out_Card(who)
    if not this.out_card then
        return
    end 
    if not who then 
        if this.out_card then 
            this.out_card.transform:Find("Target").gameObject:SetActive(false)
        end 
        return
    end
  
    local out_card_posid = this.out_card.name+0
    this.ClearCard(who,AREA_ID_OUT,out_card_posid)
    -- local out_list = this.GetCardList(AREA_ID_OUT,who) or nil 
    -- if out_list then   
    --     local out_card_posid = this.out_card.name+0 
    --     panelMgr:ClearPrefab(this.out_card)    
    --     out_list[out_card_posid]=nil
    --     this.out_card = nil   
    -- end 
end 
function mt.Create_CPG_Card(who,data,type)
    if not data then 
        return
    end 
    if not who then 
        return 
    end 
    -- local pen_list = this.GetCardList(AREA_ID_PEN,who)
    local area_data = this.GetOutCardToAreaData(AREA_ID_PEN,who)
    local penCard_data = this.GetCardData(who,area_data.len,AREA_ID_PEN)
    if type ~= DO_TYPE_ANGANG then 
        if data[1] then 
            penCard_data.card_1 = data[1]
        end 
        if data[2] then 
            penCard_data.card_2 = data[2]
        end 
        if data[3] then 
            penCard_data.card_3 = data[3]
        end 
        if data[4] then 
            penCard_data.card_4 = data[4]
        end
    end 
    penCard_data.pos = area_data.card_pos
    --生成吃牌
    local chi_card = this.CreateCard(penCard_data)  
end 
function mt.Clear_Hand_Card_By_CPG(who,data,type)
    local list = this.GetCardList(AREA_ID_HAND,who)   
    for k,posid in pairs(data)do 
        -- local del_obj = list[posid]
        -- panelMgr:ClearPrefab(del_obj) 
        -- list[posid] = nil 
        this.ClearCard(who,AREA_ID_HAND,posid)
    end  

    local multiple = 2   
    if type == DO_TYPE_ANGANG then 
        multiple = 4
        for k,posid in pairs(data)do
            if posid == 17 then 
                multiple =  3
            end 
        end     
    elseif type == DO_TYPE_GANG then 
        multiple = 3 
    elseif type == DO_TYPE_CHI then 
    elseif type == DO_TYPE_PENG then 
    end 
    local ab = data[2]-data[1]
    local space = this.GetCardSpace(AREA_ID_HAND,who)
    local move_list_1 = {}--r
    local move_list_2 = {}--l
    local move_space = nil
    if ab == 1 then --连续
        for k,v in pairs(list)do 
            if k<data[1] then 
                local m_data = {
                    id = k+multiple,
                    go = v ,
                    -- posid = k,
                }
                table.insert(move_list_1,m_data)
                list[k]=nil 
                -- list[m_data.id] = v 
                -- v.name = m_data.id
            end 
        end 
        move_space = space*multiple
    else 
        local m_data = nil
        for k, v in pairs(list)do 
            if k>data[1] and k<data[2] then --中间
                m_data = {}
                m_data.id = k+1 
                m_data.go = v 
                -- m_data.posid = k
                table.insert(move_list_1,m_data)
                list[k]=nil 
                -- list[m_data.id] = v 
                -- v.name = m_data.id
            elseif k<data[1] then  --左边
                m_data = {}
                m_data.id = k+2
                m_data.go =v 
                -- m_data.posid = k
                table.insert(move_list_2,m_data)
                list[k]=nil 
                -- list[m_data.id] = v 
                -- v.name = m_data.id
            end 
        end 
        move_space = space
    end 
    ----------------------------------------------
    -- local move_list = {}
    -- local ab = data[2]-data[1]
    -- if ab == 1 then --连续
    --     for posid,v in pairs(list) then 
    --         local m_data = {}
    --         m_data.from_posid = posid 
    --         if posid < data[1] then            
    --             m_data.to_posid = posid + multiple
    --         else 
    --             m_data.to_posid = posid
    --         end 
    --         table.insert(move_list,m_data)
    --     end 
    -- else
    --     for posid ,v in pairs(list)do 
    --         local m_data = {}
    --         m_data.from_posid = posid
    --         if posid > data[1] and posid < data[2] then 
    --             m_data.to_posid = posid + 1
    --         elseif  posid < data[1] then 
    --             m_data.to_posid = posid + multiple
    --         else 
    --             m_data.to_posid = posid 
    --         end 
    --     end 


    ----------------------------------------------
    -- 理牌动画 todo
    local move_data = {
        time = 0.05,
        -- time = BASICTWEN_TIMER,
        from = Vector3.zero,
        to = Vector3.zero,
    }
    local cl_data = {}
    if #move_list_1>0 then
        cl_data.move_data = move_data
        cl_data.move_list = move_list_1
        cl_data.who = who
        -- cl_data.space = move_space
        this.is_play_clearup_anima = true 
        this.ClearUpCardAnima(cl_data)
        -- this.AddClearUpAnima(cl_data)
    end   
    if #move_list_2>0 then 
        cl_data.move_data = move_data
        cl_data.move_list = move_list_2
        cl_data.who = who
        -- cl_data.space = move_space*(ab-1)
        -- cl_data.space = move_space*2
        this.is_play_clearup_anima = true 
        this.ClearUpCardAnima(cl_data)
        -- this.AddClearUpAnima(cl_data)
    end

    -- this.is_play_clearup_drawcard_anima = true
    -- if this.clearup_data then 
    --     global._view:Invoke(BASICTWEN_TIMER+0.1,function()
    --         this.ClearUpCardList(this.clearup_data)
    --     end)
    -- else 
    --     this.is_play_clearup_drawcard_anima = nil 
    -- end 
end 
--准备阶段结束动画控制
function mt.OnAnimaStatus(status)
    -- if this.KEYCTRL then 
    --     print("MJCTRL:OnAnimaStatus:IS KEYCTRL")
    --     return 
    -- end 
    this.str_render_timer = 0 
    if status == ANIMA_STATUS_FREE then  --空闲结束
        
    elseif status == ANIMA_STATUS_DICES then 
        this.MP.dicesPanel:SetActive(false)
        this.MP.dices_anim:SetActive(true)
        this.MP.dices_result:SetActive(false)
        this.MP.dices_result.transform.localScale = Vector3.one 
        this.anima_index = 1    
        this.anima_timer = 0  
        this.SetAnimaStatus(ANIMA_STATUS_DEAL)
    elseif status == ANIMA_STATUS_DEAL then --发牌结束
        if this.banker then 
            local seatid = this.banker.seatid 
            local who = this.GetWhoBySeatid(seatid)
            this.WHO = who 
        else 
            print ("MJCTRL:OnAnimaStatus:not banker")
        end 
        local is_show = true 
        this.UpdateBankerHead(is_show) -- 更新庄家头像标志 
        this.SetAnimaStatus(ANIMA_STATUS_DRAW)       

    elseif status == ANIMA_STATUS_DRAW then   --抽卡结束
        this.is_play_card_anima = nil  
        this.is_play_drawcard_anima = nil --播放抽牌动画中    
        --补花
        -- this.drawCard_id = nil -- 置空抽卡信息
        if this.add_flower_data then 
            this.SetAnimaStatus(ANIMA_STATUS_ADD)
        else 
            if this.flower_list then 
                this.SetAnimaStatus(ANIMA_STATUS_OTHERADD)
            else 
                if this.game_status ==this.const.MJ_STATUS_PREPARE then 
                    
                    this.SetAnimaStatus(ANIMA_STATUS_GOLD)
                else 
                    if this.is_start_game == this.const.MJ_STATUS_PREPARE then 
                        this.SetAnimaStatus(ANIMA_STATUS_GOLD)
                    else 
                        this.SetAnimaStatus(ANIMA_STATUS_CPHG)
                    end 
                end 
            end 
        end 
    elseif status == ANIMA_STATUS_ADD then --补花结束  
        this.is_play_card_anima = nil
        this.add_flower_data = nil  -- 置空自己的补花信息    
        if this.flower_list then 
            this.SetAnimaStatus(ANIMA_STATUS_OTHERADD)
        else 
            if this.game_status ==this.const.MJ_STATUS_PREPARE then 
                this.SetAnimaStatus(ANIMA_STATUS_GOLD)
            else 
                if this.is_start_game == this.const.MJ_STATUS_PREPARE then 
                    this.SetAnimaStatus(ANIMA_STATUS_GOLD)
                else 
                    this.SetAnimaStatus(ANIMA_STATUS_CPHG)
                end 
            end 
        end 
                
    elseif status == ANIMA_STATUS_OTHERADD then -- 其他人补花
        this.flower_list = nil --置空其他人的补花信息
        if this.game_status ==this.const.MJ_STATUS_PREPARE then 
            this.SetAnimaStatus(ANIMA_STATUS_GOLD)
        else 
            if this.is_start_game == this.const.MJ_STATUS_PREPARE then 
                this.SetAnimaStatus(ANIMA_STATUS_GOLD)
            else 
                this.SetAnimaStatus(ANIMA_STATUS_FREE)
            end 
        end       
    elseif status == ANIMA_STATUS_GOLD then --摸金
        -- this.star_clearup_timer = true 
        this.UpdateGoldImage()--更新金牌  
        this.MP.gold_effect:SetActive(false)
        if this.gold_effect_obj then 
            panelMgr:ClearPrefab(this.gold_effect_obj) 
            this.gold_effect_obj = nil 
        end
        this.MP.gold_eff_container.transform.localPosition = Vector3.zero
        local tp = this.MP.gold_eff_container:GetComponent("TweenPosition")
        tp.from = Vector3.zero
        tp.to = Vector3.zero
        
        this.SetAnimaStatus(ANIMA_STATUS_CLEARUP)
        this.is_play_glod_anima = nil
    elseif status == ANIMA_STATUS_CLEARUP then
        if this.is_start_game and this.game_status == this.const.MJ_STATUS_PLAY then 
            if this.WHO == 1 then 
                this.SetAnimaStatus(ANIMA_STATUS_CPHG)
            else 
                this.SetAnimaStatus(ANIMA_STATUS_FREE)
            end 
        else 
            this.SetAnimaStatus(ANIMA_STATUS_FREE)
        end 
        if this.game_status == this.const.MJ_STATUS_PREPARE then 
            this.MP.EndStatus(this.const.MJ_STATUS_PREPARE)
        end 
    elseif status == ANIMA_STATUS_CPHG then --吃碰胡杠
        this.SetAnimaStatus(ANIMA_STATUS_FREE)   
    elseif status == ANIMA_STATUS_END then --结束   
        this.result_list = nil 
        if this.head_texture_list then 
            for k,v in pairs(this.head_texture_list)do 
                if v.texture and v.head_imgurl then 
                    v.texture:SetAsyncImage(v.head_imgurl)
                end 
            end 
            this.head_texture_list = nil 
        end 
        this.SetAnimaStatus(ANIMA_STATUS_FREE)  
    end 
end 
-- 装备阶段动画控制
function mt.AnimaController() 
    if this.anima_status == ANIMA_STATUS_DICES then
        this.PlayDicesAnima()
    elseif this.anima_status == ANIMA_STATUS_DEAL then --发牌动画控制
        if not this.co_render_cards then
            return
        end 
        this.str_render_timer = this.str_render_timer + Time.deltaTime
        if this.str_render_timer>DEALCARD_TIMER then 
            local str = coroutine.status(this.co_render_cards)
            -- this.RenderFuncCards()    
            -- print (str)
            if str == "suspended" then 
                coroutine.resume(this.co_render_cards)                
            end 
            this.str_render_timer = 0
        end 
    elseif this.anima_status == ANIMA_STATUS_DRAW then -- 抽牌动画控制
        if this.is_play_clearup_anima then 
            return 
        end 
        if this.is_play_clearup_drawcard_anima then 
            return
        end 
        if this.is_play_drawcard_anima then 
            return
        end 
        this.is_play_drawcard_anima = true 
        this.DrawCard()     
    elseif this.anima_status == ANIMA_STATUS_ADD then -- --自己补花动画控制
        -- this.str_render_timer = this.str_render_timer + Time.deltaTime
        -- if this.str_render_timer > ADDFLOWER_WAIT_TIMER then
            -- this.anima_status = ANIMA_STATUS_FREE 

        if not this.is_play_addflwer_anima then 
            return 
        end 
            this.is_play_addflwer_anima = nil 

            local who = this.GetWhoBySeatid(this.seatid) 
            local add_folwer_list = this.GetAddFlowerData(who)           
            -- local time = 0
            local count = #add_folwer_list
            if count > 0 then 
                this.Play_Effect(who,EFFECT_ID_FLOWER)
               
                local info ={
                    data = add_folwer_list,
                    -- time = ADDFLOWER_WAIT_TIMER,
                    time = 0,
                    count = count,
                    id = FUN_ID_ADDFLOWER
                }
                this.AddCallFunByTimer(info,function(data)
                    this.AddFlowerCallBack(data,who)
                end,function()
                        global._view:Invoke(INVOKE_TIME_FLOWER,function()
                            this.OnAnimaStatus(ANIMA_STATUS_ADD)
                        end)                       
                        this.add_flower_data = nil 
                end) 
            else 
                this.OnAnimaStatus(ANIMA_STATUS_ADD)  
            end  
        -- end 
    elseif this.anima_status == ANIMA_STATUS_OTHERADD then  --其他人的补花动画

        this.str_render_timer = this.str_render_timer + Time.deltaTime
        if this.str_render_timer > ADDFLOWER_WAIT_TIMER*2 then 
            -- this.anima_status = ANIMA_STATUS_FREE     
            for k,v in pairs(this.flower_list)do 
                if v.seatid ~= this.seatid then --自己的不用更新
                    local who = this.GetWhoBySeatid(v.seatid)
                    this.Play_Effect(who,EFFECT_ID_FLOWER)
                    local posid = v.posid 
                    local poscard_id = v.cardid
                    local data = {}
                    data[posid]={
                        poscard_id = poscard_id,
                        poscard_id = nil
                    }                
                    this.AddFlowerCallBack(data,who)
                end 
            end 
            this.OnAnimaStatus(ANIMA_STATUS_OTHERADD)
        end   
    elseif this.anima_status == ANIMA_STATUS_GOLD then --摸金动画
        if this.is_play_glod_anima then 
            return
        end 
            this.is_play_glod_anima = true
            -- if this.gold_effect_obj then 
                
            --     this.gold_effect_obj:SetActive(true )
            -- end 
            
            this.MP.gold_effect:SetActive(true)
            this.PlaySound(this.const.SOUND_MJ_KAIJING)
            local s_data = this.GetBasicTwenData(this.MP.gold_eff_container,BASIC_TWEEN_TYPE_SCALE)
            s_data.from = Vector3.zero
            this.ScaleTweenAnima(this.MP.gold_eff_container,s_data)
            
            global._view:Invoke(INVOKE_TIME_GOLD,function()               
                local pos_data = this.GetBasicTwenData(this.MP.gold_eff_container,BASIC_TWEEN_TYPE_POS)
                pos_data.from = Vector3.zero
                pos_data.to = Vector3(-370,270,0)
                pos_data.time = BASICTWEN_TIMER*3
                this.PosTweenAnima(this.MP.gold_eff_container,pos_data)
                local sacle_data = this.GetBasicTwenData(this.MP.gold_eff_container,BASIC_TWEEN_TYPE_SCALE)
                sacle_data.to = Vector3.one*0.5
                sacle_data.time = BASICTWEN_TIMER*3
                this.ScaleTweenAnima(this.MP.gold_eff_container,sacle_data)
                
            end)
            local timer_2 = INVOKE_TIME_GOLD+BASICTWEN_TIMER*3
            global._view:Invoke(timer_2,function()
                this.OnAnimaStatus(ANIMA_STATUS_GOLD)
            end)   
            
            
        -- end 
    elseif this.anima_status == ANIMA_STATUS_CLEARUP then --理牌动画
        if this.star_clearup_timer then 
            return
        end 
        this.str_render_timer = this.str_render_timer + Time.deltaTime
        if this.str_render_timer > CLEARUP_TIMER then 
            --todo 添加动画效果
            local who = 1 
            local card_list = this.GetCardList(AREA_ID_HAND,who)
            local to_list = this.hand_list
            for k,v in pairs(card_list)do 
                local sprite = v:GetComponent("UISprite")
                sprite.spriteName = SELF_PAI_DI_NAME
            end 
            global._view:Invoke(0.03,function()
                this.UpdateHandList(card_list,to_list)
                local hand_list = this.GetCardList(AREA_ID_HAND,1)
                for k,obj in pairs(hand_list)do 
                    local cardid = this.GetCardidByObj(obj)
                    this.CheckGold(obj,cardid)
                end 
            end)            
           
            this.OnAnimaStatus(ANIMA_STATUS_CLEARUP)
            
        end 
    elseif this.anima_status == ANIMA_STATUS_CPHG then 
        -- this.str_render_timer = this.str_render_timer + Time.deltaTime
        -- if this.str_render_timer > BASICTWEN_TIMER then
        --     this.str_render_timer = 0
        --     this.ShowPlayBtn()
        --     this.OnAnimaStatus(ANIMA_STATUS_CPHG)
        -- end        
        this.ShowPlayBtn()
        
    elseif this.anima_status == ANIMA_STATUS_END then 
        if this.is_play_effect_anima then 
            return
        end 
        if this.is_play_card_anima then 
            return
        end 
        this.is_play_effect_anima = true 
        local data = {}
        data.result =  this.result

        data.result_list = {}
        local playerid = this.MP.GetPlayerID()
        if this.result_list then 
            for k,v in pairs(this.result_list) do 
                local play_users = v.play_users
                if play_users.playerid == playerid then 
                    table.insert(data.result_list,v)
                end 
            end 
            for k,v in pairs(this.result_list) do 
                local play_users = v.play_users
                if play_users.playerid ~= playerid then 
                    table.insert(data.result_list,v)
                end 
            end
            this.ShowResult(data)
        end 
        
        global._view:ClearInvoke()        
        --清空数据 todo
         
        this.ClearAllCardsPrefab()
        this.ClosePlayBtn()
        this.CloseShowCPHGPanel()
        this.MP.UpdateGoldImage()--隐藏金牌
        if this.gold_effect_obj then
            panelMgr:ClearPrefab(this.gold_effect_obj)
            this.gold_effect_obj = nil 
        end 
        this.ResetPoint() --关闭中间指示物
        this.OnAnimaStatus(ANIMA_STATUS_END)
        this.is_play_effect_anima = nil 
    end 
end 
-- 延迟调用方法控制
function mt.CallFunByTimer()
    if not this.call_fun_list then 
        return 
    end     
    local now = this.MP.GetTime()
    for fun_id,v in pairs(this.call_fun_list)do 
        if v.is_finish == false then 
            if not v.timer_to then 
                v.is_finish = true 
                this.call_fun_list[fun_id]=nil
                table.remove (this.call_fun_list,fun_id )
            else 
                if now >= v.timer_to then   
                    local fun = v.fun 
                    if v.data then 
                        local data = v.data[v.index]           
                        if fun then 
                            fun(data)
                        end 
                    else 
                        if fun then 
                            fun()
                        end 
                    end                              
                    v.index  = v.index+1                     
                    if v.index > v.count then 
                        v.is_finish = true
                        if v.finish_fun then 
                            v.finish_fun()
                        end 
                        this.call_fun_list[fun_id]=nil --执行完后删除
                        -- table.remove (this.call_fun_list,fun_id)
                    else                     
                        v.timer_to =v.timer_from+now
                    end             
                end 
            end 
        end 
    end 
end 
--fun 要调用的方法 data 要调用的方法传递的参数，{[1]=参数，} 
-- 添加延迟调用的方法
-- info = {data,time,count,id}
function mt.AddCallFunByTimer(info,fun,finish_fun)
    local data = info.data
    local now = this.MP.GetTime()
    local timer_from = info.time
    local time = info.time + now
    local count = info.count
    local id = info.id
    if not this.call_fun_list then 
        this.call_fun_list = {}
    end 
    if this.call_fun_list[id]then 
        -- return
        while (this.call_fun_list[id]) do 
            id = id + 1 
        end 
        -- id = id + 1
    end 
    this.call_fun_list[id]={
        fun = fun , -- 方法
        data = data, -- 传递的参数 与执行次数有关
        timer_to = time , --执行间隔时间
        timer_from = timer_from, -- 起始计数时间
        index = 1, -- 起始计数标记
        count = count, --执行次数
        is_finish = false, --是否执行完成标记
        finish_fun = finish_fun
    }
end 
function mt.AddClearUpCardListData(data)
    if not this.clearup_data_list then 
        this.clearup_data_list = {}
    end 
    local len = get_len (this.clearup_data_list)
    timer = (BASICTWEN_TIMER+0.2)*len
    local info = {
        data = data,
        timer = timer ,
    }
    table.insert(this.clearup_data_list,info)
end 
 
-- function mt.AddClearUpAnima(data)
--     if not this.clearup_anima_data_list then 
--         this.clearup_anima_data_list = {}
--     end 
--     local len = get_len (this.clearup_anima_data_list)
--     timer = (BASICTWEN_TIMER+0.2)*len
--     local info = {
--         data = data,
--         timer = timer ,
--     }
--     table.insert(this.clearup_anima_data_list,info)
-- end 

-- 删除延迟调用的方法
function mt.DeleteCallFunByTimer(id)
    if not this.call_fun_list then 
        
        return
    end
    for fun_id,v in pairs(this.call_fun_list)do 
        if fun_id == id then 
            this.call_fun_list[id] = nil 
        else 
        end 
    end 
end 
--播放摇骰子动画
function mt.PlayDicesAnima()
    if this.anima_index > 6 then 
        return
    end 
    if this.anima_timer < ANIMA_SPACE_TIMER+0.05 then 
        this.anima_timer = this.anima_timer + Time.deltaTime
    else        
        if this.anima_index == 1 then 
            this.PlaySound(this.const.AUDIO_MJ_SHAIZI)
        end 
        this.anima_timer = 0
        local str ="dices_"..this.anima_index
        this.MP.dices_anim_sprite.spriteName = str
        if this.anima_index == 6 then 
            this.MP.dices_anim:SetActive(false)
            this.MP.dices_result:SetActive(true)
            this.MP.dices_result_sprite_1.spriteName =""..this.dices[1].id 
            this.MP.dices_result_sprite_2.spriteName =""..this.dices[2].id 
            this.MP.dices_result_sprite_3.spriteName =""..this.dices[3].id 
            global._view:Invoke(INVOKE_TIME_DICES,function()
                local big_data = this.GetBasicTwenData(this.MP.dices_result,BASIC_TWEEN_TYPE_SCALE)
                big_data.to = Vector3(2,2,0)
                -- big_data.time = 0.3
                this.ScaleTweenAnima(this.MP.dices_result,big_data)                       
            end)
            global._view:Invoke(INVOKE_TIME_DICES*4,function()
                this.OnAnimaStatus(ANIMA_STATUS_DICES)
            end )
        end 
        this.anima_index = this.anima_index + 1
    end 
end 

--把牌打出去
--data={seatid,posid,cardid,to_posid}
function mt.PlayOutCard()
    if not this.play_out_card_data then 
        return
    end 
    if this.anima_status ~= ANIMA_STATUS_FREE then
        return
    end 
    local _data = new_table(this.play_out_card_data)
    local posID = _data.posid
    local who = this.GetWhoBySeatid(_data.seatid)
    local cardID = _data.cardid 
    local tar_id = _data.to_posid 
    local obj = _data.obj
    this.play_out_card_data = nil 

    if who == 1 then 
        this.ClosePlayBtn()        
        this.CloseShowCPHGPanel()
    end 

    if not obj then 
        print("没有卡牌OBJ:")
        this.is_play_card_anima = nil 
        return
    end 
     ----zhanshi------
    -- if not obj then 
    --     local cre_data = this.GetCardData(who,data.posid,AREA_ID_HAND)
    --     cre_data.cardid = data.cardid
    --     obj = this.CreateCard(cre_data)
    -- end 
    ----------------
    local data =  this.GetBasicTwenData(obj,1)--obj,type
    data.delay = 0.15
    local data_scale = this.GetBasicTwenData(obj,2)--obj,type
    data_scale.delay = data.delay
    data_scale.to = this.GetCardScale(AREA_ID_OUT,who)--area,who
    local data_card = this.GetCardData(who,this.out_box_data.amount,AREA_ID_OUT)--who,posid,area
    data_card.card_id = cardID
    ----------------------数据整理------------------------
    local area_data = this.GetOutCardToAreaData(AREA_ID_OUT,who)
   
    -- data_card.posID = data_card.posID - area_data.len
    -- data_card.card_name = data_card.posID   
    -- data_card.pos = area_data.card_pos
    data.to = area_data.to_pos
    ----------------------实际播放------------------------
   
    local play_out_data = {
        go = obj,
        to_data = data,
        scale_data = data_scale,
        card_data = data_card,
        who = who ,
        tar_id =tar_id,
    }

    --播放音效
    local clip = "mj_"..cardID
    this.PlaySound(clip)
   
    -- global._view:Invoke(this.const.SOUND_DELAY_MJ_OUTCARD+0.1,function()
    --     this.PlaySound(clip)
    -- end)
    if data.from.y<21 then
        local data_2 = this.GetBasicTwenData(obj,1)--obj,type
        data_2.time = 0.1
        data_2.to = obj.transform.localPosition
        data_2.to.y = this.GetCardUpToPos(who)+data_2.to.y
        data.from = data_2.to          
        -- this.PosTweenAnima(obj,data_2,function()--先上升  
        this.PosTweenAnima(obj,data_2) --先上升  
        this.is_play_clearup_drawcard_anima = true
        global._view:Invoke(data_2.time,function() 
            this.PlayOutCardAnima(play_out_data)        
        end )        
    else 
        this.is_play_clearup_drawcard_anima = true
        this.PlayOutCardAnima(play_out_data) 
    end 
    
end 
-- cpgh 特效播放动画
function mt.Play_Effect_Anima()
    
    if not this.on_play_effect then 
        return 
    end 
   
    if this.effect_count > this.effect_amount then 
        return
    end 
    
    if this.effect_anima_timer < ANIMA_SPACE_TIMER then 
        this.effect_anima_timer = this.effect_anima_timer + Time.deltaTime
    else 
        this.effect_anima_timer = 0
        this.Update_Effect_Sprite()
        if this.effect_count == 1 then 
            this.MP.cphg_effect:SetActive(true)
            this.MP.cphg_effect_sprite_obj:SetActive(true)
        end 
        this.effect_count = this.effect_count + 1
        if this.effect_count > this.effect_amount then 
            this.on_play_effect = nil 
            this.effect_str = nil          -- 特效图片名称
            this.effect_amount = nil       -- 特效图片总数
            this.effect_count = 1          -- 特效图片计数
            this.effect_anima_timer = 0    -- 特效计时器
            global._view:Invoke(ANIMA_SPACE_TIMER,function()
                this.MP.cphg_effect:SetActive(false)
                this.MP.cphg_effect_sprite_obj:SetActive(false)
                this.is_play_effect_anima = nil 
            end )
        end 
    end 
end  
this.clear_chat_list = {}  
function mt.ShowChatController()
    if this.chat_timer_1 > 0 then 
        this.chat_timer_1 = this.chat_timer_1 - Time.deltaTime
    elseif this.chat_list_1 and #this.chat_list_1>0  then 
        this.MP.say_chat_1.gameObject:SetActive(false)
    end 
    if this.chat_timer_2 > 0 then 
        this.chat_timer_2 = this.chat_timer_2 - Time.deltaTime
    elseif this.chat_list_2 and #this.chat_list_2>0 then 
        this.MP.say_chat_2.gameObject:SetActive(false)
    end 
    if this.chat_timer_3 > 0 then 
        this.chat_timer_3 = this.chat_timer_3 - Time.deltaTime
    elseif this.chat_list_3 and #this.chat_list_3>0 then 
        this.MP.say_chat_3.gameObject:SetActive(false)
    end 
    if this.chat_timer_4 > 0 then 
        this.chat_timer_4 = this.chat_timer_4 - Time.deltaTime
    elseif this.chat_list_4 and #this.chat_list_4>0 then 
        this.MP.say_chat_4.gameObject:SetActive(false)
    end 
end 


-------------------------------点击事件--------------------------------
function mt.OnBack()
    local str =i18n.TID_COMMON_BACK_GAME
	global._view:support().Awake(str,function ()
		soundMgr:PlaySound("go")
        this.MP.OnBackClick(this.isGameRoom)
	   end,function ()

   	end);
    
end 
function mt.OnHelp()
    global._view:rule().Awake(global.const.GAME_ID_MJ);
end 
function mt.OnMenu()
    if this.is_play_list_anima then 
        return
    end 
    this.is_play_list_anima = true 
    local obj = this.MP.btnGroup.gameObject
    local data = {
        time = 0.3,
        from = obj.transform.localPosition,
        to = Vector3(0,-25,0)  
    }
    this.PosTweenAnima(obj,data,function()
        this.MP.menuBtn:SetActive(false)
        this.MP.returnBtn:SetActive(true)
        this.is_play_list_anima = nil 
        this.MP.menu_di_sprite.color = Color.white
        this.MP.menu_sprite.color = Color.white
    end )    
end 
function mt.OnChat()
    -- if this.is_start_game then 
    --     return
    -- end 
    this.MP.saydialog:SetActive(true)    
end 
this.isStartViedo = false
this.StartViedoTime = 0
this.pressPoint = nil
this.viedodist = 0
function mt.OnVoice(isPress)
    if this.is_start_game then 
        return
    end 
    if(isPress) then
		if(this.StartViedoTime < 8) then
			this.startRecord()
		else
			this.MP.viedo_VoiceChatPlayer:getSendAllData()
		end
	else
		this.MP.viedo_VoiceChatPlayer:getSendAllData()
	end
end
function mt.startRecord()
	-- RoomPanel.viedo_VoiceChatPlayer:StartRecording()
	if(this.isStartViedo) then
		return
	end
	this.MP.viedo_VoiceChatPlayer:StopRecording()
    this.MP.viedo_VoiceChatPlayer:StartRecording()
	this.isStartViedo = true;
	this.StartViedoTime = 0
	this.pressPoint = Input.mousePosition;
	this.viedodist = 0
	this.viedoIndex = 4
	this.MP.record:SetActive(true)
	this.MP.recard1:SetActive(true)
	this.MP.recard2:SetActive(true)
	this.MP.recard3:SetActive(true)
	this.MP.recard4:SetActive(true)
	this.pauseMusic()
end

function mt.pauseMusic()
	if CAN_PAUSE then 
		soundMgr:PauseBackSound()
	else
		soundMgr:StopBackSound()
	end 
end 
function mt.PlayBGSound()
	if CAN_PAUSE then 
		soundMgr:PlayMusic()
	else
		soundMgr:PlayBackSound("background")
	end 
end 


function mt.OnReturn()
    if this.is_play_list_anima then 
        return
    end 
    this.is_play_list_anima = true 
    local obj = this.MP.btnGroup.gameObject
    local data = {
        time = 0.3,
        from = obj.transform.localPosition,
        to = Vector3(0,307,0)  
    }
    this.PosTweenAnima(obj,data,function()
        this.MP.menuBtn:SetActive(true)
        this.MP.returnBtn:SetActive(false)
        this.is_play_list_anima = nil 
        this.MP.return_di_sprite.color = Color.white
        this.MP.return_sprite.color = Color.white
    end )
end 
--托管
function mt.OnEntrust(obj)
    if this.game_status == this.const.MJ_STATUS_FREE or 
    this.game_status == this.const.MJ_STATUS_END then 
        local text = i18n.TID_MJ_NOT_STATR_INFO
        global._view:getViewBase("Tip").setTip(text)
        return
    end 
    this.MP.Entrust(ENTRUST_TYPE_SET)
end 
--取消托管
function mt.OnCancelEntrust(obj)
    this.MP.Entrust(ENTRUST_TYPE_CANCEL)
end
function mt.OnSet()
    local ctrl = global._view:setting()    
    ctrl.Awake(this.const.GAME_ID_MJ);
    -- ctrl.Hide_Exit_Btn()
end 
function mt.BankBtn()
    global._view:bank().Awake();
end 
function mt.OnInvite()
    if(this.isGameRoom) then
		return
	end
	global.player:get_mgr("room"):req_invite_join_room(
        this.const.GAME_ID_MJ,this.roomid)
end 
function mt.OnPass()    
    --this.MP.PassPlay() --暂时  
    if this.game_status == this.const.MJ_STATUS_PLAY then 
        -- if this.is_do_youjing then 
        --     this.MP.PassCPHG()
        -- else 
        --     this.OnPassPlayCallBack()
        -- end 
        this.OnPassPlayCallBack()
    elseif this.game_status == this.const.MJ_STATUS_CPHG or 
    this.game_status == this.const.MJ_STATUS_YOUJING then 
        this.MP.PassCPHG()
    end 
end 
--chi_list = {{[posid]=cardid,},}
this.prepare_chi_list = nil 
function mt.OnChi()
    if not this.out_card then 
        print ("报错，没有打出来的牌")
        return
    end 

    local out_cardid = this.GetCardidByObj(this.out_card) 
    if not this.chi_list then 
        return 
    end 
    local value = #this.chi_list
    local data = this.GetShowCardPanelData(SHOWCARD_TYPE_CHI,value)
    if data then 
        data.card_id_list = {} -- {{cardid,},}
        for k,list in pairs(this.chi_list)do 
            local card_list = {}
            for posid,cardid in pairs(list)do 
                table.insert(card_list,cardid)
            end 
            table.insert(card_list,out_cardid)
            table.sort(card_list,function(a,b)
                if a<b then 
                    return true 
                end 
            end )
            table.insert(data.card_id_list,card_list)
        end 
    end 
    data.out_cardid = out_cardid
    this.ShowCPHGPanel(data,SHOWCARD_TYPE_CHI)

    -- this.show_chi_list = {}
    -- local data = this.GetShowCardPanelData(SHOWCARD_TYPE_CHI)
    -- if data then 
    --     -- data.card_posid_list = {}
    --     for k,list in pairs (this.chi_list)do 
    --         local posid_list = {}
    --         for posid,cardid in pairs(list)do
    --             if posid ~= 0 then 
    --                 this.show_chi_list[posid]=0
    --             end 
    --         end
    --     end 
    -- end 
    -- local out_cardid = this.GetCardidByObj(this.out_card) 
    -- data.out_cardid = out_cardid
    -- this.ShowWarn(data,SHOWCARD_TYPE_CHI)
end
function mt.OnGang()
    if this.game_status == this.const.MJ_STATUS_PLAY then 
        this.MP.BuGang()
    else 
        if this.out_card and this.play_seatid == this.seatid and this.gang_list then 
            this.MP.GANG()
        end 
    end 
end
function mt.OnGangPress(obj,isPress)    
    if not this.gang_list then 
        return
    end 
    local list = {}
    if this.game_status == this.const.MJ_STATUS_PLAY then 
        for k,v in pairs(this.gang_list)do 
            -- local step = 20
            local info = {}
            for posid,cardid in pairs(v)do                 
                if posid == 17 then 
                    info[posid]=cardid
                else 
                    -- info[step] = cardid 
                    -- step = step + 1
                end 
            end
            table.insert(list,info) 
        end 

    else 
        list = this.gang_list
    end 
    
    this.OnCPHGPress(list,isPress)
end 
function mt.OnAnGang()
    --{{[posid]=cardid,},}--4个一组
    if not this.angang_list then 
        return
    end 
    local value = #this.angang_list
    local data = this.GetShowCardPanelData(SHOWCARD_TYPE_ANGANG,value)
    if data then 
        data.card_id_list = {} -- {{cardid,},}
        for k,list in pairs(this.angang_list)do 
            local card_list = {}
            for posid,cardid in pairs(list)do 
                table.insert(card_list,cardid)
            end 
            table.insert(data.card_id_list,card_list)
        end 
    end 
    this.ShowCPHGPanel(data,SHOWCARD_TYPE_ANGANG)     
end 

function mt.OnHu()
    if not this.can_hu or this.can_hu == 0 then 
        return 
    end 
    if this.play_seatid == this.seatid then 
        this.MP.HU()
    end 
    -- local data ={
        
    -- }
    -- this.OnHuPlayCallBack(data)
end
function mt.OnYouJing()
    if not this.youjing_list then 
        return
    end 

    local value = get_len(this.youjing_list)
    local data = this.GetShowCardPanelData(SHOWCARD_TYPE_YOUJING,value)
    if data then 
        data.card_id_list = {} -- {{cardid},}
        data.posid_list = {}--{{posid},}
        for posid,cardid in pairs(this.youjing_list)do             
            table.insert(data.card_id_list,{cardid})
            table.insert(data.posid_list,{posid})
        end 
    end 
    this.ShowCPHGPanel(data,SHOWCARD_TYPE_YOUJING)
end 
function mt.OnPeng()
    if this.out_card and this.play_seatid == this.seatid and this.pen_list then 
        this.MP.PENG()
    end  
end
function mt.OnPenPress(obj,isPress)
    local list = this.pen_list
    this.OnCPHGPress(list,isPress)
end 

function mt.ShowPanelPress(obj,isPress)
    if not this.cphg_pre_list then 
        return
    end 
    local key = obj.name + 0
    local list = {}
    table.insert(list,this.cphg_pre_list[key])
    -- local list = this.cphg_pre_list
    this.OnCPHGPress(list,isPress)
end 
function mt.OnPlayReturn()
    this.CloseShowCPHGPanel()
    this.ShowPlayBtn()
end  

function mt.OnNext()
    if this.game_status ~= this.const.MJ_STATUS_END then 
        return
    end
    this.MP.EndStatus(this.const.MJ_STATUS_END,function()
        this.CloseResult()
        
        local is_show = true
        this.is_prepare = true
        if this.game_status == this.const.MJ_STATUS_WAIT then 
            is_show = false
            this.is_prepare = false
        end 
        this.MP.UpdatePrepareBtn(this.is_prepare,is_show)
    end)
end 

function mt.OnPrepare()
    local is_show = true 
    if not this.is_prepare then 
        this.MP.EndStatus(this.game_status,function()
            -- this.MP.prepare_label.text = "取消准备"
            if this.game_status == this.const.MJ_STATUS_FREE or 
            this.game_status == this.const.MJ_STATUS_END then 
                this.is_prepare = true    
                -- local playerid = this.MP.GetPlayerID()
                -- this.udpate_player_prepare(playerid,this.is_prepare)
                this.MP.UpdatePrepareBtn(this.is_prepare,is_show)
            end 
        end)
    else
        this.MP.CancelPrepare(function()
            -- this.MP.prepare_label.text = "准备开始"
            if this.game_status == this.const.MJ_STATUS_FREE or 
            this.game_status == this.const.MJ_STATUS_END then 
                this.is_prepare = nil 
                this.MP.UpdatePrepareBtn(this.is_prepare,is_show)
            end 
        end)
    end 
end 
-------------------------------动画控制--------------------------------

--data={time=,startPos=,toPos=}
function mt.PosTweenAnima(obj,data,cb)   
    if not obj or not data then 
        return
    end   

    local tp = obj:GetComponent("TweenPosition")
    tp.duration = data.time
    if not data.from then 
        tp.from = obj.transform.localPosition
    else
        tp.from = data.from
    end     
    tp.to = data.to
    if data.delay then 
        tp.delay = data.delay
    else
        tp.delay = 0 
    end 
    tp:ResetToBeginning()
    tp.enabled = true 
    if cb then 
        resMgr:TweenPosEventDeleate(tp,function()
            cb()                
        end )
    end   
    
end 

function mt.ScaleTweenAnima(obj,data)
    local ts = obj:GetComponent("TweenScale")
    ts.duration = data.time
    ts.from = data.from
    ts.to = data.to
    if data.delay then 
        ts.delay = data.delay
    end 
    ts:ResetToBeginning()
    ts.enabled = true 
end 
function mt.PlayOutCardAnima(data)
    local obj = data.go 
    local to_data = data.to_data
    local data_scale = data.scale_data
    local data_card = data.card_data
    local who = data.who 
    local box_data = this.out_box_data

    local go = nil  

    if who == 3 then 
        data_scale.to = Vector3.one
        local sprite = obj:GetComponent("UISprite")
        sprite.depth = 20 
    end 
    to_data.time = BASICTWEN_TIMER
    data_scale.time = BASICTWEN_TIMER
    this.ScaleTweenAnima(obj,data_scale)--缩小
    this.PosTweenAnima(obj,to_data)
   
    if not data.addFlower then 
        local clear_data = {
            who = who ,
            del_id = obj.name+0,
            tar_id = data.tar_id,
        }
        -- this.is_play_clearup_drawcard_anima = true
       
        local once = true 
        global._view:Invoke(to_data.time,function()
            if once then 
                once = false
                panelMgr:ClearPrefab(obj)
                go=this.CreateCard(data_card)-- 生成出牌
                this.PlaySound(this.const.AUDIO_MJ_OUTCARD)
                this.CheckGold(go,data_card.card_id)
                local info = {}
                info[data_card.posID]=go 
                -- print ("----------------------who----------------------:",who)
                if who == 1 or who == 4 then
                    this.ClearUpCardDepth(info,box_data.amount+1) 
                else 
                    this.ClearUpCardDepth(info) 
                end 
                if this.out_card  then 
                    this.out_card.transform:Find("Target").gameObject:SetActive(false)
                end 
                this.out_card = go 
                go.transform:Find("Target").gameObject:SetActive(true)
            
                -- this.ClearUpCardList(clear_data)--整理牌组  
                this.AddClearUpCardListData(clear_data)  
            end  
                     
        end)
    else 
        local card_data = this.GetCardData(who,data_card.posID,AREA_ID_HAND)
        if data.addFlowerID then 
            card_data.card_id = data.addFlowerID 
        end 
        local def_y = this.GetCardUpToPos(who)
        card_data.pos.y = card_data.pos.y +def_y
        local add_flower_obj = this.CreateCard(card_data)
        this.PlaySound(this.const.AUDIO_MJ_OUTCARD)
        if this.game_status ~= this.const.MJ_STATUS_PREPARE then 
            this.CheckGold(add_flower_obj,card_data.card_id)
        end 
        add_flower_obj:SetActive(false)
        global._view:Invoke(to_data.time+0.1,function()
            if obj then 
                obj:SetActive(false)
                panelMgr:ClearPrefab(obj)
            end 
            local h_go = data.flower_obj
            h_go:SetActive(true)
            this.FlowerFallAnima(who,data_card.posID,add_flower_obj)
            local info = {}
            local posID = h_go.name + 0
            info[posID]=h_go
            -- print ("----------------------who----------------------:",who)
            if who == 4 or who == 3  then 
                this.ClearUpCardDepth(info,9)
            else 
                this.ClearUpCardDepth(info)
            end 
        end)
    end    
end 
--理牌动画
function mt.ClearUpCardAnima(data)
    -- print ("==========ClearUpCardAnima=====================")
    local move_data = data.move_data
    local move_list = data.move_list
    local who = data.who 
    -- local space = data.space
    local space = this.GetCardSpace(AREA_ID_HAND,who)

    local list = this.GetCardList(AREA_ID_HAND,who)
    local star_pos = this.GetCardStartPos(AREA_ID_HAND,who)
   
    local count = 1
    if move_list and get_len(move_list)>0 and move_data then 
        local len = #move_list
        for k,v in pairs(move_list)do 
            local ret,message = pcall(function()
                return v.go.name 
            end)
            if ret then 
                move_data.from = v.go.transform.localPosition
                local to_pos = star_pos
                local sign = 1 
                if who == 3 or who == 4 then 
                    sign = -1 
                end 
                to_pos = to_pos - space*(16-v.id)*sign
                move_data.to = to_pos         
                list[v.id]=v.go 
                v.go.name = v.id 
                this.PosTweenAnima(v.go,move_data)
                
            else 
                -- print("=============ClearUpCardAnima:not go id=:",v.id)
                -- local list = this.GetCardList(AREA_ID_HAND,1)
                -- for posid, obj in pairs (list)do 
                --     print ("------------------------------")
                --     print ("-------------posid--------------:",posid)
                --     print ("-------------obj--------------:",obj.name)
                -- end 
            end 
            if count == len then 
                global._view:Invoke(BASICTWEN_TIMER+0.1,function()
                    this.is_play_clearup_anima = nil  
                end)
            end 
            count = count + 1
        end 
    else 
        -- pinti (111111)
        -- print ("=============ClearUpCardAnima:move_list len < 1 or not move data")
        this.is_play_clearup_anima = nil        
    end     
end 
-- this.clearup_card_list = nil 
-- function mt.ClearUpCardAniamController()
--     if not this.clearup_card_list then 
--         return
--     end 
--     for k , v in pairs(this.clearup_card_list) do 


--补花落下动画
function mt.FlowerFallAnima(who,posID,go) 

    local def_y = this.GetCardUpToPos(who)
    local p_data = this.GetBasicTwenData(go,1)
    p_data.to.y = p_data.to.y - def_y  
    p_data.delay = 0.3 
    go:SetActive(true)
    this.PosTweenAnima(go,p_data)

    local list = this.GetCardList(AREA_ID_HAND,who)
    -- print ("----------------------who----------------------:",who)
    if who == 2 then 
        this.ClearUpCardDepth(list,18)
    else 
        this.ClearUpCardDepth(list)
    end

end 

--理牌放下竖起动画
function mt.ClearupHandAnima()
    if not this.star_clearup_timer then 
        return
    end    
    if this.clearup_tiemr < CLEARUP_TIMER  then 
        this.clearup_tiemr = this.clearup_tiemr + Time.deltaTime
    else 
        this.clearup_tiemr = 0 
        this.clearup_count = this.clearup_count + 1
       
        local sprite_name = "pai_"..this.clearup_count
        local list = this.GetCardList(AREA_ID_HAND,1)
        for k,v in pairs(list)do 
            if this.clearup_count == 1 then
                local image_obj = v.transform:Find("Sprite").gameObject
                image_obj:SetActive(false)
            end 
            local sprite = v:GetComponent("UISprite")
            sprite.spriteName = sprite_name 
            
        end 
        if this.clearup_count > 2 then 
            this.clearup_count = 0 
            this.star_clearup_timer = nil 
        end 
    end 
end 

-------------------------------清除功能--------------------------------
function mt.ClearAllCardsPrefab()
    --手牌
    if this.card_list_1~=nil then 
        for id,obj in pairs(this.card_list_1)do
            local ret,message = pcall(function()
                return obj.name
            end)
            if ret then 
                panelMgr:ClearPrefab(this.card_list_1[id]) 
            end           
        end 
        this.card_list_1=nil 
    end 
    if this.card_list_2~=nil then 
        for id,obj in pairs(this.card_list_2)do
            local ret,message = pcall(function()
                return obj.name
            end)
            if ret then 
                panelMgr:ClearPrefab(this.card_list_2[id]) 
            end 
        end 
        this.card_list_2=nil
    end 
    if this.card_list_3~=nil then 
        for id,obj in pairs(this.card_list_3)do
            local ret,message = pcall(function()
                return obj.name
            end)
            if ret then 
                panelMgr:ClearPrefab(this.card_list_3[id]) 
            end 
        end 
        this.card_list_3=nil
    end 
    if this.card_list_4~=nil then 
        for id,obj in pairs(this.card_list_4)do
            local ret,message = pcall(function()
                return obj.name
            end)
            if ret then 
                panelMgr:ClearPrefab(this.card_list_4[id]) 
            end 
        end 
        this.card_list_4=nil
    end 
    --出牌区
    if this.out_card_list_1~=nil then 
        for id,go in pairs(this.out_card_list_1)do
            panelMgr:ClearPrefab(this.out_card_list_1[id])
        end 
        this.out_card_list_1 = nil 
    end 
    if this.out_card_list_2~=nil then 
        for id,go in pairs(this.out_card_list_2)do
            panelMgr:ClearPrefab(this.out_card_list_2[id])
        end 
        this.out_card_list_2 = nil 
    end
    if this.out_card_list_3~=nil then 
        for id,go in pairs(this.out_card_list_3)do
            panelMgr:ClearPrefab(this.out_card_list_3[id])
        end 
        this.out_card_list_3 = nil 
    end
    if this.out_card_list_4~=nil then 
        for id,go in pairs(this.out_card_list_4)do
            panelMgr:ClearPrefab(this.out_card_list_4[id])
        end 
        this.out_card_list_4 = nil 
    end
    this.out_card = nil 
    --碰牌区
    if this.pen_list_1~=nil then 
        for id,go in pairs(this.pen_list_1)do
            panelMgr:ClearPrefab(this.pen_list_1[id])
        end 
        this.pen_list_1 = nil 
    end 
    if this.pen_list_2~=nil then 
        for id,go in pairs(this.pen_list_2)do
            panelMgr:ClearPrefab(this.pen_list_2[id])
        end 
        this.pen_list_2 = nil 
    end
    if this.pen_list_3~=nil then 
        for id,go in pairs(this.pen_list_3)do
            panelMgr:ClearPrefab(this.pen_list_3[id])
        end 
        this.pen_list_3 = nil 
    end
    if this.pen_list_4~=nil then 
        for id,go in pairs(this.pen_list_4)do
            panelMgr:ClearPrefab(this.pen_list_4[id])
        end 
        this.pen_list_4 = nil 
    end
        --花牌区
    if this.flower_List_1~=nil then 
        for id,go in pairs(this.flower_List_1)do
            panelMgr:ClearPrefab(this.flower_List_1[id])
        end 
        this.flower_List_1 = nil 
    end 
    if this.flower_List_2~=nil then 
        for id,go in pairs(this.flower_List_2)do
            panelMgr:ClearPrefab(this.flower_List_2[id])
        end 
        this.flower_List_2 = nil 
    end
    if this.flower_List_3~=nil then 
        for id,go in pairs(this.flower_List_3)do
            panelMgr:ClearPrefab(this.flower_List_3[id])
        end 
        this.flower_List_3 = nil 
    end
    if this.flower_List_4~=nil then 
        for id,go in pairs(this.flower_List_4)do
            panelMgr:ClearPrefab(this.flower_List_4[id])
        end 
        this.flower_List_4 = nil 
    end
    this.is_play_card_anima = nil 

end 
--关闭CPHG按钮
function mt.ClosePlayBtn()  
    this.MP.playBtnList.gameObject:SetActive(false)
    this.MP.play_btn_1:SetActive(false)
    this.MP.play_btn_2:SetActive(false)
    this.MP.play_btn_3:SetActive(false)
    this.MP.play_btn_4:SetActive(false)
    --重置位置
    this.ShowPlay_Reset()
end 
function mt.ShowPlay_Reset()
    if this.pen_list then 
        for k,v in pairs(this.pen_list)do 
            for posid,cardid in pairs (v)do 
                if this.WHO and this.WHO == 1  then 
                    local go = this.GetCardObj(AREA_ID_HAND,this.WHO,posid) or nil 
                    if go then 
                        this.ResetCardPos(go)
                    end 
                end 
            end 
        end 
    end 
    if this.gang_list then 
        for k,v in pairs(this.gang_list)do 
            for posid,cardid in pairs (v)do 
                if this.WHO and this.WHO == 1 then 
                    local go = this.GetCardObj(AREA_ID_HAND,this.WHO,posid) or nil
                    if go then 
                        this.ResetCardPos(go)
                    end 
                end 
            end 
        end 
    end 
    if this.chi_list then 
        for k,v in pairs(this.chi_list)do 
            for posid,cardid in pairs (v)do 
                if this.WHO and this.WHO == 1 then 
                    local go = this.GetCardObj(AREA_ID_HAND,this.WHO,posid) or nil
                    if go then 
                        this.ResetCardPos(go)
                    end 
                end 
            end 
        end 
    end 
    if this.angang_list then 
        for k,v in pairs(this.angang_list)do 
            for posid,cardid in pairs (v)do 
                if this.WHO and this.WHO == 1 then 
                    local go = this.GetCardObj(AREA_ID_HAND,this.WHO,posid) or nil
                    if go then 
                        this.ResetCardPos(go)
                    end 
                end 
            end 
        end 
    end 
    this.cphg_pre_list = nil 
end 
--关闭showCPHG信息面板
function mt.CloseShowCPHGPanel()
    this.MP.showCardPanel.gameObject:SetActive(false)
    if this.show_cphg_message_list then 
        for k,go in pairs(this.show_cphg_message_list)do 
            if go then 
                panelMgr:ClearPrefab(go)
            end 
        end 
    end 
    this.show_cphg_message_list = nil 
    this.cphg_pre_list = nil 
end 

function mt.ClearAllResultPrefab()
    if not this.result_item_list then 
        return
    end
    for k, obj in pairs(this.result_item_list) do 
        if obj then 
            panelMgr:ClearPrefab(obj)
        end 
    end 
    this.result_item_list = nil 
end 

function mt.ClearChat(who)
    local list = this.GetCardList(AREA_ID_CHAT,who)
    if not list then 
        return
    end 
    if #list < 1 then 
        return
    end 
    for k,v in pairs(list)do 
        if v then 
            panelMgr:ClearPrefab(v)    
            list[k]= nil     
        end 
    end 
    list = {}
end 

--清除卡牌
function mt.ClearCard(who,area,posid)

    local list = this.GetCardList(area,who) or nil 
    if not list then 
        return 
    end 
    local obj = list[posid]
    if not obj then 
        return
    end 
    panelMgr:ClearPrefab(obj)   
    list[posid] = nil 
    if area == AREA_ID_HAND then 
        
    elseif area == AREA_ID_PEN then 
    elseif area == AREA_ID_OUT then
        this.out_card = nil 
    elseif area == AREA_ID_FLOWER then 
    end 
end 
-------------------------------关闭------------------------------------
function mt.Close()
    global._view:ClearInvoke()
    this.ResetData()    
    UpdateBeat:Remove(this.TimeEvent,this)
    panelMgr:ClosePanel(CtrlNames.MaJiang)
end 

return this