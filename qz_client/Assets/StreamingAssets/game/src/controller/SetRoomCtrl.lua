require "logic/ViewManager"
local global = require "global"
local i18n = global.i18n
SetRoomCtrl = {};
local this = SetRoomCtrl;
local mt = this
--玩法
local PLAYTYPE_1 =1
local PLAYTYPE_2 =2

this.const=global.const;

this.Set=nil;

this.gameID=nil;

this.play_type=1;
this.bout_type=1;
this.type3_is_click=false;

--起始值
this.type_1 = 0
this.type_2 = 0
this.type_3 = 10


this.len = 3 -- 每行能放的选框数
this.is_have_group_3  =nil --是否有附加选项

this.type_1_list = nil;
this.type_2_list = nil;
-- bout_type 1-9
this.shierzhiData={
	play_type={
		type1_label="自由模式",
		type2_label="抢庄",
		-- type3_label="可申请放支"--额外附加
	},
	--1类型选项
	-- bout_type_1={
	-- 	{label="10局"},
	-- 	{label="20局"},
	-- 	{label="10局"},
	-- 	{label="20局"},
	-- },
	--2类型选项
	bout_type_2={
		{label="10局"},
		{label="20局"},
	}
}
this.mjData={
	play_type={
		type1_label="人数设定",
		type2_label="局数设定",
	},
	bout_type_1={
		{label = "2人局"},
		{label = "3人局"},
		{label = "4人局"},
	},
	bout_type_2 = {
		{label="10局"},
		{label="20局"},
	}
}
this.paiGowData={
	play_type={
		type1_label="自由模式",
		type2_label="抢庄",
	},	
	bout_type_2={
		{label="10局"},
		{label="20局"},
	}
}
this.yaoLeZiData={
	play_type={
		type1_label="自由模式",
		type2_label="抢庄",
		-- type3_label="可申请放支"--额外附加
	},	
	bout_type_2={
		{label="10局"},
		{label="20局"},
	}
}
this.sanshuiData={
	play_type={
		type1_label="对比模式",
		type2_label="抢庄",
	},	
	bout_type_2={
		{label="10局"},
		{label="20局"},
	}
}

--构建函数--
function this.New()
	return this;
end

function this.Awake(gameID)
	this.gameID=gameID;
	panelMgr:CreatePanel('SetRoom',this.OnCreate);

end

--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.Set= this.transform:GetComponent('LuaBehaviour');
	
	this.RenderFunc();

	this.Set:AddClick(SetRoomPanel.okBtn,this.OKOnClick);
	this.Set:AddClick(SetRoomPanel.Close, function ()
		SetRoomPanel.clearView()
	end)

	this.Set:AddClick(SetRoomPanel.group_1,this.SelectPlayType);
	this.Set:AddClick(SetRoomPanel.group_2,this.SelectPlayType);
	this.Set:AddClick(SetRoomPanel.group_3,this.SelectPlayType);
