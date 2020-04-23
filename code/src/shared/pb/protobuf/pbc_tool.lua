pb = {}
local this = pb
local bShowMsgContent = true
--pbc encode
function pb.register(strMsgName,tbProto)
    local pbdata = cc.FileUtils:getInstance():getStringFromFile(strMsgName)
    protobuf.register(pbdata)
end

function pb.encode(strMsgName,tbProto)
	if(strMsgName == nil)then
		return nil;
	else
		if(bShowMsgContent)then
			print(">>>>>> "..strMsgName .." "..json.encode(tbProto))
		end
		return protobuf.encode(strMsgName,tbProto)
	end
end
--pbc decode
function pb.decode(strMsgName,byData)
	local tbProto = protobuf.decode(strMsgName,byData)
	if(bShowMsgContent)then
		pb.expand(tbProto)
		print("<<<<<< "..strMsgName.." "..json.encode(tbProto))
	end
	return tbProto
end
-- 递归函数
function pb.expand(t)
    for k,v in pairs(t) do
        if type(v) == "table" then
            if getmetatable(v) ~= nil then
                t[k]=protobuf.decode(v[1],v[2])
				pb.expand(t[k])
            else
                pb.expand(v)
            end
        end
    end
	--return t
end
