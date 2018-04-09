--
-- Author: wangshaopei
-- Date: 2017-08-07 11:13:10
--
require "logic/ViewManager"
local global = require("global")
local i18n = global.i18n
local mgr_dealer = global.player:get_mgr("dealer")
local player = global.player

DealerCtrl = {};
local this = DealerCtrl;

local INX_FUN_INFO = 1
local INX_FUN_SETTING = 2
local INX_FUN_LIST = 3
local INX_FUN_TWO = 4
local INX_FUN_THREE = 5

local panel
local USER_LIST_MAX = 10 --一次10条

this.cur_btn = nil --gamobject 当前选择的按钮 

this.dealer_player_list = nil --{obj}
this.dealer_LV_list = nil --{obj}
this.playerid = nil 
this.dealer_data = nil 

this.cur_click_label_obj = nil 

--构建函数--
function this.New()
	-- print("DealerCtrl.New--->>");

	return this;
end

function this.Awake()
	-- print("DealerCtrl.Awake--->>");
	panelMgr:CreatePanel('Dealer', this.OnCreate);
	panel = DealerPanel
end

--启动事件--
function this.OnCreate(obj)
	this.funs={}
	this.funs={[INX_FUN_INFO] ={content = DealerPanel.dealer_info,btn=DealerPanel.BtnInfo},
				[INX_FUN_SETTING] ={content = DealerPanel.dealer_setting,btn=DealerPanel.BtnSetting},
				[INX_FUN_LIST] ={content = DealerPanel.dealer_user_list,btn=DealerPanel.BtnList},
				[INX_FUN_TWO] ={content = DealerPanel.dealer_lv,btn=DealerPanel.btn_lv_2},
				[INX_FUN_THREE] ={content = DealerPanel.dealer_lv,btn=DealerPanel.btn_lv_3},
			}
	this.gameObject = obj;
	this.transform = obj.transform;
	this.cur_page = 1
	-- this.panel = this.transform:GetComponent('UIPanel');

	this.beh= this.transform:GetComponent('LuaBehaviour');

	DealerPanel.detail:SetActive(false)

	-- this.renderFunc();
	for k,v in pairs(this.funs) do
		this.beh:AddClick(v.btn, this.OnClick);
	end
	this.beh:AddClick(DealerPanel.ButAdd, this.OnClick);

	this.beh:AddClick(DealerPanel.ButClose, this.OnClose);


	this.Get_Dealer_data()
	-- this.playerid = DealerPanel.GetPlayerID()
end

function this.Get_Dealer_data()
	DealerPanel.req_dealer_bills()
end 
function this.Start(data)
	this.dealer_data =data
	this.playerid = DealerPanel.GetPlayerID()
	this.sel(INX_FUN_INFO)
end 

function this.Close()
	mgr_dealer:clear()
	this.cur_btn = nil 
	this.dealer_player_list = nil
	this.dealer_LV_list = nil 
	this.info_data = nil
	this.info_LV2_data = nil  
	this.info_LV3_data = nil 
	this.cur_click_label_obj = nil 
	panelMgr:ClosePanel(CtrlNames.Dealer);
end

function this.OnClose()
	DealerPanel.clearView()
end

function this.sel(tpe)
	if this.cur_btn then 
		local h_label = this.cur_btn.transform:Find("H_Label").gameObject
		local s_label = this.cur_btn.transform:Find("S_Label").gameObject
		h_label.gameObject:SetActive(true)
		s_label.gameObject:SetActive(false)
	end 
	for k,v in pairs(this.funs) do
		v.content:SetActive(false)
	end
	this.funs[tpe].content:SetActive(true)
	-- this.funs[tpe].btn:SetActive(true)
	local btn = this.funs[tpe].btn
	this.cur_btn = btn ;
	DealerPanel.sel_fun.transform.localPosition = btn.transform.localPosition
	local h_label = btn.transform:Find("H_Label").gameObject
	local s_label = btn.transform:Find("S_Label").gameObject
	h_label.gameObject:SetActive(false)
	s_label.gameObject:SetActive(true)

	this.update(tpe)
end

