require('entities.base')
require('screenText')
require('table')

GasCloud = Entity:new()

function GasCloud:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Gas Cloud"
  entity.faction = "neutral"
  entity.health = 9000
  entity.maxHealth = 9000
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/poison.png"
  entity.targetIndex = 1
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.cooldown = 0
  entity.framesLeft = 350
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function GasCloud:update ()
  self.framesLeft = self.framesLeft - 1
  
  if self.framesLeft == 0 then
    self.health = 0
  end
  
  local entitiesDamaged = false
  local ATTACK_DAMAGE = 5
  for i = 1, #entities do
    if self:collidingWith(entities[i]) and self.cooldown < 1 then
      entitiesDamaged = true
      entities[i].health = entities[i].health - ATTACK_DAMAGE
      addDamageText(ATTACK_DAMAGE, self.x + math.random() * 20 - 10, self.y, entities[i])
    end
  end

  if entitiesDamaged then
    self.cooldown = 25
  else
    self.cooldown = self.cooldown - 1
  end
  
  self:updatePosition()
  self:updateStatuses()
end
