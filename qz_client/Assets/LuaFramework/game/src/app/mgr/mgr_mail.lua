
local table = table
local global = require("global")
local const = assert(global.const)
local handler = assert(global.handler)
local i18n = assert(global.i18n)
-- local KNMsg = assert(global.KNMsg)

local M = class("mgr_mail")

function M:ctor(owner)
	self:reset()
	global.network:nw_register("SC_MailRet",handler(self,self._mail_notify))
end
function M:reset()
	self.mail_list = {}
	self.count = 0
end
--得到未读邮件数量
function M:get_unread_count()
	return self.count
end
--未读邮件
function M:get_mail_list(id)
	return self.mail_list
end

function M:get_mail( index )
	return self.mail_list[index]
end
--是否已读
function M:is_readed(state)
	return ( state == const.MAIL_STATE_READ
		or state == const.MAIL_STATE_HERE
		or state == const.MAIL_STATE_RECE)
end
--是否领取过奖励
function M:is_reved( state )
	return state == const.MAIL_STATE_RECE
end
--是否有奖励
function M:has_reward(rewards)
	if rewards then
		if rewards.money then
			return true
		end
		if rewards.RMB then
			return true
		end
		if rewards.items and #rewards.items > 0 then
			return true
		end
	end
end

function M:_mail_notify(req)
	-- global.log("=======_mail_notify=========")
	self.count = req.param
	-- 显示小红点
	-- 这边通知界面更新
	local gameLobby = global._view:getViewBase("GameLobby") or nil
	if gameLobby then
		gameLobby.UpdataMailBtn (self.count)
	end
	-- local msg = global.mq_ui:mq_publish2(const.MSG_UI_NOTIFYMAIL)
	-- msg.mm_obj = self.count
end

local _mail_dump_reward = function(mail)
	local data = {}
	local c = 1
	if mail.money > 0 then
		data.money = mail.money
	end
	if mail.RMB > 0 then
		data.RMB = mail.RMB
	end

	if #mail.attachment > 0 then
		data.items = {}
		for i,v in ipairs(mail.attachment) do
			table.insert(data.items,{id=v.id, count=v.count})
		end
	end

	return data
end
local _mail_dump = function(self,mails)
	local data = {}
	for i,v in ipairs(mails) do
		local sender
		if v.sender == "system" then
			sender = i18n.TID_MAIL_SENDER
		else
			sender = v.sender
		end

		local mailtype = ""
		if 0 == v.mail_type then
			mailtype = i18n.TID_MAIL_TYPE_SYSTEM
		end
		data[#data+1] = {
			sno = v.sno,
			mailtype = mailtype,
			sender = sender,
			receiver = i18n.TID_MAIL_RECEIVER,
			sendtime = v.sendtime,
			title = v.title,
			content = v.content,
			rewards = _mail_dump_reward(v),
			state = v.state,
			playerid = v.playerid,
			-- timeout = v.timeout,
			-- name = v.name,
		}

		table.sort(self.mail_list, function(a, b)
			return a.sno > b.sno
		end)
	end
	return data
end

function M:sort_mails()
	-- table.sort(self.mail_list, function(a, b)
	-- 	return a.sno > b.sno
	-- end)
end
--[[
	加载所有邮件
]]
function M:mail_load(cb)
	global.player:call("CS_AskInfo",{type=6},function(resp)
			self.mail_list = _mail_dump(self,resp.maillist)
			self:sort_mails()
			-- dump(self.mail_list)
			if cb then
				local data = self.mail_list
				cb(data)
			end
			
			-- 这边通知界面更新
			-- local msg = global.mq_ui:mq_publish2(const.MSG_UI_NOTIFYMAIL)
			-- msg.mm_obj = self.count
		end)
end
--[[
	读一封邮件
]]
function M:mail_read(select_mail,cb)

	-- --打开界面
	-- global.ui_facade:uf_show_ui("UIMailInfo",false,select_mail)

	--通知状态改变
	local sno = select_mail.sno
	global.player:call("CS_AskInfo",{type=7,param1=1,param=sno },function(resp)
		for i,v in ipairs(self.mail_list) do
			if v.sno == sno then
				if resp.param > 0 and resp.param ~= v.state then
					v.state = resp.param
					self:sort_mails()
					self.count = self.count -1

					-- 这边通知界面更新
					-- local msg = global.mq_ui:mq_publish2(const.MSG_UI_NOTIFYMAIL)
					-- msg.mm_obj = self.count
				end
				if cb then
					cb(v)
				end
				return
			end
		end
	end)
