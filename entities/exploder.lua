require('entities.basicAI')
require('weapons.tnt')

Exploder = BasicAI:new()

function Exploder:new (x, y)
  local entity = BasicAI:new(x, y)
  entity.name           = "Exploder"
  entity.faction        = "enemy"
  entity.health         = 100
  entity.maxHealth      = 100
  entity.speedCap       = 0.4
  entity.width          = 16
  entity.height         = 16
  entity.imagePath      = "images/entities/exploder_0.png"
  entity.framesLeft     = seconds(5.0)
  entity.animationOn    = false
  entity.animationFrame = 0
  entity.switchFPS      = 2
  entity.equippedWeapon = TNT:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Exploder:updateAI ()
  self.targetIndex = self:getClosestTargetIndex()
  local targetDistance = self:getClosestTargetDistance()
  
  if self.aiState == "idle" then
    self:idleAI()
  end
  
  if self.aiState == "chase" then
    self:chaseAI()
  end

  if math.abs(self.x - self.aiGoalX) <= 1 then
    self.x = self.aiGoalX 
    self.speedX = 0
  end
  if math.abs(self.y - self.aiGoalY) <= 1 then 
    self.y = self.aiGoalY 
    self.speedY = 0
  end
  
  self.framesLeft = self.framesLeft - 1
  if (self.framesLeft % math.floor(50 / self.switchFPS)) == 0 and self.animationOn then
    self.animationFrame = 1 - self.animationFrame
    self.imagePath = "images/entities/exploder_" .. self.animationFrame .. ".png"
  end
  
  if self.health < self.maxHealth then
    local targetIndex = self:getClosestTargetIndex()
    local target = entities[targetIndex]

    self.equippedWeapon:onFire(target.x, target.y)
    self.health = 0
  end
end

function Exploder:idleAI ()     
  if self.aiGoalX == 0 or self.aiGoalY == 0 
    or (self.x == self.aiGoalX and self.y == self.aiGoalY) then     
    if self.x == self.aiGoalX and self.y == self.aiGoalY then
      self.cooldown = self.cooldown + 1
    end
    if self.cooldown == 150 then
      self.aiGoalX = math.floor((math.random() * 60) - 30 + self.x)
      self.aiGoalY = math.floor((math.random() * 60) - 30 + self.y)
      self.framesIdle = 0
    end
  end
  
  local targetDistance = self:getClosestTargetDistance()
  if targetDistance <= 70 then
    self.aiState     = "chase"
    self.animationOn = true
  end
 
  if self.switchFPS > 2 and self.framesLeft % 50 == 0 then
    self.switchFPS = self.switchFPS - 1
    if self.switchFPS == 2 then
      self.animationOn = false
    end
    
    if self.framesLeft == 0 then
      self.framesLeft = seconds(5.0)
    end
  end
end

function Exploder:chaseAI ()
  if self:getClosestTargetDistance() >= 70 then
    self.animationOn = false
    self.aiState     = "idle"
    self.framesLeft  = seconds(5.0)
  end

  local target = entities[self.targetIndex]
  self.aiGoalX = target.x
  self.aiGoalY = target.y

  if self.x > self.aiGoalX then self.speedX = -(self.speedCap + self.switchFPS * 0.1) end
  if self.y > self.aiGoalY then self.speedY = -(self.speedCap + self.switchFPS * 0.1) end
  if self.x < self.aiGoalX then self.speedX = (self.speedCap + self.switchFPS * 0.1) end
  if self.y < self.aiGoalY then self.speedY = (self.speedCap + self.switchFPS * 0.1) end
  
  if self.framesLeft % 50 == 0 then
    print(self.switchFPS)
    self.switchFPS = self.switchFPS + 1
    if self.framesLeft == 0 then
      self.equippedWeapon:onFire(target.x, target.y)
      self.health = 0
    end
  end
end

table.insert(entityConstructors, Exploder)