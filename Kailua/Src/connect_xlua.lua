--v [NO_CHECK] function(t: any, name: string, value: any)
function add_field(t, name, value)
    local m = getmetatable(t)
    local orgNewIndex = m.__newindex
    m.__newindex = nil
    t[name] = value
    m.__newindex = orgNewIndex
end

--v [NO_CHECK] function(t: any)
function add_new(t)
    local m = getmetatable(t)
    local orgNewIndex = m.__newindex
    m.__newindex = nil
    t.new = function(...) return t(...) end
    m.__newindex = orgNewIndex
end

-----------------
-- UnityEngine --
-----------------
local UE = CS.UnityEngine -- namespace CS.UnityEngine을 사용하기 좋게 aliasing
add_new(UE.Vector3)
add_new(UE.Rect)
add_new(UE.Color)
add_new(UE.GameObject)
add_new(UE.GUIStyle)

------------------
-- My Game Code --
------------------
--# assume Vector3.Add: function(a: Vector3, b: Vector3) --> Vector3
add_field(UE.Vector3, 'Add',
    --v [NO_CHECK] function(a: Vector3, b: Vector3) --> Vector3
    function(a, b) return a + b end)

--# assume Vector3.Divide: function(v: Vector3, div: number) --> Vector3
add_field(UE.Vector3, 'Divide',
    --v [NO_CHECK] function(v: Vector3, div: number) --> Vector3
    function(v, div) return v / div end)
