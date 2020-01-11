json = require "json"
plistCore = require "plist.core"
local _M = {}

function _M.read(plistFilePath)
	local jsonString = plistCore.plistFileToJsonString(plistFilePath);
	return json.decode(jsonString);
end

function _M.write(luaTable, plistFilePath, format)
	local jsonString = json.encode(luaTable);
	return plistCore.jsonStringToPlistFile(jsonString, plistFilePath, format);
end

function _M.load(plistString)
	local jsonString = plistCore.plistStringToJsonString(plistString);
	return json.decode(jsonString);
end

function _M.dump(luaTable, format)
	local jsonString = json.encode(luaTable);
	return plistCore.jsonStringToPlistString(jsonString, format);
end

return _M