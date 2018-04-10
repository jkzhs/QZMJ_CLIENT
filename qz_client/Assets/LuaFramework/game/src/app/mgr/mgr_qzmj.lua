--
-- Author: JK
-- Date: 2017-12-28 10:08:56

--[[
    message _play_user {
		optional string player_name     =1;
		optional int32 playerid         =2;
		optional string param1          =3;     //玩家头像
		optional int32 player_money     =4;     //玩家金钱
		optional int32 seatid           =5;     //玩家座位号

		repeated _card_list hand_list   =6;
		repeated _card_list out_list    =7;
		repeated _cphg_list cphg_list   =8;
		
		optional int32 param2           =9;     //--free/end 准备状态(is_prepare)
    }
    message _card_list{
        optional int32 posid               =1;
        optional int32 cardid              =2;
        optional int32 param1              =3;
    }
    message _cphg_list {
        repeated _id angang_list                 =1; //暗杠信息 
        repeated _id minggang_list               =2; //明杠信息 
        repeated _id pengchi_list                =3; //碰吃信息 
        repeated _id ting_list                   =4; //听牌信息
    }
    message _id {
        optional int32 id                  =1;
        optional int32 param1              =2;
    }
    message _flower_list{
        optional int32 seatid              =1;     //add_flower_data 时 seatid 为 flower_cardid
        optional int32 posid               =2;
        optional int32 cardid              =3;
    }
    message _result_list{
        repeated _play_user play_users           =1; //玩家信息
        optional int32 hu_cardid                 =2; //胡牌ID
        optional int32 hu_type                   =3; //胡牌模式 0无、1平胡、2自摸、3油金
        optional int32 param1                    =4; // 共几水
        optional float param2                    =5; //结果金币//--free/end is_prepare
    }
]]

local global = require("global")
local player = global.player
local const = global.const
local table_insert = table.insert
local mt=class("mgr_mj")

local gameid = const.GAME_ID_MJ
local errcode_util = global.errcode_util

local GEN_TYPE_CHI    = 1 --更新吃
local GEN_TYPE_GANG   = 2 --更新杠
local GEN_TYPE_PENG   = 3 --更新碰
local GEN_TYPE_ANGANG = 4 --更新暗杠
--==================执行吃碰胡杠类型==============
local DO_CPHG_TYPE_ANGANG  = 1   --执行暗杠
local DO_CPHG_TYPE_GANG    = 2   --执行杠
local DO_CPHG_TYPE_PENG    = 3   --执行碰
local DO_CPHG_TYPE_CHI     = 4   --执行吃
local DO_CPHG_TYPE_HU      = 5   --执行胡
local DO_CPHG_TYPE_PASS    = 6   --执行pass
local DO_CPHG_TYPE_BUGANG  = 7   --执行补杠
--===================广播类型=======================
local BROADCAST_TYPE_FORCEEXIT           = 1  --强制退出房间
local BROADCAST_TYPE_EXIT                = 2  --退出房间
local BROADCAST_TYPE_CANCEL_PREPARE      = 3  --取消准备
local BROADCAST_TYPE_PREPARE             = 4  --准备
local BROADCAST_TYPE_SUREEXIT            = 5  --确定状态离开房间

local UPDATE_BET_DATA = nil 
local PLAY_OUT_DATA = nil 
--获取长度
local function get_len(list)
    local len = 0 
    for k,v in pairs(list)do 
        len = len + 1 
    end 
    return len 
end 
local function gen_base_data(info)
    local data = {}
    if info.game_status and info.game_status~=0 then 
        data.game_status = info.game_status
    end 
    if info.over_time and info.over_time~=0 then 
        data.over_time = info.over_time
    end 
    if info.play_type and info.play_type~=0 then 
        data.play_type = info.play_type
    end 
    if info.bet_coin and info.bet_coin~=0 then 
        data.bet_coin = info.bet_coin
    end 
    if info.play_seatid and info.play_seatid~=0 then 
        data.play_seatid = info.play_seatid 
    end 
    if info.cards_amount  then 
        data.cards_amount = info.cards_amount
    end 
    return data 
