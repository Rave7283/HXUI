require ("common");
require('helpers');
local imgui = require("imgui");

local config = {};

config.DrawWindow = function(us)
    imgui.SetNextWindowSize({ 500, 500 }, ImGuiCond_FirstUseEver);
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 10, 10 });
    imgui.PushStyleColor(ImGuiCol_Text, { 1.0, 1.0, 1.0, 1.0 });
    if(showConfig[1] and imgui.Begin(("HXUI Config"):fmt(addon.version), showConfig, bit.bor(ImGuiWindowFlags_NoSavedSettings))) then
        if(imgui.Button("Restore Defaults", { 130, 20 })) then
            ResetSettings();
            UpdateSettings();
        end
        imgui.BeginChild("Config Options", { 0, 0 }, true);
        if (imgui.CollapsingHeader("Player Bar")) then
            imgui.BeginChild("PlayerBarSettings", { 0, 150 }, true);
                if (imgui.Checkbox(' Enabled', { us.showPlayerBar })) then
                    us.showPlayerBar = not us.showPlayerBar;
                    UpdateSettings();
                end
                local scaleX = { us.playerBarScaleX };
                if (imgui.SliderFloat('Scale X', scaleX, 0.1, 3.0, '"%.1f"')) then
                    us.playerBarScaleX = scaleX[1];
                    UpdateSettings();
                end
                local scaleY = { us.playerBarScaleY };
                if (imgui.SliderFloat('Scale Y', scaleY, 0.1, 3.0, '"%.1f"')) then
                    us.playerBarScaleY = scaleY[1];
                    UpdateSettings();
                end
                local fontOffset = { us.playerBarFontOffset };
                if (imgui.SliderInt('Font Offset', fontOffset, -5, 10)) then
                    us.playerBarFontOffset = fontOffset[1];
                    UpdateSettings();
                end
            imgui.EndChild();
        end
        if (imgui.CollapsingHeader("Target Bar")) then
            imgui.BeginChild("TargetBarSettings", { 0, 150 }, true);
            if (imgui.Checkbox(' Enabled', { us.showTargetBar })) then
                us.showTargetBar = not us.showTargetBar;
                UpdateSettings();
            end
            if (imgui.Checkbox(' Show Percent', { us.showTargetBarPercent })) then
                us.showTargetBarPercent = not us.showTargetBarPercent;
                UpdateSettings();
            end
            local scaleX = { us.targetBarScaleX };
            if (imgui.SliderFloat('Scale X', scaleX, 0.1, 3.0, '%.1f')) then
                us.targetBarScaleX = scaleX[1];
                UpdateSettings();
            end
            local scaleY = { us.targetBarScaleY };
            if (imgui.SliderFloat('Scale Y', scaleY, 0.1, 3.0, '%.1f')) then
                us.targetBarScaleY = scaleY[1];
                UpdateSettings();
            end
            local fontScale = { us.targetBarFontScale };
            if (imgui.SliderFloat('Font Offset', fontScale, 0.1, 3.0)) then
                us.targetBarFontScale = fontScale[1];
                UpdateSettings();
            end
            imgui.EndChild();
        end
        if (imgui.CollapsingHeader("Enemy List")) then
            imgui.BeginChild("EnemyListSettings", { 0, 150 }, true);
            if (imgui.Checkbox(' Enabled', { us.showEnemyList })) then
                us.showEnemyList = not us.showEnemyList;
                UpdateSettings();
            end
            local scaleX = { us.enemyListScaleX };
            if (imgui.SliderFloat('Scale X', scaleX, 0.1, 3.0, '%.1f')) then
                us.enemyListScaleX = scaleX[1];
                UpdateSettings();
            end
            local scaleY = { us.enemyListScaleY };
            if (imgui.SliderFloat('Scale Y', scaleY, 0.1, 3.0, '%.1f')) then
                us.enemyListScaleY = scaleY[1];
                UpdateSettings();
            end
            local fontScale = { us.enemyListFontScale };
            if (imgui.SliderFloat('Font Offset', fontScale, 0.1, 3.0)) then
                us.enemyListFontScale = fontScale[1];
                UpdateSettings();
            end
            imgui.EndChild();
        end
        if (imgui.CollapsingHeader("Party List")) then
            imgui.BeginChild("PartyListSettings", { 0, 150 }, true);
            if (imgui.Checkbox(' Enabled', { us.showPartyList })) then
                us.showPartyList = not us.showPartyList;
                UpdateSettings();
            end
            if (imgui.Checkbox(' Show When Solo', { us.showPartyListWhenSolo })) then
                us.showPartyListWhenSolo = not us.showPartyListWhenSolo;
                UpdateSettings();
            end
            local scaleX = { us.partyListScaleX };
            if (imgui.SliderFloat('Scale X', scaleX, 0.1, 3.0, '%.1f')) then
                us.partyListScaleX = scaleX[1];
                UpdateSettings();
            end
            local scaleY = { us.partyListScaleY };
            if (imgui.SliderFloat('Scale Y', scaleY, 0.1, 3.0, '%.1f')) then
                us.partyListScaleY = scaleY[1];
                UpdateSettings();
            end
            local fontOffset = { us.partyListFontOffset };
            if (imgui.SliderInt('Font Offset', fontOffset, -5, 10)) then
                us.partyListFontOffset = fontOffset[1];
                UpdateSettings();
            end
            imgui.EndChild();
        end
        if (imgui.CollapsingHeader("Exp Bar")) then
            imgui.BeginChild("ExpBarSettings", { 0, 150 }, true);
            if (imgui.Checkbox(' Enabled', { us.showExpBar })) then
                us.showExpBar = not us.showExpBar;
                UpdateSettings();
            end
            local scaleX = { us.expBarScaleX };
            if (imgui.SliderFloat('Scale X', scaleX, 0.1, 3.0, '%.1f')) then
                us.expBarScaleX = scaleX[1];
                UpdateSettings();
            end
            local scaleY = { us.expBarScaleY };
            if (imgui.SliderFloat('Scale Y', scaleY, 0.1, 3.0, '%.1f')) then
                us.expBarScaleY = scaleY[1];
                UpdateSettings();
            end
            local fontOffset = { us.expBarFontOffset };
            if (imgui.SliderInt('Font Offset', fontOffset, -5, 10)) then
                us.expBarFontOffset = fontOffset[1];
                UpdateSettings();
            end
            imgui.EndChild();
        end
        if (imgui.CollapsingHeader("Gil Tracker")) then
            imgui.BeginChild("GilTrackerSettings", { 0, 150 }, true);
            if (imgui.Checkbox(' Enabled', { us.showGilTracker })) then
                us.showGilTracker = not us.showGilTracker;
                UpdateSettings();
            end
            local scale = { us.gilTrackerScale };
            if (imgui.SliderFloat('Scale', scale, 0.1, 3.0, '%.1f')) then
                us.gilTrackerScale = scale[1];
                UpdateSettings();
            end
            local fontOffset = { us.gilTrackerFontOffset };
            if (imgui.SliderInt('Font Offset', fontOffset, -5, 10)) then
                us.gilTrackerFontOffset = fontOffset[1];
                UpdateSettings();
            end
            imgui.EndChild();
        end
        if (imgui.CollapsingHeader("Inventory Tracker")) then
            imgui.BeginChild("InventoryTrackerSettings", { 0, 150 }, true);
            if (imgui.Checkbox('Enabled', { us.showInventoryTracker })) then
                us.showInventoryTracker = not us.showInventoryTracker;
                UpdateSettings();
            end
            local scale = { us.inventoryTrackerScale };
            if (imgui.SliderFloat('Scale', scale, 0.1, 3.0, '%.1f')) then
                us.inventoryTrackerScale = scale[1];
                UpdateSettings();
            end
            local fontOffset = { us.inventoryTrackerFontOffset };
            if (imgui.SliderInt('Font Offset', fontOffset, -5, 10)) then
                us.inventoryTrackerFontOffset = fontOffset[1];
                UpdateSettings();
            end
            imgui.EndChild();
        end
    imgui.EndChild();
    end
	imgui.End();
end

return config;