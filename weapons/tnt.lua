require('weapons.weapon')

TNT = Weapon:new()

function TNT:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "TNT"
  weapon.range = 40
  weapon.speedCap = 7
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function TNT:onFire (cursorX, cursorY)
  table.insert(entities, Explosion:new(cursorX, cursorY))
end

table.insert(weaponConstructors, TNT)