require('entities.base')
require('weapons.tnt')
require('utility')

TimeBomb = Entity:new()

function TimeBomb:new (x, y)
  local entity          = Entity:new(x, y)
  entity.name           = "Time Bomb"
  entity.faction        = "trap" .. (5 * x + y)
  entity.health         = 100
  entity.maxHealth      = 100
  entity.speedCap       = 10
  entity.width          = 16
  entity.height         = 16
  entity.imagePath      = "images/entities/time_bomb_0.png"
  entity.framesLeft     = seconds(5.0)
  entity.animationFrame = 0
  entity.switchFPS      = 2
  entity.canBeSwitched  = false
  entity.isValidTarget  = false
  entity.equippedWeapon = TNT:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function TimeBomb:update ()
  self:updateAI()
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
end
  
function TimeBomb:updateAI ()
  if self.health < self.maxHealth or self.framesLeft < 1 then
    local targetIndex = self:getClosestTargetIndex()
    local target = entities[targetIndex]

    self.equippedWeapon:onFire(self.x - 8, self.y - 8)
    self.health = 0
  end
  
  self.framesLeft = self.framesLeft - 1
  if (self.framesLeft % math.floor(50 / self.switchFPS)) == 0 then
    self.animationFrame = 1 - self.animationFrame
    self.imagePath = "images/entities/time_bomb_" .. self.animationFrame .. ".png"
  end
  if self.framesLeft % 50 == 0 then
    self.switchFPS = self.switchFPS + 1
  end
end
  
function TimeBomb:updatePosition ()
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
