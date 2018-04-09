local global = require("global")
local transform;
local mgr_room = global.player:get_mgr("room")
local mgr_yaolezi= global.player:get_mgr("yaolezi")
local const = global.const
YaoLeZiPanel = {};
local this = YaoLeZiPanel;

this.gameObject = nil;
this.IsClickBack = false;

function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel(); 
	global._view:changeLayerAll("YaoLeZi")
	mgr_yaolezi:nw_reg();--后面加上
	this.GetPlayerData()
end

function this.InitPanel()
	
	this.PlayBGSound(const.GAME_ID_YAOLEZI)
    --Right
    this.Right=transform:Find("Right");
    this.money=this.Right:Find("money");
    this.betfive=this.money:Find("betfive").gameObject;
    this.betten=this.money:Find("betten").gameObject;
    this.bethund=this.money:Find("bethund").gameObject;
    this.betkilo=this.money:Find("betkilo").gameObject;
    this.bettenshou=this.money:Find("bettenshou").gameObject;
	this.betmill=this.money:Find("betmill").gameObject;
	this.okBtn=this.Right:Find("okBtn").gameObject;
	this.clearBtn=this.Right:Find("clearBtn").gameObject;
	this.betfive_UISprite=this.betfive:GetComponent("UISprite");
	this.betten_UISprite=this.betten:GetComponent("UISprite");
	this.bethund_UISprite=this.bethund:GetComponent("UISprite");
	this.betkilo_UISprite=this.betkilo:GetComponent("UISprite");
	this.bettenshou_UISprite=this.bettenshou:GetComponent("UISprite");
	this.betmill_UISprite=this.betmill:GetComponent("UISprite");
	this.okBtn_UISprtie=this.okBtn:GetComponent("UISprite");
	this.clearBtn_UISprite=this.clearBtn:GetComponent("UISprite");

	this.nazhiBet=this.Right:Find("nazhiBet").gameObject;
	this.nazhi_1=this.nazhiBet.transform:Find("1").gameObject;
	this.nazhi_10=this.nazhiBet.transform:Find("5").gameObject;
	this.nazhi_20=this.nazhiBet.transform:Find("10").gameObject;
	
    --bottom
    this.bottom=transform:Find("bottom");
    this.playlist=this.bottom:Find("playlist").gameObject;
    this.bank=this.bottom:Find("bank").gameObject;
    this.share=this.bottom:Find("share").gameObject;
    this.rule=this.bottom:Find("rule").gameObject;
    this.back=this.bottom:Find("back").gameObject;
    this.invite=this.bottom:Find("invite").gameObject;
	this.flexoBtn=this.bottom:Find("flexoBtn").gameObject;
	this.flexoBtn_label=this.flexoBtn.transform:Find("Label"):GetComponent("UILabel");	
	this.flexoBtn_cover=this.flexoBtn.transform:Find("cover").gameObject;
	this.record=this.bottom:Find("record").gameObject;
	this.record_1=this.record.transform:Find("Label1").gameObject;
	this.record_2=this.record.transform:Find("Label2").gameObject;
	this.record_3=this.record.transform:Find("Label3").gameObject;
	this.record_1_label=this.record_1:GetComponent("UILabel");
	this.record_2_label=this.record_2:GetComponent("UILabel");
	this.record_3_label=this.record_3:GetComponent("UILabel");
    --upLeft
    this.upLeft=transform:Find("upLeft");
    this.bankerName=this.upLeft:Find("bankerName").gameObject;
	this.bankerName_Label=this.bankerName:GetComponent("UILabel");
	this.upLeft_patten = this.upLeft:Find("Patten")
    this.roomID=this.upLeft_patten:Find("roomID").gameObject;
	this.roomID_Label=this.roomID:GetComponent("UILabel");
	this.robBg=this.upLeft:Find("robBg").gameObject;
	this.robBg_UISprite=this.robBg:GetComponent("UISprite");
	this.rob=this.upLeft:Find("rob").gameObject;
	this.rob_UISprite=this.rob:GetComponent("UISprite");
    this.headPanel=this.upLeft:Find("HeadPanel").gameObject;
    this.robHead=this.headPanel.transform:Find("robHead").gameObject;
	this.robHead_AsyncImageDownload=this.robHead:GetComponent("AsyncImageDownload");
	this.robEffect=this.rob.transform:Find("robEffect").gameObject;
    --upRight
    this.upRight=transform:Find("upRight");
    this.playerIcon=this.upRight:Find("PlayerIcon").gameObject;
    --this.playerIcon_Texture=this.playerIcon:GetComponent("UITexture");
    this.PlayerIcon_AsyncImageDownload = this.playerIcon:GetComponent('AsyncImageDownload');
    this.playerCoin=this.upRight:Find("playerCoin").gameObject;
    this.playerCoin_Label=this.playerCoin:GetComponent("UILabel");
    this.playerSilver=this.upRight:Find("playerSilver").gameObject;
    this.playerSilver_Label=this.playerSilver:GetComponent("UILabel");
    this.playerName=this.upRight:Find("playerName").gameObject;
    this.playerName_Label=this.playerName:GetComponent("UILabel");
    this.sumBetMoney=this.upRight:Find("sumBetMoney");
	this.sumBetMoney_Label=this.sumBetMoney:Find("Label"):GetComponent("UILabel");
	
	this.patten=this.upRight:Find("Patten").gameObject;
    this.type=this.patten.transform:Find("type");
    this.type_Label=this.type:GetComponent("UILabel");
    this.number=this.patten.transform:Find("number").gameObject;
    this.number_Label=this.number:GetComponent("UILabel");
    this.sumNumber=this.patten.transform:Find("sumNumber").gameObject;
    this.sumNumber_Label=this.sumNumber:GetComponent("UILabel");
    --timeBG
    this.timeBG=transform:Find("timeBG");
    this.timeTxt=this.timeBG:Find("timeTxt").gameObject;
    this.timeTxt_Label=this.timeTxt:GetComponent("UILabel");
    this.betState=this.timeBG:Find("betState").gameObject;
    this.betState_Label=this.betState:GetComponent("UILabel");
    this.tiprob=this.timeBG:Find("tiprob").gameObject;
    --Tips
    this.Tips=transform:Find("Tips");
    this.fristenter=this.Tips:Find("fristenter").gameObject;
    this.fristenter_Label=this.fristenter:GetComponent("UILabel");
    
    --showUI
    this.showUI=transform:Find("showUI");
    this.uibox=this.showUI:Find("uibox").gameObject;
	this.balanceEnter=this.showUI:Find("balanceEnter").gameObject;	
	this.balanceList=this.balanceEnter.transform:Find("balanceList").gameObject;
	this.balanceList_UIScrollView = this.balanceList:GetComponent('UIScrollView');
	this.balanceCollider = transform:Find("showUI/balanceEnter/balanceList/balanceCollider").gameObject
	this.balanceCollider_UISprite = this.balanceCollider:GetComponent('UISprite')
    --loseRob
    -- this.loseRob=transform:Find("loseRob");
    -- this.lsoeRob_Anima=this.loseRob:GetComponent('Animator');
    -- this.loseRob_Close=this.loseRob:Find("close").gameObject;   
    --CenterBG
    this.centerBG=transform:Find("CenterBG");
	this.chessList=this.centerBG:Find("chessList");
	this.nazhiList = this.centerBG:Find("nazhiList");
	
	--shadeAnima
	this.shadeAnima=transform:Find("shadeAnima");
	this.shadeAnimaObj=this.shadeAnima:Find("anima").gameObject;
	this.shade_anima=this.shadeAnima:GetComponent("Animator");
	this.shade=this.shadeAnima:Find("shade").gameObject;
	this.shade_di=this.shade.transform:Find("di");
	this.shade_chess_1=this.shade_di:Find("1").gameObject;
	this.shade_chess_2=this.shade_di:Find("2").gameObject;
	this.shade_chess_3=this.shade_di:Find("3").gameObject;
	this.chess_1_sprite=this.shade_chess_1:GetComponent("UISprite");
	this.chess_2_sprite=this.shade_chess_2:GetComponent("UISprite");
	this.chess_3_sprite=this.shade_chess_3:GetComponent("UISprite");
	this.shade_tp=this.shade:GetComponent("TweenPosition");
	this.shade_ts=this.shade:GetComponent("TweenScale");
	this.shade_gai=this.shade.transform:Find("gai").gameObject;
	this.shade_gai_collider=this.shade_gai:GetComponent("BoxCollider2D");
	this.shade_gai_sprite=this.shade_gai:GetComponent("UISprite");
	-- --测试
	-- this.fangzhilabel=transform:Find("fangzhi"):GetComponent("UILabel");
	-- this.nazhilabel=transform:Find("nazhi"):GetComponent("UILabel");

