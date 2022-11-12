extends Node2D

var defaultSpeed = 3

var gameSpeed = defaultSpeed
var mainBallNumber = 0

func createRandomNumber(a, b):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(a, b)
	return my_random_number
