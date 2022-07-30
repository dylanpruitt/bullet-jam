require('entities.base')
require('entities.explosion')

WarningArea = Entity:new()

function WarningArea:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Warning Area"
  entity.faction = "trap"
  entity.background = true
  entity.width = 32
  entity.height = 32
  entity.imagePath = "images/entities/warning-area.png"
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.canBeFlung = false
  entity.isValidTarget = false
  entity.framesLeft     = seconds(1.0)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function WarningArea:update ()
  self.framesLeft = self.framesLeft - 1
  
  if self.framesLeft == 0 then
    self.health = 0
    table.insert(entities, Explosion:new(self.x, self.y))
  end
end

table.insert(entityConstructors, WarningArea)