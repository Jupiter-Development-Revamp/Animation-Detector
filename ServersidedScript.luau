-- Place inside ServerScriptService
--[[
    Project: Animation Detector;
    Developers: StyxDeveloper;
    Description: Detects bad animations (Server-Sided);
    Version: v1.0;
    Update Date: 4/29/2025;
    -- Monitors animations played and checks against a blacklisted one.
    -- Implement this into your game, feel free to add credits to us (makes this findable)
]]

-- Banned Animation IDs
local BAD_ANIMATION_IDS = {
	["rbxassetid://72042024"] = true;
	["rbxassetid://698251653"] = true;
	["rbxassetid://148840371"] = true;
	["rbxassetid://5918726674"] = true;
};
local function onCharacterAdded(player: Player, character: Model)
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	if not humanoid then return; end;
	local animationConnection
	animationConnection = humanoid.AnimationPlayed:Connect(function(track)
		local animId = track.Animation and track.Animation.AnimationId or "unknown";
		if BAD_ANIMATION_IDS[animId] then
			warn("[ANIMATION BAN] " .. player.Name .. " attempted to play a banned animation: " .. animId);
			player:Kick("Inappropriate animation detected.");
		end;
	end);
	character.AncestryChanged:Connect(function(_, parent)
		if not parent then
			animationConnection:Disconnect();
		end
	end);
end;

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character);
	end);
	if player.Character then
		onCharacterAdded(player, player.Character);
	end;
end);
