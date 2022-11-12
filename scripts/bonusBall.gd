extends Node2D

var typeOfBallArray = ['÷', '×']
var numberOfBonus
var typeOfBall

func _physics_process(delta):
	self.position.y += Global.gameSpeed+2

func _on_setBonusBall_area_entered(area):
	#calculation main ball number depending on the type of ball
	if(area.name == 'getBalls'):
		if typeOfBall == '÷':
			Global.mainBallNumber = Global.mainBallNumber / numberOfBonus
		if typeOfBall == '×':
			Global.mainBallNumber = Global.mainBallNumber * numberOfBonus
		get_parent().get_parent().updateNumberOfMainBall()
		
		get_node("bonusBallSound").playing = true
		#make ball invisible and delete area node for playing sound of collision
		get_node("setBonusBall/CollisionShape2D").queue_free()
		self.visible = false

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	
func _ready():
	typeOfBall = typeOfBallArray[Global.createRandomNumber(0, 1)] #choice type of bonus ball
	numberOfBonus = Global.createRandomNumber(2, 3)
	get_node("text").text = typeOfBall + String(numberOfBonus)
