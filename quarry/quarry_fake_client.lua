rednet.open("right")

function main()
    local fakeCount = 0

    while true do
        local status = getFormattedStatus(fakeCount, 100)
        rednet.broadcast(status)
        term.clear()
        term.setCursorPos(1, 1)
        term.write(status)

        if fakeCount == 100 then
            fakeCount = 0
        else
            fakeCount = fakeCount + 1
        end

        sleep(1)
    end
end


function getFormattedStatus(minedBlocs, totalBlocs)
    local message = "quarry_client"
    message = message .. "," .. os.getComputerLabel()
    message = message .. "," .. turtle.getItemCount(1)
    message = message .. "," .. minedBlocs
    message = message .. "," .. totalBlocs
    return message
end

main()
