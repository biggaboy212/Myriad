--!nocheck
--!nolint

return function()
	if not identifyexecutor then
		return {
			status = 400,
			message = "Global not found",
		}
	end

	--// Functionality Test
	local executor, vers = identifyexecutor()
    if not executor or not vers then
        return {
			status = 500,
			message = `Did not return expected data (executor, version)`,
		}
	elseif type(executor) ~= "string" or type(vers) ~= "string" then
		return {
			status = 500,
			message = `Expected [string, string] got [{executor}, {vers}]`,
		}
	end

	--// Alias test
	local envIndex, failedIndex = require("@dependencies/aliasTest.luau")({
		"getexecutorname"
	})

	if not envIndex then
		return {
			status = 501,
			message = `Alias not found: {failedIndex}`,
		}
	end

	return {
		status = 200,
		message = `Passed ({executor}, {vers})`,
	}
end
