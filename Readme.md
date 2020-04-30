<img src=logo.png height=130 align=right>

# Kyasaki's computercraft scripts
A set of helpful scripts for your computers and turtles, helpfully provided by the great update script.

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

```bash
# Upgrade scripts registered in the default list
upgrade

 # Upgrade only specified scripts. Do not add the .lua extension.
upgrade script1 script2 ...

# Use scripts from another branch. Useful for testing pull requests.
upgrade -b feature/test-branch script1 script2 ...
```

## Improving the upgrade script
As the upgrade script cares about directory of invocation, you can download various versions of the same script in the same disk.

> Supposing we are the disk root, installed the upgrade script, and want to test a brand new upgrade script on the feature/new-upgrade-script branch, we can do the following:
```bash
mkdir new-upgrade-script # Create directory for working branch
cd new-upgrade-script
../upgrade -b feature/new-upgrade-script # Get new upgrade script, safe keeping the one we had
upgrade # Invoking the brand new update script
```

## 3nj¤y your time, so precious!
