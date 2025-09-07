local React = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("react"))
local ReactRoblox = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("react-roblox"))
local MorphUIApp = require(script.Parent:WaitForChild("MorphUI"):WaitForChild("App"))

local UIService = {}
UIService.morphUI = nil :: ScreenGui?
UIService.mainUI = nil :: ScreenGui?

local player = game.Players.LocalPlayer

function UIService:Init()
    -- MORPH UI
    local morphUI = Instance.new("ScreenGui")
    morphUI.Name = "MorphUI"
    morphUI.Parent = player.PlayerGui
    UIService.morphUI = morphUI
    morphUI.Enabled = false
    
    local morphRoot = ReactRoblox.createRoot(morphUI)
    morphRoot:render(React.createElement(MorphUIApp))
    
    -- MAIN UI
    local mainUI = Instance.new("ScreenGui")
    mainUI.Name = "MainUI"
    mainUI.Parent = player.PlayerGui
    UIService.mainUI = mainUI
end

function UIService:ShowMorphUI()
    UIService.morphUI.Enabled = true
end

function UIService:HideMorphUI()
    UIService.morphUI.Enabled = false
end

return UIService