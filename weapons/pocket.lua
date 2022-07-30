require('weapons.weapon')

Pocket = Weapon:new()

function Pocket:new (parent)
  local weapon = Weapon:new(parent)
  weapon.name = "Pocket"
  weapon.range = 60
  weapon.heldEntity = nil
  weapon.iconPath = "images/icons/pocket_icon.png"
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function Pocket:onFire (cursorX, cursorY) 
  if self.heldEntity == nil then
    local selectedEntityIndex = self:getEntityAtCursor(cursorX, cursorY)
  
    if selectedEntityIndex > NOT_FOUND and not self.parent:isSelf(entities[selectedEntityIndex]) then
      self.heldEntity = entities[selectedEntityIndex]
      table.remove(entities, selectedEntityIndex)
      self.cooldownFrames = seconds(2.0)
    end
  else
    self.heldEntity.x = cursorX - self.heldEntity.width / 2
    self.heldEntity.y = cursorY - self.heldEntity.height / 2
    table.insert(entities, self.heldEntity)
    self.heldEntity = nil
    self.cooldownFrames = seconds(2.0)
  end
end

function Pocket:getEntityAtCursor (x, y)
  for i = 1, #entities do
    if x >= entities[i].x and y >= entities[i].y and x <= (entities[i].x + entities[i].width) and y <= (entities[i].y + entities[i].height) then
        return i
    end
  end
  
  return NOT_FOUND
end

table.insert(weaponConstructors, Pocket)