local NetworkerClient = {}

local _remoteFunction: RemoteFunction = script.Parent.Events.RemoteFunction

function NetworkerClient:getService(_, serviceName: string)
	local methodsFromServer = {}

	while not script.Parent:GetAttribute("IsLoaded") do
		task.wait()
	end

	for _, eventInstance in script.Parent.Services:WaitForChild(serviceName, math.huge):GetChildren() do
		if eventInstance.ClassName ~= "Configuration" then
			methodsFromServer[eventInstance.Name] = {
				Connect = function(callback: (any?) -> any?): RBXScriptConnection
					return eventInstance.OnClientEvent:Connect(callback)
				end,
				Once = function(callback: (any?) -> any?): RBXScriptConnection
					return eventInstance.OnClientEvent:Once(callback)
				end,
				Fire = function(...)
					eventInstance:FireServer(...)
				end,
			}
			continue
		end
		methodsFromServer[eventInstance.Name] = function(_, ...: any?)
			return _remoteFunction:InvokeServer(serviceName, eventInstance.Name, ...)
		end
	end

	return methodsFromServer
end

return NetworkerClient
