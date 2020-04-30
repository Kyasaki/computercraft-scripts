-- updatable globals
stopOnNoSlotAvailable = true -- if true, the turtle will wait until some slot is available before digging
refuelAmount = 1 -- amount of fuel consumed when out of energy
junkSlotCount = 3 -- Number of junk slots
actionWaitDuration = 5 -- Number of seconds between checks for human intervention

-- generated globals
junkEndSlot = junkStartSlot + junkSlotCount - 1
storageStartSlot = junkEndSlot + 1

-- program globals
storageEndSlot = 16 -- End slot of stored items
junkStartSlot = 1 -- Id of the first slot to contain items that will be thrown away when full

-- functions --

-- Returns whether there is a free slot or not.
function hasFreeSlot()
	for i = storageStartSlot,storageEndSlot do
		if turtle.getItemCount(i) == 0 then
			return true
		end
	end
	return false
end

-- Retrurns whether or not the current selected slot contains junk
function isCurrentSlotContentJunk()
	if junkSlotCount == 0 then
		return false
	end

	-- compare to junk slots
	for i = junkStartSlot,junkEndSlot do
		if turtle.compareTo(i) then
			return true
		end
	end
	return false
end

-- Drops stacks where items are detected as useless
function dropJunk()
	print("cleaning junk slots...")
	-- clean junk slot, but keep one item for testing
	for i = junkStartSlot,junkEndSlot do
		print(i)
		turtle.select(i)
		if turtle.getItemCount(i) > 1 then
			turtle.dropDown(turtle.getItemCount(i) - 1)
		end
	end

	print("cleaning content slots...")
	-- clean content slots
	for i = storageStartSlot,storageEndSlot do
		turtle.select(i)
		if isCurrentSlotContentJunk() then
			turtle.dropDown()
		end
	end

	-- reset selection
	turtle.select(1)
end

-- Checks whether there is a free slot or not. Tries to drop useless materials if not. Only returns on success.
function canDig()
	if not stopOnNoSlotAvailable then
		return true
	end

	if not hasFreeSlot() then
		dropJunk()
	else
		return true
	end

	if not hasFreeSlot() then
		print("No more slots available. Polling user action.")
		while not hasFreeSlot() do
			os.sleep(actionWaitDuration)
		end
	end
	return true
end

-- Digs as far as possible top, forward, then bottom.
function digAround()
	-- up
	while turtle.detectUp() and canDig() do
		turtle.digUp()
	end

	-- forward
	while turtle.detect() and canDig() do
		turtle.dig()
	end

	-- down
	while turtle.detectDown() and canDig() do
		turtle.digDown()
	end
end

-- Tries make the turtle fuel level non-0. Returns false on fail.
function refuel()
	-- if fuel level not empty returns true
	if not turtle.getFuelLevel() == 0 then
		return true
	end

	-- search for fuel
	for i = storageStartSlot,storageEndSlot do
		turtle.select(i)
		if turtle.refuel(refuelAmount) then
			turtle.select(1) -- reset selection
			return true
		end
	end

	turtle.select(1)
	return false
end

-- Digs around, then do all the possible to go forward. Returns only on success.
function goForward()
	digAround()
	while not turtle.forward() do
		if turtle.getFuelLevel() == 0 then -- stuck for fuel reasons
			if not refuel() then
				print("Could not refuel. Polling user action.")
				while not refuel() do
					os.sleep(actionWaitDuration)
				end
			end
		elseif turtle.detect() then -- stuck because of an anoying block front.
			print("Annoying block detected front. Erasing him from the universe.")
			digAround()
		else -- stuck for an unknown reason
			print("Stuck for an unknown reason. Waiting for user action.")
			os.sleep(actionWaitDuration)
		end
	end
end

-- Digs a 3x3x2 tunnel
function dig3x3Zone()
	print "Starting dig cycle"

	goForward()
	turtle.turnRight()
	goForward()
	goForward()
	turtle.turnLeft()
	goForward()
	turtle.turnLeft()
	goForward()
	goForward()
	turtle.turnRight()
end

-- infinitly digs tunnel
while true do dig3x3Zone() end
