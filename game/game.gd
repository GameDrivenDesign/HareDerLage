extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	spawn_chicken(1)
	spawn_chicken(2)

func spawn_chicken(id):
	var chicken = preload("res://spr_chickenWing.tscn").instance()
	#chicken.position = pos
	chicken.player = $spaceship
	chicken.chicken_id = id
	
	add_child(chicken)

func win():
	print('You have won!!')
	get_tree().paused = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
