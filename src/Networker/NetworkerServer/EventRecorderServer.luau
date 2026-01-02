local EventRecorderServer = {}

local _remoteEvent = Instance.new("RemoteEvent")
_remoteEvent.Parent = script.Parent.Parent.Events
local _unreliableRemoteEvent = Instance.new("UnreliableRemoteEvent")
_unreliableRemoteEvent.Parent = script.Parent.Parent.Events
local _remoteFunction = Instance.new("RemoteFunction")
_remoteFunction.Parent = script.Parent.Parent.Events

local _records = {}

function EventRecorderServer:addEvent(seviceName: string, eventName: string, callback: (any?) -> any? | Instance)
	if not _records[seviceName] then
		_records[seviceName] = {}
		local serviceNetworkFolder = Instance.new("Folder")
		serviceNetworkFolder.Name = seviceName
		serviceNetworkFolder.Parent = script.Parent.Parent.Services
	end

	assert(_records[seviceName][eventName] == nil, `Event {eventName} already exists in {seviceName}`)

	_records[seviceName][eventName] = callback

	local eventInstance = typeof(callback) == "function" and Instance.new("Configuration") or callback:Clone()
	eventInstance.Name = eventName
	eventInstance.Parent = script.Parent.Parent.Services[seviceName]

	return typeof(callback) == "Instance" and eventInstance
end

_remoteFunction.OnServerInvoke = function(player: Player, serviceName: string, eventName: string, ...: any?)
	assert(_records[serviceName] ~= nil, `Service {serviceName} not found`)
	assert(_records[serviceName][eventName] ~= nil, `Event {eventName} in service {serviceName} not found`)
	return _records[serviceName][eventName](player, ...)
end

return EventRecorderServer
