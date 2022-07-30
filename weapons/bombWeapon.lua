require('weapons.weapon')
require('entities.base')
require('screenText')
require('utility')

BombWeapon = Weapon:new()

function BombWeapon:new (parent)
  local weapon    = Weapon:new(parent)
  weapon.name     = "Time Bomb"
  weapon.range    = 75
  weapon.speedCap = 1
  weapon.iconPath = "images/icons/time_bomb_icon.png"
  setmetatable(weapon, self)
  self.__index = self
  return weapon
end

function BombWeapon:onFire (cursorX, cursorY)
  local xDistance = cursorX - self.parent.x
  local yDistance = cursorY - self.parent.y
  local distance = math.sqrt(math.pow(xDistance, 2) + math.pow(yDistance, 2))

  if distance < self.range and self.cooldownFrames == 0 then
    local tntRadius = 8
    
    local CRAZY_BOMB_CHANCE = 15
    local randomNumber = math.floor(math.random() * 100) + 1
    
    if randomNumber <= CRAZY_BOMB_CHANCE then
      local message = Message:new("CRAZY BOMB ! ! !", self.parent.x - 25, self.parent.y - 25)
      message:setDelta(0, -1)
      message:setLength(50, 0)
      message:setColor(0, 0, 1)
      message.fontSize = 10
      table.insert(screenText, message)
      
      local amountOfBombs = math.random(5, 8)
      for i = 1, amountOfBombs do
        local bombXOffset = math.random() * 100 - 50
        local bombYOffset = math.random() * 100 - 50
        local bomb = TimeBomb:new(self.parent.x - bombXOffset, self.parent.y - bombYOffset)
        bomb.framesLeft = seconds(3.0)
        table.insert(entities, bomb)
      end
    else
      table.insert(entities, TimeBomb:new(cursorX - tntRadius, cursorY - tntRadius))
    end
    
    self.cooldownFrames = seconds(2.5)
  end 
end

table.insert(weaponConstructors, BombWeapon)