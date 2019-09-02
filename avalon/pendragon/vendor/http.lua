local http = { _version = "0.0.1" }
local Response = require 'pendragon/vendor.response'
require 'pendragon/vendor.helper'

local function validateMethod(method)
    if (isString(method)) then
        method = method:upper()
        if (method == 'GET' or method == 'POST' or method == 'PUT' or method == 'PATCH' or method == 'DELETE') then
            return method
        else
            error('[validateMethod] Invalid Method.')
        end
    else
        error('[validateMethod] Invalid Method Type.')
    end
end

local function validateHeaders(headers)
    if (isTable(headers) or data == nil) then
        shadow = {}
        for k, v in pairs(headers) do
            shadow[k:lower()] = v
        end
        return shadow
    else
        error('[validateHeaders] Invalid Headers Type.')
    end
end

local function validateData(data)
    if (isTable(data) or isString(data) or data == nil) then
        return data
    else
        error('[validateData] Invalid Data Type.')
    end
end

local function extractData(data)
    if (data == nil) then return '' end
    local h = {}
    for k, v in pairs(data) do
        h[#h + 1] = string.format('%s=%s', k, v)
    end
    return h
end

local function Headers(headers)
    if (string.isEmpty(headers)) then
        return ''
    elseif (isString(headers)) then
        return string.format('-H "%s"', addslashes(headers))
    elseif (isTable(headers)) then
        local h = {}
        for k, v in pairs(headers) do
            h[#h + 1] = Headers(string.format('%s: %s', k, v))
        end
        return table.concat(h, ' ')
    else
        error('[toHeaderStr] Invalid Headers Type.')
    end
end

local function FormData(data)
    if (string.isEmpty(data)) then
        return ''
    elseif (isString(data)) then
        return string.format('-d "%s"', addslashes(v))
    elseif (isTable(data)) then
        local h = {}
        for k, v in pairs(extractData(data)) do
            h[#h + 1] = string.format('-F "%s"', addslashes(v))
        end
        return table.concat(h, ' ')
    else
        error('[FormData] Invalid Form Data.')
    end
end

function http.fetch(method, url, headers, data)
    method = validateMethod(method)
    headers = validateHeaders(headers)
    data = validateData(data)
    if (method == 'GET') then
        data = table.concat(extractData(data), '&')
        url = url .. (not string.isEmpty(data) and (string.find(url, '%?') and '&' or '?') or '')
    elseif (headers['content-type'] == nil and not isTable(headers)) then
        headers['content-type'] = 'application/x-www-form-urlencoded'
    end
    headers = Headers(headers)
    data = FormData(data)
    local command = string.format('curl -sS -X %s %s %s %s', method, url, headers, data)
    local result = os.execute(string.format(command..' -sD %s/httpHeader.raw -o %s/httpBody.raw', Config.runtimePath, Config.runtimePath))
    if (result == 0) then
        return Response:new(
            url,
            readFile('httpHeader.raw'),
            readFile('httpBody.raw')
        )
    end
    return Response:new(url, nil, { success = false, message = string.format('Failed to connect to %s.', url) })
end

return http
