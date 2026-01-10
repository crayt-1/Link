local NetworkerClient = {}

local _remoteFunction: RemoteFunction = script.Parent.Events.RemoteFunction

type Func = (any?) -> any?

function NetworkerClient:getService(_, serviceName: string)
	local serverTable = {}

	while not script.Parent:GetAttribute("IsLoaded") do
		task.wait()
	end

	for _, eventInstance in script.Parent.Services:WaitForChild(serviceName, math.huge):GetChildren() do
		if eventInstance.ClassName ~= "Configuration" then
			serverTable[eventInstance.Name] = {
				connect = function(_, func: Func): RBXScriptConnection
					return eventInstance.OnClientEvent:Connect(func)
				end,
				once = function(_, func: Func): RBXScriptConnection
					return eventInstance.OnClientEvent:Once(func)
				end,
				fire = function(_, ...)
					eventInstance:FireServer(...)
				end,
			}
			continue
		end
		serverTable[eventInstance.Name] = function(_, ...: any?)
			return _remoteFunction:InvokeServer(serviceName, eventInstance.Name, ...)
		end
	end

	return serverTable
end

return NetworkerClient
