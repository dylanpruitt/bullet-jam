require('gameVariables')

round = function(n, decimalPlaces)
  local powerOfTen = math.pow(10, decimalPlaces)
  return (math.floor(n * powerOfTen) / powerOfTen)
end


-- This function takes in an amount of seconds, and returns a number value of frames
--   corresponding to that value.
seconds = function(seconds)
  return math.floor(seconds * FPS)
end

getMousePosition = function()
  x, y = love.mouse.getPosition()
  return (x / scaleX) - xOffset, (y / scaleY) - yOffset
end

fixedWindowPosition = function(x, y)
  return x - xOffset, y - yOffset
end