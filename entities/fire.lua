require('entities.base')
require('table')

Fire = Entity:new()

function Fire:new (x, y)
  local entity = Entity:new(x, y)
  entity.name = "Fire"
  entity.faction = "none"
  entity.health = 50
  entity.maxHealth = 50
  entity.background = true
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/fire.png"
  entity.canBeSwitched = false
  entity.canBeDamaged = false
  entity.isValidTarget = false
  entity.cooldown = 0
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Fire:update ()
  local bulletsAffected = false
  local DAMAGE_BOOST = 15
  for i = 1, #bullets do
    if self:collidingWith(bullets[i]) and self.cooldown < 1 then
      bulletsAffected      = true
      bullets[i].damage    = bullets[i].damage + DAMAGE_BOOST
      bullets[i].imagePath = "images/bullets/fire-bullet.png"
    end
  end

  if bulletsAffected then
    self.cooldown = 5
  else
    self.cooldown = self.cooldown - 1
  end
end

table.insert(entityConstructors, Fire)