
return function(config, global)

	-- config.WEBSERVER_URL = "http://192.168.0.22/ud/"
	--平台类型
	config.LOGIN_PLATFORM = "wx"

	-- 禁止自动登录
	config.NO_AUTO_LOGIN = false

	-- 1:微信 2:游客  3:全部
	config.PACKAGE_TYPE = 1

	config.APP_DOWN_URL = "http://www.vtv365.com/ud/down/"

	config.SocketAddress = "121.196.218.182" --game

	-- 微信h5支付回调地址
	config.wx_pay_notify = "http://121.196.218.182:9001/charge_yc_wx"

	-- 微信h5支付referer地址
	config.referer_url = "http://www.vtv365.com/pay_finish"

	-- 优畅支付宝支付回调地址
	config.yc_alipay_notify = "http://121.43.166.110/paya/yc_alipay_notify.php" --db

	config.tl_pay = "http://www.vtv365.com/paya/tl_pay.php"

	DEBUG = 0

end
