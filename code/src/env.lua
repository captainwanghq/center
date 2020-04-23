
local function dump_search_paths()
    local paths = cc.FileUtils:getInstance():getSearchPaths()
    --print(paths)
end

--获取可写目录
local function getWritablePath()
    local nTargetPlatform = cc.Application:getInstance():getTargetPlatform()
    if 0 == nTargetPlatform then
        if not cc.FileUtils:getInstance():isDirectoryExist("c:/xxxxxgame/") then 
            cc.FileUtils:getInstance():createDirectory("c:/xxxxxgame/")
        end
        cc.FileUtils:getInstance():setWritablePath("c:/xxxxxgame/")
    end
    return cc.FileUtils:getInstance():getWritablePath()
end

local key_dirs = {
    "shared/",
    "framework/"
}

for k,v in ipairs(key_dirs) do
    cc.FileUtils:getInstance():addSearchPath(string.format("src/%s",v),true)
    cc.FileUtils:getInstance():addSearchPath(string.format("%s/%s",getWritablePath(),v),true)
end

local origin_search_paths = cc.FileUtils:getInstance():getSearchPaths()

local function reset_search_paths( ... )
    -- body
    cc.FileUtils:getInstance():setSearchPaths(origin_search_paths)
end

local function change_search_paths( module_name )
    -- body
    local src_root = "src"
    local module_path = string.gsub(module_name,"%.","/")
    cc.FileUtils:getInstance():addSearchPath(string.format("%s/%s/res",src_root,module_path),true)
    cc.FileUtils:getInstance():addSearchPath(string.format("%s/%s/src",src_root,module_path),true)
    src_root = getWritablePath()
    cc.FileUtils:getInstance():addSearchPath(string.format("%s/%s/res",src_root,module_path),true)
    cc.FileUtils:getInstance():addSearchPath(string.format("%s/%s/src",src_root,module_path),true)
end

local function unload_pakage()
    -- body
    for k,v in pairs(package.loaded) do 
        if string.find(k,'app.') then 
            unload_package(k)
        end
    end
end

local csgame = {}

csgame.gameInfo = {
    gameName = "core",
    gameModule = "core",
    gameId = "10000"
}

csgame.gameList = {
    {
        gameName = "center",
        gameModule = "center.10001",
        gameId = "10001",
        gameType = "lua"
    }
    ,
    {
        gameName = "bird",
        gameModule = "game.20001",
        gameId = "20001",
        gameType = "lua"
    },
    {
        gameName = "fish",
        gameModule = "game.20002",
        gameId = "20002",
        gameType = "lua"
    },
    {
        gameName = "dot",
        gameModule = "game.20003",
        gameId = "20003",
        gameType = 'lua'
    },
}


function csgame.isShowCenter()

    return true
end

function csgame.getGameId( ... )
    -- body
    return csgame.gameInfo.gameId
end

function csgame.getCurGame()
    -- body
    return csgame.gameInfo.gameName
end

function csgame.findGameInfo( gameModule )
    -- body
    local gameInfo = nil
     for k,v in pairs(csgame.gameList) do 
        if gameModule ==  v.gameModule then 
            gameInfo = v
            break
        end
    end
    return gameInfo
end
function csgame.setCurGameInfo(gameModule)
    -- body
    for k,v in pairs(csgame.gameList) do 
        if gameModule ==  v.gameModule then 
            csgame.gameInfo = v
            break
        end
    end
end

function csgame.addGameInfo(gameInfo)
    -- body
    table.insert(csgame.gameList,gameInfo)
end

local oldPrint = print
print = function ( ... )
    -- body
    local gameId = csgame.getGameId()
    local gameName = csgame.getCurGame()
    local game = string.format("[%s-%s]",gameId,gameName) --string.format("[%s]",gameName)
    if DEBUG ~=0 then 
        local arg = {...}
        for k, v in ipairs(arg) do
            if type(v) == 'table' then
                if DEBUG > 1 then
                    dump(v,'table')
                end
            end
        end
        oldPrint(game,...)
    end
end

local function install_module(module_name,callback)

    local gameInfo = csgame.findGameInfo(module_name)
    if gameInfo then 
    else
        csgame.addGameInfo({gameModule = module_name})
    end
    if callback then 
        callback(module_name)
    end
end

local  function lanuch_so(module_name,callback)
    -- body
end

local  function lanuch_lua( module_name,callback)
    -- body
    csgame.setCurGameInfo(module_name)
    reset_search_paths()
    unload_pakage()
    change_search_paths(module_name)
    dump_search_paths()
    if callback then 
        callback()
    else
        local game = require("app.MyApp")
        if game then 
            game:create():run()
        end
    end
end

function lanuch_module(module_name,callback)
    -- body
    local gameInfo = csgame.findGameInfo(module_name)
    if not gameInfo then 
        print('启动['..module_name.."]失败")
        install_module("center.10001",function(app)
            -- body
            lanuch_module(app,callback)
        end)
    else
        if gameInfo.gameType == 'lua' then
            lanuch_lua(module_name,callback)
        else
            lanuch_so(module_name,callback)
        end
        cc.Director:getInstance():getTextureCache():removeAllTextures()
    end
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
    local gameId = csgame.getGameId()
    local gameName = csgame.getCurGame()
    local game = string.format("%s-%s-",gameId,gameName) 
    local filePath =  cc.FileUtils:getInstance():getWritablePath()..game..fileName
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
        local gameId = csgame.getGameId()
        local gameName = csgame.getCurGame()
        local game = string.format("%s-%s-",gameId,gameName) 
        filePath = cc.FileUtils:getInstance():getWritablePath()..game..fileName
    end

    local file = io.open(filePath, "r")
    if file then
        local data = file:read("*a")
        file:close()
        return data
    end
end

function saveTable(fileName, sTable)
    local res = jsonEncode(sTable)
    saveContent(fileName, res)
end

function loadTable(fileName)
    local data = readContent(fileName)
    return jsonDecode(data) 
end



