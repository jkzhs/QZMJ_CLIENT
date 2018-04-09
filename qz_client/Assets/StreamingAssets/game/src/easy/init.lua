--
-- Author: wangshaopei
-- Date: 2017-04-11 16:50:03
--

-- print("===========================================================")
-- print("              LOAD EASY FRAMEWORK")
-- print("===========================================================")

easy = easy or {}
require "easy.functions"

local GameObject = require("easy.GameObject")
local ccmt = {}
ccmt.__call = function(self, target)
    if target then
        return GameObject.extend(target)
    end
    printError("easy() - invalid target")
end
setmetatable(easy, ccmt)

require "easy.logictimer"

easy.scenes = nil--require("easy.scene.scenes")