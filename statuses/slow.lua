SlowStatus = {
  name = "Slow"
}

function SlowStatus:new (parent, frames)
  local status = {}
  status.originalSpeedCap = parent.speedCap
  status.framesLeft = frames
  status.parent = parent or nil
  setmetatable(status, self)
  self.__index = self
  
  parent.speedCap = parent.speedCap / 2
  return status
end

function SlowStatus:update ()
  self.framesLeft = self.framesLeft - 1
  
  if self.framesLeft < 50 then
    self.parent.speedCap = self.parent.speedCap + (self.originalSpeedCap / 100)
  end
end

function SlowStatus:onStatusEnd ()
  self.parent.speedCap = self.originalSpeedCap
  self.parent.controlEnabled = true
end
