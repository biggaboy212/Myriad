--!nocheck
--!nolint

return function()
	local indexedAnimate, Animate = pcall(function() return game.Players.LocalPlayer.Character.Animate end)
	if not getscripthash then
		return {
			status = 400,
			message = "Global not found",
		}
	elseif not indexedAnimate then
		return {
			status = 401,
			message = "Testing dependency 'Animate' not found.",
		}
	end

	local noBytecodeScript = Instance.new("LocalScript")
	local animateSuccess, animateReturned = pcall(function()
		return getscripthash(Animate)
	end)
	local noBytecodeSuccess, noBytecodeReturned = pcall(function()
		return getscripthash(noBytecodeScript)
	end)

	if not animateSuccess then
		return {
			status = 500,
			message = "Failed to get bytecode of 'Animate': " .. animateReturned,
		}
	elseif not noBytecodeSuccess then
		return {
			status = 500,
			message = "Failed to get script w/ no bytecode. Errored instead of returning nil.",
		}
	elseif typeof(animateReturned) ~= "string" then
		return {
			status = 500,
			message = "Did not return a hash string",
		}
	elseif hashNoBytecode ~= nil then
		return {
			status = 500,
			message = "A script with no bytecode returned non-nil data",
		}
	end

	local newAnimate = Animate:Clone()
	local oldSource = Animate.Source
	Animate.Source = "return 1"
	local newHash = getscripthash(Animate)

	if animateReturned == newHash then
		return {
			status = 500,
			message = "Gave the same hash for a modified script",
		}
	end

	Animate.Source = oldSource

	--// Alias test
	local envIndex, failedIndex = require("@dependencies/aliasTest.luau")({})

	if not envIndex then
		return {
			status = 501,
			message = `Alias not found: {failedIndex}`,
		}
	end

	return {
		status = 200,
		message = `Passed`,
	}
end
