local api = {}
local http = require('pendragon/vendor.http')
local hash = require('pendragon/vendor.sha256')
local System = luajava.bindClass('java.lang.System')
local Config = require('pendragon/config')
require 'pendragon/vendor.helper'

local function calcHash(method, endpoint, token, time)
    return hash.sha256(string.format("fgobot%s%s%s%i_%s", method, token, endpoint, time, Config.API_KEY))
end

local function fetchAPI(method, endpoint, headers, data, isAuth)
    if (not isTable(headers) and headers ~= nil) then error('[fetchAPI] Invalid Headers') end
    if (headers == nil) then headers = {} end
    if (isAuth) then
        headers['X-FGO-TOKEN'] = getDeviceID()
    end
    local requestTime = System:currentTimeMillis()
    local fullURL = not string.find(endpoint, Config.API_URL) and Config.API_URL .. endpoint or endpoint
    headers['X-FGO-REQUEST-TIME'] = requestTime
    headers['X-FGO-HASH'] = calcHash(method, endpoint, getDeviceID(), requestTime)
    return http
        .fetch(method, fullURL, headers, data)
        :resolve(
            function (res)
                if (res.ok) then
                    return res:isJson() and res:json() or { success=false, message=res:text() }
                else
                    message = string.format('%d - Unexpected Error', res.status)
                    if (res:isJson()) then
                        result = res:json()
                        message = result.message
                    end
                    error({message=message})
                end
            end,
            function (error)
                return { success=false, message=error.message }
            end
        )
end

function api.fetchCurrentStage(fileName)
    local path = '@'..GeneralImagePath..fileName
    return fetchAPI('POST', '/battle/current-stage', nil, {file=path}, false)
end

function api.postStartQuest(id)
    return fetchAPI('POST', '/quest/'..id..'/start', nil, nil, true)
end

function api.postEndQuest(id)
    return fetchAPI('POST', '/quest/'..id..'/end', nil, nil, true)
end

function api.log(message)
    return fetchAPI('POST', '/log', nil, {message=message}, false)
end

function api.debug(filename)
    local path = '@'..GeneralImagePath..filename
    return fetchAPI('POST', '/data/transfer', nil, {file=path}, false)
end

return api
