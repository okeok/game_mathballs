extends Node2D


var screenWidth = 0 #initial variable of screen width
var screenHeight = 0 #initial variable of screen height

var wallNumber = 0 #number for wall without difficult coefficient
var wallNumberWithCoefficient = 0 #number for wall with difficult coefficient
var gameDifficult = 1 #difficult coefficient
var gameLevel = 0 #game level
var numberOfBalls = 10 #number of balls in one level
var numberOfStars = 0 #number of stars in one level
var ballsNumberBundle = [] #initial variable for balls numbers array 
var creatingBonusBalls = false #in the start of the game bonus balls doesn't create
			
###create environment###
func createEnvironment():
	get_node("background").rect_size.x = get_viewport().size.x
	get_node("background").rect_size.y = get_viewport().size.y
	
	for i in range(4):
		var windowWall = preload("res://sceense/stopWall.tscn").instance();
		match i:
			0: 
				windowWall.position.x = 0
				windowWall.position.y = 0
				windowWall.get_node('collision').scale.x = 100	
			1: 
				windowWall.position.x = 0
				windowWall.position.y = get_viewport().size.y
				windowWall.get_node('collision').scale.x = 100
			2: 
				windowWall.position.x = 0
				windowWall.position.y = 0
				windowWall.get_node('collision').scale.y = 100		
			3: 
				windowWall.position.x = get_viewport().size.x
				windowWall.position.y = 0
				windowWall.get_node('collision').scale.y = 100
		add_child(windowWall)
		
###create game objects###

#show restart screen
func restartGameScreen():
	get_tree().paused = true
	get_node("UI/restartBlock").visible = true
	#show score
	get_node("UI/restartBlock/score").text = 'Your score: ' + gameLevel as String + '!'
	#stop mainTheme music
	get_node("mainTheme").playing = false
	get_node("endOfGame").play()


#create wall
func createWall():
	var wall = preload("res://sceense/wall.tscn").instance()
	wall.position.y = -1000
	wall.position.x = 300
	get_node("gameObjects").add_child(wall)	
	
#create another balls
func createAnotherBall(number, positionX, positionY):
	var ballScene = preload("res://sceense/anotherBall.tscn");
	var ball = ballScene.instance()
	ball.position.x = positionX
	ball.position.y = positionY
	ball.number = number
	if ball.number < 0:
		ball.setBackground('cold')
	else:
		ball.setBackground('warm')
	get_node("gameObjects").add_child(ball)
	
#create star
func createStar(positionX, positionY):
	var starBlack = preload("res://sceense/starBlack.tscn").instance();
	starBlack.position.x = positionX
	starBlack.position.y = positionY
	get_node("gameObjects").add_child(starBlack)	
	
#create bonus ball
func createBonusBall():
	var bonusBall = preload("res://sceense/bonusBall.tscn").instance()
	bonusBall.position.y = -1000
	bonusBall.position.x = Global.createRandomNumber(40, 300)
	get_node("gameObjects").call_deferred("add_child", bonusBall)

#create level bundle
func createGameBundle():
	createWall()

	var positionGridArray = createPositionGrid()
				
	for number in ballsNumberBundle: #количество создания шаров
		var lengthOfPositionArray = positionGridArray.size() #длина массива позиций
		var keyOfPositionArray = Global.createRandomNumber(0, lengthOfPositionArray-1) #рандомный элемент массива позиций
		var objectPosition = positionGridArray[keyOfPositionArray] #значения рандомного элемента массива
		positionGridArray.remove(keyOfPositionArray) #удалить элемент из массива - чтобы он был уникальным
	
		createAnotherBall(number, objectPosition[0], objectPosition[1])
		
	if numberOfStars > 0: #если количество звезд > 0 то рендерим звезды
		for key in range(numberOfStars): #цикл для создания звезд в зависимости от количества звезд
			var lengthOfPositionArray = positionGridArray.size() #длина массива позиций
			var keyOfPositionArray = Global.createRandomNumber(0, lengthOfPositionArray-1) #рандомный элемент массива позиций
			var objectPosition = positionGridArray[keyOfPositionArray] #значения рандомного элемента массива
			createStar( objectPosition[0], objectPosition[1])
			
###another functions###

