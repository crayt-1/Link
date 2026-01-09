local EventsRecorderserver = require(script.EventRecorderServer)

local NetworkerServer = {}

local _remoteFunction: RemoteFunction = script.Parent.Events.RemoteFunction

function NetworkerServer:setupService(serviceName: string, service: {})
	local clientTable = service.client

	for key, value in clientTable do
		clientTable[key] = EventsRecorderserver:addEvent(serviceName, key, value)
	end
end

return NetworkerServer
