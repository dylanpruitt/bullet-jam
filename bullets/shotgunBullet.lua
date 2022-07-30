require('bullets.bullet')

ShotgunBullet = Bullet:new()

function ShotgunBullet:new(x, y, speedX, speedY, creatorFaction)
  local bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.damage = 30
  bullet.acceleration = 0.87
  bullet.maxFramesActive = 40
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

table.insert(bulletConstructors, ShotgunBullet)