--功能函数
function this.update(tpe)
	if tpe == INX_FUN_INFO then
		local info = mgr_dealer:get_info()
		-- panel.LabelInvate.text = info.
		DealerPanel.LabelInvate.text = ("%s(%s级代理)"):format(info.invite_code,info.level)
		-- DealerPanel.LabelAllChouShui.text = info.all_profit
		DealerPanel.LabelDownDealerNum.text = info.dealer_num
		DealerPanel.LabelDownUserNum.text = info.user_num

		local data = this.Get_Info_Data()
		if data then 
			DealerPanel.update_info(data)
		end 

	elseif tpe == INX_FUN_SETTING then
	elseif tpe == INX_FUN_LIST then
		global._view:showLoading()
		if this.dealer_player_list then 
			for k,obj in pairs (this.dealer_player_list)do 
				panelMgr:ClearPrefab(obj)
			end 
			this.dealer_player_list = nil 
		end 
		local ls = mgr_dealer:get_data_users()
		-- local ls = DealerPanel.get_data_users()
		if #ls == 0 then
			DealerPanel.update_list(1,1000)
		else
			local start=(this.cur_page-1) * USER_LIST_MAX
			if #ls > start then
				this.update_list(start)
			else
				DealerPanel.update_list(start,1000)
			end
		end
		global._view:hideLoading()
	elseif tpe == INX_FUN_TWO then
		DealerPanel.sprite_Lv3_label:SetActive(true)

		local data = this.Get_LV2_Data()
		if data then 
			this.Update_LV_list(nil,data)
		end 
	elseif tpe == INX_FUN_THREE then
		DealerPanel.sprite_Lv3_label:SetActive(false)
		local data = this.Get_LV3_Data()
		if data then 
			this.Update_LV_list(nil,data)
		end 
	end
	-- body
end
function this.update_list(startindex)
	local data = mgr_dealer:get_data_users()
	if not startindex then
		startindex = (this.cur_page-1) * USER_LIST_MAX
	end
	local parent = DealerPanel.dealer_list.transform
    local bundle = resMgr:LoadBundle("DealerBar")
    local Prefab = resMgr:LoadBundleAsset(bundle,"DealerBar");

    local len = USER_LIST_MAX
    local width,height = 0,48
	local i = 0
	DealerPanel.detail:SetActive(false)
	this.cur_click_label_obj = nil 
    -- local count = USER_LIST_MAX
    for index,v in ipairs(data) do
    	if index >= startindex then
    		local go = GameObject.Instantiate(Prefab)
    		i = i + 1
			-- if i == 1 then
			-- 	local bc = go:GetComponent("BoxCollider2D")
			-- 	width = bc.size.x
			-- 	height = bc.size.y
			-- end
			-- print("···sss",go.transform:Find("LabelName"):GetComponent("UILabel"))
			local player_name = GameData.GetShortName(v.player_name,10,10)
			local name_label = go.transform:Find("LabelName"):GetComponent("UILabel")
			name_label.text = player_name
			local ID_label = go.transform:Find("LabelID"):GetComponent("UILabel")
			ID_label.text = v.playerid
			local online_label = go.transform:Find("LabelOnline"):GetComponent("UILabel")
			online_label.text = v.online == 0 and i18n.TID_DEALER_NOT_ONLINE or i18n.TID_DEALER_ONLINE
			local lab = go.transform:Find("LabelCoin")
			-- print("···122",go.transform.position.x,go.transform.position.y)
			lab:GetComponent("UILabel").text = "查看详情"

			go.name = "DealerBar"..i;
			go.transform.parent = parent;
			go.transform.localScale = Vector3.one;
			go.transform.localPosition = Vector3(-85,  -height*(i - 1)+140, 0)
			this.beh:AddClick(lab.gameObject, function ( ... )
				player:req_query_info(3,v.playerid,function ( info )
					if DealerPanel.ui then
						DealerPanel.detail_LabelID.text = "ID:"..v.playerid
						DealerPanel.detail_LabelGold.text = "金币:"..info.RMB
						DealerPanel.detail_LabelSilver.text = "银币:"..info.money
						DealerPanel.detail:SetActive(true)
						local y = Input.mousePosition.y - 330
						-- DealerPanel.detail.transform.localPosition = Vector3(505,go.transform.localPosition.y+10, 0)
						DealerPanel.detail.transform.localPosition =  Vector3(505,y+10, 0)
					end
					this.On_Label_Click(go)

				end)

			end);
			if not this.dealer_player_list then 
				this.dealer_player_list = {}
			end 
			table.insert(this.dealer_player_list,go)
    	end

		-- if count~=0 and i >= count then
		-- 	break
		-- end

    end
