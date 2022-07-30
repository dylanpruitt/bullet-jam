require('entities.basicAI')
require('entities.gasCloud')

PoisonVent = BasicAI:new()

function PoisonVent:new (x, y)
  local entity = BasicAI:new(x, y)
  entity.name = "Gas Vent"
  entity.faction = "none"
  entity.health = 9000
  entity.maxHealth = 9000
  entity.background = true
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/vent.png"
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.canBeFlung = false
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function PoisonVent:updateAI ()
  table.insert(entities, GasCloud:new(self.x, self.y))
  self:wait(250)
end