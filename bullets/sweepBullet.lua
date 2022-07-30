require('bullets.bullet')
require('utility')

SweepBullet = Bullet:new()

function SweepBullet:new(x, y, speedX, speedY, creatorFaction)
  bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.damage = 10
  bullet.acceleration = 1
  bullet.maxFramesActive = seconds(10.0)
  bullet.width = 4
  bullet.height = 4
  bullet.imagePath = "images/bullets/bullet.png"
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

table.insert(bulletConstructors, SweepBullet)