script_name("alphaTools")
script_author("Foxy_L")
script_version("25.06.2022")

local events = require 'lib.samp.events'
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local encoding = require 'encoding'

require "lib.moonloader"
require "lib.sampfuncs"

encoding.default = 'CP1251'
local u8 = encoding.UTF8

local logo = renderCreateFont('BigNoodleTitlingCyr', 14, 4)
local zad = false
local stateKLK = false
local firstKLK = true
local configPath = "alphaTools.ini"
local callRecorderPath = "moonloader\\callRecord.txt"
local activeCall = false
local contactTimer = os.time()
local goFind = false
local searchTime = 900
local main_window_state = imgui.ImBool(false)
local call_window_state = imgui.ImBool(false)
local screenX, screenY = getScreenResolution()
local kvBlocked = false

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
	},
	onlyCallMode =
	{
		active = true
	}

}, configPath)

local coordActive = imgui.ImBool(config.coordMenu.active)
local autokvActive = imgui.ImBool(config.autokv.active)
local callRecorderActive = imgui.ImBool(config.callRecorder.active)
local onlyCallModeActive = imgui.ImBool(config.onlyCallMode.active)
local coordPosX = imgui.ImFloat(config.coordMenu.x)
local coordPosY = imgui.ImFloat(config.coordMenu.y)

function events.onServerMessage(color, text)

	if(config.autokv.active and color == 865730559) then
		local kv1 = string.match(text, "Alpha, текущее местоположение (%W%-%d+)%.")
		if (kv1 ~= nil) then setMarkerKV(kv1) end
	end

	if(color == 865730559) then
		local kv1 = string.match(text, "Alpha, визуальный контакт с нарушителем потерян в (%W%-%d+)%. Начинайте поиски.")
		if (kv1 ~= nil) then
			goFind = true
			setMarkerKV(kv1)
			contactTimer = os.time()
		end
	end

	if(color == 865730559) then
		local kv1 = string.match(text, "Alpha, визуальный контакт с нарушителем получен в (%W%-%d+)%. Веду погоню.")
		if (kv1 ~= nil) then
			goFind = false
			setMarkerKV(kv1)
		end
	end


	if (string.match(text,"%[Информация%]") and string.match(text, "Вы подняли трубку") and color == -1347440641) then
		activeCall = true
		if (config.callRecorder.active) then
			file = io.open(callRecorderPath, "a")
			file:write("["..os.date().."] START CALL\n")
			file:close()
		end
	end

	if (string.match(text,"%[Информация%]") and string.match(text, "Звонок окончен! Время разговора") and color == -1347440641) then
		activeCall = false
		if (config.callRecorder.active) then
			file = io.open(callRecorderPath, "a")
			file:write("["..os.date().."] END CALL\n\n")
			file:close()
		end
	end


	if (activeCall and string.match(text, "%[Тел%]%:") and color == -1) then
		if (config.callRecorder.active) then
			file = io.open(callRecorderPath, "a")
			file:write(string.sub(text,24).."\n")
			file:close()
		end
	end


	if (config.onlyCallMode.active and activeCall) then
		if (string.match(text,"%[Информация%]") and string.match(text, "Вы подняли трубку") and color == -1347440641) or (string.match(text,"%[Информация%]") and string.match(text, "Звонок окончен! Время разговора") and color == -1347440641) or (string.match(text, "%[Тел%]%:") and color == -1) then
			return true
		else
			return false
		end
	end

end

function addScriptMsg(str)
	sampAddChatMessage("{4169E1}[ALPHA] "..config.colorSheme.secondColor..str, 0xFFFFFF)
end

function kvadrat()
    local X, Y, Z = getCharCoordinates(PLAYER_PED)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = string.sub("АБВГДЖЗИКЛМНОПРСТУФХЦЧШЯ",Y, Y)
	if (Y == nil) then Y = "" end
    local KVX = (Y.."-"..X)
    return KVX
end

function kvadratnum(param)
  return string.find("АБВГДЖЗИКЛМНОПРСТУФХЦЧШЯ", param) or string.find("абвгджзиклмнопрстуфхцчшя", param)
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

		if (placeWaypoint(coordx, coordy, pedz)) then
			local dist = math.floor(math.sqrt((coordx-pedx)*(coordx-pedx) + (coordy-pedy)*(coordy-pedy))*100)/100
			addScriptMsg("Метка установлена в квадрат "..setColor(kvl.."-"..kvn)..". Расстояние: "..setColor(dist).." метров.")
		else
			addScriptMsg("Неизвестная ошибка.")
		end

	else
		addScriptMsg("Такого квадрата не существует.")
	end
end

