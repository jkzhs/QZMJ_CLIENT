local global = require("global")
local transform;
local mgr_room = global.player:get_mgr("room")
local mgr_niuniu = global.player:get_mgr("niuniu")
local const = global.const
RoomPanel = {};
local this = RoomPanel;
RoomPanel.gameObject = nil;
--启动事件--
function RoomPanel.Awake(obj)
	this.gameObject = obj;
	transform = obj.transform;
	-- this.timeEvent()
	this.InitPanel();
	global._view:changeLayerAll("Room")
	mgr_niuniu:nw_reg()
	this.getPlayerData()
end

-- function RoomPanel.timeEvent()
--     global._view:addTimeEvent(this.gameObject.name,function()
--     	this.ui.timeEvent()
--     end)
-- end

--初始化面板--
function RoomPanel.InitPanel()
	
	this.PlayBGSound(const.GAME_ID_NIUNIU)

	this.btnFilling = transform:Find("bottomRight/btnFilling").gameObject--加注
	this.btnFilling_UISprite = this.btnFilling:GetComponent('UISprite');
	this.btnDel = transform:Find("bottomRight/btnDel").gameObject
	this.btnDel_UISprite = this.btnDel:GetComponent('UISprite');
	this.betfive = transform:Find("bottomRight/money/betfive").gameObject;
	this.betfive_UISprite = this.betfive:GetComponent('UISprite');
	this.betten = transform:Find("bottomRight/money/betten").gameObject;
	this.betten_UISprite = this.betten:GetComponent('UISprite');
	this.bethund = transform:Find("bottomRight/money/bethund").gameObject;
	this.bethund_UISprite = this.bethund:GetComponent('UISprite');
	this.betkilo = transform:Find("bottomRight/money/betkilo").gameObject;
	this.betkilo_UISprite = this.betkilo:GetComponent('UISprite');
	this.bettenshou = transform:Find("bottomRight/money/bettenshou").gameObject;
	this.bettenshou_UISprite = this.bettenshou:GetComponent('UISprite');
	this.betmill = transform:Find("bottomRight/money/betmill").gameObject;
	this.betmill_UISprite = this.betmill:GetComponent('UISprite');
	this.betall = transform:Find("bottomRight/money/betall").gameObject;
	this.betall_UISprite = this.betall:GetComponent('UISprite');
	this.playlist = transform:Find("bottomleft/playlist").gameObject;
	this.chat = transform:Find("bottomleft/chat").gameObject;
	this.bank = transform:Find("bottomleft/bank").gameObject;
	this.share = transform:Find("bottomleft/share").gameObject;
	this.rule = transform:Find("bottomleft/rule").gameObject;
	this.back = transform:Find("bottomleft/back").gameObject;
	this.express = transform:Find("bottomleft/express").gameObject;
	this.backOut = transform:Find("bottomleft/backOut").gameObject;
	this.viedo = transform:Find("bottomleft/viedo").gameObject;
	-- this.viedo_MicroPhoneInput = this.viedo:GetComponent('MicroPhoneInput');
	this.viedo_VoiceChatPlayer = this.viedo:GetComponent('VoiceChatPlayer');
	this.invite = transform:Find("bottomleft/invite").gameObject;
	this.invite_UISprite = this.invite:GetComponent('UISprite');
	this.invitefabu = transform:Find("bottomleft/invite/invitefabu").gameObject;
	this.invitefabu_UISprite = this.invitefabu:GetComponent('UISprite');
	this.inviteyaoqing = transform:Find("bottomleft/invite/inviteyaoqing").gameObject;
	this.inviteyaoqing_UISprite = this.inviteyaoqing:GetComponent('UISprite');
	this.bankerName = transform:Find("upLeft/bankerName").gameObject;
	this.bankerName_UILabel = this.bankerName:GetComponent('UILabel');
	this.robHead = transform:Find("upLeft/HeadPanel/robHead").gameObject;
	this.robHead_AsyncImageDownload = this.robHead:GetComponent('AsyncImageDownload');
	this.roomId = transform:Find("upLeft/roomId").gameObject;
	this.roomId_UILabel = this.roomId:GetComponent('UILabel');
	this.rob = transform:Find("upLeft/rob").gameObject;
	this.rob_UISprite = this.rob:GetComponent('UISprite');
	this.robEffect = transform:Find("upLeft/rob/robEffect").gameObject;
	this.robBg = transform:Find("upLeft/robBg").gameObject;
	this.robBg_UISprite = this.robBg:GetComponent('UISprite');
	this.timeTxt = transform:Find("timebg/timeTxt").gameObject;
	this.timeTxt_UILabel = this.timeTxt:GetComponent('UILabel');
	this.BetState = transform:Find("timebg/BetState").gameObject;
	this.BetState_UILabel = this.BetState:GetComponent('UILabel');
	this.tiprob = transform:Find("timebg/tiprob").gameObject;
	this.cardPanel = transform:Find("cardPanel");
	this.cardback = transform:Find("cardPanel/cardback").gameObject;
	this.fiveCardNum = transform:Find("cardPanel/cardpoint/fiveCardNum").gameObject;
	this.fiveCardNum_UISprite = this.fiveCardNum:GetComponent('UISprite');
	this.finalCard = transform:Find("cardPanel/finalCard").gameObject;
	this.finalCard_TweenPosition = this.finalCard:GetComponent('TweenPosition')
	this.finalCard_TweenScale = this.finalCard:GetComponent('TweenScale')
	this.animicard = transform:Find("cardPanel/animicard").gameObject;
	this.cardEffect = transform:Find("cardPanel/cardEffect").gameObject;
	this.playcard = transform:Find("cardPanel/animicard/playcard").gameObject;
	this.cardIcon = transform:Find("cardPanel/animicard/cardanima/cardIcon").gameObject;
	this.cardIcon_UISprite = this.cardIcon:GetComponent('UISprite');
	this.cardImg = transform:Find("cardPanel/animicard/cardanima/cardIcon/cardImg").gameObject;
	this.cardImg_UISprite = this.cardImg:GetComponent('UISprite');
	this.cardLeft = transform:Find("cardPanel/animicard/cardanima/leftscale/cardLeft").gameObject;
	this.cardLeft_UISprite = this.cardLeft:GetComponent('UISprite');
	this.handleft2 = transform:Find("cardPanel/animicard/cardanima/leftscale/handleft2").gameObject;
	this.handleft2_UISprite = this.handleft2:GetComponent('UISprite');
	this.handleft3 = transform:Find("cardPanel/animicard/cardanima/leftscale/handleft3").gameObject;
	this.handleft3_UISprite = this.handleft3:GetComponent('UISprite');
	this.cardRight = transform:Find("cardPanel/animicard/cardanima/rightscale/cardRight").gameObject;
	this.cardRight_UISprite = this.cardRight:GetComponent('UISprite');
	this.handright2 = transform:Find("cardPanel/animicard/cardanima/rightscale/handright2").gameObject;
	this.handright2_UISprite = this.handright2:GetComponent('UISprite');
	this.handright3 = transform:Find("cardPanel/animicard/cardanima/rightscale/handright3").gameObject;
	this.handright3_UISprite = this.handright3:GetComponent('UISprite');
	this.handright4 = transform:Find("cardPanel/animicard/cardanima/rightscale/handright4").gameObject;
	this.handright4_UISprite = this.handright4:GetComponent('UISprite');
	this.playerPoint = transform:Find("cardPanel/playerPoint").gameObject;
	this.playerPoint_UILabel = this.playerPoint:GetComponent('UILabel');
	this.playerCoin = transform:Find("upRight/playerCoin").gameObject;
	this.playerCoin_UILabel = this.playerCoin:GetComponent('UILabel');
	this.playerName = transform:Find("upRight/playerName").gameObject;
	this.playerName_UILabel = this.playerName:GetComponent('UILabel');
	this.playerSilver = transform:Find("upRight/playerSilver").gameObject;
	this.playerSilver_UILabel = this.playerSilver:GetComponent('UILabel');
	this.PlayerIcon = transform:Find("upRight/PlayerIcon").gameObject;
	this.PlayerIcon_AsyncImageDownload = this.PlayerIcon:GetComponent('AsyncImageDownload');
	this.betNum = transform:Find("bottomRight/money/betNum").gameObject;
	this.betNum_UILabel = this.betNum:GetComponent('UILabel');
	this.Tips = transform:Find("Tips").gameObject;
	this.fristenter = transform:Find("Tips/fristenter").gameObject;
	this.BarCollider = transform:Find("upLeft/battle/battlelist/BarCollider").gameObject;
	this.BarCollider_UISprite = this.BarCollider:GetComponent('UISprite');
	this.battlelist = transform:Find("upLeft/battle/battlelist").gameObject;
	this.battlelist_UIScrollView = this.battlelist:GetComponent('UIScrollView');
	--this.playerList = transform:Find("playerList").gameObject;
	--this.allplayerInfo = transform:Find("playerList/allplayerInfo").gameObject;
	--this.closePlayer = transform:Find("playerList/closePlayer").gameObject;
	--this.playerNum = transform:Find("playerList/playerNum").gameObject;
	--this.playerNum_UILabel = this.playerNum:GetComponent('UILabel');
	--this.playerCollider = transform:Find("playerList/allplayerInfo/playerCollider").gameObject;
	--this.playerCollider_UISprite = this.playerCollider:GetComponent('UISprite');
	this.showUI = transform:Find("showUI").gameObject;
	this.uibox = transform:Find("showUI/uibox").gameObject;
	this.expression = transform:Find("showUI/expression").gameObject;
	this.expressionlist = transform:Find("showUI/expression/expressionlist").gameObject;
	this.saydialog = transform:Find("showUI/saydialog").gameObject;
	this.saylist = transform:Find("showUI/saydialog/saylist").gameObject;
	this.sayCollider = transform:Find("showUI/saydialog/saylist/sayCollider").gameObject;
	this.sayCollider_UISprite = this.sayCollider:GetComponent('UISprite');
	this.balanceEnter = transform:Find("showUI/balanceEnter").gameObject;
	this.balanceList = transform:Find("showUI/balanceEnter/balanceList").gameObject;
	this.balanceList_UIScrollView = this.balanceList:GetComponent('UIScrollView');
	this.balanceCollider = transform:Find("showUI/balanceEnter/balanceList/balanceCollider").gameObject;
	this.balanceCollider_UISprite = this.balanceCollider:GetComponent('UISprite');
	this.record = transform:Find("Tips/record").gameObject;
	this.recordProcess = transform:Find("Tips/record/recordProcess").gameObject;
	this.recordProcess_UISprite = this.recordProcess:GetComponent('UISprite');
	this.recard1 = transform:Find("Tips/record/recordcard/recard1").gameObject;
	this.recard2 = transform:Find("Tips/record/recordcard/recard2").gameObject;
	this.recard3 = transform:Find("Tips/record/recordcard/recard3").gameObject;
	this.recard4 = transform:Find("Tips/record/recordcard/recard4").gameObject;
