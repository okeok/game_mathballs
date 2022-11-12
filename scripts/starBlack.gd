extends Node2D

func _on_getDmg_area_entered(area):
	if(area.name == 'getStar'):
		get_parent().get_parent().ballCollisionStar()

func _physics_process(delta):
	self.position.y += Global.gameSpeed
