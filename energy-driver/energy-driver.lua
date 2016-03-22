local status = false
local inputSide = "left"
local outputSide = "right"

while true do
    local signal = redstone.getAnalogInput(inputSide)

    if signal <= 2 then
        status = false
        redstone.setOutput(outputSide, status)
    end

    if signal >= 14 then
        status = true
        redstone.setOutput(outputSide, status)
    end

    term.clear()
    term.setCursorPos(1, 1)
    term.write("Current status : " .. (status and "On" or "Off"))
    term.setCursorPos(1, 2)
    term.write("Input level : " .. signal .. "/15")

    sleep(5)
end
