FreezeStatus = {
  name = "Freeze"
}

function FreezeStatus:new (parent, frames)
  local status = {}
  status.originalSpeedCap = parent.speedCap
  status.framesLeft = frames
  status.parent = parent or nil
  setmetatable(status, self)
  self.__index = self
  parent.speedCap = 0
  return status
end

function FreezeStatus:update ()
  self.framesLeft = self.framesLeft - 1
  self.parent.speedX = 0
  self.parent.speedY = 0
end

function FreezeStatus:onStatusEnd ()
  self.parent.speedCap = self.originalSpeedCap
end