--
-- Author: Albus
-- Date: 2016-03-01 14:42:01
-- Filename: errcode_desc.lua
--

local code = require "sys.error_code"

return {
	[code.ERROR_OK] = {
		-- ok = true,
		-- tid = "TID_NETWORK_ERROR",
		-- desc = "\230\136\144\229\138\159"
	},

	[code.NETWORK_ERROR_400] = {desc = "TID_NETWORK_ERROR_400"},
	[code.NETWORK_ERROR_401] = {desc = "TID_NETWORK_ERROR_401"},
	[code.ERROR_AUTH_FAILED] = {desc = "TID_NETWORK_ERROR_403"}, --Unauthorized
	[code.NETWORK_ERROR_404] = {desc = "TID_NETWORK_ERROR_404"}, --Unauthorized
	[code.NETWORK_ERROR_406] = {desc = "TID_NETWORK_ERROR_406"},
	[code.NETWORK_ERROR_407] = {desc = "TID_NETWORK_ERROR_407"},
	[code.ERROR_OVER_LIMIT] = {desc = "TID_NETWORK_ERROR_408"}, --人数已达上限
	[code.ERROR_SERVER_IS_CLOSE] = {desc = "TID_NETWORK_ERROR_502"}, --服务器已经关闭
	[code.ERROR_SERVER_NOT_OPEN] = {desc = "TID_NETWORK_ERROR_410"}, --服务器未开启提示
	[code.NETWORK_ERROR_500] = {desc = "TID_NETWORK_ERROR_500"},
	[code.NETWORK_ERROR_502] = {desc = "TID_NETWORK_ERROR_502"},

	[code.NETWORK_ERROR_600] = {desc = "TID_NETWORK_ERROR_600"},
	[code.NETWORK_ERROR_601] = {desc = "TID_NETWORK_ERROR_601"},
	[code.NETWORK_ERROR_602] = {desc = "TID_NETWORK_ERROR_602"},
	[code.NETWORK_ERROR_603] = {desc = "TID_NETWORK_ERROR_603"},
	[code.NETWORK_ERROR_700] = {desc = "NETWORK_ERROR_700"},
	[code.NETWORK_ERROR_701] = {desc = "NETWORK_ERROR_701"},

	[code.NETWORK_ERROR_GUEST] = {desc = "TID_NETWORK_ERROR_GUEST"},


	[code.NETWORK_ERROR_10000] = {desc = "TID_NETWORK_ERROR_10000"},
	[code.NETWORK_ERROR_100001]	= {desc = "TID_NETWORK_ERROR_100001"},
	[code.NETWORK_ERROR_UNKNOW]	= {desc = "TID_NETWORK_ERROR_UNKNOW"},

	[code.ERROR_UNKNOW]	= {desc = "ERROR_UNKNOW"},

	--聊天
	-- [code.ERR_CHANNEL_ERR_CH_ID]	= {desc = "TID_NETWORK_ERROR_502"},	--聊天频道,错误的频道id
	-- [code.ERR_CHANNEL_CD]	= {desc = "TID_NETWORK_ERROR_502" },	--聊天cd中,你发言太频繁了
	[code.ERR_CHANNEL_PRIVATE_SELF]	= {	desc = "ERR_CHANNEL_PRIVATE_SELF"},	--不要和自己私聊吧
	-- [code.ERR_CHANNEL_TEXT_EMPTY] = {	desc = "TID_NETWORK_ERROR_502"}, --不能发表空的消息
	-- [code.ERR_CHANNEL_TEXT_TOO_LONG]	= {	desc = "TID_NETWORK_ERROR_502"}, --消息太长,一次最多只能发送60个字符
	-- [code.ERR_CHANNEL_NOTIN_GUILD]	= {	desc = "TID_NETWORK_ERROR_502" },	--你尚未加入帮派,无法在帮派频道发言
	[code.ERR_CHANNEL_NO_SPEAK_FOREVER]	= {	desc = "ERR_CHANNEL_NO_SPEAK_FOREVER"},	--永久禁言
	[code.ERR_CHANNEL_NO_SPEAK_TIME]	= {	desc = "ERR_CHANNEL_NO_SPEAK_TIME"},	--禁言时间
	[code.ERR_CHANNEL_BAN_CHAT]			= {	desc = "ERR_CHANNEL_BAN_CHAT"},	--禁言


	-- [code.CHAT_PERSON_NOT_EXIT]	= {	desc = "TID_NETWORK_ERROR_502" },  --对方不存在
	[code.CHAT_PERSON_NOT_ONLINE] = {desc = "CHAT_PERSON_NOT_ONLINE"},  --对方不在线
	-- [code.CHAT_GUILD_NOT_EXIT] = {desc = "TID_NETWORK_ERROR_502"},  --工会不存在
	[code.CHAT_PERSON_IN_BLACKLIST] = {desc = "CHAT_PERSON_IN_BLACKLIST"},  --对方在黑名单中不能发聊天信息

	[code.ERR_USER_MGR_OFFLINE] 			= {desc = "CHAT_PERSON_NOT_ONLINE"},  --对方不在线
	[code.ERR_USER_MGR_PLAYER_NOT_EXISTS] 	= {desc = "ERR_USER_MGR_PLAYER_NOT_EXISTS"},
	[code.ERR_USER_MGR_PLAYER_FRIEND_FULL] 	= {desc = "ERR_USER_MGR_PLAYER_FRIEND_FULL"},  --玩家好友已满
	[code.ERR_USER_MGR_MY_FRIEND_FULL] 		= {desc = "ERR_USER_MGR_MY_FRIEND_FULL"},  --我的好友列表好友已满
	[code.ERR_FRIEND_FULL] 					= {desc = "ERR_USER_MGR_MY_FRIEND_FULL"},
	[code.ERR_FRIEND_ALREADY_HAS] 			= {desc = "ERR_FRIEND_ALREADY_HAS"},
	[code.ERR_FRIEND_REQ_NOT_EXISTS] 		= {desc = "ERR_FRIEND_REQ_NOT_EXISTS"},
	[code.ERR_FRIEND_NOT_MY_FRIEND] 		= {desc = "ERR_FRIEND_NOT_MY_FRIEND"},
	[code.ERR_FRIEND_NOT_SELF] 				= {desc = "ERR_FRIEND_NOT_SELF"},
	[code.ERR_USER_MGR_PLAYER_BLACKLIST_FULL] = {desc = "ERR_USER_MGR_PLAYER_BLACKLIST_FULL"},
	[code.ERR_BLACKLIST_NOT_SELF] 			= {desc = "ERR_BLACKLIST_NOT_SELF"},
	[code.ERR_BLACKLIST_ALREADY_HAS] 		= {desc = "ERR_BLACKLIST_ALREADY_HAS"},
	[code.ERR_BLACKLIST_ALREADY_HAS_SELF] 		= {desc = "ERR_BLACKLIST_ALREADY_HAS_SELF"},

	-- 房间
	[code.ERROR_ROOM_ROOMD_NAME] 					=  {desc="ERROR_ROOM_ROOMD_NAME",CN="错误的房间服务名称"},
	[code.ERROR_CREATE_ROOM_ROOMD_FAILED] 			= {desc="ERROR_CREATE_ROOM_ROOMD_FAILED",CN="创建房间服务器失败"},
	[code.ERROR_PLAYER_ALREADY_ROOM] 				= {desc="ERROR_PLAYER_ALREADY_ROOM",CN="玩家已经在房间"} ,
	[code.ERROR_ROOM_NO_ROOMD]						= {desc="ERROR_ROOM_NO_ROOMD",CN="房间服务不存在"},
	[code.ERROR_ROOM_NO_USER]						= {desc="ERROR_ROOM_NO_USER",CN="房间内没有这个玩家"},
	[code.ERROR_ROOM_STATUS]						= {desc="ERROR_ROOM_STATUS",CN="房间状态错误"},
	[code.ERROR_ROOM_INVITE_ALREADY]				= {desc="ERROR_ROOM_INVITE_ALREADY",CN="房间邀请存在"},
	[code.ERROR_ROOM_BANKER_ALREADY] 				= {desc="ERROR_ROOM_BANKER_ALREADY",CN="庄家已被抢"},
	[code.ERROR_ROOM_BANKER_NOT_EXIST]				= {desc="ERROR_ROOM_BANKER_NOT_EXIST",CN="没有庄家"},
	[code.ERROR_ROOM_BANKER_DONT_BET]				= {desc="ERROR_ROOM_BANKER_DONT_BET",CN="庄家不能下注"},
	[code.ERROR_ROOM_PLAYER_NOT_NUM] 				= {desc="ERROR_ROOM_PLAYER_NOT_NUM",CN="房间人数不足"},
	[code.ERROR_ROOM_NO_BET_USER] 					= {desc="ERROR_ROOM_NO_BET_USER",CN="不是下注用户"},
	[code.ERROR_ROOM_NO_PUB_ROOM] 					= {dese="ERROR_ROOM_NO_PUB_ROOM",CN="您不是房主不能邀请"},
	[code.ERROR_ROOM_CREATE_OFTEN] 					= {dese="ERROR_ROOM_CREATE_OFTEN",CN="房间创建太过频繁，请5秒后重试"},
	[code.ERROR_ROOM_TICKET_NOT_ENOUGH] 			= {dese="ERROR_ROOM_TICKET_NOT_ENOUGH",CN="房卡不足"},
	[code.ERROR_ROOM_DO_BANKER_ALREADY] 			= {dese="ERROR_ROOM_DO_BANKER_ALREADY",CN="您还在其他房间坐庄中"},
	[code.ERROR_ROOM_USER_MAX_COIN] 				= {dese="ERROR_ROOM_USER_MAX_COIN",CN="玩家最高下注错误"},
	[code.ERROR_ROOM_TRAN_MONEY] 		        	= {dese="ERROR_ROOM_TRAN_MONEY",CN="人气未达最低上限"},
	[code.ERROR_ROOM_DO_BET_ALREADY] 				= {dese="ERROR_ROOM_DO_BET_ALREADY",CN="您还在其他房间内下注"},
	[code.ERROR_ROOM_GAMEID] 						= {dese="ERROR_ROOM_GAMEID",CN="游戏ID不匹配"},
	[code.ERROR_ROOM_MAX_USER_LIMIT] 				= {dese="ERROR_ROOM_MAX_USER_LIMIT",CN="房间人数已达最大"},

	-- 牛牛
	[code.ERROR_ROB_BANKER_COIN_MIN_LIMIT]		= {desc="ERROR_ROB_BANKER_COIN_MIN_LIMIT",CN="抢庄最低亚通币不足"},
	[code.ERROR_OX_NEXT_BOUNT_OP] 				= {desc="ERROR_OX_NEXT_BOUNT_OP",CN="下局才操作"},
	[code.ERROR_OX_CARD_SHOW_ALREADY]			= {desc="ERROR_OX_CARD_SHOW_ALREADY",CN="已经甩牌"},
	[code.ERROR_OX_IN_ALL_ALREADY]				= {desc="ERROR_OX_IN_ALL_ALREADY",CN="不能多次梭哈"},
	[code.ERROR_OX_USER_COIN_ALREADY_MAX] = {desc="ERROR_OX_USER_COIN_ALREADY_MAX",CN="下注不能超过最大上限"},
	[code.ERROR_OX_USER_LOST_COIN_MAX] = {desc="ERROR_OX_USER_LOST_COIN_MAX",CN="所需最大赔率本金不足"},
	[code.ERROR_OX_PLAYER_BET_NOT_NUM] = {desc="ERROR_OX_PLAYER_BET_NOT_NUM",CN="本局房间可下注人数不足"},

	-- 12支
	[code.ERROR_TWELVE_NOT_BANKER] = {desc="ERROR_TWELVE_NOT_BANKER",CN="您不是庄家"},
	[code.ERROR_TWELVE_POS_COIN_ALREADY_MAX] = {desc="ERROR_TWELVE_POS_COIN_ALREADY_MAX",CN="该位置下注以达最大上限"},

	-- 13水
	[code.ERROR_WATER_PLAYER_BET_MAX]      = {desc="ERROR_WATER_PLAYER_BET_MAX", CN="下注金额超过庄家承受的范围"},
	[code.ERROR_WATER_PLAYER_BET_MIN]      = {desc="ERROR_WATER_PLAYER_BET_MIN", CN="下注不能低于最小押注额"},
	[code.ERROR_WATER_PLAYER_TRIM]         = {desc="ERROR_WATER_PLAYER_TRIM", CN="卡牌类型设置有误，请重新上传"},
	[code.ERROR_WATER_PLAYER_BET_MAX2]     = {desc="ERROR_WATER_PLAYER_BET_MAX2", CN="下注金额超过承受的范围"},

	[code.ERROR_WATER_ROOM_LIMIT_MAX]      = {desc="ERROR_WATER_ROOM_LIMIT_MAX", CN="该房间超过人数的限制，不能加入"},
	[code.ERROR_WATER_ROOM_LIMIT_MIN]      = {desc="ERROR_WATER_ROOM_LIMIT_MIN", CN="该房间人数不足，不能开局"},
	[code.ERROR_WATER_ROOM_CARD1]          = {desc="ERROR_WATER_ROOM_CARD1", CN="该玩家未获得卡牌的数据"},
	[code.ERROR_WATER_ROOM_CARD2]          = {desc="ERROR_WATER_ROOM_CARD2", CN="该玩家的特殊牌型检查不通过"},
	[code.ERROR_WATER_ROOM_CARD3]          = {desc="ERROR_WATER_ROOM_CARD3", CN="该玩家的普通牌型检查不通过"},
	[code.ERROR_WATER_ROOM_CARD4]          = {desc="ERROR_WATER_ROOM_CARD4", CN="该玩家的卡牌数据有误"},
	[code.ERROR_WATER_ROOM_CARD5]          = {desc="ERROR_WATER_ROOM_CARD5", CN="卡牌的牌型倒水"},
	[code.ERROR_WATER_ROOM_CARD6]          = {desc="ERROR_WATER_ROOM_CARD6", CN="本局该玩家已理完牌"},
	[code.ERROR_WATER_ROOM_ENTER_LIMIT]    = {desc="ERROR_WATER_ROOM_ENTER_LIMIT", CN="你携带的金额不够"},
	[code.ERROR_WATER_ROOM_STATUS]         = {desc="ERROR_WATER_ROOM_STATUS", CN="房间状态不在理牌阶段出牌"},
	[code.ERROR_WATER_ROOM_TYPE]           = {desc="ERROR_WATER_ROOM_TYPE", CN="房间类型不对"},

	[code.ERROR_WATER_ROOM_STATUS]         = {desc="ERROR_WATER_ROOM_STATUS", CN="房间状态不在理牌阶段出牌"},
	[code.ERROR_WATER_MAX_PAYBET]          = {desc="ERROR_WATER_MAX_PAYBET", CN="自由模式下，玩家最大赔注金额不够"},
	[code.ERROR_WATER_MIN_PAYBET]          = {desc="ERROR_WATER_MIN_PAYBET", CN="自由模式下，玩家最小赔注金额不够"},
	[code.ERROR_WATER_TRIM_CARD1]          = {desc="ERROR_WATER_TRIM_CARD1", CN="玩家正理牌判断中"},
	[code.ERROR_WATER_TRIM_CARD2]          = {desc="ERROR_WATER_TRIM_CARD2", CN="玩家已经理牌完"},


	[code.ERROR_WATER_TRIM_CARD1]          = {desc="ERROR_WATER_TRIM_CARD1", CN="玩家正理牌判断中"},
	[code.ERROR_WATER_TRIM_CARD2]          = {desc="ERROR_WATER_TRIM_CARD2", CN="玩家已经理牌完"},

	[code.ERROR_WATER_POUR_NUM]            = {desc="ERROR_WATER_POUR_NUM", CN="该房间内的最少注数还没有设置"},
	[code.ERROR_WATER_POUR_COIN]           = {desc="ERROR_WATER_POUR_COIN", CN="该房间内的最少下注限量未设置"},
	[code.ERROR_WATER_MIN_BET_POUR]        = {desc="ERROR_WATER_MIN_BET_POUR", CN="该玩家未达到最少下注限制"},

	[code.ERROR_WATER_MAX_BET_POUR]        = {desc="ERROR_WATER_MAX_BET_POUR", CN="该玩家超过本房间最多下注限制"},
	[code.ERROR_WATER_ROB_MIN_COIN]        = {desc="ERROR_WATER_ROB_MIN_COIN", CN="该玩家的未达到该房间抢庄标准"},
	[code.ERROR_WATER_ROB_USE_COIN]        = {desc="ERROR_WATER_ROB_USE_COIN", CN="该玩家的抢庄的金币不足"},

	-- 摇乐子
	[code.ERROR_YAOLEZI_SHENZHI_ALREADY]		= {desc="ERROR_YAOLEZI_SHENZHI_ALREADY",CN="已经被申请放支成功"},
	[code.YAOLEZI_SHENZHI_COIN_MIN_LIMIT]       = {desc ="YAOLEZI_SHENZHI_COIN_MIN_LIMIT",CN="申请放支最低亚通币不足"},

	-- 麻将
	[code.ERROR_MJ_PLAYER_ID]                   = {desc ="ERROR_MJ_PLAYER_ID",CN="玩家ID不正确"},
	[code.ERROR_MJ_CARD_ID]                     = {desc ="ERROR_MJ_CARD_ID",CN="卡牌ID不正确"},
	[code.ERROR_MJ_HAVED_PLAY]                  = {desc ="ERROR_MJ_HAVED_PLAY",CN="玩家已经出过牌"},
	[code.ERROR_MJ_HAVED_ENTRUST]               = {desc ="ERROR_MJ_HAVED_ENTRUST",CN="已经成功设置过托管"},
	[code.ERROR_MJ_CANCEL_ENTRUST]              = {desc ="ERROR_MJ_CANCEL_ENTRUST",CN="已经取消托管"},
	[code.ERROR_MJ_HAVED_START]                 = {desc ="ERROR_MJ_HAVED_START",CN="游戏已经开始,请等待下一局"},
	[code.ERROR_MJ_ROOM_PLAY]                   = {desc ="ERROR_MJ_ROOM_PLAY",CN="正在进行麻将游戏中，请等待游戏结束"},
	[code.ERROR_MJ_HAVED_PREPARE]               = {desc ="ERROR_MJ_HAVED_START",CN="玩家已经是准备状态"},
	[code.ERROR_MJ_DONT_PREPARE]                = {desc ="ERROR_MJ_ROOM_PLAY",CN="玩家还未做准备"},
	[code.ERROR_MJ_OVER_LIMIT]                  = {desc ="ERROR_MJ_OVER_LIMIT",CN="房间内玩家人数已经达到上限"},

	-- 代理
	[code.ERROR_DEALER_NOT_EXIST]       = {desc ="ERROR_DEALER_NOT_EXIST",CN="没有这个代理"},
	[code.ERROR_DEALER_BAND_ALEADY]     = {desc ="ERROR_DEALER_BAND_ALEADY",CN="您已经绑定代理"},

	-- 支付
	[code.ERROR_PAY_FEE]       = {desc ="ERROR_PAY_FEE",CN="支付金额错误"},
	[code.ERROR_PAY_FAILED]    = {desc ="ERROR_PAY_FAILED",CN="发起充值请求失败"},

	-- 通用
	[code.ERROR_MAX_LEVEL] = {desc ="TID_ERROR_MAX_LEVEL"},--已达到最高级别
	[code.ERROR_VIGOUR_NOT_ENOUGH] = {desc ="TID_ERROR_VIGOUR_NOT_ENOUGH"},--军令不足
	[code.ERROR_RMB_NOT_ENOUGH]= {desc ="TID_ERROR_RMB_NOT_ENOUGH",CN="亚通金币不足"},
	[code.ERROR_MONEY_NOT_ENOUGH] = {desc ="TID_ERROR_MONEY_NOT_ENOUGH",CN="亚通银币不足"},
	[code.ERROR_COIN_NOT_ENOUGH] = {desc ="ERROR_COIN_NOT_ENOUGH",CN="亚通币不足"},
	[code.ERROR_COIN_VALUE] = {desc ="ERROR_COIN_VALUE",CN="亚通币值异常"},
	[code.ERROR_VIP_NOT_ENOUGH] = {desc ="TID_ERROR_VIP_NOT_ENOUGH"},--VIP等级不足
	[code.ERROR_POP_UP_ILLEGAL_OPERATION]={desc ="TID_ERROR_POP_UP_ILLEGAL_OPERATION"},--非法操作
	[code.ERROR_NOT_EXIST_USER]={desc ="TID_ERROR_NOT_EXIST_USER",CN="玩家不存在"},
	[code.ERROR_NOT_OPERATE_SELF]={desc ="TID_ERROR_NOT_OPERATE_SELF",CN="不能对自己操作"},
	[code.ERROR_PARAM]={desc ="TID_ERROR_PARAM",CN="错误的参数"},

}