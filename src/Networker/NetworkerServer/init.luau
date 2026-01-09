local EventsRecorderserver = require(script.EventRecorderServer)

local NetworkerServer = {}

type Func = (any?) -> any?

function NetworkerServer:setupService(serviceName: string, service: {})
	local clientTable = service.client

	for key, value in clientTable do
		local eventInstance = EventsRecorderserver:addEvent(serviceName, key, value)
		clientTable[key] = eventInstance
			and {
				Connect = function(_, func: Func): RBXScriptConnection
					return eventInstance.OnServerEvent:Connect(func)
				end,
				Once = function(_, func: Func): RBXScriptConnection
					return eventInstance.OnServerEvent:Once(func)
				end,
				Fire = function(_, player: Player, ...)
					eventInstance:FireClient(player, ...)
				end,
				FireAll = function(_, ...)
					eventInstance:FireAllClients(...)
				end,
			}
	end
end

return NetworkerServer
