----------------------------------------------------------------------------------
--
-- gameover.lua
--
----------------------------------------------------------------------------------
local widget = require( "widget" ) 
local composer = require( "composer" )
local scene = composer.newScene()
composer.recycleOnSceneChange = false

-----------------------------------------------------------------------------------
---music
----------------------------------------------------------------------------------
gamebgmusic1 = audio.loadSound ("gameovermusic.mp3")

musicisOn = true 

audio.reserveChannels (1) -- one audio channel we need to reserve for the background music


---------------------------------------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view
	
	composer.removeScene( "maingame" )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	playgameMusic(gamebgmusic1)

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		SCORE = event.params.score

		local highscore = load()

		if(highscore) then 
			if(highscore < SCORE) then
				save(SCORE)
				highscore = SCORE
			end
		else
			save(SCORE)
			highscore = SCORE
		end


	contW = display.contentWidth
	contH = display.contentHeight
	centerX = display.contentCenterX
	centerY = display.contentCenterY


	local highscoreText = display.newText( "highscore : "..highscore, centerX,centerY-100, native.systemFont, 30 )
    highscoreText:setFillColor( 1, 1, 1 )
    sceneGroup:insert(highscoreText)


	local scoreText = display.newText( SCORE, centerX,centerY, native.systemFont, 60 )
    scoreText:setFillColor( 1, 1, 1 )

    sceneGroup:insert(scoreText)

    local function scoreTextHighlight2()
	scoreText:setFillColor( 1, 1, 1)
   	transition.to(scoreText,{time=200,xScale=1,yScale=1})
	end
	local function scoreTextHighlight()
		scoreText:setFillColor( 1, 0, 0)
	   	transition.to(scoreText,{time=200,xScale=1.5,yScale=1.5,onComplete=scoreTextHighlight2})
	end

	scoreTextHighlight()


	function QuitButtonEvent( event )
                 
                 resetMusic(gamebgmusic1)
                if ( "ended" == event.phase ) then
                    composer.gotoScene( "mainmenu" ,"fade", 400)
                end

    end

            -- Create the widget
            local exit = widget.newButton(
                {
                    label = "highscores",
                    onEvent = QuitButtonEvent,
                    emboss = false,
                    -- Properties for a rounded rectangle button
                    shape = "roundedRect",
                    width = 200,
                    height = 40,
                    cornerRadius = 1,
                    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0 } },
                    fillColor = { default={0,0,0,1}, over={1,1,1,1} },
                    strokeColor = { default={1,1,1,1}, over={0,0,0,1} },
                    strokeWidth = 4
                }
            )

    sceneGroup:insert(exit);

            -- Center the button
            exit.x = display.contentCenterX 
            exit.y = contH - 40

            -- Change the button's label text
            exit:setLabel( "Exit" )
            sceneGroup:insert(exit)


    function ReplayButtonEvent( event )

                if ( "ended" == event.phase ) then
                    composer.gotoScene( "maingame" ,"fade", 400)
                end
                resetMusic(gamebgmusic1)
    end

            -- Create the widget
            local ReplayButton = widget.newButton(
                {
                    label = "Replay",
                    onEvent = ReplayButtonEvent,
                    emboss = false,
                    -- Properties for a rounded rectangle button
                    shape = "roundedRect",
                    width = 200,
                    height = 40,
                    cornerRadius = 1,
                    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0 } },
                    fillColor = { default={0,0,0,1}, over={1,1,1,1} },
                    strokeColor = { default={1,1,1,1}, over={0,0,0,1} },
                    strokeWidth = 4
                }
            )


            -- Center the button
            ReplayButton.x = display.contentCenterX 
            ReplayButton.y = contH - 120

            -- Change the button's label text
            ReplayButton:setLabel( "Replay" )
            sceneGroup:insert(ReplayButton)        

	end	


--//////////////////////////////////////////////////////////////////////////////////////
--	function to save and return highscore
--//////////////////////////////////////////////////////////////////////////////////////
function save(scorevalue)
   local path = system.pathForFile( "score.txt", system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( scorevalue )
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not read score.txt", "." )
      return false
   end
end
 
function load()
   local path = system.pathForFile( "score.txt", system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- Read all contents of file into a string
      local contents = file:read( "*a" )
      local score = tonumber(contents);
      io.close( file )
      return score
   else
      print( "Error: could not read scores from score.txt", "." )
   end
   return nil
end

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
  resetMusic(gamebgmusic1)
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
 function playgameMusic (gamebgmusic1)
 
     if musicisOn == true then 
     audio.play (gamebgmusic1, {channel = 1, loops = -1 , fadein=2500})
     end
 end

function resetMusic (gamebgmusic1)
 
    if musicisOn == true then 
        audio.stop(1)
      audio.rewind (gamebgmusic1)
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