require('weapons.weapon')

MachineGun = Weapon:new()

function MachineGun:new (parent)
  local weapon    = Weapon:new(parent)
  weapon.name     = "Machine Gun"
  weapon.range    = 73
  weapon.speedCap = 4
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function MachineGun:onFire (cursorX, cursorY)
  local projectileSpeeds = self:getProjectileSpeed(cursorX, cursorY)
  local spawnX = self.parent.x + (self.parent.width / 2) - 1
  local spawnY = self.parent.y + (self.parent.height / 2) - 1
  local bullet = Bullet:new(spawnX, spawnY, projectileSpeeds[1], projectileSpeeds[2], self.parent.faction)
  table.insert(bullets, bullet)
  self.cooldownFrames = seconds(0.2) 
end

table.insert(weaponConstructors, MachineGun)