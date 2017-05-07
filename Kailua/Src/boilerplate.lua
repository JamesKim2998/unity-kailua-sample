-- Just a boilerplate for LuaBehaviour component.

--# type local Self = {}
--# assume self: Self

--v function(self: Self)
local function Awake(self)
    print('Awake')
end

--v function(self: Self)
local function Start(self)
    print('Start')
end

--v function(self: Self)
local function Update(self)
    print('Update')
end

--v function(self: Self)
local function OnGUI(self)
    print('OnGUI')
end

return {
    Awake = Awake,
    Start = Start,
    Update = Update,
    OnGUI = OnGUI,
}
