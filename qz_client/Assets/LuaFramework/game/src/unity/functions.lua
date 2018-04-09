
local function _printLog( tag, fmt, ... )
	local t = {
        "[",
        string.upper(tostring(tag)),
        "] ",
        string.format(tostring(fmt), ...)
    }
    Util.Log(table.concat(t));
end
local function _printLogW( tag, fmt, ... )
    local t = {
        "[",
        string.upper(tostring(tag)),
        "] ",
        string.format(tostring(fmt), ...)
    }
    Util.LogWarning(table.concat(t));
end
function logI(fmt, ...)
    if type(DEBUG) ~= "number" or DEBUG < 1 then return end
    _printLog("INFO", fmt, ...)
end

--错误日志--
function logE(str)
	Util.LogError(str);
end

--警告日志--
function logW(fmt, ...)
    if type(DEBUG) ~= "number" or DEBUG < 1 then return end
    _printLogW("Warn", fmt, ...)
end