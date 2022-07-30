require('entities.base')
require('weapons.machineGun')

Autoturret = Entity:new()

function Autoturret:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Autoturret"
  entity.faction = "enemy"
  entity.health = 150
  entity.maxHealth = 150
  entity.speedCap = 3
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/autoturret.png"
  entity.targetIndex = 1
  entity.framesIdle = 120
  entity.equippedWeapon = MachineGun:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Autoturret:update ()
  if self.controlEnabled then
    self:updateAI()
  end
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
end

function Autoturret:updateAI ()
  if self:getClosestTargetDistance() <= 70 then
    self.targetIndex = self:getClosestTargetIndex()
    self:attackAI()
  end
end
  
function Autoturret:attackAI ()
  local target = entities[self.targetIndex]

  if self.equippedWeapon.cooldownFrames == 0 then
    self.equippedWeapon:onFire(target.x, target.y)
  end
end

table.insert(entityConstructors, Autoturret)