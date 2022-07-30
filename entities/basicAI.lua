require('entities.base')

BasicAI = Entity:new()

function BasicAI:new (x, y)
  local entity = Entity:new(x, y)
  entity.aiState    = "idle"
  entity.isThinking = true
  entity.aiGoalX = x
  entity.aiGoalY = y
  entity.targetIndex = 1
  entity.cooldown = 0
  entity.timeOnState = 0
  entity.extraWeapons = {}
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function BasicAI:update ()
  if self.controlEnabled then
    if self.isThinking then
      self:think()
    end
    if self.cooldown < 1 then
      self:updateAI()
    else
      self.cooldown = self.cooldown - 1
    end
  end
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
  for i = 1, #self.extraWeapons do
    self.extraWeapons[i]:update()
  end
  
  self.timeOnState = self.timeOnState + 1
end

function BasicAI:updateAI () end

function BasicAI:think () end

function BasicAI:moveTo (x, y)
  local xDistance = x - self:centerX()
  local yDistance = y - self:centerY()
  local angle = math.atan(yDistance / xDistance)
  
  local xSpeed = self.speedCap * math.cos(angle)
  local ySpeed = self.speedCap * math.sin(angle)
  if xDistance < 0 then
    xSpeed = xSpeed * -1 
    ySpeed = ySpeed * -1
  end
  
  self.speedX = xSpeed
  self.speedY = ySpeed
end

function BasicAI:stop ()
  self.speedX = 0
  self.speedY = 0
end

function BasicAI:setTargetPosition (x, y)
  self.aiGoalX = x
  self.aiGoalY = y
end

function BasicAI:wait (frames)
  self.cooldown = frames
end