end
------------------------功能-----------------------
function mt.RenderFunc()
	local data=nil; 
	-- this.boutList={};
	if (this.gameID==this.const.GAME_ID_12ZHI)then 
		data=this.shierzhiData
		SetRoomPanel.group.gameObject:SetActive(true)
		SetRoomPanel.mjgroup.gameObject:SetActive(false)
	elseif(this.gameID==this.const.GAME_ID_PAIGOW)then
		data=this.paiGowData
		SetRoomPanel.group.gameObject:SetActive(true)
		SetRoomPanel.mjgroup.gameObject:SetActive(false)
	elseif(this.gameID==this.const.GAME_ID_YAOLEZI)then
		data=this.yaoLeZiData
		SetRoomPanel.group.gameObject:SetActive(true)
		SetRoomPanel.mjgroup.gameObject:SetActive(false)
	elseif(this.gameID==this.const.GAME_ID_WATER)then
		data=this.sanshuiData
		SetRoomPanel.group.gameObject:SetActive(true)
		SetRoomPanel.mjgroup.gameObject:SetActive(false)
	elseif(this.gameID==this.const.GAME_ID_MJ)then
		-- data=this.mjData
		data = nil 
		SetRoomPanel.group.gameObject:SetActive(false)
		SetRoomPanel.mjgroup.gameObject:SetActive(true)

		this.RenderMjFunc()
	end
	
	if (data~=nil)then 
		local info=data.play_type;
		SetRoomPanel.group_1_label.text=info.type1_label;
		local star_pos = this.GetStartPos()
		SetRoomPanel.group_1.transform.localPosition = star_pos
		if data.bout_type_1 then 
			local type = 1
			this.DealGroupData(data.bout_type_1,type)
		end 
		if info.type3_label ~= nil then  --附加选项
			SetRoomPanel.group_3:SetActive(true)
			SetRoomPanel.group_3_label.text=info.type3_label;
			local def_y = this.GetType_1_Group_y()+this.GetSpace(2).y
			local pos = Vector3(star_pos.x,star_pos.y-def_y,0)
			SetRoomPanel.group_3.transform.localPosition = pos 		
			this.is_have_group_3 = true 
		end 
		local collider_h = 0
		if info.type2_label then 
			SetRoomPanel.group_2_label.text=info.type2_label;
			SetRoomPanel.group_2:SetActive(true)
			local def_y = this.GetType_1_Group_y()+this.GetSpace(2).y
			if this.is_have_group_3 then 
				def_y = def_y + this.GetSpace(2).y
			end 
			collider_h = def_y 
			local pos = Vector3(star_pos.x,star_pos.y-def_y,0)
			SetRoomPanel.group_2.transform.localPosition = pos 
			if data.bout_type_2 then 
				local type =2 
				this.DealGroupData(data.bout_type_2,type)
			end 
		
		end 
		collider_h = collider_h+this.GetType_2_Group_y()+70
		if collider_h>240 then 
			SetRoomPanel.bar_sprite.height = collider_h
		end 
	end 
end 

function mt.DealGroupData(data,type)
	local len = 1
	for k,v in pairs(data)do 
		local group_data = {
			id = len,
			name =len,
			type = type,
			label = v.label,
			pos = this.GetGroupPos(type),
		}				
		this.CreatGroup(group_data)
		len = len + 1
	end 
end 
--id ,name,label,pos
function mt.CreatGroup(data)
	local bundle=resMgr:LoadBundle("group");
	local prefab=resMgr:LoadBundleAsset(bundle,"group");
	local go =GameObject.Instantiate(prefab);
	resMgr:addAltas(go.transform,"SetRoom");
	go.name=data.name
	go.transform.parent=SetRoomPanel.group_list
	go.transform.localScale=Vector3.one;
	go.transform.localPosition=data.pos
	go.transform:Find("Label").gameObject:GetComponent("UILabel").text=data.label;
	local group= go:GetComponent("UIToggle");
	if data.type == 1 then 
		if not this.type_1_list then 
			this.type_1_list = {}
		end 
		this.type_1_list[data.id] = go 
		this.Set:AddClick(go,this.SelectBoutType_1);
	elseif data.type == 2 then 
		if not this.type_2_list then 
			this.type_2_list = {}
		end 
		this.type_2_list[data.id] = go 
		this.Set:AddClick(go,this.SelectBoutType_2);
	end 
		
end 


--------------------------mj-------------------------
this.people_nu = 2 
-- this.game_nu = 5
this.input_coin = 1
this.mj_gourp_amount = 3
-- local MAX_INPUT_COIN = 1000
local MIN_INPUT_COIN = 1
function mt.RenderMjFunc()
	this.Set:AddClick(SetRoomPanel.mj_p_group_1,this.OnGroup)
	this.Set:AddClick(SetRoomPanel.mj_p_group_2,this.OnGroup)
	this.Set:AddClick(SetRoomPanel.mj_p_group_3,this.OnGroup)

	-- this.Set:AddClick(SetRoomPanel.mj_g_group_1,this.OnGroup)
	-- this.Set:AddClick(SetRoomPanel.mj_g_group_2,this.OnGroup)
	-- this.Set:AddClick(SetRoomPanel.mj_g_group_3,this.OnGroup)
	SetRoomPanel.mj_input_UIInput.value = 1
	resMgr:InputEventDeleate(SetRoomPanel.mj_input_UIInput,function()
		SetRoomPanel.mj_input_UILabel.text = SetRoomPanel.mj_input_UIInput.value
		this.input_coin =  SetRoomPanel.mj_input_UIInput.value
	end )
	this.people_nu = 2 
	-- this.game_nu = 5
	this.input_coin = 1
	this.OnGroupUpdateSprite(SetRoomPanel.mj_p_group_1)
	-- this.OnGroupUpdateSprite(SetRoomPanel.mj_g_group_1)
end 
function mt.OnGroupUpdateSprite(go)
	local parent = go.transform.parent	
	for i = 1 , this.mj_gourp_amount do 
		local str = "group_"..i.."/Sprite" 
		local sprite_obj = parent:Find(str).gameObject
		sprite_obj:SetActive(false)
	end 
	go.transform:Find("Sprite").gameObject:SetActive(true)
end 
function mt.OnGroup(go)
	-- local parent = go.transform.parent	
	local name = go.name 
	local nu = string.gsub( name,"group_","")+0
	this.people_nu = nu + 1
	-- if parent.name == "PeopleNu" then 
	-- 	this.people_nu = nu + 1
	-- elseif parent.name  == "GameNu" then 
	-- 	this.game_nu = nu*5
	-- end  
	this.OnGroupUpdateSprite(go)
end 
function mt.MJReset()
	this.people_nu = 2 
	-- this.game_nu = 5
	this.input_coin = 1
	this.OnGroupUpdateSprite(SetRoomPanel.mj_p_group_1)
	-- this.OnGroupUpdateSprite(SetRoomPanel.mj_g_group_1)
end 
function mt.SetCoin()


end 
------------------------数据获取-----------------------
function mt.GetStartPos()
	return Vector3(-120,90,0)
end 
function mt.GetGroupPos(type)
	local space = this.GetSpace(1)
	local str_pos  = this.GetStartPos()
	local len = 0
	local list = nil 
	local def_y = 0
	if type == 1 then 
		if not this.type_1_list then 
			this.type_1_list = {}
		end 
		list = this.type_1_list
	elseif type == 2 then 
		def_y = this.GetType_1_Group_y()
		def_y = def_y + this.GetSpace(2).y
		if this.is_have_group_3 then 
			def_y = def_y + this.GetSpace(2).y
		end 
		if not this.type_2_list then 
			this.type_2_list = {}
		end 
		list = this.type_2_list
	end 
	for k,v in pairs(list)do 
		len = len + 1 
	end 
	local pos_x = str_pos.x + space.x *len + math.floor(len/this.len)*str_pos.x*this.len 
	local pos_y = str_pos.y - math.floor(len/this.len)*space.y-def_y-space.y
	return Vector3(pos_x,pos_y,0)		
end 
function mt.GetSpace(type)--1、选框与选框 2、模式与模式
	if type == 1 then 
		return Vector3(120,50,0)
	elseif type == 2 then 
		return Vector3(120,60,0)
	end 
	print("报错，没有对应类型的间距！！！")
	return nil 
end 
function mt.GetType_1_Group_y()
	local def_y = 0
	local type1_len = 0
	local space = this.GetSpace(1)
	if this.type_1_list then 
		for k,v in pairs(this.type_1_list)do 
			type1_len =type1_len + 1 
		end 
		def_y = space.y * math.floor(type1_len/this.len)+space.y
	end 
	return def_y
end 
function mt.GetType_2_Group_y()
	local def_y = 0
	local type2_len = 0
	local space = this.GetSpace(1)
	if this.type_2_list then 
		for k,v in pairs(this.type_2_list)do 
			type2_len =type2_len + 1 
		end 
		def_y = space.y * math.floor(type2_len/this.len)
	end 
	return def_y
end 

