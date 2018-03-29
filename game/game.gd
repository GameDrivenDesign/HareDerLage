extends Node2D

func _ready():
	for i in range(1,10):
		spawn_chicken(i)

	$level/spaceship.connect("health_changed", $hud_layer/hud, "set_health_percentage")

func spawn_chicken(id):
	var chicken = preload("res://spr_chickenWing.tscn").instance()
	chicken.chicken_id = id
	
	$level.add_child(chicken)

func win():
	print('You have won!!')
	get_tree().paused = true
