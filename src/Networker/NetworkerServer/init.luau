local EventsRecorderserver = require(script.EventRecorderServer)

local NetworkerServer = {}

local _remoteFunction: RemoteFunction = script.Parent.Events.RemoteFunction

function NetworkerServer:setupService(serviceName: string, service: {})
	local clientTable = service.client

	for key, value in clientTable do
		local eventInstance = EventsRecorderserver:addEvent(serviceName, key, value)
		clientTable[key] = eventInstance
			and {
				Connect = function(self: typeof(clientTable), callback: (any?) -> any?): RBXScriptConnection
					return eventInstance.OnServerEvent:Connect(callback)
				end,
				Once = function(self: typeof(clientTable), callback: (any?) -> any?): RBXScriptConnection
					return eventInstance.OnServerEvent:Once(callback)
				end,
				Fire = function(self: typeof(clientTable), player: Player, ...)
					eventInstance:FireClient(player, ...)
				end,
				FireAll = function(self: typeof(clientTable), ...)
					eventInstance:FireAllClients(...)
				end,
			}
	end
end

return NetworkerServer
