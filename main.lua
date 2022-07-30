local Steam = require 'luasteam'

if not Steam.init() then
    error("Steam couldn't initialize")
end


require('map')
require('assets')
require('entities.data')
require('render')
require('utility')
require('weapons.data')
require('screenText')
require('game')
require('gameVariables')
require('entities.slime')
require('entities.sludge')
require('entities.infoBubble')
require('statuses.slow')

local Slab = require 'libraries.Slab'

local TEST = false

function resize(sx, sy)
  scaleX = sx
  scaleY = sy
  print(scaleX, scaleY)
end

function love.resize(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
  resize(w / gameWidth, h / gameHeight)
end

function love.load(args)
  local DEFAULT_MAP = "maps/demo_1"
  
  love.graphics.setDefaultFilter("nearest")
  
  addAssets("images")
  
  cursor = love.mouse.newCursor("images/crosshair.png", 10, 10)
  love.mouse.setCursor(cursor)
  
  player = Player:new(spawnX, spawnY)

  inventory = {Shotgun:new(player), BasicGun:new(player), Fling:new(player)}
  player.equippedWeaponL = inventory[1]
  player.equippedWeaponR = inventory[2]
  
  table.insert(entities, player)

  if #args >= 1 then
    loadMap(args[1])
  else
    loadMap(DEFAULT_MAP)
  end

  Slab.Initialize(args)
  drawMaskContext()
end

function love.keypressed(key)
  if key == 'q' then
    if player.activeLeftWeaponIndex == #inventory then
      player.activeLeftWeaponIndex = 1
    else
      player.activeLeftWeaponIndex = player.activeLeftWeaponIndex + 1
    end

    player.equippedWeaponL = inventory[player.activeLeftWeaponIndex]
    player.switchFrames = seconds(1.0)
  end
  
  if key == 'e' then
    if player.activeRightWeaponIndex == #inventory then
      player.activeRightWeaponIndex = 1
    else
      player.activeRightWeaponIndex = player.activeRightWeaponIndex + 1
    end

    player.equippedWeaponR = inventory[player.activeRightWeaponIndex]
    player.switchFrames = seconds(1.0)
  end
  if key == 'u' then
    table.insert(entities, Slime:new(getMousePosition()))
  end
  if key == 'r' then
    table.insert(entities, Sludge:new(getMousePosition()))
  end
  if key == 'p' then
    player:addStatus(SlowStatus:new(player, 150))
  end 
  if key == 'i' then
    loadMap("maps/boss_test")
    player.health = player.maxHealth
    TEST = true
  end
  if key == 'o' then
    loadMap("maps/boss_test_2")
    player.health = player.maxHealth
    TEST = true
  end
  if key == 'escape' then
    paused = not paused
  end
end

love.mousepressed = function (x, y, button)
  if button == 1 then
    if player.equippedWeaponL.cooldownFrames == 0 then
      player.equippedWeaponL:onFire(getMousePosition())
      player.equippedWeaponL.activeFrames = 25
    end
  elseif button == 2 then
    if player.equippedWeaponR.cooldownFrames == 0 then
      player.equippedWeaponR:onFire(getMousePosition())
      player.equippedWeaponR.activeFrames = 25
    end
  end
end

function love.update(dt)
  Steam.runCallbacks()
  if not paused then
    timeElapsed = os.clock()
        
    updateEntities()
    updateScreenText()
    updateMapTransitions()
    updateBullets()
    
    if player.health <= 0 then
      loadPlayerData("saves/autosave")
      player.health = player.maxHealth
      bullets         = {}
      screenText      = {}
      player.statuses = {}
    end
    
    collectgarbage("collect")

    timeElapsed = (os.clock() - timeElapsed)  + dt
    
    if timeElapsed < 1 / FPS then
        love.timer.sleep(1 / FPS - timeElapsed)
    end
  else
      Slab.Update(dt)
      drawModUI()
  end
end

function love.draw()
    if not paused then
    updatePlayerMovement()
    
    if updateMask then
      love.graphics.scale(1, 1)
      love.graphics.translate(0,0)
      drawMaskContext()
      updateMask = false
    end
    
    if mapChanged then
      loadFrames = loadFrames + 1
      if loadFrames % 10 == 0 then
        drawMaskContext()
      end
      if loadFrames == seconds(1.5) then
        mapChanged = false
      end
    end

    love.graphics.scale(scaleX, scaleY)
    love.graphics.translate(xOffset, yOffset)
    love.graphics.draw(maskCanvas, 0, 0)
    renderBkgdEntities()
    renderBullets()
    renderFrgdEntities()
    renderScreenText()
    drawUI()
    
    local numBosses = 0
    for i = 1, #entities do
      if entities[i].isBoss then
        renderHealthBar(entities[i], numBosses) 
        numBosses = numBosses + 1
      end
    end
    
    if timeElapsed > 0 and frame == 0 then
      love.graphics.print("FPS: " .. string.format("%.1f", (1 / timeElapsed)), 50, 50)
      frame = 5
    end
  else
    Slab.Draw()
  end
end

function love.quit()
  Steam.shutdown()
end