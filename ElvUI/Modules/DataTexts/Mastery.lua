local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local join = string.join

local GetMasteryEffect = GetMasteryEffect
local GetSpecialization = GetSpecialization
local GetSpecializationMasterySpells = GetSpecializationMasterySpells
local STAT_MASTERY = STAT_MASTERY

local displayString = ""
local lastPanel

local function OnEvent(self)
	lastPanel = self

	self.text:SetFormattedText(displayString, STAT_MASTERY, GetMasteryEffect())
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	DT.tooltip:ClearLines()

	local primaryTalentTree = GetSpecialization()

	if primaryTalentTree then
		local masterySpell, masterySpell2 = GetSpecializationMasterySpells(primaryTalentTree)
		if masterySpell then
			DT.tooltip:AddSpellByID(masterySpell)
		end
		if masterySpell2 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddSpellByID(masterySpell2)
		end
	end
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s: ", hex, "%.2f%%|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Mastery", {"MASTERY_UPDATE"}, OnEvent, nil, nil, OnEnter, nil, STAT_MASTERY)