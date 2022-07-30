require('entities.base')
require('map')
require('table')

Tree = Entity:new()

function Tree:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Tree"
  entity.faction = "none"
  entity.health = 80
  entity.maxHealth = 80
  entity.width = 17
  entity.height = 16
  entity.imagePath = "images/entities/white-tree.png"
  entity.targetIndex = 1
  entity.canBeSwitched = false
  entity.isValidTarget = false
  entity.cooldown = 0
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Tree:update () end

table.insert(entityConstructors, Tree)