end

RoomPanel.IsClickBack = false
function RoomPanel.backNiuniu(value)
	this.IsClickBack = value
	if(value) then
		mgr_room:exit(const.GAME_ID_NIUNIU,function ()
		end)
		this.gameScore()
	else
		global._view:niuniu().Awake(const.GAME_ID_NIUNIU);
	end
end

function RoomPanel.gameScore()
	global._view:showLoading();
	mgr_room:req_get_hall_list(const.GAME_ID_NIUNIU,function (list)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			global._view:gameScore().Awake(list,const.GAME_ID_NIUNIU)
		end
	end)
end

--获取数据
function RoomPanel.getPlayerData()
	mgr_niuniu:req_data(function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				this.ui.Init(data,const,0,false)
			else
				this.getPlayerData()
			end
		end
	end)
end

function RoomPanel.updatePlayerInfo()
	if(this.ui ~= nil) then
		this.ui.updatePlayerInfo()
	end
end

function RoomPanel.getPlayerCoin()
	return global.player:get_money()
end

function RoomPanel.getPlayerName()
	return global.player:get_name()
end

function RoomPanel.getPlayerId()
	return global.player:get_playerid()
end

function RoomPanel.getPlayerRMB()
	return global.player:get_RMB()
end

function RoomPanel.getPlayerImg()
	return global.player:get_headimgurl()
