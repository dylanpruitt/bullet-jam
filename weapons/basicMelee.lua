require('weapons.weapon')

BasicMelee = Weapon:new()

function BasicMelee:new (parent)
  local weapon    = Weapon:new(parent)
  weapon.name     = "Sword"
  weapon.range    = 12
  weapon.speedCap = 1.5
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function BasicMelee:onFire (cursorX, cursorY)
  local projectileSpeeds = self:getProjectileSpeed(cursorX, cursorY)
  local spawnX = self.parent.x + (self.parent.width / 2) - 1
  local spawnY = self.parent.y + (self.parent.height / 2) - 1
  local bullet = SwordBullet:new(spawnX, spawnY, projectileSpeeds[1], projectileSpeeds[2], self.parent.faction)
  table.insert(bullets, bullet)
  self.cooldownFrames = seconds(1.5) 
end

table.insert(weaponConstructors, BasicMelee)