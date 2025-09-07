local ProximityPromptService = game:GetService("ProximityPromptService")
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Constants"))
local CharactersPath = Constants.CharactersPath


local MorphService = {}
MorphService.connection = nil

function MorphService:Morph(player: Player, morphName: string)
    local char = player.Character :: Model


    -- remove old morphs
    local oldMorphs = char:FindFirstChild("MorphFolder")
    if oldMorphs then
        oldMorphs:Destroy()
    end
    
     -- make player invisible
    for _, part in char:GetDescendants() do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = 1
        end
    end

    -- load the character
    local character = CharactersPath:FindFirstChild(morphName) :: Model
    if character then
        -- create a new morph folder
        local morphFolder = Instance.new("Folder")
        morphFolder.Name = "MorphFolder"
        morphFolder.Parent = char
        
        local morph = character:Clone()
        morph.Parent = morphFolder
        
        local hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart
        local hum = char:FindFirstChild("Humanoid") :: Humanoid

        local root = morph:FindFirstChild("Root") :: BasePart
        local bottomAttachment = morph:FindFirstChild("BottomAttachment") :: Attachment
        if root and bottomAttachment and hrp and hum then

            -- ALIGN MORPH FEET TO PLAYER'S FEET
            local bottomLocalY: number
            if bottomAttachment.Parent == root then
                -- attachment is on the root part; its CFrame is already local to root
                bottomLocalY = bottomAttachment.CFrame.Y
            else
                -- convert world pos of the attachment into root's local space
                local worldPos = bottomAttachment.WorldPosition
                bottomLocalY = root.CFrame:PointToObjectSpace(worldPos).Y
            end

            -- Player "foot plane" Y in HRP local space
            -- (distance from HRP center to ground = HipHeight + HRP half-height)
            local playerFootY = -(hum.HipHeight + hrp.Size.Y * 0.5)

            -- Place root so the morph's bottom lines up with the player's foot plane
            root.CFrame = hrp.CFrame * CFrame.new(0, playerFootY - bottomLocalY, 0)
            
            local weldConstraint = Instance.new("WeldConstraint")
            weldConstraint.Part0 = root
            weldConstraint.Part1 = char.HumanoidRootPart
            weldConstraint.Parent = root
        end
    end

   
end

function MorphService:StartListeningForMorph()
    if MorphService.connection then
        return
    end
    print("Starting to listen for morph")
    MorphService.connection = ProximityPromptService.PromptTriggered:Connect(function(prompt: ProximityPrompt, player: Player)
        local morphName = prompt:GetAttribute("MorphName") :: string?
        if morphName then
            MorphService:Morph(player, morphName)
        end
    end)
end

function MorphService:StopListeningForMorph()
    if MorphService.connection then
        MorphService.connection:Disconnect()
        MorphService.connection = nil
    end
end

return MorphService