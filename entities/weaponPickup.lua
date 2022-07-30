require('entities.base')
require('weapons.weapon')

WeaponPickup = Entity:new()

function WeaponPickup:new (x, y, weapon)
  local entity = Entity:new(x, y)
  entity.name = "Weapon Pickup"
  entity.faction = "none"
  entity.health = 250
  entity.maxHealth = 250
  entity.speedCap = 0.5
  entity.width = 16
  entity.height = 16
  entity.imagePath = "images/entities/weapon-pickup.png"
  entity.equippedWeapon = weapon
  entity.weaponID = "Shotgun"
  entity.canBeDamaged = false
  entity.canBeSwitched = false
  entity.isValidTarget = false
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function WeaponPickup:update ()
  self:updateAI()
  self:updatePosition()
  self:updateStatuses()
end

function WeaponPickup:updateAI ()
  local player = entities[1]
  if self:collidingWith(player) then
    local weapon = self.equippedWeapon:new(player)
    table.insert(inventory, weapon)
    
    if #inventory > 1 and player.equippedWeaponR == nil then
        player.equippedWeaponR = weapon
        player.activeRightWeaponIndex = #inventory
    else
      player.equippedWeaponL = weapon
      player.activeLeftWeaponIndex = #inventory
    end
    
    player.switchFrames = 75
    self.health = 0
    table.insert(screenText, message)    
  end
end

table.insert(entityConstructors, WeaponPickup)