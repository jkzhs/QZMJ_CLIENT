--
-- Author: wangshaopei
-- Date: 2017-04-15 16:54:39
--
local def = {
	TIMER_ID_HEARTBEAT = 9,
	TIMER_ID_UPDATE_ST = 10,
	TIMER_ID_12ZHI_TIME = 100,
	TIMER_ID_NIUNIU_TIME = 101,
	TIMER_ID_YAOLEZI_TIME = 103,

	ROOMID_12ZHI_DATING2 = "3000200",-- 12支大厅2 1天2开房间id

	GAME_ID_12ZHI = 1,
	GAME_ID_NIUNIU = 2,
	GAME_ID_PAIGOW = 3,
	GAME_ID_YAOLEZI=4,
	GAME_ID_WATER = 5,
	GAME_ID_MJ = 6,

	-----------------------------------
	--频道
	CHANNEL_ID_SYSTEM		= 1,	--系统频道
	CHANNEL_ID_PERSONAL		= 2,	--私聊频道
	CHANNEL_ID_WORLD		= 3,	--世界频道
	CHANNEL_ID_GUILD		= 4,	--工会频道
	CHANNEL_ID_ROOM 		= 5, 	--房间
	-----------------------------------
	--频道发言CD
	_CD_TIME_CHANNEL ={
		[3] = 20,----系统频道
	},
	-----------------------------------
	--show type
	CHANNEL_SHOW_TYPE_NORMAL	= 0,
	CHANNEL_SHOW_TYPE_BULLETIN	= 1, --公告
	CHANNEL_SHOW_TYPE_MARQUEE	= 2, --跑马灯

	----------------------------------------------------------
	--通知客户端类型 SC_NOTIFY
	NOTIFY_TYPE_CHARGE_OK = 10, --充值成功提示

	----------------------------------------------------------
	------------------- 邮件系统 -------------------------
	----------------------------------------------------------
	MAIL_STATE_NONE = 0, --未读,无附件 0 => 2
	MAIL_STATE_HAVE = 1, --未读,带附件 1 => 3 OR 4
	MAIL_STATE_READ = 2, --已读,无附件
	MAIL_STATE_HERE = 3, --已读,附件未领取
	MAIL_STATE_RECE = 4, --已读,附件已领取
	----------------------------------------------------------
	---------------------背景音乐------------------------------
	BG_MUSIC_LOGIN   = "background-login",
	BG_MUSIC_HOME    = "bg_home",
	BG_MUSIC_12ZHI   = "shierzhi_music",
	BG_MUSIC_NIUNIU  = "niuniu_music",
	BG_MUSIC_PAIGOW  = "paigo_music",
	BG_MUSIC_YAOLEZI = "yaolezi_music",
	BG_MUSIC_SANSHUI = "wenot",
	BG_MUSIC_MJ = "background",

	----------------------------------------------------------
	---------------------麻将音效------------------------------
	--吃 碰 胡 杠 暗杠 补花 过
	-- AUDIO_MJ_PENG       = "mj_pengaudio",--1
	AUDIO_MJ_OUTCARD    = "mj_chupaiaudio",--0.5
	AUDIO_MJ_CLICK      = "mj_clickaudio",--0.2
	-- AUDIO_MJ_FANGPAO    = "mj_fangpao",--2.3
	AUDIO_MJ_FAPAI      = "mj_fapaiaudio",--0.2
	AUDIO_MJ_GUAFENG    = "mj_guafengaudio",--2.5
	-- AUDIO_MJ_LOST       = "mj_lostaudio",--1.5
	AUDIO_MJ_LOST       = "lose",
	AUDIO_MJ_WIN        = "win",
	AUDIO_MJ_RAIN       = "mj_rainaudio",--2.8
	AUDIO_MJ_SHAIZI     = "mj_shaiziaudio",--1.1

	SOUND_MJ_CHI      = "mj_chi",--1.6
	SOUND_MJ_PENG     = "mj_peng",--1.2
	SOUND_MJ_GANG     = "mj_gang",--1.1
	SOUND_MJ_BUHUA    = "mj_buhua",--0.9
	SOUND_MJ_YOUJING  = "mj_youjing",--0.9
	SOUND_MJ_ZIMO     = "mj_zimo",--0.9	
	SOUND_MJ_HU       = "mj_hu",--1.4
	SOUND_MJ_KAIJING  = "mj_kaijin",--0.8

	SOUND_DELAY_MJ_CHI  = 1.5,
	SOUND_DELAY_MJ_GANG = 0.7,
	SOUND_DELAY_MJ_PENG = 0.6,
	SOUND_DELAY_MJ_HU   = 1.0,
	SOUND_DELAY_MJ_ZIMO = 0.7,
	SOUND_DELAY_MJ_YOUJING = 0.8,
	SOUND_DELAY_MJ_OUTCARD = 0.5,
	SOUND_DELAY_MJ_KAIJING = 0.8,
	----------------------------------------------------------
	-- 牛牛
	OX_VALUE_TYPE_1 = 1, -- 炸弹
	OX_VALUE_TYPE_2 = 2, -- 顺子
	OX_VALUE_TYPE_3 = 3, -- 牛牛
	OX_VALUE_TYPE_NONE = 4 ,-- 非特殊牌

	OX_STATUS_FREE = 5, -- 空闲时间
	OX_STATUS_BANKER = 6, -- 抢庄时间
	OX_STATUS_BET = 7, -- 下注时间
	OX_STATUS_OPEN = 8, -- 开牌时间
	OX_STATUS_CLOSE = 9,

	OX_BANKER_COIN_MIN_LIMIT = 5000, -- 抢庄最小限制

	----------------------------------------------------------
	--十二支

	TWELVE_STATUS_FREE = 5, -- 空闲时间
	TWELVE_STATUS_BANKER = 6, -- 抢庄时间
	TWELVE_STATUS_SELECT = 7, -- 选择时间
	TWELVE_STATUS_BET = 8, -- 下注时间
	TWELVE_STATUS_OPEN = 9, -- 开牌时间
	TWELVE_STATUS_CLOSE = 10,

	-----------------------------------------------------------
	-- 牌九
	PAIGOW_STATUS_FREE 		= 5, -- 空闲时间
	PAIGOW_STATUS_BANKER 	= 6, -- 抢庄时间
	PAIGOW_STATUS_BET 		= 7, -- 下注时间
	PAIGOW_STATUS_OPEN 		= 8, -- 开牌时间
	PAIGOW_STATUS_CLOSE 	= 10,
	------------------------------------------------------------
	--摇乐子
	YAOLEZI_STATUS_FREE = 5, -- 空闲时间
	YAOLEZI_STATUS_BANKER = 6, -- 抢庄时间
	YAOLEZI_STATUS_SHAKE = 7, -- 摇奖时间
	YAOLEZI_STATUS_SHENZHI = 8, -- 申支时间
	YAOLEZI_STATUS_FANGZHI = 9, -- 放支时间
	YAOLEZI_STATUS_BET = 10,--下注（放支）
	YAOLEZI_STATUS_OPEN = 11,--开牌
	YAOLEZI_STATUS_CLOSE = 12,
	-----------------------------------------------------------
	-- 麻将
	MJ_STATUS_FREE 		= 5, -- 空闲状态
	MJ_STATUS_WAIT      = 6, -- 等待状态
	MJ_STATUS_PREPARE   = 7, -- 准备状态
	MJ_STATUS_PLAY      = 8, -- 出牌状态
	MJ_STATUS_CPHG      = 9, -- 碰吃胡状态
	MJ_STATUS_YOUJING   = 10, -- 游金状态
	MJ_STATUS_END       = 11, -- 结束状态
	
	MJ_STATUS_CLOSE 	    = 16,

	MJ_MAX_POWER        = 78, --最大赔率
	------------------------------------------------------------
	-- 13水
	WATER_STATUS_FREE 		= 5, -- 空闲时间
	WATER_STATUS_BANKER 	= 6, -- 抢庄时间
	WATER_STATUS_BET 		= 7, -- 下注时间
	WATER_STATUS_OPEN 		= 8, -- 开牌时间
	WATER_STATUS_CLOSE 	    = 10,
	WATER_STATUS_TRIM       = 11,-- 理牌时间
	WATER_STATUS_COUNT      = 12,-- 开牌前的数据统计

	WATER_BANKER_COIN_MIN_LIMIT = 500, -- 抢庄最小限制
	WATER_ODDS_1 = 1,   		 -- 赔率,一般

	WATER_ROOM_MIN          = 2, -- 最小人数限制
	WATER_ROOM_MAX          = 8, -- 最大人数限制
	WATER_ODDS13            = 4, -- 整副牌，13张

	-- 普通牌奖励
	WATER_AWARD_TYPE_0      = 0, -- 打和
	WATER_AWARD_TYPE_1      = 1, -- 头道 注
	WATER_AWARD_TYPE_2      = 1, -- 中道
	WATER_AWARD_TYPE_3      = 1, -- 尾道
	WATER_AWARD_TYPE_4      = 3, -- 打枪
	WATER_AWARD_TYPE_5      = 6, -- 全垒打

	WATER_AWARD_TYPE_11     = 2, -- 前墩3个  3
    WATER_AWARD_TYPE_12     = 1, -- 中墩葫芦  2
    WATER_AWARD_TYPE_13     = 0, -- 第三墩葫芦  1
    WATER_AWARD_TYPE_14     = 9, -- 中墩5铁枝  10
    WATER_AWARD_TYPE_15     = 7, -- 中墩4铁枝   8
    WATER_AWARD_TYPE_16     = 4, -- 后墩5铁枝   5
    WATER_AWARD_TYPE_17     = 3, -- 后墩4铁枝   4
    WATER_AWARD_TYPE_18     = 9, -- 中墩同花顺  10
    WATER_AWARD_TYPE_19     = 4, -- 后墩同花顺   5


	-- 特殊牌奖励
	WATER_AWARD_TYPE_39      = 30, -- 同花顺
	WATER_AWARD_TYPE_38      = 20, -- 草龙
	WATER_AWARD_TYPE_20      = 3,  -- 6对半，3同花，3顺子

	-- 特殊牌型
	WATER_VALUE_TYPE_298     = 1298,  -- 清一色一条龙（a-k)
	WATER_VALUE_TYPE_297     = 1297,  -- 一条龙（a-k)
	WATER_VALUE_TYPE_270     = 1270,  -- 6对半
	WATER_VALUE_TYPE_260     = 1260,  -- 3同花
	WATER_VALUE_TYPE_250     = 1250,  -- 3顺子

	-- 普通牌型
	WATER_VALUE_TYPE_190     = 1190, -- 同花顺
	WATER_VALUE_TYPE_175     = 1175, -- 五条铁支（炸弹）
	WATER_VALUE_TYPE_174     = 1174, -- 铁支（炸弹）
	WATER_VALUE_TYPE_160     = 1160, -- 葫芦
	WATER_VALUE_TYPE_150     = 1150, -- 同花
	WATER_VALUE_TYPE_140     = 1140, -- 顺子
	WATER_VALUE_TYPE_130     = 1130, -- 三条
	WATER_VALUE_TYPE_120     = 1120, -- 二对
	WATER_VALUE_TYPE_110     = 1110, -- 一对
	WATER_VALUE_TYPE_100     = 1100, -- 散牌
	WATER_VALUE_TYPE_99      = 1099, -- 倒水


	-- 引擎常量
	UE_PLATFORM_IPHONEPLAYER = 8,
	UE_PLATFORM_ANDROID = 11,

	PAY_TYPE_ALIPAY = 0,       	-- 支付宝
	PAY_TYPE_WX = 1,        	-- 微信
	PAY_TYPE_BANK = 2, 			-- 银行

}

local def_enum = function(typename, descname, ...)
	  assert(not def[typename], typename)
	  assert(not def[descname], descname)
	  local varargs = {
		...
	  }
	  local enum_members = {}
	  for i = 1, #varargs do
		local name = varargs[i]
		assert(not def[name], name)
		def[name] = i
		enum_members[i] = i
	  end
	  def[typename] = enum_members
	  def[descname] = varargs
end

-----------
--场景事件
def_enum("E_MSG", "E_MSG_NAMES",
			-- 这边开始定义事件
			"MSG_UI_UPDATAROLEINFO",
			"MSG_UI_12ZHI_CHOUMA_UPDATA",
			"MSG_UI_NIUNIU_UPDATA",
			"MSG_UI_YAOLEZI_UPDATA",

			"MSG_END"
)

return def