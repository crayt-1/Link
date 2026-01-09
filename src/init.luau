local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterGui = game:GetService("StarterGui")

local Networker = require(script.Networker)
local Events = require(script.Events)

local PARALLEL_TAG = workspace:GetAttribute("ParallelTag") or "parallel"
local ENVIRONMENT = RunService:IsServer() and "Server" or "Client"

local Link = {}

local _actors = {}
local _isInited: boolean = false
local _modulesToLoad = 0

local _actorsFolder = Instance.new("Folder")
_actorsFolder.Name = "Actors"
_actorsFolder.Parent = ENVIRONMENT == "Server" and ServerScriptService or ReplicatedStorage

local _uiFolder = ENVIRONMENT == "Client" and script:FindFirstChild("UIContainer") or Instance.new("Folder")
_uiFolder.Name = "UIContainer"
_uiFolder.Parent = script

Link.Networker = Networker
Link.Events = Events
Link.onStart = nil :: (() -> ())?
Link.onInit = nil :: (() -> ())?

local function _loadModule(module: ModuleScript)
	if module.Name:match(`.{PARALLEL_TAG}`) then
		local actor = Instance.new("Actor")
		actor.Name = `{module.Name}Actor`
		actor.Parent = _actorsFolder

		local loader: Script = script.Loader:Clone()
		loader.RunContext = Enum.RunContext[ENVIRONMENT]
		loader.Enabled = false
		loader.Name = `{module.Name}Loader`
		loader.Parent = actor
		module.Parent = loader
		loader.Enabled = true

		_actors[module.Name] = actor
		_modulesToLoad -= 1
		return
	end

	local loadedModule = require(module)
	local isTable = typeof(loadedModule) == "table"
	local isShouldInit = not _isInited and isTable and typeof(loadedModule.init) == "function"
	local isShouldStart = _isInited and isTable and typeof(loadedModule.start) == "function"

	if ENVIRONMENT == "Server" and not _isInited and typeof(loadedModule.client) == "table" then
		Networker:setupService(module.Name, loadedModule)
	end

	if isShouldInit then
		loadedModule:init()
	elseif isShouldStart then
		loadedModule:start()
	end

	_modulesToLoad -= 1
end

local function _deepLoad(modules: Instance)
	for _, module in modules:GetDescendants() do
		if not module:IsA("ModuleScript") then
			_modulesToLoad -= 1
			continue
		end
		task.spawn(_loadModule, module)
	end
end

function Link.load(modules: Instance)
	local events: ModuleScript | Instance = ReplicatedStorage:FindFirstChild("Events")
	if events and events:IsA("ModuleScript") then
		events = events :: ModuleScript
		require(events)
	end

	if ENVIRONMENT == "Server" then
		for _, gui in StarterGui:GetChildren() do
			gui.Parent = _uiFolder
		end
	else
		local playerGui = Players.LocalPlayer.PlayerGui
		for _, gui in _uiFolder:GetChildren() do
			gui.Parent = playerGui
		end
	end

	_modulesToLoad = #modules:GetDescendants()

	_deepLoad(modules) -- Initialize modules and network

	repeat
		task.wait()
	until _modulesToLoad == 0

	_isInited = true
	script.Networker:SetAttribute("IsLoaded", true)

	if Link.onInit then
		task.spawn(Link.onInit)
	end

	_modulesToLoad = #modules:GetDescendants()

	_deepLoad(modules) -- Start modules

	repeat
		task.wait()
	until _modulesToLoad == 0

	if Link.onStart then
		task.spawn(Link.onStart)
	end
end

return Link
