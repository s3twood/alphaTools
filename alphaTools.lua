local events = require 'lib.samp.events'
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local encoding = require 'encoding'

script_name("alphaTools")
script_author("Foxy_L")
script_version("25.06.2022")

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
local screenX, screenY = getScreenResolution()

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
		local kv1 = string.match(text, "Alpha, ������� �������������� (%W%-%d+)%.")
		if (kv1 ~= nil) then setMarkerKV(kv1) end
	end

	if(color == 865730559) then
		local kv1 = string.match(text, "Alpha, ���������� ������� � ����������� ������� � (%W%-%d+)%. ��������� ������.")
		if (kv1 ~= nil) then
			goFind = true
			setMarkerKV(kv1)
			contactTimer = os.time()
		end
	end

	if(color == 865730559) then
		local kv1 = string.match(text, "Alpha, ���������� ������� � ����������� ������� � (%W%-%d+)%. ���� ������.")
		if (kv1 ~= nil) then
			goFind = false
			setMarkerKV(kv1)
		end
	end


	if (string.match(text,"%[����������%]") and string.match(text, "�� ������� ������") and color == -1347440641) then
		activeCall = true
		if (config.callRecorder.active) then
			file = io.open(callRecorderPath, "a")
			file:write("["..os.date().."] START CALL\n")
			file:close()
		end
	end

	if (string.match(text,"%[����������%]") and string.match(text, "������ �������! ����� ���������") and color == -1347440641) then
		activeCall = false
		if (config.callRecorder.active) then
			file = io.open(callRecorderPath, "a")
			file:write("["..os.date().."] END CALL\n\n")
			file:close()
		end
	end


	if (activeCall and string.match(text, "%[���%]%:") and color == -1) then
		if (config.callRecorder.active) then
			file = io.open(callRecorderPath, "a")
			file:write(string.sub(text,24).."\n")
			file:close()
		end
	end


	if (config.onlyCallMode.active and activeCall) then
		if (string.match(text,"%[����������%]") and string.match(text, "�� ������� ������") and color == -1347440641) or (string.match(text,"%[����������%]") and string.match(text, "������ �������! ����� ���������") and color == -1347440641) or (string.match(text, "%[���%]%:") and color == -1) then
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
	local KV = {
        [1] = "�",
        [2] = "�",
        [3] = "�",
        [4] = "�",
        [5] = "�",
        [6] = "�",
        [7] = "�",
        [8] = "�",
        [9] = "�",
        [10] = "�",
        [11] = "�",
        [12] = "�",
        [13] = "�",
        [14] = "�",
        [15] = "�",
        [16] = "�",
        [17] = "�",
        [18] = "�",
        [19] = "�",
        [20] = "�",
        [21] = "�",
        [22] = "�",
        [23] = "�",
        [24] = "�",
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
    ["�"] = 1,
    ["�"] = 2,
    ["�"] = 3,
    ["�"] = 4,
    ["�"] = 5,
    ["�"] = 6,
    ["�"] = 7,
    ["�"] = 8,
    ["�"] = 9,
    ["�"] = 10,
    ["�"] = 11,
    ["�"] = 12,
    ["�"] = 13,
    ["�"] = 14,
    ["�"] = 15,
    ["�"] = 16,
    ["�"] = 17,
    ["�"] = 18,
    ["�"] = 19,
    ["�"] = 20,
    ["�"] = 21,
    ["�"] = 22,
    ["�"] = 23,
    ["�"] = 24,
    ["�"] = 1,
    ["�"] = 2,
    ["�"] = 3,
    ["�"] = 4,
    ["�"] = 5,
    ["�"] = 6,
    ["�"] = 7,
    ["�"] = 8,
    ["�"] = 9,
    ["�"] = 10,
    ["�"] = 11,
    ["�"] = 12,
    ["�"] = 13,
    ["�"] = 14,
    ["�"] = 15,
    ["�"] = 16,
    ["�"] = 17,
    ["�"] = 18,
    ["�"] = 19,
    ["�"] = 20,
    ["�"] = 21,
    ["�"] = 22,
    ["�"] = 23,
    ["�"] = 24,
  }
  return KV[param]
end


