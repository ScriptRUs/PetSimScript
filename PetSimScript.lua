
if _G.Key == "PhGZmYnn4Ck66zg8" then
    wait()
    local start = tick()
    repeat task.wait() until game:isLoaded()
    repeat task.wait() until game:GetService("Players")
    repeat task.wait() until game:GetService("Players").LocalPlayer
    repeat task.wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.Main.Enabled
    repeat task.wait() until game:GetService("Workspace"):FindFirstChild('__MAP')


    -- Pet Simulator Script!
game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
local GameLibrary = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
local Network = GameLibrary.Network
local Run_Service = game:GetService("RunService")
local rs = Run_Service.RenderStepped
local CurrencyOrder = {"Tech Coins", "Fantasy Coins", "Coins",}

    local IMightKillMyselfCauseOfThis = {
        --Misc
        ['VIP'] = {'VIP'};
        --Spawn
        ['Town'] = {'Town', 'Town FRONT'}; ['Forest'] = {'Forest', 'Forest FRONT'}; ['Beach'] = {'Beach', 'Beach FRONT'}; ['Mine'] = {'Mine', 'Mine FRONT'}; ['Winter'] = {'Winter', 'Winter FRONT'}; ['Glacier'] = {'Glacier', 'Glacier Lake'}; ['Desert'] = {'Desert', 'Desert FRONT'}; ['Volcano'] = {'Volcano', 'Volcano FRONT'};
        -- Fantasy init
        ['Enchanted Forest'] = {'Enchanted Forest', 'Enchanted Forest FRONT'}; ['Ancient'] = {'Ancient'}; ['Samurai'] = {'Samurai', 'Samurai FRONT'}; ['Candy'] = {'Candy'}; ['Haunted'] = {'Haunted', 'Haunted FRONT'}; ['Hell'] = {'Hell'}; ['Heaven'] = {'Heaven'};
        -- Tech
        ['Ice Tech'] = {'Ice Tech'}; ['Tech City'] = {'Tech City'; 'Tech City FRONT'}; ['Dark Tech'] = {'Dark Tech'; 'Dark Tech FRONT'}; ['Steampunk'] = {'Steampunk'; 'Steampunk FRONT'}, ['Alien Forest'] = {"Alien Forest"; "Alien Forest FRONT"}, ['Alien Lab'] = {"Alien Forest"; "Alien Lab FRONT"}, ['Glitch'] = {"Glitch";"Glitch FRONT"}, ["Hacker Portal"] = {"Hacker Portal", "Hacker Portal FRONT"};
    }

    local AreaList = { --These match the IMightKillMyselfCuaseOfThis table
        'All'; 'VIP';
        'Town'; 'Forest'; 'Beach'; 'Mine'; 'Winter'; 'Glacier'; 'Desert'; 'Volcano';
        'Enchanted Forest'; 'Ancient'; 'Samurai'; 'Candy'; 'Haunted'; 'Hell'; 'Heaven';
        'Ice Tech'; 'Tech City'; 'Dark Tech'; 'Steampunk'; 'Alien Lab'; 'Alien Forest';
        'Glitch'; 'Hacker Portal';
    }

    local Chests = {
"All";
        -- Spawn
        "Magma Chest",
        -- Fantasy
        "Enchanted Chest", "Hell Chest", "Haunted Chest", "Angel Chest", "Grand Heaven Chest",
        -- Tech
        "Giant Tech Chest"; "Giant Steampunk Chest"; "Giant Alien Chest";
    }

workspace.__THINGS.__REMOTES.MAIN:FireServer("b", "buy egg")
workspace.__THINGS.__REMOTES.MAIN:FireServer("b", "join coin")
workspace.__THINGS.__REMOTES.MAIN:FireServer("a", "farm coin")
workspace.__THINGS.__REMOTES.MAIN:FireServer("a", "claim orbs")
workspace.__THINGS.__REMOTES.MAIN:FireServer("a", "change pet target")

