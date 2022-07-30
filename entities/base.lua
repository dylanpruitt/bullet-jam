require('weapons.weapon')
require('constants')

Entity = {
  speedX         = 0,
  speedY         = 0,
  speedCap       = 0,
  health         = 1,
  maxHealth      = 1,
  controlEnabled = true,
  background     = false,
  canBeSwitched  = true,
  canBeDamaged   = true,
  canBeFlung     = true,
  isValidTarget  = true,
  statuses       = {},
}

function Entity:new (x, y)
  local entity = {
      x = x,
      y = y,
  }
  entity.equippedWeapon = Weapon:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end
  
function Entity:updatePosition ()
  local entityX = self.x
  local entityY = self.y
  
  self.x = self.x + self.speedX

  for i = 1, #boundingBoxes do
    if entityCollidingWithBounds(self, boundingBoxes[i]) then
      self.x = entityX
      self.speedX = 0
    end
  end

  self.y = self.y + self.speedY

  for i = 1, #boundingBoxes do
    if entityCollidingWithBounds(self, boundingBoxes[i]) then
      self.y = entityY
      self.speedY = 0
    end
  end
  
  if math.abs(self.speedX) <= 0.1 then
    self.speedX = 0 
  end
  if math.abs(self.speedY) <= 0.1 then
    self.speedY = 0 
  end
end

function Entity:updateSpeed ()
  if self.speedX > 0 then 
    self.speedX = self.speedX - 0.1 
  end
  if self.speedY > 0 then 
    self.speedY = self.speedY - 0.1 
  end
  if self.speedX < 0 then 
    self.speedX = self.speedX + 0.1 
  end
  if self.speedY < 0 then 
    self.speedY = self.speedY + 0.1 
  end
end

function Entity:collidingWith (object)
  return (((self.x < object.x and object.x < (self.x + self.width)) 
    or (self.x < (object.x + object.width) and (object.x + object.width) < (self.x + self.width)))
    and ((self.y < object.y and object.y < (self.y + self.height))
    or (self.y < (object.y + object.height) and (object.y + object.height) < (self.y + self.height))))
end

function Entity:getClosestTargetDistance ()
  local closestDistance = 10000
  for i = 1, #entities do
    distanceFromEntity = math.sqrt(math.pow(self.x - entities[i].x, 2) + math.pow(self.y - entities[i].y, 2))
    if distanceFromEntity < closestDistance and not entities[i]:isSelf(self) then
      if self:validTarget(entities[i]) then
        closestDistance = distanceFromEntity
      end
    end
  end
  return closestDistance
end

function Entity:getClosestTargetIndex ()
  local closestDistance = 10000; local targetIndex = NOT_FOUND
  for i = 1, #entities do
    distanceFromEntity = math.sqrt(math.pow(self.x - entities[i].x, 2) + math.pow(self.y - entities[i].y, 2))
    
    if distanceFromEntity < closestDistance and not entities[i]:isSelf(self) then
      if self:validTarget(entities[i]) then
        closestDistance = distanceFromEntity
        targetIndex = i
      end
    end
  end
  
  return targetIndex
end

function Entity:isSelf (entity)
  return (tostring(self) == tostring(entity))
end

function Entity:validTarget (entity)
  local normalCondition = entity.isValidTarget and self.faction ~= entity.faction
  local frenzyCondition = self:getStatusIndexByName("Frenzy") > NOT_FOUND and entity.canBeDamaged
  return normalCondition or frenzyCondition
end

function Entity:updateStatuses ()
  local temp = {}
  for i = 1, #self.statuses do
    if self.statuses[i].framesLeft > 0 then
      table.insert(temp, self.statuses[i])
      self.statuses[i]:update()
    else
      self.statuses[i]:onStatusEnd()
    end
  end

  self.statuses = temp
end

function Entity:getStatusIndexByName (name)
  for i = 1, #self.statuses do
    if self.statuses[i].name == name then
      return i
    end
  end

  return NOT_FOUND
end

function Entity:addStatus (status)
  local index = self:getStatusIndexByName(status.name)
  if index > NOT_FOUND then
    self.statuses[index].framesLeft = self.statuses[index].framesLeft + status.framesLeft
  else
    table.insert(self.statuses, status)
  end
end  

function Entity:centerX ()
  return self.x + self.width / 2
end

function Entity:centerY ()
  return self.y + self.height / 2
end

function Entity:draw ()
  local image = assets[self.imagePath]
  love.graphics.draw(image, self.x, self.y)
end