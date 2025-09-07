local ProximityPromptService = game:GetService("ProximityPromptService")
local MorphService = {}
MorphService.highlight = nil
MorphService.currentPrompt = nil
MorphService.connections = {}

function createHighlight()
    if MorphService.highlight then
        return MorphService.highlight
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MorphHighlight"
    highlight.Parent = game.Workspace
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    MorphService.highlight = highlight

    return highlight
end

function showHighlight(model: Model)
    local highlight = createHighlight()
    highlight.Enabled = true
    highlight.Adornee = model
end

function hideHighlight()
    local highlight = createHighlight()
    highlight.Enabled = false
    highlight.Adornee = nil
end

function MorphService:BindHighlight()
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
end

function MorphService:UnbindHighlight()
    for _, connection in MorphService.connections do
        connection:Disconnect()
    end
    MorphService.connections = {}
end

return MorphService