-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setDefault( "background", 100/255, 100/255, 200/255 )
math.randomseed( os.time() )

local instructions = display.newText( " Keep the ball in the air using the padddle until the timer hit 30", display.contentCenterX, display.contentCenterY - 50, native.systemFont, 13 )

local Title = display.newText( " Ball Bounce Game", display.contentCenterX, display.contentCenterY + 50, native.systemFont, 25 )



-- Gravity


local physics = require( "physics" )



physics.start()

physics.setGravity( 0 , 30 ) -- ( x, y )







local paddle = display.newImageRect( "/assets/sprites/paddle.png", 90, 20 )

paddle.x = 160

paddle.y = display.contentHeight

paddle.id = "the ground"

physics.addBody( paddle, "static", { 


	density = 2.0,

    friction = 0.5, 

    bounce = 1 

    } )

paddle.isFixedRotation = true


theBall = display.newImageRect( "/assets/sprites/ball.png", 75, 75 )

theBall.x = display.contentCenterX 

theBall.y = -30

theBall.id = "the character"

physics.addBody( theBall, "dynamic", { 

    density = 3, 

    friction = 0.5, 

    bounce = .5 

    } )
theBall.angularVelocity = math.randomseed(-10, 100)

theBall.isFixedRotation = true -- If you apply this property before the physics.addBody() command for the object, it will merely be treated as a property of the object like any other custom property and, in that case, it will not cause any physical change in terms of locking rotation.

local Ball = display.newImageRect( "/assets/sprites/ball.png", 50, 50 )

Ball.x = 200000000000

function balldrop (event)


		Ball = display.newImageRect( "/assets/sprites/ball.png", 50, 50 )

		Ball.x = display.contentCenterX + 150

		Ball.y = -200

		Ball.id = "the ball"

		physics.addBody( Ball, "dynamic", { 

    		density = 3, 

    		friction = 0.5, 

    		bounce = .75
		} )

		Ball.isFixedRotation = true

end

timer.performWithDelay(10500, balldrop )




 -- If you apply this property before the physics.addBody() command for the object, it will merely be treated as a property of the object like any other custom property and, in that case, it will not cause any physical change in terms of locking rotation.

local thirdBall = display.newImageRect( "/assets/sprites/ball.png", 50, 50 )
thirdBall.x = 200000000000
function thirdballdrop (event)


		thirdBall = display.newImageRect( "/assets/sprites/ball.png", 50, 50 )

		thirdBall.x = display.contentCenterX - 150

		thirdBall.y = -200

		thirdBall.id = "the thirdball"

		physics.addBody( thirdBall, "dynamic", { 

    		density = 3, 

    		friction = 0.5, 

    		bounce = 0.25
		} )

		thirdBall.isFixedRotation = true

end

timer.performWithDelay(20500, thirdballdrop )


local function paddletouch ( event )

	local paddletouched = event.target



        if (event.phase == "began") then

        	display.getCurrentStage():setFocus( paddletouched )



        	paddletouched.startMoveX = paddletouched.x



        elseif (event.phase == "moved") then

        		 paddletouched.x = (event.x - event.xStart) + paddletouched.startMoveX

 

        elseif event.phase == "ended" or event.phase == "cancelled"  then

        		display.getCurrentStage():setFocus( nil )

        		paddletouched.x = paddle.x

             

        end

                return true

end




local gravity = math.random(-10, 10)


-- if character falls off the end of the world, respawn back to where it came from
local timeLimit = 30
local currentTime = 0
local timerUpTimer

local currentTimeText = display.newText(currentTime, 160, 20, native.systemFontBold, 24)
currentTimeText:setTextColor(255,0,0)

local function timerUp()
    currentTime = currentTime + 1
    currentTimeText.text = currentTime

    if currentTime >= timeLimit then
        timer.cancel(timerUpTimer)
        instructions.text = "congratulations, you win"
        Runtime:removeEventListener( "enterFrame", checkBallPosition )

        
        Ball:removeSelf()
        Ball = nil
        thirdBall:removeSelf()
        thirdBall = nil
        theBall:removeSelf()
        theBall = nil
        


    end

end





timerUpTimer = timer.performWithDelay(1000, timerUp, 0)

function checkBallPosition( event )

    -- check every frame to see if character has fallen

    if theBall.y > display.contentHeight + 500 then

        instructions.text = "Game over "
        timer.cancel(timerUpTimer)
        Runtime:removeEventListener( "enterFrame", checkBallPosition )

        
        Ball:removeSelf()
		Ball = nil
		thirdBall:removeSelf()
		thirdBall = nil
		theBall:removeSelf()
		theBall = nil

        elseif Ball.y > display.contentHeight + 500 then

        instructions.text = "Game over "
        timer.cancel(timerUpTimer)
        Runtime:removeEventListener( "enterFrame", checkBallPosition )
  
        Ball:removeSelf()
		Ball = nil
		thirdBall:removeSelf()
		thirdBall = nil
		theBall:removeSelf()
		theBall = nil



        elseif thirdBall.y > display.contentHeight + 500 then

        instructions.text = "Game over "
        timer.cancel(timerUpTimer)
        Runtime:removeEventListener( "enterFrame", checkBallPosition )

        Ball:removeSelf()
		Ball = nil
		thirdBall:removeSelf()
		thirdBall = nil
		theBall:removeSelf()
		theBall = nil
		





     

    end

end

 





local function fastCollision( self, event )



    if ( event.phase == "began" ) then

        print( self.id .. ": collision began with " .. event.other.id )

       
    end
end  

local function Collision( self, event )



    if ( event.phase == "began" ) then

        print( self.id .. ": collision began with " .. event.other.id )


    end
end  

local function BallCollision( self, event )



    if ( event.phase == "began" ) then

        print( self.id .. ": collision began with " .. event.other.id )

        if event.other.id == "the ground" then

        

        end
    end
end  




local backgroundmusic = audio.loadStream( "./assets/bgm_action_4.mp3" )
local musicChannel = audio.play( backgroundmusic )

local SoundPlaying = 1



-- Music Pause Button

local mutebutton = display.newImageRect( "./assets/sprites/mute.png", 50, 50 )
	mutebutton.x = display.contentCenterX - 130
	mutebutton.y = 50

function mutebutton:tap( event )
	if SoundPlaying == 1 then
		audio.pause( backgroundmusic )
		SoundPlaying = 0
	elseif SoundPlaying == 0 then
		audio.play( backgroundmusic )
		SoundPlaying = 1
	else
		audio.play( backgroundmusic )
		SoundPlaying = 1
	end
end

mutebutton:addEventListener( 'tap', mutebutton )  



paddle:addEventListener("touch", paddletouch )

Runtime:addEventListener( "enterFrame", checkBallPosition )


theBall.collision = Collision

theBall:addEventListener( "collision" )


Ball.collision = fastCollision

Ball:addEventListener( "collision" )


thirdBall.collision = BallCollision

thirdBall:addEventListener( "collision" )


