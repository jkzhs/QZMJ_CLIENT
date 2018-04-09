--cmd.lua
--[[
	client:所有cmd都为gated的包。

	name: 消息名，需跟pb一样。

	CS_XXXX	客户端发向服务端
	SC_XXXX	服务端发向客户端

	CSC_XXXX 客户端和服务端相互发(客户端发起)
	SCS_XXXX 客户端和服务端相互发(服务端发起)
]]

return {
	{1, "CSC_SysHeartBeat"},
	{2, "CS_Login"},
	{3, "SC_Login"},
	{4, "CS_AskInfo"},
	--------------------------------------------------------------------------
	-- hero
	{5, "SC_NewHero"},
	{6, "SC_AskHeros"},
	--------------------------------------------------------------------------
	-- 阵形
	{7, "SC_AskFormations"},
	{8, "CS_UpdateFormation"},
	{9, "SC_FormationResult"},
	--------------------------------------------------------------------------
	-- item
	{10, "SC_AskItemBag"},
	{11, "SC_NewItem"},
	{12, "CS_UseItem"},
	{13, "SC_UseItem"},
	-- 合成
	{14, "CS_Compound"},
	{15, "SC_Compound"},
	-- 强化装备
	{16, "CS_EquipEnhance"},
	{17, "SC_EquipEnhance"},
	{18, "SC_UpdateHeroEquip"},
	--------------------------------------------------------------------------
	{19, "SC_UpdateKeys"},
	--------------------------------------------------------------------------
	{20, "CS_Command"},
	{21, "SC_MSG"},
	--------------------------------------------------------------------------
	{22, "SC_DelHero"},
	--------------------------------------------------------------------------
	-- 关卡
	{23, "SC_AskStages"},
	{24, "SC_StageInfo"},
	-- 战斗
	{25, "CS_FightBegin"},
	{26, "SC_FightBegin"},
	{27, "CS_FightEnd"},
	{28, "SC_FightEnd"},
	--------------------------------------------------------------------------
	-- 任务
	{29, "SC_MissionList"},
	{30, "SC_FlushMission"},
	{31, "CS_MissionOP"},
	{32, "SC_MissionOP"},
	--------------------------------------------------------------------------
	-- 邮件
	{33, "SC_MailRet"},
	--------------------------------------------------------------------------
	{34, "CS_upgrade_star"},
	{35, "CS_upgrade_quality"},
	{36, "CS_upgrade_arms"},
	{37, "CS_upgrade_skill"},
	{38, "SC_upgrade_result"},
	-- 扫荡
	{39, "CS_cleanout"},
	{40, "SC_cleanout_result"},
	--------------------------------------------------------------------------
	-- 抽奖
	{41, "CS_Lottery"},
	{42, "SC_Lottery_result"},
	-- 酒馆数据
	{43, "SC_TavernInfo"},
	--------------------------------------------------------------------------
	-- 卖物品
	{44, "CS_Sell"},
	{45, "SC_Sell"},
	-- 买物品
	{46, "CS_Buy"},
	{47, "SC_Buy"},
	--------------------------------------------------------------------------
	-- 建筑
	--建筑信息
	{50, "SC_BuildInfo"},
	--升级建筑
	{51, "CS_upgrade_build"},
	{52, "SC_upgrade_build"},
	--征收
	{53, "CS_levy"},
	{54, "SC_levy"},
	-- 居民贡献
	{55, "CS_Minju"},
	{56, "SC_Minju"},
	{57, "SC_UpdateBuildInfo"},
	{58, "SC_FlushHeroAttr"},
	--------------------------------------------------------------------------
	{59, "SC_OFFLINE_NOTIFY"},
	--刷新小兵属性
	{60, "SC_FLUSH_ARMS_ATTRS"},
	--------------------------------------------------------------------------
	--聊天
	{61, "CS_CHAT"},
	{62, "SC_CHAT"},
	--创建角色
	{63, "CS_CREATE_ROLE"},
	{64, "SC_CREATE_ROLE"},
	--------------------------------------------------------------------------
	--CDKEY
	{65, "CS_GET_CDKEY"},
	{66, "SC_GET_CDKEY"},
	--------------------------------------------------------------------------
	--玩家技能
	{100, "SC_SkillInfo"},
	{101, "SC_PlayerSkills"},
	{102, "CS_UgradePlayerSkills"},
	{103, "CS_SetSkills"},
	{104, "SC_SetSkills"},
	--------------------------------------------------------------------------
	-- 武将副本（过关斩将）
	{ 120, "SC_AskHStages"},
	{ 121, "SC_HStageInfo"},
	{ 122, "CS_HBattle"},
	{ 123, "SC_HBattle"},
	--------------------------------------------------------------------------
	-- 商店
	{ 300, "SC_StoreList"},
	{ 301, "SC_FlushStore"},
	{ 302, "CS_FlushStore"},
	--------------------------------------------------------------------------
	-- 签到
	{ 310, "SC_SignInList"},
	{ 311, "SC_SignIn"},
	{ 312, "CS_SignIn"},
	--------------------------------------------------------------------------
	-- 引导
	{ 320, "SC_GuideList"},
	{ 321, "CS_Step"},
	{ 322, "SC_Step"},
	--------------------------------------------------------------------------
	-- 组合技能
	{ 330, "SC_GroupSkillList"},
	{ 331, "CS_GroupSkillOP"},
	{ 332, "SC_GroupSkillOP"},
	--------------------------------------------------------------------------
	--其他玩家信息
	{ 400, "CS_QueryPlayerinfo"},
	{ 401, "SC_QueryPlayerinfo"},
	--------------------------------------------------------------------------
	--时间事件
	{ 450, "SC_TIME_EVENT"},
	--系统开放
	{ 451, "SC_OPEN_SYSTEM"},
	--改基本属性
	{ 452, "CS_CHANGE_BASIC"},
	{ 453, "SC_CHANGE_BASIC"},
	--------------------------------------------------------------------------
	--竞技场
	{ 460, "CS_ASK_ATHLETIC"},
	{ 461, "SC_ASK_ATHLETIC"},
	{ 462, "SC_ATHLETIC_BASE"},
	{ 463, "CS_ATHLETIC_UPDATE_FORMATION"},
	{ 464, "SC_ATHLETIC_UPDATE_FORMATION"},
	{ 465, "SC_ATHLETIC_TOP"},
	{ 466, "SC_ATHLETIC_ENEMYS"},
	{ 467, "CS_ATHLETIC_CHALLENGE"},
	{ 468, "SC_ATHLETIC_CHALLENGE"},
	{ 469, "SC_ATHLETIC_REPORT"},
	--------------------------------------------------------------------------
	--活动
	{ 500, "SC_ACTIVITYLIST"},
	{ 501, "SC_FLUSHACTIVITY"},
	{ 502, "CS_ACTIVITYOP"},
	{ 503, "SC_ACTIVITYOP"},
	--------------------------------------------------------------------------
	--用来做通知处理
	{ 600, "SC_NOTIFY"},
	{ 601, "SC_EMPTY_MSG"},
	{ 602, "SC_NOTIFYCHARGERESP"},
	{ 603, "CS_WITHDRAW"},
	{ 604, "SC_CHARGE_INFO"},
	--------------------------------------------------------------------------
	--好友
	{ 1000, "CS_FRIEND_OP"},
	{ 1001, "SC_FRIEND_OP"},
	{ 1002, "SC_REQ_ADD_FRIEND"},
	{ 1003, "SC_FRIEND_LIST"},
	{ 1004, "SC_FRIEND_INFO"},

	--------------------------------------------------------------------------
	--在线奖励
	{ 1350, "SC_AskOnlineAward"},
	{ 1351, "CS_AskOnlineAward"},

	--------------------------------------------------------------------------
	--兵营训练
	{ 1400, "CS_TRAINING"},
	{ 1401, "SC_UPDATE_TRAINING"},
	--------------------------------------------------------------------------
	--排行榜
	{ 1402, "CS_ASK_LEADERBOARD"},
	{ 1403, "SC_LEADERBOARD"},
	--------------------------------------------------------------------------
	--活动副本
	{ 1404, "CS_WORLDSTAGE"},
	{ 1405, "SC_WORLDSTAGE"},
	{ 1406, "SC_WORLDSTAGE_INFO"},
	{ 1407, "SC_WORLDSTAGE_INFOS"},
	--世界boss
	{ 1408, "CS_WORLDBOSS"},
	{ 1409, "SC_WORLDBOSS_BASE"},
	{ 1410, "SC_WORLDBOSS_MSG"},
	--------------------------------------------------------------------------
	--装备转移
	{ 1450, "CS_EquipChange"},
	{ 1451, "SC_EquipChange"},

	--------------------------------------------------------------------------
	-- 棋牌
	{ 1470, "CS_CREATE_ROOM"},
	{ 1471, "SC_CREATE_ROOM"},
	{ 1472, "CS_ENTER_ROOM"},
	{ 1473, "SC_ENTER_ROOM"},
	{ 1474, "CS_EXIT_ROOM"},
	{ 1475, "SC_EXIT_ROOM"},
	{ 1476, "CS_OP_ROOM"},
	{ 1477, "SC_BET"},
	{ 1478, "SC_ROOM_MEMBERS"},
	{ 1479, "SC_HALL_LIST"},
	{ 1480, "SC_OP_ROOM_ACTION"},
	{ 1481, "SC_OP_ROOM"},
	{ 1482, "SC_INVITE_ROOMLIST"},
	{ 1483, "CS_QUERY_INFO"},
	{ 1484, "SC_QUERY_INFO"},

	-- 12支
	{ 1500, "SC_12ZHI_GETDATA"},
	{ 1501, "SC_12ZHI_BET"},
	{ 1502, "CS_12ZHI_BET"},
	{ 1503, "SC_TWELVE_RECORD"},

	-- 牛牛
	{ 1510, "SC_NIU_GETDATA"},
	{ 1511, "SC_NIUNIU_BET"},
	{ 1512, "SC_OX_ROB_BANKER"},
	{ 1513, "SC_OX_CARD_SHOW"},
	{ 1514, "SC_OX_PUBLIC_ROB_BANKER"},

	--dealer
	{ 1520, "CS_OP_DEALER"},
	{ 1521, "SC_DEALER_LIST"},
	{ 1522, "SC_DEALER_ADD"},
	{ 1523, "SC_DEALER_USERS"},
	{ 1524, "SC_TRANSFER_RECODE"},
	{ 1525, "SC_DEALER_BILL"},

	-- bank
	{1530, "CS_Transfer"},
	{1531, "SC_Transfer"},
	{1532, "CS_PAY_INFO"},
	{1533, "SC_PAY_INFO"},

	{1540, "CS_ORDER_CREATE"},
	{1541, "SC_ORDER_CREATE"},

	-- 牌九
	{1550, "SC_PAIGOW_GETDATA"},
	{1551, "SC_PAIGOW_BET"},
	{1552, "SC_OP_PAIGOW_ACTION"},
	{1553, "SC_PAIGOW_GETDATA_ENTER"},

	--摇乐子

	{1560, "SC_YAOLEZI_GETDATA"},
	{1561, "SC_YAOLEZI_BET"},
	{1562, "CS_YAOLEZI_BET"},
	-- {1562, "SC_YAOLEZI_FZ_BET"},
	-- {1563, "SC_YAOLEZI_NZ_BET"},
	{1564, "SC_SHEN_ZHI"},
	{1565, "SC_PUBLIC_SHEN_ZHI"},

	-- 13水
	{1570, "SC_WATER_GETDATA"},
	{1571, "SC_WATER_BET"},
	{1572, "SC_OP_WATER_ACTION"},
	{1573, "SC_WATER_EXIT_ROOM"},
	{1574, "SC_WATER_TRIM"},
	{1575, "SC_WATER_ENTER_ROOM"},
	{1576, "SC_WATERHALL_LIST"},

	
	--麻将
	{1580, "SC_MJ_GETDATA"},	
	{1581, "SC_MJ_ENTER"},	
	{1582, "SC_MJ_OUT_CARD"},	
	{1583, "SC_MJ_CPHG"},
	{1584, "SC_MJ_ENTRUST"},
	{1585, "SC_MJ_BROADCAST"},
	-- 公共
	{8000, "SC_CommonParam1"}

}