--!nocheck
--!nolint

return function()
	if not getgc then
		return {
			status = 400,
			message = "Global not found",
		}
	end

    local originalTable = {}
    local function originalFunction() end
    task.wait(0.1)

    local check1
    local check2
    for _, value in pairs(getgc(true)) do
        if value == originalFunction then
            check1 = true
        elseif value == originalTable then
            check2 = true
        end
    end

    if not check1 then
        return {
            status = 500,
            message = "Original function not found",
        }
    elseif not check2 then
        return {
            status = 500,
            message = "Original table not found",
        }
    end

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
