local LevelsManager = {}

--RecordManager.record = {level = 1,highestscore = 0,order = 1}
function LevelsManager:initialize()
	-- body
	local data = loadTable("levels.data") 
	if data then 
	--	saveTable("levels.data",data)	
		LevelsManager.record = data 
	else 
		data = {}
		data[1] = {level = 1,steps=0,pass=1}
		LevelsManager.record = data 
		saveTable("levels.data",data)
	end
end
LevelsManager:initialize()

function LevelsManager:getRecord()
	-- body
	return LevelsManager.record
end

function LevelsManager:addRecord(record)
	-- body
	if not LevelsManager.record then
		LevelsManager.record = {}
		LevelsManager.record[record.level] = record
	else
		if LevelsManager.record[record.level] then 
			if   LevelsManager.record[record.level].pass==0 then 
				if LevelsManager.record[record.level].steps > record.steps then 
					LevelsManager.record[record.level].steps = record.steps
				end
				if not LevelsManager.record[record.level+1] then 
					LevelsManager.record[record.level+1] = {level = record.level+1,pass = 1,steps = 0}
				end
			elseif LevelsManager.record[record.level].pass==1 then 
				LevelsManager.record[record.level] = record
				if not LevelsManager.record[record.level+1] then 
					LevelsManager.record[record.level+1] = {level = record.level+1,pass = 1,steps = 0}
				end
			end		
		end
	end
	saveTable("levels.data",LevelsManager.record)
end

function LevelsManager:updateRecord(record)
	-- body
--[[	if not LevelsManager.record then 
		LevelsManager.record = {}
		LevelsManager.record[record.level-1] = record
	else 
		if LevelsManager.record[record.level-1] then 
			if LevelsManager.record[record.level-1].highestscore < record.highestscore then
				LevelsManager.record[record.level-1] = record
			end
		else 
			LevelsManager.record[record.level-1] = record
		end
	end]]
	saveTable("levels.data",LevelsManager.record)
end

return LevelsManager