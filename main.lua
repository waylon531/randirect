function love.load()
	level="game"
	tile = love.graphics.newImage("img/tile.png")
	block = love.graphics.newImage("img/block.png")
	character = love.graphics.newImage("img/character.png")
	arrow = love.graphics.newImage("img/arrow.png")
	fire = love.graphics.newImage("img/fire.png")
	rng = love.math.newRandomGenerator()
	direction = rng:random(4) --1 is down, 2 is left, 3 is up, 4 is right
	arrowX = arrow:getWidth()/2
	arrowY = arrow:getHeight()/2
	love.graphics.setBackgroundColor( 0, 0, 0 )
	windowWidth=love.graphics.getWidth()/2
	spriteY=16
	spriteX=16
	windowHeight=love.graphics.getHeight()
	numberOfTiles=math.ceil(windowHeight/spriteY)+1
	spriteBatch = love.graphics.newSpriteBatch( tile, 100 )
	updateSpritebatch(spriteBatch,0)
	time = love.timer.getTime()
	i=0
	characterY=windowHeight/2
	time4 = love.timer.getTime()
end
function love.draw()
	if level=="game" then
		love.graphics.draw(arrow,windowWidth+30,characterY+8,math.pi*direction/2,2,2,arrowX,arrowY)
		--love.graphics.print(direction)
		love.graphics.print(time3,20,100)
		--love.graphics.print(i,20,200)
		love.graphics.draw(spriteBatch)
		love.graphics.draw(character,windowWidth-7,characterY)
	else
		love.graphics.print("GAME OVER",windowWidth,windowHeight/2)
	end
end
function love.keypressed( key, isrepeat )
	if direction == 1 then
		neededKey="down"
	elseif direction == 2 then
		neededKey="left"
	elseif direction == 3 then
		neededKey="up"
	else
		neededKey="right"
	end
	if key == neededKey then
		direction = rng:random(4)
		characterY=characterY-4
	else
		characterY=characterY+4
	end
end
function love.update(dt)
	time2 = love.timer.getTime() - time
	time3 = love.timer.getTime() - time4
		if time2 >= .2 then
			updateSpritebatch(spriteBatch,i)
			characterY=characterY+1
			if i>1 then
				i=0
			end
			i=i+1	
			time = love.timer.getTime( )
		end
	if characterY>windowHeight then
		level="end"
	end
end
function updateSpritebatch(spriteBatch,translation)
	spriteBatch:bind()
	spriteBatch:clear()
	for x=0,numberOfTiles do
		spriteBatch:add(windowWidth-8,16*x-16+translation)
	end
	spriteBatch:unbind()
end
