local json = require 'pendragon/vendor.json'
local class = require 'pendragon/vendor.middleclass'
require 'pendragon/vendor.helper'

local Headers = class('Headers')
function Headers:initialize(headerArray)
    self.headers = {}
    for k, v in pairs(headerArray) do
        local header = explode(':', v, 2)
        if (table.getn(header) == 2) then
            self.headers[string.lower(header[1])] = trim(header[2])
        end
    end
end

function Headers:get(field)
    return self.headers[field] or nil
end

local Response = class('Response')
function Response:initialize(url, headers, body)
    self.ok = false
    if (headers ~= nil) then
        local headerArray = split('\n', headers)
        local httpStatus = table.remove(headerArray, 1)
        if (string.find(httpStatus, ' 100 Continue')) then
            httpStatus = table.remove(headerArray, 2)
        end
        local status = table.pack(string.match(httpStatus, '(HTTP%/.+) (%d+) (.+)'))
        self.headers = Headers(headerArray)
        self.httpVersion = status[1]
        self.status = tonumber(status[2])
        self.statusText = status[3]
        self.ok = self.status >= 200 and self.status < 300
    end
    self.body = body
    self.url = url
end

function Response:isJson()
    if (self.headers ~= nil) then
        return string.find(self.headers:get('content-type'), 'application/json') ~= nil
    end
    return false
end

function Response:text()
    if (isTable(self.body)) then
        return json.decode(self.body)
    end
    return self.body
end

function Response:json()
    if (isTable(self.body)) then
        return self.body
    end
    return json.decode(self.body)
end

function Response:resolve(func, handler)
    local status, result = pcall(func, self)
    if (not status) then
        return handler(result)
    end
    return result
end

return Response
