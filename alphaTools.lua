local events = require 'lib.samp.events'
require "lib.moonloader"
require "lib.sampfuncs"

local plashka = {show = true,x = "10", y = "450"} 
local logo = renderCreateFont('BigNoodleTitlingCyr', 14, 4)
local result
local car = nil
local zad = false
local stateKLK = false
local firstKLK = true
local coordOn = true
local colorSheme = { firstColor = "{FF0000}", secondColor = "{ffffff}"}

function addScriptMsg(str)
	sampAddChatMessage("{4169E1}[ALPHA]: "..colorSheme.secondColor..str, 0xFFFFFF)
end

function kvadrat()
	local KV = {
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
    }

    local X, Y, Z = getCharCoordinates(PLAYER_PED)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
	if (Y == nil) then Y = "" end
    local KVX = (Y.."-"..X)
    return KVX
end

function kvadratnum(param)
  local KV = {
    ["А"] = 1,
    ["Б"] = 2,
    ["В"] = 3,
    ["Г"] = 4,
    ["Д"] = 5,
    ["Ж"] = 6,
    ["З"] = 7,
    ["И"] = 8,
    ["К"] = 9,
    ["Л"] = 10,
    ["М"] = 11,
    ["Н"] = 12,
    ["О"] = 13,
    ["П"] = 14,
    ["Р"] = 15,
    ["С"] = 16,
    ["Т"] = 17,
    ["У"] = 18,
    ["Ф"] = 19,
    ["Х"] = 20,
    ["Ц"] = 21,
    ["Ч"] = 22,
    ["Ш"] = 23,
    ["Я"] = 24,
    ["а"] = 1,
    ["б"] = 2,
    ["в"] = 3,
    ["г"] = 4,
    ["д"] = 5,
    ["ж"] = 6,
    ["з"] = 7,
    ["и"] = 8,
    ["к"] = 9,
    ["л"] = 10,
    ["м"] = 11,
    ["н"] = 12,
    ["о"] = 13,
    ["п"] = 14,
    ["р"] = 15,
    ["с"] = 16,
    ["т"] = 17,
    ["у"] = 18,
    ["ф"] = 19,
    ["х"] = 20,
    ["ц"] = 21,
    ["ч"] = 22,
    ["ш"] = 23,
    ["я"] = 24,
  }
  return KV[param]
end


function setMarkerKV(arg)
	kvl, kvn = string.match(arg, "(%W)%-(%d+)")
	if (kvl == nil or kvn == nil) then 
		kvl, kvn = string.match(arg, "(%W)(%d+)")
	end
		
	if (kvl == nil or kvn == nil) then 
		addScriptMsg("Используйте /setkv "..setColor("[квадрат]")..". Пример: /setkv "..setColor("А-1"))
		return 
	end
	
	if (kvadratnum(kvl) ~= nil and tonumber(kvn) > 0 and tonumber(kvn) < 25) then
		local coordx = tonumber(kvn)*250-3250 + 125
		local coordy = 3250-kvadratnum(kvl)*250 - 125
		
		local pedx, pedy, pedz = getCharCoordinates(PLAYER_PED)
		
		if (placeWaypoint(coordx, coordy, pedz) == true) then
			local dist = math.floor(math.sqrt((coordx-pedx)*(coordx-pedx) + (coordy-pedy)*(coordy-pedy))*100)/100
			addScriptMsg("Метка установлена в квадрат "..setColor(kvl.."-"..kvn)..". Расстояние: "..setColor(dist).." метров.")
		else
			addScriptMsg("Неизвестная ошибка.")
		end
		
	else 
		addScriptMsg("Такого квадрата не существует.")
	end
	
	
end

function testCheats()
	if testCheat('KLK') then
		stateKLK = not stateKLK
		firstKLK = true
		if stateKLK then 
			if (KLKTest() == true) then 
				addScriptMsg("KLK активирован.") 
			else
				addScriptMsg("KLK не может быть активирован.") 
			end
		else 
			addScriptMsg("KLK отключен.") 
		end
	end
	
	if testCheat('ZAD') then 
		zad = not zad
		if zad then
			addScriptMsg("ZAD активирован.")
		else
			addScriptMsg("ZAD отключен.")
		end
	end
end

function KLKTest()
	if stateKLK then
		if (isCharInModel(PLAYER_PED, 487) or isCharInModel(PLAYER_PED, 497)) then
			local veh = storeCarCharIsInNoSave(PLAYER_PED)
			if isCarEngineOn(veh) then 
				if getCarSpeed(veh) < 2 then 
					setCarForwardSpeed(veh, 0) 
					if (firstKLK == true) then 
						printStringNow('~y~Stayed', 1000)
						firstKLK = false
						return true
					end	
				elseif firstKLK == true then
					printStringNow('~y~'..string.sub(tostring(getCarSpeed(veh)),0,4), 1000)
					return true
				end
			else 
				stateKLK = false
				firstKLK = true
			end
		else 
			stateKLK = false
			firstKLK = true
		end
	end
	return false