end

--[[
	删除邮件
]]
function M:remove_mail(sno, cb)
	global.player:call("CS_AskInfo",{type=7,param1=2,param=sno },function(resp)
		for i,v in ipairs(self.mail_list) do
			if v.sno == sno then
				if resp.param == sno then
					--删除
					table.remove(self.mail_list,i)

					self:sort_mails()

					-- 这边通知界面更新
					-- local msg = global.mq_ui:mq_publish2(const.MSG_UI_NOTIFYMAIL)
					-- msg.mm_obj = self.count

					if cb then --回调
						cb(true)
					end
					return --KNMsg:flashShowError(i18n.MAIL_DEL_OK)
				else
					if cb then
						cb(false)
					end
					-- return KNMsg:flashShowError(i18n.MAIL_DEL_ATTA_HERE)
				end
			end
		end
	end)
end

--[[
	一键删除
]]
function M:one_key_remove_mail(cb)
	if #self.mail_list == 0 then
		if cb then
			cb(false)
			return
		end


		-- return KNMsg:flashShowError(i18n.MAIL_DEL_NO_MAIL)

	end

	global.player:call("CS_AskInfo",{type=7,param1=3},function(resp)
		if #resp.list <= 0 then
			if cb then
				 cb(true)

				 return
			 end
			-- return KNMsg:flashShowError(i18n.MAIL_DEL_NO_READED_MAIL)
		end

		--del
		for i,id in ipairs(resp.list) do
			for j,v in ipairs(self.mail_list) do
				if v.sno == id then
					table.remove(self.mail_list,j)
					break
				end
			end

		end
		if cb then
			cb(true)

			return
		end
		-- 这边通知界面更新
		-- local msg = global.mq_ui:mq_publish2(const.MSG_UI_NOTIFYMAIL)
		-- msg.mm_obj = self.count

		-- return KNMsg:flashShowError(i18n.MAIL_DEL_ALL_OK)
	end)
end

--[[
	收取邮件
]]
function M:mail_recv(sno)
	global.player:call("CS_AskInfo",{type=7,param1=4, param=sno},function(resp)
		for i,v in ipairs(self.mail_list) do
			if v.sno == sno then
				if resp.param > 0 and resp.param ~= v.state then
					v.state = resp.param
					if v.state == const.MAIL_STATE_RECE then
						self:sort_mails()

						-- 这边通知界面更新
						-- global.mq_ui:mq_publish2(const.MSG_UI_RECV_MAIL)
						-- local msg = global.mq_ui:mq_publish2(const.MSG_UI_NOTIFYMAIL)
						-- msg.mm_obj = self.count
					end
				end
				return
			end
		end
	end)
end

--[[
	一键收取
]]
function M:one_key_mail_recv(cb)
	if #self.mail_list == 0 then
		if cb then cb() end
		return KNMsg:flashShowError(i18n.MAIL_RECV_NO_MAIL)
	end

	global.player:call("CS_AskInfo",{type=7,param1=5},function(resp)
		if #resp.list <= 0 then
			if cb then cb() end
			return KNMsg:flashShowError(i18n.MAIL_RECV_NO_MAIL)
		end

		--del
		for i,id in ipairs(resp.list) do
			for j,v in ipairs(self.mail_list) do
				if v.sno == id then
					v.state = const.MAIL_STATE_RECE
					break
				end
			end
		end
		self.count = self.count - #resp.list
		self:sort_mails()

		-- 这边通知界面更新

		-- local msg = global.mq_ui:mq_publish2(const.MSG_UI_NOTIFYMAIL)
		-- msg.mm_obj = self.count

		return --KNMsg:flashShowError(i18n.MAIL_RECV_ALL_OK)
	end)
end

--[[
 获取未收邮件数量
]]
function M:req_get_uncheck_mail_count()
	return global.player:call("CS_AskInfo",{type=8},handler(self,self._mail_notify))
end

return M