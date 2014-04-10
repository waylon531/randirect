core=require "core"
function love.load()
	xMod=1
	yMod=1
	xRes=800
	yRes=600
	love.window.setMode(800, 600, {resizable=true})
	red=255
	textEnterable=true
	insert=0
	text=""
	love.window.setTitle("randir")
	level="menu"
	tile = love.graphics.newImage("img/conveyor.png")
	character = love.graphics.newImage("img/character2.png")
	arrow = love.graphics.newImage("img/arrow.png")
	bigArrow = love.graphics.newImage("img/bigarrow.png")
	bigGreenArrow = love.graphics.newImage("img/biggreenarrow.png")
	rng = love.math.newRandomGenerator()
	direction = rng:random(4) --1 is down, 2 is left, 3 is up, 4 is right
	bigDirection = rng:random(4)
	whichArrow = rng:random(2) --1 for smaller arrow, 2 for bigger arrow
	arrowX = arrow:getWidth()/2
	arrowY = arrow:getHeight()/2
	bigArrowX = bigArrow:getWidth()/2
	bigArrowY = bigArrow:getHeight()/2
	love.graphics.setBackgroundColor( 0, 0, 0 )
	windowWidth=love.graphics.getWidth()/2
	spriteY=32
	spriteX=32
	windowHeight=love.graphics.getHeight()
	numberOfTiles=math.ceil(windowHeight/spriteY)+1
	spriteBatch = love.graphics.newSpriteBatch( tile, 100 )
	updateSpritebatch(spriteBatch,0)
	time = love.timer.getTime()
	characterY=windowHeight/2
	i=0
	time4 = love.timer.getTime()
	difficulty=.2
	font = love.graphics.newFont(12)
	highscore=false
	player="waylon531"
end
function love.resize(w,h)
	windowWidth=love.graphics.getWidth()/2
	windowHeight=love.graphics.getHeight()
	numberOfTiles=math.ceil(windowHeight/spriteY)+1
	--love.graphics.scale(w/xRes,h/yRes)
	print(xRes,yRes,w/xRes,h/yRes)
	xMod=w/xRes
	yMod=h/yRes
	--xRes=w
	--yRes=h
	--print(xRes,yRes)
end
function love.draw()
	love.graphics.scale(xMod,yMod)
	if level=="game" then
		love.graphics.print(time3,20,100)
	end
	love.graphics.translate(xMod*-350+350,yMod*-350+350)
	if level=="game" then
		love.graphics.draw(arrow,windowWidth+50,characterY+16,math.pi*direction/2,1,1,arrowX,arrowY)
		if whichArrow==1 then
			love.graphics.draw(bigArrow,windowWidth+50,characterY+16,math.pi*bigDirection/2,2,2,bigArrowX,bigArrowY)
		else
			love.graphics.draw(bigGreenArrow,windowWidth+50,characterY+16,math.pi*bigDirection/2,2,2,bigArrowX,bigArrowY)
		end
		--love.graphics.print(direction)
		--love.graphics.print(i,20,200)
		love.graphics.draw(spriteBatch)
		love.graphics.draw(character,windowWidth-16,characterY)
		--love.graphics.print(difficulty-1/(characterY-20)-.05/(1+math.exp(-time3+50)))
	elseif level=="end" then
		love.graphics.print("GAME OVER",windowWidth-60,windowHeight/2-200)
		love.graphics.print(oldscore,windowWidth-font:getWidth(oldscore)/2-20,windowHeight/2-170)
		for i, v in ipairs(csv) do 
			if (i % 2 == 0) then
				x=windowWidth+30
				if v==4 then
					if red == 255 then
						love.graphics.setColor( 255, 0, 0)
					else
						love.graphics.setColor( 255, 255, 255)
					end
					v=text
					if text=='' then
						love.graphics.setColor( 255, 0, 0)
						v="Enter name:"
					end
				end
			else
				x=windowWidth-90
			end
			love.graphics.print(v,x,math.ceil(i/2)*20+150)
			love.graphics.setColor( 255, 255, 255)
		end
		love.graphics.setColor( 255, 200, 255)
		love.graphics.rectangle("fill", windowWidth-70, windowHeight/2-20, 100, 40 )
		love.graphics.rectangle("fill", windowWidth-70, windowHeight/2+60, 100, 40 )
		love.graphics.setColor( 0, 0, 0)
		love.graphics.print("Normal Mode",windowWidth-60,windowHeight/2-7)
		love.graphics.print("INSANE MODE!!!",windowWidth-70,windowHeight/2+73)
		love.graphics.setColor( 255, 255, 255)
	elseif level=="menu" then
		love.graphics.setColor( 255, 200, 255)
		love.graphics.rectangle("fill", windowWidth-70, windowHeight/2-20, 100, 40 )
		love.graphics.rectangle("fill", windowWidth-70, windowHeight/2+60, 100, 40 )
		love.graphics.setColor( 0, 0, 0)
		love.graphics.print("Normal Mode",windowWidth-60,windowHeight/2-7)
		love.graphics.print("INSANE MODE!!!",windowWidth-70,windowHeight/2+73)
		love.graphics.setColor( 255, 255, 255)
		--love.graphics.print("Enter Your name:",windowWidth-80, 100)
		--love.graphics.print(text,windowWidth-80, 120)
	end
