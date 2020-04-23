

local oldRequire = require
require = function (module_name)
    -- body
    local old_module = _G[module_name]
    package.loaded[module_name] = nil
    local new_module = oldRequire (module_name)
    if old_module and new_module then
        for k, v in pairs(new_module) do
            old_module[k] = v
        end
        package.loaded[module_name] = old_module
    end
    print(module_name)
    return new_module
end