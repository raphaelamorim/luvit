--[[

Copyright 2014 The Luvit Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS-IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

--]]

require('tap')(function (test)
  test("test listenerCount", function()
    assert(2 == require('core').Emitter:new()
      :on("foo", function(a) end)
      :on("foo", function(a,b) end)
      :on("bar", function(a,b) end)
      :listenerCount("foo"))
    assert(0 == require('core').Emitter:new():listenerCount("non-exist"))
  end)

  test("chaining", function(expect)
    require('core').Emitter:new()
      :on("foo", expect(function(x)
        assert(x.a == 'b')
      end))
      :emit("foo", { a = "b" })
  end)

  test("removal", function(expect)
    local e1 = require('core').Emitter:new()
    local cnt = 0
    local function checkCount()
      cnt = cnt + 1
      if cnt == 2 then
        assert(e1:listenerCount('t1') == 2)
      end
    end
    local function dummy()
    end
    e1:on('t1', expect(function()
      checkCount()
    end))
    e1:on('t1', dummy)
    e1:on('t1', expect(function()
      checkCount()
    end))
    e1:removeListener('t1', dummy)
    e1:emit('t1')
  end)

  test("remove all listeners", function(expect)
    local em = require('core').Emitter:new()
    em:on('data', function() end)
    em:removeAllListeners()
    em:on('data', expect(function() end))
    em:emit('data', 'Go Fish')
    assert(#em:listeners('data') == 1)
    em:removeAllListeners()
    assert(#em:listeners('data') == 0)
  end)
end)


