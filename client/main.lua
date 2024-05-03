local QBCore = exports['qb-core']:GetCoreObject()
local player = PlayerPedId()


--// Models
local box = GetHashKey("reh_prop_reh_b_computer_04a")
RequestModel(box)
while not HasModelLoaded(box) do
    Citizen.Wait(1)
    RequestModel(box)
end

--// Events
RegisterNetEvent("ss-blackout:recentlyhitnotification", function()
QBCore.Functions.Notify(Config.RecentlyHitMessage, "error", 3000)
end)

RegisterNetEvent("ss-blackout:blackoutactivenotification", function()
QBCore.Functions.Notify(Config.AlreadyActiveMessage, "error", 3000)
end)

RegisterNetEvent("ss-blackout:enterbox", function()
    local ped = PlayerPedId()
    SetEntityHeading(
        ped,
        239.88
    )
    local pedCoords = GetEntityCoords(ped)
    local pedRotation = GetEntityRotation(ped)
    

    NetworkedScene(vector3(713.9, 160.55, 80.75), pedRotation, {
        {
            ped = ped,
            anim = {
                dict = "anim@scripted@ulp_missions@fuse@male@",
                anim = "enter"
            }
        }
    }, {
        {
            model = `reh_prop_reh_b_computer_04a`,
            anim = {
                dict = "anim@scripted@ulp_missions@fuse@male@",
                anim = "enter_fusebox"
            }
        }
    }, 7500)

    local ped = PlayerPedId()
    SetEntityHeading(
        ped,
        239.88
    )
    local pedCoords = GetEntityCoords(ped)
    local pedRotation = GetEntityRotation(ped)
    
    NetworkedScene(vector3(713.9, 160.55, 80.75), pedRotation, {
        {
            ped = ped,
            anim = {
                dict = "anim@scripted@ulp_missions@fuse@male@",
                anim = "success"
            }
        }
    }, {
        {
            model = `reh_prop_reh_b_computer_04a`,
            anim = {
                dict = "anim@scripted@ulp_missions@fuse@male@",
                anim = "success_fusebox"
            }
        }
    }, 9560)

end)



--// Functions
function NetworkedScene(coords, rotation, peds, objects, duration)
    local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z-1, rotation, 2, false, false,
        -1,
        0,
        1.0)

    for k, v in pairs(peds) do
        if v.model and not v.ped then
            while not HasModelLoaded(v.model) do
                RequestModel(v.model)
                Wait(1)
            end

            v.ped = CreatePed(23, v.model, coords.x, coords.y, coords.z, 0.0, true, true)
            v.createdByUs = true
        end
        while not HasAnimDictLoaded(v.anim.dict) do
            RequestAnimDict(v.anim.dict)
            Wait(1)
        end
        NetworkAddPedToSynchronisedScene(v.ped, scene, v.anim.dict, v.anim.anim, 1.5,
            -4.0, 1,
            16,
            1148846080, 0)
    end

    for k, v in pairs(objects) do
        if v.model and not v.object then
            while not HasModelLoaded(v.model) do
                RequestModel(v.model)
                Wait(1)
            end
            v.object = CreateObject(v.model, coords, true, true, true)
            v.createdByUs = true
        end
        while not HasAnimDictLoaded(v.anim.dict) do
            RequestAnimDict(v.anim.dict)
            Wait(1)
        end
        NetworkAddEntityToSynchronisedScene(v.object, scene, v.anim.dict, v.anim.anim,
            1.0,
            1.0, 1)
    end

    NetworkStartSynchronisedScene(scene)
    Wait(duration)
    NetworkStopSynchronisedScene(scene)



    for k, v in pairs(peds) do
        if v.createdByUs then
            DeletePed(v.ped)
        end
    end

    for k, v in pairs(objects) do
        if v.createdByUs then
            DeleteEntity(v.object)
        end
    end
end


--// Box Targeting
exports['qb-target']:AddBoxZone("BlackoutBoxZone",vector3(713.01, 161.07, 81.10), 1.2, 1, { -- The name has to be unique, the coords a vector3 as shown, the 1.5 is the length of the boxzone and the 1.6 is the width of the boxzone, the length and width have to be float values
  name = "BlackoutBoxZone", -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
  heading = 331, -- The heading of the boxzone, this has to be a float value
  debugPoly = false, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
  minZ = 80.5, -- This is the bottom of the boxzone, this can be different from the Z value in the coords, this has to be a float value
  maxZ = 81.9, -- This is the top of the boxzone, this can be different from the Z value in the coords, this has to be a float value
}, {
  options = { -- This is your options table, in this table all the options will be specified for the target to accept
    { -- This is the first table with options, you can make as many options inside the options table as you want
      num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
      type = "server", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
      event = "ss-blackout:blackout", -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
      icon = 'fa-solid fa-power-off', -- This is the icon that will display next to this trigger option
      label = 'Turn City Power Off', -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
    }
  },
  distance = 3.0, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
})

