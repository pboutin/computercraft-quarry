rednet.open("right")

function main()
    print("Enter the width")
    local width = tonumber(read())

    print("Enter the depth")
    local depth = tonumber(read())

    local switch = true
    local progress = 1

    checkFuel()

    for x = 1, width do
        for y = 2, depth do
            turtle.digDown()

            selectBloc()
            turtle.placeDown()

            checkFuel()

            turtle.forward()
        end

        turtle.digDown()

        selectBloc()
        turtle.placeDown()

        if x < width then
            if switch then
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.forward()
                turtle.turnLeft()
            end
            switch = not switch
        end
    end
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

function selectBloc()
    local index = 2
    while (index <= 16) and (turtle.getItemCount(index) == 0) do
        index = index + 1
    end
    turtle.select(index)
end

main()
