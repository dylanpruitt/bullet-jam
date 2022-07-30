require('entities.base')
require('weapons.shotgun')
require('weapons.magnesis')

MagnetTurret = Entity:new()

function MagnetTurret:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Magnet Tower"
  entity.faction = "enemy"
  entity.health = 180
  entity.maxHealth = 180
  entity.speedCap = 3
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/magnesis-tower.png"
  entity.targetIndex = 1
  entity.framesIdle = 120
  entity.equippedWeapon = Shotgun:new(entity)
  entity.magnesis = Magnesis:new(entity)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function MagnetTurret:update ()
  if self.controlEnabled then
    self:updateAI()
  end
  self:updatePosition()
  self:updateStatuses()
  self.equippedWeapon:update()
  self.magnesis:update()
end

function MagnetTurret:updateAI ()
  if self:getClosestTargetDistance() <= 70 then
    self.targetIndex = self:getClosestTargetIndex()
    self:attackAI()
  end
  
  if self.magnesis.cooldownFrames == 0 then 
    self.magnesis:onFire(0, 0)
  end
end
  
function MagnetTurret:attackAI ()
  local target = entities[self.targetIndex]

  if self.equippedWeapon.cooldownFrames == 0 then
    self.equippedWeapon:onFire(target.x, target.y)
  end
end
