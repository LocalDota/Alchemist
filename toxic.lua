local Toxic = {}

local myPlayer, kills = nil, nil









--Перевод
local RU = "russian"
local EN = "english" 
local CN = "Chinese" 
 
 
local language = EN
 
if Menu.GetLanguageOptionId then
    local LanguageItem = Menu.GetLanguageOptionId()
    local menuLang = Menu.GetValue(LanguageItem)
    if menuLang == 1 then -- ru
      language = RU
    elseif menuLang == 0 then -- en
      language = EN
	elseif menuLang == 2 then -- cn
	  language = CN
    end
end


local Translation = {
    ["optionTaunt"] = {
        [RU] = "Насмешка",
        [EN] = "Taunt",
		[CN] = "",
    },
    ["optionEnableMessage"] = {
        [RU] = "Писать в чат после убийства",
        [EN] = "Send a chat message after a kill",
		[CN] = "",
    },
    ["optionMessage"] = {
        [RU] = "Сообщение в чат",
        [EN] = "Message in chat",
		[CN] = "",
    },
    ["Message1"] = {
        [RU] = "Изи",
        [EN] = "Ez",
		[CN] = "",
    },
    ["Message2"] = {
        [RU] = "В следующий раз повезёт",
        [EN] = "Lucky next time",
		[CN] = "",
    },
    ["Message3"] = {
        [RU] = "Отдохни",
        [EN] = "Have a rest",
		[CN] = "",
    },
} 



local rootPath = "Utility"

local mainPath = {rootPath, "Toxic"}


if language == RU then
    rootPath = "Утилиты"
    mainPath = {rootPath, "Toxic"}
end 







Toxic.optionTaunt = Menu.AddOptionBool(mainPath, Translation.optionTaunt[language], false)
Menu.AddOptionIcon(Toxic.optionTaunt, "~/MenuIcons/stupid_smile.png")
Menu.AddMenuIcon(mainPath, "~/MenuIcons/rat.png")


Toxic.optionEnableMessage = Menu.AddOptionBool(mainPath, Translation.optionEnableMessage[language], false)
Menu.AddOptionIcon(Toxic.optionEnableMessage, "~/MenuIcons/chat.png")

Toxic.optionMessage = Menu.AddOptionCombo(mainPath, Translation.optionMessage[language], { Translation.Message1[language], Translation.Message2[language], Translation.Message3[language] }, 0)
Menu.AddOptionIcon(Toxic.optionMessage, "~/MenuIcons/text_panel.png")



local result = {
	[0] = Translation.Message1[language],
	[1] = Translation.Message2[language],
	[2] = Translation.Message3[language]
}	


function Toxic.OnUpdate()

	if (not myPlayer) then
		myPlayer = Players.GetLocal()
		return
	end

	
	if not kills then
		kills = Player.GetTeamData(myPlayer)["kills"]
	end

	
	if Menu.IsEnabled(Toxic.optionTaunt) then
		if kills and kills ~= Player.GetTeamData(myPlayer)["kills"] then
			Engine.ExecuteCommand("use_item_client current_hero taunt")
			if not Menu.IsEnabled(Toxic.optionEnableMessage) then
				kills = nil
			end	
		end
	end	


	if Menu.IsEnabled(Toxic.optionEnableMessage) then
		if kills and kills ~= Player.GetTeamData(myPlayer)["kills"] then
			message = result[Menu.GetValue(Toxic.optionMessage)]
			Engine.ExecuteCommand("say "..message .. "")
			kills = nil
		end
	end		
end	



return Toxic