
-- local Registry = import(".Registry")

local GameObject = {}

local function OnLoad(name, ...)
    -- local cls = Registry.classes_[name]
    -- if not cls then
        pcall(function()
            cls = require(name)
            -- Registry.add(cls, name)
        end)
    -- end
    assert(cls ~= nil, string.format("GameObject.OnLoad() - invalid class \"%s\"", tostring(name)))
    return cls
    -- return cls.new(...)
end
local Component = {}
function Component.exportMethods(target,obj)

    for key,v in pairs(obj) do
        if not target[key] then
            local m = obj[key]
            if type(m) == "function" then
                target[key] = function(__, ...)
                    return m(obj, ...)
                end
            end
        end
    end

end

function GameObject.extend(target)
    target.components_ = {}

    function target:checkComponent(name)
        return self.components_[name] ~= nil
    end

    function target:addComponent(name)
        -- local component = Registry.newObject(name)
        local component = OnLoad(name)
        self.components_[name] = component
        if component.init then
            component:init()
        end
        Component.exportMethods(self,component)
        -- component:bind_(self)
        return component
    end

    -- function target:removeComponent(name)
    --     local component = self.components_[name]
    --     if component then component:unbind_() end
    --     self.components_[name] = nil
    -- end

    function target:getComponent(name)
        return self.components_[name]
    end

    return target
end

return GameObject
