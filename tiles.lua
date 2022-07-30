require('constants')

defaultTile = function (x, y)
  local tile = {
    x = x,
    y = y,
    width = 16,
    height = 16,
    collidable = false,
    imagePath = "images/tiles/empty.png",
  }
  return tile   
end

qButton = function (x, y)
  local tile = defaultTile(x, y)
  tile.imagePath = "images/tiles/q-button.png"
  return tile   
end

eButton = function (x, y)
  local tile = defaultTile(x, y)
  tile.imagePath = "images/tiles/e-button.png"
  return tile    
end

dungeonFloor1 = function (x, y)
  local tile = defaultTile(x, y)
  tile.imagePath = "images/tiles/dungeon-floor-1.png"
  return tile     
end

dungeonFloor2 = function (x, y)
  local tile = defaultTile(x, y)
  tile.imagePath = "images/tiles/dungeon-floor-2.png"
  return tile    
end

dungeonWall1 = function (x, y)
  local tile = defaultTile(x, y)
  tile.collidable = true
  tile.imagePath = "images/tiles/dungeon-wall-1.png"
  return tile   
end

minefieldFloorTile = function (x, y)
  local tile = defaultTile(x, y)
  tile.imagePath = "images/tiles/minefield-dirt-floor.png"
  return tile
end

minefieldWallTile = function (x, y)
  local tile = defaultTile(x, y)
  tile.collidable = true
  tile.imagePath = "images/tiles/minefield-rock.png"
  return tile
end

minefieldGemTile = function (x, y)
  local tile = defaultTile(x, y)
  tile.collidable = true
  tile.imagePath = "images/tiles/minefield-gem.png"
  return tile
end

vampireLairWallTile = function (x, y)
  local tile = defaultTile(x, y)
  tile.collidable = true
  tile.imagePath = "images/tiles/blue-brick-wall.png"
  return tile
end

vampireLairFloorTile = function (x, y)
  local tile = defaultTile(x, y)
  tile.collidable = false
  tile.imagePath = "images/tiles/blue-brick-floor.png"
  return tile
end

tileset = {defaultTile, qButton, eButton, dungeonFloor1, dungeonFloor2, dungeonWall1, 
  minefieldFloorTile, minefieldWallTile, minefieldGemTile, vampireLairWallTile, vampireLairFloorTile}

getTileIndexFromImagePath = function (path)
  for i = 1, #tileset do
    local tile = tileset[i](0,0)
    if path == tile.imagePath then
      return i
    end
  end
  return NOT_FOUND
end