end 
local function gen_play_users(info,is_req_data,game_status)
    local data = {}
    for k,v in pairs(info)do 
        local d = {}
        if v.player_name then 
            d.player_name = v.player_name
        end 
        if v.playerid then 
            d.playerid = v.playerid 
        end 
        if v.param1 then 
            d.head_imgurl = v.param1
        end 
        if v.seatid then 
            d.seatid = v.seatid
        end 
        if v.player_money then 
            d.player_money = v.player_money
        end 
        if is_req_data then 
            if game_status >= const.MJ_STATUS_PLAY and game_status <= const.MJ_STATUS_END then 
                if v.hand_list then 
                    d.hand_list = v.hand_list
                end 
                if v.cphg_list then 
                    for k1,v1 in pairs( v.cphg_list)do 
                        local cphg_list = v1
                        if cphg_list.angang_list then 
                            if cphg_list.angang_list[1] and cphg_list.angang_list[1].param1 then 
                                d.angang_len = cphg_list.angang_list[1].param1
                            end 
                        end 
                        if cphg_list.minggang_list then 
                            d.minggang_list = cphg_list.minggang_list
                        end 
                        if cphg_list.pengchi_list then 
                            d.pengchi_list = cphg_list.pengchi_list
                        end 
                        if cphg_list.ting_list then 
                            d.ting_list = cphg_list.ting_list
                        end 
                    end 
                end 
                if v.out_list then 
                    d.out_list = v.out_list 
                end  
                if game_status == const.MJ_STATUS_END then 
                    if v.param2 then 
                        if v.param2 == 1 then 
                            d.is_prepare = true 
                        else 
                            d.is_prepare = false
                        end 
                    end
                end 
            elseif game_status == const.MJ_STATUS_FREE then 
                if v.param2 then 
                    if v.param2 == 1 then 
                        d.is_prepare = true 
                    else 
                        d.is_prepare = false
                    end 
                end
            end 
        end
        table.insert(data,d)        
    end 
    return data
end 
-- return {[posid]=cardid}
local function gen_card_list(list)
    if not list then 
        print("MJMGR:gen_card_list:error not list!!!")
    end 
    local new_list = {}
    for k,v in pairs(list)do 
        new_list[v.posid]=v.cardid
    end 
    if get_len(new_list)>0 then 
        return new_list
    else 
        return nil 
    end 
end 

-- return list = {{[posid]=cardid,},}
--or list = {{posid,}}
-- v.posid = 0  为 out_card
local function gen_CPHG(list,type,is_update)
    if not list then 
        print("MJMGR:gen_CPHG:error not list!!!")
    end 
    local step = nil 
    if type == GEN_TYPE_CHI or type == GEN_TYPE_PENG  then 
        step = 3 
        if is_update then 
            step = 2
        end 
    end 
    if type == GEN_TYPE_GANG then 
        step = 4
        if is_update then 
            step = 3
        end 
    end 
    if type == GEN_TYPE_ANGANG then 
        step = 4
    end
    local new_list = {}
    local data = {}
    local count = 1 
    for k,v in pairs(list)do 
        if v.cardid then 
            data[v.posid]=v.cardid
        else 
            data[v.posid] = 0
        end 
        count = count + 1 
        if count > step then 
            table.insert(new_list,data)
            data = {}
            count = 1
        end 
    end 
    if get_len(new_list)>0 then 
        return new_list
    else 
        return nil 
    end 
