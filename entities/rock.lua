require('entities.base')
require('map')
require('table')

Rock = Entity:new()

function Rock:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Rock"
  entity.faction = "none"
  entity.health = 50
  entity.maxHealth = 50
  entity.width = 22
  entity.height = 20
  entity.imagePath = "images/entities/rock.png"
  entity.targetIndex = 1
  entity.canBeSwitched = false
  entity.isValidTarget = false
  entity.cooldown = 0
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Rock:update () end

table.insert(entityConstructors, Rock)