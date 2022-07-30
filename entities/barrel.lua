require('entities.basicAI')
require('weapons.shotgun')

Barrel = Entity:new()

function Barrel:new (x, y)
  local entity = BasicAI:new(x, y)
  entity.name = "Barrel"
  entity.faction = "none"
  entity.health = 20
  entity.maxHealth = 20
  entity.speedCap = 0.8
  entity.width = 13
  entity.height = 15
  entity.imagePath = "images/entities/barrel.png"
  entity.isValidTarget = false
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Barrel:update ()
  self:updatePosition()
  self:updateStatuses()
end

table.insert(entityConstructors, Barrel)