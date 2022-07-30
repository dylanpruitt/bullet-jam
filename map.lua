require('table')
require('tiles')

tileArray = {
    5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    5, 5, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1,
    3, 3, 3, 3, 3, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
    3, 3, 3, 3, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1,
    5, 3, 3, 5, 1, 5, 3, 3, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1,
    5, 1, 1, 1, 1, 5, 1, 1, 1, 1, 5, 1, 1, 3, 1, 1, 3, 3, 1, 1,
    5, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1,
    5, 5, 5, 3, 3, 3, 1, 1, 3, 3, 1, 3, 3, 3, 1, 3, 1, 1, 1, 1,
    5, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 1, 1, 3, 1, 1, 1, 1,
    5, 1, 1, 3, 3, 3, 1, 1, 3, 3, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1,
    1, 1, 3, 1, 1, 5, 1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 3, 3, 1, 3, 3, 3, 3, 3, 1, 1, 3, 1, 1, 1, 1, 1,
    3, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1, 3, 3, 1, 1, 1, 1, 1,
    3, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1, 1, 1,
    3, 1, 1, 1, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1,
    3, 1, 1, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1,
    1, 1, 1, 3, 1, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1,
}
boundingBoxes = {}
transitionBoxes = {}
spawnLocations = {}
mapFilePath = nil

MAP_WIDTH = 20
MAP_HEIGHT = 20
TILE_SIZE = 16
spawnX = 20
spawnY = 300

mapUpdate = function (entities) end
mapVariables = {}

entityCollidingWithBounds = function (entity, bounds)
  local entityLeftOfBounds = (entity.x + entity.width) < bounds.minX
  local entityRightOfBounds = entity.x > bounds.maxX
  local entityAboveBounds = entity.y > bounds.maxY
  local entityBelowBounds = (entity.y + entity.height) < bounds.minY

  return not ( entityLeftOfBounds or entityRightOfBounds or entityAboveBounds or entityBelowBounds )
end