------------------------单击事件-----------------------
--id ,play_type,bout_type_2
function mt.OKOnClick(go)
	if this.gameID == this.const.GAME_ID_MJ then 
		this.input_coin =  SetRoomPanel.mj_input_UIInput.value + 0
		if this.input_coin < MIN_INPUT_COIN then 
			local str =i18n.TID_SETROOM_INPUTMONEY_MIN_INFO
			global._view:getViewBase("Tip").setTip(string.format(str,MIN_INPUT_COIN))
			return
		end 
		local gameid = this.gameID
		local people_nu = this.people_nu
		-- local game_nu = this.game_nu
		local input_coin = this.input_coin
		SetRoomPanel.CreateMJRoom(gameid,people_nu,input_coin)
	else 
		SetRoomPanel.OKOnClick(this.gameID,this.play_type,this.bout_type);
	end 
end 

function mt.SelectPlayType(go)
	if (go.name=="group_1")then 
		this.play_type=PLAYTYPE_1;
		if this.type_2_list then 
			this.ResetGroupSprite(this.type_2_list)
		end 
		SetRoomPanel.group_1_sprite:SetActive(true) 
		SetRoomPanel.group_2_sprite:SetActive(false)
		if this.type_1_list then 
			local go = this.type_1_list[1]
			go.transform:Find("Sprite").gameObject:SetActive(true)
			this.bout_type = go.name + this.type_1 
		end 	

	elseif (go.name=="group_2")then 
		this.play_type=PLAYTYPE_2;
		if this.type_1_list then 
			this.ResetGroupSprite(this.type_1_list)
		end 
		SetRoomPanel.group_1_sprite:SetActive(false) 
		SetRoomPanel.group_2_sprite:SetActive(true)
		if this.type_2_list then 
			local go = this.type_2_list[1]
			go.transform:Find("Sprite").gameObject:SetActive(true)
			this.bout_type = go.name + this.type_2 
		end 
	elseif (go.name=="group_3")then 
		if this.type3_is_click ==false then 
			this.play_type = this.play_type + this.type_3 
			this.type3_is_click=true
			SetRoomPanel.group_3_sprite:SetActive(true);
		else 
			this.play_type = this.play_type - this.type_3 
			this.type3_is_click=false
			SetRoomPanel.group_3_sprite:SetActive(false);
		end 
	end 
end 
function mt.SelectBoutType_1(go)
	if this.play_type ~= PLAYTYPE_1 then
		SetRoomPanel.group_1_sprite:SetActive(true) 
		SetRoomPanel.group_2_sprite:SetActive(false)
		this.play_type = PLAYTYPE_1
		if this.type3_is_click then 
			this.play_type = PLAYTYPE_1 + this.type_3 
		end 
	end 
	this.ResetGroupSprite(this.type_1_list)
	go.transform:Find("Sprite").gameObject:SetActive(true)
	local id = go.name + this.type_1 
	this.bout_type = id 
end	
function mt.SelectBoutType_2(go)
	if this.play_type ~= PLAYTYPE_2 then 
		SetRoomPanel.group_1_sprite:SetActive(false) 
		SetRoomPanel.group_2_sprite:SetActive(true)
		this.play_type = PLAYTYPE_2
		if this.type3_is_click then 
			this.play_type = PLAYTYPE_2 + this.type_3 
		end 
	end 
	this.ResetGroupSprite(this.type_2_list)
	go.transform:Find("Sprite").gameObject:SetActive(true)
	local id = go.name+ this.type_2 
	this.bout_type = id 
end
------------------------重置-----------------------
function mt.Reset()
	this.play_type=1;
	this.bout_type=1;
	this.type3_is_click=false;
	this.type_1_list = nil 
	this.type_2_list = nil 
	this.is_have_group_3 = nil
end 
function mt.ResetGroupSprite(list)
	for k,v in pairs(list)do 
		v.transform:Find("Sprite").gameObject:SetActive(false)
	end 
end 
------------------------关闭-----------------------
function mt.Close()	 
	this.gameID=nil ;
	this.Reset();
	this.MJReset();
	panelMgr:ClosePanel(CtrlNames.SetRoom);
end

return SetRoomCtrl