require('bullets.floaterBullet')
require('entities.basicAI')
require('entities.warningArea')
require('weapons.burstWeapon')
require('weapons.fastBurst')
require('weapons.floaterWeapon')
require('weapons.superShotgun')
require('weapons.sweepWeapon')
require('weapons.switcheroo')
require('utility')

BossDoppleganger = BasicAI:new()

--[[

  AI STATES
  
  Check States
    on state shotgunRush
      50% chance -> FINISHER
      50% chance -> SHOTGUN
      
    on state floaters
      60% chance -> FLOATERS
      40% chance -> SWEEP
      
    on state BACKSTEP
      playerdistance < 100
        SHOTGUN
  
    playerdistance
      if   <   75
        15% chance -> BACKSTEP
      elif <   125
        50% chance -> FLOATERS
        50% chance -> SWEEP
      else
        CD
    
  Wait
    wait 3s
    check states (think())
  Floaters
    Stop
    Use Floaters if cooldown is 0
    after 5s check states to see what to do
  Shotgun Rush
    moveTo player
    Use shotgun if cooldown is 0
    after 3s check states to see what to do
--]]

function BossDoppleganger:new (x, y)
  local entity = BasicAI:new(x, y)
  entity.name = "Id"
  entity.faction = "enemy"
  entity.aiState = "wait"
  entity.health = 800
  entity.maxHealth = 800
  entity.speedCap = 1.3
  entity.width = 6
  entity.height = 8
  entity.imagePath = "images/entities/evil-player.png"
  entity.equippedWeapon = BurstFire:new(entity, seconds(1.0))
  entity.isBoss = true

  
  table.insert(entity.extraWeapons, SuperShotgun:new(entity))
  table.insert(entity.extraWeapons, FloaterWeapon:new(entity, seconds(3.0)))
  table.insert(entity.extraWeapons, SweepFire:new(entity))
  table.insert(entity.extraWeapons, FastBurst:new(entity, seconds(7.0)))
  setmetatable(entity, self)
  self.__index = self
  return entity
end

function BossDoppleganger:think ()
  if self.aiState ~= "wait" then
    local target = entities[self.targetIndex]
    local targetDistance = math.sqrt(math.pow(self:centerX() - target:centerX(), 2) + math.pow(self:centerY() - target:centerY(), 2))
    local stateChosen = false
    
    if self.aiState == "closeDistance" then
      local a = math.floor(math.random() * 100) + 1
      if a <= 50 or targetDistance < 50 then
        local target = entities[self.targetIndex]
        self:setupLunge()
      end
      
      stateChosen = true
    end

    if self.aiState == "shotgunRush" and not stateChosen then
      local a = math.floor(math.random() * 100) + 1
      if a <= 50 then
        local target = entities[self.targetIndex]
        self.targetX = target.x
        self.targetY = target.y
        self.aiState = "finisher"
      end
      
      stateChosen = true
    end

    if self.aiState == "burstFire" and not stateChosen then
      local a = math.floor(math.random() * 100) + 1
      if     a <= 30 then
        local target = entities[self.targetIndex]
        self.targetX = target.x
        self.targetY = target.y
        self.aiState = "sweepFire"
      elseif a <= 60 then
        self.aiState = "closeDistance"
      end
      
      stateChosen = true
    end
    
    if self.aiState == "backstep" and targetDistance < 100 and not stateChosen then
      self:setupLunge()
      stateChosen = true
    end
    
    if not stateChosen then
      if targetDistance < 50 then
        local a = math.floor(math.random() * 100) + 1
        if a <= 30 then
          self.aiState = "backstep"
        else
          self:setupLunge()
        end
      elseif targetDistance < 100 then
        local a = math.floor(math.random() * 100) + 1
        if a <= 50 then
          self.aiState = "burstFire"
        else
          self:setupLunge()
        end
      elseif targetDistance < 150 then
        local target = entities[self.targetIndex]
        self.targetX = target.x
        self.targetY = target.y
        self.aiState = "sweepFire"
      else
        self.aiState = "closeDistance"
      end
    end

    self.timeOnState = 0
    self.isThinking  = false
    
    print("going to state ", self.aiState)
  end
end

