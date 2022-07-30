require('constants')
require('entities.basicAI')
require('weapons.fling')
require('weapons.shotgun')

Vampire = BasicAI:new()

function Vampire:new (x, y)
  local entity             = BasicAI:new(x, y)
  entity.name              = "Vampire"
  entity.faction           = "vampire"
  entity.health            = 160
  entity.maxHealth         = 160
  entity.speedCap          = 1.6
  entity.width             = 24
  entity.height            = 24
  entity.imagePath         = "images/entities/armor.png"
  entity.equippedWeapon    = Shotgun:new(entity)
  entity.equippedSecondary = Fling:new(entity)
  entity.activated         = false
  entity.targetIndex       = 1
  entity.state             = "idle"
  setmetatable(entity, self) 
  self.__index = self
  return entity
end

function Vampire:update ()
  if self.controlEnabled then
    if self.cooldown < 1 then
      self:updateAI()
    else
      self.cooldown = self.cooldown - 1
    end
  end
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
  self.equippedSecondary:update()
end

function Vampire:updateAI ()
  if not self.activated then
    local distanceFromPlayer = math.sqrt(math.pow(self.x - player.x, 2) + math.pow(self.y - player.y, 2))
    if distanceFromPlayer <= 125 then
      self.activated = true
    end
  else
    if math.abs(self.x - self.aiGoalX) <= 1 then
      self.x = self.aiGoalX 
      self.speedX = 0
    end
    if math.abs(self.y - self.aiGoalY) <= 1 then 
      self.y = self.aiGoalY 
      self.speedY = 0
    end  
  
    if self.state == "idle" then
      local distanceFromPlayer = math.sqrt(math.pow(self.x - player.x, 2) + math.pow(self.y - player.y, 2))

      self.targetIndex = self:getClosestEntityIndex()
      
      local entity = entities[self.targetIndex]
      if     entity.faction == "player" or distanceFromPlayer <= 75 then
        self.state = "chase"
        self:wait(50)
      elseif entity.faction == "enemy"  then
        self.state = "flingEnemy"
        self:wait(50)
      end
    end
    
    if self.state == "flingEnemy" then
      local target = entities[self.targetIndex]
      self.aiGoalX = target.x
      self.aiGoalY = target.y

      if self.x > self.aiGoalX then self.speedX = -self.speedCap end
      if self.y > self.aiGoalY then self.speedY = -self.speedCap end
      if self.x < self.aiGoalX then self.speedX = self.speedCap end
      if self.y < self.aiGoalY then self.speedY = self.speedCap end

      local targetDistance = math.sqrt(math.pow(self.x - target.x, 2) + math.pow(self.y - target.y, 2))
      if self.equippedSecondary.cooldownFrames == 0 and targetDistance <= 75 then
        self.equippedSecondary:onFire(target.x, target.y)
        self:setFlingDirection(target)
        self.state = "idle"
        self:wait(50)
      end
      
      local distanceFromPlayer = math.sqrt(math.pow(self.x - player.x, 2) + math.pow(self.y - player.y, 2))
      if distanceFromPlayer <= 75 then
        self.state = "chase"
        self:wait(50)
      end
    end
    
    if self.state == "chase" then
      local target = entities[self.targetIndex]
      self.aiGoalX = target.x
      self.aiGoalY = target.y

      if self.x > self.aiGoalX then self.speedX = -self.speedCap end
      if self.y > self.aiGoalY then self.speedY = -self.speedCap end
      if self.x < self.aiGoalX then self.speedX = self.speedCap end
      if self.y < self.aiGoalY then self.speedY = self.speedCap end
      
      local targetDistance = math.sqrt(math.pow(self.x - target.x, 2) + math.pow(self.y - target.y, 2))
      if self.equippedSecondary.cooldownFrames == 0 and targetDistance <= 75 then
        self.equippedSecondary:onFire(target.x, target.y)
        self.equippedWeapon.cooldownFrames = self.equippedWeapon.cooldownFrames + 25
        self.speedX = self.speedX * -1
        self.speedX = self.speedY * -1
        self:setFlingDirection(target)
        self:wait(50)
      end  
      if self.equippedWeapon.cooldownFrames == 0 and targetDistance <= 30 then
        self.equippedWeapon:onFire(target.x, target.y)
        self.state = "idle"
        self:wait(50)
      end  
    end
  end
end

function Vampire:getClosestEntityIndex ()
  local closestDistance = 10000; closestIndex = NOT_FOUND
  for i = 1, #entities do
    local distanceFromEntity = math.sqrt(math.pow(self.x - entities[i].x, 2) + math.pow(self.y - entities[i].y, 2))
    if distanceFromEntity < closestDistance and not entities[i]:isSelf(self) and entities[i].isValidTarget then
      closestDistance = distanceFromEntity
      closestIndex    = i
    end
  end
  
  return closestIndex
end

function Vampire:setFlingDirection (target)
  local xDistance = target.x - self:centerX()
  local yDistance = target.y - self:centerY()
  local angle = math.atan(yDistance / xDistance)
  
  self.speedX = self.speedCap * math.cos(angle)
  self.speedY = self.speedCap * math.sin(angle)
  if xDistance < 0 then
    self.speedX = self.speedX * -1 
    self.speedY = self.speedY * -1
  end
end