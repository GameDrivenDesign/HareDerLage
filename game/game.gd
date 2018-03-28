extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	spawn_chicken(Vector2(600, 500))

func spawn_chicken(pos):
	var chicken = preload("res://spr_chickenWing.tscn").instance()
	chicken.position = pos
	chicken.player = $spaceship
	
	add_child(chicken)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