func updateNumberOfMainBall():
	get_node("numbers/HBoxContainer/playerNumber").text = Global.mainBallNumber as String
	
func gameLevelUp():
	gameLevel +=1
	get_node("UI/gameLevel").text = gameLevel as String
	
func createNewNumberForWall():
	wallNumber = Global.createRandomNumber(1, 10) #устновка цифры для прохода стены
	wallNumberWithCoefficient = wallNumber * gameDifficult;
	#тут нужен какой то скрипт более сложный для формирования номера стены например увеличения (ДОБАВИЛ КООФИЦЕНТ)
	get_node("numbers/HBoxContainer/wallNumber").text = wallNumberWithCoefficient as String

#create position grid for balls and stars
func spawnPositionX(length, number):
	var array = []
	for i in range(0, number):
		array.push_front((length/number)*i + 47) #add 47px for uniform distribution objects in window
	return array	
	
func spawnPositionY(length, number):
	var array = []
	for i in range(0, number):
		array.push_front(-200-(length - length/number*i - 47)) #add 47px for uniform distribution objects in window
	return array	
func createPositionGrid():
	var screenWidth = get_viewport().size.x
	#var screenHeight = get_viewport().size.y
	var spawnPositionXArray = spawnPositionX(screenWidth, 4)
	var spawnPositionYArray = spawnPositionY(700, 9)
	var spawnPositionGridArray = []
	for x in spawnPositionXArray:
		for y in spawnPositionYArray:
			spawnPositionGridArray.push_back([x, y])
	return spawnPositionGridArray
	
func makeGameDifficultyForEveryLevel():
	#create new number for wall
	createNewNumberForWall()

	#update game speed for every 10 levels
	if gameLevel%10 == 0 && gameLevel != 0:
		Global.gameSpeed += 1
	
	#update game difficult
	if gameLevel%5 == 0 && gameLevel != 0:
		gameDifficult += 1
	
	#start to create bonus balls from 20 level
	if gameLevel == 20:
		creatingBonusBalls = true
		
	#add stars to game from level == 10 for every 10 levels
	if gameLevel >= 10:
		if numberOfStars <= 5: #max numbers of stars is 5
			if gameLevel%10 == 0:
				numberOfStars += 1
				
	#creating balls numbers array. The maximum number of balls with a minus must be only half of the total number of balls
	ballsNumberBundle = []
	var tempMinusBalls = numberOfBalls/2
	if gameLevel/2 >= numberOfBalls/2:
		tempMinusBalls = numberOfBalls/2
	else:
		tempMinusBalls = gameLevel/2
	for ball in range(tempMinusBalls):
		ballsNumberBundle.push_front(Global.createRandomNumber(-10, -1) * gameDifficult)
	#minus one for ball with number of wallNumberWithCoefficient
	for ball in range(numberOfBalls - tempMinusBalls - 1):
		ballsNumberBundle.push_front(Global.createRandomNumber(1, wallNumber))
	# add one ball with number of wallNumberWithCoefficient
	ballsNumberBundle.push_front(wallNumberWithCoefficient) 
	
###colision functions###
func ballCollisionWall():
	if Global.mainBallNumber >= wallNumberWithCoefficient:
		Global.mainBallNumber = Global.mainBallNumber - wallNumberWithCoefficient #надо подумать надо ли сбрасывать цифру здесь (на ноль)
		updateNumberOfMainBall()
		gameLevelUp()
		makeGameDifficultyForEveryLevel()
		
		if creatingBonusBalls:
			#50% chance of creating bonus balls
			if Global.createRandomNumber(0, 1) == 1:
				createBonusBall()
	else: 
		restartGameScreen()

		
func ballCollisionStar():
	restartGameScreen()
	
###signals###
#restarn button
func _on_TextureButton_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	Global.gameSpeed = Global.defaultSpeed
	Global.mainBallNumber = 0

func _on_goToMainMenu_pressed():
	get_tree().change_scene("res://sceense/mainMenu.tscn")


###ready###
func _ready():
	#setting default values ​​for global variables
	Global.gameSpeed = Global.defaultSpeed
	Global.mainBallNumber = 0
	#functions
	makeGameDifficultyForEveryLevel()
	createEnvironment()
	createGameBundle()
	#start mainTheme music
	get_node("mainTheme").playing = true




