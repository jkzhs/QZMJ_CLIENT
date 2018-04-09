require "logic/ViewManager"
local global = require("global")
local i18n = global.i18n
YaoLeZiCtrl ={};
local this=YaoLeZiCtrl;

--构建函数--
function this.New()
	return this;
end

--awake
this.gameObject=nil;
this.transform=nil;
this.panel=nil;
this.LB=nil;
this._const=nil;
this.IsGameRoom=nil; --大厅
this.RoomTitle = nil 

this.KEYCTRL=false;--按键控制流程

--data
this.banker_data =nil -- {playerid,name,headimgurl,max_coin}

this._RoomCreate=nil;
this._curState=nil;
this._robData=nil;
this._isBanker=false; -- 庄家



this._FreeTime=0;

this.monentData={}--暂时用来控制全局
this._robBet=0; --抢庄金额
--功能
this._bigshow=nil;
this._IsLiuju=0;
this._uiPreant=nil;
this.allBetCoin=0;--当局下注总金额
this.Bet_PosAndCoin={};--{{posID=,money=,posObj=}}--记录下注点和下注金额

this._result_cards = nil;--{res1=,res2=,res3=}

--Chess
this.allChessList={};--{{obj=,id=,pos=,child={{obj,id,pos},2,3,4,5,6}}}--存储所有实例化出来的押注位置物体
this.currentChess=nil;--{obj=,id=,pos=}--记录当前点击的位置
--放支
this.fangzhi_data=nil--{palyerid=,name=,headimgurl=,max_coin,max_number}

this._shenzhiBet=0;--申支保证金
this.shenzhi_data=nil;--{shenzhi_min_coin=，shenzhi_max_coin=，}
this.canFangzhi=false;
this.isfangzhi=false;
this.fangZhi_Select=false;
this.fangzhi_PosAndCoin=nil--{posID=,money=,posObj=};
--拿支
this.isnazhi=false;
this.canNazhi=false;
this.addnazhi_money_lsit = nil --{obj=}
--动画
--this.coin_create=false;
this.coinAnima_max=nil -- 最多播放数
this.BetAnimaList={};--{{posID=,money=,posObj=}}--钱币动画播放集合
this.coin_finish=true;--动画完成标记
this.coinPrefabList={};--{obj}--钱币预制体集合
this.coin_number=0;--动画播放计数
this.bet_class={};--{{{posID=,money=,posObj=},},}--钱币动画播放分类（根据位置分类）
this.animaCanPlay=false;--能否开始播放动画标记

this.re_bet_list = nil --{{posID,money,posObj,}}--未选择棋子，记录金额

this.is_net_cb = false
--shade 动画
this.isShake=false;--是否摇过奖
this.shadeAmina_1=false;
this.shadeTime_1=0.5;
this.shadeAnima_2=false;
this.shadeTime_2=1.5;
this.shadeStartPos=Vector3(-134,15,0);
--开盖
this.shadeClick=false;
this.pressPos=nil;

--分数
this._startScore = 0;
this._maxScore = 0;
this._playScore = 0;
this._startAnima = false;
this._scoreLen=0;
--动画
this.Speed=0;
--显示结果
this._finalVec={};
this._haveBalance=false;
this._IsOpenGame=false;
this._balanceList={};
this._userBetVec=nil;--{{betusers={player_name=,result_money=},playerid}}
--this.result_card=nil;--结果图片

this._isdaoban = nil 

this.QiPai={
         --中间            1             2            3             4             5              6 
    {id=1,pos=1,child={{id=6,pos=7},{id=2,pos=8},{id=4,pos=13},{id=5,pos=14},{id=-1,pos=-1},{id=-1,pos=-1}}},
    {id=2,pos=2,child={{id=1,pos=9},{id=3,pos=10},{id=4,pos=15},{id=6,pos=17},{id=-1,pos=-1},{id=5,pos=16}}},
    {id=3,pos=3,child={{id=2,pos=11},{id=1,pos=12},{id=5,pos=18},{id=6,pos=19},{id=-1,pos=-1},{id=-1,pos=-1}}},
    {id=4,pos=4,child={{id=1,pos=20},{id=2,pos=21},{id=3,pos=27},{id=5,pos=28},{id=-1,pos=-1},{id=-1,pos=-1}}},
    {id=5,pos=5,child={{id=1,pos=22},{id=3,pos=24},{id=4,pos=29},{id=6,pos=30},{id=2,pos=23},{id=-1,pos=-1}}},
    {id=6,pos=6,child={{id=2,pos=25},{id=3,pos=26},{id=5,pos=31},{id=4,pos=32},{id=-1,pos=-1},{id=-1,pos=-1}}},
}
this.nazhi_pos_id ={ -- posid 查找 nazhi ID 
    [1]=1,  [2]=2,  [3]=3,  [4]=4,  [5]=5,  [6]=6,
    [7]=7,  [8]=13, [9]=13, [10]=14,[11]=14,[12]=8,
    [13]=9, [14]=17,[15]=18,[16]=21,[17]=19,[18]=20,
    [19]=10,[20]=9, [21]=18,[22]=17,[23]=21,[24]=20,
    [25]=19,[26]=10,[27]=11,[28]=15,[29]=15,[30]=16,
    [31]=16,[32]=12,
}
this.nazhi_list =nil--{[id]=obj}
local function Get_Len(list)
    local len = 0
    if list then 
        for k,v in pairs(list)do 
            len = len + 1 
        end 
    end 
    return len 
end 
function this.Awake(roomid,value,title)
	this.RoomId = roomid;
	this.IsGameRoom = value
    this.RoomTitle = title    
    panelMgr:CreatePanel('YaoLeZi',this.OnCreate);
   
    
end

function this.OnCreate(obj)
    this.gameObject=obj;
    this.transform=obj.transform;
    this.panel=this.transform:GetComponent("UIPanel");
    this.LB=this.transform:GetComponent("LuaBehaviour");

    this.YP=YaoLeZiPanel;

    global._view:chat().Awake(global.const.GAME_ID_YAOLEZI);
    this.RenderFunc();
    -- this.RenderNazhi();
    this.Render_Nazhi()
    --Right
    
    this.LB:AddClick(this.YP.okBtn,this.OnOkBtn);
    this.LB:AddClick(this.YP.clearBtn,this.OnClearBtn);
    --money
    this.LB:AddClick(this.YP.betfive,this.OnBet);
    this.LB:AddClick(this.YP.betten,this.OnBet);
    this.LB:AddClick(this.YP.bethund,this.OnBet);
    this.LB:AddClick(this.YP.betkilo,this.OnBet);
    this.LB:AddClick(this.YP.bettenshou,this.OnBet);
    this.LB:AddClick(this.YP.betmill,this.OnBet);
    --nazhiBet
    this.LB:AddClick(this.YP.nazhi_1,this.OnNaZhiBet);
    this.LB:AddClick(this.YP.nazhi_10,this.OnNaZhiBet);
    this.LB:AddClick(this.YP.nazhi_20,this.OnNaZhiBet);

    --bottom
    this.LB:AddClick(this.YP.back,this.OnBack);
    this.LB:AddClick(this.YP.playlist,this.OnPlayerList);
    this.LB:AddClick(this.YP.share,this.OnShare);
    this.LB:AddClick(this.YP.rule,this.OnRule);
    this.LB:AddClick(this.YP.bank,this.OnBank);
    this.LB:AddClick(this.YP.invite,this.OnInvite);
    this.LB:AddClick(this.YP.flexoBtn,this.OnFlexoBtn);
    --upLeft
    this.LB:AddClick(this.YP.rob,this.OnRob);

    --showUI
    this.LB:AddClick(this.YP.uibox,this.CloseShowUI);
    --shadeAnima
    this.LB:AddOnPress(this.YP.shade_gai,this.OnShade);

  

    UpdateBeat:Add(this.TimeEvent,this)

    if global.player:get_paytype() == 1 then 
		this.YP.bank:SetActive(false)
		this.YP.share:SetActive(false)
	end 
end 


function this.Init(data,const,liuju)
    this.YP=YaoLeZiPanel;
    this.monentData=data;--测试用
	global._view:showLoading();
    this._const = const    
    this._RoomCreate = data.house_owner_name;
   
    this.play_type=data.play_type;     

    --房主
    if(this.IsGameRoom==false)then
        if (this._RoomCreate~=nil)then         
            this.YP.roomID_Label.text="房主:" .. GameData.GetShortName(this._RoomCreate,10,10) .. "\n房间号:" .. this.RoomId;
        else
            this.YP.roomID_Label.text="\n房间号:" .. this.RoomId
        end 
	else
		this.YP.roomID_Label.text="\n"..this.RoomTitle;
    end   
    --右边头像框
    this.YP.PlayerIcon_AsyncImageDownload:SetAsyncImage(this.YP.getPlayerImg());
    if data.banker then 
        this.banker_data = data.banker
    end
    if data.fangzhi then 
        this.fangzhi_data = data.fangzhi
    end 
    this.UpdateBankerInfo(this.banker_data)

    this.UpdateTypeAndBout(data)
    
    --更新玩家信息
    this.UpdatePlayerInfo();
    --后面进来的重置shade
    if data.game_status then 
        if data.game_status ~= this._const.YAOLEZI_STATUS_FREE and 
        data.game_status ~= this._const.YAOLEZI_STATUS_BANKER and 
        data.game_status ~= this._const.YAOLEZI_STATUS_SHAKE then 
            this.YP.shade:SetActive(true);
            this.YP.shade.transform.localPosition = Vector3(-134,-230,0)
            this.YP.shade.transform.localScale = Vector3(0.5,0.5,1)
            this.isShake = true 
        end 
    end   
    --更新下注信息
    if data.fangzhi_info then 
        this.InitBetInfo(data.fangzhi_info,2)
    end 
    if data.bet_info then 
        this.InitBetInfo(data.bet_info,1)
    end 
    if data.nazhi_info then 
        this.InitBetInfo(data.nazhi_info,3)
    end  

    -- --更新开奖结果
    -- if this._curState == this._const.YAOLEZI_STATUS_OPEN then 
    --     if data.bet_users then 
    --         this.UpdateResultBet(data.bet_users)
    --     end 
    -- end 
    this.UpdateBetState(this.monentData,liuju);

    global._view:hideLoading();

end

function this.InitBetInfo(data,value)--1 下注 2放支 3拿支
    -- local info ={bet_list={}}
    -- for k,v in pairs(data)do 
    --   info.bet_list[#info.bet_list+1]={
    --       pos = v.posid , 
    --       money = v.money，
    --       playerid = v.playerid  
    --   }
    -- end 
    -- if value == 1 then 
    --     this.UpdateBetData(info,false) --全局下注更新
    -- elseif value == 2 then 
    for k,v in pairs (data)do 
        local list_id = this.GetChessIDByPosID(v.posid)
        local chess = this.GetMainChessByID(list_id.mainChessID)
        local child_chess = nil 
        if list_id.childChessID ~=-1 then 
            child_chess = this.GetMainChessByID(list_id.childChessID)
        end 
        if value == 1 then
            local aver_money = v.money            
            if  child_chess then 
                aver_money = v.money / 2
                this.AddChessAllMoneyAnima(child_chess,aver_money,false)  
            end    
            this.AddChessAllMoneyAnima(chess,aver_money,false)    
            if v.playerid  == this.YP.GetPlayerID() then 
                this.AddChessMoneyAnima(chess,aver_money)
                if  child_chess then 
                    this.AddChessMoneyAnima(child_chess,aver_money)  
                end 
            end 
        elseif value == 2 then 
            this.AddFangzhiMoney(v.posid,v.money)
            this.AddNazhiMoneyAnima(v.posid,v.money)
            local posid = v.posid 
            local money = v.money  
            local obj = nil 

            if posid < 7 then 
                obj = this.GetMainChessByID(posid)
            else 
                local list_id = this.GetChessIDByPosID(posid)
                obj = this.GetChildChessByID(list_id.mainChessID,list_id.childChessID)
            end         
           
            if posid and money and obj  then 
                if not this.fangzhi_PosAndCoin then 
                    this.fangzhi_PosAndCoin = {}
                end
                this.fangzhi_PosAndCoin.posID = posid 
                this.fangzhi_PosAndCoin.money = 0 
                this.fangzhi_PosAndCoin.posObj = obj 
                if this.YP.GetPlayerID() ~= data[1].playerid then 
                    this.canNazhi = true 
                end   
            end 
        elseif value == 3 then 
            local aver_money = v.money            
            if  child_chess then 
                aver_money = v.money / 2
                this.AddChessAllMoneyAnima(child_chess,aver_money,true)  
            end    
            this.AddChessAllMoneyAnima(chess,aver_money,true)
            if v.playerid == this.YP.GetPlayerID() then 
                this.AddNazhiMoneyAnima(v.posid,v.money)
            end 
        end         
    end   
