local RecordManager = {}

--RecordManager.record = {level = 1,highestscore = 0,order = 1}
function RecordManager:initialize()
	-- body
	local data = loadTable("record.data")
	if data then 
		saveTable("record.data",data)
		RecordManager.record = data 
	end
end
RecordManager:initialize()

function RecordManager:getRecord()
	-- body
	return RecordManager.record
end

function RecordManager:addRecord(record)
	-- body
	if not RecordManager.record then
		RecordManager.record = {}
		RecordManager.record[record.level-1] = record
	else
		RecordManager.record[record.level-1] = record
	end
	saveTable("record.data",RecordManager.record)
end

function RecordManager:updateRecord(record)
	-- body
	if not RecordManager.record then 
		RecordManager.record = {}
		RecordManager.record[record.level-1] = record
	else 
		if RecordManager.record[record.level-1] then 
			if RecordManager.record[record.level-1].highestscore < record.highestscore then
				RecordManager.record[record.level-1] = record
			end
		else 
			RecordManager.record[record.level-1] = record
		end
	end
	saveTable("record.data",RecordManager.record)
end

return RecordManager