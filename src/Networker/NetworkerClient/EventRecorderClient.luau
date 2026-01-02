local EventRecorderClient = {}

local _remoteEvent: RemoteEvent = script.Parent.Parent.Events:WaitForChild("RemoteEvent", math.huge)
local _unreliableRemoteEvent: UnreliableRemoteEvent =
	script.Parent.Parent.Events:WaitForChild("UnreliableRemoteEvent", math.huge)
local _remoteFunction: RemoteFunction = script.Parent.Parent.Events:WaitForChild("RemoteFunction", math.huge)

local _records = {}

function EventRecorderClient:addEvent(controllerName: string, eventName: string, callback: (any?) -> any?)
	if not _records[controllerName] then
		_records[controllerName] = {}
	end

	assert(_records[controllerName][eventName] == nil, `Event {eventName} already exists in {controllerName}`)

	_records[controllerName][eventName] = callback
end

_remoteFunction.OnClientInvoke = function(player: Player, controllerName: string, eventName: string, ...: any?)
	assert(_records[controllerName] ~= nil, `Controller {controllerName} not found`)
	assert(_records[controllerName][eventName] ~= nil, `Event {eventName} in controller {controllerName} not found`)
	return _records[controllerName][eventName](...)
end

return EventRecorderClient
