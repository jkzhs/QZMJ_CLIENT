--{STRIP}
local t = {
	-- 网络错误
	["TID_NETWORK_ERROR_400"] = "请求错误",--"Bad Request",
	["TID_NETWORK_ERROR_401"] = "#{SG000374}",--"Unauthorized",
	["TID_NETWORK_ERROR_403"] = "#{SG000375}",--"Forbidden or Index Expired",
	["TID_NETWORK_ERROR_406"] = "#{SG000376}",
	["TID_NETWORK_ERROR_407"] = "#{SG000377}",
	["TID_NETWORK_ERROR_404"] = "#{SG000378}",--"User Not Found",
	["TID_NETWORK_ERROR_408"] = "#{SG000379}",
	["TID_NETWORK_ERROR_410"] = "#{SG000380}",
	["TID_NETWORK_ERROR_500"] = "#{SG000381}",
	["TID_NETWORK_ERROR_502"] = "#{SG000382}",
	["TID_NETWORK_ERROR_600"] = "#{SG000383}",
	["NETWORK_ERROR_700"] = "#{SG000384}",
	["NETWORK_ERROR_701"] = "#{SG000385}",
	["TID_NETWORK_ERROR_GUEST"] = "禁止游客登陆",
	["TID_NETWORK_ERROR_10000"] = "#{SG000386}",
	["TID_NETWORK_ERROR_100001"] = "#{SG000387}",
	["TID_NETWORK_ERROR_UNKNOW"] = "#{SG000388}",
	["TID_LOGIN_ERROR_3RD"] = "#{SG000389}",
	["TID_LOGIN_ERROR_3RD_BACK"] = "#{SG000390}",
	["TID_ERROR_MODIYF_ATTR"] = "#{SG000391}",

	["ERROR_UNKNOW"] = "#{SG000392}",

	["ERROR_DOWNLOAD_CFG"] = "#{SG000393}",
	["ERROR_DOWNLOAD_CFG_CONNECT"] = "#{SG000394}",
	["ERROR_DECODE_CFG"] = "#{SG000395}",
	["ERROR_DOWNLOAD_SERVERLIST"] = "#{SG000396}",

	["ERROR_LOGIN_UNKONWERROR"] = "#{SG000397}",
	["ERROR_PACKLIST_UNKONWERROR"] = "#{SG000398}",
	["ERROR_SERVERLIST_UNKONWERROR"] = "#{SG000399}",

	--
	["TID_ERROR_KICK_ACOUNT_LOGIN"] = "#{SG000400}",
	["TID_ERROR_KICK_SERVER_MAINTENANCE"]="#{SG000401}",
	["TID_ERROR_POP_UP_AUTO_DISCONNECTED"]="#{SG000402}",
	["TID_ERROR_POP_UP_SERVER_MAINTENANCE"]="#{SG000403}",

	["TID_ERROR_UPDATE_DOWNLOAD"]= "#{SG000411}",
	["TID_ERROR_SERVER_UNKONW"]= "#{SG000412}",

	["TID_UPDATE_DOWLOADING_DESC"]= "#{SG000413}",
	["TID_UPDATE_DOWLOADING"]= "#{SG000414}",
	["TID_UPDATE_COMPLETE"]= "#{SG000415}",
	["TID_UPDATE_CLEARING"]= "#{SG000416}",
	["TID_UPDATE_CLEAR_OK"]= "#{SG000417}",

	["TID_ERROR_BATTLE_ERROR"] = "#{SG000418}",

	-- 银行
	["TID_COIN_GLOD"] = "亚通金币不足",
	["TID_COIN_SILVER"] = "亚通银币不足",
	["TID_BANK_TRAN_SUCCEE"] = "成功",
	["TID_COIN_TICKET"] = "房卡不足",

	-- 代理
	["TID_DEALER_ONLINE"] = "在线",
	["TID_DEALER_NOT_ONLINE"] = "离线",

	-- 充值
	["TID_CHARGE_OK_DESC"] = "获得亚通金币%s",
	["CHARGE_TIME_DESC"]="您的账号于%s充值%d元宝\n是否立即领取至当前角色%s",
	["TID_TEXT_TIME"]="%Y月%m日",


	-- 通用字符
	["TID_COMMON_LEVEL"] = "Lv.%d",
	["TID_COMMON_1e"] = "#{SG000862}",
	["TID_COMMON_1w"] = "#{SG000863}",
	["TID_COMMON_1k"] = "#{SG000864}",
	["TID_COMMON_MONEY"]="#{_MONEY_%s}",
	["TID_COMMON_RMB"]="#{_RMB_%d}",
	["TID_COMMON_NOT_OPERATE_SELF"]="不能对自己操作",
	["TID_COMMON_OP_SUCCEE"] = "操作成功",

	["TID_COMMON_BACK_GAME"]="您确定要退出房间游戏吗？",
	["TID_COMMON_STATISTC_DATA"]="数据统计中...",
	["TID_COMMON_GIVEUP_BANKER"]="您确定是否放弃坐庄？",

	-- 抢庄提示信息
	["TID_BANKER_INFO"] = "提示：庄家最低携带%s分以上才能抢庄,玩家能设置最高不能超过%s分。",
	["TID_SHENZHI_INFO"] = "[FEFFBF]提示：最低携带[F60404]%s[FEFFBF]分以上才能申请放支，"..
	"玩家设置最高不能超过[F60404]%s[FEFFBF],申请放支成功后设置的金额将被冻结，一轮结束后返还。",

	--12支
	["TID_12ZHI_CHAT_INFO"] = "在%s位置下注%s分",
	--麻将
	["TID_MJ_NOT_STATR_INFO"] = "游戏还未开始无法进行托管",
	--setRoom
	["TID_SETROOM_INPUTMONEY_MIN_INFO"] = "设置的金额最少不能小于%s",

}

return t