end

function ZADTest()
	if zad then setCameraBehindPlayer() end
end

function setColor(str)
	return colorSheme.firstColor..str..colorSheme.secondColor
end



function COORDTest()
	if not coordOn then return end
		
	local naprav = ""
	if getCharHeading(PLAYER_PED) >= 337.5 or getCharHeading(PLAYER_PED) <= 22.5 then naprav = "Северное" end
       if getCharHeading(PLAYER_PED) > 22.5 and getCharHeading(PLAYER_PED) <= 67.5 then naprav = "Северо-западное" end
       if getCharHeading(PLAYER_PED) > 67.5 and getCharHeading(PLAYER_PED) <= 112.5 then naprav = "Западное" end
       if getCharHeading(PLAYER_PED) > 112.5 and getCharHeading(PLAYER_PED) <= 157.5 then naprav = "Юго-западное" end
       if getCharHeading(PLAYER_PED) > 157.5 and getCharHeading(PLAYER_PED) <= 202.5 then naprav = "Южное" end
       if getCharHeading(PLAYER_PED) > 202.5 and getCharHeading(PLAYER_PED) <= 247.5 then naprav = "Юго-восточное" end
       if getCharHeading(PLAYER_PED) > 247.5 and getCharHeading(PLAYER_PED) <= 292.5 then naprav = "Восточное" end
       if getCharHeading(PLAYER_PED) > 292.5 and getCharHeading(PLAYER_PED) <= 337.5 then naprav = "Северо-восточное" end
	
	local pedx, pedy, pedz = getCharCoordinates(PLAYER_PED)
	local bool, waypointx, waypointy, waypointz = getTargetBlipCoordinates()
	
	if (bool) then 
		renderFontDrawText(logo, "Направление: "..setColor(naprav).."\nКвадрат: " ..setColor(kvadrat()).."\nВысота: "..setColor(math.floor(pedz)).."\nМетка: "..setColor(math.floor(math.sqrt((waypointx-pedx)*(waypointx-pedx) + (waypointy-pedy)*(waypointy-pedy))*100)/100), plashka.x, plashka.y, 0xFFFFFFFF)
	else
		renderFontDrawText(logo, "Направление: "..setColor(naprav).."\nКвадрат: " ..setColor(kvadrat()).."\nВысота: "..setColor(math.floor(pedz)), plashka.x, plashka.y, 0xFFFFFFFF)
	end
end



function doEveryTime()
	KLKTest()
	ZADTest()
	COORDTest()
end

function loadSettings()
	local file = io.open("moonloader\\config\\alphaTools.ini", "r")
	
	if (file == nil) then
		file = io.open("moonloader\\config\\alphaTools.ini", "w+")
		file:write(plashka.x.." "..plashka.y)
		file:close()
	else
		local xpos, ypos = string.match(file:read("*line"), "(%d+) (%d+)")
		file:close()
		if (xpos == nil or ypos == nil) then 
			addScriptMsg("Ошибка чтения файла. Файл перезаписан.")
			file = io.open("moonloader\\config\\alphaTools.ini", "w+")
			file:write(plashka.x.." "..plashka.y)
			file:close()
		else
			plashka.x = xpos
			plashka.y = ypos
		end
	end
end

function coordpos(args)
	local xpos, ypos = string.match(args, "(%d+) (%d+)")
	
	if (xpos == nil or ypos == nil) then 
		addScriptMsg("Используйте /coordpos "..setColor("[x] [y]"))
		return
	end
	
	plashka.x = xpos;
	plashka.y = ypos;
	
	local file = io.open("moonloader\\config\\alphaTools.ini", "w")
	file:write(xpos.." "..ypos)
	file:close()
end


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
		while not isSampAvailable() do wait(100) end
	
	
	loadSettings()
	
	sampRegisterChatCommand("alphahelp", function()
		sampShowDialog(6405, "AlphaTools", "{4169E1}/alphahelp {ffffff}- функции скрипта\n{4169E1}/setkv [квадрат] {ffffff}- устанавливает метку в выбранный квадрат\n{4169E1}/coord {ffffff}- включает/отключает меню координации\n{4169E1}/coordpos [x] [y] {ffffff}- устанавливает позицию меню координации\n{4169E1}KLK {ffffff}- как чит-код, останавливает Maverick в воздухе, если скорость меньше 2-ух\n{4169E1}ZAD {ffffff}- как чит-код, фиксирует камеру за персонажем","Закрыть","Закрыть",0)
	end)
	
	sampRegisterChatCommand("setkv", setMarkerKV)
	sampRegisterChatCommand("coordpos", coordpos)
	sampRegisterChatCommand("coord", function() coordOn = not coordOn end)
	

	addScriptMsg("AlphaTools загружен. Помощь: /alphahelp.")
	
	while true do wait(0)
		testCheats()
		doEveryTime()
	end
end
