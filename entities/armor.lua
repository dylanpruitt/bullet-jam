require('entities.basicAI')
require('weapons.shotgun')

Armor = BasicAI:new()

function Armor:new (x, y)
  local entity = BasicAI:new(x, y)
  entity.name = "Armor"
  entity.faction = "enemy"
  entity.health = 240
  entity.maxHealth = 240
  entity.speedCap = 0.8
  entity.width = 24
  entity.height = 24
  entity.imagePath = "images/entities/armor.png"
  entity.equippedWeapon = Shotgun:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Armor:updateAI ()
  self.targetIndex = self:getClosestTargetIndex()
  local targetDistance = self:getClosestTargetDistance()
  if targetDistance > 90 then
    self:idleAI()
  else
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
end

function Armor:idleAI ()
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
 
  if self.x > self.aiGoalX then self.speedX = -self.speedCap * 0.80 end
  if self.y > self.aiGoalY then self.speedY = -self.speedCap * 0.80 end
  if self.x < self.aiGoalX then self.speedX = self.speedCap * 0.80 end
  if self.y < self.aiGoalY then self.speedY = self.speedCap * 0.80 end
end

function Armor:chaseAI ()
  local target = entities[self.targetIndex]
  self.aiGoalX = target.x
  self.aiGoalY = target.y

  if self.x > self.aiGoalX then self.speedX = -self.speedCap end
  if self.y > self.aiGoalY then self.speedY = -self.speedCap end
  if self.x < self.aiGoalX then self.speedX = self.speedCap end
  if self.y < self.aiGoalY then self.speedY = self.speedCap end

  if self.equippedWeapon.cooldownFrames == 0 then
    self.equippedWeapon:onFire(target.x, target.y)
  end  
end