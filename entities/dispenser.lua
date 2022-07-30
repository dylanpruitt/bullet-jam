require('entities.base')
require('weapons.dispenserWeapon')

HealthDispenser = Entity:new()

function HealthDispenser:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Health Dispenser"
  entity.faction = "none"
  entity.health = 180
  entity.maxHealth = 180
  entity.speedCap = 3
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/health-dispenser.png"
  entity.targetIndex = 1
  entity.framesIdle = 120
  entity.equippedWeapon = DispenserWeapon:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function HealthDispenser:update ()
  if self.controlEnabled then
    self:updateAI()
  end
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
end

function HealthDispenser:updateAI ()
  if self:getClosestTargetDistance() <= 70 then
    self.targetIndex = self:getClosestTargetIndex()
    self:attackAI()
  end
end
  
function HealthDispenser:attackAI ()
  local target = entities[self.targetIndex]

  if self.equippedWeapon.cooldownFrames == 0 then
    self.equippedWeapon:onFire(target.x, target.y)
  end
end