end
function love.keypressed( key, isrepeat )
	if level=="end" then
		if key =="backspace" then
			text=string.sub(text, 1, string.len(text)-1)
		end
	end
	if key == 'return' then
		if textEnterable == false then
			textEnterable=true
			red=255
		else
			textEnterable=false
			red=0
		end
	end
	if whichArrow ==1 then
		neededDirection=direction
	else
		neededDirection=bigDirection
	end	
	if 	neededDirection == 1 then
		neededKey="down"
	elseif neededDirection == 2 then
		neededKey="left"
	elseif neededDirection == 3 then
		neededKey="up"
	else
		neededKey="right"
	end
	if key == neededKey then
		direction = rng:random(4)
		bigDirection = rng:random(4)
		whichArrow = rng:random(2)
		characterY=characterY-4
	else
		characterY=characterY+4
	end
end
function love.update(dt)
	if level=="game" then
		time2 = love.timer.getTime() - time
		time3 = love.timer.getTime() - time4
		if time2 >= difficulty-1/(characterY-20)-.05/(1+math.exp(-time3+50)) then
			updateSpritebatch(spriteBatch,i)
			characterY=characterY+1
			if i>7 then
				i=0
			end
			i=i+1	
			time = love.timer.getTime( )
		end
	end
	if characterY>windowHeight then
		score,oldscore=time3,time3
		level="end"
		text=""
		textEnterable=true
		--print("gameover")
		characterY=windowHeight-10000000
		if difficulty==.2 then
			contents= love.filesystem.read("highscores.csv")
		else
			contents= love.filesystem.read("highscoresdifficult.csv")
		end
		csv = core.ParseCSVLine(contents)
		for i, v in ipairs(csv) do 
			if (i % 2 == 0) then
			else
				--print(":")
				--print(score)
				--print(v)
				--print(":")
				if tonumber(score) > tonumber(v) and highscore==false then
					--print(score)
					--print(v)
					highscore=true
					insert=i+1
					table.insert(csv,i,core.round(score,6))
					table.insert(csv,i+1,4)
					table.remove(csv)
					table.remove(csv)
					score=v
					if csv[10]==nil then
						csv[10]="waylon"
					end
				end
			end
		end
		if difficulty==.2 then
			love.filesystem.write("highscores.csv",core.toCSV(csv))
		else
			love.filesystem.write("highscoresdifficult.csv",core.toCSV(csv))
		end
	end
end
function love.mousepressed(x, y, button)
	if button == "l" then
		if level ~= "game" and y>windowHeight/2-20 and y<windowHeight/2+20 then
			if x>windowWidth-70 and x<windowWidth+30 then
				if level =="end" and highscore==true then
					csv[insert]=text
					if difficulty==.2 then
						love.filesystem.write("highscores.csv",core.toCSV(csv))
					else
						love.filesystem.write("highscoresdifficult.csv",core.toCSV(csv))
					end
					highscore=false
				end
				level="game"
				characterY=windowHeight/2
				time = love.timer.getTime()
				time4 = love.timer.getTime()
				difficulty=.2
			end
		elseif level ~= "game" and y>windowHeight/2+60 and y<windowHeight/2+100 then
			if x>windowWidth-70 and x<windowWidth+30 then
				if level =="end" and highscore==true then
					csv[insert]=text
					if difficulty==.2 then
						love.filesystem.write("highscores.csv",core.toCSV(csv))
					else
						love.filesystem.write("highscoresdifficult.csv",core.toCSV(csv))
					end
					highscore=false
				end
				level="game"
				characterY=windowHeight/2
				time = love.timer.getTime()
				time4 = love.timer.getTime()
				difficulty=.1
			end
		end
	end
end
function love.quit()
	if level=='end' and highscore==true then
		csv[insert]=text
		if difficulty==.2 then
			love.filesystem.write("highscores.csv",core.toCSV(csv))
		else
			love.filesystem.write("highscoresdifficult.csv",core.toCSV(csv))
		end
		highscore=false
	end
end
function love.textinput(t)
	if textEnterable==true then
		text = text .. t
	end
end
function updateSpritebatch(spriteBatch,translation)
	spriteBatch:bind()
	spriteBatch:clear()
	for x=0,numberOfTiles do
		spriteBatch:add(windowWidth-16,32*x-32+translation)
	end
	spriteBatch:unbind()
end
