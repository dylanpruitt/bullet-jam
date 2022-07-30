require('bullets.floaterBullet')
require('weapons.burstWeapon')

FloaterWeapon = Weapon:new()

function FloaterWeapon:new (parent, cooldown)
  local weapon = BurstFire:new(parent)
  weapon.name = "Burst Fire"
  weapon.range = 40
  weapon.speedCap = 1.0
  weapon.cooldownToSet = cooldown
  weapon.degreesOffset = 0
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function FloaterWeapon:onFire (cursorX, cursorY)
  local NUM_BULLETS = 12
  local baseAngle   = math.pi * (self.degreesOffset / 180)
  local angleOffset = math.pi * (2 / NUM_BULLETS)

  for i = 1, NUM_BULLETS do
    local angle = baseAngle + (angleOffset * (i - 1))
    
    local spawnX    = self.parent:centerX() + 150 * math.cos(angle) - 6
    local spawnY    = self.parent:centerY() + 150 * math.sin(angle) - 6
    
    local xDistance = spawnX - self.parent:centerX()
    local yDistance = spawnY - self.parent:centerY()
    local angle = math.atan(yDistance / xDistance)
  
    local xSpeed = self.speedCap * math.cos(angle) * -0.5
    local ySpeed = self.speedCap * math.sin(angle) * -0.5
    if xDistance < 0 then
      xSpeed = xSpeed * -1 
      ySpeed = ySpeed * -1
    end

    local bullet = FloaterBullet:new(spawnX, spawnY, xSpeed, ySpeed, self.parent.faction)
    table.insert(bullets, bullet)
  end
  
  self.degreesOffset  = self.degreesOffset + 15
  self.cooldownFrames = self.cooldownToSet
end

table.insert(weaponConstructors, FloaterWeapon)