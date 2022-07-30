require('bullets.bullet')
require('utility')

FloaterBullet = Bullet:new()

function FloaterBullet:new(x, y, speedX, speedY, creatorFaction)
  bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.damage = 100
  bullet.acceleration = 1
  bullet.maxFramesActive = seconds(10.0)
  bullet.width = 12
  bullet.height = 12
  bullet.imagePath = "images/bullets/floater-bullet.png"
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

table.insert(bulletConstructors, FloaterBullet)