function addGangZone(id, left, up, right, down, color)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, id)
    raknetBitStreamWriteFloat(bs, left)
    raknetBitStreamWriteFloat(bs, up)
    raknetBitStreamWriteFloat(bs, right)
    raknetBitStreamWriteFloat(bs, down)
    raknetBitStreamWriteInt32(bs, color)
    raknetEmulRpcReceiveBitStream(108, bs)
    raknetDeleteBitStream(bs)
end
function removeGangZone(id)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, id)
    raknetEmulRpcReceiveBitStream(120, bs)
    raknetDeleteBitStream(bs)
end


function blockkv(arg)
	if (kvBlocked) then 
		addScriptMsg("Перекрытая зона убрана с карты.")
		removeGangZone("CloseZone")
		kvBlocked = false
		return
	end
	
	kvl, kvn = string.match(arg, "(%W)%-(%d+)")
	if (kvl == nil or kvn == nil) then
		kvl, kvn = string.match(arg, "(%W)(%d+)")
	end

	if (kvl == nil or kvn == nil) then
		addScriptMsg("Используйте /blockkv "..setColor("[квадрат]")..". Пример: /blockkv "..setColor("А-1"))
		return
	end

	if (kvadratnum(kvl) ~= nil and tonumber(kvn) > 0 and tonumber(kvn) < 25) then
		local leftx = tonumber(kvn)*250-3500
		local lefty = 3500-kvadratnum(kvl)*250
		addGangZone("CloseZone", leftx, lefty - 750, leftx+750, lefty, 0x800000FF)
		addScriptMsg("Квадрат "..setColor(kvl.."-"..kvn).." и прилегающие к нему отмечены на карте.")
		kvBlocked = true
	else
		addScriptMsg("Такого квадрата не существует.")
	end
end

function testCheats()
	if testCheat('KLK') then
		stateKLK = not stateKLK
		firstKLK = true
		if stateKLK then
			if (KLKTest()) then
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
					if (firstKLK) then
						printStringNow('~y~Stayed', 1000)
						firstKLK = false
						return true
					end
				elseif firstKLK then
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
	if config.coordMenu.active then

		local naprav = ""
		local charHeading = getCharHeading(PLAYER_PED)

		if charHeading >= 337.5 or  charHeading <= 22.5  then naprav = "Северное" end
		if charHeading >  22.5  and charHeading <= 67.5  then naprav = "Северо-западное" end
		if charHeading >  67.5  and charHeading <= 112.5 then naprav = "Западное" end
		if charHeading >  112.5 and charHeading <= 157.5 then naprav = "Юго-западное" end
		if charHeading >  157.5 and charHeading <= 202.5 then naprav = "Южное" end
		if charHeading >  202.5 and charHeading <= 247.5 then naprav = "Юго-восточное" end
		if charHeading >  247.5 and charHeading <= 292.5 then naprav = "Восточное" end
		if charHeading >  292.5 and charHeading <= 337.5 then naprav = "Северо-восточное" end

		local pedx, pedy, pedz = getCharCoordinates(PLAYER_PED)
		local bool, waypointx, waypointy = getTargetBlipCoordinates()

		local renderString = "Направление: "..setColor(naprav).."\nКвадрат: " ..setColor(kvadrat()).."\nВысота: "..setColor(math.floor(pedz))
		if (bool) then renderString = renderString.."\nМетка: "..setColor(math.floor(math.sqrt((waypointx-pedx)*(waypointx-pedx) + (waypointy-pedy)*(waypointy-pedy))*100)/100) end
		if (goFind) then
			local findTime = contactTimer+searchTime-os.time()
			local findTimeMin = math.floor(findTime/60)
			local findTimeSec = findTime%60
			if (findTimeSec < 10) then findTimeSec = "0"..findTimeSec end
			renderString = renderString.."\nПоиски: "..setColor(findTimeMin..":"..findTimeSec)
		end

		renderFontDrawText(logo, renderString, config.coordMenu.x, config.coordMenu.y, 0xFFFFFFFF)
	end
end

function findTest()
	if goFind and contactTimer+searchTime-os.time() < 1 then
		goFind = false
		addScriptMsg("Бандиты потеряны. Погоня не ведётся.")
	end
end

function keyPressTest()
	
end

function doEveryTime()
	KLKTest()
	ZADTest()
	COORDTest()
	findTest()
	keyPressTest()
end

