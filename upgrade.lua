-- Upgrades default scripts, or only specific ones if passed as argument.
-- upgrade [scriptName1, ...]

local defaultScripts = {"upgrade", "wget"}
local scriptsBaseUrl = "https://raw.githubusercontent.com/Kyasaki/computercraft-scripts/master/"

-- Upgrades a script given its name
function upgradeScript(scriptName)
	local scriptUrl = scriptsBaseUrl .. scriptName .. ".lua"
	local scriptPath = shell.dir() .. "/" .. scriptName
	print("> ", scriptPath, "...")

	local localScript = fs.open(scriptPath, "w")
	if not localScript then
		error("Failed opening local script")
	end

	local remoteScript = http.get(scriptUrl)
	if not remoteScript then
		error("Failed opening remote script")
	end

	localScript.write(remoteScript.readAll())
	localScript.close()
end

-- get the list of scripts to upgrade
local scripts = {...}
if table.getn(scripts) == 0 then
	print("(Using default script list)")
	scripts = defaultScripts
end

-- update listed scripts
for scriptIndex, scriptName in ipairs(scripts) do
	upgradeScript(scriptName)
end

print("Successfully updated scripts!")
