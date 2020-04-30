# Kyasaki's computercraft scripts
A set of helpful scripts for your turtles, along with upgrader script.

## Quick setup
Paste the following code line by line in a lua prompt as to download the upgrade script:
```lua
file = fs.open(shell.dir() .. "/upgrade", "w")
file.write(http.get("https://raw.githubusercontent.com/Kyasaki/computercraft-scripts/master/upgrade.lua").readAll())
file.close()
exit()
```
You can now proudly invoke the upgrade script anytime and get those scripts in one go!

## Using the upgrade script
Invoking the upgrade script will download an replace a given list of scripts from this repository into you computer/turtle.

```shell
# Upgrade scripts registered in the default list
upgrade

 # Upgrade only specified scripts. Do not add the .lua extension.
upgrade script1 script2 ...

# Use scripts from another branch. Useful for testing pull requests.
upgrade -b feature/test-branch script1 script2 ...
```

## 3nj¤y your time, so precious!
