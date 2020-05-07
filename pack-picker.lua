-- Picks some items by multiple of 9 in top inventory and places them in the bottom inventory
-- Purges items left when a redstone signal is detected back

local startSlot = 1
local endSlot = 16
local packAmount = 9
local transferedItems -- keep track of the possibility to transfer again
local currentSlot

-- Purges inventory to left storage when a redstone signal is active back
-- Makes sure to not affect the currently selected slot between executions
-- To be called at the most critical points in program as to maximise chances of catching
function detectPurge()
  if redstone.getInput("back") then
    print("Detected purge signal, purging to left side...")
    turtle.turnLeft()
    for slot = startSlot,endSlot do
      turtle.select(slot)
      turtle.drop()
    end
    turtle.turnRight()
    print("Purge succesful")
    turtle.select(currentSlot)
  end
end

-- Sets the current slot. Used as to polyfill turtle.getSelectedSlot()
-- Detects purge signals
function selectSlot(slot)
  detectPurge()
  if turtle.select(slot) then
    currentSlot = slot
    return true
  else
    return false
  end
end

-- Waits some time when blocked by an external operation
-- Detects purge signals
function wait()
  sleep(1)
  detectPurge()
end

-- Selects a slot and drops packs of the selected slot when possible
function dropPacks(slot)
  selectSlot(slot)
  while turtle.getItemCount(slot) >= packAmount do
    print("Pack available in slot ", slot)
    if not turtle.dropDown(packAmount) then -- wait packer is emtpy
      print("Waiting pack machine...")
      while not turtle.dropDown(packAmount) and turtle.getItemCount(slot) ~= 0 do
        wait()
      end
    end
    print("Pack droped")
  end
end

while true do
  for slot = startSlot,endSlot do
    print("Packing priority to slot ", slot)
    transferedItems = true

	repeat -- pack until no more transfer is possible
      dropPacks(slot)

      -- fetch similar item in other slots and transfer to current slot if not empty
      transferedItems = false
      if turtle.getItemCount(slot) > 0 then
        print("Fetching similar items")
        for transferSlot = startSlot,endSlot do
          if transferSlot ~= slot then
            selectSlot(transferSlot)
			dropPacks(transferSlot) -- drop before transfering, improving performance
            if turtle.compareTo(slot) then
              print("Transfering similar item from slot ", transferSlot)
              turtle.transferTo(slot)
              transferedItems = true
              -- stop transfer fetching if current slot is full
              if turtle.getItemSpace(slot) == 0 then
                print("Transfer fetching aborted, slot is full")
                break
              end
            end
          end
          selectSlot(slot)
        end
      else
        print("Slot clear")
      end
    until not transferedItems
	end
end
