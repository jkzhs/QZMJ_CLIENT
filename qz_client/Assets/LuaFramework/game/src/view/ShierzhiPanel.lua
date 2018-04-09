local global = require("global")
local transform;
local mgr_room = global.player:get_mgr("room")
local const = global.const
ShierzhiPanel = {};
local this = ShierzhiPanel;
ShierzhiPanel.gameObject = nil;
--启动事件--
function ShierzhiPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("Shierzhi")--必加
end

--初始化面板--
function ShierzhiPanel.InitPanel()
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
end

function ShierzhiPanel.openGame()
	global._view:showLoading();
	mgr_room:create(const.GAME_ID_12ZHI,function (data)
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					global._view:room().Awake(data.roomid,false,"")
				else
					global._view:hideLoading();
				end
			end
		end
	end)
	
	
end

function ShierzhiPanel.getHeadUrl()
	return global.player:get_headimgurl()
end

function ShierzhiPanel.get_RMB()
	return global.player:get_RMB()
end

function ShierzhiPanel.get_money()
	return global.player:get_money()
end

function ShierzhiPanel.JoinRoom()
	global._view:joinroom().Awake(1)
end

function ShierzhiPanel.backLobby()
	global._view:gamelobby().Awake()
end

function ShierzhiPanel.memberSort(list)
	table.sort(list,function (a,b)
        return a.roomid > b.roomid
    end)
    return list
end

function ShierzhiPanel.gameScore()
	global._view:showLoading();
	mgr_room:req_get_hall_list(const.GAME_ID_12ZHI,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			global._view:gameScore().Awake(list)
		end
	end)
end

function ShierzhiPanel.OnDestroy()
	this.ui.Close()
end

return ShierzhiPanel