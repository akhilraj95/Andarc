
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.


    contW = display.contentWidth
    contH = display.contentHeight
    centerX = display.contentCenterX
    centerY = display.contentCenterY


 	    local myImage = display.newImage( "instruction.png" )
        myImage:translate( display.contentCenterX, display.contentCenterY*0.7 )
        sceneGroup:insert(myImage)



  	 -- /////////////////////////////////////////////////////////////////
     -- button for highscores
     --///////////////////////////////////////////////////////////////////
     		-- Function to handle button events
            local function handleHighscoreButtonEvent( event )
                if ( "ended" == event.phase ) then
                    composer.gotoScene( "mainmenu" ,"fade", 400)
                end
            end

            -- Create the widget
            local buttonhighscore = widget.newButton(
                {
                    label = "Return",
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
            buttonhighscore.y = display.contentCenterY*1.8

            -- Change the button's label text
            buttonhighscore:setLabel( "Return" )

            sceneGroup:insert(buttonhighscore)

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then

    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene