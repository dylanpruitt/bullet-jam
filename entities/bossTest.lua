require('entities.basicAI')
require('entities.warningArea')
require('weapons.burstWeapon')
require('weapons.shotgun')
require('weapons.switcheroo')
require('utility')

Boss = BasicAI:new()

--[[

  AI STATES
  
  Check States
    playerdistance
      if   <   75 goto Shotgun Rush
      else <  150 goto Burst Fire
      else >= 150 goto Switcheroo
      
  Wait
    wait 3s
    check states (think())
  Burst Fire
    Stop
    Use Burst Fire if cooldown is 0
    after 5s check states to see what to do
  Shotgun Rush
    moveTo player
    Use shotgun if cooldown is 0
    after 3s check states to see what to do
  Switcheroo
    Stop
    Wait 3s
    Switcheroo
    check states

--]]

function Boss:new (x, y)
  local entity = BasicAI:new(x, y)
  entity.name = "Putrid Mass"
  entity.faction = "enemy"
  entity.aiState = "wait"
  entity.health = 640
  entity.maxHealth = 640
  entity.speedCap = 0.8
  entity.width = 32
  entity.height = 32
  entity.imagePath = "images/entities/placeholder32.png"
  entity.equippedWeapon = BurstFire:new(entity, seconds(1.0))
  entity.isBoss = true
  
  table.insert(entity.extraWeapons, Shotgun:new(entity))
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function Boss:think ()
  if self.aiState ~= "wait" then
    local target = entities[self.targetIndex]
    local targetDistance = math.sqrt(math.pow(self:centerX() - target:centerX(), 2) + math.pow(self:centerY() - target:centerY(), 2))
    
    if targetDistance < 100 then
      self.aiState = "burstFire"
    elseif targetDistance < 200 then
      self.aiState = "shotgunRush"
    else
      self.aiState = "bomb"
    end
    
    self.timeOnState = 0
    self.isThinking  = false
  end
end

function Boss:updateAI ()
  self.targetIndex = self:getClosestTargetIndex()
  
  if self.aiState == "burstFire" then
    self:burstFireAI()
  end
  
  if self.aiState == "shotgunRush" then
    self:shotgunRushAI()
  end
  
  if self.aiState == "bomb" then
    self:bombAI()
  end
  
  if self.aiState == "wait" then
    self.isThinking = false
    self:wait(seconds(3.0))
    self.aiState = "burstFire"
  end  
end

function Boss:burstFireAI ()
  local target = entities[self.targetIndex]
  
  self:stop()
  if self.equippedWeapon.cooldownFrames == 0 then
    self.equippedWeapon:onFire(target.x, target.y)
  end 
  
  if self.timeOnState == seconds(5.0) then
    self.isThinking = true
  end
end

function Boss:bombAI ()
  local target = entities[self.targetIndex]
  table.insert(entities, WarningArea:new(
      target:centerX() - math.floor(math.random() * 32) - 16, 
      target:centerY() - math.floor(math.random() * 32) - 16))
  self:wait(seconds(0.5))
  
  self.isThinking = true
  
  if self.timeOnState == seconds(5.0) then
    self.aiState = "shotgunRush"
  end
end

function Boss:shotgunRushAI ()
  local SHOTGUN = 1
  local target = entities[self.targetIndex]
  
  self:moveTo(target:centerX(), target:centerY())
  if self.extraWeapons[SHOTGUN].cooldownFrames == 0 then
      self.extraWeapons[SHOTGUN]:onFire(target.x, target.y)
  end
  
  if self.timeOnState == seconds(3.0) then
    self.isThinking = true
  end
end

table.insert(entityConstructors, Boss)