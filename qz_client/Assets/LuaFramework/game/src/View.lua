require "logic/CtrlManager"
require "logic/ViewManager"
require "logic/CustomNotification"
local View = {};
View.viewList = {};
View.timeList = {};
View.noticeVec = "";
View.IsFrist = false;
local global = require("global")
-- 聊天背景音暂停开关
View.CAN_PAUSE = true
-- gamelobbypanel list offset
View.offset = 0
-- 启动游戏
function View:start ()
	self.IsFrist = false;
	self.noticeVec = "";
	-- self:login().Awake();
	global.login_mgr:set_login_game(true)
	global.login_mgr:lgm_login(true,function ( failed )
		-- print("···ppppp",failed)
		-- if not failed then
		-- 	global.login_mgr:lgm_login_game()
		-- end

	end)
	self:addPlayerPacth()
end

function View:returnToLogin()
	self.IsFrist = true;
	-- self:login().Awake();
	-- global.account_data:clear()

	--[[
		返回登录时一些全局文件需要重新load，才能初始化里面的一些模块
		如GameLobbyCtrl的mgr_dealer
	]]
	self:unloaded_ctrl()

	global.login_mgr:lgm_login(true,function ( failed )

	end)
end

-- lua文件重新load,
function View:unloaded_ctrl()
	local ui_names = {
		"GameLobby",
		"Room",
		"Niuniu",
		"Dealer",
		"Bank"
	}
	for i,v in ipairs(ui_names) do
		local name = v
		CtrlManager.RemoveCtrl(name)
		package.loaded["controller."..name.."Ctrl"] = nil
		-- self:Remove_viewList(name)
		package.loaded["view.".. name .. "Panel"] = nil
	end
end

------------------------------------------------------------------
--
--    time
--
------------------------------------------------------------------

-- 时间
function View:timeEvent()
	self:renderTime();
	-- self:viewStateEvent();
	if (Input.GetKeyDown(KeyCode.Escape)) then
		self:support().Awake("您确定要退出游戏吗？",function ()
       		Application.Quit();
		   end,function ()

       	end);
    end
    self:InvokeTime();
end

View._invokeList = {}
-- 延迟执行
function View:Invoke(time, func)
    local data = {};
    data.Time = time;
    data.Func = func;
    table.insert(self._invokeList, data);
end

function View:InvokeTime()
	local len = #self._invokeList;
	for i = len, 1, -1 do
		local data = self._invokeList[i];
		if (data.Time <= 0) then
			if (data.Func ~= nil) then
		    	data.Func();
			end
			table.remove(self._invokeList, i);
		else
			data.Time = data.Time - Time.deltaTime;
		end
	end
end

function View:ClearInvoke()
	self._invokeList = {}
end 


-- 添加时间
function View:addTimeEvent(sign, func)
	self:canceTimeEvent(sign);
	local data = {};
	data.Sign = sign;
	data.Func = func;
	data.UserTime = 0;
	data.UserNum = 0;

	table.insert(self.timeList, data);
end

-- 删除时间
function View:canceTimeEvent(sign)
	local len = #self.timeList;
	if (len <= 0) then
		return;
	end

	for i = len, 1, -1 do
		local data = self.timeList[i];
		if (data.Sign == sign) then
			table.remove(self.timeList, i);
			return;
		end
	end
end

-- 时间
function View:renderTime ()
	local len = #self.timeList;
	if (len <= 0) then
		return;
	end

	for i = len, 1, -1 do
		if (self.timeList == nil) then
			return;
		end
		local data = self.timeList[i];
		if (data == nil) then
			return;
		end
		if (data.Func == nil) then
			error("错误 renderTime:" .. data.Sign);
			return;
		end
		data.Func();
	end
end

function View:updatePlayerData()
	CustomNotification:excuteNotification("View","updateResourceValue")
end

