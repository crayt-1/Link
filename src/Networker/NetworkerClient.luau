local EventRecorderClient = require(script.EventRecorderClient)

local NetworkerClient = {}

local _remoteEvent: RemoteEvent = script.Parent.Events.RemoteEvent
local _unreliableRemoteEvent: UnreliableRemoteEvent = script.Parent.Events.UnreliableRemoteEvent
local _remoteFunction: RemoteFunction = script.Parent.Events.RemoteFunction

local function _getService(self, serviceName: string)
	local methodsFromServer = {}

	while not script.Parent:GetAttribute("IsLoaded") do
		task.wait()
	end

	for _, eventInstance in script.Parent.Services:WaitForChild(serviceName, math.huge):GetChildren() do
		if eventInstance.ClassName ~= "Configuration" then
			methodsFromServer[eventInstance.Name] = eventInstance
			continue
		end
		methodsFromServer[eventInstance.Name] = function(self, ...: any?)
			return _remoteFunction:InvokeServer(serviceName, eventInstance.Name, ...)
		end
	end

	return methodsFromServer
end

function NetworkerClient:setupController(controllerName: string, controller: {})
	local serverTable = controller.server

	for key, value in serverTable do
		serverTable[key] = function(self, ...: any?)
			EventRecorderClient:addEvent(controllerName, key, value)
		end
	end
end

return setmetatable(NetworkerClient, {
	__call = _getService,
})
