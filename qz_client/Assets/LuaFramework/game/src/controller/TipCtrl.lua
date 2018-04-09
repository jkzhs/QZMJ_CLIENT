require "logic/ViewManager"
TipCtrl = {};
local this = TipCtrl;
--构建函数--
function TipCtrl.New()
	return this;
end

TipCtrl._text = ""
function TipCtrl.Awake(txt)
	panelMgr:CreatePanel('Tip', function ()
		if(TipPanel._tagerT ~= "") then
			txt = TipPanel._tagerT
		end
		this.updateTipInfo(txt)
	end);
end

function TipCtrl.updateTipInfo(txt)
	if(txt == "") then
		return
	end
	TipPanel.tipTxt_UILabel.text = txt
	local w = TipPanel.tipTxt_UILabel.width
	TipPanel.tipbg_UISprite.width = w + 140
	TipPanel.dialog_UIWidget.alpha = 0
	TipPanel.dialog.transform.localScale = Vector3(0,0,0);
    TipPanel.dialog_TweenAlpha:ResetToBeginning()
    TipPanel.dialog_TweenScale:ResetToBeginning()
    if(TipPanel.dialog_TweenAlpha.enabled == false) then
    	TipPanel.dialog_TweenAlpha.enabled = true
    end
    if(TipPanel.dialog_TweenScale.enabled == false) then
    	TipPanel.dialog_TweenScale.enabled = true
    end
end

--关闭事件--
function TipCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Tip);
end

return TipCtrl