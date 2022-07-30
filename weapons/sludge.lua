require('weapons.burstWeapon')
require('bullets.sludgeBullet')

SludgeWeapon = Weapon:new()

function SludgeWeapon:new (parent, cooldown)
  local weapon = BurstFire:new(parent)
  weapon.name = "Sludge"
  weapon.range = 40
  weapon.speedCap = 0.8
  weapon.cooldownToSet = cooldown
  weapon.degreesOffset = 0
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function SludgeWeapon:onFire (cursorX, cursorY)
  local NUM_BULLETS = 8
  local spawnX      = self.parent:centerX()
  local spawnY      = self.parent:centerY()
  local baseAngle   = math.pi * (self.degreesOffset / 180)
  local angleOffset = math.pi * (2 / NUM_BULLETS)

  for i = 1, NUM_BULLETS do
    local angle = baseAngle + (angleOffset * (i - 1))
    
    local xSpeed = self.speedCap * math.cos(angle)
    local ySpeed = self.speedCap * math.sin(angle)
    
    --if xDistance < 0 then
    --  xSpeed = xSpeed * -1 
     -- ySpeed = ySpeed * -1
    --e-nd

    local bullet = SludgeBullet:new(spawnX, spawnY, xSpeed, ySpeed, self.parent.faction)
    table.insert(bullets, bullet)
  end
  
  self.degreesOffset  = self.degreesOffset + 15
  self.cooldownFrames = self.cooldownToSet
end

table.insert(weaponConstructors, SludgeWeapon)