require('entities.base')
require('screenText')

InfoBubble = Entity:new()

function InfoBubble:new (x, y, message)
  local entity = Entity:new(x, y)
  entity.name = "Info Bubble"
  entity.faction = "neutral"
  entity.message = message
  entity.health = 1
  entity.maxHealth = 1
  entity.background = true
  entity.width = 8
  entity.height = 8
  entity.imagePath = "images/entities/info-bubble.png"
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

function InfoBubble:update ()
 if self.cooldown > 0 then self.cooldown = self.cooldown - 1 end
 
 if self:collidingWith(player) and self.cooldown < 1 then
    local msg      = Message:new(self.message, self:centerX() - (2 * self.message:len()), self:centerY() - 16)
    msg.fontSize   = 10
    msg.waitFrames = seconds(3.0)
    self.cooldown  = seconds(3.0)
    table.insert(screenText, msg)
  end
end

table.insert(entityConstructors, InfoBubble)