screenText = {}

function addDamageText (message, x, y, entity)
  local temp = Message:new(message, x, y, tostring(entity))
  local uniqueTag = true
  temp:setDelta(0, -1)
  temp:setLength(50, 0)
  temp:setColor(1, 0, 0)
  for i = 1, #screenText do
    if temp.tag == screenText[i].tag then
      local damage = tonumber(screenText[i].message) + tonumber(temp.message)
      screenText[i].message = damage
      uniqueTag = false
    end
  end
  
  if uniqueTag then table.insert(screenText, temp) end
end

Message = {}

function Message:new (message, x, y, tag)
  local messageObj = {
    message = message,
    x = x,
    y = y,
    tag = tag,
    dx = 0,
    dy = 0,
    r = 255/255, 
    g = 255/255, 
    b = 255/255,
    opacity = 1,
    fontSize = 7,
    waitFrames = 50,
    fadeFrames = 0,
    totalFadeFrames = 0,
    fixed = false
  }
  setmetatable(messageObj, self)
  self.__index = self
  return messageObj
end

function Message:setDelta (dx, dy)
  self.dx = dx
  self.dy = dy
end

function Message:setLength (wait, fade)
  self.waitFrames = wait
  self.totalFadeFrames = fade
  self.fadeFrames = fade
end

function Message:setColor (r, g, b)
  self.r = r
  self.g = g
  self.b = b
end

function Message:update ()
  if self.waitFrames > 0 then
    self.waitFrames = self.waitFrames - 1
    self.x = self.x + self.dx
    self.y = self.y + self.dy
  elseif (self.fadeFrames > 0) then
    self.fadeFrames = self.fadeFrames - 1
    self.opacity = self.opacity - (1 / self.totalFadeFrames)
  end
end