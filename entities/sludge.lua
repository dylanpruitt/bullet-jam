require('constants')
require('entities.basicAI')
require('weapons.sludge')

Sludge = BasicAI:new()

function Sludge:new (x, y)
  local entity             = BasicAI:new(x, y)
  entity.name              = "Sludge"
  entity.faction           = "enemy"
  entity.health            = 50
  entity.maxHealth         = 50
  entity.speedCap          = 0.2
  entity.width             = 12
  entity.height            = 11
  entity.imagePath         = "images/entities/sludge.png"
  entity.equippedWeapon    = SludgeWeapon:new(entity, seconds(4.0))
  entity.targetIndex       = 1
  entity.state             = "idle"
  setmetatable(entity, self) 
  self.__index = self
  return entity
end

function Sludge:updateAI ()
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

      self.targetIndex = self:getClosestTargetIndex()
      
      local entity = entities[self.targetIndex]
      if     entity.faction == "player" or distanceFromPlayer <= 75 then
        self.state = "chase"
        self:wait(50)
      elseif entity.faction == "enemy"  then
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
      
      table.insert(entities, SlimeTrap:new(self:centerX() - 8, self:centerY() - 8))
      self:wait(50)
      
      local targetDistance = math.sqrt(math.pow(self.x - target.x, 2) + math.pow(self.y - target.y, 2))

      if self.equippedWeapon.cooldownFrames == 0 then
        self.equippedWeapon:onFire(target.x, target.y)
        self.state = "idle"
        self:stop()
        self:wait(50)
      end  
    end
  end