function setMarkerKV(arg)
	kvl, kvn = string.match(arg, "(%W)%-(%d+)")
	if (kvl == nil or kvn == nil) then
		kvl, kvn = string.match(arg, "(%W)(%d+)")
	end

	if (kvl == nil or kvn == nil) then
		addScriptMsg("����������� /setkv "..setColor("[�������]")..". ������: /setkv "..setColor("�-1"))
		return
	end

	if (kvadratnum(kvl) ~= nil and tonumber(kvn) > 0 and tonumber(kvn) < 25) then
		local coordx = tonumber(kvn)*250-3250 + 125
		local coordy = 3250-kvadratnum(kvl)*250 - 125

		local pedx, pedy, pedz = getCharCoordinates(PLAYER_PED)

		if (placeWaypoint(coordx, coordy, pedz)) then
			local dist = math.floor(math.sqrt((coordx-pedx)*(coordx-pedx) + (coordy-pedy)*(coordy-pedy))*100)/100
			addScriptMsg("����� ����������� � ������� "..setColor(kvl.."-"..kvn)..". ����������: "..setColor(dist).." ������.")
		else
			addScriptMsg("����������� ������.")
		end

	else
		addScriptMsg("������ �������� �� ����������.")
	end


end

function testCheats()
	if testCheat('KLK') then
		stateKLK = not stateKLK
		firstKLK = true
		if stateKLK then
			if (KLKTest()) then
				addScriptMsg("KLK �����������.")
			else
				addScriptMsg("KLK �� ����� ���� �����������.")
			end
		else
			addScriptMsg("KLK ��������.")
		end
	end

	if testCheat('ZAD') then
		zad = not zad
		if zad then
			addScriptMsg("ZAD �����������.")
		else
			addScriptMsg("ZAD ��������.")
		end
	end

	if testCheat('BK') then
		sampSendChat("/d Alpha, ������� �������������� "..kvadrat()..".")
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

		if charHeading >= 337.5 or  charHeading <= 22.5  then naprav = "��������" end
		if charHeading >  22.5  and charHeading <= 67.5  then naprav = "������-��������" end
		if charHeading >  67.5  and charHeading <= 112.5 then naprav = "��������" end
		if charHeading >  112.5 and charHeading <= 157.5 then naprav = "���-��������" end
		if charHeading >  157.5 and charHeading <= 202.5 then naprav = "�����" end
		if charHeading >  202.5 and charHeading <= 247.5 then naprav = "���-���������" end
		if charHeading >  247.5 and charHeading <= 292.5 then naprav = "���������" end
		if charHeading >  292.5 and charHeading <= 337.5 then naprav = "������-���������" end

		local pedx, pedy, pedz = getCharCoordinates(PLAYER_PED)
		local bool, waypointx, waypointy = getTargetBlipCoordinates()

		local renderString = "�����������: "..setColor(naprav).."\n�������: " ..setColor(kvadrat()).."\n������: "..setColor(math.floor(pedz))
		if (bool) then renderString = renderString.."\n�����: "..setColor(math.floor(math.sqrt((waypointx-pedx)*(waypointx-pedx) + (waypointy-pedy)*(waypointy-pedy))*100)/100) end
		if (goFind) then
			local findTime = contactTimer+searchTime-os.time()
			local findTimeMin = math.floor(findTime/60)
			local findTimeSec = findTime%60
			if (findTimeSec < 10) then findTimeSec = "0"..findTimeSec end
			renderString = renderString.."\n������: "..setColor(findTimeMin..":"..findTimeSec)
		end

		renderFontDrawText(logo, renderString, config.coordMenu.x, config.coordMenu.y, 0xFFFFFFFF)
	end
end

