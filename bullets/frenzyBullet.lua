require('bullets.bullet')
require('statuses.frenzy')
require('utility')

FrenzyBullet = Bullet:new()

function FrenzyBullet:new(x, y, speedX, speedY, creatorFaction)
  bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.damage = 0
  bullet.acceleration = 0.93
  bullet.maxFramesActive = 100
  bullet.width = 5
  bullet.height = 5
  bullet.imagePath = "images/bullets/frenzy.png"
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

function FrenzyBullet:onCollide (entity)
  if entity.faction ~= self.creatorFaction then
    entity:addStatus(FrenzyStatus:new(entity, seconds(5.0)))
    self.framesActive = self.maxFramesActive
  end
end

table.insert(bulletConstructors, FrenzyBullet)