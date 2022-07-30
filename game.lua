require('constants')
require('render')
require('weapons.data')
require('screenText')
require('entities.data')
require('gameVariables')
local json = require 'json'

updatePlayerMovement = function (dt)
  local movementChanged = false
  if player.x + xOffset > gameWidth / 2 and xOffset > -(MAP_WIDTH * TILE_SIZE - gameWidth) then
    xOffset = xOffset - math.abs(player.speedX)
    movementChanged = true
    if xOffset < -(MAP_WIDTH * TILE_SIZE - gameWidth) then
      xOffset = -(MAP_WIDTH * TILE_SIZE - gameWidth)
    end
  end
  if player.y + yOffset > gameHeight / 2 and yOffset > -(MAP_HEIGHT * TILE_SIZE - gameHeight) then
    yOffset = yOffset - math.abs(player.speedY)
    movementChanged = true
    if yOffset < -(MAP_HEIGHT * TILE_SIZE - gameWidth)  then
      yOffset = -(MAP_HEIGHT * TILE_SIZE - gameWidth) 
    end
  end
  if player.x + xOffset < gameWidth / 2 and xOffset < 0 then
    xOffset = xOffset + math.abs(player.speedX)
    movementChanged = true
    if xOffset > 0 then xOffset = 0 end
  end
  if player.y + yOffset < gameHeight / 2 and yOffset < 0 then
    yOffset = yOffset + math.abs(player.speedY)
    movementChanged = true
    if yOffset > 0 then yOffset = 0 end
  end

  if movementChanged and (player.speedX ~= 0 or player.speedY ~= 0) then
    updateMask = true
  end
end


updateBullets = function ()  
  for i = 1, #bullets do
    if bullets[i].framesActive < bullets[i].maxFramesActive then
      bullets[i]:update()    
    end

    for j = 1, #entities do
      if entities[j]:collidingWith(bullets[i]) then
        if entities[j].name == "Portal" then
          entities[j]:transferObject(bullets[i])
        else 
          bullets[i]:onCollide(entities[j])
        end
      end
    end

    for j = 1, #boundingBoxes do
      if entityCollidingWithBounds(bullets[i], boundingBoxes[j]) then
        bullets[i].framesActive = bullets[i].maxFramesActive
        break
      end
    end
  end

  removeDeadBullets()
end

removeDeadBullets = function ()
  local temp = {}
  for i = 1, #bullets do
    if bullets[i].framesActive < bullets[i].maxFramesActive then
      table.insert(temp, bullets[i])   
    end
  end
  bullets = temp
end   

updateScreenText = function ()
  local temp = {}
  for i = 1, #screenText do
    screenText[i]:update()
    if screenText[i].waitFrames > 0 or screenText[i].fadeFrames > 0 then
      table.insert(temp, screenText[i])
    end
  end

  screenText = temp
end

updateEntities = function ()
  for i = 1, #entities do
    entities[i]:update()
  end

  removeDeadEntities()
end

removeDeadEntities = function ()
  local temp = {}
  for i = 1, #entities do
    if entities[i].health > 0 then
      table.insert(temp, entities[i])   
    end
  end
  entities = temp
end

stopGameOnPlayerDeath = function ()
  if player.health <= 0 then
    game.clear()
    game.context.font = "bold 24px Arial"
    game.context.fillText("YOU DIED", 15, 135)
    game.stop()
  end
end

updateMapTransitions = function ()
  for i = 1, #transitionBoxes do
    if transitionBoxes[i] ~= nil and entityCollidingWithBounds(player, transitionBoxes[i]) then
      transitionToMap(transitionBoxes[i].path, transitionBoxes[i].spawnID)
    end
  end
end

getTileIndices = function (tileArray)
  local TILES = {}
  for i = 1, #tileset do
    local tile = tileset[i](0,0)
    table.insert(TILES, tile)
  end
  
  local temp = {}
  for i = 1, #tileArray do
    for j = 1, #TILES do
      if tileArray[i].imagePath == tileArray[j].imagePath then
        table.insert(temp, j)
      end
    end
  end
  
  return temp
end

playerHasWeapon = function (name)
  for i = 1, #inventory do
    if inventory[i].name == name then
      return true
    end
  end
  
  return false
end

