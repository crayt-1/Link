local NetworkerClient = {}

local _remoteFunction: RemoteFunction = script.Parent.Events.RemoteFunction

local function _getService(_, serviceName: string)
	local methodsFromServer = {}

	while not script.Parent:GetAttribute("IsLoaded") do
		task.wait()
	end

	for _, eventInstance in script.Parent.Services:WaitForChild(serviceName, math.huge):GetChildren() do
		if eventInstance.ClassName ~= "Configuration" then
			methodsFromServer[eventInstance.Name] = eventInstance.OnClientEvent
			continue
		end
		methodsFromServer[eventInstance.Name] = function(_, ...: any?)
			return _remoteFunction:InvokeServer(serviceName, eventInstance.Name, ...)
		end
	end

	return methodsFromServer
end

return setmetatable(NetworkerClient, {
	__call = _getService,
})
