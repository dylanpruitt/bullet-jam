player       = nil
inventory    = {}
paused       = false
mapChanged   = false
loadFrames   = 0
entities     = {}
updateMask   = false

FPS          = 50
timeElapsed  = 1 / FPS
frame        = 1

xOffset      = math.floor(spawnX / 240) * -80
yOffset      = math.floor(spawnY / 240) * -80

maskCanvas   = love.graphics.newCanvas(MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE)