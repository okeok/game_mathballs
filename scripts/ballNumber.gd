extends Node2D

func _ready():
	get_node("text").text = Global.mainBallNumber as String

