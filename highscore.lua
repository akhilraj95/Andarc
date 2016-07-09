----------------------------------------------------------------------------------
--
-- highscore.lua
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
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	playgameMusic(gamebgmusic1)

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

		local highscore = load()

	contW = display.contentWidth
	contH = display.contentHeight
	centerX = display.contentCenterX
	centerY = display.contentCenterY


  local highscoreText = display.newText("Highscore", centerX,centerY-100, native.systemFont, 30 )
    highscoreText:setFillColor( 1, 1, 1 )
    sceneGroup:insert(highscoreText)

	local highscoreText = display.newText(highscore, centerX,centerY, native.systemFont, 50 )
    highscoreText:setFillColor( 1, 0, 0 )
    sceneGroup:insert(highscoreText)


	function QuitButtonEvent( event )
                 
                 resetMusic(gamebgmusic1)
                if ( "ended" == event.phase ) then
                    composer.gotoScene( "mainmenu" ,"fade", 400)
                end

    end

            -- Create the widget
            local exit = widget.newButton(
                {
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
            exit:setLabel( "Back" )
            sceneGroup:insert(exit)



	end	


--//////////////////////////////////////////////////////////////////////////////////////
--	function toreturn highscore
--//////////////////////////////////////////////////////////////////////////////////////
 
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