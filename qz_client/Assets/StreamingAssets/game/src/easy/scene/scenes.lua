--
-- Author: wangshaopei
-- Date: 2017-04-19 15:31:15
--

local SceneManager=UnityEngine.SceneManagement.SceneManager

local m = {}
function m.load_scene(name)
	return SceneManager.LoadScene(name)
end
function m.scene_loaded(cb,badd)
	if badd then
		SceneManager.sceneLoaded = SceneManager.sceneLoaded + cb
	else
		SceneManager.sceneLoaded = SceneManager.sceneLoaded - cb
	end

end
function m.scene_unloaded(cb,badd)
	if badd then
		SceneManager.sceneUnloaded = SceneManager.sceneUnloaded + cb
	else
		SceneManager.sceneUnloaded = SceneManager.sceneUnloaded - cb
	end
end
return m