end

function this.updatePlayerInfo()
	if this.ui~=nil then 
		if this.ui._curState~=const.YAOLEZI_STATUS_OPEN 
		and this.ui._curState~=const.YAOLEZI_STATUS_BET then 
			this.ui.UpdatePlayerInfo()
		end 
	end 
end 

function this.GetTime()
    return global.ts_now;
end 

function this.GetPlayerData()
	
	if (this.ui.KEYCTRL)then
		-- --暂时
		-- local data={
		-- 	house_owner_name=101010,
		-- 	player_max_coin=50000,
		-- 	banker_name="jk",
		-- 	over_time=this.GetTime()+10,
		-- 	game_status=5,
		-- 	canFangzhi=false,
		-- 	canNazhi=false,
		-- 	canFangzhi=false,
		-- 	canNazhi=true,
		-- }
		-- global._view:showLoading();
		-- if (this.ui~=nil)then
		-- 	this.ui.Init(data,const,0)
		-- end 
	else
		global._view:showLoading()
		mgr_yaolezi:req_data(function (data)
			global._view:hideLoading();
			if (this.ui ~= nil) then
				if (data ~= nil) then
					this.ui.Init(data,const,0)
				else
					this.GetPlayerData()
				end
			end
		end)

	end    
  
end

function this.GetPlayerImg()
	return global.player:get_headimgurl()
