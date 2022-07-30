require('weapons.weapon')
require('statuses.magnesis')

Magnesis = Weapon:new()

function Magnesis:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "Magnesis"
  weapon.range = 1
  weapon.speedCap = 6
  weapon.iconPath = "images/icons/magnesis_icon.png"
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function Magnesis:onFire (cursorX, cursorY) end

function Magnesis:onHold (cursorX, cursorY)
  self.parent:addStatus(MagnesisStatus:new(self.parent, 1))
  self.activeFrames = 5
end

table.insert(weaponConstructors, Magnesis)