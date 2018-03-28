extends KinematicBody2D


var proj_speed = 1
var direction
var proj_damage = 10

func _ready():
	direction = Vector2(0, proj_speed).rotated(transform.get_rotation())

	
func _physics_process(delta):
	var collided = move_and_collide(direction)
	if collided:
		#preload("res://______________________.tscn").instance() ->hier könnte eine Explosion gespawnt werden
		if collided.collider.has_method("take_damage"):
			collided.collider.take_damage (proj_damage)
			#preload("res://spr_chickenWing.tscn").instance() ->hier könnte eine Explosion gespawnt werden
			#queue_free()