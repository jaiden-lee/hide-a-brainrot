local Packet = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("packet"))

local MorphServiceAPI = {}

-- HandleMorph(morphName: string) -> boolean
MorphServiceAPI.HandleMorph = Packet("HandleMorph", Packet.String)

return MorphServiceAPI