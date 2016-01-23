function char_load()
  char = {
    x = 0;
    y = 450;
    dir = 1;
    frameset = 1;
      }
  char_frames = {}
  char_idle = {}
  char_crouch = {}
  char_jump = {}
  char_skill = {}
  char_run = {}
  colision = {}
  wincolision = {}
  acc = 1
  for i=1, 12, 1 do --Percorre a matriz e checa a colisão com o personagem
    for j=1, 56, 1 do
      if (map[i][j] == "G") then
        table.insert(colision, {x = j*50 - 50, y = i*50 - 50})
      elseif map[i][j] == "W" then
        table.insert(wincolision, {x = j*50 - 50, y = i*50 - 50})
      end
    end
  end
  for x = 1,2,1 do
    char_idle[x] = love.graphics.newImage("shadow_Idle_"..x..".png") -- OK
    char_crouch[x] = love.graphics.newImage("shadow_Crouch_"..x..".png") -- programar funcionalidade e animação
    char_jump[x] = love.graphics.newImage("shadow_Jump_"..x..".png") -- OK
  end
  for x = 1,3,1 do
    char_skill[x] = love.graphics.newImage("shadow_disable_"..x..".png") -- programar funcionalidade e animação
  end
  for x = 1,4,1 do 
    char_frames[x] = love.graphics.newImage("shadow_walk_"..x..".png") -- OK
  end
  for x = 1,6,1 do
    char_run[x] = love.graphics.newImage("shadow_run"..x..".png") -- programar funcionalidade e animação
  end
  char_anim_time = 0
  char_anim_frames = 1
  idle_frames = 1
  jump_frames = 1
  run_frames = 1
  tempo = 0
  pulo = false 
  run = 1
end

function checkcolision(x, xw, x2, xw2, y, yh, y2, yh2) -- checar a colisão
 return y2 < y + yh and x2 < x + xw and y < y2 + yh2 and x < x2 + xw2
end

function char_keypressed(key)
  if key == "up" then 
    pulo = true 
  end 
end 

function char_update(dt)
  for i,v in ipairs(colision) do 
    if checkcolision(char.x, 50, v.x - MOVE + 5, 40, char.y + 300*dt, 100, v.y, 1) then
      char.y = v.y - 100
      if tempo >= 0.5 then
        pulo = false
        tempo = 0
      end
    end
    if checkcolision(char.x + (75*run)*dt, 50, v.x - MOVE, 1, char.y, 100, v.y + 5, 40) then
      char.x = v.x - 51 - MOVE
    end
    if checkcolision(char.x - (75*run)*dt, 50, v.x - MOVE + 49, 1, char.y, 100, v.y + 5, 40) then
      char.x = v.x + 51 - MOVE
    end
    if checkcolision(char.x, 50, v.x - MOVE + 5, 40, char.y - 300*dt, 100, v.y + 49, 1) then
      char.y = v.y + 50
    end
  end
  for i,v in ipairs(wincolision) do-- ZOEIRA +- (precisa da win no MVP)
    if checkcolision(char.x, 50, v.x - MOVE, 50, char.y, 100, v.y, 50) then-- ZOEIRA
      winbastard = 1-- ZOEIRA
    elseif char.y + 100 >= 600 then-- ZOEIRA
      winbastard = 3-- ZOEIRA
      counter = counter + dt-- ZOEIRA
      if counter > 8 then
        love.load()
      end
    end
  end
  if love.keyboard.isDown("right") then
    char.frameset = 2
    if love.keyboard.isDown("lshift") then
      char.frameset = 4
      run = 2
    end
  elseif love.keyboard.isDown("left") then
    char.frameset = 3
    if love.keyboard.isDown("lshift") then
      char.frameset = 5
      run = 2
    end
  else
    char.frameset = 1
  end
  if char.frameset == 2 then
    char.x = char.x + 75*dt
    char.dir = 1
    char_anim_time = char_anim_time + dt
    if char_anim_time > 0.2 then
      char_anim_frames = char_anim_frames + 1
        if char_anim_frames > 4 then
          char_anim_frames = 1
        end
      char_anim_time = 0
    end
  elseif char.frameset == 1 then
    char_anim_time = char_anim_time + dt
    if char_anim_time > 0.8 then
      idle_frames = idle_frames + 1
        if idle_frames > 2 then
          idle_frames = 1
        end
      char_anim_time = 0
    end
  elseif char.frameset == 3 then    
    char.x = char.x - 75*dt
    char.dir = -1
    char_anim_time = char_anim_time + dt
    if char_anim_time > 0.2 then
      char_anim_frames = char_anim_frames + 1
        if char_anim_frames > 4 then
          char_anim_frames = 1
        end
      char_anim_time = 0
    end
  elseif char.frameset == 4 then
    char.x = char.x + 150*dt
    char.dir = 1
    char_anim_time = char_anim_time + dt
    if char_anim_time > 0.15 then
      run_frames = run_frames + 1
        if run_frames > 6 then
          run_frames = 1
        end
      char_anim_time = 0
    end
  elseif char.frameset == 5 then
    char.x = char.x - 150*dt
    char.dir = -1
    char_anim_time = char_anim_time + dt
    if char_anim_time > 0.15 then
      run_frames = run_frames + 1
        if run_frames > 6 then
          run_frames = 1
        end
      char_anim_time = 0
    end
    ------------------------------------------------------------------------------------
  end
  if pulo == true then
    tempo = tempo + dt
    frameset = 4
    if tempo < 0.5 then
      jump_frames = 1
      char.y = char.y - 300*dt 
    elseif tempo > 0.5 then
      jump_frames = 2
      char.y = char.y + 300*dt
    end
  end
  if char.x > 500 then
    MOVE = MOVE + 200*dt
    char.x = 500
  end
  if char.x > 750 then -- colocando os limites da tela ( incio )
    char.x = 750
  end
  if char.x < 0 then
    char.x = 0
  end
  if char.y - 300*dt < 0 then 
    char.y = 0
  end
  if char.y > 500 then -- limites da tela ( fim )
    char.y = 500
  end
end

function char_draw()
  if (char.frameset == 2 or char.frameset == 3) and pulo == false then
    love.graphics.setColor(255,255,255)
    love.graphics.draw(char_frames[char_anim_frames], char.x + char_idle[1]:getWidth()/2, char.y + char_idle[1]:getHeight()/2, 0, char.dir, 1, char_frames[1]:getWidth()/2, char_frames[1]:getHeight()/2)
  elseif pulo == true then
    love.graphics.draw(char_jump[jump_frames], char.x + char_jump[1]:getWidth()/2, char.y + char_jump[1]:getHeight()/2, 0, char.dir, 1, char_jump[1]:getWidth()/2, char_jump[1]:getHeight()/2)
  elseif char.frameset == 4 or char.frameset == 5 then
    love.graphics.draw(char_run[run_frames], char.x + char_run[1]:getWidth()/2, char.y + char_run[1]:getHeight()/2, 0, char.dir, 1, char_run[1]:getWidth()/2, char_run[1]:getHeight()/2)
  else
    love.graphics.draw(char_idle[idle_frames], char.x + char_idle[1]:getWidth()/2, char.y + char_idle[1]:getHeight()/2, 0, char.dir, 1, char_idle[1]:getWidth()/2, char_idle[1]:getHeight()/2)
  end
end