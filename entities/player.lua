require('entities.base')
require('utility')

inventory = {}

Player = Entity:new()

function Player:new (x, y)
  local player                  = Entity:new(x, y)
  player.name                   = "Player"
  player.faction                = "player"
  player.health                 = 250
  player.maxHealth              = 250
  player.speedCap               = 2
  player.width                  = 8
  player.height                 = 10
  player.imagePath              = "images/entities/player.png"
  player.activeLeftWeaponIndex  = 1
  player.activeRightWeaponIndex = 1
  player.switchFrames           = 0
  player.equippedWeaponL        = nil
  player.equippedWeaponR        = nil
  setmetatable(player, self)
  self.__index = self
  return player
end

function Player:update ()
  self:updatePosition()
  self:updateSpeed()
  self:updateStatuses()
  self:updateWeapons()
  self:updateKeyInput()
  self:updateMouseInput()
  self:correctPosition()
end

function Player:updateWeapons ()
  for i = 1, #inventory do
    inventory[i]:update()
  end
  
  if player.equippedWeaponL ~= nil then player.equippedWeaponL:update() end
  if player.equippedWeaponR ~= nil then player.equippedWeaponR:update() end
end

function Player:updateKeyInput ()
  if love.keyboard.isDown("a") then
    if self.speedX > 1 then
      self.speedX = self.speedX - 0.7
    else
      self.speedX = self.speedX - 0.3
    end
        
    if self.speedX < self.speedCap * -1 then
      self.speedX = self.speedCap * -1
    end
  end
  if love.keyboard.isDown("d") then
    if self.speedX < -1 then
      self.speedX = self.speedX + 0.7
    else
      self.speedX = self.speedX + 0.3
    end
        
    if self.speedX > self.speedCap then
      self.speedX = self.speedCap
    end
  end
  if love.keyboard.isDown("w") then
    if self.speedY > 1 then
      self.speedY = self.speedY - 0.7
    else
      self.speedY = self.speedY - 0.3
    end
          
    if self.speedY < self.speedCap * -1 then
      self.speedY = self.speedCap * -1
    end 
  end
  if love.keyboard.isDown("s") then
    if self.speedY < -1 then
      self.speedY = self.speedY + 0.7
    else
      self.speedY = self.speedY + 0.3
    end
          
    if self.speedY > self.speedCap then
      self.speedY = self.speedCap
    end
  end
  if love.keyboard.isDown("tab") then
    self.switchFrames = seconds(0.1)
  end
end

function Player:updateMouseInput ()
  if love.mouse.isDown(1) and self.equippedWeaponL ~= nil then
    self.equippedWeaponL:onHold(getMousePosition())
    if self.equippedWeaponL.cooldownFrames > 0 then self.equippedWeaponL.activeFrames = 25 end
  end
  
  if love.mouse.isDown(2) and self.equippedWeaponR ~= nil then
    self.equippedWeaponR:onHold(getMousePosition())
    if self.equippedWeaponL.cooldownFrames > 0 then self.equippedWeaponL.activeFrames = 25 end
  end
end

function Player:correctPosition ()
  if self.x < 0 then
    self.x = 0
    self.speedX = 0
  end
  if self.x > TILE_SIZE * MAP_WIDTH - self.width then
    self.x = TILE_SIZE * MAP_WIDTH - self.width
    self.speedX = 0
  end
  if self.y < 0 then
    self.y = 0
    self.speedY = 0
  end
  if self.y > TILE_SIZE * MAP_HEIGHT - self.height then
    self.y = TILE_SIZE * MAP_HEIGHT - self.height
    self.speedY = 0
  end
end