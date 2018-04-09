--
-- Author: wangshaopei
-- Date: 2017-12-07 19:06:49
--
--
require "logic/ViewManager"
local global = require("global")
local player = global.player

TestCtrl = {};
local this = TestCtrl;

--构建函数--
function this.New()
	return this;
end

function this.Awake()
	panelMgr:CreatePanel('Test', this.OnCreate);
end

--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	-- this.panel = this.transform:GetComponent('UIPanel');

	this.beh = this.transform:GetComponent('LuaBehaviour');

	this.beh:AddClick(TestPanel.Container, this.OnClick);

	this.beh:AddClick(TestPanel.btn_test1, this.OnTest1);

end


function this.Close()
	panelMgr:ClosePanel(CtrlNames.Test);
end


function this.OnClick()
	TestPanel.clearView()
end

function this.OnTest1()
	print("···pppppppp")
end

return this