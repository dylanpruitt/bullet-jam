require('bullets.bullet')

MachineGunBullet = Bullet:new()

function MachineGunBullet:new(x, y, speedX, speedY, creatorFaction)
  local bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.damage = 3
  bullet.acceleration = 0.92
  bullet.maxFramesActive = 60
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

table.insert(bulletConstructors, MachineGunBullet)