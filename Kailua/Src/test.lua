-- namespace aliasing
local UE = CS.UnityEngine

-- declare Self
--# type local Self = {
--#     `userdata`: Component,
--#     spriteRenderer: SpriteRenderer,
--#     elaspedTime: number,
--# }
--# assume self: Self

-- static members
local randomColors =
{
    UE.Color.white,
    UE.Color.red,
    UE.Color.green,
    UE.Color.blue,
    UE.Color.gray,
} --: vector<Color>

--v function(self: Self)
local function Awake(self)
    print('hello, kailua!')
    self.elaspedTime = 0
end

-- Unity 로고를 보여주는 GameObject를 추가
--v function(self: Self)
local function Start(self)
    local tmpSpriteRenderer = self.userdata.gameObject:AddComponent(typeof(UE.SpriteRenderer))
    --# assume tmpSpriteRenderer: SpriteRenderer
    self.spriteRenderer = tmpSpriteRenderer

    local sprite = UE.Resources.Load('logo_sprite', typeof(UE.Sprite))
    --# assume sprite: Sprite
    self.spriteRenderer.sprite = sprite
    self.spriteRenderer.color = UE.Color.red
end

-- GameObject를 원운동 시킨다
--v function(self: Self)
local function Update(self)
    self.elaspedTime = self.elaspedTime + UE.Time.deltaTime
    local t = self.elaspedTime
    local x = math.sin(t * 4) / 3
    local y = math.cos(t * 4) / 3
    local v = UE.Vector3.new(x, y)
    self.userdata.transform.localPosition = v
end

--v function(self: Self)
local function OnGUI(self)
    local r = UE.Rect.new(0, 0, UE.Screen.width, UE.Screen.height)
    local btnStyle = UE.GUIStyle.new(UE.GUI.skin.button)
    btnStyle.fontSize = 50

    UE.GUILayout.BeginArea(r)
    -- 랜덤 색상으로 변경
    if UE.GUILayout.Button('random color', btnStyle) then
        newColorIdx = math.random(1, #randomColors)
        --# assume newColorIdx: integer
        newColor = randomColors[newColorIdx]
        self.spriteRenderer.color = newColor
    end
    -- 씬을 다시 로딩
    if UE.GUILayout.Button('reload scene', btnStyle) then
        UE.SceneManagement.SceneManager.LoadScene('Main')
    end
    UE.GUILayout.EndArea()
end

return {
    Awake = Awake,
    Start = Start,
    Update = Update,
    OnGUI = OnGUI,
}
