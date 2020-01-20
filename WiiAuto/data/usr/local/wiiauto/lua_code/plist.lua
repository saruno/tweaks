json = require "json"
local _M = {}

function _M.read(plistFilePath)
	local jsonString = wiiplist.fileToJson(plistFilePath);
	return json.decode(jsonString);
end

function _M.write(luaTable, plistFilePath, format)
	local jsonString = json.encode(luaTable);
	return wiiplist.jsonToFile(jsonString, plistFilePath, format);
end

return _M