rednet.open("right")
local tArgs = { ... }

function main(prefix)
    local clients = {}
    term.clear()
    term.setCursorPos(1, 1)
    term.write("Waiting for a client...")

    while true do
        id, message = rednet.receive()

        if compareStrings(message, "quarry_client") then
            e, client, fuel, progress, total = message:match("([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")

            if compareStrings(client, prefix) then
                clients[client] = {fuel, progress, total}
                refreshDisplayFor(clients)
            end
        end

        sleep(.1)
    end
end

function refreshDisplayFor(clients)
    local ordered_clients = {}
    for key in pairs(clients) do
        table.insert(ordered_clients, key)
    end

    table.sort(ordered_clients)

    term.clear()
    local screenPos = 3
    local screenWidth, screenHeight = term.getSize()

    local progressWidth = screenWidth - 4

    term.setCursorPos(2, 1)
    term.write("Following " .. #ordered_clients .. " client" .. (#ordered_clients > 1 and "s" or ""))

    for i = 1, #ordered_clients do
        local client, values = ordered_clients[i], clients[ordered_clients[i]]

        term.setCursorPos(2, screenPos)
        local fuel = tonumber(values[1])
        term.write(client .. " : " .. fuel .. " fuel" .. (fuel > 1 and "s" or ""))
        screenPos = screenPos + 1

        term.setCursorPos(2, screenPos)
        local progress = tonumber(values[2]) / tonumber(values[3])
        term.write(values[2] .. " / " .. values[3] .. " blocs mined (" .. math.floor(progress * 100) .. "%)")
        screenPos = screenPos + 1

        term.setCursorPos(2, screenPos)
        term.write("[")
        for prg = 1, progressWidth do
            if (prg / progressWidth) <= progress then
                term.write("#")
            else
                term.write(" ")
            end
        end
        term.write("]")

        screenPos = screenPos + 2
    end
end

-- Check if a starts with b
function compareStrings(a, b)
    if b == "" then
        return true
    end
    return string.sub(a, 1, string.len(b)) == b
end

if #tArgs == 0 then
    main("")
else
    main(tArgs[1])
end
