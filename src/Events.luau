type Callback = (any?) -> any?

export type ServerEvent = {
	Connect: (ServerEvent, Callback, ...any?) -> RBXScriptConnection,
	Once: (ServerEvent, Callback, ...any?) -> RBXScriptConnection,
	Fire: (ServerEvent, Player, ...any?) -> (),
	FireAll: (ServerEvent, ...any?) -> (),
}

return {
	RemoteEvent = Instance.new("RemoteEvent") :: ServerEvent,
	UnreliableRemoteEvent = Instance.new("UnreliableRemoteEvent") :: ServerEvent,
}
