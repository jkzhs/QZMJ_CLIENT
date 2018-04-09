local global = require("global")
local transform;
NoticePanel = {};
local this = NoticePanel;
NoticePanel.gameObject = nil;
--启动事件--
function NoticePanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	this.timeEvent();
	global._view:changeLayerAll("Notice")--必加
end

function NoticePanel.timeEvent()
    global._view:addTimeEvent(this.gameObject.name,function()
    	this.ui.timeEvent()
    end)
end

--初始化面板--
function NoticePanel.InitPanel()
	this.noticeInfo = transform:Find('Context/noticeInfo').gameObject;
	this.noticeInfo_UILabel = this.noticeInfo:GetComponent('UILabel');
end

function NoticePanel.getNoticeInfo()
	return global._view.noticeVec;
end

function NoticePanel.playNoticeInfo()
	if(this.ui ~= nil) then
		this.ui.loadNoticeInfo()
	end
end

function NoticePanel.clearView()
	global._view:clearFormulateUI("Notice")
end

function NoticePanel.OnDestroy()
	global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close()
end

return NoticePanel