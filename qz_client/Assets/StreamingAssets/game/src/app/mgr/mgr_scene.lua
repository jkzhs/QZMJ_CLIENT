--
-- Author: wangshaopei
-- Date: 2017-04-22 08:49:51
--
local m = class("mgr_scene")
local mgr={}

function m.load_logic(name)
	if name == "login" then
		local loginscene = require("app.scene.loginscene").new()
		mgr[name]=loginscene
	elseif name == "home" then
		local homescene = require("app.scene.homescene").new()
		mgr[name]=homescene
	elseif name == "hall" then
		local hallscene = require("app.scene.hallscene").new()
		mgr[name]=hallscene
	elseif name == "room" then
		local roomscene = require("app.scene.roomscene").new()
		mgr[name]=roomscene
	elseif name == "room_12zhi" then
		local room_12zhi_scene = require("app.scene.room_12zhi_scene").new()
		mgr[name]=room_12zhi_scene
	else
		mgr[name]=require("app.scene."..name.."_scene").new()
		-- assert(false)
	end
	return mgr[name]
end

function m.load_scene ( name )
	m.load_logic(name)
	-- easy.scenes.load_scene(name)
end

function m.unload_scene( name )
	if name == "login" then
	end
end

function m.get_scene(name)
	return mgr[name]
end

function m.Loaded(name)
	local s = mgr[name]
	if not s then
		s = m.load_logic(name)
	end
	if s and s.Loaded then
		s:Loaded()
	end
end

function m.UnLoaded(name)
	local s = mgr[name]
	if s and s.UnLoaded then
		s:UnLoaded()
	end
	mgr[name]=nil
end

return m