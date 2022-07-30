require('entities.base')

Sheep = Entity:new()

function Sheep:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Sheep"
  entity.faction = "neutral"
  entity.health = 35
  entity.maxHealth = 35
  entity.speedCap = 1.2
  entity.width = 12
  entity.height = 12
  entity.imagePath = "images/entities/sheep.png"
  entity.aiState = "idle"
  entity.aiGoalX = x
  entity.aiGoalY = y
  entity.targetIndex = 1
  entity.framesIdle = 120
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Sheep:update ()
  if self.controlEnabled then
    self:updateAI()
  end
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
end

function Sheep:updateAI ()
  if self:getClosestTargetDistance() > 80 then
    self:idleAI()
  else
    self:panicAI()
  end

  if math.abs(self.x - self.aiGoalX) <= 1 then 
    self.x = self.aiGoalX 
    self.speedX = 0
  end
  if math.abs(self.y - self.aiGoalY) <= 1 then
    self.y = self.aiGoalY 
    self.speedY = 0
  end
end
  
function Sheep:idleAI ()
  if self.aiGoalX == 0 or self.aiGoalY == 0 
    or (self.x == self.aiGoalX and self.y == self.aiGoalY) then     
    if self.x == self.aiGoalX and self.y == self.aiGoalY then
      self.framesIdle = self.framesIdle + 1
    end
    if self.framesIdle == 150 then
      self.aiGoalX = math.floor((math.random() * 60) - 30 + self.x)
      self.aiGoalY = math.floor((math.random() * 60) - 30 + self.y)
      self.framesIdle = 0
    end
  end
 
  if self.x > self.aiGoalX then self.speedX = -self.speedCap * 0.80 end
  if self.y > self.aiGoalY then self.speedY = -self.speedCap * 0.80 end
  if self.x < self.aiGoalX then self.speedX = self.speedCap * 0.80 end
  if self.y < self.aiGoalY then self.speedY = self.speedCap * 0.80 end
end
  
function Sheep:panicAI ()
  local target = entities[self.targetIndex]
  if self.x > target.x then self.speedX = self.speedCap end
  if self.y > target.y then self.speedY = self.speedCap end
  if self.x < target.x then self.speedX = -self.speedCap end
  if self.y < target.y then self.speedY = -self.speedCap end

  self.aiGoalX = self.x + self.speedX
  self.aiGoalY = self.y + self.speedY
end