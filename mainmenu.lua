----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

composer.recycleOnSceneChange = false


-----------------------------------------------------------------------------------
---music
----------------------------------------------------------------------------------
gamebgmusic = audio.loadSound ("Game-Menu_v001.mp3")

musicisOn = true 

audio.reserveChannels (1) -- one audio channel we need to reserve for the background music

---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view


            local myImage = display.newImage( "andarc.png" )
            myImage:translate( display.contentCenterX, display.contentCenterY*0.40 )
            sceneGroup:insert(myImage)


                -- Function to handle button events
            local function handleButtonEvent( event )

                if ( "ended" == event.phase ) then
                    composer.gotoScene( "maingame" ,"fade", 400)
                end
            end

            -- Create the widget
            local buttonplay = widget.newButton(
                {
                    label = "Play",
                    onEvent = handleButtonEvent,
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
            buttonplay.x = display.contentCenterX
            buttonplay.y = display.contentCenterY

            -- Change the button's label text
            buttonplay:setLabel( "Play" )

            sceneGroup:insert(buttonplay)
            -- /////////////////////////////////////////////////////////////////
            -- button for highscores
            --///////////////////////////////////////////////////////////////////
            -- Function to handle button events
            local function handleHighscoreButtonEvent( event )

                if ( "ended" == event.phase ) then
                    composer.gotoScene( "highscore" ,"fade", 400)
                end
            end

            -- Create the widget
            local buttonhighscore = widget.newButton(
                {
                    label = "Highscore",
                    onEvent = handleHighscoreButtonEvent,
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
            buttonhighscore.x = display.contentCenterX 
            buttonhighscore.y = display.contentCenterY + 60

            -- Change the button's label text
            buttonhighscore:setLabel( "Highscore" )

            sceneGroup:insert(buttonhighscore)

            --/////////////////////////////////////////////////////////////////////
            -- button for exit
            --/////////////////////////////////////////////////////////////////////

            local function handleInstrButtonEvent( event )

                if ( "ended" == event.phase ) then
                    composer.gotoScene( "instruction" ,"fade", 400)
                end
            end

            -- Create the widget
            local instr = widget.newButton(
                {
                    label = "highscores",
                    onEvent = handleInstrButtonEvent,
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
            instr.x = display.contentCenterX 
            instr.y = display.contentCenterY + 120

            -- Change the button's label text
            instr:setLabel( "Instruction" )
            sceneGroup:insert(instr)


            --/////////////////////////////////////////////////////////////////////
            -- button for exit
            --/////////////////////////////////////////////////////////////////////

            local function handleExitButtonEvent( event )

                if ( "ended" == event.phase ) then
                   native.requestExit()
                end
            end

            -- Create the widget
            local exit = widget.newButton(
                {
                    label = "highscores",
                    onEvent = handleExitButtonEvent,
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
            exit.x = display.contentCenterX 
            exit.y = display.contentCenterY + 180

            -- Change the button's label text
            exit:setLabel( "Exit" )
            sceneGroup:insert(exit)




end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.

       playgameMusic(gamebgmusic)
             

    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)

     resetMusic(gamebgmusic)
                
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view
    
    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc.
end


--------------------------------------------------------------------------------
--music function--anvitha---
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

