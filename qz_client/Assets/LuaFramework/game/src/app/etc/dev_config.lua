
return function(config, global)

	-- config.WEBSERVER_URL = "http://192.168.0.22/ud/"
	--平台类型
	-- config.LOGIN_PLATFORM = "lwt"
	config.LOGIN_PLATFORM = "lwt"
	-- 禁止自动登录
	config.NO_AUTO_LOGIN = true

	-- 1:微信 2:游客  3:全部
	config.PACKAGE_TYPE = 3

	config.APP_DOWN_URL = "http://www.vtv365.com/ud/down/"

	-- config.SocketAddress = "47.96.166.201"
	-- config.SocketAddress = "192.168.1.148"
	config.SocketAddress = "192.168.1.2"
	-- config.SocketAddress = "192.168.1.111"
	-- config.SocketAddress = "192.168.1.166"

	-- 微信h5支付回调地址
	config.wx_pay_notify = "http://47.96.166.201:9001/charge_yc_wx" -- 线上测试服

	-- 微信h5支付referer地址
	config.referer_url = "http://www.vtv365.com/pay_finish"

	-- 优畅支付宝支付回调地址
	config.yc_alipay_notify = "http://47.96.166.201/paya/yc_alipay_notify.php"

	-- 通联银行发起充值地址
	config.tl_pay = "http://www.vtv365.com/paya/tl_pay.php"

	-- 测试支付
	config.TEST_PAY = true
end
