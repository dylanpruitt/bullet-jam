require('weapons.weapon')

Shotgun = Weapon:new()

function Shotgun:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "Shotgun"
  weapon.speedCap = 6.5
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function Shotgun:onFire (cursorX, cursorY)
  self:spreadFire(cursorX, cursorY, ShotgunBullet, 60, 4)
  self.cooldownFrames = 75  
end

table.insert(weaponConstructors, Shotgun)