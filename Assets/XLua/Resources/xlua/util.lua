-- Tencent is pleased to support the open source community by making xLua available.
-- Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
-- Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
-- http://opensource.org/licenses/MIT
-- Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


--# assume unpack: function(table) --> (any...)
--# assume table.unpack: function(table) --> (any...)
--# assume table.insert: function(`table`: table, position: int?, value: any)
--# assume coroutine.wrap: function(function()) --> (function() --> WHATEVER)

--# type Iterator = {
--# }

--# type Generator = {
--#     Current: Iterator,
--#     w_func: function(),
--#     co: function() --> Iterator,
--#     Reset: function(self: WHATEVER),
--# }

local unpack = unpack or table.unpack

--v function(async_func: function(any...), callback_pos: int) --> (function(any...) --> any...)
local function async_to_sync(async_func, callback_pos)
    -- TODO
    return function(...)
        local _co = coroutine.running() or error ('this function must be run in coroutine')
        local rets --: table
        local waiting = false
        local function cb_func(...) --: function(any...)
            if waiting then
                coroutine.resume(_co, ...)
            else
                rets = {...}
            end
        end
        local params = {...} --: table
        table.insert(params, callback_pos or (#params + 1), cb_func)
        async_func(unpack(params))
        if rets == nil then
            waiting = true
            rets = {coroutine.yield()}
        end

        return unpack(rets)
    end
end

local function coroutine_call(func) --: function(any...)
    return function(...) --: function(any...)
        local co = coroutine.create(func)
        --# assume assert: WHATEVER
        assert(coroutine.resume(co, ...))
    end
end

local move_end = {}

local generator_mt = {
    __index = {
        MoveNext = function(self) --: Generator
            self.Current = self.co()
            if self.Current == move_end then
                self.Current = nil
                return false
            else
                return true
            end
        end;
        Reset = function(self) --: Generator
            self.co = coroutine.wrap(self.w_func)
        end
    }
}

local function cs_generator(
    func --: function()
    )
    local generator = setmetatable({
        w_func = function()
            func()
            return move_end
        end
    }, generator_mt)
    --# assume generator: Generator
    generator:Reset()
    return generator
end

return {
    async_to_sync = async_to_sync,
    coroutine_call = coroutine_call,
    cs_generator = cs_generator,
}
