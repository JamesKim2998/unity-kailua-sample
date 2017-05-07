using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using XLua;

using ScriptFunc = System.Action<XLua.LuaTable>;

public class LuaBehaviour : MonoBehaviour
{
    public string FileName = "test";

    private LuaTable _self;
    private ScriptFunc _luaStart;
    private ScriptFunc _luaUpdate;
    private ScriptFunc _luaOnGUI;

    private static readonly LuaEnv _globalEnv = MakeGlobalEnv();

    private void Awake()
    {
        var scriptRet = MakeScriptEnv(_globalEnv, FileName, this);

        var scriptApi = scriptRet[0] as LuaTable;
        scriptApi.Get("Start", out _luaStart);
        scriptApi.Get("Update", out _luaUpdate);
        scriptApi.Get("OnGUI", out _luaOnGUI);

        _self = _globalEnv.NewTable();
        _self.Set("userdata", this);
        scriptApi.Get<ScriptFunc>("Awake")(_self);
    }

    private void Start()
    {
        _luaStart(_self);
    }

    private void Update()
    {
        _luaUpdate(_self);
    }

    private void OnGUI()
    {
        _luaOnGUI(_self);
    }

    private static LuaEnv MakeGlobalEnv()
    {
        var env = new LuaEnv();
        env.AddLoader(LoadLuaFile);
        env.DoString("require 'connect_xlua'");
        return env;
    }

    private static byte[] LoadLuaFile(ref string filePath)
    {
        return File.ReadAllBytes("Kailua/Src/" + filePath + ".lua");
    }

    private static object[] MakeScriptEnv(LuaEnv globalEnv, string scriptFilename, UnityEngine.Object userdata)
    {
        var content = File.ReadAllText("Kailua/Src/" + scriptFilename + ".lua");
        return globalEnv.DoString(content, scriptFilename);
    }

    /*
    private static void CopyAllLuaFiles()
    {
        const string dir = "Assets/LuaSrc/Resources";
        if (!Directory.Exists(dir))
            Directory.CreateDirectory(dir);

        foreach (var path in Directory.GetFiles("Kailua/Src"))
        {
            var filenameWithoutExt = Path.GetFileNameWithoutExtension(path);
            var newPath = Path.Combine(dir, filenameWithoutExt + ".lua.txt");
            if (File.Exists(newPath)) File.Delete(newPath);
            File.Copy(path, newPath);
        }
    }
    */
}
