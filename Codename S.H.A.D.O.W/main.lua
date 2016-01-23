require "personagem"
require "mapa"

function love.load()
  mapa_load()
  --love.window.setFullscreen(true,"desktop")
  char_load()
  winbastard = 0 -- ZOEIRA
  counter = 0 -- ZOEIRA
  gato_vermelho = {255,255,255,128,0,0,0,0,0,127,255,255}-- ZOEIRA
  gato_verde = {0,128,255,255,255,255,255,128,0,0,0,0}-- ZOEIRA
  gato_azul = {0,0,0,0,0,128,255,255,255,255,255,127}-- ZOEIRA
  gato_animador = 0-- ZOEIRA
  gato_piscador = 0-- ZOEIRA
  gato_espelhado = 0-- ZOEIRA
  gato_animador2 = 0-- ZOEIRA
  fontefinal = love.graphics.newFont("fonte_arcade.ttf",60)-- ZOEIRA
end

function love.keypressed(key)
  char_keypressed(key)  
end

function love.update(dt)
  mapa_update(dt)
  char_update(dt)
  if winbastard == 1 or winbastard == 3 then -- ZOEIRA
    gato_animador = gato_animador + 300*dt  -- ZOEIRA
    if gato_animador >= 0.5 then  -- ZOEIRA
      gato_piscador = gato_piscador + 1  -- ZOEIRA
      gato_animador = 0  -- ZOEIRA
      if gato_piscador == 12 then  -- ZOEIRA
        gato_piscador = 0  -- ZOEIRA
      end
    end
  end
end

function love.draw()
  if winbastard == 0 then
    mapa_draw()
    char_draw()
  elseif winbastard == 1 then  -- ZOEIRA
  love.graphics.setFont(fontefinal)  -- ZOEIRA
    for x = 1,gato_piscador,1 do  -- ZOEIRA
      love.graphics.setColor(gato_vermelho[x],gato_verde[x],gato_azul[x])  -- ZOEIRA
    end 
    love.graphics.rectangle("fill", 0, 0, 800, 600)  -- ZOEIRA 
    for x = 1,gato_piscador,1 do  -- ZOEIRA
      love.graphics.setColor(gato_vermelho[x] + 20,gato_verde[x] + 20,gato_azul[x] + 20)  -- ZOEIRA
    end
    love.graphics.print("      YOU WIN!!!", 230, 220)  -- ZOEIRA
  elseif winbastard == 3 then  -- ZOEIRA
    love.graphics.setFont(fontefinal)  -- ZOEIRA
    for x = 1,gato_piscador,1 do  -- ZOEIRA
      love.graphics.setColor(gato_vermelho[x],gato_verde[x],gato_azul[x])   -- ZOEIRA
    end
    love.graphics.rectangle("fill", 0, 0, 800, 600)  -- ZOEIRA
    love.graphics.setColor(0,0,0)  -- ZOEIRA
    love.graphics.print("WASTED\n\n\n\n\n   HU3", 250, 150)  -- ZOEIRA
  end
  end 