function BossDoppleganger:setupLunge ()
  local SHOTGUN = 1
  local target  = entities[self.targetIndex]
  
  local xDistance = target:centerX() - self:centerX()
  local yDistance = target:centerY() - self:centerY()
  local angle = math.atan(yDistance / xDistance)
        
  local xSpeed = self.speedCap * math.cos(angle)
  local ySpeed = self.speedCap * math.sin(angle)
  if xDistance < 0 then
    xSpeed = xSpeed * -1 
    ySpeed = ySpeed * -1
  end
          
  local status  = DisableStatus:new(self, seconds(1.0), xSpeed, ySpeed)
  self:addStatus(status)
  self.controlEnabled = true
        
  self.extraWeapons[SHOTGUN].cooldownFrames = seconds(0.2)
  self.aiState = "shotgunRush"
end

function BossDoppleganger:updateAI ()
  self.targetIndex = self:getClosestTargetIndex()
  
  if self.aiState == "backstep" then
    self:backstepAI()
  end
  
  if self.aiState == "burstFire" then
    self:floaterAI()
  end
  
  if self.aiState == "shotgunRush" then
    self:lungeAI()
  end
  
  if self.aiState == "sweepFire" then
    self:sweepFireAI()
  end
  
  if self.aiState == "finisher" then
    self:finisherAI()
  end
  
  if self.aiState == "closeDistance" then
    local target         = entities[self.targetIndex]
    local targetDistance = math.sqrt(math.pow(self:centerX() - target:centerX(), 2) + math.pow(self:centerY() - target:centerY(), 2))

    self:moveTo(target.x, target.y)
    
    if targetDistance < 100 or self.timeOnState == seconds(2.0) then
      self.isThinking = true
    end
  end
  
  if self.aiState == "wait" then
    self.isThinking = false
    self:wait(seconds(2.0))
    self.aiState = "burstFire"
  end  
end

function BossDoppleganger:floaterAI ()  
  local FLOATER = 2
  if self.extraWeapons[FLOATER].cooldownFrames == 0 then
      self.extraWeapons[FLOATER]:onFire(0, 0)
  end
  
  if self.timeOnState == seconds(3.0) then
    self.isThinking = true
  end
end

function BossDoppleganger:backstepAI ()
  local SHOTGUN = 1
  local target  = entities[self.targetIndex]
  
  local xDistance = target:centerX() - self:centerX()
  local yDistance = target:centerY() - self:centerY()
  local angle = math.atan(yDistance / xDistance)
  
  local xSpeed = self.speedCap * math.cos(angle) * -0.6
  local ySpeed = self.speedCap * math.sin(angle) * -0.6
  if xDistance < 0 then
    xSpeed = xSpeed * -1 
    ySpeed = ySpeed * -1
  end
    
  local status  = DisableStatus:new(self, seconds(1.5), xSpeed, ySpeed)
  self:addStatus(status)
  if self.extraWeapons[SHOTGUN].cooldownFrames == 0 then
      self.extraWeapons[SHOTGUN]:onFire(target.x, target.y)
  end
  
  self.isThinking = true
end

function BossDoppleganger:sweepFireAI ()
  local SWEEP = 3
  
  self:stop()
  if self.extraWeapons[SWEEP].cooldownFrames == 0 then
      self.extraWeapons[SWEEP]:onFire(self.targetX, self.targetY)
  end
  
  if self.timeOnState == seconds(5.0) then
    self.isThinking = true
  end
end

function BossDoppleganger:finisherAI ()
  local FINISHER = 4
  
  self:stop()
  if self.extraWeapons[FINISHER].cooldownFrames == 0 then
      self.extraWeapons[FINISHER]:onFire(self.targetX, self.targetY)
  end
  
  if self.timeOnState == seconds(5.0) then
    self.isThinking = true
  end
end

function BossDoppleganger:bombAI ()
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

function BossDoppleganger:lungeAI ()
  local SHOTGUN = 1
  local target = entities[self.targetIndex]
  
  if self.extraWeapons[SHOTGUN].cooldownFrames == 0 then
      self.extraWeapons[SHOTGUN]:onFire(target.x, target.y)
  end
  
  if self.timeOnState == seconds(1.5) then
    self.statuses = {}
    self:stop()
    self.isThinking = true
  end
end

table.insert(entityConstructors, BossDoppleganger)