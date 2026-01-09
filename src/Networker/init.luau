local RunService = game:GetService("RunService")

if RunService:IsServer() then
	local eventsFolder = Instance.new("Folder")
	eventsFolder.Name = "Events"
	eventsFolder.Parent = script

	local servicesFolder = Instance.new("Folder")
	servicesFolder.Name = "Services"
	servicesFolder.Parent = script
end

return RunService:IsServer() and require(script.NetworkerServer) or require(script.NetworkerClient)
