require('bullets.bullet')

HealthBullet = Bullet:new()

function HealthBullet:new(x, y, speedX, speedY, creatorFaction)
  local bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.acceleration = 0.92
  bullet.maxFramesActive = 60
  bullet.damage = 0
  bullet.imagePath = "images/bullets/health-bullet.png"
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

function HealthBullet:onCollide (entity)
  if entity.faction ~= self.creatorFaction then
    entity.health = entity.health + 25
    if entity.health > entity.maxHealth then
      entity.health = entity.maxHealth
    end
    self.framesActive = self.maxFramesActive
  end
end

table.insert(bulletConstructors, HealthBullet)