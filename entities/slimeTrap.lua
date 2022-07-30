require('entities.base')
require('statuses.slow')
require('table')

SlimeTrap = Entity:new()

function SlimeTrap:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Slime Trap"
  entity.faction = "enemy"
  entity.health = 200
  entity.maxHealth = 200
  entity.background = true
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/slime-trap.png"
  entity.targetIndex = 1
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.canBeFlung = false
  entity.isValidTarget = false
  entity.cooldown = 0
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function SlimeTrap:update ()
  for i = 1, #entities do
    if self:collidingWith(entities[i]) and entities[i].faction ~= self.faction and self.cooldown == 0 then
      local status = SlowStatus:new(entities[i], seconds(3), self.parentSpeedX, self.parentSpeedY)
      entities[i]:addStatus(status)
      self.cooldown = seconds(4.0)
    end
  end
  
  if self.cooldown > 0 then self.cooldown = self.cooldown - 1 end
  
  self.health = self.health - 1
end

table.insert(entityConstructors, SlimeTrap)