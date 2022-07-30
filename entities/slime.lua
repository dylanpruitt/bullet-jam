require('constants')
require('entities.basicAI')
require('entities.slimeTrap')

Slime = BasicAI:new()

function Slime:new (x, y)
  local entity             = BasicAI:new(x, y)
  entity.name              = "Slime"
  entity.faction           = "enemy"
  entity.health            = 50
  entity.maxHealth         = 50
  entity.speedCap          = 0.5
  entity.width             = 12
  entity.height            = 11
  entity.imagePath         = "images/entities/slime.png"
  entity.equippedWeapon    = Shotgun:new(entity)
  entity.targetIndex       = 1
  entity.state             = "idle"
  setmetatable(entity, self) 
  self.__index = self
  return entity
end

function Slime:updateAI ()
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
      
      local targetDistance = math.sqrt(math.pow(self.x - target.x, 2) + math.pow(self.y - target.y, 2))

      if self.equippedWeapon.cooldownFrames == 0 then
        self.equippedWeapon:onFire(target.x, target.y)
        self.state = "idle"
        self:stop()
        self:wait(50)
      end  
    end
  end