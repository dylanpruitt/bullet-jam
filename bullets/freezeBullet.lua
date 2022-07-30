require('bullets.bullet')
require('statuses.freeze')
require('utility')

FreezeBullet = Bullet:new()

function FreezeBullet:new(x, y, speedX, speedY, creatorFaction)
  local bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.damage = 0
  bullet.speedCap = 6
  bullet.acceleration = 0.92
  bullet.maxFramesActive = 100
  bullet.width = 5
  bullet.height = 5
  bullet.imagePath = "images/bullets/frenzy.png"
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

function FreezeBullet:onCollide (entity)
  if entity.faction ~= self.creatorFaction then
    entity:addStatus(FreezeStatus:new(entity, seconds(1.0)))
    self.framesActive = self.maxFramesActive
  end
end

table.insert(bulletConstructors, FreezeBullet)