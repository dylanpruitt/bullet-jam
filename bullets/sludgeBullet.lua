require('bullets.bullet')

SludgeBullet = Bullet:new()

function SludgeBullet:new(x, y, speedX, speedY, creatorFaction)
  local bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.damage          = 50
  bullet.acceleration    = 1.0
  bullet.maxFramesActive = seconds(3.0)
  bullet.imagePath       = "images/bullets/trap-bullet.png"
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

table.insert(bulletConstructors, SludgeBullet)