function View:addPlayerPacth()
	CustomNotification:addNotification("View","updateResourceValue",function ()
        if(self:getViewBase("GameLobby") ~= nil) then
        	self:getViewBase("GameLobby").updatePlayerInfo()
		end
		-- if(self:getViewBase("YaoLeZi") ~= nil) then
        -- 	self:getViewBase("YaoLeZi").updatePlayerInfo()
		-- end
		if(self:getViewBase("Niuniu") ~= nil) then
        	self:getViewBase("Niuniu").updatePlayerInfo()
		end
		-- if(self:getViewBase("ShierzhiRoom") ~= nil) then
        -- 	self:getViewBase("ShierzhiRoom").updatePlayerInfo()
		-- end
		if(self:getViewBase("GameScore") ~= nil) then
        	self:getViewBase("GameScore").updatePlayerInfo()
		end
    end)
end
------------------------------------------------------------------
--
--    界面管理
--
------------------------------------------------------------------

-- 登录界面
function View:login ()
	local uiSign = CtrlNames.Login;
	return self:getView(uiSign);
end

function View:gamelobby ()
	local uiSign = CtrlNames.GameLobby;
	return self:getView(uiSign);
end

function View:niuniu ()
	local uiSign = CtrlNames.Niuniu;
	return self:getView(uiSign);
end
function View:Shierzhi(	)
	local uisign=CtrlNames.Shierzhi;
	return self:getView(uisign);
end
function View:room ()
	local uiSign = CtrlNames.Room;
	return self:getView(uiSign);
end
function View:ShierzhiRoom ()
	local uiSign = CtrlNames.ShierzhiRoom;
	return self:getView(uiSign);
end
function View:dealer( ... )
	return self:getView(CtrlNames.Dealer);
end

function View:bank(  )
	return self:getView(CtrlNames.Bank);
end

function View:test()
	return self:getView(CtrlNames.Test);
end

function View:loading()
	return self:getView(CtrlNames.Loading);
end

function View:rule()
	return self:getView(CtrlNames.Rule);
end

function View:playerList()
	return self:getView(CtrlNames.PlayerList);
end

function View:setting()
	return self:getView(CtrlNames.Setting);
end

function View:joinroom()
	return self:getView(CtrlNames.JoinRoom);
end

function View:tip()
	return self:getView(CtrlNames.Tip);
end

function View:support()
	return self:getView(CtrlNames.Support);
end

function View:gameScore()
	return self:getView(CtrlNames.GameScore);
end

function View:sendInvitation()
	return self:getView(CtrlNames.SendInvitation);
end

function View:paiGow()
	return self:getView(CtrlNames.PaiGow);
end

function View:chat()
	return self:getView(CtrlNames.Chat);
end

function View:SetRoom()
	return self:getView(CtrlNames.SetRoom)
end

function View:YaoLeZi()
    return self:getView(CtrlNames.YaoLeZi)
end

function View:sanshui()
    return self:getView(CtrlNames.Sanshui)
end

function View:majiang()
    return self:getView(CtrlNames.MaJiang)
end

function View:mail()
    return self:getView(CtrlNames.Mail)
end

function View:shop()
    return self:getView(CtrlNames.Shop)
end

function View:people()
    return self:getView(CtrlNames.People)
end

function View:customer()
	return self:getView(CtrlNames.Customer)
end

function View:notice()
	return self:getView(CtrlNames.Notice)
end

function View:history()
	return self:getView(CtrlNames.History)
end
-- 相机层级
View.ViewLayerNum =
{
  Default = 0,
  UI = 1,
  UI1 = 2,
  UI2 = 3,
  UI3 = 4,
  UI4 = 5,
  ItemSupport = 10,
  TIP = 11,
  SYSTEMTIP = 12,
  TEST = 13,
}

View.CameraLayerNum =
{
  Default = 0,
  UI = 5,
}

