require "logic/ViewManager"
JoinRoomCtrl = {};
local this = JoinRoomCtrl;

--构建函数--
function this.New()
	return this;
end

this.state = 1 -- "1加入房间2绑定邀请"
this._gameID=nil--游戏ID
function this.Awake(state,gameID)
	this._gameID=gameID;
	this.state = state
	panelMgr:CreatePanel('JoinRoom', this.OnCreate);
end

--启动事件--
function this.OnCreate(obj)
	this.gameObject = obj;
	this.transform = obj.transform;
	this.beh= this.transform:GetComponent('LuaBehaviour');
	this.beh:AddClick(JoinRoomPanel.close, function ()
		JoinRoomPanel.clearView()
	end);
	this.beh:AddClick(JoinRoomPanel.delBtn, this.OnDelete);
	local allBtn = {JoinRoomPanel.oneBtn,JoinRoomPanel.twoBtn,JoinRoomPanel.threeBtn,
	JoinRoomPanel.fourBtn,JoinRoomPanel.fiveBtn,JoinRoomPanel.sixBtn,JoinRoomPanel.sevenBtn,
	JoinRoomPanel.eightBtn,JoinRoomPanel.nineBtn,JoinRoomPanel.tenBtn}
	for i=1,#allBtn do
		local obj = allBtn[i]
		this.beh:AddClick(obj, function ()
			local oldlen = string.len(this.roomId)
			if(oldlen >= 6) then
				return
			end
			if(i == 10) then
				i = 0
			end
			this.roomId = this.roomId .. i
			local len = string.len(this.roomId)
			if(len == 1) then
				JoinRoomPanel.oneTxt_UILabel.text = i
			elseif(len == 2) then
				JoinRoomPanel.twoTxt_UILabel.text = i
			elseif(len == 3) then
				JoinRoomPanel.threeTxt_UILabel.text = i
			elseif(len == 4) then
				JoinRoomPanel.fourTxt_UILabel.text = i
			elseif(len == 5) then
				JoinRoomPanel.fiveTxt_UILabel.text = i
			elseif(len == 6) then
				JoinRoomPanel.sixTxt_UILabel.text = i
				if(this.state == 1) then
					JoinRoomPanel.joinRoomPoto(this.roomId,this._gameID)
				else
					JoinRoomPanel.BindAccontPoto(this.roomId)
				end
			end
		end);
	end
	this.initTxt()
end

function this.OnDelete()
	local len = string.len(this.roomId)
	if(len == 1) then
		JoinRoomPanel.oneTxt_UILabel.text = ""
	elseif(len == 2) then
		JoinRoomPanel.twoTxt_UILabel.text = ""
	elseif(len == 3) then
		JoinRoomPanel.threeTxt_UILabel.text = ""
	elseif(len == 4) then
		JoinRoomPanel.fourTxt_UILabel.text = ""
	elseif(len == 5) then
		JoinRoomPanel.fiveTxt_UILabel.text = ""
	elseif(len == 6) then
		JoinRoomPanel.sixTxt_UILabel.text = ""
	end
	this.roomId = string.sub(this.roomId, 1, -2)
end

function this.initTxt()
	if(this.state == 1) then
		JoinRoomPanel.RoomTitle_UILabel.text = "请输入6位房间号"
	else
		JoinRoomPanel.RoomTitle_UILabel.text = "请输入6位邀请码"
	end
	this.roomId = ""
	JoinRoomPanel.oneTxt_UILabel.text = ""
	JoinRoomPanel.twoTxt_UILabel.text = ""
	JoinRoomPanel.threeTxt_UILabel.text = ""
	JoinRoomPanel.fourTxt_UILabel.text = ""
	JoinRoomPanel.fiveTxt_UILabel.text = ""
	JoinRoomPanel.sixTxt_UILabel.text = ""
end

function this.Close()
	this._gameID=nil;
	panelMgr:ClosePanel(CtrlNames.JoinRoom);
end

return this