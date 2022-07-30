require('entities.base')
require('screenText')
require('table')
require('constants')

Portal = Entity:new()

function Portal:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Portal"
  entity.faction = "none"
  entity.health = 9000
  entity.maxHealth = 9000
  entity.width = 15
  entity.height = 15
  entity.imagePath = "images/entities/portal.png"
  entity.targetIndex = 1
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.isValidTarget = false
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Portal:update ()
  self:updatePosition()
  self:updateStatuses()
end

function Portal:transferObject (object)
  local targetIndex = self:getClosestPortal()
  
  if targetIndex ~= NOT_FOUND and not object.transferred then
    local target = entities[targetIndex]
    object.x = target.x + (target.width - object.width) / 2
    object.y = target.y + (target.height - object.height) / 2
    object.speedX = object.speedX * 2
    object.speedY = object.speedY * 2
    object.transferred = true
  end
end

function Portal:getClosestPortal ()
  local closestDistance = 10000
  local closestIndex = NOT_FOUND
  for i = 1, #entities do
    distanceFromEntity = math.sqrt(math.pow(self.x - entities[i].x, 2) + math.pow(self.y - entities[i].y, 2))
    if entities[i].name == "Portal" and distanceFromEntity < closestDistance and distanceFromEntity > 0 then
      closestIndex = i
    end
  end
  return closestIndex
end


table.insert(entityConstructors, Portal)