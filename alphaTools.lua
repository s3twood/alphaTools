local events = require 'lib.samp.events'
local inicfg = require 'inicfg'
require "lib.moonloader"
require "lib.sampfuncs"


local logo = renderCreateFont('BigNoodleTitlingCyr', 14, 4)
local result
local car = nil
local zad = false
local stateKLK = false
local firstKLK = true
local configPath = "alphaTools.ini"
local callRecorderPath = "moonloader\\calls.txt"
local activeCall = false


local config = inicfg.load({
	coordMenu = 
	{
		x = 10,
		y = 450,
		active = true
	},
	autokv = 
	{ 
		active = true 
	},
	colorSheme = 
	{ 
		firstColor = "{FF0000}", 
		secondColor = "{FFFFFF}"
	},
	callRecorder = 
	{
		active = true
	}
	
}, configPath)


function events.onServerMessage(color, text)
	
	if(config.autokv.active == true and color == 865730559) then 
		local kv1 = string.match(text, "Alpha, текущее местоположение (%W%-%d+)%.")
		if (kv1 ~= nil) then setMarkerKV(kv1) end
	end
	
	if (config.autokv.active == true) then
	
		if (string.match(text,"%[Информация%]") and string.match(text, "Вы подняли трубку") and color == -1347440641) then
			activeCall = true
			file = io.open(callRecorderPath, "a")
			file:write("["..os.date().."] START CALL\n")
			file:close()
		end
		
		if (string.match(text,"%[Информация%]") and string.match(text, "Звонок окончен! Время разговора") and color == -1347440641) then
			activeCall = false
			file = io.open(callRecorderPath, "a")
			file:write("["..os.date().."] END CALL\n\n")
			file:close()
		end
		
		
		if (activeCall and string.match(text, "%[Тел%]%:") and color == -1) then
			file = io.open(callRecorderPath, "a")
			file:write(string.sub(text,24).."\n")
			file:close()
		end
	end
	
end

function addScriptMsg(str)
	sampAddChatMessage("{4169E1}[ALPHA] "..config.colorSheme.secondColor..str, 0xFFFFFF)
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

	if testCheat('BK') then
		sampSendChat("/d Alpha, текущее местоположение "..kvadrat()..".")
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
	return config.colorSheme.firstColor..str..config.colorSheme.secondColor
end



function COORDTest()
	if not config.coordMenu.active then return end

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
		renderFontDrawText(logo, "Направление: "..setColor(naprav).."\nКвадрат: " ..setColor(kvadrat()).."\nВысота: "..setColor(math.floor(pedz)).."\nМетка: "..setColor(math.floor(math.sqrt((waypointx-pedx)*(waypointx-pedx) + (waypointy-pedy)*(waypointy-pedy))*100)/100), config.coordMenu.x, config.coordMenu.y, 0xFFFFFFFF)
	else
		renderFontDrawText(logo, "Направление: "..setColor(naprav).."\nКвадрат: " ..setColor(kvadrat()).."\nВысота: "..setColor(math.floor(pedz)), config.coordMenu.x, config.coordMenu.y, 0xFFFFFFFF)
	end
end


function doEveryTime()
	KLKTest()
	ZADTest()
	COORDTest()
end


function coordpos(args)
	local xpos, ypos = string.match(args, "(%d+) (%d+)")

	if (xpos == nil or ypos == nil) then
		addScriptMsg("Используйте /coordpos "..setColor("[x] [y]"))
		return
	end
			
	config.coordMenu.x = xpos;
	config.coordMenu.y = ypos;
	
	inicfg.save(config, configPath)
	
end


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
		while not isSampAvailable() do wait(100) end
	

	sampRegisterChatCommand("alphahelp", function()
		sampShowDialog(6405, "AlphaTools",
		[[
{4169E1}/alphahelp {ffffff}- функции скрипта.
{4169E1}/setkv [квадрат] {ffffff}- устанавливает метку в выбранный квадрат.
{4169E1}/coord {ffffff}- включает/отключает меню координации.
{4169E1}/coordpos [x] [y] {ffffff}- устанавливает позицию меню координации.
{4169E1}/autokv {ffffff}- автоматическая установка метки при сообщении в департамент.

{4169E1}KLK {ffffff}- как чит-код, останавливает Maverick в воздухе, если скорость меньше 2-ух.
{4169E1}ZAD {ffffff}- как чит-код, фиксирует камеру за персонажем.
{4169E1}BK {ffffff}- как чит-код, отправляет информацию о текущем местоположении в департамент.
]],
		"Закрыть",
		"",
		0)
	end)

	sampAddChatMessage("test",-1347440641)
	sampRegisterChatCommand("setkv", setMarkerKV)
	sampRegisterChatCommand("coordpos", coordpos)

	sampRegisterChatCommand("coord", function()
		config.coordMenu.active = not config.coordMenu.active
		if config.coordMenu.active then 
			addScriptMsg("Меню координации включено.")
			config.coordMenu.active = true
			inicfg.save(config, configPath)
		else 
			addScriptMsg("Меню координации отключено.")
			config.coordMenu.active = false
			inicfg.save(config, configPath)
		end
	end)

	sampRegisterChatCommand("autokv", function()
		config.autokv.active = not config.autokv.active
		if config.autokv.active then 
			addScriptMsg("Автометка включена.")
			config.autokv.active = true
			inicfg.save(config, configPath)
		else 
			addScriptMsg("Автометка отключена.") 
			config.autokv.active = false
			inicfg.save(config, configPath)
			end
	end)

	addScriptMsg("AlphaTools загружен. Помощь: /alphahelp.")

	while true do wait(0)
		testCheats()
		doEveryTime()
	end
end
