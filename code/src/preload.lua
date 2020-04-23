--
--版权所有:cyframe
-- Author: 
-- Date: 2017-07-09
-- Desc: 系统级的帮助函数
--

--==============================--
--desc:卸载LUA文件
--time:2017-07-10 10:36:47
--@sPackName:包名
--@return 
--==============================--
function unload_package(sPackName)
    package.loaded[sPackName] = nil
    --Log.info("file unload == "..sPackName)
end

--==============================--
--desc:释放内存 自动GC
--time:2017-07-10 10:36:38
--@return 
--==============================--
function LuaGC()
    local c = collectgarbage("count")
    Log.info("Begin gc count = "..(c/1024).." mb")
    collectgarbage("collect")
    c = collectgarbage("count")
    Log.info("End gc count = "..(c/1024).." mb")
end

--==============================--
--desc:打印错误信息
--time:2017-07-10 10:36:22
--@errmsg:错误消息
--@return 
--==============================--
local function __TRACKBACK__(errmsg)
    local msg = debug.traceback(tostring(errmsg), 3)
    if msg then
        Log.error(msg)
    end
    return false
end

--==============================--
--desc:安全调用
--time:2017-07-10 10:36:05
--@func:回调方法
--@args:可变参数
--@return 
--==============================--
function safe_call(func,...)
     if func then
        local args = {...}
        local function callBack()
            return func(unpack(args))
        end
        return xpcall(callBack,__G__TRACKBACK__ or __TRACKBACK__)
    else
        Log.info("func is nil")
    end
end

--==============================--
--desc:安全调用
--time:2017-11-25 04:20:54
--@func:方法
--@args:参数
--@return 
--==============================--
function safe_p_call(func,...)
    local status, result = pcall(func,...)
    if status then 
        return result
    end
    Log.error("safe_p_call error ", tostring(result))
end

--==============================--
--desc:主线程调用
--time:2017-10-29 03:45:59
--@func:回调
--@return 
--==============================--
function main_thread(func)
    if func then
        local scheduler = cc.Director:getInstance():getScheduler()  
        local schedulerID = nil  
        schedulerID = scheduler:scheduleScriptFunc(function()  
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
            func()
            func = nil
        end,0.1,false) 
    end
end

--==============================--
--desc:utf8 字符串
--time:2017-07-10 10:36:59
--@str:
--@start:
--@num:
--@return 
--==============================--
function utf8str(str, start, num)
    local function utf8CharSize(char)
        if not char then
            return 0
        elseif char > 240 then
            return 4
        elseif char > 225 then
            return 3
        elseif char > 192 then
            return 2
        else
            return 1
        end
    end
    local startIdx = 1
    while start > 1 do
        local char = string.byte(str, startIdx)
        startIdx = startIdx + utf8CharSize(char)
        start = start - 1
    end
    local endIdx = startIdx
    while num > 0 do
        if endIdx > #str then
            endIdx = #str
            break
        end
        local char = string.byte(str, idx)
        endIdx = endIdx + utf8CharSize(char)
        num = num - 1
    end
    return str:sub(startIdx, endIdx - 1)
end

--==============================--
--desc:分割字符串
--time:2017-07-10 10:35:19
--@sep:分割符
--@return:table
--==============================--
function string:split(sep)
    local sep, fields = sep or ",", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) table.insert(fields, c) end)
    return fields
end


--==============================--
--desc:检测table中是否包含指定的value
--time:2017-11-06 01:32:34
--@value:要匹配的值
--@tab:table
--@return:如果存在返回true 否则返回false
--==============================--
function isInclude(value, tab)
    if tab then
        for k,v in pairs(tab) do
        if v == value then
            return true
        end
        end
    end
    return false
end

--==============================--
--desc:获取value值所在的数组下标
--time:2017-11-06 01:33:51
--@value:需要匹配的值
--@tab:table(数组)
--@return:如果查找到返回下标 否则返回0
--==============================--
function indexOf(value, tab)
    if tab then
        for k,v in ipairs(tab) do
        if v == value then
            return k
        end
        end
    end
    return 0
end

--==============================--
--desc:判断table是否为空{} 注意不是nil
--time:2017-11-10 03:50:12
--@tab:源table
--@return:如果是空表返回true 否则返回false
--==============================--
function isEmptyTable(tab)
    if tab then
        if next(tab) == nil then
        else
            return false
        end
    end
    return true
end

--==============================--
--desc:获取目录
--time:2017-07-10 10:37:20
--@path:
--@return 
--==============================--
function getDir(path)
    return string.match(path, ".*/")
end

--==============================--
--desc:获取文件名
--time:2017-07-10 10:37:12
--@path:
--@return 
--==============================--
function getFileName(path)
    return string.match(path, ".*/(.*)")
end

--==============================--
--desc:获取文件拓展名
--time:2017-07-10 10:35:15
--@str:
--@return 
--==============================--
function getExtension(str)
    return str:match(".+%.(%w+)$")
end

--==============================--
--desc:获取文件名字,拓展名,文件名称(不带拓展名),目录
--time:2017-07-10 10:35:15
--@str:
--@return 
--==============================--
function getFileInfo(path)

    local file_full_name =  getFileName(path)
    local idx = file_full_name:match(".+()%.%w+$")
    local _ext = getExtension(file_full_name)
    local _dir = getDir(path)
    if idx then 
        return {full_name = file_full_name,ext_name = _ext,file_name= file_full_name:sub(1,idx-1),dir = _dir}
    else
        return {full_name = file_full_name,ext_name = _ext,file_name= file_full_name,dir = _dir}
    end
