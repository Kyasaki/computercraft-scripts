-- Farms a rectangle zone with the given count of row and columns
-- Digs columns left to right

-- User settings --
local fuelSlot = 1
local seedSlot = 2

-- Internal constants --
local storageEndSlot = 16
local refuelAmount = 1

-- Functions --

-- Refuels the turtle if needed, waiting operator intervention if none available
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

-- Picks the ressource down and places a seed in its place
function farm()
	turtle.select(seedSlot)
	turtle.digDown()
	turtle.placeDown()
end

-- Moves forward, or wait until fueled or space front is free
function forward()
	while not turtle.forward() do
		refuel()
		sleep(1)
	end
end

-- parse arguments
local colCount, rowCount = ...
if colCount == nil or tonumber(colCount) == nil or rowCount == nil or tonumber(rowCount) == nil then
	error("Usage: farm-zone <width> <depth>")
end
colCount = tonumber(colCount)
rowCount = tonumber(rowCount)

-- farm zone
for col = 1, colCount do
	farm()
	for row = 1, rowCount - 1 do
		forward()
		farm()
	end
	if col < colCount then
		if col % 2 > 0 then
			turtle.turnRight()
			forward()
			turtle.turnRight()
		else
			turtle.turnLeft()
			forward()
			turtle.turnLeft()
		end
	end
end

-- reorient for next travel
turtle.turnRight()
turtle.turnRight()

-- done
print("Succesfully farmed zone!")
