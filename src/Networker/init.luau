return game:GetService("RunService"):IsServer() and require(script.NetworkerServer) or require(script.NetworkerClient)
