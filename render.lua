require('utility')
require('entities.data')
require('gameVariables')

drawEntity = function (entity)
  love.graphics.setCanvas()
  local image = assets[entity.imagePath]
  love.graphics.draw(image, entity.x, entity.y, entity.r)
end

drawUI = function ()
  renderPlayerHealth()
  renderPlayerWeapons()
  
  local screenRight, screenBottom = fixedWindowPosition(gameWidth, gameHeight)
  
  local ICON_SIZE      = 32
  local EXTRA_SPACE_PX = 4
  
  if player.equippedWeaponL ~= nil then
    if player.equippedWeaponL.activeFrames > 0 then
      local leftWeaponIcon = assets[player.equippedWeaponL.iconPath]
      love.graphics.draw(leftWeaponIcon, screenRight - (ICON_SIZE * 2 + EXTRA_SPACE_PX), screenBottom - ICON_SIZE)
    end
  end
  if player.equippedWeaponR ~= nil then
    if player.equippedWeaponR.activeFrames > 0 then
      local rightWeaponIcon = assets[player.equippedWeaponR.iconPath]
      love.graphics.draw(rightWeaponIcon, screenRight - ICON_SIZE, screenBottom - ICON_SIZE)
    end
  end
end

renderHealthBar = function (entity, offset)
  love.graphics.setCanvas()
  local healthPercent = entity.health / entity.maxHealth
  
  love.graphics.setColor(75/255, 75/255, 75/255)
  
  local x, y = fixedWindowPosition(5, gameHeight - (10 + offset * 20))
  love.graphics.rectangle("fill", x, y, gameWidth - 80, 5)
  
  love.graphics.setColor(255/255, 0/255, 0/255)
  love.graphics.rectangle("fill", x, y, (gameWidth - 80) * healthPercent, 5)
  love.graphics.setColor(255/255, 255/255, 255/255)
  
  local font = love.graphics.newFont(10)
  love.graphics.setFont(font)
  
  x, y = fixedWindowPosition(5, gameHeight - (25 + offset * 20))
  love.graphics.printf(entity.name, x, y, 180, "left")
end

renderPlayerHealth = function ()
    local font = love.graphics.newFont(14)
    love.graphics.setFont(font)
    if player.health / player.maxHealth <= 0.25 then
      love.graphics.setColor(255/255, 0/255, 0/255)
    else
      love.graphics.setColor(255/255, 255/255, 255/255)
    end
    love.graphics.printf(player.health, player.x - 100 + player.width / 2, player.y + 10, 200, "center")
    love.graphics.setColor(255/255, 255/255, 255/255)
end

renderPlayerWeapons = function ()
  if player.switchFrames > 0 then
    player.switchFrames = player.switchFrames - 1
    local font = love.graphics.newFont(14)
    love.graphics.setFont(font)
    love.graphics.setColor(255/255, 255/255, 255/255)
    if player.equippedWeaponL ~= nil then
      love.graphics.printf(player.equippedWeaponL.name, player.x - 150 + player.width / 2, player.y - 30, 200, "center")
    end
    if player.equippedWeaponR ~= nil then
      love.graphics.printf(player.equippedWeaponR.name, player.x - 50 + player.width / 2, player.y - 30, 200, "center")
    end
  end

  if player.equippedWeaponL ~= nil then
    local reloadTime = round(player.equippedWeaponL.cooldownFrames / FPS, 1)
    if reloadTime > 0.1 then
          love.graphics.printf(string.format("%.1f", reloadTime), player.x - 150 + player.width / 2, player.y - 15, 200, "center")
    end
  end
  
  if player.equippedWeaponR ~= nil then
    local reloadTime = round(player.equippedWeaponR.cooldownFrames / FPS, 1)
    if reloadTime > 0.1 then
          love.graphics.printf(string.format("%.1f", reloadTime), player.x - 50 + player.width / 2, player.y - 15, 200, "center")
    end
  end
  
  local font = love.graphics.newFont(14)
  love.graphics.setFont(font)
end

renderScreenText = function ()
    for i = 1, #screenText do
      local font = love.graphics.newFont(screenText[i].fontSize)
      love.graphics.setFont(font)
      love.graphics.setColor(screenText[i].r, screenText[i].g, screenText[i].b, screenText[i].opacity)
      love.graphics.print(screenText[i].message, screenText[i].x, screenText[i].y)
    end
    
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

end

renderBkgdEntities = function ()
  local layers = getEntityLayers()
  local background = layers[1]
  
  for i = 1, #background do
    background[i]:draw()
  end
end

renderFrgdEntities = function ()
  local layers = getEntityLayers()
  local foreground = layers[2]
  
  for i = 1, #foreground do
    foreground[i]:draw()
  end
end

renderBullets = function ()
  for i = 1, #bullets do
    drawEntity(bullets[i])
  end
end

drawMaskContext = function ()
  love.graphics.setCanvas(maskCanvas)
  love.graphics.clear()

  local topLeftIndex = getTileIndexFromPosition(-xOffset, -yOffset)
  -- The extra tile on renderBoxWidth and renderBoxHeight provides a "buffer" for smooth loading; without it the player can easily notice tiles being
  -- loaded in

  local renderBoxWidth = gameWidth / TILE_SIZE + 2
  local renderBoxHeight = gameHeight / TILE_SIZE + 2
  
  for i = 1, renderBoxWidth do
    for j = 1, renderBoxHeight do
      local index = topLeftIndex + j + (i - 1) * MAP_WIDTH
      if index < #tileArray + 1 then
        if tileArray[index] == nil then
          print(topLeftIndex, xOffset, yOffset, index)
        elseif tileArray[index].imagePath ~= "images/tiles/empty.png" then
          local image = assets[tileArray[index].imagePath]
          love.graphics.draw(image, tileArray[index].x, tileArray[index].y)
        end
      end
    end
  end

  love.graphics.setCanvas()
end

getTileIndexFromPosition = function (x, y)
    local xIndex = math.floor(x / TILE_SIZE)
    local yIndex = math.floor(y / TILE_SIZE)
    local index = yIndex * MAP_WIDTH + xIndex
    return index
end

debugShowBoundingBoxes = function ()
  for i = 1, #boundingBoxes do
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("line", boundingBoxes[i].minX, boundingBoxes[i].minY, boundingBoxes[i].width, boundingBoxes[i].height)  
  end
  love.graphics.setColor(1,1,1)
end