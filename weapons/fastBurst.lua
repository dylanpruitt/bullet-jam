require('weapons.weapon')

FastBurst = Weapon:new()

local MAX_FRAMES_ACTIVE = seconds(2.0)

function FastBurst:new (parent, cooldown)
  local weapon = Weapon:new(parent)
  weapon.name = "Burst Fire"
  weapon.range = 40
  weapon.speedCap = 5.0
  weapon.cooldownToSet = cooldown
  weapon.degreesOffset = 0
  weapon.framesActive = 0
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function FastBurst:onFire (cursorX, cursorY)
  local spawnX = self.parent:centerX()
  local spawnY = self.parent:centerY()

  local xDistance = cursorX - spawnX
  local yDistance = cursorY - spawnY
  local angle = math.atan(yDistance / xDistance)
  
  angle = angle + math.pi * (self.degreesOffset / 180)

  for i = 1, 4 do
    local xSpeed = self.speedCap * math.cos(angle)
    local ySpeed = self.speedCap * math.sin(angle)
      
    if xDistance < 0 then
      xSpeed = xSpeed * -1 
      ySpeed = ySpeed * -1
    end

    local bullet = Bullet:new(spawnX, spawnY, xSpeed, ySpeed, self.parent.faction)
    table.insert(bullets, bullet)
    
    angle = angle + (math.pi / 2)
  end
  
  self.degreesOffset = self.degreesOffset + 5
  
  self.cooldownFrames = 2
  self.framesActive   = self.framesActive + 2
  
  if self.framesActive == MAX_FRAMES_ACTIVE then
    self.cooldownFrames = self.cooldownFrames + self.cooldownToSet
    self.framesActive   = 0
  end
end