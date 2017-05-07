------------------------------------------------
-- 아래 코드는 런타임에 돌아가는 코드가 아닙니다.
-- kailua의 static type checking을 위한 type hinting 파일입니다.
------------------------------------------------

--# assume global `class`: [make_class] function() --> any

---------------
-- Common C# --
---------------
--# type Type = { } -- C#의 Type class를 선언
typeof = 
    --v function(obj: any) --> Type
    function(obj) return nil end

-----------------
-- UnityEngine --
-----------------
-- namespace 등록
CS = { -- namespace CS 선언
    UnityEngine = { -- namespace UnityEngine 선언
        UI = {}, -- namespace UI 선언
        SceneManagement = {}, -- namespace SceneManagement 선언
    }
}

-- namespace aliasing
local UE = CS.UnityEngine
local UI = UE.UI
local SM = UE.SceneManagement

-- forward declaration
Vector3 = class() UE.Vector3 = Vector3 -- namespace CS.UnityEngine에 등록
Rect = class() UE.Rect = Rect
Color = class() UE.Color = Color
Object = class() UE.Object = Object
Sprite = class() UE.Sprite = Sprite
Component = class() UE.Component = Component
GameObject = class() Transform = class()
UE.Transform = Transform SpriteRenderer = class()
UE.SpriteRenderer = SpriteRenderer UE.GameObject = GameObject
Time = class() UE.Time = Time
Resources = class() UE.Resources = Resources
WaitForSeconds = class() UE.WaitForSeconds = WaitForSeconds
WWW = class() UE.WWW = WWW
Screen = class() UE.Screen = Screen
GUIStyle = class() UE.GUIStyle = GUIStyle
GUISkin = class() UE.GUISkin = GUISkin
GUI = class() UE.GUI = GUI
GUILayout = class() UE.GUILayout = GUILayout
SceneManager = class() SM.SceneManager = SceneManager

-- UnityEngine.Vector3
--v method(x: number, y: number, z: number?)
function Vector3:init(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end

-- UnityEngine.Rect
--v method(x: number, y: number, w: number, h: number)
function Rect:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

-- UnityEngine.Color
--v method(r: number, g: number, b: number)
function Color:init(r, g, b)
    self.r = r
    self.g = g
    self.b = b

    -- static members
    Color.white = nil --: Color
    Color.red = nil --: Color
    Color.green = nil --: Color
    Color.blue = nil --: Color
    Color.gray = nil --: Color
end

-- UnityEngine.Object
function Object:init() end

-- UnityEngine.Sprite
function Sprite:init() end

-- UnityEngine.Component
function Component:init()
    self.gameObject = nil --: GameObject
    self.transform = nil --: Transform
end

-- UnityEngine.Transform
function Transform:init()
    self.localPosition = Vector3.new(0, 0, 0)
end

--# assume Transform.Translate: method(translation: Vector3)

-- UnityEngine.SpriteRenderer
function SpriteRenderer:init()
    self.sprite = nil --: Sprite
    self.color = nil --: Color
end

-- UnityEngine.GameObject
--v method(name: string?)
function GameObject:init(name) 
    self.transform = nil --: Transform
end

--# assume GameObject.AddComponent: method(`type`: Type) --> Component

-- UnityEngine.Time
function Time:init()
    Time.time = 0
    Time.deltaTime = 0
end

-- UnityEngine.Resource
function Resources:init()
    Resources.Load =
        --v function(path: string, `type`: Type) --> Object
        function(path, type) return nil end
end

-- UnityEngine.WaitForSeconds
function WaitForSeconds:init() end

-- UnityEngine.WWW
function WWW:init() end

-- UnityEngine.Screen
function Screen:init()
    Screen.width = 0
    Screen.height = 0
end

-- UnityEngine.GUIStyle
--v method(style: GUIStyle?)
function GUIStyle:init(style)
    self.fontSize = 0
end

-- UnityEngine.GUISkin
function GUISkin:init()
    self.button = nil --: GUIStyle
end

-- UnityEngine.GUI
function GUI:init()
    GUI.skin = GUISkin.new()
end

-- UnityEngine.GUILayout
function GUILayout:init()
    GUILayout.BeginArea =
        --v function(r: Rect)
        function(r) end
    GUILayout.EndArea =
        --v function()
        function() end
    GUILayout.Button =
        --v function(label: string, style: GUIStyle?) --> bool
        function(label, style) return false end
end

-- UnityEngine.SceneManagement.SceneManager
function SceneManager:init()
    SceneManager.LoadScene =
        --v function(scene: string)
        function(scene) end
end

------------------
-- My Game Code --
------------------