end

function RoomPanel.setRoomBtnState(data)
	if(this.ui ~= nil) then
		this.ui.updateBetState(data,data.liuju,data.daobang)
	end
end

function RoomPanel.updateBetInfo(info)
	if(this.ui ~= nil) then
		local allin = ""
		if(info.bet_type == 1) then
			allin = "【梭哈】"
		end
		local data={coin = 0,
				player_name = info.player_name,
				amount_money = 0,
				content = allin .. "下注:" .. info.coin .. "  总下注:" .. info.amount_money,
				url = info.url,
				viedo = false,
				viedoTime = 0,
				IsCard = nil,
				IsBank = "",
			}
		local who = 0
		if(info.amount_money > 100) then
			soundMgr:PlaySound("slot_win")
		end
		-- if(info.url == "" or info.url == nil) then
		-- 	who = 2
		-- end
		this.ui.addPlayerBetInfo(data,who);
	end
end

function RoomPanel.getTime()
	return global.ts_now;
end

--获取抢庄的信息
function RoomPanel.getRobInfo()
	global._view:showLoading();
	mgr_niuniu:req_rob_banker_info(function (data,ec)
		global._view:hideLoading();
		if(#data > 0 and this.ui ~= nil) then
			this.ui.robCallBack(data[1])
		else
			this.setTip(global.errcode_util:get_errcode_CN(ec))
		end
	end);
end

--抢庄
function RoomPanel.robData(coin)
	global._view:showLoading();
	mgr_niuniu:req_rob_banker(coin,function (data)
		global._view:hideLoading();
		if(data.errcode == 0) then
			if(this.ui ~= nil) then
				this.ui.closeShowUI()
				local d={coin = 0,
					player_name = this.getPlayerName(),
					amount_money = 0,
					content = "抢庄：闲家最高下注" .. coin .. " 梭哈最高下注" .. coin * 10,
					url = this.getPlayerImg(),
					viedo = false,
					viedoTime = 0,
					IsCard = nil,
					IsBank = "",
				}
				this.ui.addPlayerBetInfo(d,1)
			end
			-- this.setTip("抢庄成功")
		else
			local ec = data.errcode
			this.setTip(global.errcode_util:get_errcode_CN(ec))
		end
	end);
end

function RoomPanel.setTip(text)
	global._view:getViewBase("Tip").setTip(text)
end

--下注
function RoomPanel.betData(value,bet_type)
	global._view:showLoading();
	mgr_niuniu:req_bet(value,bet_type,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					local allin = ""
					if(bet_type == 1) then
						allin = "【梭哈】"
					end
					local info={coin = 0,
						player_name = this.getPlayerName(),
						amount_money = 0,
						content = allin .. "下注:" .. value .. "  总下注:" .. this.ui._totalBetCoin+value,
						url = this.getPlayerImg(),
						viedo = false,
						viedoTime = 0,
						IsCard = nil,
						IsBank = "",
					}
					if(this.ui._totalBetCoin+value > 100) then
						soundMgr:PlaySound("slot_win")
					end
					this.ui.addPlayerBetInfo(info,1);
					this.ui.BetFillCallBack(value)
					this.ui.updatePlayerInfo()
				else
					this.setTip(global.errcode_util:get_errcode_CN(succec))

				end
			end
		end
	end)
end

function RoomPanel.memberSort(list)
	table.sort(list,function (a,b)
        return a.RMB + a.money > b.RMB + b.money
    end)
    return list
end

function RoomPanel.getPlayerList()
	global._view:showLoading();
	mgr_niuniu:req_room_members(1,200,function (data)
		global._view:hideLoading();
		if(this.ui ~= nil) then
			if(data ~= nil) then
				local succec = data.errcode
				if(succec == 0) then
					local list = this.memberSort(data.members)
					this.ui.renderPlayer(list)
				else
					-- this.setTip("失败")
					local ec = data.errcode
					this.setTip(global.errcode_util:get_errcode_CN(ec))
				end
			end
		end
	end)
end

function RoomPanel.sendChat(msg,msgtype,voicetime)
	-- local s = "水电费水电费水电费"
	-- msg = Util.stringtobyte(s)
	-- msgtype = 1
	global.player:get_mgr("chat"):chat2room(msg,msgtype,voicetime)
end

function RoomPanel.getChatData(data,playerInfo)
	local name = playerInfo.from_name
	local Isviedo = false
	if(data.msgtype == 1) then
		Isviedo = true
	end
	local d={coin = 0,
		player_name = name,
		amount_money = 0,
		content = data.msg,
		url = playerInfo.from_headid,
		viedo = Isviedo,
		viedoTime = data.voice_time,
		IsCard = nil,
		IsBank = "",
	}

	local who = 0
	if(name == this.getPlayerName()) then
		who = 1
	end
	if(this.ui ~= nil) then
		this.ui.addPlayerBetInfo(d,who)
	end
end

function RoomPanel.SendCardData()
	mgr_niuniu:req_card_show()
end

function RoomPanel.Cardshow(id)
	if(this.ui ~= nil) then
		this.ui.CardShow(id)
	end
end

function RoomPanel.RobBroadcast(data)
	local name = data.player_name
	if(name == this.getPlayerName()) then
		return
	end
	local d={coin = 0,
		player_name = name,
		amount_money = 0,
		content = "抢庄：闲家最高下注" .. data.coin  .. " 梭哈最高下注" .. data.coin * 10,
		url = data.headimgurl,
		viedo = false,
		viedoTime = 0,
		IsCard = nil,
		IsBank = "",
	}
	if(this.ui ~= nil) then
		this.ui.addPlayerBetInfo(d,0)
	end
end

function RoomPanel.PlayBGSound(gameid)
	global._view:PlayBGSound(gameid)
end 

function RoomPanel.DropBanker()
	global._view:showLoading();
	mgr_niuniu:req_drop_banker(function (data)
		global._view:hideLoading();
		this.backOut:SetActive(false)
	end)
end

function RoomPanel.OnDestroy()
	-- global._view:canceTimeEvent(this.gameObject.name);
	this.ui.Close();
	this.IsClear = true;
	if(this.IsClickBack == false) then
		mgr_room:exit(const.GAME_ID_NIUNIU,function ()
		end)
	end
	mgr_niuniu:nw_unreg()
end


return RoomPanel