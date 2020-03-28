local ObjectizeUI

AddEvent("OnPackageStart", function()
    ObjectizeUI = CreateWebUI(0.0, 0.0, 0.0, 0.0)
    LoadWebFile(ObjectizeUI, "http://asset/"..GetPackageName().."/ui/index.html")
    SetWebAlignment(ObjectizeUI, 0.0, 0.0)
    SetWebAnchors(ObjectizeUI, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(ObjectizeUI, WEB_HIDDEN)
end)

AddEvent("OnPackageStop", function()
	DestroyWebUI(ObjectizeUI)
end)

AddRemoteEvent("ShowCharacterSelection", function()
    ExecuteWebJS(ObjectizeUI, "ShowCharacterSelect()")
  	ShowMouseCursor(true)
	SetIgnoreMoveInput(true);
	SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(ObjectizeUI, WEB_VISIBLE)
end)

AddEvent("OnKeyPress", function(key)
	if key == "I" then
		CallRemoteEvent("GetInventory")

		-- show inventory
		ShowMouseCursor(true)
		SetIgnoreMoveInput(true);
		SetInputMode(INPUT_GAMEANDUI)
		SetWebVisibility(ObjectizeUI, WEB_VISIBLE)
	end
end)

AddEvent("OnKeyRelease", function(key)
	if key == "I" then
		-- hide inventory
		ShowMouseCursor(false)
		SetIgnoreMoveInput(false);
		SetInputMode(INPUT_GAME)
		SetWebVisibility(ObjectizeUI, WEB_HIDDEN)
	end
end)

AddRemoteEvent("PlayObjectUseSound", function(sound, x, y, z)
    SetSoundVolume(CreateSound3D("sounds/"..sound, x, y, z, 1000), 1.0)
end)

AddRemoteEvent("SetInventory", function(data)
	ExecuteWebJS(ObjectizeUI, "SyncInventory('".. data .."')")
end)

AddEvent("UseObject", function(name)
	CallRemoteEvent("UseObjectFromInventory", name)
end)

AddEvent("EquipObject", function(name)
	CallRemoteEvent("EquipObjectFromInventory", name)
end)

AddEvent("UnequipObject", function(name)
	CallRemoteEvent("UnequipObject", name)
end)

AddEvent("DropObject", function(name)
	CallRemoteEvent("DropObjectFromInventory", name)
end)