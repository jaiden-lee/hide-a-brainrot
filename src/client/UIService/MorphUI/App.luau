local React = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("react"))
local UserInputService = game:GetService("UserInputService")

function App()
    local text = "Press E to morph"
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        text = "Tap to morph"
    end


    return React.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
    }, {
        React.createElement("TextLabel", {
            Size = UDim2.fromScale(0.5, 0.1),
            Position = UDim2.fromScale(0.25, 0.75),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            FontFace = Font.fromEnum(Enum.Font.Cartoon),
        })
    })
end

return App