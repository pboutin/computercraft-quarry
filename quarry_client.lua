rednet.open("right")

function main()
    print("Specify the width")
    local width = tonumber(read())

    print("Specify the depth")
    local depth = tonumber(read())

    local height = 3

    local switch = true
    local count = 0

    for x = 1, width do
        for y = 1, depth do
            turtle.digUp()
            turtle.dig()
            turtle.digDown()
            count = count + 3

            checkInventory()
            checkFuel()

            local status = getFormattedStatus(count, width * depth * height)
            rednet.broadcast(status)
            term.clear()
            print(status)

            turtle.forward()
        end

        turtle.digUp()
        turtle.digDown()

        if x < width then
            if switch then
                turtle.turnRight()
                turtle.dig()
                turtle.forward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.dig()
                turtle.forward()
                turtle.turnLeft()
            end
            count = count + 1
        end

        switch = not switch
    end

    clearInventory()

    if width % 2 == 0 then
        turtle.turnRight()
        for i = 1, width - 1 do
            turtle.forward()
        end
    else
        turtle.turnLeft()
        for i = 1, width - 1 do
            turtle.forward()
        end
        turtle.turnLeft()
        for i = 1, depth - 1 do
            turtle.forward()
        end
    end
end

function checkInventory()
    local requireCleanup = true
    local index = 3

    while index <= 16 and requireCleanup do
        if turtle.getItemCount(index) == 0 then
            requireCleanup = false
        end
        index = index + 1
    end

    if requireCleanup then
        clearInventory()
    end
end

function clearInventory()
    while turtle.digUp() do end

    turtle.select(2)
    turtle.placeUp()

    for i = 3, 16 do
        turtle.select(i)
        turtle.dropUp()
    end

    turtle.select(2)
    turtle.digUp()
end

function checkFuel()
    local fuelPerShot = 5
    local fuelQuantity = turtle.getItemCount(1)
    if (turtle.getFuelLevel() < 500) and (fuelQuantity > 1) then
        turtle.select(1)
        if fuelQuantity > fuelPerShot then
            turtle.refuel(fuelPerShot)
        else
            turtle.refuel(fuelQuantity - 1)
        end
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
