assets = {}

addAssets = function (folder)
  local files = love.filesystem.getDirectoryItems( folder )
  for i = 1, #files do
    if files[i] ~= nil then
      path = folder .. "/" .. files[i]
      info = love.filesystem.getInfo(path)
      if     info.type == "file"      then
        assets[path] = love.graphics.newImage(path)
      elseif info.type == "directory" then
        addAssets(path)
      end
    end
  end
end