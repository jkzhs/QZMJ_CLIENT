--
-- Author: wangshaopei
-- Date: 2017-04-22 09:42:56
--
local m={}
local mgr = {}
function m.open( panel_name ,conf)
	-- LoginPanel = require("app.ui.login.LoginPanel")
	local panel = require(conf.file)
	local panel_name_ = panel_name.."Panel"
	_G[panel_name_] = panel
	panel.create(panel_name)

end

function m.open_lua(panel_name ,conf)
	local panel = require(conf.file).new()
	local panel_name_ = panel_name
	-- _G[panel_name_] = panel
	mgr[panel_name_] = panel

	local Canvas = GameObject.FindWithTag("Canvas")
	local parent = Canvas.transform
	-- panelMgr:CreatePanel(name, this.OnCreate);
	resMgr:LoadPrefab(conf.pre_name, { panel_name }, function ( objs )
		-- body
		local go = newObject(objs[0]);
		go.name = panel_name;
		go.transform:SetParent(parent);
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = Vector3.zero;
		local lc=go:AddComponent(typeof(LuaFramework.LuaComponent))
		lc:CallAwake(panel)
		-- Util.AddLuaComponent(go,{panel})
	end)
	return panel
	-- panel.create(panel_name)
end

function m.close( name )
	-- local panel = _G[name]
	local panel = mgr[name]
	if not panel then
		return
	end
	if panel.destroy then
		panel:destroy()
	end
	-- if panel.gameObject then
		destroy(panel.go)
	-- end
	mgr[name] = nil
	-- _G[name]=nil

end

return m