------------------------------------------------
--
--  简单消息通知
--
------------------------------------------------ 
CustomNotification = {}

function CustomNotification:addNotification(group,name,func)
    if group == nil or name == nil or func == nil then
        return
    end
    if type(func) ~= "function" then
        print("注册的侦听非方法",group,name)
        return
    end
    if self[group] == nil then
        self[group] = {}
    end
    self[group][name] = func
end

function CustomNotification:removeNotification(group,name)
    if group == nil then 
        return
    end
    if self[group] ~= nil then
        if name == nil then
            self[group] = nil
        else
            if self[group][name] ~= nil then
                self[group][name] = nil
            end
        end
    end
end

function CustomNotification:excuteNotification(group,name,...)
    if group == nil then
        print("未注册侦听类",group)
        return
    end
    if self[group] ~= nil then
        if name == nil then
            for k,v in pairs(self[group]) do
                v(...)
            end
        else
            if self[group][name] ~= nil then
                self[group][name](...)
            end
        end
    end
end