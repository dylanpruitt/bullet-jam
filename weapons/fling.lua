require('weapons.weapon')
require('bullets.frenzyBullet')

Fling = Weapon:new()

function Fling:new (parent)
  local weapon    = Weapon:new(parent)
  weapon.name     = "Fling"
  weapon.range    = 80
  weapon.speedCap = 10
  weapon.iconPath = "images/icons/fling_icon.png"
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function Fling:onFire (cursorX, cursorY)
  local projectileSpeeds = self:getProjectileSpeed(cursorX, cursorY)
  local spawnX = self.parent.x + (self.parent.width / 2) - 1
  local spawnY = self.parent.y + (self.parent.height / 2) - 1
  local bullet = DisableBullet:new(spawnX, spawnY, projectileSpeeds[1], projectileSpeeds[2], self.parent.speedX, self.parent.speedY, self.parent.faction)
  table.insert(bullets, bullet)
  self.cooldownFrames = 100
end

table.insert(weaponConstructors, Fling)