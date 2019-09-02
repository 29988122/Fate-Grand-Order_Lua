inputText = type
type = typeOf

function isString(str)
    return type(str) == 'string'
end

function isTable(tab)
    return type(tab) == 'table'
end

function isNumber(num)
    return type(num) == 'number'
end

function string.isNumeric(s)
    return tonumber(s) ~= nil
end

function string.isEmpty(s)
  return s == nil or s == ''
end

function fileExists(name)
    local f = io.open(name, 'r')
    if f ~= nil then io.close(f) return true else return false end
end

function readFileInHex(fileName)
    local file = io.open(Config.runtimePath .. fileName, 'rb')
    local t = ''
    repeat
        local str = file:read(4 * 1024)
        for c in (str or ''):gmatch'.' do
            t = t .. string.format('%02X', c:byte())
        end
    until not str
    file:close()
    return t
end

function readFile(fileName)
    local f = assert(io.open(Config.runtimePath .. fileName, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function screenshot(reg, fileName)
    Settings:setCompareDimension(true, 1920)
    setImagePath(Config.runtimePath)
    reg:save(fileName)
    setImagePath(Config.imagePath)
    Settings:setCompareDimension(true, 960)
end

function OCR(region, fileName)
    screenshot(region, fileName)
end

function table.clone(org)
    return { unpack(org) }
end

function validateClick(reg, target, comparison)
    usePreviousSnap(false)
    setImagePath(Config.runtimePath)
    reg:save('validation.png')
    click(target)
    while (reg:exists('validation.png', 0) ~= nil) do
        if (comparison ~= nil) then
            setImagePath(Config.imagePath)
            if(reg:exists(comparison, 0) == nil) then
                break
            end
            setImagePath(Config.runtimePath)
        end
        click(target)
        reg:save('validation.png')
    end
    setImagePath(Config.imagePath)
end

function explode(sep, str, limit)
    if not sep or sep == "" then
        return false
    end
    if not str then
        return false
    end
    limit = limit or mhuge
    if limit == 0 or limit == 1 then
        return {str}, 1
    end

    local r = {}
    local n, init = 0, 1

    while true do
        local s,e = string.find(str, sep, init, true)
        if not s then
            break
        end
        r[#r+1] = string.sub(str, init, s - 1)
        init = e + 1
        n = n + 1
        if n == limit - 1 then
            break
        end
    end

    if init <= string.len(str) then
        r[#r+1] = string.sub(str, init)
    else
        r[#r+1] = ""
    end
    n = n + 1

    if limit < 0 then
        for i=n, n + limit + 1, -1 do r[i] = nil end
        n = n + limit
    end

    return r, n
end

function split(d, p)
    local t, ll
    t={}
    ll=0
    if(#p == 1) then
        return {p}
    end
    while true do
        l = string.find(p, d, ll, true) -- find the next d in the string
        if l ~= nil then -- if "not not" found then..
            table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
            ll = l + 1 -- save just after where we found it for searching next time.
        else
            table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
            break -- Break at end, as it should be, according to the lua manual.
        end
    end
    return t
end

function trim(s)
    return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

function table.pack(...)
    return {...}
end

function addslashes(s)
    s = string.gsub(s, "(['\"\\])", "\\%1")
    return (string.gsub(s, "%z", "\\0"))
end
