require('weapons.weapon')

BasicGun = Weapon:new()

function BasicGun:new (parent)
  local weapon    = Weapon:new(parent)
  weapon.name     = "Pistol"
  weapon.range    = 73
  weapon.speedCap = 8
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function BasicGun:onFire (cursorX, cursorY)
  local projectileSpeeds = self:getProjectileSpeed(cursorX, cursorY)
  local spawnX = self.parent.x + (self.parent.width / 2) - 1
  local spawnY = self.parent.y + (self.parent.height / 2) - 1
  local bullet = Bullet:new(spawnX, spawnY, projectileSpeeds[1], projectileSpeeds[2], self.parent.faction)
  bullet.damage = 5
  bullet.acceleration = 0.97
  table.insert(bullets, bullet)
  self.cooldownFrames = seconds(0.8) 
end

table.insert(weaponConstructors, BasicGun)