DisableStatus = {
  name = "Disable"
}

function DisableStatus:new (parent, frames, speedX, speedY)
  local status = {}
  status.originalSpeedCap = parent.speedCap
  status.framesLeft = frames
  status.parent = parent or nil
  setmetatable(status, self)
  self.__index = self
  
  parent.speedCap = parent.speedCap * 2.5

  parent.speedX = speedX * 2
  parent.speedY = speedY * 2
  parent.controlEnabled = false
  return status
end

function DisableStatus:update ()
  self.framesLeft = self.framesLeft - 1
  self.parent.speedX = self.parent.speedX * 0.95
  self.parent.speedY = self.parent.speedY * 0.95
  self.parent.speedCap = self.parent.speedCap * 0.95
end

function DisableStatus:onStatusEnd ()
  self.parent.speedCap = self.originalSpeedCap
  self.parent.controlEnabled = true
end
