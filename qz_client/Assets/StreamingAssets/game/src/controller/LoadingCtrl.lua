require "logic/ViewManager"
LoadingCtrl = {};
local this = LoadingCtrl;
--构建函数--
function LoadingCtrl.New()
	return this;
end

function LoadingCtrl.Awake()
	panelMgr:CreatePanel('Loading', function ()
		this.time = 0
	end);
end

LoadingCtrl.time = 0
function LoadingCtrl.timeEvent()
	if(this.time < 30) then
		this.time = this.time + Time.deltaTime
	else
		LoadingPanel.clearView()
	end
end

--关闭事件--
function LoadingCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Loading);
end

return LoadingCtrl