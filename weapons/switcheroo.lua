require('weapons.weapon')
require('gameVariables')

Switcheroo = Weapon:new()

function Switcheroo:new (parent)
  local weapon    = Weapon:new(parent)
  weapon.name     = "Switcheroo"
  weapon.range    = 100
  weapon.iconPath = "images/icons/switcheroo_icon.png"
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function Switcheroo:onFire (cursorX, cursorY)
  local targetDistance = self:getClosestTargetDistance()
  local targetIndex = self:getClosestTargetIndex()

  if targetDistance <= self.range * 2 then
    local target = entities[targetIndex]
    local tempX = self.parent.x
    local tempY = self.parent.y

    self.parent.x = target.x
    self.parent.y = target.y
    target.x = tempX
    target.y = tempY
  end
  
  if self.parent.faction == "player" then
    xOffset = 120 - self.parent.x
    if xOffset > 0 then xOffset = 0 end
    yOffset = 120 - self.parent.y
    if yOffset > 0 then yOffset = 0 end
    
    updateMask = true
  end

  self.cooldownFrames = 250
end

function Switcheroo:getClosestTargetDistance ()
  local closestDistance = 10000
  for i = 1, #entities do
    distanceFromEntity = math.sqrt(math.pow(self.parent.x - entities[i].x, 2) + math.pow(self.parent.y - entities[i].y, 2))
    if distanceFromEntity < closestDistance and self.parent.faction ~= entities[i].faction and entities[i].canBeSwitched then
      closestDistance = distanceFromEntity
    end
  end
  return closestDistance
end

function Switcheroo:getClosestTargetIndex ()
  local closestDistance = 10000; local targetIndex = 0
  for i = 1, #entities do
    distanceFromEntity = math.sqrt(math.pow(self.parent.x - entities[i].x, 2) + math.pow(self.parent.y - entities[i].y, 2))
    if distanceFromEntity < closestDistance and self.parent.faction ~= entities[i].faction and entities[i].canBeSwitched then
      closestDistance = distanceFromEntity
      targetIndex = i
    end
  end
  return targetIndex
end

table.insert(weaponConstructors, Switcheroo)