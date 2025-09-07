local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local MorphServiceAPI = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("MorphService"):WaitForChild("API"))
local UIService = require(script.Parent.Parent:WaitForChild("UIService"):WaitForChild("Client"))

local MorphService = {}
MorphService.highlight = nil :: Highlight?
MorphService.currentPrompt = nil :: ProximityPrompt?
MorphService.connections = nil :: {[string]: RBXScriptSignal}?

local player = game.Players.LocalPlayer :: Player
local mouse = player:GetMouse() :: Mouse

function createHighlight()
    if MorphService.highlight then
        return MorphService.highlight
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MorphHighlight"
    highlight.Parent = game.Workspace
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.FillTransparency = 0.75
    MorphService.highlight = highlight

    return highlight
end

function showHighlight(model: Model)
    local highlight = createHighlight()
    highlight.Enabled = true
    highlight.Adornee = model
    UIService:ShowMorphUI()
end

function hideHighlight()
    local highlight = createHighlight()
    highlight.Enabled = false
    highlight.Adornee = nil
    UIService:HideMorphUI()
end

function MorphService:BindHighlight()
    if MorphService.connections then
        return
    end

    MorphService.connections = {}

    MorphService.connections.promptShown = ProximityPromptService.PromptShown:Connect(function(prompt: ProximityPrompt)
        MorphService.currentPrompt = prompt
        if prompt.Parent and prompt.Parent.Parent then
            showHighlight(prompt.Parent.Parent :: Model) 
            -- always 2 parents above; since root is always direct child of the model
        end
    end)

    MorphService.connections.promptHidden = ProximityPromptService.PromptHidden:Connect(function(prompt: ProximityPrompt)
        if MorphService.currentPrompt == prompt then
            MorphService.currentPrompt = nil
            hideHighlight()
        end
    end)


    MorphService.connections.highlightClicked = UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
        if gameProcessedEvent then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 and MorphService.currentPrompt then
            local adornee = MorphService.highlight and MorphService.highlight.Adornee
            if adornee and mouse.Target:IsDescendantOf(adornee) then
                local morphName = MorphService.currentPrompt:GetAttribute("MorphName") :: string?
                if morphName then
                    MorphServiceAPI.HandleMorph:Fire(morphName)
                end
            end
        end
    end)
end

function MorphService:UnbindHighlight()
    for _, connection in MorphService.connections do
        connection:Disconnect()
    end
    MorphService.connections = nil
end

return MorphService