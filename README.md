Hi, I'm James Kim from Devsisters. :)

For last few days, I was trying to connect Unity(Game Engine) to Kailua, as my vacation pet project. I somehow managed this, and I think my workflow is quite robust to share. So here I will give a brief guide of how I applied Kailua to my own [sample Unity project][Repository]. (I'm not sure it's right space to post this, but anyway I hope somebody could get a grasp how to apply Kailua to their project.)  

## Install XLua
Since Unity does not support Lua binding by itself, first thing I did was install [XLua] plugin to my Unity project. By the way, XLua plugin is really awesome Lua binding generator for C#, which support class, delegate, extension methods, hotfix, etc.

## Add type_hint.lua
But XLua only generates pure lua binding, not the Kailua flavored lua scripts. So I added Kailua type hinting file, [type_hint.lua], to get static type checking. This file looks like bunch of skeleton code, since it's just for static type checking, not for runtime. The code below is from `type_hint.lua` and it's for registering Component class to Kailua language server.

```lua
Component = class()
UE.Component = Component
function Component:init()
    -- members varibles
    self.gameObject = nil --: GameObject
    self.transform = nil --: Transform
end
```

Again, this script is *NOT* used in runtime, so assigning nil has no problem at all.

## Add bootstrap.lua and require all lua files
To let Kailua language server know about `type_hint.lua`, I needed to require `type_hint.lua` in someplace that can be reached from `start_path`. Now `type_hint.lua` is the only file needs static type checking, but while after this project will have lots of lua scripts. For requiring every scripts that needs static type checking, I added [bootstrap.lua]. Below is a complete `bootstrap.lua` for my sample project.

```lua
--# open lua51
-- Give type infomation to Kailua.
require 'Kailua/Hint/type_hint'

-- Fill gap between XLua and Kailua
require 'Kailua/Src/connect_xlua'

-- Require all custom scripts for static type checking
require 'Kailua/Src/boilerplate'
require 'Kailua/Src/test'
```

## Set bootstrap.lua as start_path
Even now Kailua language server don't know about `bootstrap.lua`, so I needed to register this. For this, I set `start_path` to `Kailua/Hint/bootstrap.lua`. (As mentioned in [README.md], you can find `start_path` in file [.vscode/kailua.json]) Soon after, all the files that recursively required from `bootstrap.lua` will get static type checking.

## Write some custom script
Now I have `type_hint.lua` for type checking, plus I can register all lua files in `bootstrap.lua`.
So All tedious jobs are done! Next, I implemented my own lua behaviour script `test.lua`. Lua behaviour script is just lua version of MonoBehaviour. For example, code below will log "Awake" on Awake.

```lua
--v function(self: Self)
local function Awake(self)
    print('Awake')
end
```

It has only Awake, Start, Update, OnGUI functions for now.

## Attach lua behaviour script
To use lua behaviour script `test.lua`, I implemented [LuaBehaviour.cs] which calls Awake, Start, etc from C# to lua. Then I attached this script to GameObject and assign its member variable, `filename`, to `test.lua`. After doing this, `LuaBehaviour.cs` will call `test.lua`'s Awake when MonoBehaviour Awake, Start when Start, etc.

## More
You can build my own sample project by cloning [repository][Repository]. Or you can download and play [standalone version].

[README.md]: https://github.com/devcat-studio/kailua/README.md
[XLua]: https://github.com/tencent/xlua
[Repository]: https://github.com/JamesKim2998/unity-kailua-sample
[type_hint.lua]: https://github.com/JamesKim2998/unity-kailua-sample/blob/master/Kailua/Hint/type_hint.lua
[bootstrap.lua]: https://github.com/JamesKim2998/unity-kailua-sample/blob/master/Kailua/Hint/bootstrap.lua
[.vscode/kailua.json]: https://github.com/JamesKim2998/unity-kailua-sample/blob/master/.vscode/kailua.json
[test.lua]: https://github.com/JamesKim2998/unity-kailua-sample/blob/master/Kailua/Src/test.lua
[LuaBehaviour.cs]: https://github.com/JamesKim2998/unity-kailua-sample/blob/master/Assets/Script/LuaBehaviour.cs
[standalone version]: https://github.com/JamesKim2998/unity-kailua-sample/releases/tag/v1.0
