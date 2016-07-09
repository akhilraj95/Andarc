----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local raintimer, barriertimer , scoretimer

composer.recycleOnSceneChange = false

function scene:create( event )
	local sceneGroup = self.view
	-----------------------------------------------------------------------------------
	---music
	----------------------------------------------------------------------------------
	gamebgmusic = audio.loadSound ("mainmusic.mp3")

	musicisOn = true 

	audio.reserveChannels (1) -- one audio channel we need to reserve for the background music

	---------------------------------------------------------------------------------
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
   
    playgameMusic(gamebgmusic)

	composer.removeScene( "gameover" )
	system.activate( "multitouch" )

	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
-- Display constants 
contW = display.contentWidth
contH = display.contentHeight
centerX = display.contentCenterX
centerY = display.contentCenterY
local physics = require( "physics" )
physics.start() 


-- GAME VARIABLES 
ENEMY_SPAWN_RATE= 1000				-- rate of enemy generation
BARRIER_SPAWN_RATE= 3000			-- rate of static barrier generation

PLAYER_SCORE = 0					-- initial score
PLAYER_SCORE_UPDATE_RATE = 500	-- constant update frequency of the score

--///////////////////////////////////////////////////////////////////////
-- 	Tutorial System
	local options =
	{
    width = contW/2,
    height = contH,
	}

	local myImageshoot = display.newImage( "shoot_tutorial.png" ,options)
    myImageshoot:translate( contW*0.25, centerY )
    sceneGroup:insert(myImageshoot)

    local myImagemove = display.newImage( "move_tutorial.png" ,options)
    myImagemove:translate( contW*0.75, centerY )
    sceneGroup:insert(myImagemove)

    transition.fadeOut( myImagemove, { time=2000 } )
    transition.fadeOut( myImageshoot, { time=2000 } )
  
    local function removetutorial()
    	myImagemove:removeSelf()
    	myImageshoot:removeSelf()
    end

    tutorialtimer = timer.performWithDelay( 2000, removetutorial , 1)

--///////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////
--	Scoring System
--///////////////////////////////////////////////////////////////////////
local options = {
   text = "0",
   x = contW/2,
   y = 0,
   fontSize = 24,
   width = contW,
   height = 30,
   align = "center"
}
 
scoreText = display.newText( options )
scoreText:setFillColor( 1, 1, 1)

sceneGroup:insert(scoreText)

level = 0
lvlcnt = 0
local function scoreUpdate()
	PLAYER_SCORE = PLAYER_SCORE + 10
	scoreText.text = PLAYER_SCORE
	-- changing difficulty
	if(PLAYER_SCORE > level + 500) then
		lvlcnt = lvlcnt + 1
		level = PLAYER_SCORE
		ENEMY_SPAWN_RATE = ENEMY_SPAWN_RATE - 50
		BARRIER_SPAWN_RATE = BARRIER_SPAWN_RATE - 50
	    display.setDefault("background",math.random(5)/10,math.random(5)/10,math.random(5)/10)
		local level = display.newText("level - "..lvlcnt, centerX,centerY, native.systemFont, 30 )
	    level:setFillColor( 1, 1, 1 )
	    sceneGroup:insert(level)
	   transition.fadeOut( level, { time=2000 } )
	end
end

-- local function scoreTextHighlight2()
-- 	s:setFillColor( 1, 1, 1)
--    	transition.to(scoreText,{time=200,xScale=1,yScale=1})
-- -- end
-- local function scoreTextHighlight()
-- 	scoreText:setFillColor( 1, 0, 0)
--    	transition.to(scoreText,{time=200,xScale=1.2,yScale=1.2,onComplete=scoreTextHighlight2})
-- end


scoretimer = timer.performWithDelay( PLAYER_SCORE_UPDATE_RATE , scoreUpdate , 100000)

-- ////////////////////////////////////////////////////////////////////////
-- Character
--  	player - circle (temp)
-- 		looped animation functions 
-- 				moveright()
--				moveleft()
--////////////////////////////////////////////////////////////////////////


local player = display.newCircle( contW*1/15, contH*9.5/10, 20)
speed = 0.3

local gradient = {
    type="gradient",
    color1={ 1, 1, 1 }, color2={0.9,0.9,0.9 }, direction="down"
    }
player:setFillColor(gradient )

sceneGroup:insert(player)

physics.addBody(player)
player.bodyType = "dynamic"
player.gravityScale = 0

local function gameover( self, event )
    
    if ( event.phase == "began" ) then
    	physics.pause()
	   display.setDefault("background",0,0,0)
    	local options = { "fade", 400,params = { score = PLAYER_SCORE } }
		composer.gotoScene("gameover", options)

    end
end
player.collision = gameover
player:addEventListener( "collision", player)

dirconstant= 1
function moveright()
	dirconstant =0

	local times = 1 * (player.x -(contW*14/15)) / speed 
	if(times<0) then 
		times = times * -1
	end
	print(times)
	transition.to( player, { x=contW*14/15 , time = times } )	
end

function moveleft()
	dirconstant = 1
	local times = 1 * (player.x -(contW*1/15)) / speed 
	if(times<0) then 
		times = times * -1
	end
	print(times)
	transition.to( player, { x=contW*1/15, time = times} )	
