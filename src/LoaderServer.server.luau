local module = script:FindFirstChildWhichIsA("ModuleScript")

if module then
	local loadedModule = require(module)
	local isTable = typeof(loadedModule) == "table"
	local hasInit = isTable and typeof(loadedModule.init) == "function"
	local hasStart = isTable and typeof(loadedModule.start) == "function"

	task.desynchronize()

	if hasInit then
		loadedModule:init()
	end
	if hasStart then
		loadedModule:init()
	end
else
	script.Enabled = false
end
