local events = require 'lib.samp.events'
require "lib.moonloader"
require "lib.sampfuncs"


local plashka = {show = true,x = "10", y = "450"} -- Тут редактируйте расположение инфы.
local sx, sy = getScreenResolution()
local logo = renderCreateFont('BigNoodleTitlingCyr', 10, 0) -- А тут редактируйте размер текста. Сейчас размер текста "14".
local result
local car = nil
local zad = false
local stateKLK = false
local firstKLK = true
local coordOn = true

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

function setMarker(type, x, y, z, radius, color)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    checkpoint = addBlipForCoord(x, y, z)
    marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
    changeBlipColour(checkpoint, color)
    lua_thread.create(function()
    repeat
        wait(0)
        local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
        until getDistanceBetweenCoords3d(x, y, z, x1, y1, z1) < radius or not doesBlipExist(checkpoint)
        deleteCheckpoint(marker)
        removeBlip(checkpoint)
        addOneOffSound(0, 0, 0, 1149)
    end)
end

function setMarkerKV(arg)

	kvl, kvn = string.match(arg, "(%W)%-(%d+)")
	if (kvl == nil or kvn == nil) then 
		kvl, kvn = string.match(arg, "(%W)(%d+)")
	end
		
	if (kvl == nil or kvn == nil) then 
		sampAddChatMessage("{4169E1}[APLHA]: {ffffff}Используйте /setkv {ff0000}[квадрат]{ffffff}. Пример: /setkv {ff0000}А-1", 0xFFFFFF)
		return 
	end
	
	if (kvadratnum(kvl) ~= nil and tonumber(kvn) > 0 and tonumber(kvn) < 25) then
		
		
		local coordx = tonumber(kvn)*250-3250 + 125
		local coordy = 3250-kvadratnum(kvl)*250 - 125
		
		local pedx, pedy, pedz = getCharCoordinates(PLAYER_PED)
		
		if (placeWaypoint(coordx, coordy, pedz) == true) then
			local dist = math.floor(math.sqrt((coordx-pedx)*(coordx-pedx) + (coordy-pedy)*(coordy-pedy))*100)/100
			sampAddChatMessage("{4169E1}[APLHA]: {ffffff}Метка установлена в квадрат {ff0000}"..kvl.."-"..kvn..". {ffffff}Расстояние: {ff0000}"..dist.." {ffffff}метров.", 0xFFFFFF)
		else
			sampAddChatMessage("{4169E1}[APLHA]: {ffffff}Поставьте метку в любой точке карты для работы", 0xFFFFFF)
		end
		
	else 
		sampAddChatMessage("{4169E1}[APLHA]: {ffffff}Такого квадрата не существует", 0xFFFFFF)
	end
	
	
end

function testCheats()
	if testCheat('KLK') then
		stateKLK = not stateKLK
		firstKLK = true
		if stateKLK then printStringNow('~g~+', 1000) 
		else printStringNow('~r~-', 1000) 
		end
	end
	
	if testCheat('ZAD') then 
		zad = not zad
		if zad then
			printStringNow('~g~ZAD', 1000) 
		else
			printStringNow('~r~ZAD', 1000) 
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
					end	
				elseif firstKLK == true then
					printStringNow('~y~'..string.sub(tostring(getCarSpeed(veh)),0,4), 1000)
				end
			else 
				stateKLK = false
				firstKLK = true
				printStringNow('', 1000) 
			end
		else 
			stateKLK = false
			firstKLK = true
			printStringNow('', 1000) 
		end
	end
end

function ZADTest()
	if zad then setCameraBehindPlayer() end
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
		
		renderFontDrawText(logo, "Направление: "..naprav.."\nКвадрат: " ..kvadrat().."\nВысота: "..math.floor(pedz), plashka.x, sy-plashka.y+renderGetFontDrawHeight(logo), 0xFFFFFFFF)
		
end

function coord()
	coordOn = not coordOn
end

function doEveryTime()
	KLKTest()
	ZADTest()
	COORDTest()
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
		while not isSampAvailable() do wait(100) end
	
	sampRegisterChatCommand("setkv", setMarkerKV)
	sampRegisterChatCommand("coord", coord)
	while true do wait(0)
		testCheats()
		doEveryTime()
	end
end
