extends Node2D

func _physics_process(delta):
	self.position.y += Global.gameSpeed

func _on_wallArea_area_entered(area):
	get_parent().get_parent().ballCollisionWall()
	get_node("wallArea").queue_free()
	#play sound
	get_node("wallCollisionSound").playing = true

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	get_parent().get_parent().createGameBundle()
