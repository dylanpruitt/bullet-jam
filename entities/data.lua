require('constants')

entityConstructors = {}

require('entities.barrel')
require('entities.bombSpawner')
require('entities.bossDoppelganger')
require('entities.bossTest')
require('entities.column')
require('entities.exploder')
require('entities.explosion')
require('entities.fire')
require('entities.forcefield')
require('entities.forcefieldSpawner')
require('entities.repulsor')
require('entities.spike')
require('entities.player')
require('entities.portal')
require('entities.rock')
require('entities.timeBomb')
require('entities.tnt')
require('entities.turret')
require('entities.tree')
require('entities.virusEnemy')
require('entities.warningArea')
require('entities.weaponPickup')

getEntityConstructorIndexFromName = function (name)
    for i = 1, #entityConstructors do
        temp = entityConstructors[i]:new(0, 0)
        if temp.name == name then
            return i
        end
    end

    return NOT_FOUND
end

getEntityLayers = function ()
  local background = {}
  local foreground = {}
  
  for i = 1, #entities do
    if entities[i].background then
      table.insert(background, entities[i])
    else
      table.insert(foreground, entities[i])
    end
  end
  
  return {background, foreground}
end

addEntity = function (newEntity)
  local index = getEntityConstructorIndexFromName(newEntity:new(0,0).name)
  if index > NOT_FOUND then
    print("entity can't be added!")
  else
    table.insert(entityConstructors, newEntity)
  end
end

replaceEntity = function (name, newEntity)
  local index = getEntityConstructorIndexFromName(name)
  if index > NOT_FOUND then
    entityConstructors[index] = newEntity
  else
    addEntity(newEntity)
  end
end