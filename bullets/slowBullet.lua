require('table')
require('utility')

SlowBullet = {
  damage = 50,
  acceleration = 0.99,
  width = 4,
  height = 4,
  imagePath = "images/bullets/bullet.png",
  framesActive = 0,
  maxFramesActive = seconds(5.0),
}

function SlowBullet:new (x, y, speedX, speedY, creatorFaction)
  local bullet = {}
  bullet.x = x
  bullet.y = y
  bullet.speedX = speedX
  bullet.speedY = speedY
  bullet.creatorFaction = creatorFaction
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

function SlowBullet:update ()
  self:updatePosition()
  self:updateSpeed()
  self.framesActive = self.framesActive + 1
end

function SlowBullet:updatePosition ()
  self.x = self.x + self.speedX
  self.y = self.y + self.speedY
end

function SlowBullet:updateSpeed ()
  self.speedX = self.speedX * self.acceleration
  self.speedY = self.speedY * self.acceleration
  if math.abs(self.speedX) < 0.1 then
    self.speedX = 0 
  end
  if math.abs(self.speedY) < 0.1 then
    self.speedY = 0
  end
end

function SlowBullet:onCollide (entity)
  if entity.faction ~= self.creatorFaction and entity.canBeDamaged then
    self.framesActive = self.maxFramesActive
    entity.health = entity.health - self.damage
    
    if self.damage > 0 then
      addDamageText(self.damage, entity.x + math.random() * 20 - 10, entity.y, entity)
    end
  end
end

table.insert(bulletConstructors, SlowBullet)