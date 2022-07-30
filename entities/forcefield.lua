require('entities.base')

ForceField = Entity:new()

function ForceField:new (x, y, parent)
  local entity = Entity:new(x, y)
  entity.name = "Forcefield"
  entity.parent = parent
  if parent ~= nil then entity.faction = parent.faction end
  entity.health = 1500
  entity.maxHealth = 1500
  entity.speedCap = 0.0
  entity.width = 32
  entity.height = 32
  entity.imagePath = "images/entities/forcefield.png"
  entity.framesLeft = seconds(3.0)
  entity.isValidTarget = false
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function ForceField:update ()
  self:updatePosition()
  self:updateSpeed()
  self:updateStatuses()
  self.framesLeft = self.framesLeft - 1
  if self.framesLeft == 0 then
    self.health = 0
  end
end

function ForceField:collidingWith (object)
  local objectDistance = math.sqrt((self:centerX() - object.x) ^ 2 + ((self:centerY() - object.y) ^ 2))
  return objectDistance > 14 and objectDistance < 18 
end

table.insert(entityConstructors, ForceField)