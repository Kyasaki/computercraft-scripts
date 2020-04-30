-- Wait a redstone signal, farms a 17 x 17 zone, goes back home, drops items to a chest and reset for next cycle
local fuelSlot = 1
local seedSlot = 2
local storageStartSlot = 3
local storageEndSlot = 16
local refuelAmount = 1
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

-- Drops all seeds but one in a top chest, and the harvested ressources to a chest front
function dropStorage()
  print("Dropping harvests...")
  while not turtle.detect() do
    print("Can't drop, need a chest front")
  end
  while not turtle.detectUp() do
    print("Can't drop, need a chest up")
  end

  for slot = storageStartSlot,storageEndSlot do
    if turtle.getItemCount(slot) > 0 then
      turtle.select(slot)
      if turtle.compareTo(seedSlot) then
        while not turtle.dropUp() do
          print("Not enough storage in up chest, waiting")
          sleep(1)
        end
      else
        while not turtle.drop() do
          print("Not enough storage in front chest, waiting")
          sleep(1)
        end
      end
    end
  end
end

-- Go back home after farming
function goBackHome()
  print("Going back home")
  if colCount % 2 > 0 then
    for row = 1,rowCount - 1 do
      forward()
    end
    turtle.turnRight()
  else
    turtle.turnLeft()
  end

  for col = 1,colCount - 1 do
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
  until not redstone.getInput("back")
end

while true do
  waitStartSignal()
  farm()
  goBackHome()
  dropStorage()
  reorient()
end
