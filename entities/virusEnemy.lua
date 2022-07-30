require('entities.basicAI')
require('weapons.weapon')
require('utility')

Virus = BasicAI:new()

function Virus:new (x, y)
  local entity = BasicAI:new(x, y)
  entity.name = "Virus"
  entity.faction = "enemy"
  entity.health = 5
  entity.maxHealth = 5
  entity.speedCap = 2
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/bullets/health-bullet.png"
  entity.targetIndex = 1
  entity.framesIdle = 120
  entity.spawnCooldown = seconds(5.0)
  entity.equippedWeapon = Weapon:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Virus:update ()
  if self.controlEnabled then
    self:updateAI()
    self.spawnCooldown = self.spawnCooldown - 1
  end
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
end

function Virus:updateAI ()
  if self:getClosestTargetDistance() <= 70 then
    self.targetIndex = self:getClosestTargetIndex()
    self:attackAI()
  end
  
  if self.spawnCooldown <= 0 then
    table.insert(entities, Virus:new(self.x, self.y))
    self.spawnCooldown = seconds(5.0)
    self.aiGoalX = self.aiGoalX + math.random(0, 100) - 50
    self.aiGoalY = self.aiGoalY + math.random(0, 100) - 50
  end
  
  if self.x > self.aiGoalX then self.speedX = -self.speedCap * 0.80 end
  if self.y > self.aiGoalY then self.speedY = -self.speedCap * 0.80 end
  if self.x < self.aiGoalX then self.speedX = self.speedCap * 0.80 end
  if self.y < self.aiGoalY then self.speedY = self.speedCap * 0.80 end
  
  if math.abs(self.x - self.aiGoalX) <= 1 then
    self.x = self.aiGoalX 
    self.speedX = 0
  end
  if math.abs(self.y - self.aiGoalY) <= 1 then 
    self.y = self.aiGoalY 
    self.speedY = 0
  end  
end
  
function Virus:attackAI ()
  local target = entities[self.targetIndex]

  if self.equippedWeapon.cooldownFrames == 0 then
    self.equippedWeapon:onFire(target.x, target.y)
  end
end
