require('entities.base')
require('map')
require('table')

Column = Entity:new()

function Column:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Column"
  entity.faction = "none"
  entity.health = 50
  entity.maxHealth = 50
  entity.width = 16
  entity.height = 32
  entity.imagePath = "images/entities/column.png"
  entity.targetIndex = 1
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.canBeFlung = false
  entity.isValidTarget = false
  entity.cooldown = 0
  
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Column:update () end

table.insert(entityConstructors, Column)