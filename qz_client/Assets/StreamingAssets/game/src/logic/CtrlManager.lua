require "logic/ViewManager"

CtrlManager = {};
local this = CtrlManager;
local ctrlList = {};	--控制器列表--

function CtrlManager.InitObj(sign)
	if (ctrlList[sign] == nil) then
		local ctrl = sign .. "Ctrl";
		local tb = require("controller.".. ctrl);
		print("ctrl",ctrl);
		ctrlList[sign] = tb.New();
	end
	return this;
end

--添加控制器--
function CtrlManager.AddCtrl(ctrlName, ctrlObj)
	ctrlList[ctrlName] = ctrlObj;
end

--获取控制器--
function CtrlManager.GetCtrl(ctrlName)
	return ctrlList[ctrlName];
end

--移除控制器--
function CtrlManager.RemoveCtrl(ctrlName)
	ctrlList[ctrlName] = nil;
end

--关闭控制器--
function CtrlManager.Close()
	print('CtrlManager.Close---->>>');
end