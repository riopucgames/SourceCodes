function LoadMap(filename) -- Le o conteúdo do arquivo para a matriz
  file = io.open(filename)
  i = 1
  for line in file:lines() do
    map[i] = {}
    for j = 1, #line, 1 do
      map[i][j] = line:sub(j,j)
    end
    i = i + 1
  end
  file:close()
end

function mapa_load()
  map = {}
  LoadMap("mapa.txt")
  MOVE = 0
  laser_anim_time = 0
  laser_anim_frame = 1
  base_anim_frame = 1
  laser = {}
  base_laser = {}
  background = {}
  elevator = love.graphics.newImage("Elevator Background.png")
  for x = 1,2,1 do
    background[x] = love.graphics.newImage("Base Background_"..x..".png")
  end
  floor_tile = love.graphics.newImage("floor.png")
  for x = 1,7,1 do
    laser[x] = love.graphics.newImage("Laser_"..x..".png")
  end
  for x = 1,2,1 do
    base_laser[x] = love.graphics.newImage("Base_Laser_"..x..".png")
  end
  c = 0
end
function mapa_update(dt)
  laser_anim_time = laser_anim_time + dt
    c = c + dt 
    if c >= 7 then
      laser_anim_frame = 1
      c = 0
    end
  if laser_anim_time >= 0.1 then
    laser_anim_frame = laser_anim_frame + 1
    if laser_anim_frame > 7 then
      laser_anim_frame = 6
      base_anim_frame = 2
    else
      base_anim_frame = 1
    end
    laser_anim_time = 0
  end
end

function mapa_draw()
  local alter_bg = 0
  for i=1, 12, 1 do --Percorre a matriz e desenha quadrados coloridos
    for j=1, 56, 1 do
      --if (map[i][j] == "X") then
      -- love.graphics.setColor(230,235,134)
      if (map[i][j] == "G") then
        love.graphics.draw(floor_tile, (j * 50 - (50 + MOVE)), (i * 50 - 50))
      elseif map[i][j] == "V" then
        love.graphics.setColor(255,255,255)
        love.graphics.draw(elevator, (j * 50 - (50 + MOVE)), (i * 50 - 50))
      elseif map[i][j] == "D" then 
        love.graphics.draw(background[math.ceil(j%2 + alter_bg)], (j * 50 - (50 + MOVE)), (i * 50 - 50))
        alter_bg = alter_bg + 1
        if alter_bg > 1 then
          alter_bg = 0
          end
      end
    end
  end
  love.graphics.setColor(255,255,255)
  love.graphics.draw(laser[laser_anim_frame], 200 - MOVE, -32)
  love.graphics.draw(base_laser[base_anim_frame], 201 - MOVE, 0)
end