end 
-- list ={{seatid,posid,cardid}}
--return {[posid]={{poscard_id,addcard_id},}
local function gen_add_flower(list)
    if list then 
        local info = {}
        for k,v in pairs(list)do 
            
            if not info[v.posid]then 
                info[v.posid]= {}
            end 
            local data = {}
            data.poscard_id = v.seatid 
            data.addcard_id = v.cardid 
            table.insert(info[v.posid],data)
        end 
        if get_len(info)>0 then 
            return info 
        else
            return nil 
        end 
    end 
    
end 
--return true or false
local function gen_hu(value)
    if type(value) ~= "number" then 
        return false
    end 
    if value == 1 then
        return true 
    else 
        return false
    end 
end 

function mt:nw_reg()
    global.network:nw_register("SC_QZMJ_GETDATA",handler(self,self.on_net_update_data))
    global.network:nw_register("SC_QZMJ_ENTER",handler(self,self.on_new_player_enter))
    global.network:nw_register("SC_QZMJ_OUT_CARD", handler(self,self.on_net_out_card))
    global.network:nw_register("SC_QZMJ_CPHG",handler(self,self.on_net_CPHG))
    global.network:nw_register("SC_QZMJ_ENTRUST",handler(self,self.on_net_entrust))
    global.network:nw_register("SC_QZMJ_BROADCAST",handler(self,self.on_net_broadcast))

end

function mt:nw_unreg()
	global.network:nw_unregister("SC_QZMJ_GETDATA")
	global.network:nw_unregister("SC_QZMJ_ENTER")
	global.network:nw_unregister("SC_QZMJ_OUT_CARD")
    global.network:nw_unregister("SC_QZMJ_CPHG")
    global.network:nw_unregister("SC_QZMJ_ENTRUST")
    global.network:nw_unregister("SC_QZMJ_BROADCAST")
end

--[[
    =============================================================================================================
    ==============================================请求数据=======================================================
    =============================================================================================================
]]
--获取信息
--[[ 
     resp =
    ------正常房间玩家   
    optional int32 game_status
    optional int32 over_time 
    optional int32 play_type 
    optional int32 cards_amount
    optional int32 bet_coin
    repeated _play_user play_users           [1]庄家 （如果有）

        play_users ={
            player_name
            playerid
            param1                           头像
            player_money
            seatid
            if game_status == STATUS_FREE or STATUS_END then 
                param2                       1、准备状态 
            end 
            if game_status >= STATUS_PLAY and <= STATUS_END then 
               _card_list hand_list 
               _card_list out_list
               _cphg_list cphg_list
                    cphg_list = {
                        repeated _id angang_list                 =1; //暗杠信息 
                        repeated _id minggang_list               =2; //明杠信息 
                        repeated _id pengchi_list                =3; //碰吃信息 
                        repeated _id ting_list                   =4; //听牌信息
                    }
               
            end 

        }
    if self.game_status >= status_play and <= status_buy then 
        param2                        出牌人的座位id
    end 
    if game_status == STATUS_WAIT then 
        repeated _id dices                   摇骰子结果
    elseif game_status == STATUS_PREPARE then 
        repeated _card_list deal_list        发牌信息
        repeated _card_list hand_list        手牌信息
    elseif game_status == STATUS_PLAY then 	
        optional int32 param1                1、吃碰状态
        optional int32 draw_cardid           抽牌ID
        optional int32 can_hu                能不能胡 1 可以 0 不可以
    elseif game_status == STATUS_CPHG then 
        optional int32 play_seatid           出牌人座位ID
        repeated _card_list deal_list        杠牌的信息 
        repeated _card_list param1_list      碰牌信息
        repeated _card_list param2_list      吃牌信息
    end 
]]

function mt:req_data(cb)
    global.player:call("CS_OP_ROOM",{gameid=gameid,op=1},function(resp)
        -- dump(resp)
        local ec = resp.errcode
        if ec == 0 then 
            local data = gen_base_data(resp)       
            data.play_users = gen_play_users(resp.play_users,true,data.game_status)
            if data.game_status then 
                if data.game_status >= const.MJ_STATUS_PREPARE then 
                    if data.play_users then                     
                        data.banker = resp.play_users[1]
                    end 
                end 
                if data.game_status >= const.MJ_STATUS_PLAY and 
                data.game_status <  const.MJ_STATUS_BUY then 
                    data.cur_out_seatid = resp.param2 
                end 
            end 
            if data.game_status == const.MJ_STATUS_FREE then 
            elseif data.game_status == const.MJ_STATUS_WAIT then 
                if resp.dices then 
                    if resp.dices[1] then 
                        data.dices = resp.dices
                    end 
                end 
            elseif data.game_status == const.MJ_STATUS_PREPARE then
                data.hand_list = gen_card_list(resp.hand_list)--{[posid]=cardid}
                data.deal_list = gen_card_list(resp.deal_list)--{[posid]=cardid}
            elseif data.game_status == const.MJ_STATUS_PLAY then                
                data.drawCard_id = resp.draw_cardid
                data.can_hu = gen_hu(resp.can_hu)
                if resp.param1  then --吃 碰状态
                    data.play_status = resp.param1
                end 
                if resp.deal_list then 
                    data.angang_list = gen_CPHG(resp.deal_list,GEN_TYPE_ANGANG,true)--{{[posid]=cardid,},}
                end 
                if resp.param1_list then 
                    data.gang_list = gen_CPHG(resp.param1_list,GEN_TYPE_GANG,false)--{{[posid]=cardid,},}-- 补杠
                end  
                if resp.dices then 
                    data.ting_list = resp.dices  -- 听牌信息
                end 

            elseif data.game_status == const.MJ_STATUS_CPHG then
                data.can_hu = gen_hu(resp.can_hu)
                if resp.deal_list then 
                    data.gang_list = gen_CPHG(resp.deal_list,GEN_TYPE_GANG,true)--{{[posid]=cardid,},}
                end 
                if resp.param1_list and #resp.param1_list > 0 then 
                    data.pen_list = gen_CPHG(resp.param1_list,GEN_TYPE_PENG,true)
                end
                if resp.dices then 
                    data.ting_list = resp.dices  -- 听牌信息
                end 
            elseif data.game_status == const.MJ_STATUS_BUY then 
                -- todo 
            end 
            if cb then 
                cb(data)
            end 
        else
            global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
            global._view:hideLoading()
        end 
    end)
end 
--结束状态
function mt:req_end_status(status_id,playerid,cb)
    global.player:call("CS_OP_ROOM",{gameid=gameid,op=2,param1=status_id,param2=playerid},function(resp)
        local ec = resp.errcode
        if ec == 0 then 
            if cb then 
                cb()
            end 
        else
            global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))             
        end 
        global._view:hideLoading()
    end)
