-- Upgrades default scripts, or only specific ones if passed as argument.
-- upgrade [-b branch] [scriptName1, ...]

local scriptsBaseUrl = "https://raw.githubusercontent.com/Kyasaki/computercraft-scripts"
local branch = "master"
local scripts = {"upgrade", "wget"}

-- Upgrades a script given its name
function upgradeScript(scriptName)
	local scriptUrl = scriptsBaseUrl .. "/" .. branch .."/" .. scriptName .. ".lua"
	local scriptPath = shell.dir() .. "/" .. scriptName
	print("> ", scriptPath, "...")

	local remoteScript = http.get(scriptUrl)
	if not remoteScript then
		error("Failed opening remote script at ", scriptUrl)
	end

	local localScript = fs.open(scriptPath, "w")
	if not localScript then
		error("Failed opening local script")
	end

	localScript.write(remoteScript.readAll())
	localScript.close()
end

-- parse arguments
local args = {...}
if table.getn(args) >= 2 and args[1] == "-b" then
	branch = args[2]
  if table.getn(args) > 2 then
    scripts = {}
    for i = 3, table.getn(args) do
      scripts[i - 2] = args[i]
    end
	end
elseif (table.getn(args) > 0) then
	scripts = args
end

-- update listed scripts
for scriptIndex, scriptName in ipairs(scripts) do
	upgradeScript(scriptName)
end

print("Successfully updated scripts from ", branch, " branch!")
