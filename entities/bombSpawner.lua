require('entities.basicAI')
require('entities.warningArea')

BombSpawner = BasicAI:new()

function BombSpawner:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Bomb Spawner"
  entity.faction = "enemy"
  entity.health = 50
  entity.maxHealth = 50
  entity.width = 10
  entity.height = 10
  entity.imagePath = "images/entities/bomb-spawner.png"
  entity.targetIndex = 1
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function BombSpawner:updateAI ()
  if self:getClosestTargetDistance() <= 150 and self.aiState == "idle" then
    self.targetIndex = self:getClosestTargetIndex()
    self:wait(seconds(1.0))
    self.aiState = "attack"
  end
  if self.aiState == "attack" then
    if self:getClosestTargetDistance() <= 150 then
      self:attackAI()
    else
      self.aiState = "idle" 
    end
  end
end
  
function BombSpawner:attackAI ()
  local targetIndex = self:getClosestTargetIndex()
  local target = entities[targetIndex]

  table.insert(entities, WarningArea:new(target:centerX() - 16, target:centerY() - 16))
  self:wait(seconds(3.5))
end

table.insert(entityConstructors, BombSpawner)