FrenzyStatus = {
  name = "Frenzy"
}

function FrenzyStatus:new (parent, frames)
  local status = {}
  status.originalFaction = parent.faction
  status.framesLeft = frames
  status.parent = parent or nil
  setmetatable(status, self)
  self.__index = self
  
  parent.faction = "frenzy"
  return status
end

function FrenzyStatus:update ()
  self.framesLeft = self.framesLeft - 1
end

function FrenzyStatus:onStatusEnd ()
  self.parent.faction = self.originalFaction
end