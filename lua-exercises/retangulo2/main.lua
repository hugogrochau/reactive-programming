function newblip (vel)
  local x, y = 0, 0
  local width, height = love.graphics.getDimensions( )
  local wakeTime = false 
  return {
    update = coroutine.wrap ( function ()
      while true do
        if not wakeTime then
          x = x+vel
        elseif wakeTime < os.time() then
          x = x+vel
        end
        if x > width then
        -- volta à esquerda da janela
          x = 0
        end
        coroutine.yield()
      end
    end),
    affected = function (pos)
      if pos>x-20 and pos<x+20 then
      -- "pegou" o blip
        return true
      else
        return false
      end
    end,
    draw = function ()
      love.graphics.rectangle("line", x, y, 10, 10)
    end,
    wait = function (seconds)
      wakeTime = os.time() + seconds
    end
  }
end

function newplayer ()
  local x, y = 0, 200
  local width, height = love.graphics.getDimensions( )
  return {
  try = function ()
    return x
  end,
  update = function (dt)
    x = x + 0.5
    if x > width then
      x = 0
    end
  end,
  draw = function ()
    love.graphics.rectangle("line", x, y, 30, 10)
  end
  }
end

function love.keypressed(key)
  if key == 'a' then
    pos = player.try()
    for i in ipairs(listabls) do
      local hit = listabls[i].affected(pos)
      if hit then
        listabls[i].wait(3)
        -- table.remove(listabls, i) -- esse blip "morre" 
        return -- assumo que só vai pegar um blip
      end
    end
  end
end

function love.load()
  player =  newplayer()
  listabls = {}
  for i = 1, 5 do
    listabls[i] = newblip(i)
  end
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update(dt)
  player.update(dt)
  for i = 1,#listabls do
    listabls[i].update()
  end
end
  
