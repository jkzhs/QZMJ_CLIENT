--
-- Author: wangshaopei
-- Date: 2017-08-07 11:14:53
--
local global = require("global")
local mgr_dealer = global.player:get_mgr("dealer")

local transform;
DealerPanel = {};
local this = DealerPanel;
DealerPanel.gameObject = nil;

--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("Dealer")--必加
end

--初始化面板--
function this.InitPanel()
	this.dealer_user_list = transform:Find("dealer_list").gameObject

	this.dealer_list = transform:Find("dealer_list/dealer_list").gameObject
	this.detail = transform:Find("dealer_list/detail").gameObject
	this.detail_LabelID = transform:Find("dealer_list/detail/LabelID"):GetComponent("UILabel")
	this.detail_LabelGold = transform:Find("dealer_list/detail/LabelGold"):GetComponent("UILabel")
	this.detail_LabelSilver = transform:Find("dealer_list/detail/LabelSilver"):GetComponent("UILabel")
	this.dealer_info = transform:Find("dealer_info").gameObject
	this.dealer_info_bg_2 = this.dealer_info.transform:Find("DataInfo/bg_2")

	this.info_time_label_1 = this.dealer_info_bg_2:Find("Time_label_1"):GetComponent("UILabel")
	this.info_time_label_2 = this.dealer_info_bg_2:Find("Time_label_2"):GetComponent("UILabel")
	this.info_all_label_1 = this.dealer_info_bg_2:Find("All_label_1"):GetComponent("UILabel")
	this.info_all_label_2 = this.dealer_info_bg_2:Find("All_label_2"):GetComponent("UILabel")
	this.info_LV_1_label_1 = this.dealer_info_bg_2:Find("LV_1_label_1"):GetComponent("UILabel")
	this.info_LV_1_label_2 = this.dealer_info_bg_2:Find("LV_1_label_2"):GetComponent("UILabel")
	this.info_LV_2_label_1 = this.dealer_info_bg_2:Find("LV_2_label_1"):GetComponent("UILabel")
	this.info_LV_2_label_2 = this.dealer_info_bg_2:Find("LV_2_label_2"):GetComponent("UILabel")
	this.info_LV_3_label_1 = this.dealer_info_bg_2:Find("LV_3_label_1"):GetComponent("UILabel")
	this.info_LV_3_label_2 = this.dealer_info_bg_2:Find("LV_3_label_2"):GetComponent("UILabel")

	this.dealer_lv = transform:Find("dealer_lv").gameObject
	this.dealer_LV_list = transform:Find("dealer_lv/dealer_list")	
	this.sprite_Lv3_label = this.dealer_lv.transform:Find("SpriteLV_3").gameObject

	this.dealer_setting = transform:Find("dealer_setting").gameObject
	this.sel_fun = transform:Find("sel_fun").gameObject
	this.ButClose = transform:Find("ButClose").gameObject
	this.BtnSetting = transform:Find("BtnSetting").gameObject
	-- print("···3333",this.BtnSetting)
	this.BtnInfo = transform:Find("BtnInfo").gameObject
	this.BtnList = transform:Find("BtnList").gameObject

	this.btn_lv_2 = transform:Find("Btn_2").gameObject
	this.btn_lv_3 = transform:Find("Btn_3").gameObject

	-- 信息
	this.LabelInvate = this.dealer_info.transform:Find("LabelInvate"):GetComponent('UILabel')
	-- this.LabelAllChouShui = this.dealer_info.transform:Find("LabelAllChouShui"):GetComponent('UILabel')
	-- this.LabelDayChouShui = this.dealer_info.transform:Find("LabelDayChouShui"):GetComponent('UILabel')
	this.LabelDownUserNum = this.dealer_info.transform:Find("LabelDownUserNum"):GetComponent('UILabel')
	this.LabelDownDealerNum = this.dealer_info.transform:Find("LabelDownDealerNum"):GetComponent('UILabel')

	-- this.SpriteDayChouShui = this.dealer_info.transform:Find("SpriteDayChouShui").gameObject
	-- this.SpriteDayChouShui:SetActive(false)
	-- this.dealer_info.transform:Find("LabelDayChouShui").gameObject:SetActive(false)

 
	


	-- 设置
	this.ButAdd = this.dealer_setting.transform:Find("content/ButAdd").gameObject
	this.InputPlayerIDVal = this.dealer_setting.transform:Find("content/InputPlayerIDVal/input"):GetComponent('UIInput')

	this.InputRateVal = this.dealer_setting.transform:Find("content/InputRateVal/input"):GetComponent('UIInput')
	-- mgr_dealer:req("req_dealer_bills",function ()
	-- 	dumpall(mgr_dealer:get_bills()) 
	-- end)

end

function this.req_dealer_bills()
	global._view:showLoading()
	mgr_dealer:req("req_dealer_bills",function ()
		local data =  mgr_dealer:get_bills()	
		-- dumpall(data)
		global._view:hideLoading()
		if this.ui~= nil then 
			this.ui.Start(data)	
		end 
	end)
end 

function this.clearView()
	global._view:clearFormulateUI("Dealer")
end

function this.OnDestroy()
	this.ui.Close()
end

function this.ButtonAdd( playerid,rate )
	mgr_dealer:req("req_add_dealer",playerid,rate,function ()
		local data = mgr_dealer:get_data()
		-- dump(data)
	end)
end

function this.update_list(start,count)
	mgr_dealer:req("req_dealer_users",start,count,function ()
		local data = mgr_dealer:get_data_users()
		if this.ui then
			this.ui.update_list()
		end

	end)
end
--[[
	info = {info_1,info_2}
	info_1= {time,all,LV_1,LV_2,LV_3}
]]
function this.update_info(info)

	local data = info.info_1
	if data.time_str then 
		this.info_time_label_1.text = data.time_str
	else 
		this.info_time_label_1.text = "-"
	end 
	if data.all then 
		this.info_all_label_1.text = data.all
	else 
		this.info_all_label_1.text = "-"
	end 
	if data.LV_1 then 
		this.info_LV_1_label_1.text = data.LV_1 
	else 
		this.info_LV_1_label_1.text = "-"
	end 
	if data.LV_2 then 
		this.info_LV_2_label_1.text = data.LV_2 
	else 
		this.info_LV_2_label_1.text = "-"
	end  
	if data.LV_3 then 
		this.info_LV_3_label_1.text = data.LV_3 
	else 
		this.info_LV_3_label_1.text = "-"
	end

	data = info.info_2
	if data.time_str then 
		this.info_time_label_2.text = data.time_str 
	else 
		this.info_time_label_2.text = "-"
	end 
	if data.all then 
		this.info_all_label_2.text = data.all
	else 
		this.info_all_label_2.text = "-"
	end 
	if data.LV_1 then 
		this.info_LV_1_label_2.text = data.LV_1 
	else 
		this.info_LV_1_label_2.text = "-"
	end 
	if data.LV_2 then 
		this.info_LV_2_label_2.text = data.LV_2 
	else 
		this.info_LV_2_label_2.text = "-"
	end  
	if data.LV_3 then 
		this.info_LV_3_label_2.text = data.LV_3 
	else 
		this.info_LV_3_label_2.text = "-"
	end
	
end 
function this.GetPlayerID()
	return global.player:get_playerid()
end 

-- function this.get_data_users()
-- 	global._view:showLoading()
-- 	local ls = mgr_dealer:get_data_users()
-- 	global._view:hideLoading()
-- 	return ls 
-- end 

return this