function loadMap (path, spawnID)
  mapFilePath = path
  local jsonFile = io.open(path .. ".json", "r")
  
  print("Loading map " .. path .. ".json...")
  
  if jsonFile == nil then
    print("[!!] Map at " .. path .. ".json DOES NOT EXIST.")
    return false
  end
  
  local contents = jsonFile:read( "*all" )
  local gameState = json.decode(contents)

  spawnLocations = gameState.spawnLocations or {}

  local spawn = spawnLocations[spawnID] or nil
  
  if spawn ~= nil then
    spawnX = spawn.x
    spawnY = spawn.y
  else
    spawnX = gameState.spawnX
    spawnY = gameState.spawnY
  end

  player.x = spawnX
  player.y = spawnY
  MAP_WIDTH = gameState.MAP_WIDTH
  MAP_HEIGHT = gameState.MAP_HEIGHT
  xOffset = math.floor(spawnX / gameWidth) * -gameWidth
  if xOffset < 0 and xOffset < -(MAP_WIDTH * TILE_SIZE - gameWidth) then
    xOffset = -(MAP_WIDTH * TILE_SIZE - gameWidth)
  end
  yOffset = math.floor(spawnY / gameWidth) * -gameWidth 
  if yOffset < 0 and yOffset < -(MAP_HEIGHT * TILE_SIZE - gameWidth) then
    yOffset = -(MAP_HEIGHT * TILE_SIZE - gameWidth)
  end
  
  tileArray = gameState.tiles
  local tilePaths = gameState.tilePaths
  
for i = 1, #tileArray do
    local pathIndex = tileArray[i]
    local index = getTileIndexFromImagePath(tilePaths[pathIndex])
    if index ~= -1 then
      local x = ((i - 1) % MAP_WIDTH) * TILE_SIZE
      local y = math.floor((i - 1) / MAP_WIDTH) * TILE_SIZE
      tileArray[i] = tileset[index](x, y)
    end
  end
  
  boundingBoxes = gameState.boxes
  transitionBoxes = gameState.transitionBoxes
  entities = gameState.entities
  table.insert(entities, 1, player)
  for i = 1, #entities do
    index = getEntityConstructorIndexFromName(entities[i].name)
    if index ~= -1 then
      if entities[i].name == "Weapon Pickup" then
        local weaponIndex = getWeaponIndexFromName(entities[i].weaponID)
        
        if weaponIndex ~= NOT_FOUND then
          local weapon = weaponConstructors[weaponIndex]:new(entities[i])
          entities[i]  = entityConstructors[index]:new(entities[i].x, entities[i].y, weapon)
          if playerHasWeapon(weapon.name) then
            entities[i].health = 0
          end
        else
          entities[i] = entityConstructors[index]:new(entities[i].x, entities[i].y, Weapon:new(entities[i]))
        end
      elseif entities[i].name == "Info Bubble" then
        entities[i] = entityConstructors[index]:new(entities[i].x, entities[i].y, entities[i].message)
      else
        entities[i] = entityConstructors[index]:new(entities[i].x, entities[i].y)
      end
    end
  end
  
  backgroundEntities = gameState.backgroundEntities or {}
  for i = 1, #backgroundEntities do
    index = getEntityConstructorIndexFromName(backgroundEntities[i].name)
    if index ~= -1 then
        table.insert(entities, entityConstructors[index]:new(backgroundEntities[i].x, backgroundEntities[i].y))
    end
  end
  
  bullets         = {}
  screenText      = {}
  player.statuses = {}
  
  maskCanvas = love.graphics.newCanvas(TILE_SIZE * MAP_WIDTH, TILE_SIZE * MAP_HEIGHT)
  jsonFile:close()
  
  mapChanged = true
  
  local scriptInfo = love.filesystem.getInfo(path .. ".lua")
  if scriptInfo ~= nil then
    dofile(path .. ".lua")
    print("Loaded in map script at " .. path .. ".lua")
  else
    mapUpdate = function (entities) end
  end
  
  savePlayerData("saves/autosave.json")
end

function transitionToMap (path, spawnID)
  loadMap (path, spawnID)
end

function savePlayerData (path)
  local jsonFile = io.open(path, "w")
  local inventoryIndices = {}
  
  for i = 1, #inventory do
    table.insert(inventoryIndices, getWeaponIndexFromName(inventory[i].name))
  end
  
  local gameState = {
    mapPath = mapFilePath,
    x = player.x,
    y = player.y,
    inventory = inventoryIndices,
    activeWeapon = player.activeWeaponIndex
  }

  jsonFile:write(json.encode(gameState))
  jsonFile:close()
end

function loadPlayerData (path)
  local jsonFile = io.open(path .. ".json", "r")
  print("Loading save state " .. path .. ".json...")
  
  local contents = jsonFile:read( "*all" )
  local gameState = json.decode(contents)

  local mapPath = gameState.mapPath
  loadMap(mapPath)

  player.x = gameState.x
  player.y = gameState.y
  xOffset = math.floor(player.x / 240) * -240
  if xOffset < 0 and xOffset < -(MAP_WIDTH * TILE_SIZE - 240) then
    xOffset = -(MAP_WIDTH * TILE_SIZE - 240)
  end
  yOffset = math.floor(player.y / 240) * -240 
  if yOffset < 0 and yOffset < -(MAP_HEIGHT * TILE_SIZE - 240) then
    yOffset = -(MAP_HEIGHT * TILE_SIZE - 240)
  end
  player.activeWeaponIndex = gameState.activeWeapon
  inventory = gameState.inventory
  for i = 1, #inventory do
    inventory[i] = weaponConstructors[inventory[i]]:new(player)
  end

  jsonFile:close()
  
  updateMask = true
end