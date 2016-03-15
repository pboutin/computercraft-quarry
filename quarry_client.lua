rednet.open("right")

function main()
    print("Enter the width")
    local width = tonumber(read())

    print("Enter the depth")
    local depth = tonumber(read())

    print("How many layers ? (1 layer = 3 blocs)")
    local layers = tonumber(read())

    local totalBlocs = width * depth * layers * 3;

    local switch = true
    local progress = 1

    checkFuel()
    turtle.up()

    for z = 1, layers do
        for x = 1, width do
            for y = 2, depth do
                turtle.dig()
                turtle.digUp()
                turtle.digDown()

                progress = progress + 1

                checkInventory()
                checkFuel()

                rednet.broadcast(getFormattedStatus(progress * 3, totalBlocs))

                safeForward()
            end

            turtle.digUp()
            turtle.digDown()

            progress = progress + 1

            if x < width then
                if switch then
                    turtle.turnRight()
                    turtle.dig()
                    sleep(1)
                    safeForward()
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                    turtle.dig()
                    sleep(1)
                    safeForward()
                    turtle.turnLeft()
                end
                switch = not switch
            end
        end

        if z < layers then
            turtle.turnLeft()
            turtle.turnLeft()
            turtle.down()
            turtle.digDown()
            turtle.down()
            turtle.digDown()
            turtle.down()
        end
    end

    clearInventory()

    for i = 2, (layers - 1) * 3 do
        turtle.up()
    end

    if layers % 2 == 1 then
        if width % 2 == 0 then
            turtle.turnRight()
            for i = 1, width - 1 do
                turtle.forward()
            end
            turtle.turnLeft()
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

    safeForward()
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

function safeForward()
    while not turtle.forward() do
        turtle.dig()
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
