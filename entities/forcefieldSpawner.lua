require('entities.basicAI')
require('entities.forcefield')
require('entities.warningArea')

FFSpawner = BasicAI:new()

function FFSpawner:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Forcefield Spawner"
  entity.faction = "none"
  entity.health = 50
  entity.maxHealth = 50
  entity.width = 10
  entity.height = 10
  entity.imagePath = "images/entities/forcefield-spawner.png"
  entity.targetIndex = 1
  entity.isValidTarget = false
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function FFSpawner:updateAI ()
  if self:getClosestTargetDistance() <= 70 and self.aiState == "idle" then
    self.targetIndex = self:getClosestTargetIndex()
    self:wait(seconds(1.0))
    self.aiState = "attack"
  end
  if self.aiState == "attack" then
    if self:getClosestTargetDistance() <= 70 then
      self:attackAI()
    else
      self.aiState = "idle" 
    end
  end
end
  
function FFSpawner:attackAI ()
  local targetIndex = self:getClosestTargetIndex()
  local target = entities[targetIndex]

  table.insert(entities, ForceField:new(target:centerX() - 16, target:centerY() - 16, target))
  self:wait(seconds(5.0))
end

table.insert(entityConstructors, FFSpawner)