end

-- 返回table大小
table.tostring = function(t)
    local mark = { }
    local assign = { }
    local function ser_table(tbl, parent)
        mark[tbl] = parent
        local tmp = { }
        for k, v in pairs(tbl) do
            local key = type(k) == "number" and "[" .. k .. "]" or "[" .. string.format("%q", k) .. "]"
            if type(v) == "table" then
                local dotkey = parent .. key
                if mark[v] then
                    table.insert(assign, dotkey .. "='" .. mark[v] .. "'")
                else
                    table.insert(tmp, key .. "=" .. ser_table(v, dotkey))
                end
            elseif type(v) == "string" then
                table.insert(tmp, key .. "=" .. string.format('%q', v))
            elseif type(v) == "number" or type(v) == "boolean" then
                table.insert(tmp, key .. "=" .. tostring(v))
            end
        end
        return "{" .. table.concat(tmp, ",") .. "}"
    end
    return ser_table(t, "ret") .. table.concat(assign, " ")
    -- return "do local ret=" .. ser_table(t, "ret") .. table.concat(assign, " ") .. " return ret end"
end

table.loadstring = function(strData)
    local f = loadstring(strData)
    if f then
        return f()
    end
end

-- table扩展=====================

table.contains=function(tb, element)
  if tb == nil then
        return false
  end
  for _, value in pairs(tb) do
    if value == element then
      return true,_
    end
  end
  return false
end

table.size = function(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

--==============================--
--desc:判断table是否为空
--param:t table
--@return:如果为空 返回 true 否则返回 false
--==============================--
table.empty = function(t)
    return not next(t)
end

--==============================--
--desc:返回table索引列表
--param:t table
--@return:
--==============================--
table.indices = function(t)
    local result = { }
    for k, v in pairs(t) do
        table.insert(result, k)
    end
end

--==============================--
--desc:返回table值列表
--param:t table
--@return:
--==============================--
table.values = function(t)
    local result = { }
    for k, v in pairs(t) do
        table.insert(result, v)
    end
end

--==============================--
--desc:Table浅拷贝
--param:t table
--param:nometa 元表
--@return:新的table
--==============================--
table.clone = function(t, nometa)
    local result = { }
    if not nometa then
        setmetatable(result, getmetatable(t))
    end
    for k, v in pairs(t) do
        result[k] = v
    end
    return result
end

--==============================--
--desc:Table深拷贝
--param:t table
--param:nometa 元表
--@return:新的table
--==============================--
table.copy = function(t, nometa)
    local result = { }

    if not nometa then
        setmetatable(result, getmetatable(t))
    end

    for k, v in pairs(t) do
        local k_= k
        if type(k) == "table" then
             k_ = table.copy(k)
        end
        if type(v) == "table" then
            result[k_] = table.copy(v)
        else
            result[k_] = v
        end
    end
    return result
end

--==============================--
--desc:table hash合并
--param:dest 目标table
--param:src 源table
--@return:
--==============================--
table.merge = function(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

--==============================--
--desc:table int 合并
--param:dest 目标table
--param:src 源table
--@return:
--==============================--
table.iMerge = function(dest, src)
    for k, v in ipairs(src) do
        table.insert(dest,v)
    end
end

--==============================--
--desc:根据value值移除元素
--param:t table
--param:value 需要移除的值
--@return:
--==============================--
table.RemoveListValue=function(t,value)
    for i ,v in ipairs(t) do
        if value==v then
            table.remove(t,i);
            return
        end
    end
end

--==============================--
--desc:table排序(默认升序)
--param:t table
--param:isDesc 是否自定义排序
--@return:
--==============================--
table.sortEx=function(t,isDesc)
    if isDesc then
        table.sort(t,function(a,b) return a> b end)
    else
        table.sort(t)
    end
end

--==============================--
--desc:读取文件内容
--param:path 文件路径
--@return:文件内容{string}
--==============================--
function readFile(path)
  local file = io.open(path, "r");
  assert(file);
  local data = file:read("*a"); -- 读取所有内容
  file:close();
  return data;
end






local function jsonDecode(str)
    if not str then return end
    if string.len(str) <= 0 then return end
    local success, ret = pcall(json.decode, str)
    if success then return ret end
end

local function jsonEncode(sTable)

    return json.encode(sTable)
end

local function saveContent(fileName, content)
    if not content or not fileName then return end
    if string.len(content) < 2 then return end
    local filePath =  cc.FileUtils:getInstance():getWritablePath()..fileName
    local file = io.open(filePath, "w")
    if file then
        file:write(content)
        file:close()
    end
end

local function readContent(fileName)
    if not fileName then return end
    local filePath = nil
    if cc.FileUtils:getInstance():isAbsolutePath(fileName) then
        filePath = fileName
    else
        filePath = cc.FileUtils:getInstance():getWritablePath()..fileName
    end

    local file = io.open(filePath, "r")
    if file then
        local data = file:read("*a")
        file:close()
        return data
    end
end

local function saveTable(fileName, sTable)
    local res = jsonEncode(sTable)
    saveContent(fileName, res)
end

local function loadTable(fileName)
    local data = readContent(fileName)
    return jsonDecode(data) 
end



