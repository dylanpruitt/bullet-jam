require('constants')
require('entities.basicAI')
require('weapons.fling')
require('statuses.disable')
require('utility')

Repulsor = BasicAI:new()
local RANGE = 50

function Repulsor:new (x, y)
  local entity             = BasicAI:new(x, y)
  entity.name              = "Repulsor"
  entity.faction           = "neutral"
  entity.health            = 150
  entity.maxHealth         = 150
  entity.speedCap          = 3.0
  entity.width             = 16
  entity.height            = 16
  entity.imagePath         = "images/entities/repulsor.png"
  entity.equippedWeapon    = Fling:new(entity)
  entity.isValidTarget     = false
  entity.state             = "idle"
  setmetatable(entity, self) 
  self.__index = self
  return entity
end

function Repulsor:updateAI ()
  local distanceFromPlayer = math.sqrt(math.pow(self.x - entities[1].x, 2) + math.pow(self.y - entities[1].y, 2))
  if distanceFromPlayer >= 300 then
    self:wait(seconds(0.5))
    return
  end
  
  if self.state == "idle" then
    if self:inRangeOfEntities() then
      self.state     = "fling"
      self.imagePath = "images/entities/repulsor_charging.png"
      self:wait(seconds(1.0))
    end
  elseif self.state == "fling" then
    if self:inRangeOfEntities() then
      for i = 1, #entities do
        local distanceFromEntity = math.sqrt(math.pow(self.x - entities[i].x, 2) + math.pow(self.y - entities[i].y, 2))
        if distanceFromEntity < RANGE and not entities[i]:isSelf(self) and entities[i].canBeFlung then
          local flingVelocity = self:getFlingVelocity(entities[i])
          
          entities[i]:addStatus(DisableStatus:new(entities[i], seconds(1.5), flingVelocity[1], flingVelocity[2]))
        end
      end
      self.state = "idle"
      self.imagePath = "images/entities/repulsor.png"
      self:wait(seconds(3.0))
    else
      self.state = "idle"
      self.imagePath = "images/entities/repulsor.png"
    end
  end
end

function Repulsor:inRangeOfEntities ()
  for i = 1, #entities do
    local distanceFromEntity = math.sqrt(math.pow(self.x - entities[i].x, 2) + math.pow(self.y - entities[i].y, 2))
    if distanceFromEntity < RANGE and not entities[i]:isSelf(self) then
      return true
    end
  end
  return false
end

function Repulsor:getFlingVelocity (target)
  local xDistance = target:centerX() - self:centerX()
  local yDistance = target:centerY() - self:centerY()
  local angle = math.atan(yDistance / xDistance)
  
  local velocity = {}
  table.insert(velocity, self.speedCap * math.cos(angle))
  table.insert(velocity, self.speedCap * math.sin(angle))
  
  if xDistance < 0 then
    velocity[1] = velocity[1] * -1 
    velocity[2] = velocity[2] * -1
  end
  return velocity
end

table.insert(entityConstructors, Repulsor)