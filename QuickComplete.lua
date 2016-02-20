SLASH_QUICKCLEAN1 = "/qc";


function SlashCmdList.QUICKCLEAN(msg, editbox)
	if QuickComplete:IsShown() then
		QuickComplete:Hide();
	else
		QuickComplete:Show();            
	end
end

function QuickComplete_OnLoad(self, event, ...)
    self:RegisterForDrag("LeftButton")
	self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("QUEST_DETAIL")
    self:RegisterEvent("QUEST_ACCEPTED")
    self:RegisterEvent("QUEST_PROGRESS")
    self:RegisterEvent("QUEST_COMPLETE")
end

function QuickComplete_OnEvent(self, event, ...)                  
	if event == "ADDON_LOADED" and ... == "QuickComplete" then
	    self:UnregisterEvent("ADDON_LOADED")	
        QuickCompleteOptions = QuickCompleteOptions or nil
        if QuickCompleteOptions == nil then
            QuickCompleteOptions = { one = false, all = false }
        end

		local btn = CreateFrame("CheckButton", "$parentCheckButton1", QuickComplete, "UICheckButtonTemplate")
		btn:SetPoint("LEFT", "$parent", "LEFT", 60, 10);
		btn:SetScript("OnClick", QuickComplete_Checked)
		local fontstring = btn:CreateFontString("QuickCompleteCheckButtonString", "ARTWORK", "GameFontNormal")
		fontstring:SetTextColor(0.7, 0.7, 0, 1.0)
		fontstring:SetText("Quick Complete from Kristen Stoneforge")
		fontstring:SetPoint("LEFT", "$parent", "RIGHT", 0, 0)
		btn:SetFontString(fontstring)
		btn:Show();

        local btn = CreateFrame("CheckButton", "$parentCheckButtonAll", QuickComplete, "UICheckButtonTemplate")
		btn:SetPoint("TOP", "$parentCheckButton1", "BOTTOM", 0, 0);
		btn:SetScript("OnClick", QuickComplete_Checked)
		local fontstring = btn:CreateFontString("QuickCompleteCheckButtonAllString", "ARTWORK", "GameFontNormal")
		fontstring:SetTextColor(0.7, 0.7, 0, 1.0)
		fontstring:SetText("Quick Accept and Complete from all NPCs and players?")
		fontstring:SetPoint("LEFT", "$parent", "RIGHT", 0, 0)
		btn:SetFontString(fontstring)
        btn:SetChecked(QuickCompleteOptions.all)
		btn:Show();

        QuickCompleteCheckButton1:SetChecked(QuickCompleteOptions.one)
        

    elseif (event == "QUEST_ACCEPTED" or event ==  "QUEST_DETAIL") and QuickCompleteCheckButtonAll:GetChecked() then
        AcceptQuest()
    elseif event == "QUEST_PROGRESS" then
        QuickCompleteName = GetUnitName("npc", false)
        if (QuickCompleteName == "Kristen Stoneforge" and QuickCompleteCheckButton1:GetChecked()) or QuickCompleteCheckButtonAll:GetChecked() then
            CompleteQuest()
        end
    elseif event == "QUEST_COMPLETE" then
        if (QuickCompleteName == "Kristen Stoneforge" and QuickCompleteCheckButton1:GetChecked()) or QuickCompleteCheckButtonAll:GetChecked() then
            GetQuestReward(math.random(3));
        end
    end	
end

function QuickComplete_Checked(self, event, ...)
    QuickCompleteOptions.one = QuickCompleteCheckButton1:GetChecked()
    QuickCompleteOptions.all = QuickCompleteCheckButtonAll:GetChecked()
end