end



-- ////////////////////////////////////////////////////////////////////////
-- Control Logic
--  	dirbutton 
-- 		shootbutton 
--////////////////////////////////////////////////////////////////////////

local dirbutton = display.newRect( contW*3/4, contH/2, contW/2, contH)
local shootbutton = display.newRect( contW/4, contH/2, contW/2, contH )

sceneGroup:insert(dirbutton)
sceneGroup:insert(shootbutton)

dirbutton.alpha  = 0.0
dirbutton.isHitTestable = true


shootbutton.alpha  = 0.0 
shootbutton.isHitTestable = true


local function onBulletCollision( self, event )
    if ( event.phase == "began" ) then
    	self:removeSelf()
    end
end

local function ShootEvent( event )
	print( "ShootEvent ")
    print( "Phase: "..event.phase )
    print( "Location: "..event.x..","..event.y )
    print( "Unique touch ID: "..tostring(event.id) )
    print( "----------" )
    if(event.phase=="began") then
	       local bullet = display.newCircle( player.x,player.y-40, 5)
		  sceneGroup:insert(bullet)
	      physics.addBody( bullet, "dynamic", { radius=5 } )
	      bullet.gravityScale = 0
	    --Make the object a "bullet" type object
	      bullet.isBullet = true
	      bullet:setLinearVelocity( 0,-200 )
	      bullet.collision = onBulletCollision
	      bullet:addEventListener( "collision", bullet )

    end
     return true
end


local function DirEvent( event )
-- 	change the direction
	if(event.phase == "ended") then
		if(dirconstant == 0) then 
			transition.cancel(player)
			moveleft()
		else
			transition.cancel(player)
			moveright()
		end
	end
	print( "DirEvent ")
    print( "Phase: "..event.phase )
    print( "Location: "..event.x..","..event.y )
    print( "Unique touch ID: "..tostring(event.id) )
    print( "----------" )
    return true
end




shootbutton:addEventListener( "touch", ShootEvent )
dirbutton:addEventListener( "touch", DirEvent )

--//////////////////////////////////////////////////////////////////////////
--randomly generated objects
--/////////////////////////////////////////////////////////////////////////

local function onLocalCollision( self, event )
    
    if ( event.phase == "began" ) then
    	self:removeSelf()				-- removing the object 
    	PLAYER_SCORE = PLAYER_SCORE + 100
    	scoreText.text = PLAYER_SCORE
    	--scoreTextHighlight()
    end
end

rainFall = function()
	rainDrop = display.newRect(math.random(contW),0,20,20)
	sceneGroup:insert(rainDrop)
	physics.addBody(rainDrop)
	rainDrop.gravityScale = 0 
	rainDrop:setLinearVelocity( 0,100 )
	rainDrop.collision = onLocalCollision
	rainDrop:addEventListener( "collision", rainDrop )


	local gradient = {
    type="gradient",
    color1={ 1, 1, 1 }, color2={ 0.7,0.7,0.7 }, direction="down"
    }
	rainDrop:setFillColor(gradient )

end
 

-- Call that rainfall function
-- 0.1 => Time interval to call the function each time, rainFall => function name, 10000 => Number of times, the function will be called
raintimer = timer.performWithDelay( ENEMY_SPAWN_RATE,  rainFall, 100000 )

--///////////////////////////////////////////////////////////////////////
--barrier fall
--//////////////////////////////////////////////////////////////////////

barrierFall = function()
	local temp1 = math.random(2)
	print("temp1- ",	temp1)
		local w = math.random(contW*0.5)
		local h = 40
	if(temp1 == 1) then 
		barrierDrop = display.newRect(w/2,0,w,h)
	else 
		barrierDrop = display.newRect(contW-(w/2),0,w,h)
	end

	sceneGroup:insert(barrierDrop)
	physics.addBody(barrierDrop)
	barrierDrop.bodyType = "kinematic"
	barrierDrop.gravityScale = 0
	barrierDrop:setLinearVelocity( 0,100 )


	local gradient = {
    type="gradient",
    color1={ 1, 1, 1 }, color2={ 0.7,0.7,0.7 }, direction="down"
	}
	barrierDrop:setFillColor( gradient )
end
barriertimer = timer.performWithDelay( BARRIER_SPAWN_RATE,  barrierFall, 100000 )




	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		timer.cancel(raintimer)
		raintimer = nil 

		timer.cancel(barriertimer)
		barriertimer = nil

		timer.cancel(scoretimer)
		scoretimer = nil 

		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	resetMusic(gamebgmusic)
end


function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

--------------------------------------------------------------------------------
--music function--
--------------------------------------------------------------------------------
 function playgameMusic (gamebgmusic)
 
     if musicisOn == true then 
     audio.play (gamebgmusic, {channel = 1, loops = -1 , fadein=2500})
     end
 end

function resetMusic (gamebgmusic)
 
    if musicisOn == true then 
        audio.stop(1)
      audio.rewind (gamebgmusic)
     end
 end

function pauseMusic (gamebgmusic)
  if musicisOn == true then 
  audio.pause()
end
end
 
function resumeMusic (channel)
  if musicisOn == true then 
  audio.resume(channel)
end
end



---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene