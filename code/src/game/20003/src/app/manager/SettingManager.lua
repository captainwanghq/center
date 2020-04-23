local SettingManager = {}
SettingManager.settings ={}
local settings = {sound = true,clickmodel = 1,highestscore = 0}
function SettingManager:initialize()
	local data = loadTable("setting.data")  or settings
	saveTable("setting.data",data)
	SettingManager.settings = data 
end

function SettingManager:getSettings(name)
	-- body
	return SettingManager.settings[name]
end

function SettingManager:setSettings(name,value)
	-- body
	SettingManager.settings[name] = value
	saveTable("setting.data",SettingManager.settings)
end
SettingManager:initialize()

return SettingManager