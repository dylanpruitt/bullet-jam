require('entities.base')
require('screenText')
require('table')

Spike = Entity:new()

function Spike:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Spike Trap"
  entity.faction = "trap"
  entity.health = 9000
  entity.maxHealth = 9000
  entity.background = true
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/spike.png"
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

function Spike:update ()
  local entitiesDamaged = false
  local ATTACK_DAMAGE = 5
  for i = 1, #entities do
    if self:collidingWith(entities[i]) and self.cooldown < 1 and entities[i].canBeDamaged then
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
end

table.insert(entityConstructors, Spike)