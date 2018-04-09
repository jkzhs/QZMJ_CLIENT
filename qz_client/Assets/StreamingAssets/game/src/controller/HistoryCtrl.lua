require "logic/ViewManager"
local global = require("global")
History = {};
local this = History;
local mt = this
local panel = nil 

local SPACE = 185 --TODO
local START_POS_X = 20
local START_POS_Y = 0

this._gameId = nil 
this.data = nil  --{title,time,item_list}
this.item_list = nil -- {obj}

--构建函数--
function mt.New()
	return this;
end

function mt.Awake(gameid,data)
	this._gameId = gameid
	this.data = data 
	panelMgr:CreatePanel("History", this.OnCreate);
end

--启动事件--
function mt.OnCreate(obj)
	panel = HistoryPanel
	this.gameObject = obj;
	this.transform = obj.transform;
	this.LB= this.transform:GetComponent('LuaBehaviour');
	this.LB:AddClick(panel.closeBtn,this.OnClose)
	this.RenderFunc()
end

--[[item_list={[1]={
	title_label=string ,
	contentLabel=string,
	content_sprite_name=string,
	content_sprite_label=string,
	result_label = string ,
	tip_label = string ,
	Image_name = string,
}
}]]
function mt.RenderFunc()
	if not this.data then 
		print("HISTorY_CTRL:NOT DATA")
		return 
	end 

	local data = this.data 
	if data.title then 
		panel.SetTitle(data.title)
	end 
	if data.time then 
		panel.SetTime(data.time)
	else
		panel.time.gameObject:SetActive(false)
	end 

	local bundle = resMgr:LoadBundle("HistoryItem")
	local prefab = resMgr:LoadBundleAsset(bundle,"HistoryItem")
	local parent = panel.item_list
	local list = data.item_list 

	local count = 0 
	for k,v in pairs(list)do
		count = count + 1 
		local go = GameObject.Instantiate(prefab)
		resMgr:addAltas(go.transform,"History")
		go.name = k 
		go.transform.parent = parent
		go.transform.localScale = Vector3.one
		local starPos = this.GetSatrtPos()
		go.transform.localPosition = Vector3(starPos.x,starPos.y-SPACE*(count-1),0)
		if not this.item_list then 
			this.item_list = {}
		end 
		table.insert(this.item_list,go)		
		 
		this.UpdateItme(v,go)
	end 
	local collider_sprite = panel.barcollider:GetComponent("UISprite")
	local height = SPACE*count + 24  
	if height > 374 then 
		collider_sprite.height = height
	else 
		collider_sprite.height = 374
	end 
end
--------------------------更新数据-----------------------
--[[data={
	title_label=string ,
	contentLabel=string,
	content_sprite_name=string,
	content_sprite_label=string,
	result_label = string ,
	tip_label = string ,
	Image_name = string,
}]]
function mt.UpdateItme(data,go)

	
	if data.title_label then 
		local title = go.transform:Find("TitleLabel"):GetComponent("UILabel")
		title.text = data.title_label
	else 
		title.text =""
	end

	if data.contentLabel then 
		local content_Label = go.transform:Find("ContentLabel"):GetComponent("UILabel")
		content_Label.text = data.contentLabel
	else 
		content_Label.text =""
	end 

	local obj = go.transform:Find("ContentSprite").gameObject
	if data.content_sprite_name then 		
		obj:SetActive(true)
		local content_sprite = obj:GetComponent("UISprite")
		content_sprite.spriteName = data.content_sprite_name
	end
	if data.content_sprite_label then 
		local label = obj.transform:Find("Label"):GetComponent("UILabel")
		label.text = data.content_sprite_label
	else 
		label.text =""
	end 

	if data.result_label then 
		local result_label = go.transform:Find("result_Label"):GetComponent("UILabel")
		result_label.text = data.result_label
	else 
		result_label.text =""
	end 

	if data.tip_label then 
		local tip_label = go.transform:Find("TipLabel"):GetComponent("UILabel")
		tip_label.text = data.tip_label
	else 
		tip_label.text =""
	end 

	if data.Image_name then 
		local Image = go.transform:Find("Image"):GetComponent("UISprite")
		Image.spriteName = data.Image_name
	end 	

end 
--------------------------获取数据-----------------------
function mt.GetSatrtPos()
	local data = {
		x = START_POS_X,
		y = START_POS_Y,
	}
	return data
end 

function mt.OnClose(go)
	panel.clearView()
end 

function mt.Close()
	-- this.clearRuleList()
	panelMgr:ClosePanel(CtrlNames.History);
end

return History