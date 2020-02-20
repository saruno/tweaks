local http = require("socket.http")
local json = require"json"
local ltn12 = require"ltn12"

LOCALHOST_API = "http://localhost:8080"

function downFile(httpUrl, path)
    local response_body = {}
    local status,code,header = http.request{
        url = httpUrl,
        headers =
            {
               ["Content-Type"] = "application/x-www-form-urlencoded",
            },
        sink = ltn12.sink.table(response_body),
    }
    data = table.concat(response_body)
    if code == 200 then
        local file = io.open(path,"wb")
        if file then           
            file:write(data)
            file:close()
            return true
        end
        return false
    else
        return false
    end
end

function exe(cmd)
    local c = io.popen(cmd)
    local res = c:read("*a")
    c:close()
    return res
  end

function downFileCurl(httpUrl, path)
    exe("curl -o "..path.." "..httpUrl)
    mSleep(5000)
    return true
end

function httpGet(httpUrl, params)
    local response_body = {}
    local status,code,header = http.request{
        url = httpUrl.."?"..params,
        headers = 
            {
                ["Content-Type"] = "text/html",
            },
        sink = ltn12.sink.table(response_body),
    }
    if code == 200 then
        return table.concat(response_body)
    else
        return nil
    end
end


-- Functions merge with touchsprite
function mSleep(millis)
    usleep(1000 * millis);
  end

fileUrl = "http://p2o.wiimob.com/autotools/wiiauto.zip"

httpGet(LOCALHOST_API.."/control/stop_playing", "path=/AutoInstallApp.at")
mSleep(1000)
exe("proxytool 0") -- Reset proxy
mSleep(1000)
removeTimer("/ControlAutorun.lua")
mSleep(1000)
-- Remove Folder
-- exe("rm -rf "..rootDir().."/AutoInstallApp.at")
-- mSleep(2000)
-- exe("rm -rf "..rootDir().."/ServerConfig.lua")
-- mSleep(2000)
-- exe("rm -rf "..rootDir().."/ControlAutorun.lua")
-- mSleep(2000)
exe("yes n | find /private/var/mobile/Library/WiiAuto/Scripts ! -name 'Install.lua' -type f -exec rm -f {} +")
mSleep(2000)
exe("yes n | find /private/var/mobile/Library/WiiAuto/Scripts ! -name 'Scripts' -type d -exec rm -r {} +")
mSleep(2000)
-- Download
filePath = rootDir().."/AutoInstallApp.zip"
flag = downFile(fileUrl, filePath)
mSleep(2000)
if flag then
    exe("unzip "..filePath.." -d "..rootDir())
    exe("rm -f "..filePath)
end

httpGet(LOCALHOST_API.."/control/start_playing", "path=/AutoInstallApp.at/ios_initdevice.lua")
mSleep(5000)
-- Set loop interval
-- Autolaunch tao ra crash
setTimer("/ControlAutorun.lua", 30, true, 60)
--
toast("Finish Setup", 10)