end

function this.Update_LV_list(startindex,data_list)
	if not startindex then
		startindex = (this.cur_page-1) * USER_LIST_MAX
	end
	if this.dealer_LV_list then 
		for k,obj in pairs (this.dealer_LV_list)do 
			panelMgr:ClearPrefab(obj)
		end 
		this.dealer_LV_list = nil 
	end 
	local parent = DealerPanel.dealer_LV_list
	local bundle = resMgr:LoadBundle("DealerBar_LV")
	local prefab = resMgr:LoadBundleAsset(bundle,"DealerBar_LV")

	local i = 0;
	local space = 48

	for index,data in pairs(data_list)do
		if index >= startindex then 
			i= i +1 
			local go = GameObject.Instantiate(prefab)
			go.name = "DealerBar_LV"..i
			go.transform.parent = parent
			go.transform.localScale = Vector3.one
			go.transform.localPosition =Vector3(-85,-space*(i - 1)+140, 0)
			local id_label = go.transform:Find("LabelID"):GetComponent("UILabel")
			local time_label = go.transform:Find("LabelTime"):GetComponent("UILabel")
			local all_label = go.transform:Find("LabelAll"):GetComponent("UILabel")
			local self_label = go.transform:Find("LabelSelf"):GetComponent("UILabel")
			local lv_3_label = go.transform:Find("Label_LV_3"):GetComponent("UILabel")
			if data.id then 
				id_label.text = data.id
			else
				id_label.text = "-"
			end 
			if data.time then 
				time_label.text = data.time
			else
				time_label.text = "-"
			end 
			if data.all then 
				all_label.text = data.all
			else
				all_label.text = "-"
			end 
			if data.LV_self then 
				self_label.text = data.LV_self
			else
				self_label.text = "-"
			end 
			if data.LV_3 then 
				lv_3_label.text = data.LV_3
			else
				lv_3_label.text = ""
			end 
			if not this.dealer_LV_list then 
				this.dealer_LV_list = {}
			end 
			table.insert(this.dealer_LV_list,go)
		end 
	end 
end 

function this.OnClick(go)
	-- body
	local name = go.name
	if name == "BtnInfo" then
		this.sel(1)
	elseif name == "BtnSetting" then
		this.sel(2)
	elseif name == "BtnList" then
		this.sel(3)
	elseif name == "ButAdd" then

		local playerid = tonumber( DealerPanel.InputPlayerIDVal.value) or 0
		-- local rate = tonumber(DealerPanel.InputRateVal.value) or 0
		if not playerid or playerid == 0 then
			return
		end
		DealerPanel.ButtonAdd(playerid,rate)
	elseif name == "Btn_2" then
		this.sel(4)
	elseif name == "Btn_3" then
		this.sel(5)
	end
end
function this.On_Label_Click(go)
	local white = Color.white
	if this.cur_click_label_obj then 
		this.UpdateLabeInfoColor(this.cur_click_label_obj,white)
	end 
	local yellow = Color.yellow
	this.UpdateLabeInfoColor(go,yellow)
	this.cur_click_label_obj = go 
end 
this.info_data = nil --{info_1,info_2}

