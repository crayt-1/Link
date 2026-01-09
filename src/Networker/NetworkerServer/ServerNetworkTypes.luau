type Callback = (any?) -> any?

export type ServerEvent = {
	Connect: (ServerEvent, Callback, ...any?) -> RBXScriptConnection,
	Once: (ServerEvent, Callback, ...any?) -> RBXScriptConnection,
	Fire: (ServerEvent, Player, ...any?) -> (),
	FireAll: (ServerEvent, ...any?) -> (),
}

return nil
