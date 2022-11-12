extends Node2D

var number = 5
var colisionAnotherBall = false

#preload textures 
var coldBg = preload("res://imgs/cold.png")
var warmBg = preload("res://imgs/warm.png")

func _physics_process(delta):
	self.position.y += Global.gameSpeed

func setBackground(color):
	if color == 'warm':
		get_node("Sprite").texture = warmBg
	if color == 'cold':
		get_node("Sprite").texture = coldBg

func _on_setBall_area_entered(area):
	if area.name != 'setBall' && area.name != 'setBonusBall':
		Global.mainBallNumber += number
		get_parent().get_parent().updateNumberOfMainBall()
		if number >= 0:
			get_node("plusSound").playing = true
		else:
			get_node("minusSound").playing = true
			
		#make ball invisible and delete area node for playing sound of collision
		get_node("setBall").queue_free()
		self.visible = false
			
func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	
func _ready():
	#remove minus sign from label
	if number < 0: 
		var tempNumber = number*-1
		get_node("number").text = tempNumber as String
	else: 
		get_node("number").text = number as String