end
--放支下注信息更新
function this.UpdateFangzhiData(info)
	if (this.ui~=nil)then
		this.ui.ChatBet(info,2)
		if info.playerid == this.GetPlayerID()then 
			return
		end
		--广播，自己不用播放 
		this.ui.UpdateFangZhiByNet(info)
	end 
end 
--下注信息更新
function this.UpdateBetData(info)
	if (this.ui~=nil)then 
		this.ui.ChatBet(info,1)
		this.ui.UpdateBetData(info,false)
	end 
end 
--拿支下注信息更新
function this.UpdateNaZhiData(info)
	if (this.ui~=nil)then 
		this.ui.ChatBet(info,3)
		this.ui.UpdateBetData(info,true)
	end 
end 

function this.SetBetState(data)
	if (this.ui~=nil)then 
		this.ui.UpdateBetState(data,data.liuju)
	end 
end 

function this.GetPlayerName()
	return global.player:get_name()
end
function this.GetPlayerID()
	return global.player:get_playerid()
end 
function this.GetPlayerCoin()
	return global.player:get_money()
end

function this.GetPlayerRMB()
	return global.player:get_RMB()
end

--获取玩家列表
function this.GetPlayerList()
	global._view:showLoading();
	mgr_yaolezi:req_room_members(1,200,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					local list = this.memberSort(data.members)
					this.ui.renderPlayer(list)
				else
					this.setTip(global.errcode_util:get_errcode_CN(succec))
				end
			end
		end
	end)	
end

--玩家列表排序
function this.memberSort(list)
	table.sort(list,function (a,b)
        return a.RMB + a.money > b.RMB + b.money
    end)
    return list
end