function imgui.OnDrawFrame()

	imgui.ShowCursor = main_window_state.v or call_window_state.v
	
	
	if main_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(600, 200), imgui.Cond.FirstUseEver)

		imgui.Begin(u8'Настройки', main_window_state)

		if imgui.Checkbox(u8'Меню координации', coordActive) then
			config.coordMenu.active = coordActive.v
			if config.coordMenu.active then addScriptMsg("Меню координации включено.")
			else addScriptMsg("Меню координации отключено.") end

			inicfg.save(config, configPath)
		end

		if imgui.SliderFloat(u8"Позиция по горизонтали", coordPosX, 0, screenX) then
			config.coordMenu.x = coordPosX.v
			inicfg.save(config, configPath)
		end

		if imgui.SliderFloat(u8"Позиция по вертикали", coordPosY, 0, screenY) then
			config.coordMenu.y = coordPosY.v
			inicfg.save(config, configPath)
		end

		if imgui.Checkbox(u8'Автометка', autokvActive) then
			config.autokv.active = autokvActive.v
			if config.autokv.active then addScriptMsg("Автометка включена.")
			else addScriptMsg("Автометка отключена.") end

			inicfg.save(config, configPath)
		end

		if imgui.Checkbox(u8'Запись звонков', callRecorderActive) then
			config.callRecorder.active = callRecorderActive.v
			if config.callRecorder.active then addScriptMsg("Сохранение звонков включено.") 
			else addScriptMsg("Сохранение звонков отключено.") end

			inicfg.save(config, configPath)
		end

		if imgui.Checkbox(u8'Режим "только звонок"', onlyCallModeActive) then
			config.onlyCallMode.active = onlyCallModeActive.v
			if config.onlyCallMode.active then addScriptMsg("Отображение только телефона при звонке включено.")
			else addScriptMsg("Отображение только телефона при звонке отключено.") end

			inicfg.save(config, configPath)
		end
		imgui.End()
	end
	
	
	
	if call_window_state.v then
		imgui.ShowCursor = true
		imgui.SetNextWindowSize(imgui.ImVec2(600, 200), imgui.Cond.FirstUseEver)
		
		imgui.Begin(u8'Звонки', call_window_state)
			file = io.open(callRecorderPath, "r")
			if file ~= nil then
				local text = ""
				
				 for line in file:lines() do 
					text = text..line.."\n"
				 end
				 file:close()
				 imgui.Text(u8:decode(text))
			else
				imgui.Text(u8"Нет звонков.")
			end
			
			
			
		imgui.End()
	end
	
	
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
		while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand("alphahelp", function()
		sampShowDialog(6405, "AlphaTools",
		[[
{4169E1}/alphahelp {ffffff}- функции скрипта.
{4169E1}/alphasettings {ffffff}- настройки скрипта.
{4169E1}/setkv [квадрат] {ffffff}- устанавливает метку в выбранный квадрат.
{4169E1}/blockkv [квадрат] {ffffff}- отмечает перекрытую территорию относительно квадрата на карте.
{4169E1}/fc {ffffff}- получен визуальный контакт с бандитами. Убирает таймер погони.
{4169E1}/lc {ffffff}- потерян визуальный контакт с бандитами. Запускается таймер погони.
{4169E1}/callsrec {ffffff}- открыть записи звонков.

{4169E1}KLK {ffffff}- как чит-код, останавливает Maverick в воздухе, если скорость меньше 2-ух.
{4169E1}ZAD {ffffff}- как чит-код, фиксирует камеру за персонажем.
{4169E1}BK {ffffff}- как чит-код, отправляет информацию о текущем местоположении в департамент.

{4169E1}Меню координации {ffffff}- указывает ваше направление, квадрат, высоту, расстояние до метки, таймер поимки.
{4169E1}Автометка {ffffff}- автоматическая установка метки при сообщении в департамент.
{4169E1}Запись звонков {ffffff}- сохраняет все ваши звонки в текстовый файл moonloader/callRecord.txt.
{4169E1}Режим "только звонок" {ffffff}- при разговоре по телефону все остальные сообщения в чате не отображаются.
]],
		"Закрыть",
		"",
		0)
	end)

	sampRegisterChatCommand("setkv", setMarkerKV)
	sampRegisterChatCommand("blockkv", blockkv)
	
	
	sampRegisterChatCommand("fc", function()
			addScriptMsg("Визуальный контакт получен.")
			sampSendChat("/d Alpha, визуальный контакт с нарушителем получен в "..kvadrat()..". Веду погоню.")

	end)
		sampRegisterChatCommand("lc", function()
			if (goFind) then
				addScriptMsg("В данный момент и так ведутся поиски.")
			else
				addScriptMsg("Визуальный контакт потерян.")
				sampSendChat("/d Alpha, визуальный контакт с нарушителем потерян в "..kvadrat()..". Начинайте поиски.")
			end
	end)

		sampRegisterChatCommand("alphasettings", function()
			  main_window_state.v = not main_window_state.v
			  imgui.Process = main_window_state.v
	end)
	
	sampRegisterChatCommand("callsrec", function()
			  call_window_state.v = not call_window_state.v
			  imgui.Process = call_window_state.v
	end)


	addScriptMsg("AlphaTools загружен. Помощь: /alphahelp.")

	while true do wait(0)
		testCheats()
		doEveryTime()
	end
end