end 

function this.UpdateBetState(data,liuju)
    if (this._const==nil)then 
        return
    end 
    this._FreeTime=data.over_time;
    this._isBanker=false;
    this._curState=data.game_status
  
    local bet="";

    --庄家面板
    this.YP.tiprob:SetActive(false)--箭头提示
    this.YP.rob_UISprite.color = Color.gray
	this.YP.robBg_UISprite.color = Color.gray
    this.YP.robEffect:SetActive(false)   
    --左边下注面板
    this.BetBtnColor(Color.gray);
    --初始化部分信息
    -- this.isShake=false;
    this._IsLiuju = 0

    this.ClearCoinPrefab();

    this.ClearBigShow()
    this.YP.flexoBtn:SetActive(false)
    --跟新开牌记录
    if data.history then 
        this.UpdateRecordResult(data.history)
    end 

    if (this._curState==this._const.YAOLEZI_STATUS_FREE)then --空闲
        bet="空闲";
        if(this.banker_data and 
        this.banker_data.playerid==this.YP.GetPlayerID())then 
            this._isBanker=true
            this.YP.flexoBtn:SetActive(true)
        end  
        
        --清空
        if (this._uiPreant~=nil)then 
            this.CloseShowUI()
        end 

        this.ClearShowMoney();
        this.ClearFangzhi();
        this.ResetNazhiBet();
        this.ResetBet()

        if (this.currentChess~=nil)then 
            this.ClearChessLightByPosID(this.currentChess.pos);
            this.currentChess=nil
        end 
        --流局
        this._IsLiuju=liuju;
        if(this._IsLiuju==1)then
            soundMgr:PlaySound("liuju");
            this.ShowBigTime();
        end  
        if data.daobang then
            this._isdaoban =data.daobang
            this.YP.rob:SetActive(true)
            this.YP.robHead:SetActive(false)
            this.ShowBigTime()
        end 
        if(this.banker_data and data.player_max_coin)then
            this.banker_data.max_coin = data.player_max_coin            
        end 
        this.UpdateBankerInfo(this.banker_data)

        --更新多功能按钮
        this.UpdateFlexoBtnType();
        --重置SHADE
        this.ResetShadeAnima();
        --更新玩家信息
        --  this.UpdatePlayerInfo();
        this.UpdatePlayerMoney()
        --更新局数
        this.UpdateTypeAndBout(data) 
        --显示开牌结果
        this.showAllPlayerPoint()

        this.isShake = false

    elseif(this._curState==this._const.YAOLEZI_STATUS_BANKER)then --抢庄
        bet="抢庄";
        -- this.YP.bankerName_Label.text="庄家:待定\n单字最高下注:0";
        this.banker_data = nil 
        this.UpdateBankerInfo(this.banker_data)

        soundMgr:PlaySound("prob");
        this.ShowBigTime();
        this.YP.tiprob:SetActive(true);
        this.YP.rob_UISprite.color=Color.white;
        this.YP.robBg_UISprite.color = Color.white;
        this.YP.robEffect:SetActive(true);
        --更新多功能按钮
        this.UpdateFlexoBtnType();


    elseif(this._curState==this._const.YAOLEZI_STATUS_SHAKE)then --摇奖
        bet="摇奖";
        
        if  data.banker ~= nil then 
            this.banker_data = data.banker             
        end 
        if(this.banker_data and
         this.banker_data.playerid==this.YP.GetPlayerID())then 
            this._isBanker=true
            soundMgr:PlaySound("merob")--提示音，你做庄
            this.YP.flexoBtn:SetActive(true)
            -- this.UpdatePlayerInfo();
            this.UpdatePlayerMoney();
        end 
        if(this._isBanker)then 
            soundMgr:PlaySound("merob");
            -- this.ShowBigTime();
        end 
        if (this._uiPreant~=nil)then 
            this.CloseShowUI()
        end 

        this.UpdateBankerInfo(this.banker_data)

        this.UpdateFlexoBtnType();  
    elseif(this._curState==this._const.YAOLEZI_STATUS_SHENZHI)then --申支
        bet="申支"
        if(this.banker_data and 
        this.banker_data.playerid==this.YP.GetPlayerID())then 
            this._isBanker=true
            this.YP.flexoBtn:SetActive(true)
        end         
        this.fangzhi_data = nil
        --更新多功能按钮 
        this.UpdateFlexoBtnType();

        this.ShowBigTime()
        --播放摇奖动画
        this.StartShadeAnima()

    elseif(this._curState==this._const.YAOLEZI_STATUS_FANGZHI)then --放支        
        bet="放支"
        if(this.banker_data and
        this.banker_data.playerid==this.YP.GetPlayerID())then 
            this._isBanker=true
            this.YP.flexoBtn:SetActive(true)
        end 
        if (this._uiPreant~=nil)then 
            this.CloseShowUI()
        end 
        --获取放支支人的信息
        if data.fangzhi then 
            this.fangzhi_data =data.fangzhi
            if this.fangzhi_data.playerid == this.YP.GetPlayerID() then                 
                this.canFangzhi = true 
                this.BetBtnColor(Color.white); 
                this.isfangzhi = true 

                this.UpdatePlayerMoney()
                --设置放支金额提醒
                this.ShowBigTime()
            else
                this.canFangzhi = false              
            end 
            --更新放支人的信息显示
            this.UpdateFangzhiInfo(this.fangzhi_data)
        end               
        --更新多功能按钮
        this.UpdateFlexoBtnType();      

    elseif(this._curState==this._const.YAOLEZI_STATUS_BET)then --下注(拿支)
        bet="下注"
        if data.fangzhi_max_number then 
            this.fangzhi_data.max_number = data.fangzhi_max_number
        end 
        if(this.banker_data and
        this.banker_data.playerid==this.YP.GetPlayerID())then 
            this._isBanker=true
            this.YP.flexoBtn:SetActive(true)
        end 
        -- this.canNazhi=data.canNazhi;
        if (this.animaCanPlay==false)then 
            this.isfangzhi=false;
        end 
        if (this._uiPreant~=nil)then 
            this.CloseShowUI()
        end 
        this.canFangzhi = false
        this.fangZhi_Select=false;
        this.UpdateFlexoBtnType();
        if (this._isBanker==false)then 
            this.BetBtnColor(Color.white);
        end             
        --更新庄家信息显示
        if this.banker_data then 
            this.UpdateBankerInfo(this.banker_data)
        end 

        --清空未确定的放支信息
        this.NextClearBet()
        if this.fangzhi_PosAndCoin then 
            this.fangzhi_PosAndCoin.money=0
        end 
        --播放摇奖动画
        this.StartShadeAnima()
        this.ShowBigTime()
        
    elseif(this._curState==this._const.YAOLEZI_STATUS_OPEN)then --开牌
        bet="开牌"
        if(this.banker_data and
        this.banker_data.playerid==this.YP.GetPlayerID())then 
            this._isBanker=true
            this.YP.flexoBtn:SetActive(true)
        end
        if(global._view:getViewBase("PlayerList")~=nil)then
			global._view:getViewBase("PlayerList").clearView();
		end
        --更新开牌结果
        if data.result_cards then 
            this._result_cards = data.result_cards         
            this.UpdateShadeChessResult(data.result_cards)
        end 
        --更新下注结果
        this.UpdateResultBet(data.bet_users);
        --更新多功能按钮
        this.UpdateFlexoBtnType();
        --遮罩上升
        this.SandeAnima_Move_4();

        this.ShowBigTime()

    end
    this.YP.betState_Label.text=bet; 
end
--全局下注信息更新
function this.UpdateBetData(info,value)
    local list = info.bet_list
    local is_nazhi = value 
    for k , v in pairs (list) do 
        local list_id = this.GetChessIDByPosID(v.pos)
        local chess_obj 
        local aver_money = v.money  
        if list_id.childChessID ~=-1 then 
            aver_money = v.money /2 
            chess_obj = this.GetMainChessByID(list_id.childChessID)
            this.AddChessAllMoneyAnima(chess_obj,aver_money,is_nazhi)
        end
        chess_obj = this.GetMainChessByID(list_id.mainChessID)
        this.AddChessAllMoneyAnima(chess_obj,aver_money,is_nazhi)        
    end 
      

end 
function this.ChatBet(data,value)--1下注 2 放支 3 拿支
    --chat
    local str 
    if value==1 then 
        str ="下注"
    elseif value == 2 then  
        str = "放支"
    elseif value == 3 then 
        str = "拿支"
    end 
    -- local coin =0;
    local il18 = "在%s位置%s%s分%s"--在 车 位置 下注 5 分 ，
    local list = data.bet_list
    local len =#list;
    local text = ""
	for i=1,len do 
        -- coin=coin+list[i].money;
        
        local cardid_list = this.GetChessIDByPosID(list[i].pos)
        local nu  = 1
        if cardid_list.childChessID ~= -1 then 
            nu = 2
        end 
        local money = list[i].money/nu
        local main_str = nil 
        local child_str = nil 
        
        if cardid_list.mainChessID ~= -1 then 
           main_str = this.GetFontAndColorByID(cardid_list.mainChessID).font
        end
        if cardid_list.childChessID ~= -1 then 
            child_str = this.GetFontAndColorByID(cardid_list.childChessID).font
        end
        if main_str then 
            if i ~= len then 
                text =text..string.format(il18,main_str,str,money,",")
                if child_str then 
                    text = text..string.format(il18,child_str,str,money,",")
                end 
            else 
                if not child_str then 
                    text =text..string.format(il18,main_str,str,money,"。")
                else 
                    text =text..string.format(il18,main_str,str,money,",")
                    text = text..string.format(il18,child_str,str,money,"。")
                end 
            end 
        end 
	end 
	local who =0;
	local name =data.player_name;
	if (name~=this.YP.GetPlayerName())then
		who=1;
	end
	local info ={
		player_name=data.player_name,
        -- msg=str..":"..coin,
        msg = text ,
		from_headid=data.headimgurl,
	}
	if(global._view:getViewBase("Chat")~=nil)then
		global._view:getViewBase("Chat").UpdateMessage(info,who);
    end 
end 

function this.TimeEvent()
    this.BetAnima();
    if this.KEYCTRL then        
        this.ControllerByKey(); 
    end 
    this.ShadeAnimaTime();
    this.OpenShade();
    this.FreeTimeEvent();
    this.UpdateBalanceScore();
end 
function this.FreeTimeEvent()
    if (this._FreeTime > 0) then
		local time = this._FreeTime - this.YP.GetTime()
		if (time >= 0) then
			local hours = math.floor(time / 3600);
			time = time - hours * 3600;
			local minute = math.floor(time / 60);
			time = time - minute * 60;
            this.YP.timeTxt_Label.text= GameData.changeFoLimitTime(time);
            --自动摇奖
            -- if (this._curState==this._const.YAOLEZI_STATUS_SHAKE and this.isShake==false)then 
            --     if (time<=3)then 
            --         this.ShadeAnima_BigToSmall_1();
            --         this.shadeAmina_1=true;
            --         this.isShake=true;
            --     end 
            -- end
            --自动开牌
            if (this._curState==this._const.YAOLEZI_STATUS_OPEN )then 
                if (time<=3)then 
                    local pos=this.YP.shade_gai.transform.localPosition
                    local tp=this.YP.shade_gai:GetComponent("TweenPosition");
                    
                    tp.from=pos;
                    tp.duration=0.3
                    tp:ResetToBeginning();
                    if (pos.x>=0 and pos.x<85)then 
                        pos.x=100;
                        tp.to=pos;
                        tp.enabled=true 
                        this.YP.shade_gai_collider.enabled=false;
                        this.shadeClick=false   
                    end 
                    if (pos.x<0 and pos.x>-85)then 
                        pos.x=-100;
                        tp.to=pos;
                        tp.enabled=true
                        this.YP.shade_gai_collider.enabled=false;
                        this.shadeClick=false       
                    end
                end   
            end 
		else
			this._FreeTime = 0;
			this.YP.timeTxt_Label.text ="00"
		end		
	end
