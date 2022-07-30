require('weapons.weapon')
require('entities.forcefield')

ForceFieldWeapon = Weapon:new()

function ForceFieldWeapon:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "Forcefield"
  weapon.range = 10000
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function ForceFieldWeapon:onFire (cursorX, cursorY)
  table.insert(entities, ForceField:new(self.parent.x, self.parent.y, self.parent))

  self.cooldownFrames = 250
end

table.insert(weaponConstructors, ForceFieldWeapon)