-- 显示层级
View.ViewLayer =
{
    CtrlNames.Login, "UI",
    CtrlNames.GameLobby, "UI",
    CtrlNames.Niuniu, "UI",
    CtrlNames.Room, "UI",
    CtrlNames.Dealer, "UI1",
    CtrlNames.Bank, "UI1",
	CtrlNames.PlayerList,"UI1",
    CtrlNames.Rule, "UI1",
    CtrlNames.Setting,"UI1",
    CtrlNames.JoinRoom, "UI1",
    CtrlNames.GameScore, "UI",
    CtrlNames.SendInvitation,"UI1",
    CtrlNames.Tip,"TIP",
    CtrlNames.Loading, "SYSTEMTIP",
    CtrlNames.Support, "ItemSupport",
	CtrlNames.ShierzhiRoom,"UI",
	CtrlNames.PaiGow,"UI",
	CtrlNames.Chat,"UI2",
	CtrlNames.SetRoom,"UI1",
	CtrlNames.YaoLeZi,"UI",
	CtrlNames.Sanshui,"UI",
	CtrlNames.Test, "TEST",
	CtrlNames.MaJiang,"UI",
	CtrlNames.Mail, "UI1",
	CtrlNames.Shop, "UI1",
	CtrlNames.People,"UI2",
	CtrlNames.Customer,"UI1",
	CtrlNames.Notice,"UI4",
	CtrlNames.History,"UI1",
}

-- 获取需要添加的层级
function View:getAddLayerInfo(sign)
	local len = #self.ViewLayer;
	for i = 1, len, 2 do
		local uiSign = self.ViewLayer[i];
		if (uiSign == sign) then
	      local layerInfo = {};
		    layerInfo.layerSign = self.ViewLayer[i + 1];
			 return layerInfo.layerSign;
		end
	end
	return "";
end

function View:changeLayerAll(sign)
   self._loadShow = false
   self:hideOtherUI(sign)
   local layer = self:getAddLayerInfo(sign);
   local scorName = self:changeCamera(layer);

   local cameraLayer = ""
   if (scorName == "Default") then
      cameraLayer =  self.CameraLayerNum.Default;
   else
      cameraLayer =  self.CameraLayerNum.UI;
   end

   local index = self.ViewLayerNum[layer];
   local pz = 0 - index;
   panelMgr:renderLayerAll(sign, pz, scorName, cameraLayer);
end

function View:changeCamera(layer)
   local scorName = "";
   if (layer == "Default") then
       scorName = "Default";
   else
       scorName = "UI";
   end
   return scorName;
end

-- 共存的面板
View.CoexistData =
{
  Dealer = {CtrlNames.GameLobby},
  Bank = {CtrlNames.GameLobby,CtrlNames.Room,CtrlNames.ShierzhiRoom,CtrlNames.Chat,CtrlNames.YaoLeZi,CtrlNames.MaJiang},
  Rule = {CtrlNames.Room,CtrlNames.ShierzhiRoom,CtrlNames.Chat,CtrlNames.YaoLeZi,CtrlNames.MaJiang},
  Setting = {CtrlNames.GameLobby,CtrlNames.MaJiang},
  JoinRoom = {CtrlNames.Niuniu,CtrlNames.GameLobby},
  SendInvitation = {CtrlNames.GameLobby},
  PlayerList={CtrlNames.Room,CtrlNames.ShierzhiRoom,CtrlNames.Chat,CtrlNames.YaoLeZi},
  Chat = {CtrlNames.PaiGow,CtrlNames.ShierzhiRoom,CtrlNames.YaoLeZi,CtrlNames.Sanshui},
  SetRoom={CtrlNames.Niuniu},
  Test = {CtrlNames.GameLobby,CtrlNames.Room,CtrlNames.ShierzhiRoom,CtrlNames.Chat,CtrlNames.YaoLeZi},
  Mail = {CtrlNames.GameLobby},
  Shop = {CtrlNames.GameLobby},
  People = {CtrlNames.GameLobby,CtrlNames.Shop},
  Customer = {CtrlNames.GameLobby},
  History = {CtrlNames.ShierzhiRoom,CtrlNames.Chat},

}

