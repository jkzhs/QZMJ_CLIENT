require "logic/ViewManager"
local global = require("global")
local player = global.player
local const = global.const
NoticeCtrl = {};
local this = NoticeCtrl;

--构建函数--
function NoticeCtrl.New()
	return this;
end

function NoticeCtrl.Awake()
	panelMgr:CreatePanel('Notice', this.OnCreate);
end

--启动事件--
function NoticeCtrl.OnCreate(obj)
	this.loadNoticeInfo()
end

function NoticeCtrl:timeEvent()
	this:TextMove();
end

NoticeCtrl.isAnim = false
NoticeCtrl.notice_width = 0;
function NoticeCtrl:TextMove()
	if (this.isAnim == true) then
		local px = NoticePanel.noticeInfo.transform.localPosition.x;
		if (px > (-245 - this.notice_width)) then
			px = px - Time.deltaTime*30;
			NoticePanel.noticeInfo.transform.localPosition = Vector3(px,0,0);
			if (px <= (-245 - this.notice_width)) then
				this.isAnim = false
				NoticePanel.noticeInfo.transform.localPosition = Vector3(245,0,0);
				this:loadNoticeInfo();
			end
		end
	end
end

function NoticeCtrl.loadNoticeInfo()
	if (this.isAnim) then
		return
	end
	local text = NoticePanel.getNoticeInfo()
	if (text ~= "") then
		NoticePanel.noticeInfo_UILabel.text = text
		this.notice_width = NoticePanel.noticeInfo_UILabel.printedSize.x + 20
		this.isAnim = true;
	else
		this.isAnim = false;
		this.notice_width = 0
		NoticePanel.clearView()
	end
end

--关闭事件--
function NoticeCtrl.Close()
	this.isAnim = false
	panelMgr:ClosePanel(CtrlNames.Notice);
end

return NoticeCtrl