
CtrlNames = {
	Login = "Login",
	GameLobby = "GameLobby",
	Niuniu = "Niuniu",
	Room = "Room",
	ShierzhiRoom = "ShierzhiRoom",
	Dealer = "Dealer",
	Bank = "Bank",
	PlayerList="PlayerList",
	Loading = "Loading",
	Rule = "Rule",
	Setting = "Setting",
	JoinRoom = "JoinRoom",
	Tip = "Tip",
	Support = "Support",
    GameScore = "GameScore",
    SendInvitation = "SendInvitation",
    PaiGow = "PaiGow",
    Chat = "Chat",
    SetRoom="SetRoom",
    YaoLeZi="YaoLeZi",
    Sanshui = "Sanshui",
    Test = "Test",
    MaJiang = "MaJiang",
    Mail = "Mail",
    Shop = "Shop",
    People = "People",
    Customer="Customer",
    Notice = "Notice",
    History="History",
}

Util = LuaFramework.Util;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;
ByteBuffer = LuaFramework.ByteBuffer;

resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
gameMgr = LuaHelper.GetGameManager();

-- networkMgr = LuaHelper.GetNetManager();

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;
PlayerPrefs = UnityEngine.PlayerPrefs;
Input = UnityEngine.Input;
KeyCode = UnityEngine.KeyCode;
Screen = UnityEngine.Screen;
Application = UnityEngine.Application;

GameData = {};

function GameData.getMoveRota()
	local standard_aspect = 1280 / 720;
	local device_aspect = Screen.width / Screen.height;
	local scale = 0;
	if (device_aspect > standard_aspect) then
	    scale = device_aspect / standard_aspect;
	else
	    scale = standard_aspect / device_aspect;
	end
	return scale
end

function GameData.getTimeForSecond (second)
	local hours = math.floor(second / 3600);
	second = second - hours * 3600;

	local minute = math.floor(second / 60);
	second = second - minute * 60;

	local hoursInfo = GameData.changeFoLimitTime(hours);
	local minuteInfo = GameData.changeFoLimitTime(minute);
	local secondInfo = GameData.changeFoLimitTime(second);

	return hoursInfo .. ":" .. minuteInfo .. ":" .. secondInfo;
end

-- 秒换算时间格式
function GameData.getTimeForSecond2 (second)
  local minute = math.floor(second / 60);
  second = second - minute * 60;

  local minuteInfo = GameData.changeFoLimitTime(minute);
  local secondInfo = GameData.changeFoLimitTime(second);

  return minuteInfo .. ":" .. secondInfo;
end

--个位数补0
function GameData.changeFoLimitTime (num)
	local info = "";
	if (num < 10) then
		info = "0" .. num;
	else
		info = tostring(num);
	end
	return info;
end

-- 通过时间戳获取时间列表
-- year month day hour min sec
function GameData.getTimeTableForNum(num)
    return os.date("*t", num);
end

function GameData.GetShortName(sName,nMaxCount,nShowCount)
    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0
    if nShowCount == nil then
       nShowCount = nMaxCount - 3
    end
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            table.insert(tCode,1)

        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName,char)
            table.insert(tCode,2)
        end
    end

    if nWidth > nMaxCount then
        local _sN = ""
        local _len = 0
        for i=1,#tName do
            _sN = _sN .. tName[i]
            _len = _len + tCode[i]
            if _len >= nShowCount then
                break
            end
        end
        sName = _sN .. "..."
    end
    return sName
end

function GameData.deepCopy(newTble, oldTbl)  
    if oldTbl == nil then  
        return  
    end  
    for key,value in pairs(oldTbl) do  
        if type(value) == "table" then  
            newTble[key] = {}  
            GameData.deepCopy(newTble[key], value)  
        elseif type(value) == "userdata" then  
            newTble[key] = value  
        elseif type(value) == "thread" then  
            newTble[key] = value  
        else  
            newTble[key] = value  
        end  
    end  
end  