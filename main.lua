--tela
local x = display.contentWidth
local y = display.contentHeight

--FUNDO ----
fundo = display.newImageRect("mapa.png",2528,3071)
local bg1
local bg2
local runtime = 0
local scrollSpeed = 1.4
--PARALLAX
local function addScrollableBg()
    local bgImage = { type="image", filename="mapa.png" }

    -- Add First bg image
    bg1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg1.fill = bgImage
    bg1.x = display.contentCenterX
    bg1.y = display.contentCenterY

    -- Add Second bg image
    bg2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg2.fill = bgImage
    bg2.x = display.contentCenterX
    bg2.y = display.contentCenterY - display.actualContentHeight
end

local function moveBg(dt)
    bg1.y = bg1.y + scrollSpeed * dt
    bg2.y = bg2.y + scrollSpeed * dt

    if (bg1.y - display.contentHeight/2) > display.actualContentHeight then
        bg1:translate(0, -bg1.contentHeight * 2)
    end
    if (bg2.y - display.contentHeight/2) > display.actualContentHeight then
        bg2:translate(0, -bg2.contentHeight * 2)
    end    
end 

local function getDeltaTime()
   local temp = system.getTimer()
   local dt = (temp-runtime) / (1000/60)
   runtime = temp
   return dt
end

local function enterFrame()
    local dt = getDeltaTime()
    moveBg(dt)
end

function init()
    addScrollableBg()
    Runtime:addEventListener("enterFrame", enterFrame)
end

init()

fundo.enterFrame = scrollMountains
Runtime:addEventListener("enterFrame", fundo)

--fim FUNDO/PARALLAX

--SONS 
local function tocaSom(e)
    local soundEffect = audio.loadSound("sounds/qubodup-crash.ogg")
    audio.play(soundEffect, {channel=2, loops=0})
end
local function som( e )
    local sound1 = audio.loadSound("sounds/Spacearray.ogg")
    audio.play(sound1, {channel=1, loops=-1})
end
som()
--FIM SOM 

-- PERSONAGEM
local personagem = {}
personagem[1] = display.newImageRect("papaleguas.png", 300, 300)
personagem[1].x = x * .5
personagem[1].y = y*.9
personagem[1].myName = "papalegua"
-- FIM PERSONAGEM



-- INIMIGOS 
local obstaculos = {}
obstaculos[1] = display.newImageRect("nave2.png",150,200)
obstaculos[1].x = x*.3
obstaculos[1].y = -300
obstaculos[1].rotation = -180
obstaculos[1].myName = "enemy1"

obstaculos[2] = display.newImageRect("nave1.png", 150, 200)
obstaculos[2].x = x*.75
obstaculos[2].y = -300
obstaculos[2].rotation = 180
obstaculos[2].myName = "enemy2"


obstaculos[3] = display.newImageRect("nave1.png", 150, 200)
obstaculos[3].x = x*.2
obstaculos[3].y = -300
obstaculos[3].rotation = 180
obstaculos[3].myName = "enemy3"
--FIM INIMIGOS

--FÍSICA 
local fisica = require("physics")
fisica.start()
    -- física personagem
fisica.addBody(personagem[1], {density=3.0, friction=0.5, bounce=0.3})
personagem[1].isFixedRotation = true
personagem[1].angularVelocity = 0
    --fim física personagem
fisica.addBody(obstaculos[1], {density=3.0, friction=0.5, bounce=0.3})
obstaculos[1].isFixedRotation = true
obstaculos[1].angularVelocity = 0

fisica.addBody(obstaculos[2], {density=3.0, friction=0.5, bounce=0.3})
obstaculos[2].isFixedRotation = true
obstaculos[2].angularVelocity = 0

fisica.addBody(obstaculos[3], {density=3.0, friction=0.5, bounce=0.3})
obstaculos[3].isFixedRotation = true
obstaculos[3].angularVelocity = 0

fisica.setGravity(0, 0)

--FIM FÍSICA 


-- MOVIMENTAÇÃO INIMIGOS 

local w,h = display.contentWidth, display.contentHeight
 
local function listener1( obj )
    print( "Transition 1 completed on object: " .. tostring( obj ) )
end
  
local function listener2( obj )
    print( "Transition 2 completed on object: " .. tostring( obj ) )
end

local function moveInimigo( e )
        transition.to(obstaculos[1], { time=5000, delay=500, alpha=1.0, y=2000, onComplete=moveInimigo}) 
        obstaculos[1].x = math.random(0,x)
        obstaculos[1].y = -100
end  
local function moveInimigo2( e )
        transition.to(obstaculos[2], { time=3000, delay=400, alpha=1.0, y=2000, onComplete=moveInimigo2}) 
        obstaculos[2].x = math.random(0,x)
        obstaculos[2].y = -100
end  
local function moveInimigo3( e )
        transition.to(obstaculos[3], { time=2000, delay=300, alpha=1.0, y=2000, onComplete=moveInimigo3}) 
        obstaculos[3].x = math.random(0,x)
        obstaculos[3].y = -100
end  
   moveInimigo()
   moveInimigo2()
   moveInimigo3()
--FIM MOVIMENTAÇÃO INIMIGOS 

-- COLISÕES
quantidade={}
quantidade[0] = 0
quantidade[1] = 0
quantidade[2] = 0
local function colisaoGlobal(e)
    if(e.phase == "began") then
        e.object2:setFillColor(1, 0, 0)

      tocaSom()


    elseif(e.phase == "ended") then
        e.object2:setFillColor(0, .5, 1)
    end
end
Runtime:addEventListener("collision", colisaoGlobal)
--FIM COLISÕES

--[[  MOVE COM DEDOS
local function ontouch( event )
	if (event.phase == "ended")then
    	transition.to(personagem[1],  { alpha=1.0,delay=50,x=event.x})
    	-- time=5000, delay=500, alpha=1.0,
    end
    if personagem[1].x < 50 then -- Esquerda
        personagem[1].x = 50
    elseif personagem[1].x > 270 then -- Direita
        personagem[1].x = x-50
    elseif personagem[1].y < 50 then -- Cima
        personagem[1].y = 50
    elseif personagem[1].y > 430 then -- Baixo
        personagem[1].y = y-50
    end
end
Runtime:addEventListener("touch",ontouch)
]]--


--MOVE COM ACCELEROMETER
local function heroMovex(event)
	personagem[1].x = personagem[1].x + (personagem[1].x*(event.xGravity*2))



    if personagem[1].x < 30 then -- Esquerda
        personagem[1].x = 30
    elseif personagem[1].x > 270 then -- Direita
        personagem[1].x = x-30
   end
end
 
Runtime:addEventListener("accelerometer", heroMovex)