end 
--取消准备
function mt:req_cancel_prepare(playerid,cb)
    global.player:call("CS_OP_ROOM",{gameid=gameid,op=14,param1=playerid},function(resp)
        local ec = resp.errcode
        if ec == 0 then 
            if cb then 
                cb()
            end 
        else
            global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))             
        end 
        global._view:hideLoading()
    end)
end 
--出牌
function mt:req_play_out_card(posid,cardid,playerid,cb)
    global.player:call("CS_OP_ROOM",{gameid = gameid,op =11,param1=posid,param2=playerid,param3 = cardid},function(resp)
        local ec = resp.errcode
        if ec == 0 then 
           
        else
            global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
        end 
        if cb then 
            cb(ec)
        end 
        global._view:hideLoading()
    end)
end
--CPHG
-- id 选择的ID 
function mt:req_CPHG(playerid,type,id,cb)
    global.player:call("CS_OP_ROOM",{gameid = gameid,op = 12,param1=type,param2=playerid,param3=id},function(resp)
        local ec = resp.errcode
        if ec == 0 then 
           
        else
            global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
        end 
        if cb then 
            cb(resp)
        end 
        global._view:hideLoading()
    end)
end 
--委托 // type 1 委托，0 取消委托
function mt:req_entrust(type,playerid)
    global.player:call("CS_OP_ROOM",{gameid = gameid,op = 13,param1 = playerid, param2 = type },function(resp)
        local ec = resp.errcode 
        if ec == 0 then 
        else 
            global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
        end 
        if cb then 
            cb(resp)
        end 
        global._view:hideLoading()
    end)
end 
--[[
    =============================================================================================================
    ==============================================广播数据=======================================================
    =============================================================================================================
]]
--[[
    message SC_QZMJ_ENTRUST{
	optional int32 errcode                =1;
	optional int32 seatid                 =2;
	optional int32 entrust                =3; // 0 取消托 1进行委托
	optional int32 param1                 =4; // 拓展
}
]]
function mt:on_net_entrust(resp)
    local ec = resp.errcode
    if ec == 0 then 
        local data = {}
        if resp.entrust == 0 then 
            data.entrust = false 
        elseif resp.entrust == 1 then 
            data.entrust = true 
        end 
        data.seatid = resp.seatid 

        local view = global._view:getViewBase("MaJiang")
        if view then 
            view.Entrust_CallBack(data)
        end 

    else 
        global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
    end 
    global._view:hideLoading()
