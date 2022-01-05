script_author('chapo')
script_name('RollerFix +')
require 'lib.moonloader'
local object = nil

local inicfg = require 'inicfg'
local directIni = 'RollerFixPlusByChapo.ini'
local ini = inicfg.load(inicfg.load({
    main = {
        speedFix = true,
        delayFix = true,
    },
}, directIni))
inicfg.save(ini, directIni)
local font = renderCreateFont('Arial', 15, 5)
function main()
    while not isSampAvailable() do wait(0) end
    object = createObject(19843, 0, 0, 0)
    setObjectRotation(object, 0, 0, 0)
    setObjectScale(object, 0)
    sampRegisterChatCommand('rollerfix', function()
        callDialog()
    end)
    while true do
        wait(0)
        --==[ SPEED ON GRASS/SAND ]==--    
        if ini.main.speedFix then
            local x, y, z = getCharCoordinates(PLAYER_PED) 
            setObjectCoordinates(object, x, y, getGroundZFor3dCoord(x, y, z))
        end
        
        --==[ NO DELAY ]==-- 
        if ini.main.delayFix then
            if isButtonPressed(Player, 1) or isButtonPressed(Player, 0) then
                setCharAnimSpeed(PLAYER_PED, 'skate_idle', 1000)
            end
        end
        local result, button, list, input = sampHasDialogRespond(8812)
        if result then
            if button == 1 then
                if list == 0 then
                    ini.main.speedFix = not ini.main.speedFix
                elseif list == 1 then
                    ini.main.delayFix = not ini.main.delayFix
                end
                inicfg.save(ini, directIni)
                callDialog()
            end
        end
    end
end

function callDialog()
    sampShowDialog(8812, 'RollerFix+ by chapo', '{ffffff}Фикс скорости на земле и песке: '..(ini.main.speedFix and '{36ff6f}включено' or '{ff3636}выключено')..'\n{ffffff}Фикс разгона: '..(ini.main.delayFix and '{36ff6f}включено' or '{ff3636}выключено'), 'Выбрать', 'Закрыть', 4)
end

function onScriptTerminate(s, q)
    if s == thisScript() then
        if doesObjectExist(object) then
            deleteObject(object)
        end
    end
end