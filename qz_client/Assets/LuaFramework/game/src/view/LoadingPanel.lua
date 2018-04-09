local global = require("global")

LoadingPanel = {};
local this = LoadingPanel;
LoadingPanel.gameObject = nil;
--启动事件--
function LoadingPanel.Awake(obj)
	this.gameObject = obj;
	this.timeEvent()
	global._view:changeLayerAll("Loading")--必加
	this.cril = obj.transform:Find("cril").gameObject;
end

function LoadingPanel.timeEvent()
    global._view:addTimeEvent(this.gameObject.name,function()
    	if(this.ui ~= nil) then
    		this.ui.timeEvent()
    	end
    end)
end

function LoadingPanel.clearView()
	this.cril:SetActive(false)
	-- global._view:clearFormulateUI("Loading")
end

function LoadingPanel.resertTime()
	if(this.ui ~= nil) then
		this.ui.time = 0
		this.cril:SetActive(true)
	end
end

function LoadingPanel.OnDestroy()
	global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
end

return LoadingPanel