end 
--[[
    message SC_QZMJ_CPHG{
	//=======公开数据=========
	optional int32 errcode                =1;  //
	optional int32 play_seatid            =2;  //出牌人座位ID
	optional int32 type                   =3;  //CPHG_type: 1 angang 2 gang 3 pen 4 chi 5 hu
	repeated _card_list param1_list       =4;  //消除牌的列表 chi/pen/gang:posid = 0 为out_cardid 
	optional int32 posid                  =5;  //理牌位置 有17号位置的牌（暗杠）才有
	optional int32 param1                 =6;  //拓展  chi/pen/gang:seat_id 被CPHG人的座位ID
}
]]
function mt:on_net_CPHG(resp)
    local ec = resp.errcode
    if ec == 0 then        
        local data = {}
        data.play_seatid = resp.play_seatid
        local gen_type = nil 
        local do_type = nil 
        if resp.type == DO_CPHG_TYPE_ANGANG then
            data.posid = resp.posid
            gen_type = GEN_TYPE_ANGANG             
            do_type = DO_CPHG_TYPE_ANGANG
        elseif resp.type == DO_CPHG_TYPE_GANG then
            data.by_seatid = resp.param1
            gen_type = GEN_TYPE_GANG             
            do_type = DO_CPHG_TYPE_GANG
        elseif resp.type == DO_CPHG_TYPE_PENG then
            data.by_seatid = resp.param1
            gen_type = GEN_TYPE_PENG             
            do_type = DO_CPHG_TYPE_PENG
        elseif resp.type == DO_CPHG_TYPE_CHI then
            data.by_seatid = resp.param1
            gen_type = GEN_TYPE_CHI             
            do_type = DO_CPHG_TYPE_CHI
        elseif resp.type == DO_CPHG_TYPE_HU then
            data.by_seatid = resp.param1
            data.hu_cardid = resp.param1_list.cardid 
            data.hu_type = resp.posid -- 1 平胡	2自摸  3油金 
            do_type = DO_CPHG_TYPE_HU
        elseif resp.type == DO_CPHG_TYPE_PASS then
        elseif resp.type == DO_CPHG_TYPE_BUGANG then
            data.by_seatid = resp.param1
            local delete_list = {}
            for k,v in pairs(resp.param1_list)do 
                local info = {}
                if v.cardid then 
                    info[v.posid] = v.cardid 
                else 
                    info[v.posid] = 0
                end 
                table.insert(delete_list,info)
            end 
            data.delete_list = delete_list[1]--{[posid]=cardid,}
            gen_type = nil              
            do_type = DO_CPHG_TYPE_BUGANG
        end 
        if gen_type then 
            
            data.delete_list = gen_CPHG(resp.param1_list,gen_type,false)[1]--{[posid]=0,} or {[posid]=cardid,}
        end 
        local view = global._view:getViewBase("MaJiang")
        if view then 
            if do_type then 
                view.DO_CPHG(data,do_type)
            end 
        end 
    else 
        global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
    end 
    global._view:hideLoading()

end 
--出牌广播
--[[
    message SC_QZMJ_OUT_CARD{
	optional int32 errcode                =1;
	optional int32 seatid                 =2;
	optional int32 posid                  =3;
	optional int32 cardid                 =4;
    optional int32 param1                 =5; //抽取的牌要插入的位置 or nil
    optional int32 param2                 =6; //游金座位id
}
}
]]
function mt:on_net_out_card(resp)
    local ec = resp.errcode
    if ec == 0 then 
        -- dump(resp)
        local to_posid = nil 
        if resp.param1 then 
            to_posid =resp.param1
        end 
       
        local data = {
            seatid = resp.seatid,
            posid = resp.posid,
            cardid = resp.cardid,
            to_posid = to_posid
        }
        if resp.param2 and resp.param2 ~=0 then 
            data.youjing_seatid = resp.param2 or nil 
        end 
        local view = global._view:getViewBase("MaJiang")
        if view then 
            PLAY_OUT_DATA = data
            view.Play_Out_Card(data)
        end
    else 
        global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
    end 
    global._view:hideLoading()
end 
function mt:get_play_out_data()
    return PLAY_OUT_DATA 
