-- Downloads a ressource on the internet down to a computer disk
-- wget <remoteUrl> <localPath>
local remoteFileUrl, localFilePath = ...
localFilePath = shell.dir() .. "/" .. localFilePath
print("Downloading ", remoteFileUrl, " to ",  localFilePath, "...")

local localFile = fs.open(localFilePath, "w")
if not localFile then
	error("Failed opening local file")
end

local remoteFile = http.get(remoteFileUrl)
if not remoteFile then
	error("Failed opening remote file")
end

local fileContents = remoteFile.readAll()
localFile.write(fileContents)
localFile.close()
print("> Succesfully wrote ", #fileContents, " bytes")
