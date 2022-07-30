require('entities.base')
require('screenText')
require('table')

Explosion = Entity:new()

function Explosion:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Explosion"
  entity.faction = "trap"
  entity.health = 9000
  entity.maxHealth = 9000
  entity.background = true
  entity.width = 32
  entity.height = 32
  entity.imagePath = "images/entities/explosion.png"
  entity.targetIndex = 1
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.canBeFlung = false
  entity.isValidTarget = false
  entity.cooldown = 0
  entity.framesLeft     = seconds(1.0)
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Explosion:update ()
  local entitiesDamaged   = false
  local ATTACK_DAMAGE     = 5
  local DAMAGE_MULTIPLIER = math.ceil(self.framesLeft / 5)
  for i = 1, #entities do
    if self:collidingWith(entities[i]) and self.cooldown < 1 and entities[i].canBeDamaged then
      entitiesDamaged = true
      entities[i].health = entities[i].health - ATTACK_DAMAGE * DAMAGE_MULTIPLIER
      addDamageText(ATTACK_DAMAGE * DAMAGE_MULTIPLIER, self.x + math.random() * 20 - 10, self.y, entities[i])
    end
  end

  if entitiesDamaged then
    self.cooldown = 10
  else
    self.cooldown = self.cooldown - 1
  end
  
  self.framesLeft = self.framesLeft - 1
  
  if self.framesLeft == 0 then
    self.health = 0
  end
end

function Explosion:draw ()
  local image         = assets[self.imagePath]
  local frameIndex    = math.floor((50 - self.framesLeft) / 5)
  local currentFrame  = love.graphics.newQuad(0, frameIndex * 32, 32, 32, image:getDimensions())
  love.graphics.draw(image, currentFrame, self.x, self.y)
end