end 
--玩家进入房间广播
--[[
     resp = {
        optional int32 errcode                =1;
        repeated _play_user play_users        =2; 进入玩家的信息
            play_users = {
                player_name 
                playerid 
                param1                        头像URL地址
                player_money 
                seatid 
                if game_status == STATUS_FREE or STATUS_END then 
                    param2                    准备状态 1准备                    
                }    
        repeated int32 param1                 =4; //拓展
    }   
]]
function mt:on_new_player_enter(resp)
    local ec = resp.errcode 
    if ec == 0 then 
        local data = {}
        data.play_users = gen_play_users(resp.play_users)
        local view = global._view:getViewBase("QZMaJiang")
        if view~=nil then 
            -- view.UpdatePlayerEnter(data)
            --调用函数
        else
            print("MGR_MJ:on_new_player_enter:not view!!!")
        end
    else
        global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
        global._view:hideLoading()
    end       
end 
--流程更新广播
--[[
    optional int32 errcode                =1;
	optional int32 game_status            =2;  
    optional int32 over_time 			  =3;
    optional int32 cards_amount           =5; //牌组数量
    if game_status == STATUS_FREE then 
        --公开数据
        --私人数据
    elseif game_status == STATUS_WAIT then 	
        --公开数据
        repeated _id dices                 =7;  //摇骰子结果
         --私人数据
    elseif game_status == STATUS_PREPARE then 
        --公开数据
        repeated _play_user play_users           =6;  //只有庄家信息[1]
     -------optional int32 goldid                    =8;  //金牌ID------
        repeated _flower_list flower_list        =9;  //花区信息 （其他人播放补花动画用）
        --私人数据
        repeated _card_list deal_list            =10; //发牌信息
        repeated _card_list hand_list            =11; //手牌信息 
        repeated _flower_list add_flower         =12; //补花信息
    elseif game_status == STATUS_PLAY then 
        --公开数据
        optional int32 play_seatid               =13; //出牌人座位ID
        repeated _flower_list flower_list        =9;  //花区信息（其他人播放补花动画用）
        optional int32 param1                    =20; //1、吃碰状态标记
        --私人数据
        repeated _flower_list add_flower         =12; //补花信息
        optional int32 draw_cardid               =14; //抽牌ID	
        repeated _card_list deal_list            =10; //暗杆牌的信息
        repeated _card_list param1_list          =16; //补杠信息
        repeated _card_list param2_list          =17; //游金信息
        optional int32 can_hu                    =15; //能不能胡 1 可以 0 不可以
    elseif game_status == STATUS_CPHG then 
        --公开数据
        --私人数据
        optional int32 play_seatid               =13; // 出牌人座位ID（不公开，不让其他人知道谁可以CPHG）
        optional int32 can_hu                    =15; // 胡牌cardid nil 不能胡
        repeated _card_list deal_list            =10; // 杠牌的信息
        repeated _card_list param1_list          =16; // 碰牌信息
        repeated _card_list param2_list          =17; // 吃牌信息
    elseif game_status == STATUS_YOUJING then 
        --公开数据
        optional int32 play_seatid               =13; //游金人座位ID
        repeated _flower_list flower_list        =9;  //花区信息（其他人播放补花动画用）
        optional int32 param1                    =20; //1、吃碰状态标记
        --私人数据
        repeated _flower_list add_flower         =12; //补花信息
        optional int32 draw_cardid               =14; //抽牌ID
        optional int32 can_hu                    =15; //能不能胡 1 可以 0 不可以
    elseif game_status == STATUS_END then 
        --公开数据
        repeated _result_list result_list           =18; //结果列表
        optional int32 bet_coin                     =22; //每一水的金额
        optional int32 play_type                    =4;	 //几人局
        repeated _play_user play_users              =6;  //玩家信息[1]庄家（用于大厅更行界面信息）
        --私人数据
        optional int32 result                       =19; // 结果 1、获胜 2、失败 3、流局
    end 
]]

