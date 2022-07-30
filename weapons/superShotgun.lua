require('weapons.shotgun')

SuperShotgun = Shotgun:new()

function SuperShotgun:new (parent)
  local weapon = Shotgun:new(parent)
  weapon.name = "Shotgun"
  weapon.speedCap = 6.5
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function SuperShotgun:onFire (cursorX, cursorY)
  self:spreadFire(cursorX, cursorY, ShotgunBullet, 30, 6)
  self.cooldownFrames = 50  
end

table.insert(weaponConstructors, SuperShotgun)