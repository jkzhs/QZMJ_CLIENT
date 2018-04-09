require "logic/ViewManager"
SupportCtrl = {};
local this = SupportCtrl;
SupportCtrl.Support = nil;
--构建函数--
function SupportCtrl.New()
	return this;
end

function SupportCtrl.Awake(text,sure,cancle)
	if(this.Support ~= nil) then
		SupportPanel.gameObject:SetActive(true)
		this.ChangeState(cancle)
		this.Support:AddClick(SupportPanel.Ok, function ()
			SupportPanel.clearView()
			if(sure) then
				sure();
			end
		end);
		-- this.Support:AddClick(SupportPanel.Cancel, function ()
		-- 	SupportPanel.clearView()
		-- 	if(cancle) then
		-- 		cancle();
		-- 	end
		-- end);
		SupportPanel.text_UILabel.text = text;
	else
		panelMgr:CreatePanel('Support', function (obj)
			this.Support = obj.transform:GetComponent('LuaBehaviour');
			this.ChangeState(cancle)
			this.Support:AddClick(SupportPanel.Ok, function ()
				SupportPanel.clearView()
				if(sure) then
					sure();
				end
			end);
			
			SupportPanel.text_UILabel.text = text;
		end);
	end
	
end

function SupportCtrl.ChangeState(cancle)
	if(cancle == nil) then
		SupportPanel.Cancel.gameObject:SetActive(false)
		SupportPanel.Ok.transform.localPosition = Vector3(0, -72, 0);
	else
		SupportPanel.Cancel.gameObject:SetActive(true)
		SupportPanel.Ok.transform.localPosition = Vector3(142, -72, 0);
		this.Support:AddClick(SupportPanel.Cancel, function ()
			SupportPanel.clearView()
			if(cancle) then
				cancle();
			end
		end);
	end
end

--关闭事件--
function SupportCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Support);
end

return SupportCtrl