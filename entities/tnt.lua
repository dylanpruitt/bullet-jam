require('entities.base')
require('weapons.tnt')

TNTEntity = Entity:new()

function TNTEntity:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "TNT"
  entity.faction = "trap" .. (5 * x + y)
  entity.health = 100
  entity.maxHealth = 100
  entity.speedCap = 10
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/placeholder-tnt.png"
  entity.aiState = "idle"
  entity.aiGoalX = x
  entity.aiGoalY = y
  entity.framesIdle = 120
  entity.canBeSwitched = false
  entity.isValidTarget = false
  entity.equippedWeapon = TNT:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function TNTEntity:update ()
  self:updateAI()
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
end
  
function TNTEntity:updateAI ()
  if self.health < self.maxHealth then
    self.equippedWeapon:onFire(self.x - 8, self.y - 8)
    self.health = 0
  end
end
  
function TNTEntity:updatePosition ()
  local entityX = self.x
  local entityY = self.y
  local speedMagnitude = math.sqrt(math.pow(self.speedX, 2) + math.pow(self.speedY, 2))
  local collision = false
      
  self.x = self.x + self.speedX
      
  for i = 1, #boundingBoxes do
    if entityCollidingWithBounds(self, boundingBoxes[i]) then
      self.x = entityX
      self.speedX = 0
      collision = true
    end
  end
      
  self.y = self.y + self.speedY
      
  for i = 1, #boundingBoxes do
    if entityCollidingWithBounds(self, boundingBoxes[i]) then
      self.y = entityY
      self.speedY = 0
      collision = true
    end
  end
    
  if collision and speedMagnitude > 5 then
    self.equippedWeapon:onFire(self.x - 8, self.y - 8)
    self.health = 0
  end  
end

table.insert(entityConstructors, TNTEntity)