function findTest()
	if (goFind and contactTimer+searchTime-os.time() < 1) then
		goFind = false
		addScriptMsg("������� ��������. ������ �� ������.")
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
	if main_window_state.v then
		imgui.ShowCursor = true
		imgui.SetNextWindowSize(imgui.ImVec2(600, 200), imgui.Cond.FirstUseEver)

		imgui.Begin(u8'���������', main_window_state)

		if imgui.Checkbox(u8'���� �����������', coordActive) then
			config.coordMenu.active = coordActive.v
			if config.coordMenu.active then addScriptMsg("���� ����������� ��������.")
			else addScriptMsg("���� ����������� ���������.") end

			inicfg.save(config, configPath)
		end

		if imgui.SliderFloat(u8"������� �� �����������", coordPosX, 0, screenX) then
			config.coordMenu.x = coordPosX.v
			inicfg.save(config, configPath)
		end

		if imgui.SliderFloat(u8"������� �� ���������", coordPosY, 0, screenY) then
			config.coordMenu.y = coordPosY.v
			inicfg.save(config, configPath)
		end

		if imgui.Checkbox(u8'���������', autokvActive) then
			config.autokv.active = autokvActive.v
			if config.autokv.active then addScriptMsg("��������� ��������.")
			else addScriptMsg("��������� ���������.") end

			inicfg.save(config, configPath)
		end

		if imgui.Checkbox(u8'������ �������', callRecorderActive) then
			config.callRecorder.active = callRecorderActive.v
			if config.callRecorder.active then addScriptMsg("���������� ������� ��������.") 
			else addScriptMsg("���������� ������� ���������.") end

			inicfg.save(config, configPath)
		end

		if imgui.Checkbox(u8'����� "������ ������"', onlyCallModeActive) then
			config.onlyCallMode.active = onlyCallModeActive.v
			if config.onlyCallMode.active then addScriptMsg("����������� ������ �������� ��� ������ ��������.")
			else addScriptMsg("����������� ������ �������� ��� ������ ���������.") end

			inicfg.save(config, configPath)
		end
		imgui.End()
	else
		imgui.ShowCursor = false
	end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
		while not isSampAvailable() do wait(100) end


	autoupdate("https://raw.githubusercontent.com/s3twood/alphaTools/main/update.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/s3twood/alphaTools/main/update.json")


	sampRegisterChatCommand("alphahelp", function()
		sampShowDialog(6405, "AlphaTools",
		[[
{4169E1}/alphahelp {ffffff}- ������� �������.
{4169E1}/alphasettings {ffffff}- ��������� �������.
{4169E1}/setkv [�������] {ffffff}- ������������� ����� � ��������� �������.
{4169E1}/fc {ffffff}- ������� ���������� ������� � ���������. ������� ������ ������.
{4169E1}/lc {ffffff}- ������� ���������� ������� � ���������. ����������� ������ ������.
{4169E1}KLK {ffffff}- ��� ���-���, ������������� Maverick � �������, ���� �������� ������ 2-��.
{4169E1}ZAD {ffffff}- ��� ���-���, ��������� ������ �� ����������.
{4169E1}BK {ffffff}- ��� ���-���, ���������� ���������� � ������� �������������� � �����������.
{4169E1}���� ����������� {ffffff}- ��������� ���� �����������, �������, ������, ���������� �� �����, ������ ������.
{4169E1}��������� {ffffff}- �������������� ��������� ����� ��� ��������� � �����������.
{4169E1}������ ������� {ffffff}- ��������� ��� ���� ������ � ��������� ���� moonloader/callRecord.txt.
{4169E1}����� "������ ������" {ffffff}- ��� ��������� �� �������� ��� ��������� ��������� � ���� �� ������������.
]],
		"�������",
		"",
		0)
	end)

	sampRegisterChatCommand("setkv", setMarkerKV)
	
	sampRegisterChatCommand("fc", function()
			addScriptMsg("���������� ������� �������.")
			sampSendChat("/d Alpha, ���������� ������� � ����������� ������� � "..kvadrat()..". ���� ������.")

	end)
		sampRegisterChatCommand("lc", function()
			if (goFind) then
				addScriptMsg("� ������ ������ � ��� ������� ������.")
			else
				addScriptMsg("���������� ������� �������.")
				sampSendChat("/d Alpha, ���������� ������� � ����������� ������� � "..kvadrat()..". ��������� ������.")
			end
	end)

		sampRegisterChatCommand("alphasettings", function()
			  main_window_state.v = not main_window_state.v
			  imgui.Process = main_window_state.v
	end)


	addScriptMsg("AlphaTools ��������. ������: /alphahelp.")

	while true do wait(0)
		testCheats()
		doEveryTime()
	end
end


--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   ______   __   ___  ____  _     _  __
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| | __ ) \ / /  / _ \|  _ \| |   | |/ /
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   |  _ \\ V /  | | | | |_) | |   | ' /
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  | |_) || |   | |_| |  _ <| |___| . \
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____| |____/ |_|    \__\_\_| \_\_____|_|\_\                                                                                                                                                                                                                  
--
-- Author: http://qrlk.me/samp
--
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      sampAddChatMessage((prefix..'���������� ���������!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': ���������� �� ���������.')
            end
          end
        else
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end