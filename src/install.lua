function NASH_Install()
    if Event_Exists("NASH: Scenario Loaded") then
        Event_Delete("NASH: Scenario Loaded", true)
    end

    -- initialize IKE on load by injecting its own code into the VM
    local main = Event_Create("NASH: Scenario Loaded", {
        IsRepeatable=true, 
        IsShown=false
    })
    Event_AddTrigger(main, Trigger_Create("NASH_Scenario_Loaded", {
        type='ScenLoaded'
    }))
    Event_AddAction(main, Action_Create("NASH: Load Script", {
        type='LuaScript',
        ScriptText=NASH_LOADER
    }))

    Input_OK("NASH has been successfully installed!")
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