end

--controler
function this.ControllerByKey()
    -- if (Input.GetKeyDown(KeyCode.K))then
    --     this.ClearCoinPrefab();
    -- end
    -- if (Input.GetKeyDown(KeyCode.L))then
    --     this.ClearShowMoney();
    -- end
    -- if (Input.GetKeyDown(KeyCode.U))then
    --     if(this.monentData.canFangzhi)then 
    --         this.monentData.canFangzhi=false
    --         this.YP.fangzhilabel.text="fangzhi:false"
    --     else 
    --         this.monentData.canFangzhi=true
    --         this.YP.fangzhilabel.text="fangzhi:true"
    --     end         
    -- end
    -- if (Input.GetKeyDown(KeyCode.Y))then
    --     if(this.monentData.canNazhi)then 
    --         this.monentData.canNazhi=false
    --         this.YP.nazhilabel.text="nazhi:false"
    --     else 
    --         this.monentData.canNazhi=true
    --         this.YP.nazhilabel.text="nazhi:true"
    --     end 
    -- end
    -- if (Input.GetKeyDown(KeyCode.I))then
    --     this. ClearFangzhi();
    -- end 
    -- if (Input.GetKeyDown(KeyCode.P))then
    --     local i= this.monentData.game_status;
    --     i=i+1;
    --     if (i>11)then 
    --         i=5
    --     end 
    --     this.monentData.game_status=i;
    --     this.monentData.over_time=this.YP.GetTime()+10;
    --     this.UpdateBetState(this.monentData,0);
    -- end
    -- if (Input.GetKeyDown(KeyCode.Q))then
    --     this. ResetShadeAnima();
    -- end
    -- if (Input.GetKeyDown(KeyCode.W))then
    --     this.ShadeAnima_BigToSmall_1();
    --     this.shadeAmina_1=true;
    -- end
    -- if (Input.GetKeyDown(KeyCode.E))then
    --     this.SandeAnima_Move_4();
    -- end
    -- if (Input.GetKeyDown(KeyCode.Z))then
    --     local data={}
    --     data.res1=math.random(1,6);
    --     data.res2=math.random(1,6);
    --     data.res3=math.random(1,6);
    --     this.UpdateRecordResult(data);
    --     this.UpdateShadeChessResult(data);
    -- end
    
