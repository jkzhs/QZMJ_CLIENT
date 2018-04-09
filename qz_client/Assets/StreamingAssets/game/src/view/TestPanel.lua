--
-- Author: wangshaopei
-- Date: 2017-12-07 19:03:32
--
local global = require("global")
local transform;
TestPanel = {};
local this = TestPanel;
TestPanel.gameObject = nil;
--启动事件--
function this.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	global._view:changeLayerAll("Test")--必加
end

--初始化面板--
function this.InitPanel()
	this.Container = transform:Find("Container").gameObject

	this.btn_test1 = transform:Find("btn_test1").gameObject

end


function this.OnDestroy()
	this.ui.Close()
end

function this.update_data()
	if(this.ui ~= nil) then
		this.ui.update_data()
	end
end

function this.clearView()
	global._view:clearFormulateUI("Test")
end

return TestPanel