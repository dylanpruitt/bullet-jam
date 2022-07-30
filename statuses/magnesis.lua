local RANGE = 80
local SPEED = 0.9

MagnesisStatus = {
  name = "Magnesis"
}

function MagnesisStatus:new (parent, frames)
  local status = {}
  status.originalSpeedCap = parent.speedCap
  status.framesLeft = frames
  status.parent = parent or nil
  setmetatable(status, self)
  self.__index = self
  return status
end

function MagnesisStatus:update ()
  self.framesLeft = self.framesLeft - 1
  
  for i = 1, #entities do
    local entity = entities[i]
    
    if self:getParentDistance(entity) <= RANGE and not entity.background then
      if entity:centerX() < self.parent:centerX() then
        entity.x = entity.x + SPEED
      end
      if entity:centerY() < self.parent:centerY() then
        entity.y = entity.y + SPEED
      end
      if entity:centerX() > self.parent:centerX() then
        entity.x = entity.x - SPEED
      end
      if entity:centerY() > self.parent:centerY() then
        entity.y = entity.y - SPEED
      end
    end
  end
end

function MagnesisStatus:getParentDistance (entity)
  return math.sqrt(math.pow(self.parent:centerX() - entity:centerX(), 2) + math.pow(self.parent:centerY() - entity:centerY(), 2))
end

function MagnesisStatus:onStatusEnd ()
  return
end