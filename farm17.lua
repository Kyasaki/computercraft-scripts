-- Wait a redstone signal, farms a 17 x 17 zone, goes back home, drops items to a chest and reset for next cycle
local fuelSlot = 1
local refuelAmount = 1
local storageStartSlot = 3
local storageEndSlot = 16
local colCount = 3
local rowCount = 3

-- Moves forward, refueling and waiting as needed
function forward()
	while not turtle.forward() do
		if turtle.getFuelAmount() == 0 then
			print("Need fuel...")
			turtle.select(fuelSlot)
			while not turtle.refuel(refuelAmount) do
				sleep(1)
			end
		else
			print("Can't move")
			sleep(1)
		end
	end
end

-- Reorient from droping items as to face farming direction
function reorient()
  turtle.turnRight()
end

-- Drop storage items in a chest, waiting as needed
function dropStorage()
  print("Dropping harvests...")
  while not turtle.detect() do
    print("Can't drop, need a chest front")
  end

  for slot = storageStartSlot,storageEndSlot do
    turtle.select(slot)
    while not turtle.place() do
      print("Not enough storage in chest, I'll be waiting")
      sleep(1)
    end
  end
end

-- Go back home after farming
function goBackHome()
  print("Going back home")
  if colCount % 2 > 0 then
    for row = 1,rowCount do
      forward()
    end
    turtle.turnRight()
  else
    turtle.turnLeft()
  end

  for col = 1,colCount do
    forward()
  end
end

-- Farm zone
function farm()
  shell.run("farm-zone", colCount, rowCount)
end

-- Wait a signal as to start farming
function waitStartSignal()
	print("Waiting start signal...")
  repeat
    os.pullEvent("redstone")
  until redstone.getInput("back")
end

while true do
  waitStartSignal()
  farm()
  goBackHome()
  dropStorage()
  reorient()
end
