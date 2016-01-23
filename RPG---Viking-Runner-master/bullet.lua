require "contact"
require "homingBullet"

bullet = {}
local qFrame = 6
local time = 0.7
--9,18 com 48,48
function bullet.load()
  bullet.image = love.graphics.newImage("/Assets/Enemies/fireBall.png")
  bullet.velocity = love.graphics.getWidth()*0.5
  bullet.list = {}
  local aw = bullet.image:getWidth()
  local ah = bullet.image:getHeight()
  local w = aw/qFrame
  local h = ah
  bullet.imgHeight = 72*love.graphics.getHeight()/720
  bullet.scale = bullet.imgHeight/h
  bullet.imgWidth = bullet.scale*w
  bullet.width = bullet.scale*48
  bullet.height = bullet.scale*48
  bullet.offset = {x=9,y=18}
  bullet.quads = {}
  for i=0, qFrame-1 do
    table.insert(bullet.quads,love.graphics.newQuad(i*w,0,w,h,aw,ah))
  end
  
  --[[
  originalWidth = bullet.image:getWidth()
  originalHeight = bullet.image:getHeight()
  bullet.sw = bullet.width / originalWidth
  bullet.sh = bullet.height / originalHeight
  ]]
  --bullet.s = bullet.sw>bullet.sh and bullet.sw or bullet.sh
  
end

function bullet.randomSpawn()
  randomNumber = love.math.random()
  bulletPos = randomNumber>2/3 and 2 or randomNumber>1/3 and 1 or 0
  local hom
  if bulletPos == 2 then
    rnd = 100
    hom = true
  else
    rnd = 302 + 200*bulletPos
    hom = false
  end
  --y=rnd
  local bul = {x=love.graphics.getWidth(),y=rnd, aComp = animComp.newAnim(qFrame,time),vel={x=-bullet.velocity,y=0},angle=math.pi}
  bul.isHoming = hom
  table.insert(bullet.list, bul)
  audio.playBullet()
end

function bullet.spawn(x,y)
  table.insert(bullet.list,{x=x,y=y,aComp = animComp.newAnim(qFrame,time),vel={x=-bullet.velocity,y=0},angle=math.pi})
  audio.playBullet()
end

function bullet.update(dt)
  for i,v in ipairs(bullet.list) do
    if v.isHoming then
      homingBullet.update(dt,v,bullet)
    end
    v.x = v.x+v.vel.x*dt
    v.y = v.y+v.vel.y*dt
    --v.x = v.x + bullet.velocity*dt
    animComp.update(dt,v.aComp)
  end
  if player.invTime==0 then
    bullet.checkContact()
  end
end

function bullet.checkContact()
  local p = player
  local sw = love.graphics.getWidth()/2
  local sh = love.graphics.getHeight()/2
  local bw = bullet.width/2
  local bh = bullet.height/2
  local dw = bw+sw
  local dh = bh+sh
  for i,v in ipairs(bullet.list) do
    local dist = {x=v.x+bw-sw,y=v.y+bh-sh}
    if math.abs(dist.x)>dw or math.abs(dist.y)>dh then
      removeBullet(i)
      --bullet.randomSpawn()
    elseif contact.isInRectContact(p.x,p.y,p.width,p.height,v.x,v.y,bullet.width,bullet.height) then
      player.reset()
      animations.createSplash(v.x,v.y+bullet.height/2,color.red)
      removeBullet(i)
      --bullet.randomSpawn()
    end
  end
end

function removeBullet(i)
  table.remove(bullet.list,i)
  if #bullet.list == 0 then
    audio.stopFire()
  end
end

function bullet.quit()
  table.removeAll(bullet.list)
end

function bullet.draw(dt)
  for i,v in ipairs(bullet.list) do
    --love.graphics.draw(bullet.image,v.x,v.y,0,bullet.sw, bullet.sh)
    love.graphics.draw(bullet.image,bullet.quads[v.aComp.curr_frame],v.x+bullet.width/2,v.y+bullet.height/2,math.pi-v.angle,bullet.scale,bullet.scale,bullet.width/2+bullet.offset.x,bullet.height/2+bullet.offset.y)
    if configuration.debugBoundingBox then
      love.graphics.rectangle("line",v.x,v.y,bullet.width,bullet.height)
    end
    --love.graphics.print(v.angle,400,400)
  end
end