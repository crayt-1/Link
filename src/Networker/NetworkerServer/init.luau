local EventsRecorderserver = require(script.EventRecorderServer)

local NetworkerServer = {}

type Func = (any?) -> any?

function NetworkerServer:setupService(serviceName: string, service: {})
	local clientTable = service.client

	for key, value in clientTable do
		local eventInstance = EventsRecorderserver:addEvent(serviceName, key, value)
		clientTable[key] = eventInstance
			and {
				connect = function(_, func: Func): RBXScriptConnection
					return eventInstance.OnServerEvent:Connect(func)
				end,
				once = function(_, func: Func): RBXScriptConnection
					return eventInstance.OnServerEvent:Once(func)
				end,
				fire = function(_, player: Player, ...: any?)
					eventInstance:FireClient(player, ...)
				end,
				fireAll = function(_, ...: any?)
					eventInstance:FireAllClients(...)
				end,
			}
	end
end

return NetworkerServer
