-- Farms a rectangle zone with the given count of row and columns
local col_count, row_count = ...

local fuelSlot = 1
local seedSlot = 2
local storageEndSlot = 16
local refuelAmount = 1

function refuel()
	if turtle.getFuelLevel() == 0 then
		turtle.select(fuelSlot)
		if not turtle.refuel(refuelAmount) then
			print("Slot ", fuelSlot, " does not contain fuel, waiting user action...")
			while not turtle.refuel(refuelAmount) do
				sleep(1)
			end
			print("Got fuel")
		end
	end
end

function collect()
	turtle.select(seedSlot)
	turtle.digDown()
end

function plant()
	turtle.select(seedSlot)
	turtle.placeDown()
end

function forward()
	while not turtle.forward() do
		refuel()
		sleep(1)
	end
end

function farmIteration()
	collect()
	plant()
	forward()
end

for col = 1, col_count do
	for row = 1, row_count - 1 do
		print("Coordinates: ", col, ",", row)
		farmIteration()
	end
	if col ~= squareSize then
		print("Turning to next row")
		if col % 2 > 0 then
			turtle.turnRight()
			farmIteration()
			turtle.turnRight()
		else
			turtle.turnLeft()
			farmIteration()
			turtle.turnLeft()
		end
	else
end

print("I'm satisfied now :)")
