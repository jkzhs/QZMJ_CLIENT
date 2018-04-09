
return function(config, global)

	-- config.WEBSERVER_URL = "http://192.168.0.22/ud/"
	--平台类型
	config.LOGIN_PLATFORM = "lwt"

	-- 禁止自动登录
	config.NO_AUTO_LOGIN = false

	-- 1:微信 2:游客  3:全部
	config.PACKAGE_TYPE = 3

	config.APP_DOWN_URL = "http://www.solu8.com/down/htdocs/"

	config.SocketAddress = "219.234.5.48"

	DEBUG = 0

end
