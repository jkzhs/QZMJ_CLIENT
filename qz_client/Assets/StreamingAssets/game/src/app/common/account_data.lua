--
-- Author: Albus
-- Date: 2016-04-27 11:52:40
-- Filename: account_data.lua
--
-- local lastServerAccount_filepath = G_FLIE_PATH.."LastServerAccount.txt"

local M = {}
local PlayerPrefs = UnityEngine.PlayerPrefs
function M:get_account()
	local info = self:load_account()
	local uid,token = info.uid, info.token
	if uid and uid~="" and token and token~="" then
		return info
	end
end
function M:load_account()

	local info = self.v_info
	if info then
		return info
	end

	-- local uid = KNFileManager.readfile(lastServerAccount_filepath , "acc" , "=")
	-- local token = KNFileManager.readfile(lastServerAccount_filepath , "pwd" , "=")
	local uid = PlayerPrefs.GetString("acc")
	local token = PlayerPrefs.GetString("pwd")
	local info = {
		uid = uid,
		token= token
	}
	self.v_info = info
	return info
end

function M:save_account(uid, token)
	-- KNFileManager.updatafile(lastServerAccount_filepath , "acc" , "=" , uid)
	-- KNFileManager.updatafile(lastServerAccount_filepath , "pwd" , "=" , token)
	PlayerPrefs.SetString("acc",uid)
	PlayerPrefs.SetString("pwd",token)
	self.v_info = {
		uid = uid,
		token= token
	}
end

function M:clear()
	-- PlayerPrefs.SetString("acc",'')
	-- PlayerPrefs.SetString("pwd",'')
end

function M:load_lastserver()
	local lineid = KNFileManager.readfile(lastServerAccount_filepath , "aid" , "=")
	local serverid = KNFileManager.readfile(lastServerAccount_filepath , "sid" , "=")
	return lineid, serverid
end

function M:save_lastserver( lineid, serverid )
	KNFileManager.updatafile(lastServerAccount_filepath , "aid" , "=" , lineid)
	KNFileManager.updatafile(lastServerAccount_filepath , "sid" , "=" , serverid)
end

--设置SDKID，易接用到
function M:set_sdkid( sdkid )
	-- KNFileManager.updatafile(lastServerAccount_filepath , "sdkid" , "=" , sdkid)
	self.sdkid = sdkid
end
function M:get_sdkid()
	local sdkid = self.sdkid
	if sdkid then
		return sdkid
	end
	sdkid = KNFileManager.readfile(lastServerAccount_filepath , "sdkid" , "=")
	return sdkid
end

function M:set_autologin(b)
	KNFileManager.updatafile(lastServerAccount_filepath , "auto" , "=" , b)
	self.autologin = b
end
function M:get_autologin()
	local auto = self.autologin
	if auto then
		return auto
	end
	auto = KNFileManager.readfile(lastServerAccount_filepath , "auto" , "=")
	if not auto or auto == "" then
		return 0
	end
	return tonumber(auto)
end

function M:isauto()
	return self:get_autologin() > 0
end

return M