end 
--anima 动画
--bet
function this.BetAnima()
    if (#this.BetAnimaList>0 and this.animaCanPlay )then 
        if (this.KEYCTRL == false)then 
            if this.is_net_cb == false then 
                return
            end 
        end 
        if this.coin_finish==true then
           --this.BetAnimaList=this.bet_class[this.coin_number];
            this.coin_number=this.coin_number+1;
            this.coin_finish=false;
            local list =this.BetAnimaList[this.coin_number];
            --动画时间控制
            local animatime =1.2/#this.BetAnimaList
            if (animatime>0.2)then 
                animatime = 0.2 
            end 
            for i=1, #list do
                local data=list[i]
                local obj=data.posObj;
                local parent=obj.transform.parent;
                obj.transform.parent=this.YP.chessList;
                local toPos=obj.transform.localPosition;
                obj.transform.parent=parent;
                local money=data.money;
                if this.isnazhi then 
                    this.AddNazhiMoneyAnima(data.posID,money) 
                else
                    if (data.posID<7 --[[or this.isfangzhi]])then
                        if (this.isfangzhi)then
                            local sign=obj.transform:Find("signCoin").gameObject;
                            this.AddChessMoneyAnima(sign,money);
                            this.AddNazhiMoneyAnima(data.posID,money)
                        else                           
                            this.AddChessMoneyAnima(obj,money);
                        end               
                    else
                        local info=this.GetChessIDByPosID(data.posID);
                        local chess_1=this.GetMainChessByID(info.mainChessID);
                        local chess_2=this.GetMainChessByID(info.childChessID);
                        if (this.isfangzhi)then
                            local sign_1=chess_1.transform:Find("signCoin").gameObject;
                            local sign_2=chess_2.transform:Find("signCoin").gameObject;
                            this.AddChessMoneyAnima(sign_1,money/2);
                            this.AddChessMoneyAnima(sign_2,money/2);
                            this.AddNazhiMoneyAnima(data.posID,money)
                        else
                            this.AddChessMoneyAnima(chess_1,money/2);
                            this.AddChessMoneyAnima(chess_2,money/2);
                        end 
                    end               
                    
                end
                --生成筹码，并播放飞行动画
                if #list >10 and animatime <0.1 and i <6 then
                    --头5个正常显示飞行动画
                    this.CreateBetAnima(toPos,money,0.1); 
                else
                    this.CreateBetAnima(toPos,money,animatime); 
                end              
            end                       
        end
        if (this.coin_number>=#this.BetAnimaList)then
            --this.Bet_PosAndCoin={};
            --this.ClearCoinPrefab();
            this.bet_class={};   
            this.coin_number=0;
            this.coinAnima_max=0;
            this.animaCanPlay=false; 
            this.is_net_cb = false   
            this.BetAnimaList={}; 
            if (this._curState==this._const.YAOLEZI_STATUS_BET)then 
                this.isfangzhi=false;
            end   
        end 
    end   
end 

function this.CreateBetAnima(toPos,money,animatime)
    local bundle=resMgr:LoadBundle("Coin");
    local Prefab=resMgr:LoadBundleAsset(bundle,"Coin");
    local parent=this.YP.chessList;
    local go =GameObject.Instantiate(Prefab);
    go.transform.parent=parent;
    go.transform.localPosition=Vector3(637,-47,0);
    go.transform.localScale=Vector3.one;
    go.name=money;
    resMgr:addAltas(go.transform,"YaoLeZi");
    local sprite =go:GetComponent("UISprite");   
    local str=this.GetCoinNameByValue(money);
    sprite.spriteName=str;
    table.insert(this.coinPrefabList,go);
    local tp=go:GetComponent("TweenPosition")
    tp.from=Vector3(637,-47,0);
    tp.to=toPos;
    tp.duration=animatime;    
    tp.enabled=true;
    --tp.ResetToBeginning();
    resMgr:TweenPosEventDeleate(tp,function()
        tp.enabled=false;
        this.coin_finish=true; 
        local ta=go:GetComponent("TweenAlpha");
        ta.from=1;
        ta.to=0;
        ta.duration=0.3;        
        ta.enabled=true;
        --ta.ResetToBeginning();
    end);
end 
function this.GetCoinNameByValue(money)
    local str=nil 
    if (money<5)then 
        str="youbiandikuang_chouma_6"
    elseif (money<10)then 
        str="youbiandikuang_chouma_3"
    elseif (money<20)then 
        str="youbiandikuang_chouma_5"
    elseif (money<50)then 
        str="youbiandikuang_chouma_4"
    elseif (money<100)then 
        str="youbiandikuang_chouma_1"
    else 
        str="youbiandikuang_chouma_2"
    end
    return str;
end 
function this.AddFangzhiMoney(posid,money)
    local listID=this.GetChessIDByPosID(posid);
    local chess1=this.GetMainChessByID(listID.mainChessID);        
    local chess_1_Sign=chess1.transform:Find("signCoin").gameObject;
    chess_1_Sign:SetActive(true); 
    local chess2=nil;
    local aver_money = money 
    if (listID.childChessID~=-1)then
        chess2=this.GetMainChessByID(listID.childChessID);
        local chess_2_Sign= chess2.transform:Find("signCoin").gameObject;
        chess_2_Sign:SetActive(true); 
        if money then 
            aver_money = money/2
            this.AddChessMoneyAnima(chess_2_Sign,aver_money,false)
        end    
    end 
    if money then 
        this.AddChessMoneyAnima(chess_1_Sign,aver_money)
    end  
end 

function this.AddNazhiMoneyAnima(posID,money)
    local id = this.nazhi_pos_id[posID]
    local nahzi_obj = this.nazhi_list[id]
    local label_obj = nahzi_obj.transform:Find("label").gameObject
    local label = label_obj:GetComponent("UILabel")
    local coin = string.gsub(label.text,"支","")+0
    coin = coin + money 
    label.text = coin.."支"
    nahzi_obj:SetActive(true);
    local ts=label_obj:GetComponent("TweenScale");
    if ts then
        ts.enabled=false
        ts.enabled=true;
        ts:ResetToBeginning();
    end
    if not this.addnazhi_money_lsit then 
        this.addnazhi_money_lsit = {}
    end 
    local data = {
        obj = nahzi_obj
    }
    table.insert(this.addnazhi_money_lsit,data)
end 
function this.AddChessMoneyAnima(obj,money)
    local moneyObj=nil;
    local show_obj = nil 
    show_obj = obj.transform:Find("betmoney").gameObject
    moneyObj=show_obj.transform:Find("money").gameObject;    
    show_obj:SetActive(true);
    local ts=moneyObj:GetComponent("TweenScale");
    if ts then
        ts.enabled=false
        ts.enabled=true;
        ts:ResetToBeginning();
    end    
    local label= moneyObj:GetComponent("UILabel");
    label.text=label.text+money;
    return moneyObj
end
--全局下注金额或拿支金额，
function this.AddChessAllMoneyAnima(obj,money,is_nazhi)
    local moneyObj=nil;
    local show_obj = nil 
    if (is_nazhi)then
        show_obj = obj.transform:Find("nazhiallmoney").gameObject
        moneyObj=show_obj.transform:Find("allNazhiMoney").gameObject;
        
    else
        show_obj = obj.transform:Find("betallmoney").gameObject
        moneyObj=show_obj.transform:Find("allMoney").gameObject;
    end         
    show_obj:SetActive(true);
    local ts=moneyObj:GetComponent("TweenScale");
    ts.enabled=false
    ts.enabled=true;
    ts:ResetToBeginning();   
    local label= moneyObj:GetComponent("UILabel");
    label.text=label.text+money;
    return moneyObj
end 
   
function this.ClearCoinPrefab() 
    if (#this.coinPrefabList<1)then 
        return
    end 
    for i=1,#this.coinPrefabList do 
        local ret,message = pcall(function()
            panelMgr:ClearPrefab(this.coinPrefabList[i]);
            return true 
        end )       
    end 
    this.coinPrefabList={};
    this.coin_finish=true;
end 
function this.ClearShowMoney()
    for i=1,#this.allChessList do
       local show_obj= this.allChessList[i].obj.transform:Find("betmoney").gameObject
       local moneyObj=show_obj.transform:Find("money").gameObject;
       local label=moneyObj:GetComponent("UILabel");
       label.text=0;
       show_obj:SetActive(false);  
       show_obj= this.allChessList[i].obj.transform:Find("betallmoney").gameObject
       moneyObj=show_obj.transform:Find("allMoney").gameObject;
       label=moneyObj:GetComponent("UILabel");
       label.text=0;
       show_obj:SetActive(false);
       show_obj= this.allChessList[i].obj.transform:Find("nazhiallmoney").gameObject
       moneyObj= show_obj.transform:Find("allNazhiMoney").gameObject;
       label=moneyObj:GetComponent("UILabel");
       label.text=0;
       show_obj:SetActive(false); 
    --    show_obj= this.allChessList[i].obj.transform:Find("betmoney").gameObject
    --    moneyObj=this.allChessList[i].obj.transform:Find("nazhiMoney").gameObject;
    --    label=moneyObj:GetComponent("UILabel");
    --    label.text=0;
    --    moneyObj:SetActive(false);
    end 
    if this.addnazhi_money_lsit then 
        for k,v in pairs(this.addnazhi_money_lsit) do 
            local label = v.obj.transform:Find("label"):GetComponent("UILabel")
            label.text ="0支"
            v.obj:SetActive(false)    
        end 
        this.addnazhi_money_lsit = nil 
    end 
   
end 
function this.ClearFangzhi()
    if (this.fangzhi_PosAndCoin==nil)then 
        return
    end 
    if (not this.fangzhi_PosAndCoin.posObj) then 
        return
    end 

    local money
    local money_label
    local list=this.GetChessIDByPosID(this.fangzhi_PosAndCoin.posID);
    local chess1=this.GetMainChessByID(list.mainChessID);
    local chess1_nazhiLight=chess1.transform:Find("nazhiLight").gameObject;
    local chess_1_Sign=chess1.transform:Find("signCoin").gameObject;
    local chess2=nil ;
    local chess2_nazhiLight=nil;    
    if (list.childChessID~=-1)then
        chess2=this.GetMainChessByID(list.childChessID);        
        chess2_nazhiLight=chess2.transform:Find("nazhiLight").gameObject;
        chess_2_Sign = chess2.transform:Find("signCoin").gameObject;
    end
    chess1_nazhiLight:SetActive(false);
    chess_1_Sign:SetActive(false);
    money=chess_1_Sign.transform:Find("betmoney/money").gameObject;
    money_label=money:GetComponent("UILabel");
    money_label.text=0;
    if (chess2~=nil)then 
       chess2_nazhiLight:SetActive(false);
       chess_2_Sign:SetActive(false);
       money=chess_2_Sign.transform:Find("betmoney/money").gameObject;
       money_label=money:GetComponent("UILabel");
       money_label.text=0;
    end 
    this.fangZhi_Select=false;
    this.isfangzhi=false;
    this.canFangzhi=false;  
    this.shenzhi_data = nil 

    
    -- this.fangzhi_PosAndCoin={posID=-1,money=0,posObj=nil};
    this.fangzhi_PosAndCoin = nil 
end
function this.ClearBigShow()
    if (this._bigshow ~= nil) then
		panelMgr:ClearPrefab(this._bigshow);
	end
	this._bigshow = nil
end 
function this.ClearChessLightByPosID(id)
    if (id<7)then
        local mainObj=this.GetMainChessByID(id);
        mainObj.transform:Find("Light").gameObject:SetActive(false);
    else
        local list =this.GetChessIDByPosID(id);
        local mainObj=this.GetMainChessByID(list.mainChessID);
        if(mainObj~=nil)then 
            mainObj.transform:Find("Light").gameObject:SetActive(false);
        end  
        local childObj=this.GetChildChessByID(list.mainChessID,list.childChessID);
        if(childObj~=nil)then 
            childObj.transform:Find("Light").gameObject:SetActive(false);
        end 
        mainObj=this.GetMainChessByID(list.childChessID);
        if(mainObj~=nil)then 
            mainObj.transform:Find("Light").gameObject:SetActive(false);
        end        
        childObj=this.GetChildChessByID(list.childChessID,list.mainChessID);
        if(childObj~=nil)then 
            childObj.transform:Find("Light").gameObject:SetActive(false);
        end 
    end
end 

function this.ShadeAnimaTime()
    if (this.shadeAmina_1)then 
        this.shadeTime_1=this.shadeTime_1-Time.deltaTime;
        if (this.shadeTime_1<0)then
            this.shadeAmina_1=false;
            this.shadeTime_1=0.5;
            this.shadeAnima_2=true;
            this.ShadeAnima_Shake_2(true);
        end
    end 
    if (this.shadeAnima_2)then 
        this.shadeTime_2=this.shadeTime_2-Time.deltaTime;
        if (this.shadeTime_2<0)then
            this.ShadeAnima_Shake_2(false);
            this.shadeAnima_2=false;
            this.shadeTime_2=1.5;
            this.ShadeAnima_Move_3();
        end 
    end 
end 
function this.ShadeAnima_BigToSmall_1()
    this.YP.shade:SetActive(true);
    local ts=this.YP.shade:GetComponent("TweenScale");
    ts.from=Vector3(5,5,1);
    ts.to=Vector3(2,2,1);
    ts.duration=0.3;
    ts:ResetToBeginning();
    ts.enabled=true;
end 
function this.ShadeAnima_Shake_2(value)
    local versa=true;
    if (value)then 
        soundMgr:PlaySound("yaolezi_touzi") 
        versa =false
    end 
    this.YP.shade:SetActive(versa)
    this.YP.shadeAnimaObj:SetActive(value);
    this.YP.shade_anima:SetBool("shake",value);
       
end 
function this.ShadeAnima_Move_3()
    local ts=this.YP.shade:GetComponent("TweenScale");
    local tp=this.YP.shade:GetComponent("TweenPosition");
    ts.from=Vector3(2,2,1);
    ts.to=Vector3(0.5,0.5,1);
    ts.duration=0.3;
    tp.from=this.shadeStartPos;
    tp.to =Vector3(-134,-230,0);
    tp.duration=0.3;
    ts:ResetToBeginning();
    tp:ResetToBeginning();
    ts.enabled=true;
    tp.enabled=true;
end 
function this.SandeAnima_Move_4()
    local ts=this.YP.shade:GetComponent("TweenScale");
    local tp=this.YP.shade:GetComponent("TweenPosition");
    ts.from=Vector3(0.5,0.5,1);
    ts.to=Vector3(2,2,1);
    ts.duration=0.3;
    tp.from=Vector3(-134,-230,0);
    tp.to =this.shadeStartPos;
    tp.duration=0.3;
    ts:ResetToBeginning();
    tp:ResetToBeginning();
    ts.enabled=true;
    tp.enabled=true;
end 
function this.StartShadeAnima()
    if this.isShake then 
        return 
    end 
    this.ShadeAnima_BigToSmall_1()
    this.shadeAmina_1 = true 
    this.isShake = true 
    
end 
function this.OpenShade()
    if (this.shadeClick)then 
        local pos =this.YP.shade_gai.transform.localPosition;       
       
        local value =Input.mousePosition.x-this.pressPos.x
        pos.x=value/2+pos.x;
        if (pos.x>128)then 
            pos.x=128
        elseif (pos.x<-128)then 
            pos.x=-128
        end 
        this.YP.shade_gai.transform.localPosition=pos;
        this.pressPos.x=this.pressPos.x+value;
        
        
    end 
end 
function this.ResetShadeAnima()
    this.YP.shade:SetActive(false);
    this.YP.shade_anima:SetBool("shake",false);
    this.YP.shade.transform.localPosition=this.shadeStartPos;
    this.shadeAmina_1=false;
    this.shadeTime_1=0.5;
    this.shadeAnima_2=false;
    this.shadeTime_2=1.5;
    this.YP.shade_gai.transform.localPosition=Vector3.zero;
    local tp = this.YP.shade_gai:GetComponent("TweenPosition")
    tp.from =Vector3.zero
    tp.enabled = false
    this.YP.shade_gai.transform.localScale=Vector3.one;
    this.YP.shade_gai_collider.enabled=true;
    this.YP.shade_gai_sprite.color=Color.white;
end 
function this.ResetNazhiBet()
    local tp =this.YP.nazhiBet:GetComponent("TweenPosition");
    local pos =this.YP.nazhiBet.transform.localPosition;
    this.YP.flexoBtn_label.text="申请拿支";
    tp.from=pos;
    tp.to=Vector3(310,74,0);
    tp.duration=0.3;
    tp:ResetToBeginning();
    tp.enabled=true;
    this.isnazhi=false;
    this.re_bet_list = nil 
    this.Bet_PosAndCoin={};
    this.canNazhi = false;
end 
function this.ResetBet()
    this.allBetCoin = 0
    this.YP.sumBetMoney_Label.text = 0 
end 

--功能
  --显示UI
function this.showUIprefab(name)
	this.YP.uibox:SetActive(true)
	local pane = name.."bar"
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == pane) then
			return
		end
	end
	local bundle = resMgr:LoadBundle(name);
    local Prefab = resMgr:LoadBundleAsset(bundle,name);
    this._uiPreant = GameObject.Instantiate(Prefab);
	this._uiPreant.name = name .. "bar";
	this._uiPreant.transform.parent = this.YP.showUI.transform;
	this._uiPreant.transform.localScale = Vector3.one;
    this._uiPreant.transform.localPosition = Vector3.zero;
    if (name=="shenzhiPanel") then 
        resMgr:addAltas(this._uiPreant.transform,"SetRoom")
    else
        resMgr:addAltas(this._uiPreant.transform,"Room")--暂时先用room的图集
    end 
	
end
function this.RenderFunc()
    local parent=YaoLeZiPanel.chessList;
    local bundle=resMgr:LoadBundle("Chess");
    local Prefab=resMgr:LoadBundleAsset(bundle,"Chess");
    local space=335;
    local len =#this.QiPai
    for i=1,len do 
        local mainChessList={obj=nil,id=nil,pos=nil,child={}};
        local data=this.QiPai[i];
        local childData=data.child;
        local na="chess"..data.id;
        local go =GameObject.Instantiate(Prefab);
        go.name=na;
        go.transform.parent=parent;
        go.transform.localScale=Vector3.one;
        local sprite=go.transform:Find("Sprite"):GetComponent("UISprite");
        sprite:MakePixelPerfect();
        sprite.spriteName=this.ChessSpriteNameByID(data.id);
        if (i<4)then 
            go.transform.localPosition=Vector3(-335+space*(i-1),129,0);
        else
            go.transform.localPosition=Vector3(-335+space*(i-4),-129,0);
        end 
        mainChessList.obj=go;
        mainChessList.id=data.id;
        mainChessList.pos=data.pos;
        this.LB:AddClick(go,this.OnChessClick);        
        local tr=go.transform;
        resMgr:addAltas(tr,"YaoLeZi");
        local childLen=#childData;
        for i=1,childLen do
            local childChessList={obj=nil,id=nil,pos=nil}; 
            local da=childData[i];
            if (da.id~=-1)then 
                local str=this.ChessSpriteNameByID(da.id);
                local obj=go.transform:GetChild(i).gameObject;
                obj:SetActive(true);
                this.LB:AddClick(obj,this.OnChildChessClick);
                local sprite=obj.transform:Find("Sprite"):GetComponent("UISprite");               
                sprite.spriteName=str;
                childChessList.obj=obj;
                childChessList.id=da.id;
                childChessList.pos=da.pos;
                table.insert(mainChessList.child,childChessList);
            end 
        end
        table.insert(this.allChessList,mainChessList);
    end
end 
-- function this.RenderNazhi()
--     for i=1 ,21 do 
--         local obj = this.YP.nazhiList:GetChild(i-1).gameObject
--         -- local id = obj.name+0
--         this.nazhi_id_obj[i]=obj
--     end 
-- end
function this.Render_Nazhi()
    local parent=this.YP.nazhiList;
    local bundle=resMgr:LoadBundle("nazhi");
    local Prefab=resMgr:LoadBundleAsset(bundle,"nazhi");
    local space_1=335;
    local space_2=870;
    local len =21
    for i=1,len do 
        local na="nazhi"..i;
        local go =GameObject.Instantiate(Prefab);
        go.name=na;
        go.transform.parent=parent;
        go.transform.localScale=Vector3.one;
        local sprite=go.transform:Find("sprite").gameObject
        -- sprite:MakePixelPerfect();
        local label = go.transform:Find("label").gameObject
        --位置调整
        if (i<7)then            
            if i<4 then
                go.transform.localPosition=Vector3(-370+space_1*(i-1),95,0);
            else 
                go.transform.localPosition=Vector3(-370+space_1*(i-4),-170,0);
            end             
        elseif i <13 then 
            if i<9 then 
                go.transform.localPosition=Vector3(-445+space_2*(i-7),185,0);
            elseif i<11 then 
                go.transform.localPosition=Vector3(-445+space_2*(i-9),-30,0);
            elseif i<13 then 
                go.transform.localPosition=Vector3(-445+space_2*(i-11),-245,0);
            end 
        elseif i <17 then 
            if i<15 then 
                go.transform.localPosition=Vector3(-180+space_1*(i-13),175,0);
            elseif i<17 then 
                go.transform.localPosition=Vector3(-180+space_1*(i-15),-235,0);
            end 
        elseif i < 21 then 
            if i<19 then 
                go.transform.localPosition=Vector3(-180,-30,0);
            else
                go.transform.localPosition=Vector3(155,-30,0);
            end 
        else 
            go.transform.localPosition=Vector3(-30,-30,0);        
        end 
        --图片调整
        if i>12 and i<17 then 
            sprite.transform.localRotation = Quaternion.Euler(Vector3(0,0,90))
        end 
        if i == 17 or i == 19 then 
            sprite.transform.localRotation =Quaternion.Euler(Vector3(0,0,45)) 
        end 
        if i == 18 or i == 20 then 
            sprite.transform.localRotation =Quaternion.Euler(Vector3(0,0,-45)) 
        end 
        --文字位置调整
        --上
        if i == 13 or i == 14 then 
            label.transform.localPosition = Vector3(8,53,0)
        end 
        --下
        if i == 15 or i == 16 then 
            label.transform.localPosition = Vector3(8,4,0)
        end 
        --左
        if i == 7 or i == 9 or i == 11 or i ==18 or i == 20 then 
            label.transform.localPosition = Vector3(-28,30,0)
        end 
        if not this.nazhi_list then     
            this.nazhi_list = {}
        end 
        this.nazhi_list[i]=go 
        local tr=go.transform;
        resMgr:addAltas(tr,"YaoLeZi");
    end
end 

function this.renderPlayer(list)
	global._view:playerList().Awake(list);
end
function this.BetBtnColor(color)
	this.YP.betfive_UISprite.color = color
	this.YP.betten_UISprite.color = color
	this.YP.bethund_UISprite.color = color
	this.YP.betkilo_UISprite.color = color
	this.YP.bettenshou_UISprite.color = color
	this.YP.betmill_UISprite.color = color
	this.YP.okBtn_UISprtie.color = color
	this.YP.clearBtn_UISprite.color = color

end
function this.ChessSpriteNameByID(id)
    if (id==1)then 
        return "zishuai"
    elseif (id==2)then 
        return "zisiwei"
    elseif (id==3)then 
        return "zixiang"
    elseif (id==4)then 
        return "ziche"        
    elseif (id==5)then 
        return "zima"        
    elseif (id==6)then 
        return "zipao"
    end
end         
function this.GetFontAndColorByID(id)
    local list={font=nil,color=nil}
    if (id==1)then 
       list.font="帥";
       list.color=Color.red;
    elseif (id==2)then 
        list.font="仕";
        list.color=Color.red;
    elseif (id==3)then 
        list.font="相";
        list.color=Color.red;
    elseif (id==4)then 
        list.font="車";
        list.color=Color.white;     
    elseif (id==5)then 
        list.font="馬";
        list.color=Color.white;      
    elseif (id==6)then 
        list.font="包";
        list.color=Color.white;
    end
    return list;
end 
function this.GetShareSpriteNameByID(id)
    if (id==1)then 
        return "tbshaizishuai"
    elseif (id==2)then 
        return "tbshaizishi"
    elseif (id==3)then 
        return "tbshaizixiang"
    elseif (id==4)then 
        return "tbshaiziche"        
    elseif (id==5)then 
        return "tbshaizima"        
    elseif (id==6)then 
        return "tbshaizipao"
    end
end 
function this.GetChessIDByPosID(id)
    local list ={mainChessID=-1,childChessID=-1};    
    if (id<7)then 
        list.mainChessID=id;
    else
        for k ,v in pairs(this.QiPai)do 
            local childData=v.child;
            for k1,v1 in pairs(childData)do 
                if (id==v1.pos)then 
                   list.mainChessID=v.id;
                   list.childChessID=v1.id;
                   break
                end                
            end 
        end 
    end 
    if list.mainChessID~=-1 then 
        return list
    end 
end  
function this.GetMainChessByID(id)
    if (#this.allChessList<1)then 
        return
    end 
    for k,v in pairs(this.allChessList)do 
        if (v.id==id )then 
            return v.obj;
        end 
    end
    return nil ;
end

function this.GetChildChessByID(mainID,childID)
    if (#this.allChessList<1)then 
        return
    end 
    for k ,v in pairs(this.allChessList)do 
        if (v.id ==mainID)then 
            local list =v.child;
            for k1,v1 in pairs(list)do 
                if (v1.id==childID)then 
                    return v1.obj;
                end 
            end
        end      
    end
    return nil 
end

function this.ShowBigTime()
	local bundle = resMgr:LoadBundle("bigshow");
	local Prefab = resMgr:LoadBundleAsset(bundle,"bigshow");
	this._bigshow = GameObject.Instantiate(Prefab);
	this._bigshow.name = "bigshowbar";
	this._bigshow.transform.parent = this.YP.Tips.transform;
	this._bigshow.transform.localScale = Vector3.one;
	this._bigshow.transform.localPosition = Vector3(0,32,0);---135
	resMgr:addAltas(this._bigshow.transform,"Room")
	local showtip = this._bigshow.transform:Find("showtip");
	local liuju = showtip:Find('liuju').gameObject;
	local popen = showtip:Find('popen').gameObject;
	local pbet = showtip:Find('pbet').gameObject;
	local prob = showtip:Find('prob').gameObject;
    local pselect=showtip:Find("pselect").gameObject;
    local pshenzhi = showtip:Find("pshenzhi").gameObject;
    local pfangzhi = showtip:Find("pfangzhi").gameObject;
    local loseRob=this._bigshow.transform:Find("loserob").gameObject;
	popen:SetActive(false)
	pbet:SetActive(false)
    prob:SetActive(false)
    
    if (this._isdaoban) then 
		loseRob:SetActive(true)
		showtip.gameObject:SetActive(false)
		this._isdaoban=false
    end 
    
	if (this._IsLiuju == 1) then
		liuju:SetActive(true)
		return
	end
	if (this._curState == this._const.YAOLEZI_STATUS_BANKER) then
		prob:SetActive(true)
	elseif(this._curState == this._const.YAOLEZI_STATUS_SHAKE) then
        --pselect:SetActive(true)
    elseif(this._curState == this._const.YAOLEZI_STATUS_SHENZHI) then
        pshenzhi:SetActive(true)
    elseif(this._curState == this._const.YAOLEZI_STATUS_FANGZHI) then
        pfangzhi:SetActive(true)
    elseif (this._curState == this._const.YAOLEZI_STATUS_BET) then
		pbet:SetActive(true)
	elseif (this._curState == this._const.YAOLEZI_STATUS_OPEN) then
		-- this._bigshow.transform.localPosition = Vector3(0,100,0);
		popen:SetActive(true)
	end
end

function this.showAllPlayerPoint()
	-- this.onCloseCard()
	if(this._userBetVec ~= nil) then
    	local len = #this._userBetVec
    	local isshow = false
    	for i=1,len do
    		local data = this._userBetVec[i]
    		--local who = 0
			local name = data.betusers.player_name
			if(name == this.YP.GetPlayerName()) then
				--who = 1
				isshow = true
			end    
    	end
    	if(isshow) then
    		this.ShowBalance(this._userBetVec)
    	end
    	this._userBetVec = nil
    end
end
--[[
    data={
        betusers={player_name=,result_money=,}
    }

    ]]
function this.ShowBalance(data)
	this._haveBalance = false
	this.CloseShowUI()
	this.showUIprefab("balanceInfo")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "balanceInfobar") then
			this.YP.balanceEnter:SetActive(true)
			this.CloseBalanceList();
			this.PrefabBalance(data)
			this.LB:AddClick(this._uiPreant.transform:Find('sharebalance').gameObject, function ()
				if(this._haveBalance) then
					return
				end
				this._haveBalance = true
				local photo = this._uiPreant.transform:Find('sharebalance'):GetComponent('Photo')
				photo:startCut(function ()
					this._haveBalance = false
					photo:SaveCutImg();
					local files = photo:getCutImgPath()
					global.sdk_mgr:share(1,"",files,"摇乐子")
				end)
			end);
		end
	end
end

function this.CloseShowUI()
    if(this._uiPreant~=nil)then 
        local ret,message = pcall(function()
            panelMgr:ClearPrefab(this._uiPreant);
            return true 
        end)       
        this._uiPreant=nil ;
    end 
    this.YP.uibox:SetActive(false);
    this.CloseBalanceList();
    this.YP.balanceEnter:SetActive(false);
end 
function this.CloseBalanceList()
	local len = #this._balanceList;
	for i=1,len do
		local data = this._balanceList[i]
        if(data ~= nil) then
            local ret,message = pcall(function()
                panelMgr:ClearPrefab(data);
                return true 
            end )
		end
	end
	this._balanceList = {}
end

function this.PrefabBalance(list)
    this.YP.balanceList_UIScrollView:ResetPosition()
	local bundle = resMgr:LoadBundle("balance_yaolezi");
    local Prefab = resMgr:LoadBundleAsset(bundle,"balance_yaolezi");
    local WinCoin = 0
    local len = #list
    for i=1,len do
    	local data = list[i]
    	local name = data.betusers.player_name
    	local coin = data.betusers.result_money
    	local go = GameObject.Instantiate(Prefab);
		go.name = "balance_yaolezibar";
		go.transform.parent = this.YP.balanceList.transform;
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3(0,92 - (i - 1) * 78,0);
		resMgr:addAltas(go.transform,"YaoLeZi")
        local cards=go.transform:Find("cards");
        local card_1_sprite=cards:Find("card_1"):GetComponent("UISprite")
        local card_2_sprite=cards:Find("card_2"):GetComponent("UISprite")
        local card_3_sprite=cards:Find("card_3"):GetComponent("UISprite")
        --local special = go.transform:Find('special').gameObject;
        local fangzhi = go.transform:Find("fangzhi").gameObject;
		local village = go.transform:Find('village').gameObject;
		if(i == 1) then
			--special:SetActive(true)
			village:SetActive(true)
			cards.gameObject:SetActive(true);
			if (this._result_cards~=nil)then 
                card_1_sprite.spriteName=this.GetShareSpriteNameByID(this._result_cards.res1)
                card_2_sprite.spriteName=this.GetShareSpriteNameByID(this._result_cards.res2)
                card_3_sprite.spriteName=this.GetShareSpriteNameByID(this._result_cards.res3)
			end 

		else
			--special:SetActive(false)
			village:SetActive(false)
        end
        if this.fangzhi_data then 
            if data.playerid == this.fangzhi_data.playerid then 
                fangzhi:SetActive(true)
            else 
                fangzhi:SetActive(false)
            end 
        end 
        
		local freehome = go.transform:Find('freehome').gameObject;
		freehome:GetComponent('UILabel').text = GameData.GetShortName(name,6,6)
		local bscore = go.transform:Find('bscore').gameObject;
		bscore:GetComponent('UILabel').text = coin
    	if(name == this.YP.GetPlayerName()) then
            WinCoin = coin
            if this._isBanker==false then 
                if coin > 0 then 
                    bscore:GetComponent('UILabel').text ="[FF0000FF]+"..coin
                else 
                    bscore:GetComponent('UILabel').text ="[00FF17FF]"..coin
                end 
            end 
            freehome:GetComponent('UILabel').text ="[FFCA3CFF]".. GameData.GetShortName(name,6,6)
		end
		table.insert(this._balanceList,go)
    end
    if(WinCoin > 0) then --赢
    	this._startScore = 0
		this._maxScore = 0
		this._playScore = 0
		this._startAnima = true
		this._maxScore = WinCoin
		this.getScoreFinal()
		if(this._uiPreant ~= nil) then
			if(WinCoin > 100) then
				this._uiPreant.transform:Find('animscale/big').gameObject:SetActive(true)
				this._uiPreant.transform:Find('animscale/win').gameObject.transform.localPosition = Vector3(68,89,0)
			end
			this._uiPreant.transform:Find('animscale').gameObject:SetActive(true)
			this._uiPreant.transform:Find('animscale/score'):GetComponent('UILabel').text = "00000000"
			soundMgr:PlaySound("win")
		end
	else
		if(this._uiPreant ~= nil) then
			this._uiPreant.transform:Find('loseanima').gameObject:SetActive(true)
			soundMgr:PlaySound("lose")
		end
    end
    local pH = len * 78
	if(pH > 280) then
		this.YP.balanceCollider_UISprite.height = pH
	end
end
function this.getScoreFinal()
	this._finalVec = {}
	local len = string.len(this._maxScore)
	this._scoreLen = len
	for i=1,len do
		local value = string.sub(this._maxScore, -i,len - (i-1))
		table.insert(this._finalVec,value)
	end
end
--centerBG
--按键事件
function this.OnChessClick(go) 
    if (this.fangZhi_Select and this.fangzhi_PosAndCoin
    and go~=this.fangzhi_PosAndCoin.posObj)then
        return
    end
    if (this._curState~=this._const.YAOLEZI_STATUS_BET)then 
        if (this.isfangzhi==false)then 
            return
        end
    end 
    if (this.isnazhi and this.fangzhi_PosAndCoin
    and this.fangzhi_PosAndCoin.posID)then
      local list =this.GetChessIDByPosID(this.fangzhi_PosAndCoin.posID);
      local mainChess=this.GetMainChessByID(list.mainChessID); 
      if (mainChess==go)then 
        return
      end 
      mainChess=this.GetMainChessByID(list.childChessID);
      if (mainChess==go)then 
        return
      end
    end 

    if (this.currentChess~=nil)then 
        this.ClearChessLightByPosID(this.currentChess.pos);
    end   
    for k ,v in pairs(this.allChessList) do
        if v.obj==go then
            local tr=go.transform;
            tr:Find("Light").gameObject:SetActive(true);
           
            local data={
                obj=go,
                id =v.id,
                pos=v.pos
            }           
            this.currentChess=data;
            --table.insert(this.currentChess,data);
            break
        end
    end
end 
function this.OnChildChessClick(go)
    if (this.fangZhi_Select and this.fangzhi_PosAndCoin
    and go~=this.fangzhi_PosAndCoin.posObj)then
        return
    end 
    if (this._curState~=this._const.YAOLEZI_STATUS_BET)then 
        if (this.isfangzhi==false)then 
            return
        end
    end 
    local parent=go.transform.parent.gameObject;
    local childList={}
    for k,v in pairs(this.allChessList)do 
        if (v.obj==parent)then 
            childList=v.child;
            break
        end
    end
    -- if (this.isnazhi and this.fangzhi_PosAndCoin.posID~=-1)then
    if (this.isnazhi and  this.fangzhi_PosAndCoin)then
        local list =this.GetChessIDByPosID(this.fangzhi_PosAndCoin.posID);
        local comList={};
        for k,v in pairs(childList)do 
            if (v.obj==go)then
                comList =this.GetChessIDByPosID(v.pos);
                break
            end 
        end 
        if (list.mainChessID==comList.mainChessID or list.mainChessID==comList.childChessID)then 
            return
        end 
        if (list.childChessID==comList.mainChessID or list.childChessID==comList.childChessID)then 
            return
        end 
    end 

    if (this.currentChess~=nil)then 
        this.ClearChessLightByPosID(this.currentChess.pos);
    end
   
    for k,v in pairs(childList)do
        if (v.obj==go)then           
            go.transform:Find("Light").gameObject:SetActive(true);
            parent.transform:Find("Light").gameObject:SetActive(true);
            local list=this.GetChessIDByPosID(v.pos);
            local mainObj=this.GetMainChessByID(list.childChessID);
            local childObj=this.GetChildChessByID(list.childChessID,list.mainChessID);
            if (mainObj~=nil)then 
                mainObj.transform:Find("Light").gameObject:SetActive(true);
            end 
            if (childObj~=nil)then 
                childObj.transform:Find("Light").gameObject:SetActive(true); 
            end       
            local data ={
                obj=go,
                id=v.id,
                pos=v.pos,
            }
            this.currentChess=data
            --table.insert(this.currentChess,data);  
               
            break
        end            
    end      

end 

--shadeAnima 开盖
function this.OnShade(go,isPress)
    if (this._curState~=this._const.YAOLEZI_STATUS_OPEN)then 
        return
    end 
    local ts=this.YP.shade_gai:GetComponent("TweenScale");
    if (this.shadeClick)then 
        this.shadeClick=false;
        ts.from=Vector3(1.2,1.2,1);
        ts.to=Vector3(1,1,1);
        ts.duration=0.2
        ts:ResetToBeginning();
        ts.enabled=true;
    else
        this.shadeClick=true;
        this.pressPos=Input.mousePosition;
        ts.from=Vector3(1,1,1);
        ts.to=Vector3(1.2,1.2,1);
        ts.duration=0.2
        ts:ResetToBeginning();
        ts.enabled=true;
    end 
end 
--Right
function this.OnNaZhiBet(go)
    if (this.isnazhi==false)then 
        return
    end
    -- if (this.currentChess==nil)then 
    --     local str = "请先选择下注位置"
    --     this.YP.setTip(str)
    --     return
    -- end 
    if (this._curState~=this._const.YAOLEZI_STATUS_BET)then 
        return
    end

    local coin=go.name+0;
    this.allBetCoin=this.allBetCoin+coin;
    -- data={
    --     posID=this.currentChess.pos,
    --     money=coin,
    --     posObj=this.currentChess.obj;
    -- }
    -- table.insert(this.Bet_PosAndCoin,data);
     --额外修改
    local data = {
        posID = nil ,
        money = coin ,
        posObj = nil ,
    }
    if not this.re_bet_list then 
        this.re_bet_list = {}
    end 
    table.insert(this.re_bet_list,data);
    this.YP.sumBetMoney_Label.text=this.allBetCoin; 
end
function this.OnBet(go)
    if (this._curState~=this._const.YAOLEZI_STATUS_BET)then 
        if (this.isfangzhi==false)then
            -- local str = "未到下注时间"
            -- this.YP.setTip(str)
            return
        end 
    end
    if (this.canFangzhi==false and this._isBanker)then 
        return
    end 
    -- if (this.currentChess==nil)then 
    --     local str = "请先选择下注位置"
    --     this.YP.setTip(str)
    --     return
    -- end   
    if (this.isnazhi)then 
        return
    end         
    local coin = 0
	if(go.name == "betfive") then --1
		coin = 1
	elseif(go.name == "betten") then --5
		coin = 5
	elseif(go.name == "bethund") then --10
		coin = 10
	elseif(go.name == "betkilo") then --20
		coin = 20
	elseif(go.name == "bettenshou") then --50
		coin = 50
	elseif(go.name == "betmill") then --100
		coin = 100
    end
    this.allBetCoin=this.allBetCoin+coin;
    local data 
    if not this.re_bet_list then 
        this.re_bet_list = {}
    end 
    local data = {
        posID = nil ,
        money = coin ,
        posObj = nil ,
    }        
    table.insert(this.re_bet_list,data);
    this.YP.sumBetMoney_Label.text=this.allBetCoin;    
end 
function this.OnOkBtn()
    if (this._curState~=this._const.YAOLEZI_STATUS_BET)then 
        if (this.isfangzhi==false)then
            return
        end 
    end 
    --额外修改
    if (this.currentChess==nil)then 
        local str = "未选择要下注的棋子"
        this.YP.setTip(str)
        return
    end 
    if (this.animaCanPlay)then 
        local str = "正在处理上一次下注，请等待"
        this.YP.setTip(str)
        return
    end 
    if (this.re_bet_list==nil)then 
        local str = "没有下注金额"
        this.YP.setTip(str)
        return
    end  
 
    if this.isfangzhi then   
        if not this.fangzhi_PosAndCoin then 
            this.fangzhi_PosAndCoin = {}
        end           
        this.fangzhi_PosAndCoin.posObj = this.currentChess.obj
        this.fangzhi_PosAndCoin.money = this.allBetCoin
        this.fangzhi_PosAndCoin.posID = this.currentChess.pos
        for k,v in pairs (this.re_bet_list)do 
            local data={
                {
                    posID =  this.currentChess.pos,
                    money = v.money ,
                    posObj = this.currentChess.obj,
                }                
            }
            this.AddFangzhiMoney(this.fangzhi_PosAndCoin.posID,nil)
            table.insert(this.BetAnimaList,data);
            this.fangZhi_Select=true; 
        end 

    else   
        for k,v in pairs (this.re_bet_list) do  
            v.posID = this.currentChess.pos 
            v.posObj = this.currentChess.obj
        end     
        this.Bet_PosAndCoin = this.re_bet_list
    end 
    --向服务端发送数据
    local op  -- 1 下注 2 放支 3 拿支
    local bet_list ={}
    local bet_info = {}
    if (this.isfangzhi)then 
        op = 2  
        bet_info = {this.fangzhi_PosAndCoin}
    elseif(this.isnazhi)then 
        op = 3 
        bet_info = this.Bet_PosAndCoin
        --拿支动画
        this.BetAnimaClassify(this.Bet_PosAndCoin);
    else
        op = 1     
        bet_info = this.Bet_PosAndCoin      
        this.BetAnimaClassify(this.Bet_PosAndCoin);
    end 
    for k , v in pairs (bet_info)do 
        local data ={}
        data.pos = v.posID
        data.money = v.money 
        table.insert(bet_list,data) 
    end 
    this.YP.SendBetListToNet(bet_list,op)  

    --清空
    this.allBetCoin=0;
    this.re_bet_list = nil 
    this.YP.sumBetMoney_Label.text=this.allBetCoin;    
    this.Bet_PosAndCoin={};
    if(this.isfangzhi)then 
        this.fangzhi_PosAndCoin.money=0;
    end 
end 

function this.NextClearBet()
    this.allBetCoin=0
    this.YP.sumBetMoney_Label.text=this.allBetCoin
    this.re_bet_list = nil 
    if this.animaCanPlay == false then 
        this.BetAnimaList={}; 
    end    
    if (this._curState==this._const.YAOLEZI_STATUS_BET)then 
        this.isfangzhi=false;
    end 
end 

function this.LoseRobCallBack(data)
    if this._curState == this._const.YAOLEZI_STATUS_FREE then 
        this.YP.flexoBtn_cover:SetActive(true);
    end 
    this.banker_data = nil 
    this._isBanker = false
    this.UpdateBankerInfo(this.banker_data)
end 


function this.SendBetCallBack(op,succeed)
    if succeed then 
        this.is_net_cb = true 
        if op == 1 then --下注回调
        elseif  op == 2 then --放支回调
            this.animaCanPlay=true;
        elseif op == 3 then --拿支回调
        end 
        this.UpdatePlayerMoney()
    else
        this.is_net_cb = false 
        this.NextClearBet()
        this.BetAnimaList = {} 
        this.animaCanPlay = false
        this.re_bet_list = nil 
        this.Bet_PosAndCoin = {}
        this.bet_class={}
        if op == 1 then --下注回调
        elseif  op == 2 then --放支回调
            
        elseif op == 3 then --拿支回调
    
        end 
    end
    
end 

function this.OnClearBtn()
    this.allBetCoin=0;
    this.YP.sumBetMoney_Label.text=this.allBetCoin;
    this.Bet_PosAndCoin={};
    this.re_bet_list = nil 
    if this.fangzhi_PosAndCoin then 
        this.fangzhi_PosAndCoin.money = 0 
    end 
    if (this.currentChess~=nil)then 
        this.ClearChessLightByPosID(this.currentChess.pos);
        this.currentChess=nil;
    end 
    -- if(this.isfangzhi)then 
    --     this.BetAnimaList={};
    --     if not this.fangzhi_PosAndCoin then 
    --         return 
    --     end 
    --     if not this.fangzhi_PosAndCoin.posID then 
    --         return 
    --     end 
    --     local listID=this.GetChessIDByPosID(this.fangzhi_PosAndCoin.posID);
    --     local chess=this.GetMainChessByID(listID.mainChessID);        
    --     local fangzhiSign=chess.transform:Find("signCoin").gameObject;
    --     local money=fangzhiSign.transform:Find("money").gameObject;
    --     local money_label=money:GetComponent("UILabel");
    --     local coin = money_label.text+0
    --     if (coin==0)then
    --         fangzhiSign:SetActive(false); 
    --         -- this.fangzhi_PosAndCoin={posID=-1,money=0,posObj=nil};
    --         this.fangzhi_PosAndCoin = nil 
    --         this.fangZhi_Select=false;
    --     else
    --         this.fangzhi_PosAndCoin.money=0;
    --     end
    --     if (listID.childChessID~=-1)then 
    --         chess=this.GetMainChessByID(listID.childChessID);
    --         if (chess~=nil)then
    --             fangzhiSign=chess.transform:Find("signCoin").gameObject;
    --             money=fangzhiSign.transform:Find("money").gameObject;
    --             money_label=money:GetComponent("UILabel");
    --             if (money_label.text+0==0)then
    --                 fangzhiSign:SetActive(false); 
    --                 this.fangzhi_PosAndCoin=nil;
    --                 this.fangZhi_Select=false;
    --             else
    --                 this.fangzhi_PosAndCoin.money=0;
    --             end
    --         end 
    --     end         
    -- end   
end 
function this.BetAnimaClassify(list)
    for k,v in pairs(list)do 
        if (#this.bet_class<1)then  
            local data={};
            table.insert(data,v);   
            table.insert(this.bet_class,data); 
        else
            local hasfind=false;
            for k1,v1 in pairs(this.bet_class)do 
                local info=v1;
                if info[1].posID ==v.posID then 
                    table.insert(v1,v);
                    hasfind=true;            
                end                         
            end 
            if (hasfind==false)then 
                local data={};
                table.insert(data,v);
                table.insert(this.bet_class,data);
            end           
        end 
    end
    this.coinAnima_max=0;
    for i=1 ,#this.bet_class do 
        if (#this.bet_class[i]>this.coinAnima_max)then 
            this.coinAnima_max=#this.bet_class[i];
        end 
    end    
    for i=1 ,this.coinAnima_max do
        local data={}; 
        for j=1,#this.bet_class do
            local info= this.bet_class[j];
            if (info[i]~=nil)then 
                table.insert(data,info[i]);
            end
        end 
        if (#data>0)then 
            table.insert(this.BetAnimaList,data);
        end 
    end           
    this.animaCanPlay=true;
end 

--UpLeft
function this.OnRob(go)
	if (this._const == nil) then
		return
	end
	if (this._curState ~= this._const.YAOLEZI_STATUS_BANKER) then
		this._robData = nil
		return
	end
	if (this._robData == nil) then
		this.YP.GetRobInfo()
	else
		this.RobCallBack(this._robData)
	end
end

function this.RobCallBack(data)
	if(this._curState == this._const.YAOLEZI_STATUS_BANKER) then --抢庄
		this.showUIprefab("ShierzhiRob")
		if(this._uiPreant ~= nil) then
			if(this._uiPreant.name == "ShierzhiRobbar") then
                this._robData = data

                local minscore = tonumber(data.banker_min_coin)
				local maxscore = tonumber(data.player_max_coin)
				if(data.player_max_coin == "") then
					maxscore = 0
				end
				if(data.banker_min_coin == "") then
					minscore = 0
                end
                local text =  string.format(i18n.TID_BANKER_INFO,minscore,maxscore)
                this._uiPreant.transform:Find('hint'):GetComponent('UILabel').text =text
                local maxInput = this._uiPreant.transform:Find('maxInput').gameObject;
				local maxInput_UIInput = maxInput:GetComponent('UIInput');
                local maxInput_UILabel = maxInput:GetComponent('UILabel');
                local max_score= math.floor(data.player_max_coin*3/4)
				maxInput_UILabel.text =max_score
                maxInput_UIInput.value =max_score
				this._robBet =max_score
				resMgr:InputEventDeleate(maxInput_UIInput,function()
					if(math.floor(maxInput_UIInput.value) > maxscore) then
                        maxInput_UIInput.value = maxscore
					elseif(math.floor(maxInput_UIInput.value) < 1) then
						maxInput_UIInput.value = 1
					end
					maxInput_UILabel.text = maxInput_UIInput.value
					this._robBet = maxInput_UIInput.value
                end)
                

				local robOk = this._uiPreant.transform:Find('robOk').gameObject;
				this.LB:AddClick(robOk, function ()
					if(this._robBet == 0) then
						this.YP.setTip("抢庄金额不能低于1")
						return
                    end
                    this._robBet = maxInput_UIInput.value
					this.YP.robData(this._robBet)
				end);
			end
		end
	end
end

function this.RobBroadcast(data)    
    local list ={
        player_name=this.YP.GetPlayerName(),
        msg="玩家"..data.player_name.."进行抢庄！抢庄积分为："..data.coin,
        from_headid=data.headimgurl,
    }
    if(global._view:getViewBase("Chat")~=nil)then
        global._view:getViewBase("Chat").UpdateMessage(list,0);
    end        
 end

 function this.ShenZhicast(data)    
    local list ={
        player_name=this.YP.GetPlayerName(),
        msg="玩家"..data.player_name.."进行申请放支！申请放支积分为："..data.coin,
        from_headid=data.headimgurl,
    }
    if(global._view:getViewBase("Chat")~=nil)then
        global._view:getViewBase("Chat").UpdateMessage(list,0);
    end        
 end

--bottom

function this.OnFlexoBtn(go)
    if (this._curState==this._const.YAOLEZI_STATUS_FREE)then--下庄
        if(this._isBanker==false)then 
            return
        end
        local str = "确定是否放弃坐庄？"
        local support = global._view:support();
        support.Awake(str,function()
            this.YP.LoseRob(function()
                
                        end)
            end,function()
        end)   
    elseif(this._curState==this._const.YAOLEZI_STATUS_SHAKE)then--摇奖
        if (this.isShake )then 
            return
        end 
        this.YP.Shake_Shade()
    elseif(this._curState==this._const.YAOLEZI_STATUS_SHENZHI)then--申支
        if (this._const == nil) then
            return
        end
        if this.shenzhi_data == nil then 
            this.shenzhi_data = this.YP.GetShenZhiData()
        else 
            this.ShenZhiCallBack(this.shenzhi_data)
        end 
            --申支窗口
    elseif(this._curState==this._const.YAOLEZI_STATUS_BET)then--拿支
        if (this.canNazhi==false)then 
            return
        end 
        if (not this.fangzhi_PosAndCoin)then 
            return
        end 
        --center 中心变色
        local list=this.GetChessIDByPosID(this.fangzhi_PosAndCoin.posID);
        local chess1=this.GetMainChessByID(list.mainChessID);
        local chess1_nazhiLight=chess1.transform:Find("nazhiLight").gameObject;
        local chess2=nil ;
        local chess2_nazhiLight=nil;
        if (list.childChessID~=-1)then
            chess2=this.GetMainChessByID(list.childChessID);        
            chess2_nazhiLight=chess2.transform:Find("nazhiLight").gameObject;
        end
        --拿支窗口
        local tp=this.YP.nazhiBet:GetComponent("TweenPosition");
        if (this.isnazhi)then 
            this.isnazhi=false;
            this.YP.flexoBtn_label.text="申请拿支"            
            tp.from=Vector3(40,74,0);
            tp.to=Vector3(310,74,0);
            chess1_nazhiLight:SetActive(false);
            if(chess2~=nil)then
                chess2_nazhiLight:SetActive(false);
            end 
            this.YP.okBtn_UISprtie.color = Color.gray
            this.YP.clearBtn_UISprite.color = Color.gray
            this.UpdateBankerInfo(this.banker_data)                      
        else 
            this.isnazhi=true;
            this.YP.flexoBtn_label.text="取消拿支"
            tp.from=Vector3(310,74,0);
            tp.to=Vector3(40,74,0);
            chess1_nazhiLight:SetActive(true); 
            if (chess2~=nil)then
                chess2_nazhiLight:SetActive(true);
            end 
            this.YP.okBtn_UISprtie.color = Color.white
            this.YP.clearBtn_UISprite.color = Color.white
            this.UpdateNazhiInfo(this.fangzhi_data)        
        end 
        tp.duration=0.3        
        tp:ResetToBeginning();
        tp.enabled=true;
        this.OnClearBtn();   
    
    end 
end 

function this.ShenZhiCallBack(data)
    if(this._curState == this._const.YAOLEZI_STATUS_SHENZHI) then --申支
        this.showUIprefab("shenzhiPanel")
		if(this._uiPreant ~= nil) then
			if(this._uiPreant.name == "shenzhiPanelbar") then
                this.shenzhi_data = data

                local minscore = tonumber(data.shenzhi_min_coin)
				local maxscore = tonumber(data.shenzhi_max_coin)
				if(data.player_max_coin == "") then
					maxscore = 0
				end
				if(data.banker_min_coin == "") then
					minscore = 0
                end
                local content =this._uiPreant.transform:Find("content");
                local text =string.format(i18n.TID_SHENZHI_INFO,minscore,maxscore) 
                content:Find('LabelBg/Label'):GetComponent('UILabel').text = text
				local maxInput = content.transform:Find('Seting/maxInput').gameObject;
				local maxInput_UIInput = maxInput:GetComponent('UIInput');
                local maxInput_UILabel = maxInput:GetComponent('UILabel');
                local max_score =math.floor(data.shenzhi_max_coin*3/4) 
				maxInput_UILabel.text = max_score
                maxInput_UIInput.value = max_score
				this._shenzhiBet =  max_score
				resMgr:InputEventDeleate(maxInput_UIInput,function()
					if(tonumber(maxInput_UIInput.value) > maxscore*3/4) then
						maxInput_UIInput.value = maxscore*3/4
					elseif(tonumber(maxInput_UIInput.value) < 1) then
						maxInput_UIInput.value = 1
					end
					maxInput_UILabel.text = maxInput_UIInput.value
					this._shenzhiBet = maxInput_UIInput.value
				end)


				local OKBtn = this._uiPreant.transform:Find('OKBtn').gameObject;
				this.LB:AddClick(OKBtn, function ()
					if(this._shenzhiBet == 0) then
						this.YP.setTip("放支的金额不能低于1")
						return
                    end
                    this._shenzhiBet =maxInput_UIInput.value
					this.YP.shenzhiData(this._shenzhiBet)
				end);
				

			end
		end
	end
end 

function this.UpdateBankerInfo(data)
    if data and data.playerid ~=0 then 
        local bstr = "庄家:" .. GameData.GetShortName(data.name,14,14) ..
        "\n单字最高下注:" ..  math.floor(data.max_coin/3)
        this.YP.bankerName_Label.text = bstr
        this.YP.rob:SetActive(false)
		this.YP.robHead:SetActive(true)
        this.YP.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
        this.YP.bankerName_Label.fontSize =25
    else 
        this.YP.bankerName_Label.text = "庄家:无\n单字最高下注:0"
        this.YP.rob:SetActive(true)
        this.YP.robHead:SetActive(false)
    end 
end 

function this.UpdateFangzhiInfo(data)
    if data then 
        local max_coin=data.max_coin*1/4
        local banker_max_coin =this.banker_data.max_coin/3
        if max_coin > banker_max_coin then 
            max_coin = banker_max_coin
        end 
        local bstr = "放支人:" .. GameData.GetShortName(data.name,14,12) ..
        "\n单字最高放支:" ..  math.floor(max_coin)      
        this.YP.bankerName_Label.text = bstr
        this.YP.rob:SetActive(false)
		this.YP.robHead:SetActive(true)
        this.YP.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
    else 
        this.YP.bankerName_Label.text = "放支人:无\n单字最高放支:0"
        this.YP.rob:SetActive(true)
        this.YP.robHead:SetActive(false)
    end 
end 
function this.UpdateNazhiInfo(data)
    if data then 
        local bstr = "放支人:" .. GameData.GetShortName(data.name,14,12) ..
        "\n单字最高可拿支数:" ..  math.floor(data.max_number)
        this.YP.bankerName_Label.text = bstr
        this.YP.rob:SetActive(false)
		this.YP.robHead:SetActive(true)
        this.YP.robHead_AsyncImageDownload:SetAsyncImage(data.headimgurl)
    else 
        this.YP.bankerName_Label.text = "放支人:无\n单字最高可拿支数:0"
        this.YP.rob:SetActive(true)
        this.YP.robHead:SetActive(false)
    end 
end 

function this.UpdateResultBet(data)
    if not data then 
        return 
    end 
    this._userBetVec = {}
    local len = #data
    if len > 0 then 
        local bankerInfo = data[1]
        local vec = {}
		vec.betusers = bankerInfo
        vec.playerId = bankerInfo.playerid
        table.insert(this._userBetVec,vec)
        --不是庄家 并且1人以上
		local self_name = this.YP.GetPlayerName()
		if len > 1 and bankerInfo.player_name ~= self_name then 
			for k,v in pairs(data) do 
				if v.player_name == self_name then 
					self_i = k 
					local vec = {
						betusers = v,
						playerId = v.playerid
					}
					table.insert(this._userBetVec,vec)
				end 
			end 
        end 
    end 
        
    for i = 2 , len  do 
        if i ~= self_i then 
            local bankerInfo = data[i]
            --local name = bankerInfo.player_name
            local vec = {
                betusers = bankerInfo,
                --Isopen = 0,
                playerid = bankerInfo.playerid,
            }
            table.insert(this._userBetVec,vec)
        end 
    end
end 

function this.UpdatePlayerInfo()
    this._playerCoin = this.YP.GetPlayerCoin() + this.YP.GetPlayerRMB()
	this.YP.playerCoin_Label.text = this.YP.GetPlayerRMB()
	this.YP.playerSilver_Label.text = this.YP.GetPlayerCoin()
    this.YP.playerName_Label.text = GameData.GetShortName(this.YP.GetPlayerName(),14,12)
     .. "\nID:" .. this.YP.GetPlayerID()
end 
function this.UpdatePlayerMoney()
    this.YP.playerCoin_Label.text = this.YP.GetPlayerRMB()
    this.YP.playerSilver_Label.text = this.YP.GetPlayerCoin()
    this._playerCoin = this.YP.playerCoin_Label.text + this.YP.playerSilver_Label.text
end 
--跟新模式，局数
function this.UpdateTypeAndBout(data)
    if (this.play_type==1 or this.play_type==11)then
        if data.bout~=nil then 
            this.YP.number_Label.text=data.bout
        end 
		this.YP.type_Label.text="自由模式"		
		this.YP.sumNumber_Label.text="-"
	elseif(this.play_type==2 or this.play_type==12)then 
		this.YP.type_Label.text="抢庄模式"		
		if(data.bout_amount~=nil)then
			this.YP.sumNumber_Label.text=data.bout_amount
		end	
		if (data.bout~=nil)then 
			this.YP.number_Label.text=data.bout
		end 	
	end 
end  
function this.UpdateFlexoBtnType()
    if (this._curState==this._const.YAOLEZI_STATUS_FREE)then
        if(this._isBanker==false)then 
            this.YP.flexoBtn_cover:SetActive(true);
        else
            this.YP.flexoBtn_cover:SetActive(false);
        end 
        this.YP.flexoBtn_label.text="申请下庄";

    elseif(this._curState==this._const.YAOLEZI_STATUS_BANKER)then
        if(this._isBanker==false)then 
            this.YP.flexoBtn_cover:SetActive(true);
        else
            this.YP.flexoBtn_cover:SetActive(true);
        end 
        this.YP.flexoBtn_label.text="申请下庄";

    elseif(this._curState==this._const.YAOLEZI_STATUS_SHAKE)then
        if(this._isBanker==false)then 
            this.YP.flexoBtn_cover:SetActive(true);
        else
            this.YP.flexoBtn_cover:SetActive(false);
        end 
        this.YP.flexoBtn_label.text="摇  奖";
    elseif(this._curState==this._const.YAOLEZI_STATUS_SHENZHI)then
        this.YP.flexoBtn_cover:SetActive(false);
        this.YP.flexoBtn_label.text="申请放支";
    elseif(this._curState==this._const.YAOLEZI_STATUS_FANGZHI)then
        this.YP.flexoBtn_cover:SetActive(true);
    elseif(this._curState==this._const.YAOLEZI_STATUS_BET)then
        if(this.canNazhi==false)then 
            this.YP.flexoBtn_cover:SetActive(true);
        else
            this.YP.flexoBtn_cover:SetActive(false);
        end 
        local str = ""
        if this.canNazhi then 
            str = "申请拿支"
        else 
            str = "摇  奖"
        end 
        this.YP.flexoBtn_label.text=str;
    elseif(this._curState==this._const.YAOLEZI_STATUS_OPEN)then
        this.YP.flexoBtn_cover:SetActive(true);
    end 
end 
--data={res1=,res2=,res3=}
function this.UpdateRecordResult(data)
    this.YP.record_1:SetActive(true);
    this.YP.record_2:SetActive(true);
    this.YP.record_3:SetActive(true);
    local res1=this.GetFontAndColorByID(data.res1);
    this.YP.record_1_label.text=res1.font;
    this.YP.record_1_label.color=res1.color;
    local res2=this.GetFontAndColorByID(data.res2);
    this.YP.record_2_label.text=res2.font;
    this.YP.record_2_label.color=res2.color;
    local res3=this.GetFontAndColorByID(data.res3);
    this.YP.record_3_label.text=res3.font;
    this.YP.record_3_label.color=res3.color;
end 
--data={res1=,res2=,res3=}
function this.UpdateShadeChessResult(data) 
    this.YP.chess_1_sprite.spriteName=this.GetShareSpriteNameByID(data.res1);
    this.YP.chess_2_sprite.spriteName=this.GetShareSpriteNameByID(data.res2);
    this.YP.chess_3_sprite.spriteName=this.GetShareSpriteNameByID(data.res3);
end 
--data={posID=,money=,}
function this.UpdateFangZhiByNet(info)
    if this.YP.GetPlayerID() ~= info.playerid then 
        this.canNazhi = true 
    end
    local data ={}
    data.posID =info.bet_list[1].pos
    data.money =info.bet_list[1].money 
      
    if not this.fangzhi_PosAndCoin  then 
        this.fangzhi_PosAndCoin = {}
    end        
    this.fangzhi_PosAndCoin.posID=data.posID;
    this.fangzhi_PosAndCoin.money=0;
    local list_id = this.GetChessIDByPosID(data.posID)
    local fangzhiSign
    local money
    local label
    if (data.posID<7)then 
        this.fangzhi_PosAndCoin.posObj=this.GetMainChessByID(data.posID);
        fangzhiSign=this.fangzhi_PosAndCoin.posObj.transform:Find("signCoin").gameObject;
        money=fangzhiSign.transform:Find("betmoney/money").gameObject;
        label=money:GetComponent("UILabel");
        fangzhiSign:SetActive(true);
        label.text=data.money+label.text;  
    else
        data.money = data.money/2
        this.fangzhi_PosAndCoin.posObj=this.GetChildChessByID(list_id.mainChessID,list_id.childChessID);
        local obj_1 = this.GetMainChessByID(list_id.mainChessID)
        fangzhiSign = obj_1.transform:Find("signCoin").gameObject;
        money=fangzhiSign.transform:Find("betmoney/money").gameObject;
        label=money:GetComponent("UILabel");
        fangzhiSign:SetActive(true);
        label.text=data.money+label.text; 

        local obj_2 = this.GetMainChessByID(list_id.childChessID)
        fangzhiSign = obj_2.transform:Find("signCoin").gameObject;
        money=fangzhiSign.transform:Find("betmoney/money").gameObject;
        label=money:GetComponent("UILabel");
        fangzhiSign:SetActive(true);
        label.text=data.money+label.text;
    end     
end 
function this.UpdateBalanceScore()
	if(this._startAnima == false) then
		return
	end
	if(this._playScore < 0.45) then--延迟
		this._playScore = this._playScore + Time.deltaTime
	else
		if(this.Speed <= 0.03) then--延迟
	        this.Speed = this.Speed + Time.deltaTime
	    else
	    	this.Speed = 0
	    	if(this._startScore < this._maxScore) then
	    		if(this._uiPreant ~= nil) then
	    			if(this._uiPreant.name == "balanceInfobar") then
	    				this._startScore = this._startScore + this.getScoreValue()
						local len = string.len(this._startScore)
						local str = ""
						for i=1,8 - len do
							str = str .. "0"
						end
						this._uiPreant.transform:Find('animscale/score'):GetComponent('UILabel').text = str .. this._startScore
	    			end
	    		end
			else
				this._startAnima = false
				local max = string.len(this._maxScore)
				local str = ""
					for i=1,8 - max do
						str = str .. "0"
					end
				if(this._uiPreant ~= nil) then
					this._uiPreant.transform:Find('animscale/score'):GetComponent('UILabel').text = str .. this._maxScore
				end
			end
	    end
	end
end
function this.getScoreValue()
	local max = this._startScore
	local flen = #this._finalVec
	local m = 1
	for i=1,flen do
		if(i > 1) then
			m = m * 10
		end
		if(this._scoreLen == i) then
			local comprare = this._finalVec[i]
			for j=flen,this._scoreLen + 1,-1 do
				max = max - this._finalVec[j] * this.getZeroNum(j)
			end
			if(max < tonumber(this._finalVec[i])*m) then
				return m
			else
				this._scoreLen = this._scoreLen - 1
				return this.getZeroNum(this._scoreLen)
			end
		end
	end
	return 1
end
function this.getZeroNum(len)
	local num = 1
	for i=1,len - 1 do
		num = num * 10
	end
	return num
end
  --玩家列表
function this.OnPlayerList()
    if(this._curState ~= this._const.YAOLEZI_STATUS_OPEN) then
		this.YP.GetPlayerList()
    else
        local str = i18n.TID_COMMON_STATISTC_DATA
		this.YP.setTip(str)
	end
	-- this.YP.GetPlayerList()
end
--分享
function this.OnShare()
	this.showUIprefab("shareUI")
	if(this._uiPreant ~= nil) then
		if(this._uiPreant.name == "shareUIbar") then
			local sharefriend = this._uiPreant.transform:Find('sharefriend').gameObject;
			this.LB:AddClick(sharefriend, function ()
				local desc = "同时200人在线摇乐子,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
				local title = "摇乐子[房号:" .. this.RoomId .. "]"
                if this.IsGameRoom then 
					desc = "同时200人在线摇乐子,您的好友邀请您进入游戏"
					title = "摇乐子[大厅:" .. this.RoomTitle .. "]"
				end 
				global.sdk_mgr:share(1,desc,"",title) 

			end);
			local shareall = this._uiPreant.transform:Find('shareall').gameObject;
			this.LB:AddClick(shareall, function ()
				local desc = "同时200人在线摇乐子,房主" .. this._RoomCreate .. ",您的好友邀请您进入游戏"
                local title = "摇乐子[房号:" .. this.RoomId .. "]"
                if this.IsGameRoom then 
					desc = "同时200人在线摇乐子,您的好友邀请您进入游戏"
					title = "摇乐子[大厅:" .. this.RoomTitle .. "]"
				end 
				global.sdk_mgr:share(0,desc,"",title)
			end);
		end
	end
end
function this.OnRule(go)
    global._view:rule().Awake(global.const.GAME_ID_YAOLEZI);
end 
function this.OnBank(go)
    global._view:bank().Awake();
end
function this.OnInvite(go)
	if(this.IsGameRoom) then
		return
	end
	global.player:get_mgr("room"):req_invite_join_room(
        this._const.GAME_ID_YAOLEZI,this.RoomId)
end
  --返回
function this.OnBack(go)	
    local str =i18n.TID_COMMON_BACK_GAME
	global._view:support().Awake(str,function ()
        soundMgr:PlaySound("go")
        this.YP.OnBackClick(this.IsGameRoom)
	   end,function ()
   	end);
    
end
function this.Close()
    this.ClearShowMoney()

    this.allBetCoin=0;
    this.Bet_PosAndCoin={};

    this.allChessList={};    
    this.currentChess=nil;
    this.canNazhi = false;
    this.BetAnimaList={};
    this.ClearCoinPrefab();
    this.coin_finish=true; 
    this.coin_number=0; 
    this.bet_class={};
    this.animaCanPlay=false;

    --shade 动画
    this.isShake=false;--是否摇过奖
    this.shadeAmina_1=false;
    this.shadeTime_1=0.5;
    this.shadeAnima_2=false;
    this.shadeTime_2=1.5;
    this.is_net_cb = false 

    this._result_cards = nil
    this._shenzhiBet=nil 
    this.fangzhi_data = nil
    this.shenzhi_data = nil 
    this.canFangzhi = false

    this.banker_data = nil
    this._isBanker = false
    this.nazhi_id_obj={}
    this.fangzhi_PosAndCoin = nil 

    this._isdaoban = nil 

    this.re_bet_list = nil 

    this.nazhi_list =nil

    this.ClearBigShow()
    
    UpdateBeat:Remove(this.TimeEvent, this)
    panelMgr:ClosePanel(CtrlNames.YaoLeZi);
end 

return this