--UpLeft
--获取庄家数据
function this.GetRobInfo()	
	global._view:showLoading();
	mgr_yaolezi:req_rob_banker_info(function (data,ec)
		global._view:hideLoading();
		if (#data > 0 and this.ui ~= nil) then
			this.ui.RobCallBack(data[1])
		else
			this.setTip(global.errcode_util:get_errcode_CN(ec))
		end
	end);
end
function this.robData(coin)
	
	global._view:showLoading();
	mgr_yaolezi:req_rob_banker(coin, function (data)
		global._view:hideLoading();
		if (data.errcode == 0) then
			if (this.ui ~= nil) then
				this.ui.CloseShowUI()
			end
		else
			this.setTip(global.errcode_util:get_errcode_CN(data.errcode))
		end
	end);
end
function this.RobBroadcast(data)
	if (this.ui~=nil)then 
		this.ui.RobBroadcast(data);
	end 
end 
function this.ShenZhicast(data)
	if (this.ui~=nil)then 
		this.ui.ShenZhicast(data);
	end
end 
--Tips
function this.setTip(text)
	global._view:getViewBase("Tip").setTip(text)
end 
--UpRight
function this.getPlayerImg()
	return global.player:get_headimgurl()
end
--bottom
--获取申支信息
function this.GetShenZhiData()
	global._view:showLoading();
	mgr_yaolezi:req_Shenzhi_info(function (data,ec)
		global._view:hideLoading();
		if (#data > 0 and this.ui ~= nil) then
			this.ui.ShenZhiCallBack(data[1])
		else
			this.setTip(global.errcode_util:get_errcode_CN(ec))
		end
	end);	
end 
--申支
function this.shenzhiData(coin)
	
	global._view:showLoading();
	mgr_yaolezi:req_shenzhi(coin, function (data)
		global._view:hideLoading();
		if (data.errcode == 0) then
			if (this.ui ~= nil) then
				this.ui.CloseShowUI()
			end
		else
			this.setTip(global.errcode_util:get_errcode_CN(data.errcode))
		end
	end);
end

function this.Shake_Shade()
	global._view:showLoading()
	mgr_yaolezi:req_shake_shade(function()
		global._view:hideLoading()	
	end )
end 

--right
function this.SendBetListToNet(bet_list,op)
	global._view:showLoading()
	mgr_yaolezi:req_bet(bet_list,op,function(data,op)
		global._view:hideLoading()
		local ec = data.errcode
		if ec == 0 then 
			if this.ui ~= nil then 
				this.ui.SendBetCallBack(op,true)
			end 
		else 
			this.setTip(global.errcode_util:get_errcode_CN(ec))
			if this.ui~= nil then 
				this.ui.SendBetCallBack(op,false)
			end 
		end 
		
	end)
end 
function this.OnBackClick(value)
	global._view:showLoading();
	this.IsClickBack = value
	if (value) then		
		mgr_room:exit(const.GAME_ID_YAOLEZI, function ()
			-- global._view:hideLoading();
		end)
		this.gameScore()
	else
		 global._view:niuniu().Awake(const.GAME_ID_YAOLEZI);		
	end	
	global._view:hideLoading();
	-- --暂时	
	-- global._view:gamelobby().Awake()
	-- mgr_room:exit(const.GAME_ID_YAOLEZI,function ()
	-- end )
end

function this.gameScore()
	global._view:showLoading();
	mgr_room:req_get_hall_list(const.GAME_ID_YAOLEZI, function (list)
		global._view:hideLoading();
		if (this.ui ~= nil) then
			global._view:gameScore().Awake(list,const.GAME_ID_YAOLEZI)
		end
	end)
end

function this.LoseRob(cb)
	global._view:showLoading()
	mgr_yaolezi:req_drop_banker(function()
		global._view:hideLoading()
		cb()
	end)
end 
function this.LoseRobCallBack(data)	  
	if this.ui~=nil then 
		this.ui.LoseRobCallBack(data)
	end 
end 

function this.PlayBGSound(gameid)
	global._view:PlayBGSound(gameid)
end 

function this.OnDestroy()
	global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
	if(this.IsClickBack == false) then
		mgr_room:exit(const.GAME_ID_YAOLEZI,function ()
		end)
	end
	mgr_yaolezi:nw_unreg();
end
return this