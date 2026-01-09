local ServerNetworkTypes = require(script.Parent.Networker.ServerNetworkTypes)
return {
	RemoteEvent = Instance.new("RemoteEvent") :: ServerNetworkTypes.ServerEvent,
	UnreliableRemoteEvent = Instance.new("UnreliableRemoteEvent") :: ServerNetworkTypes.ServerEvent,
	--RemoteFunction = Instance.new("RemoteFunction") :: ServerNetworkTypes.ServerEvent,
}
