local ItemizeUI

AddEvent("OnPackageStart", function()
    ItemizeUI = CreateWebUI(0.0, 0.0, 0.0, 0.0)
    LoadWebFile(ItemizeUI, "http://asset/"..GetPackageName().."/ui/index.html")
    SetWebAlignment(ItemizeUI, 0.0, 0.0)
    SetWebAnchors(ItemizeUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(ItemizeUI, WEB_HIDDEN)
end)

AddEvent("OnPackageStop", function()
	DestroyWebUI(ItemizeUI)
end)

AddRemoteEvent("ShowCharacterSelection", function()
    ExecuteWebJS(ItemizeUI, "ShowCharacterSelect()")
  	ShowMouseCursor(true)
	SetIgnoreMoveInput(true);
	SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(ItemizeUI, WEB_VISIBLE)
end)

AddEvent("OnKeyPress", function(key)
	if key == "I" then
		CallRemoteEvent("GetInventory")

		-- show inventory
		ShowMouseCursor(true)
		SetIgnoreMoveInput(true);
		SetInputMode(INPUT_GAMEANDUI)
		SetWebVisibility(ItemizeUI, WEB_VISIBLE)
	end
end)

AddEvent("OnKeyRelease", function(key)
	if key == "I" then
		-- hide inventory
		ShowMouseCursor(false)
		SetIgnoreMoveInput(false);
		SetInputMode(INPUT_GAME)
		SetWebVisibility(ItemizeUI, WEB_HIDDEN)
	end
end)

AddRemoteEvent("SetInventory", function(data)
	ExecuteWebJS(ItemizeUI, "SyncInventory('".. data .."')")
end)

AddEvent("UseItem", function(name)
	CallRemoteEvent("UseItemFromInventory", name)
end)

AddEvent("EquipItem", function(name)
	CallRemoteEvent("EquipItemFromInventory", name)
end)

AddEvent("UnequipItem", function(name)
	CallRemoteEvent("UnequipItem", name)
end)

AddEvent("DropItem", function(name)
	CallRemoteEvent("DropItemFromInventory", name)
end)