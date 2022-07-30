require('weapons.weapon')
require('bullets.frenzyBullet')

Frenzy = Weapon:new()

function Frenzy:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "Frenzy"
  weapon.range = 73
  weapon.speedCap = 6
  weapon.iconPath = "images/icons/frenzy_icon.png"
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function Frenzy:onFire (cursorX, cursorY)
  local projectileSpeeds = self:getProjectileSpeed(cursorX, cursorY)
  local spawnX = self.parent.x + (self.parent.width / 2) - 1
  local spawnY = self.parent.y + (self.parent.height / 2) - 1
  local bullet = FrenzyBullet:new(spawnX, spawnY, projectileSpeeds[1], projectileSpeeds[2], self.parent.faction)
  table.insert(bullets, bullet)
  self.cooldownFrames = 150
end

table.insert(weaponConstructors, Frenzy)