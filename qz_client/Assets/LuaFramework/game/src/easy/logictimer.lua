
local pairs=pairs
local _ipairs=ipairs
--timer task
local timer_list = {}
local timer_list_inx={}

local ontimer

logictimer = {}

local deltaTime=Time.deltaTime

--[[
	单位
	starttime 为定时器第一次触发时间，
	interval>0 时为定时器第二次以后
	interval==0 只处理1次
]]
function logictimer.add_timer(id, starttime, interval, f)
	if timer_list[id] then
		-- assert(fa,id)
		logW(("timerid %s is exist"):format(id))
		return
	end
	local t = {
		id = id,
		interval = interval*1000,
		callback = f,
		trigger_time = starttime,
		current_time = 0,
		del = false,
	}

	timer_list[id] = t
	table.insert(timer_list_inx,t)

	return id
end

local function del_timer(id)
	-- timer_list[id] = nil
	if not id or not timer_list[id] then
		-- assert(false)
		print("del_timer failed , id is",id)
		return false
	end
	-- table.remove(timer_list,id)
	-- timer_list[id]=nil
	local t = timer_list[id]
	t.del = true
end
logictimer.del_timer = del_timer

function logictimer.clear_timer()
	timer_list = {}
	timer_list_inx = {}
end
-- timer event
function logictimer.ontimer_fun( fun )
	ontimer = fun
end

function logictimer.dispatch_timertask(dt)
	-- local now = deltaTime()*1000
	for k, v in _ipairs(timer_list_inx) do
		if v and not v.del then
			if v.current_time >= v.trigger_time then
				--优先执行
				local f = v.callback
				if f then
					f(v)
				else
					if ontimer then
						ontimer(v)
					end
				end
				--在删除
				if v.interval > 0 then
					v.trigger_time = v.current_time + v.interval
				else
					del_timer(v.id)
				end
			end
			v.current_time = v.current_time + dt*1000
		end
	end

	for i=#timer_list_inx,1,-1 do
		local t = timer_list_inx[i]
		if t and t.del then
			timer_list[t.id]=nil
			table.remove(timer_list_inx,i)
		end
	end
end

return logictimer