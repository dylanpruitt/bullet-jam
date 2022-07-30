require('table')
require('bullets.data')
require('utility')

if not weaponConstructors then
  weaponConstructors = {}
end

Weapon = {
  name = "Basic Weapon",
  range = 60,
  speedCap = 3.2,
  cooldownFrames = 0,
  activeFrames = 0,
  iconPath = "images/icons/default_icon.png",
}

function Weapon:new (parent)
  local weapon = {}
  weapon.parent = parent or nil
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function Weapon:onFire (cursorX, cursorY)
  local projectileSpeeds = self:getProjectileSpeed(cursorX, cursorY)
  local spawnX = self.parent:centerX()
  local spawnY = self.parent:centerY()
  local bullet = Bullet:new(spawnX, spawnY, projectileSpeeds[1], projectileSpeeds[2], self.parent.faction)
  table.insert(bullets, bullet)
  self.cooldownFrames = seconds(0.5)
end

function Weapon:onHold (cursorX, cursorY)
  if self.cooldownFrames == 0 then
    self:onFire(cursorX, cursorY)
  end
  self.activeFrames = 5
end

function Weapon:update ()
  if self.cooldownFrames > 0 then
    self.cooldownFrames = self.cooldownFrames - 1
  end
  
  if self.activeFrames > 0 then
    self.activeFrames = self.activeFrames - 1
  end
end

function Weapon:getProjectileSpeed (cursorX, cursorY)
  local spawnX = self.parent:centerX()
  local spawnY = self.parent:centerY()

  local xDistance = cursorX - spawnX
  local yDistance = cursorY - spawnY
  local angle = math.atan(yDistance / xDistance)
  
  local xSpeed = self.speedCap * math.cos(angle)
  local ySpeed = self.speedCap * math.sin(angle)
  if xDistance < 0 then
    xSpeed = xSpeed * -1 
    ySpeed = ySpeed * -1
  end
  return {xSpeed, ySpeed}
end
      
function Weapon:spreadFire (cursorX, cursorY, bulletType, spreadAngle, numBullets)
  local spawnX = self.parent:centerX()
  local spawnY = self.parent:centerY()
  
  local xDistance = cursorX - spawnX
  local yDistance = cursorY - spawnY
  local baseAngle = math.atan(yDistance / xDistance)

  for i = 1, numBullets do
    local spreadRadians = math.pi * (spreadAngle / 180)
    local angle = baseAngle + math.random() * spreadRadians - (spreadRadians / 2)
    if angle < 0 then
      angle = 2 * math.pi + angle
    end
    
    local xSpeed = self.speedCap * math.cos(angle)
    local ySpeed = self.speedCap * math.sin(angle)
    
    if xDistance < 0 then
      xSpeed = xSpeed * -1 
      ySpeed = ySpeed * -1
    end

    local bullet = bulletType:new(spawnX, spawnY, xSpeed, ySpeed, self.parent.faction)
    table.insert(bullets, bullet)
  end
end

table.insert(weaponConstructors, Weapon)