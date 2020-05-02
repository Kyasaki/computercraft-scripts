-- Picks some items by multiple of 9 in top inventory and places them in the bottom inventory

local startSlot = 1
local endSlot = 16
local packAmount = 9
local transferedItems -- keep track of the possibility to transfer again

-- selects a slot and drops packs of the selected slot when possible
function dropPacks(slot)
  turtle.select(slot)
  while turtle.getItemCount(slot) >= packAmount do
    print("Pack available in slot ", slot)
    if not turtle.dropDown(packAmount) then -- wait packer is emtpy
      print("Waiting pack machine...")
      while not turtle.dropDown(packAmount) do -- wait packer is emtpy
        sleep(1)
      end
    end
    print("Pack picked")
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
            turtle.select(transferSlot)
            if turtle.compareTo(slot) then
              dropPacks(transferSlot) -- drop before transfering, improving performance
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
          turtle.select(slot)
        end
      else
        print("Slot clear")
      end
    until not transferedItems
	end
end
