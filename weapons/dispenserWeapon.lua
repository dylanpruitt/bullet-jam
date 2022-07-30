require('weapons.weapon')
require('bullets.healthBullet')

DispenserWeapon = Weapon:new()

function DispenserWeapon:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "Dispenser Weapon"
  weapon.range = 73
  weapon.speedCap = 4
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function DispenserWeapon:onFire (cursorX, cursorY)
  local projectileSpeeds = self:getProjectileSpeed(cursorX, cursorY)
  local spawnX = self.parent.x + (self.parent.width / 2) - 1
  local spawnY = self.parent.y + (self.parent.height / 2) - 1
  local bullet = HealthBullet:new(spawnX, spawnY, projectileSpeeds[1], projectileSpeeds[2], self.parent.faction)
  table.insert(bullets, bullet)
  self.cooldownFrames = 50 
end

table.insert(weaponConstructors, DispenserWeapon)