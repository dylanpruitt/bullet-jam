bulletConstructors = {}

addBullets = function (folder)
  local files = love.filesystem.getDirectoryItems( folder )
  
  local subfolders = {}
  
  for i = 1, #files do
    local path = folder .. "/" .. files[i]
    
    if string.find(path, ".lua") then
      if path ~= "bullets/data.lua" then
        path = path:gsub("/", ".")
        path = path:gsub(".lua", "")
        require(path)
      end
    else
      table.insert(subfolders, path)
    end
  end
  
  for i = 1, #subfolders do
    addBullets(subfolders[i])
  end
end

addBullets("bullets")

bullets = {}