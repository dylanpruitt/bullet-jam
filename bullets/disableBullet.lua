require('bullets.bullet')
require('statuses.disable')
require('utility')
require('assets')

DisableBullet = Bullet:new()

function DisableBullet:new(x, y, speedX, speedY, parentSpeedX, parentSpeedY, creatorFaction)
  local bullet = Bullet:new(x, y, speedX, speedY, creatorFaction)
  bullet.parentSpeedX = parentSpeedX
  bullet.parentSpeedY = parentSpeedY
  bullet.damage = 0
  bullet.acceleration = 0.8
  bullet.maxFramesActive = 50
  bullet.width = 5
  bullet.height = 5
  bullet.imagePath = "images/bullets/frenzy.png"
  setmetatable(bullet, self)
  self.__index = self
  return bullet
end

function DisableBullet:onCollide (entity)
  if entity.faction ~= self.creatorFaction and entity.canBeFlung then
    local status = DisableStatus:new(entity, seconds(1.5), self.parentSpeedX, self.parentSpeedY)
    entity:addStatus(status)
  self.framesActive = self.maxFramesActive
  end
end

table.insert(bulletConstructors, DisableBullet)