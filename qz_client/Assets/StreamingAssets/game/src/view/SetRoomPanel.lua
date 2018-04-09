local global = require("global")
local transform;
local mgr_room=global.player:get_mgr("room")
local const = global.const;
SetRoomPanel = {};
local this = SetRoomPanel;
SetRoomPanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("SetRoom")--必加
end

--初始化面板--
function this.InitPanel()
	this.okBtn=transform:Find("okBtn").gameObject;
	this.Close=transform:Find("close").gameObject;
	this.group=transform:Find("group");
	this.group_list = this.group:Find("GroupList")

	this.group_1=this.group_list:Find("group_1").gameObject;
	this.group_2=this.group_list:Find("group_2").gameObject;
	this.group_3=this.group_list:Find("group_3").gameObject;
	this.group_1_sprite=this.group_1.transform:Find("Sprite").gameObject;
	this.group_2_sprite=this.group_2.transform:Find("Sprite").gameObject;

	this.cutOffRule = this.group_list:Find("CutOffRule")
	this.barCollier = this.group_list:Find("BarCollider").gameObject
	this.bar_sprite = this.barCollier:GetComponent("UISprite")
	

	this.group_1_label=this.group_1.transform:Find("Label"):GetComponent("UILabel");
	this.group_2_label=this.group_2.transform:Find("Label"):GetComponent("UILabel");

	-- this.group2=this.group:Find("p2/group2").gameObject;--todo

	--附加先选
	this.group_3_label=this.group_3.transform:Find("Label"):GetComponent("UILabel");
	this.group_3_sprite=this.group_3.transform:Find("Sprite").gameObject;


	-------------------------------majiang-----------------------------------------
	this.mjgroup = transform:Find("MJgroup")
	this.mj_people_nu = this.mjgroup:Find("PeopleNu")
	this.mj_p_group_1 = this.mj_people_nu:Find("group_1").gameObject
	this.mj_p_group_2 = this.mj_people_nu:Find("group_2").gameObject
	this.mj_p_group_3 = this.mj_people_nu:Find("group_3").gameObject
	-- this.mj_game_nu = this.mjgroup:Find("GameNu")
	-- this.mj_g_group_1 = this.mj_game_nu:Find("group_1").gameObject
	-- this.mj_g_group_2 = this.mj_game_nu:Find("group_2").gameObject
	-- this.mj_g_group_3 = this.mj_game_nu:Find("group_3").gameObject
	this.mj_input_nu = this.mjgroup:Find("MoneyNu")
	this.mj_input_money = this.mj_input_nu:Find("Input")
	this.mj_input_UIInput = this.mj_input_money:GetComponent("UIInput")
	this.mj_input_UILabel = this.mj_input_money:GetComponent("UILabel")
	
end


-- 创建房间
--[[
	play_type : int 玩法，1:自由坐张 2:抢庄
	bout_type : int 回合类型 1:4 2:8 3:12
]]
function this.OKOnClick(gameID,play_type,bout_type) 
	global._view:showLoading();
	mgr_room:create(gameID,function(data)
		if (this.ui~=nil)then 
			if(data~=nil)then			
				local succec = data.errcode
				if (succec==0)then
					if (gameID==const.GAME_ID_12ZHI)then
						global._view:ShierzhiRoom().Awake(data.roomid,false,"")
					elseif (gameID==const.GAME_ID_PAIGOW)then
						global._view:paiGow().Awake(data.roomid,false,"")
					elseif (gameID==const.GAME_ID_YAOLEZI)then 
						global._view:YaoLeZi().Awake(data.roomid,false,"")
					elseif (gameID==const.GAME_ID_WATER)then 
						global._view:sanshui().Awake(data.roomid,false,"")
					elseif (gameID==const.GAME_ID_MJ)then 
						global._view:majiang().Awake(data.roomid,false,"")
					end 
				end 
			end
		end
		global._view:hideLoading();
	end, play_type,bout_type)
end 

function this.CreateMJRoom(gameID,people_nu,game_nu,coin)
	global._view:showLoading();
	mgr_room:create_room_mj(gameID,function(data)
		if this.ui~=nil then 
			if data then 
				local succec = data.errcode
				if succec == 0 then 
					global._view:majiang().Awake(data.roomid,false,"")
				end 
			end 
		end 
		global._view:hideLoading();
	end,people_nu,game_nu,coin)
end 
	 
function this.clearView()
	global._view:clearFormulateUI("SetRoom")
end

function this.OnDestroy()
	this.ui.Close()
end

return SetRoomPanel