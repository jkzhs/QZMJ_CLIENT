return {
	ERROR_OK				= 0, --成功

	--[[系统错误 1~800]]
	-- ERROR_VER_ERR 			= 1,	--socket 版本不兼容
	-- ERROR_SERVER_CLOSING 	= 2,	--服务器正在关闭
	-- ERROR_REPEAT_LOGIN 		= 2,	--账号重复登录
	-- ERROR_PASSWORD_ERR 		= 3,	--密码错误
	-- ERROR_NO_PERMISSION 		= 4,	--没权限
	-- ERROR_LOGIN_OTHER 		= 5,	--帐号在别处登录

	NETWORK_ERROR_400			= 400, --Bad Request . 握手失败
	NETWORK_ERROR_401			= 401, --Unauthorized . 自定义的 auth_handler 不认可 token
	ERROR_AUTH_FAILED			= 403, --Unauthorized
	NETWORK_ERROR_404			= 404, --agent已经关闭
	NETWORK_ERROR_406			= 406, --Not Acceptable . 该用户已经在登陆中。（只发生在 multilogin 关闭时）
	NETWORK_ERROR_407			= 407,
	ERROR_OVER_LIMIT 			= 408, --人数已达上限
	ERROR_SERVER_IS_CLOSE 		= 409, --服务器已经关闭
	ERROR_SERVER_NOT_OPEN 		= 410, --服务器未到开服时间
	NETWORK_ERROR_500			= 500,
	NETWORK_ERROR_502			= 502,
	NETWORK_ERROR_600			= 600, --登录失败
	NETWORK_ERROR_601			= 601, --解析包头失败
	NETWORK_ERROR_602			= 602, --未定义消息
	NETWORK_ERROR_603			= 603, --包解析失败
	NETWORK_ERROR_700			= 700, --封ip
	NETWORK_ERROR_701			= 701, --封号
	ERROR_TOKEN_MISS			= 800, --token 失效

	NETWORK_ERROR_GUEST			= 900, --禁止游客登陆

	NETWORK_ERROR_10000			= 10000,
	NETWORK_ERROR_100001		= 100001,
	NETWORK_ERROR_UNKNOW		= 100002,

	ERROR_UNKNOW				= 100003,


	-- ERR_CHANNEL_ERR_CH_ID			= 1000,	--聊天频道,错误的频道id
	-- ERR_CHANNEL_CD					= 1001,	--聊天cd中,你发言太频繁了
	ERR_CHANNEL_PRIVATE_SELF		= 1002,	--不要和自己私聊吧
	-- ERR_CHANNEL_TEXT_EMPTY			= 1003,	--不能发表空的消息
	-- ERR_CHANNEL_TEXT_TOO_LONG		= 1004,	--消息太长,一次最多只能发送60个字符
	-- ERR_CHANNEL_NOTIN_GUILD			= 1005,	--你尚未加入帮派,无法在帮派频道发言
	ERR_CHANNEL_NO_SPEAK_FOREVER	= 1006,	--永久禁言
	ERR_CHANNEL_NO_SPEAK_TIME		= 1007,	--禁言时间
	ERR_CHANNEL_BAN_CHAT			= 1008,	--因xxx，被禁言

	--聊天
	-- CHAT_PERSON_NOT_EXIT			= 200000,  --对方不存在
	CHAT_PERSON_NOT_ONLINE			= 200001,  --对方不在线
	-- CHAT_GUILD_NOT_EXIT				= 200002,  --工会不存在
	CHAT_PERSON_IN_BLACKLIST		= 200003,  --对方在黑名单中不能发聊天信息

	ERR_USER_MGR_OFFLINE				= 300001, --玩家不在线
	ERR_USER_MGR_PLAYER_NOT_EXISTS		= 300002,
	ERR_USER_MGR_PLAYER_FRIEND_FULL		= 300003, --玩家好友已满
	ERR_USER_MGR_MY_FRIEND_FULL			= 300004, --我的好友列表好友已满
	ERR_FRIEND_FULL						= 300005,
	ERR_FRIEND_ALREADY_HAS				= 300006,
	ERR_FRIEND_NOT_MY_FRIEND			= 300007,
	ERR_FRIEND_REQ_NOT_EXISTS			= 300008,
	ERR_FRIEND_NOT_SELF					= 300009,
	ERR_USER_MGR_PLAYER_BLACKLIST_FULL	= 300010, --黑名单已满
	ERR_BLACKLIST_NOT_SELF				= 300011, --不能加自己
	ERR_BLACKLIST_ALREADY_HAS			= 300012, --已在黑名单中
	ERR_BLACKLIST_ALREADY_HAS_SELF		= 300013, --你在对方的黑名单中

	-- 房间
	ERROR_ROOM_ROOMD_NAME 					= 400000,
	ERROR_CREATE_ROOM_ROOMD_FAILED 			= 400001, -- 创建房间服务器失败
	ERROR_PLAYER_ALREADY_ROOM 				= 400002, -- 玩家已经在房间
	ERROR_ROOM_NO_ROOMD						= 400003, -- 房间服务不存在
	ERROR_ROOM_NO_USER						= 400004, -- 房间内没有这个玩家
	ERROR_ROOM_STATUS						= 400005, -- 房间状态错误
	ERROR_ROOM_INVITE_ALREADY				= 400006, -- 房间邀请存在
	ERROR_ROOM_BANKER_ALREADY 				= 400007, -- 庄家已被抢
	ERROR_ROOM_BANKER_NOT_EXIST				= 400008, -- 没有庄家
	ERROR_ROOM_BANKER_DONT_BET				= 400009, -- 庄家不能下注
	ERROR_ROOM_PLAYER_NOT_NUM 				= 400010, -- 房间人数不足
	ERROR_ROOM_NO_BET_USER 					= 400011, -- 不是下注用户
	ERROR_ROOM_NO_PUB_ROOM					= 400012, -- 房主才能发布房间
	ERROR_ROOM_NO_HALL_LIST 				= 400013,
	ERROR_ROOM_CREATE_OFTEN 				= 400014, -- 房间创建太过频繁，请10秒后重试
	ERROR_ROOM_TICKET_NOT_ENOUGH 			= 400015, -- 房卡不足
	ERROR_ROOM_DO_BANKER_ALREADY 			= 400016, -- 您还在其他房间坐庄中
	ERROR_ROOM_USER_MAX_COIN				= 400017, -- 玩家最高下注错误
	ERROR_ROOM_TRAN_MONEY					= 400018, -- 人气未达最低上限
	ERROR_ROOM_DO_BET_ALREADY 			 	= 400019, -- 您还在其他房间内下注
	ERROR_ROOM_GAMEID 			 			= 400020, -- 游戏ID不匹配
	ERROR_ROOM_MAX_USER_LIMIT 				= 400021, -- 房间人数已达最大

	-- 牛牛
	ERROR_ROB_BANKER_COIN_MIN_LIMIT		= 401000,-- 抢庄最低亚通币不足
	ERROR_OX_NEXT_BOUNT_OP 				= 401001,-- 下局才操作
	ERROR_OX_CARD_SHOW_ALREADY			= 401002,-- 已经甩牌
	ERROR_OX_IN_ALL_ALREADY				= 401003,-- 不能多次梭哈
	ERROR_OX_USER_COIN_ALREADY_MAX 		= 401004,-- 下注不能超过最大上限
	ERROR_OX_USER_LOST_COIN_MAX 		= 401005,-- 所需最大赔率本金不足
	ERROR_OX_PLAYER_BET_NOT_NUM 		= 401006,-- 房间可下注人数不足

	-- 12支
	ERROR_TWELVE_NOT_BANKER				= 401200,-- 您不是庄家
	ERROR_TWELVE_POS_COIN_ALREADY_MAX 	= 401201,-- 该位置下注以达最大上限

	-- 13水
	ERROR_WATER_PLAYER_BET_MAX          = 501000, -- 下注金额超过庄家承受的范围
	ERROR_WATER_PLAYER_BET_MIN          = 501001, -- 闲家不能低于最小押注额
	ERROR_WATER_PLAYER_TRIM             = 501002, -- 卡牌类型设置有误，请重新上传
	ERROR_WATER_PLAYER_BET_MAX2         = 501003, -- 下注金额超过承受的范围

	ERROR_WATER_ROOM_LIMIT_MAX          = 502000, -- 该房间超过人数的限制，不能加入
	ERROR_WATER_ROOM_LIMIT_MIN          = 502000, -- 该房间人数不足，不能开局
	ERROR_WATER_ROOM_CARD1              = 502001, -- 该玩家未获得卡牌的数据
	ERROR_WATER_ROOM_CARD2              = 502002, -- 该玩家的特殊牌型检查不通过
	ERROR_WATER_ROOM_CARD3              = 502003, -- 该玩家的第一（2,3）墩牌型检查不通过
	ERROR_WATER_ROOM_CARD4              = 502004, -- 该玩家的卡牌数据有误，整理后位置数据有误
	ERROR_WATER_ROOM_CARD5              = 502005, -- 卡牌的牌型倒水
	ERROR_WATER_ROOM_CARD6              = 502006, -- 本局该玩家已理完牌
	ERROR_WATER_ROOM_ENTER_LIMIT        = 502009, -- 你携带的金额不够
	ERROR_WATER_ROOM_STATUS             = 502010, -- 房间状态不在理牌阶段出牌
	ERROR_WATER_ROOM_TYPE               = 502011, -- 房间类型不对

	ERROR_WATER_MAX_PAYBET              = 504001, -- 自由模式下，玩家最大赔注金额不够
	ERROR_WATER_MIN_PAYBET              = 504002, -- 自由模式下，玩家最大赔注金额不够

	ERROR_WATER_TRIM_CARD1              = 504010, -- 玩家正理牌判断中
	ERROR_WATER_TRIM_CARD2              = 504011, -- 玩家已经理牌完

	ERROR_WATER_POUR_NUM                = 503000, -- 该房间内的最少注数还没有设置
	ERROR_WATER_POUR_COIN               = 503001, -- 该房间内的最少下注限量未设置
	ERROR_WATER_MIN_BET_POUR            = 503010, -- 该玩家未达到最少下注限制
	ERROR_WATER_MAX_BET_POUR            = 503011, -- 该玩家超过本房间最多下注限制
	ERROR_WATER_ROB_MIN_COIN            = 503020, -- 该玩家的未达到该房间抢庄标准
	ERROR_WATER_ROB_USE_COIN            = 503021, -- 该玩家的抢庄的金币不足

	--摇乐子
	ERROR_YAOLEZI_SHENZHI_ALREADY       = 401400,-- 已经被申请放支成功
	YAOLEZI_SHENZHI_COIN_MIN_LIMIT      = 401401,--申请放支最低亚通币不足

	-- 麻将
	ERROR_MJ_PLAYER_ID                    = 401501, -- 玩家ID不正确
	ERROR_MJ_CARD_ID                      = 401502, -- 卡牌ID不正确
	ERROR_MJ_HAVED_PLAY                   = 401503, -- 已经出过牌
	ERROR_MJ_HAVED_ENTRUST                = 401504, -- 已经成功设置过委托
	ERROR_MJ_CANCEL_ENTRUST               = 401505, -- 已经取消委托
	ERROR_MJ_HAVED_START                  = 401506, -- 游戏已开始
	ERROR_MJ_ROOM_PLAY                    = 401507, -- 还在进行麻将游戏，请等待当局结束
	ERROR_MJ_HAVED_PREPARE                = 401508, -- 玩家已经是准备状态
	ERROR_MJ_DONT_PREPARE                 = 401509, -- 玩家还未做准备
	ERROR_MJ_OVER_LIMIT                   = 401510, -- 房间内玩家人数已经达到上限
	-- 代理
	ERROR_DEALER_NOT_EXIST				= 402008, -- 没有这个代理
	ERROR_DEALER_BAND_ALEADY 			= 402009, -- 您已经绑定代理

	-- 支付
	ERROR_PAY_FEE 						= 403009, -- 支付金额错误
	ERROR_PAY_FAILED 					= 403010, -- 发起充值请求失败



	-- 通用
	ERROR_MAX_LEVEL 						= 900001,--已达到最高级别
	ERROR_VIGOUR_NOT_ENOUGH 				= 900002,--军令不足
	ERROR_RMB_NOT_ENOUGH 					= 900003,--亚通金币不足
	ERROR_MONEY_NOT_ENOUGH 					= 900004,--亚通银币不足
	ERROR_VIP_NOT_ENOUGH 					= 900005,--VIP等级不足
	ERROR_POP_UP_ILLEGAL_OPERATION			= 900006,--非法操作
	ERROR_COIN_NOT_ENOUGH 					= 900007,--亚通币不足
	ERROR_COIN_VALUE						= 900008,--亚通币值异常
	ERROR_NOT_EXIST_USER					= 900009, --玩家不存在
	ERROR_NOT_OPERATE_SELF 					= 900010, -- 不能对自己操作
	ERROR_PARAM  							= 900011, -- 错误的参数

}