function this.Get_Info_Data()
	if not this.dealer_data then 
		return nil 
	end 
	if this.info_data then 
		return this.info_data
	end 
	--当前代理信息处理
	this.info_data ={
		info_1={},
		info_2={},
	}
	local data = this.dealer_data[this.playerid]
	for k,v in pairs (this.dealer_data)do 
		if k == this.playerid then 
			data = v 
		end 
	end 
	local bills_list = nil 
	for k,v in pairs(data)do 
		if k =="bills" then 
			bills_list = v 
		end 
	end 
	local index = 1
	for time,v in pairs(bills_list)do 
		local info = {}
		info.time_str = this.Deal_Time_Data(time)	
		
		local all = 0
		if v[1] then 
			info.LV_1 =this.precise_two(v[1])
			all = all + v[1]
		end 
		if v[2] then 
			info.LV_2 =this.precise_two(v[2])
			all = all + v[2]
		end 
		if v[3] then 
			info.LV_3 =this.precise_two(v[3]) 
			all = all + v[3]
		end 
		info.all =this.precise_two(all)
		if index ==1 then 
			this.info_data.info_1 = info
		elseif index == 2 then 
			this.info_data.info_2 = info
		end 
		index = index +1
	end 
	return this.info_data
end 
--二级代理信息处理
this.info_LV2_data = nil 
function this.Get_LV2_Data()
	if not this.dealer_data then 
		return nil 
	end 
	if this.info_LV2_data then 
		return this.info_LV2_data
	end 
	this.info_LV2_data = {}
	for id,data in pairs(this.dealer_data)do 
		local bills_list = nil 
		local level = nil 
		if data then 
			for k,value in pairs(data)do 
				if k =="bills" then 
					bills_list = value 
				end 
				if k == "level"then 
					level = value
				end 
			end 
			if level == 2 then 
				
				if bills_list then 
					for time,v in pairs(bills_list)do 
						local info = {}
						info.id = id 
						info.time = this.Deal_Time_Data(time)
						info.all = 0
						if v[2]then 
							info.LV_self = this.precise_two(v[2]) 
							info.all = info.all + v[2]
						end 
						if v[3] then 							
							info.LV_3 =this.precise_two(v[3]) 
							info.all = info.all + v[3]							
						end 
						info.all =this.precise_two(info.all) 
						table.insert(this.info_LV2_data,info)
					end 
					
				end 
			end 
		end 
	end 
	return this.info_LV2_data
end 
--三级代理信息处理
this.info_LV3_data = nil 
function this.Get_LV3_Data()
	if not this.dealer_data then 
		return nil 
	end 
	if this.info_LV3_data then 
		return this.info_LV3_data
	end 
	this.info_LV3_data = {}
	for id,data in pairs(this.dealer_data)do 
		local bills_list = nil
		local level = nil 
		if data then  
			for k,value in pairs(data)do 
				if k =="bills" then 
					bills_list = value 
				end 
				if k == "level"then 
					level = value
				end 
			end 
			if level == 3 then 
				
				if bills_list then 
					for time,v in pairs(bills_list)do 
						local info = {}
						info.id = id 
						info.time = this.Deal_Time_Data(time)
						info.all = 0 
						if v[3] then 
							info.LV_self =this.precise_two(v[3])
							info.all =this.precise_two(v[3])
						end 
						table.insert(this.info_LV3_data,info)
					end 
					
				end 
			end 
		end 
	end 
	return this.info_LV3_data
end 

function this.Deal_Time_Data(str)
	if not str then 
		return nil 
	end 
	local month_1 = string.sub(str,5,6)
	local day_1 = string.sub(str,7,8)
	local month_2=string.sub(str,14,15)
	local day_2 = string.sub(str,16,17)
	
	local text = "%s/%s-%s/%s"--月/日-月/日
	return string.format(text,month_1,day_1,month_2,day_2)
end 
--保留2位小数
function this.precise_two(num)
	if type(num) ~= "number"then 
		return num
	end 
	local str = "%0.2f"
	local ret = tonumber(string.format(str,num))
	return ret 
end 

function this.UpdateLabeInfoColor(go,color)
	if not go then 
		return
	end 
	if not color then 
		return
	end 
	local name_label = go.transform:Find("LabelName"):GetComponent("UILabel")
	local ID_label = go.transform:Find("LabelID"):GetComponent("UILabel")
	local online_label = go.transform:Find("LabelOnline"):GetComponent("UILabel")
	local lab = go.transform:Find("LabelCoin"):GetComponent("UILabel")
	name_label.color = color
	ID_label.color = color
	online_label.color = color
	lab.color = color

end 
return this