function mt:on_net_update_data(resp)
    local data = {}
    local ec = resp.errcode
    if ec == 0 then 
        data = gen_base_data(resp)
        if data.game_status == const.MJ_STATUS_FREE then --空闲

        elseif data.game_status == const.MJ_STATUS_WAIT then--等待
            if resp.dices then 
                if resp.dices[1] then 
                    data.dices = resp.dices
                end 
            end 
        elseif data.game_status == const.MJ_STATUS_PREPARE then--准备
            data.banker = resp.play_users[1]
            data.hand_list = gen_card_list(resp.hand_list)--{[posid]=cardid}--手牌
            data.deal_list = gen_card_list(resp.deal_list)--{[posid]=cardid}--发牌
        elseif data.game_status == const.MJ_STATUS_PLAY then--出牌
            if resp.param1  then --吃 碰状态
                data.play_status = resp.param1
            end 
            if resp.deal_list then 
                data.angang_list = gen_CPHG(resp.deal_list,GEN_TYPE_ANGANG,true)--{{[posid]=cardid,},}
            end 
            if resp.param1_list then 
                data.gang_list = gen_CPHG(resp.param1_list,GEN_TYPE_GANG,false)--{{[posid]=cardid,},}-- 补杠
            end  
            if resp.dices then 
                data.ting_list = resp.dices  -- 听牌信息
            end 
            data.drawCard_id = resp.draw_cardid
            data.can_hu = gen_hu(resp.can_hu)

           
        elseif data.game_status == const.MJ_STATUS_CPHG then--吃碰胡杠
            -- data.play_seatid = resp.play_seatid
            data.can_hu = gen_hu(resp.can_hu)
            -- print("MJMGR:CAN_HU:",data.can_hu)
            if resp.deal_list then 
                data.gang_list = gen_CPHG(resp.deal_list,GEN_TYPE_GANG,true)--{{[posid]=cardid,},}
            end 
            if resp.param1_list and #resp.param1_list > 0 then 
                data.pen_list = gen_CPHG(resp.param1_list,GEN_TYPE_PENG,true)
            end
            if resp.dices then 
                data.ting_list = resp.dices  -- 听牌信息
            end 
        elseif data.game_status == const.MJ_STATUS_END then
            if resp.result_list then 
                data.result_list = resp.result_list
            end 
            if resp.result then 
                data.result = resp.result
            end 
            if resp.play_users then 
                data.play_users = gen_play_users(resp.play_users,true,data.game_status)
            end
        end   
        
        local view = global._view:getViewBase("ZQMaJiang")
        if view ~= nil then 
            UPDATE_BET_DATA = data
            view.SetBetState(data)
        end 
    else 
        global._view:hideLoading()
        global._view:getViewBase("Tip").setTip(errcode_util:get_errcode_CN(ec))
    end 
end 

function mt:get_update_data()
    return UPDATE_BET_DATA
end 

--[[
    message SC_QZMJ_BROADCAST{
	optional int32 errcode                =1;
	optional int32 type                   =2; // 1 强制退出房间 2 退出房间 3 取消准备 4 准备
	optional int32 param1                 =3; // 拓展 
	optional int32 param2                 =4; // 拓展 
	optional int32 param3                 =5; // 拓展
}
]]
function mt:on_net_broadcast(resp)
    local ec = resp.errcode 
    if ec == 0 then 
        local type = resp.type
        local view = global._view:getViewBase("QZMaJiang") 
        if view == nil then 
            return 
        end 
        local data = {}--[[seatid(int 座位id),type(int 广播类型),play_type(int 玩家人数模式)
        is_prepare (bool 是否点击准备)
        ]]
        if type == BROADCAST_TYPE_FORCEEXIT then --1 强制退出房间（只对当事人发送）
             -- 调用函数[]
            -- view:Force_Exit()
        elseif type == BROADCAST_TYPE_EXIT then -- 2 退出房间 
            data.seatid = resp.param1 
            data.type = type
            if resp.param2 and resp.param2 ~= 0 then 
                data.play_type = resp.param2  
            end 
            -- 调用函数 [seatid,type,play_type]
            -- view.Broad_Exit(data)
        elseif type == BROADCAST_TYPE_CANCEL_PREPARE then -- 3 取消准备 
            data.seatid = resp.param1 
            if resp.param2 then --1准备
                if resp.param2 == 1 then 
                    data.is_prepare = true
                else 
                    data.is_prepare = false
                end 
                -- 调用函数[seatid,is_prepare]
                -- view.UpdatePlayerPrepare(data)
            end
            --todo
        elseif type == BROADCAST_TYPE_PREPARE then -- 4 --准备
            data.seatid = resp.param1 
            if resp.param2 then --1准备
                if resp.param2 == 1 then 
                    data.is_prepare = true
                else 
                    data.is_prepare = false
                end 
                 -- 调用函数[seatid,is_prepare]
                -- view.UpdatePlayerPrepare(data)
            end            
        end         
    end 

end 

return mt