--Farms a coin. It seems to work. That's fun
function FarmCoin(CoinID, PetID)
    game.workspace['__THINGS']['__REMOTES']["join coin"]:InvokeServer({[1] = CoinID, [2] = {[1] = PetID}})
    game.workspace['__THINGS']['__REMOTES']["farm coin"]:FireServer({[1] = CoinID, [2] = PetID})
end

function GetMyPets()
   local returntable = {}
   for i,v in pairs(GameLibrary.Save.Get().Pets) do
       if v.e then 
           table.insert(returntable, v.uid)
       end
   end
   return returntable
end

--returns all coins within the given area (area must be a table of conent)
function GetCoins(area)
    local returntable = {}
    local ListCoins = game.workspace['__THINGS']['__REMOTES']["get coins"]:InvokeServer({})[1]
    for i,v in pairs(ListCoins) do
        if FarmingArea == 'All' or table.find(IMightKillMyselfCauseOfThis[FarmingArea], v.a) then
            local shit = v
            shit["index"] = i
            table.insert(returntable, shit)
         end
    end
    return returntable
end

--Sexy man ( wYn#0001 ) made this for me. It works, not sure how, it does.
function GetCoinTable(area)
    local CoinTable = GetCoins(area)
    function getKeysSortedByValue(tbl, sortFunction)
        local keys = {}
        for key in pairs(tbl) do
            table.insert(keys, key)
        end
        table.sort(
            keys,
            function(a, b)
                return sortFunction(tbl[a].h, tbl[b].h)
            end
        )
        return keys
    end
    local sortedKeys = getKeysSortedByValue(CoinTable, function(a, b) return a > b end)
    local newCoinTable = {}

    for i,v in pairs(sortedKeys) do
        table.insert(newCoinTable, CoinTable[v])
    end
    
    return newCoinTable
end

--Not sure exactly why I did this
local AreaWorldTable = {}
for _, v in pairs(game:GetService("ReplicatedStorage").Game.Coins:GetChildren()) do
    for _, b in pairs(v:GetChildren()) do
        table.insert(AreaWorldTable, b.Name)
    end
    table.insert(AreaWorldTable, v.Name)
end

--Returns all the currently alive chests in the game  the same was getcoins does
function AllChests()
    local returntable = {}
    local ListCoins = game.workspace['__THINGS']['__REMOTES']["get coins"]:InvokeServer({})[1]
    for i,v in pairs(ListCoins) do
        local shit = v
        shit["index"] = i
        for aa,bb in pairs(AreaWorldTable) do
            if string.find(v.n, bb) then
                local thing = string.gsub(v.n, bb.." ", "")
                if table.find(Chests, thing) then
                    shit.n = thing
                    table.insert(returntable, shit)
                end
            end
        end
    end
    return returntable
end

--[[
--the remote works like this. I'm too scared to test anything else out
function CollectOrbs()
    local ohTable1 = {[1] = {}}
    for i,v in pairs(game.workspace['__THINGS'].Orbs:GetChildren()) do
        ohTable1[1][i] = v.Name
    end
    game.workspace['__THINGS']['__REMOTES']["claim orbs"]:FireServer(ohTable1)
end
]]
local s =
    setmetatable(
    {},
    {
        __index = function(self, service)
            return game:GetService(service)
        end,
        __newindex = function(self, key)
            self[key] = nil
        end
    }
)

local Ser;

for i, v in next, getreg() do
    if typeof(v) == "table" then
        if rawget(v, "Services") then
            Ser = v.Services
            break
        end
    end
end


local user = s["Players"].LocalPlayer
if _G.MyConnection then _G.MyConnection:Disconnect() end
_G.MyConnection = game.Workspace.__THINGS.Orbs.ChildAdded:Connect(function(Orb)
    game.Workspace.__THINGS.__REMOTES["claim orbs"]:FireServer({{Orb.Name}})
end)



do
	local ui = game:GetService("CoreGui"):FindFirstChild("LuxtLibWisteria GUI")
	if ui then
		ui:Destroy()
	end
end

local Luxtl = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Luxware-UI-Library/main/Source.lua"))()

local Luxt = Luxtl.CreateWindow("Wisteria GUI", 6105620301)
------Autofarm Stuff----
local Mains = Luxt:Tab("Autofarm", 6087485864)
local ToggleSettings = Mains:Section("Autofarm Toggles")
local AutoSettings = Mains:Section("Autofarm Settings")
------Pet Stuff----
local Pets = Luxt:Tab("Pet", 6087485864)
local PetToggle = Pets:Section("Toggles")
local PetSetting = Pets:Section("Settings")
------Menu Stuff-----
local Menus = Luxt:Tab("Menus", 6087485864)
local MenuStuff = Menus:Section("All Menu Uis")

----Visual Stuff----
local Fun = Luxt:Tab("Visuals", 6087485864)
local FunWindow = Fun:Section("Visual Multis")
------Misc Stuff-----
local mISCS = Luxt:Tab("Miscs", 6087485864)
local MiscWindow = mISCS:Section("Misc Stuff")


ToggleSettings:Toggle("Start Farming",function(State)
	FarmingEnabled = State
end)
ToggleSettings:Toggle("Auto Collect Loot Bags", function(Val)
	LootBag = Val
end)
ToggleSettings:Slider("Wait Time", 1, 10, function(Values)
    WaitTime = Values
end)
ToggleSettings:Label("Please Choose A Spot Hidden From Others")
ToggleSettings:Label("Before Using The Beta Invisible Feature")
ToggleSettings:Button("Go Invisible", function()
    if(user.Character and user.Character:FindFirstChild("LowerTorso") or user.Character:FindFirstChildWhichIsA("LowerTorso")) then
        user.character.LowerTorso.Root:Destroy()
    end
end)
ToggleSettings:Label("Pets Will Not Hide For Now!")
local CurrentFarmingPets = {}
spawn(function()
        while true and rs:wait() do wait(WaitTime)
		if FarmingEnabled then
			local pethingy = GetMyPets()
			if FarmingType == 'Normal' then
				local cointhiny = GetCoins(FarmingArea)
				for i = 1, #cointhiny do
					if game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(cointhiny[i].index) then
						for _, bb in pairs(pethingy) do
							if FarmingEnabled and game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(cointhiny[i].index) then
								spawn(function()
									FarmCoin(cointhiny[i].index, bb)
								end)
							end
						end
						repeat rs:wait() until not game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(cointhiny[i].index)
					end
				end

			elseif FarmingType == 'Chest' then
				for i,v in pairs(AllChests()) do
					if (v.n == FarmingSingleChest) or (FarmingSingleChest == 'All') then
						local starttick = tick()
						for a, b in pairs(pethingy) do
							pcall(function() FarmCoin(v.index, b) end)
						end
						repeat rs:wait() until not game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(v.index) or #game:GetService("Workspace")["__THINGS"].Coins[v.index].Pets:GetChildren() == 0
						warn(v.n .. " has been broken in", tick()-starttick)
					end
				end

			elseif FarmingType == 'Multi Target' then
				local cointhiny = GetCoins(FarmingArea)
				for i = 1, #cointhiny do
					if i%#pethingy == #pethingy-1 then wait() end
					if not CurrentFarmingPets[pethingy[i%#pethingy+1]] or CurrentFarmingPets[pethingy[i%#pethingy+1]] == nil then
						spawn(function()
							CurrentFarmingPets[pethingy[i%#pethingy+1]] = 'Farming'
							FarmCoin(cointhiny[i].index, pethingy[i%#pethingy+1])
							repeat rs:wait() until not game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(cointhiny[i].index) or #game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(cointhiny[i].index).Pets:GetChildren() == 0
							CurrentFarmingPets[pethingy[i%#pethingy+1]] = nil
						end)
					end
				end

			elseif FarmingType == 'Highest Value' then
				local cointhiny = GetCoinTable(FarmingArea)
				for a,b in pairs(pethingy) do
					spawn(function() FarmCoin(cointhiny[1].index, b) end)
				end
				repeat rs:wait() until not game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(cointhiny[1].index) or #game:GetService("Workspace")["__THINGS"].Coins[cointhiny[1].index].Pets:GetChildren() == 0

			elseif FarmingType == 'Nearest' then
				local NearestOne = nil
				local NearestDistance = math.huge
				for i,v in pairs(game:GetService("Workspace")["__THINGS"].Coins:GetChildren()) do
					if (v.POS.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < NearestDistance then
						NearestOne = v
						NearestDistance = (v.POS.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
					end
				end
				for a,b in pairs(pethingy) do
					spawn(function() FarmCoin(NearestOne.Name, b) end)
				end
			end
		end
	end
end)
spawn(function()
    while wait(2) do
        if LootBag then
        local Running = {}
        while wait() and LootBag == true do
            for i, v in pairs(game:GetService("Workspace")["__THINGS"].Lootbags:GetChildren()) do
                spawn(function()
                    if v ~= nil and v.ClassName == 'MeshPart' then
                        if not Running[v.Name] then
                            Running[v.Name] = true
                            local StartTick = tick()
                            v.Transparency = 1
                            for a,b in pairs(v:GetChildren()) do
                                if not string.find(b.Name, "Body") then
                                    b:Destroy()
                                end
                            end
                            repeat task.wait()
                                v.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                            until v == nil or not v.Parent or tick() > StartTick + 3
                            Running[v.Name] = nil
                        end
                    end
                end)
            end
        end
        end
end
end)
AutoSettings:DropDown("Type",{'Normal', 'Chest', 'Multi Target', 'Highest Value', 'Nearest'}, function(Values)
	FarmingType = Values
end)
AutoSettings:DropDown("If chest", Chests, function(FarmChest)
	FarmingSingleChest = FarmChest
end)
AutoSettings:DropDown("Area", AreaList, function(FarmArea)
	FarmingArea = FarmArea
end)

PetToggle:Toggle("Start Toggle", function(State)
	StartCombine = State
end)
PetToggle:Toggle("Auto Golden",function(State)
	Golden = State
end)
PetToggle:Toggle("Auto Rainbow", function(State)
	Rainbow = State
end)
PetSetting:DropDown("Required",{ 1, 2, 3, 4, 5, 6 }, function(Requires)
	Required = Requires
end)

local MyEggData = {}
local littleuselesstable = {}
local GameLibrary = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
for i,v in pairs(GameLibrary.Directory.Eggs) do
	local temptable = {}
	temptable['Name'] = i
	temptable['Currency'] = v.currency
	temptable['Price'] = v.cost
	table.insert(MyEggData, temptable)
end

table.sort(MyEggData, function(a, b)
	return a.Price < b.Price
end)


local EggTech = {"Tech Coins"}
local EggFantasy = {"Fantasy Coins"}
local EggCoins = {"Coins"}
local DataTech = {}
local DataFantasy = {}
local DataCoins = {}
-----------------Egg Data Lists
for i,v in pairs(EggTech) do
	table.insert(DataTech, " ")
	table.insert(DataTech, "-- "..v.." --")
	for a,b in pairs(MyEggData) do
		if b.Currency == v then
			table.insert(DataTech, b.Name)
		end
	end
end
for i,v in pairs(EggFantasy) do
	table.insert(DataFantasy, " ")
	table.insert(DataFantasy, "-- "..v.." --")
	for a,b in pairs(MyEggData) do
		if b.Currency == v then
			table.insert(DataFantasy, b.Name)
		end
	end
end
for i,v in pairs(EggCoins) do
	table.insert(DataCoins, " ")
	table.insert(DataCoins, "-- "..v.." --")
	for a,b in pairs(MyEggData) do
		if b.Currency == v then
			table.insert(DataCoins, b.Name)
		end
	end
end




local Library = require(game:GetService("ReplicatedStorage").Framework.Library)
local IDToName = {}
local NameToID = {}
for i,v in pairs(Library.Directory.Pets ) do
    IDToName[i] = v.name
    NameToID[v.name] = i
end

function GetPets()
    local MyPets = {}
    for i,v in pairs(Library.Save.Get().Pets) do
        local ThingyThingyTempTypeThing = (v.g and 'Gold') or (v.r and 'Rainbow') or (v.dm and 'Dark Matter') or 'Normal'
        local TempString = ThingyThingyTempTypeThing .. IDToName[v.id]
        if MyPets[TempString] then
            table.insert(MyPets[TempString], v.uid)
        else
            MyPets[TempString] = {}
            table.insert(MyPets[TempString], v.uid)
        end
    end
    return MyPets
end
spawn(function()
	while true do wait()
		if StartCombine then
			for i, v in pairs(GetPets()) do
				if #v >= Required and StartCombine then
					if string.find(i, "Normal") and StartCombine and Golden then
						local Args = {}
						for eeeee = 1, Required do
							Args[#Args+1] = v[#Args+1]
						end
						Library.Network.Invoke("use golden machine", Args)

					elseif string.find(i, "Gold") and StartCombine and Rainbow then
						local Args = {}
						for eeeee = 1, Required do
							Args[#Args+1] = v[#Args+1]
						end
						Library.Network.Invoke("use rainbow machine", Args)
					end
				end
			end
		end
	end
end)

PetToggle:Toggle("Open Eggs",function(State)
	OpenEggs = State
end)
PetToggle:Toggle("Triple Eggs", function(State)
	TripleEggs = State
end)
spawn(function()
	while true do wait()
		if OpenEggs then
			local ohTable1 = {
				[1] = SelectedEgg,
				[2] = TripleEggs
			}
			workspace.__THINGS.__REMOTES["buy egg"]:InvokeServer(ohTable1)
		end
	end
end)
PetSetting:DropDown('Tech Eggs', DataTech, function(EggsTable)
	SelectedEgg = EggsTable
end)
PetSetting:DropDown('Fantasy Eggs', DataFantasy, function(EggsTable)
	SelectedEgg = EggsTable
end)
PetSetting:DropDown('Coins Eggs', DataCoins, function(EggsTable)
	SelectedEgg = EggsTable
end)
PetSetting:Button("Remove Animation", function()
	for i,v in pairs(getgc(true)) do
		if (typeof(v) == 'table' and rawget(v, 'OpenEgg')) then
			v.OpenEgg = function()
				return
			end
		end
	end
end)


MiscWindow:Button("Reload GUI", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptRUs/Ryans/main/Ghosthub.lua"))()
end)
MiscWindow:Button("Stat Tracker", function()
loadstring(game:HttpGet("https://pastebin.com/raw/dPXXyp4A", true))()
end)
MiscWindow:Button("Show Pets Hidden Chances", function()
workspace.__MAP.Eggs.DescendantAdded:Connect(function(a)
   if a.Name == 'EggInfo' then
       for i,v in pairs(a.Frame.Pets:GetChildren()) do
           if v:IsA('Frame') and v.Thumbnail.Chance.Text == '??' then
               local pet
               for _,tbl in pairs(getgc(true)) do
                   if (typeof(tbl) == 'table' and rawget(tbl, 'thumbnail')) then
                       if tbl.thumbnail == v.Thumbnail.Image then
                           pet = string.split(tostring(tbl.model.Parent), ' - ')[1]
                       end
                   end
               end
               for _,egg in pairs(game.ReplicatedStorage.Game.Eggs:GetDescendants()) do
                   if egg:IsA('ModuleScript') and typeof(require(egg).drops) == 'table' then
                       for _,drop in pairs(require(egg).drops) do
                           if pet == '266' then v.Thumbnail.Chance.Text = '0.000002%' return end
                           if drop[1] == pet then
                               v.Thumbnail.Chance.Text = drop[2] .. '%'
                           end
                       end
                   end
               end
           end
       end
   end
end)

local lib = require(game.ReplicatedStorage.Framework.Library)
table.foreach(lib.Save.Get(), print)

local oldworld = lib.Save.Get().World
while wait(0.1) do
   if lib.Save.Get().World ~= oldworld then
       oldworld = lib.Save.Get().World
       workspace.__MAP.Eggs.DescendantAdded:Connect(function(a)
           if a.Name == 'EggInfo' then
               for i,v in pairs(a.Frame.Pets:GetChildren()) do
                   if v:IsA('Frame') and v.Thumbnail.Chance.Text == '??' then
                       local pet
                       for _,tbl in pairs(getgc(true)) do
                           if (typeof(tbl) == 'table' and rawget(tbl, 'thumbnail')) then
                               if tbl.thumbnail == v.Thumbnail.Image then
                                   pet = string.split(tostring(tbl.model.Parent), ' - ')[1]
                               end
                           end
                       end
                       for _,egg in pairs(game.ReplicatedStorage.Game.Eggs:GetDescendants()) do
                           if egg:IsA('ModuleScript') and typeof(require(egg).drops) == 'table' then
                               for _,drop in pairs(require(egg).drops) do
                                   if pet == '266' then v.Thumbnail.Chance.Text = '0.000002%' return end
                                   if drop[1] == pet then
                                       v.Thumbnail.Chance.Text = drop[2] .. '%'
                                   end
                               end
                           end
                       end
                   end
               end
           end
       end)
   end
end
end)
MiscWindow:Toggle("Collect VIP & Rank Rewards", function(autorewards)
	if autorewards == true then
		_G.AutoRewards = true
	elseif autorewards == false then
		_G.AutoRewards = false
	end
end)
while task.wait() and _G.AutoRewards do
	workspace.__THINGS.__REMOTES["redeem vip rewards"]:InvokeServer({})
	workspace.__THINGS.__REMOTES["redeem rank rewards"]:InvokeServer({})			
end

MiscWindow:Toggle("Buy Merchant Slot 1", function(Vals)
	merchantBuy1 = Vals
end)
MiscWindow:Toggle("Buy Merchant Slot 2", function(Vals)
	merchantBuy2 = Vals
end)
MiscWindow:Toggle("Buy Merchant Slot 3", function(Vals)
	merchantBuy3 = Vals
end)

spawn(function()
    while true do wait(0)
    local isMerchantHere = game:GetService("Workspace")["__THINGS"]["__REMOTES"]["is merchant here"]:InvokeServer({})[1];
    if (isMerchantHere) then
            if merchantBuy1 then
            local ohTable1 = {
	            [1] = 1
            }
            workspace.__THINGS.__REMOTES["buy merchant item"]:InvokeServer(ohTable1)

            end
            if merchantBuy2 then
            local ohTable1 = {
	            [1] = 2
            }
            workspace.__THINGS.__REMOTES["buy merchant item"]:InvokeServer(ohTable1)
            end
            if merchantBuy3 then

            local ohTable1 = {
	            [1] = 3
            }
            workspace.__THINGS.__REMOTES["buy merchant item"]:InvokeServer(ohTable1)
            end
    elseif not (isMerchantHere) then
	wait(0.1)
    end
end
end)
MiscWindow:Button("Get Gamepasses", function()
	require(game:GetService("ReplicatedStorage").Framework.Modules.Client["5 | Gamepasses"]).Owns = function() return true end
end)
MiscWindow:Button("Possible Anti-Lag", function()
	game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.GUIs["Coin Rewards HUD"].Disabled = true
    if game:GetService("Workspace"):FindFirstChild("__DEBRIS") then
      game:GetService("Workspace")["__DEBRIS"]:Destroy()
    end
end)

MiscWindow:Button("FPS Boost - Beta", function()
	local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
	local g = game
	local w = g.Workspace
	local l = g.Lighting
	local t = w.Terrain
	t.WaterWaveSize = 0
	t.WaterWaveSpeed = 0
	t.WaterReflectance = 0
	t.WaterTransparency = 0
	l.GlobalShadows = false
	l.FogEnd = 9e9
	l.Brightness = 0
	settings().Rendering.QualityLevel = "Level01"
	for i, v in pairs(g:GetDescendants()) do
		if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
			v.Material = "Plastic"
			v.Reflectance = 0
		elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		elseif v:IsA("Explosion") then
			v.BlastPressure = 1
			v.BlastRadius = 1
		elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
			v.Enabled = false
		elseif v:IsA("MeshPart") then
			v.Material = "Plastic"
			v.Reflectance = 0
			v.TextureID = 10385902758728957
		end
	end
	for i, e in pairs(l:GetChildren()) do
		if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
			e.Enabled = false
		end
	end
end)

FunWindow:Button("Visual Dupe Gems", function()
	function comma_value(amount)
	  local formatted = amount
	  while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
		  break
		end
	  end
	  return formatted
	end

	local diamonds = game.Players.LocalPlayer.PlayerGui.Main.Right.Diamonds.Amount
	local old = diamonds.Text
	local oldNumber = string.gsub(old, ",", "")
	local newNumber = oldNumber * 2
	local new = comma_value(newNumber)
	local newString = tostring(new)
	diamonds.Text = newString
end)

FunWindow:Button("Visual Dupe Tech Coins", function()
	function comma_value(amount)
	  local formatted = amount
	  while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
		  break
		end
	  end
	  return formatted
	end

	local TechCoin = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Tech Coins"].Amount
	local old = TechCoin.Text
	local oldNumber = string.gsub(old, ",", "")
	local newNumber = oldNumber * 2
	local new = comma_value(newNumber)
	local newString = tostring(new)
	TechCoin.Text = newString
end)
FunWindow:Button("Visual Dupe Fantasy Coins", function()
	function comma_value(amount)
	  local formatted = amount
	  while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
		  break
		end
	  end
	  return formatted
	end

	local FantasyCoin = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Fantasy Coins"].Amount
	local old = FantasyCoin.Text
	local oldNumber = string.gsub(old, ",", "")
	local newNumber = oldNumber * 2
	local new = comma_value(newNumber)
	local newString = tostring(new)
	FantasyCoin.Text = newString
end)
FunWindow:Button("Visual Dupe Regular Coins", function()
	function comma_value(amount)
	  local formatted = amount
	  while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
		  break
		end
	  end
	  return formatted
	end

	local RegularCoin = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Coins.Amount
	local old = RegularCoin.Text
	local oldNumber = string.gsub(old, ",", "")
	local newNumber = oldNumber * 2
	local new = comma_value(newNumber)
	local newString = tostring(new)
	RegularCoin.Text = newString
end)

MenuStuff:Button("Golden Menu", function()
	game:GetService("Players").LocalPlayer.PlayerGui.Golden.Enabled = true
end)
MenuStuff:Button("Rainbow Menu",function()
	game:GetService("Players").LocalPlayer.PlayerGui.Rainbow.Enabled = true
end)
MenuStuff:Button("Dark Matter Menu", function()
	game:GetService("Players").LocalPlayer.PlayerGui.DarkMatter.Enabled = true
end)
MenuStuff:Button("Fuse Menu", function()
	game:GetService("Players").LocalPlayer.PlayerGui.FusePets.Enabled = true
end)
MenuStuff:Button("Upgrade Menu", function()
	game:GetService("Players").LocalPlayer.PlayerGui.Upgrades.Enabled = true
end)
MenuStuff:Button("Enchantment Menu",  function()
	game:GetService("Players").LocalPlayer.PlayerGui.EnchantPets.Enabled = true
end)
MenuStuff:Button("Merchant Menu", function()
	game:GetService("Players").LocalPlayer.PlayerGui.Merchant.Enabled = true
end)
MenuStuff:Button("Bank Menu", function()
	game:GetService("Players").LocalPlayer.PlayerGui.Bank.Enabled = true
end)

else
    game.Players.LocalPlayer:Kick("You have been kicked due to Incorrect Key, please complete linkvertise That has been copied to clipboard to support us and get the key!")
    setclipboard("https://link-hub.net/79302/pet-simulator-x-script")
end