function View:showNotice()
	local notice = self:getViewBase("Notice")
	if(notice == nil) then
		self:notice().Awake();
	else
		notice.playNoticeInfo()
	end
end

function View:showLoading()
	-- if (self.viewList["Loading"] ~= nil) then
	-- 	return;
	-- end
	local load = self:getViewBase("Loading")
	if(load == nil) then
		self:loading().Awake();
	else
		load.resertTime()
	end
end

function View:hideLoading()
	table.foreach(self.viewList,
		function (key, data)
			if (data ~= nil and key == "Loading") then
				if(data.viewBase ~= nil and data.viewBase.ui ~= nil) then
					-- self.viewList[key] = nil;
					data.viewBase.clearView()
					-- data.viewBase.ui = nil
				end
			end
		end)
end

function View:changeOtherView(sign)
	table.foreach(self.viewList,
		function (key, data)
			if (key ~= sign and data ~= nil and data.viewBase ~= nil) then
				data.viewBase.IsClear = true;
			end
		end)
end

function View:coxistInit(sign)
	local closeList = self.CoexistData[sign];
	if (closeList == nil or #closeList == 0) then
		self:changeOtherView(sign)
	    return;
	end

	local len = #closeList;
	for i = 1, len do
		local saveSign = closeList[i];
		if (saveSign ~= sign) then
	        local uiTable = self.viewList[saveSign];
			if (uiTable ~= nil) then
	          uiTable.viewBase.IsClear = false;
	        end
	    end
	end
end

-- function View:IsCoxist(key)
-- 	local closeList = self.CoexistData[self._finalSign];
-- 	if(closeList ~= nil) then
-- 		local len = #closeList;
-- 		for i = 1, len do
-- 		    local saveSign = closeList[i];
-- 		    if (saveSign == key) then
-- 		        return false
-- 		    end
-- 		end
-- 	end
-- 	return true
-- end

function View:hideOtherUI(sign)
	if(sign == "Loading" or sign == "Tip" or sign == "Support" or sign == "Notice") then
		return
	end
	table.foreach(self.viewList,
		function (key, data)
			if (data ~= nil and key ~= sign and key ~= "Tip" and key ~= "Loading" and key ~= "Support" and key ~= "Notice") then
				if data.viewBase ~= nil and data.viewBase.ui ~= nil and data.viewBase.IsClear and self._finalSign ~= key then
					-- print(self._finalSign,"key",key);
					self.viewList[key] = nil;
					data.viewBase.OnDestroy()
					data.viewBase.ui = nil
					self:clearCoxistUI(key)
				end
			end
		end)
end

function View:clearCoxistUI(sign)
	local closeList = self.CoexistData[sign];
	if (closeList == nil or #closeList == 0) then
	    return;
	end
	local len = #closeList;
	for i = 1, len do
		local saveSign = closeList[i];
	    if (saveSign ~= sign and self._finalSign ~= saveSign) then
	        local uiTable = self.viewList[saveSign];
	        if (uiTable ~= nil and uiTable.viewBase.ui ~= nil) then
	        	self.viewList[saveSign] = nil;
	          	uiTable.viewBase.IsClear = true;
	          	uiTable.viewBase.OnDestroy()
				uiTable.viewBase.ui = nil
	        end
	    end
	end
end

function View:clearFormulateUI(sign) --清除制定UI
	table.foreach(self.viewList,
		function (key, data)
			if (data ~= nil and key == sign) then
				if(data.viewBase ~= nil and data.viewBase.ui ~= nil) then
					self.viewList[key] = nil;
					data.viewBase.IsClear = true
					data.viewBase.OnDestroy()
					data.viewBase.ui = nil
				end
			end
		end)
end

-- function View:closeOtherUI(sign)
-- 	table.foreach(self.viewList,
-- 		function (key, data)
-- 			if (data ~= nil and key ~= sign) then
-- 				if(data.viewBase ~= nil and data.viewBase.ui ~= nil and data.viewBase.IsClear) then
-- 					self:clearView(key)
-- 					-- data.viewBase.OnDestroy()
-- 					-- data.viewBase.ui = nil
-- 				end
-- 			end
-- 		end)
-- end
function View:IsLoadShow(sign)

end

View._loadShow = false
View._finalSign = "";
View._viewIndex = 0;
-- 实例化
function View:getView(sign)
	if(self._loadShow) then
		return CtrlCopy
	end
	if(sign ~= "Loading" and sign ~= "Tip" and sign ~= "Support" and sign ~= "Notice") then
		self:coxistInit(sign)
	else
		self._loadShow = true
	end
	-- self:closeOtherUI(sign)
	CtrlManager.InitObj(sign)
	if (self.viewList[sign] == nil) then
		local path = "view.".. sign .. "Panel";
	    local tb = require(path);
		local data = {};
		data.viewBase = tb;
		data.viewBase.IsClear = true;
		data.ClearTime = -1;
		self.viewList[sign] = data;
	-- else
	-- 	self.viewList[sign].ClearTime = -1;
	end
	local ctrl = CtrlManager.GetCtrl(sign);
	self.viewList[sign].viewBase.ui = ctrl;
	self._finalSign = sign;
	return ctrl;
end

function View:PlayBGSound(gameID)
	local clip = nil
	if gameID == global.const.GAME_ID_12ZHI then
		clip = global.const.BG_MUSIC_12ZHI
	elseif gameID == global.const.GAME_ID_NIUNIU then
		clip = global.const.BG_MUSIC_NIUNIU
	elseif gameID == global.const.GAME_ID_PAIGOW then
		clip = global.const.BG_MUSIC_PAIGOW
	elseif gameID == global.const.GAME_ID_YAOLEZI then
		clip = global.const.BG_MUSIC_YAOLEZI
	elseif gameID == global.const.GAME_ID_WATER then
		clip = global.const.BG_MUSIC_SANSHUI
	elseif gameID == global.const.GAME_ID_MJ then
		clip = global.const.BG_MUSIC_MJ
	end
	if clip then
		soundMgr:PlayBackSound(clip)
	end
end

function View:getViewBase(sign)
	if(self.viewList[sign] ~= nil and self.viewList[sign].viewBase ~= nil) then
		local viewBase = self.viewList[sign].viewBase
		if(self.viewList[sign].viewBase.ui ~= nil) then
			return viewBase
		end
	elseif(sign == "Tip") then
		self:tip().Awake("");
		return self.viewList[sign].viewBase
	end
	return nil
end

View._hasClearView = false;



function View:Remove_viewList(sign)
	self.viewList[sign] = nil
end
-- 清除View;
-- function View:clearView(sign)
-- 	if (self.viewList[sign] == nil) then
-- 		return;
-- 	end

-- 	local data = self.viewList[sign];
-- 	data.ClearTime = 1;
-- end

-- function View:viewStateEvent()
-- 	table.foreach(self.viewList,
-- 		function (key, data)
-- 			if (data ~= nil and data.ClearTime > 0) then
-- 				data.ClearTime = data.ClearTime - Time.deltaTime;
-- 				if (data.ClearTime <= 0 and data.ClearTime ~= -1) then
-- 	                self.viewList[key] = nil;
-- 	                if(data.viewBase ~= nil and data.viewBase.ui ~= nil and data.viewBase.IsClear) then
-- 						data.viewBase.OnDestroy()
-- 						data.viewBase.ui = nil
-- 					end
-- 				end
-- 			end
-- 		end)
-- end

CtrlCopy = {}
function CtrlCopy.Awake()
end

return View;
