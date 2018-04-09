local global = require("global")
local transform;
local mgr_room = global.player:get_mgr("room")
local const = global.const
NiuniuPanel = {};
local this = NiuniuPanel;
NiuniuPanel.gameObject = nil;



--启动事件--
function NiuniuPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("Niuniu")--必加
end

--初始化面板--
function NiuniuPanel.InitPanel()
	this.createRoom = transform:FindChild("createRoom").gameObject;--创建房间
	this.joinRoom = transform:FindChild("joinRoom").gameObject;--加入房间
	this.joinPublic = transform:FindChild("joinPublic").gameObject;--加入大厅
	this.btnBack = transform:Find("PlayerInfo/btnBack").gameObject;
	this.playerIcon = transform:Find("PlayerInfo/playerIcon").gameObject;
	this.playerIcon_AsyncImageDownload = this.playerIcon:GetComponent('AsyncImageDownload');
	this.diamondTxt = transform:Find("PlayerInfo/diamond/diamondTxt").gameObject;
	this.coinTxt = transform:Find("PlayerInfo/coin/coinTxt").gameObject;
	this.diamondTxt = transform:Find("PlayerInfo/diamond/diamondTxt"):GetComponent('UILabel');
	this.coinTxt = transform:Find("PlayerInfo/coin/coinTxt"):GetComponent('UILabel');
	this.joinEffect = transform:Find("joinEffect").gameObject;
	this.joinEffect_Renderer = this.joinEffect:GetComponent('SpriteRenderer');
	this.createEffect = transform:Find("createEffect").gameObject;
	this.createEffect_Renderer = this.createEffect:GetComponent('SpriteRenderer');
	this.uplight1 = transform:Find("uplight1").gameObject;
	this.uplight1_Renderer = this.uplight1:GetComponent('SpriteRenderer');
	this.uplight2 = transform:Find("uplight2").gameObject;
	this.uplight2_Renderer = this.uplight2:GetComponent('SpriteRenderer');
	this.uplight3 = transform:Find("uplight3").gameObject;
	this.uplight3_Renderer = this.uplight3:GetComponent('SpriteRenderer');
	this.title_Sprite=transform:Find("Title/TitleSprite"):GetComponent("UISprite");
	this.dayTwoOpen=transform:Find("dayTwoOpen").gameObject;
	this.dayTwoOpen_Btn=this.dayTwoOpen.transform:Find("Sprite").gameObject
	this.showDialog=transform:Find("showDialog").gameObject;
	this.showDialog_UIPanel = this.showDialog:GetComponent('UIPanel');
end

function NiuniuPanel.updatePlayerInfo()
	this.diamondTxt.text=global.player:get_RMB()
	this.coinTxt.text = global.player:get_money()
end 

function NiuniuPanel.InitPanelTitle(gameID)
	if(gameID==const.GAME_ID_NIUNIU)then
		this.title_Sprite.spriteName="zinn";
	elseif(gameID==const.GAME_ID_12ZHI)then
		this.title_Sprite.spriteName="zisez";
	elseif(gameID==const.GAME_ID_PAIGOW)then
		this.title_Sprite.spriteName="zidpj";
	elseif(gameID==const.GAME_ID_YAOLEZI)then
		this.title_Sprite.spriteName="ziylz";
	elseif(gameID==const.GAME_ID_WATER)then
		this.title_Sprite.spriteName="zisss";
	elseif(gameID==const.GAME_ID_MJ)then
		this.title_Sprite.spriteName="zimj";
	end
end 
function this.InitDayTwoOpen(gameID,cb)
	if (gameID==const.GAME_ID_12ZHI)then 
		this.dayTwoOpen:SetActive(true);
		cb();	
	end 
end 
function NiuniuPanel.openGame(gameID)
	if (gameID==const.GAME_ID_12ZHI)then
		global._view:SetRoom().Awake(gameID);
	elseif(gameID==const.GAME_ID_PAIGOW) then
		global._view:SetRoom().Awake(gameID);
	elseif(gameID==const.GAME_ID_YAOLEZI)then 
		global._view:SetRoom().Awake(gameID);
	elseif(gameID==const.GAME_ID_WATER)then 
		if(this.ui ~= nil) then
			this.ui.showShiShuiTip()
		end
	elseif(gameID==const.GAME_ID_MJ)then 
		global._view:SetRoom().Awake(gameID);
	else 
		global._view:showLoading();
		mgr_room:create(gameID,function (data)
			if(this.ui ~= nil) then
				if(data ~= nil) then
					local succec = data.errcode
					if(succec == 0) then
						if (gameID==const.GAME_ID_NIUNIU)then 
							global._view:room().Awake(data.roomid,false,"")
						-- elseif (gameID==const.GAME_ID_12ZHI)then
							-- global._view:ShierzhiRoom().Awake(data.roomid,false,"")
						end 
					else
						global._view:hideLoading();
					end
				end
			end
		end)
	end

end

-- play_type : int 玩法，1:自由坐庄 2:抢庄
-- 	bout_type : int 回合类型 1:10 2:20
-- 	pour_num  : int 最多设置注数
-- 	pour_coin  : int 设置最少的金币
function NiuniuPanel.openShiSanShui(play_type,bout_type, pour_num, pour_coin)
	global._view:showLoading();
	mgr_room:create_room_water(const.GAME_ID_WATER,function (data)
		global._view:hideLoading();
		local succec = data.errcode
		if(succec == 0) then
			global._view:sanshui().Awake(data.roomid,false,"")
		end
	end,play_type,bout_type, pour_num, pour_coin)
end

function NiuniuPanel.setTip(text)
	global._view:getViewBase("Tip").setTip(text)
end

function NiuniuPanel.getHeadUrl()
	return global.player:get_headimgurl()
end

function NiuniuPanel.get_RMB()
	return global.player:get_RMB()
end

function NiuniuPanel.get_money()
	return global.player:get_money()
end

function NiuniuPanel.JoinRoom(gameID)
	global._view:joinroom().Awake(1,gameID)
end

function NiuniuPanel.backLobby()
	global._view:gamelobby().Awake()
end

function NiuniuPanel.memberSort(list)
	table.sort(list,function (a,b)
        return a.roomid > b.roomid
    end)
    return list
end

function NiuniuPanel.gameScore(gameID)
	global._view:showLoading();
	mgr_room:req_get_hall_list(gameID,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil and list ~= nil) then
			global._view:gameScore().Awake(list,gameID)
		end
	end)
end

function NiuniuPanel.SanshuiGameScore(gameID)
	global._view:showLoading();
	mgr_room:req_get_waterhall_list(gameID,nil,nil,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil and list ~= nil) then
			global._view:gameScore().Awake(list,gameID)
		end
	end)
end

function this.DayOpenOnClick(gameID)
	global._view:showLoading();
	mgr_room:enter(gameID,const.ROOMID_12ZHI_DATING2,function (data)
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					if (gameID==const.GAME_ID_12ZHI)then	
						 global._view:ShierzhiRoom().Awake(data.roomid,false,const.ROOMID_12ZHI_DATING2)
				   end				
				else
					global._view:hideLoading();
				end
			end
		end
	end)
end 

function this.PlayBGSound(gameid)
	global._view:PlayBGSound(gameid)
end 

function NiuniuPanel.OnDestroy()
	this.ui.Close()
end

return NiuniuPanel