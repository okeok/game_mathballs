extends KinematicBody2D

var speed = 1200 
var velocity = Vector2()
onready var target = position

func _physics_process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		target = get_global_mouse_position()
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		velocity = move_and_slide(velocity)

