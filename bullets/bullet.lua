require('table')

Bullet = {
  damage = 15,
  acceleration = 0.95,
  width = 4,
  height = 4,
  imagePath = "images/bullets/bullet.png",
  framesActive = 0,
  maxFramesActive = 60,
}

function Bullet:new (x, y, speedX, speedY, creatorFaction)
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

function Bullet:update ()
  self:updatePosition()
  self:updateSpeed()
  self.framesActive = self.framesActive + 1
end

function Bullet:updatePosition ()
  self.x = self.x + self.speedX
  self.y = self.y + self.speedY
end

function Bullet:updateSpeed ()
  self.speedX = self.speedX * self.acceleration
  self.speedY = self.speedY * self.acceleration
  if math.abs(self.speedX) < 0.1 then
    self.speedX = 0 
  end
  if math.abs(self.speedY) < 0.1 then
    self.speedY = 0
  end
end

function Bullet:onCollide (entity)
  if entity.faction ~= self.creatorFaction and entity.canBeDamaged then
    self.framesActive = self.maxFramesActive
    entity.health = entity.health - self.damage
    
    if self.damage > 0 then
      addDamageText(self.damage, entity.x + math.random() * 20 - 10, entity.y, entity)
    end
  end
end

table.insert(bulletConstructors, Bullet)