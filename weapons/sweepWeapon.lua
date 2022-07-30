require('weapons.weapon')
require('utility')

SweepFire = Weapon:new()

local SWEEP_DEGREES     = 90
local MAX_FRAMES_ACTIVE = seconds(SWEEP_DEGREES * 2.5)

function SweepFire:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "Sweep Fire"
  weapon.range = 400
  weapon.speedCap = 7.0
  weapon.cooldownToSet = seconds(5.0)
  weapon.degreesOffset = 0
  weapon.framesActive = 0
  weapon.sweepDirection = 1
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function SweepFire:onFire (cursorX, cursorY)
  local spawnX = self.parent:centerX()
  local spawnY = self.parent:centerY()

  local xDistance = cursorX - spawnX
  local yDistance = cursorY - spawnY
  local angle = math.atan(yDistance / xDistance)
  
  angle = angle + math.pi * (self.degreesOffset / 180)

  local xSpeed = self.speedCap * math.cos(angle)
  local ySpeed = self.speedCap * math.sin(angle)
    
  if xDistance < 0 then
    xSpeed = xSpeed * -1 
    ySpeed = ySpeed * -1
  end

  local bullet = Bullet:new(spawnX, spawnY, xSpeed, ySpeed, self.parent.faction)
  table.insert(bullets, bullet)
  
  self.degreesOffset = self.degreesOffset + self.sweepDirection * 5
  
  if math.abs(self.degreesOffset) == SWEEP_DEGREES / 2 then
    self.sweepDirection = self.sweepDirection * -1
  end
  
  self.cooldownFrames = 5
  
  if self.framesActive == MAX_FRAMES_ACTIVE then
    self.cooldownFrames = self.cooldownFrames + self.cooldownToSet
    self.framesActive   = 0
  end
end

table.insert(weaponConstructors, SweepFire)