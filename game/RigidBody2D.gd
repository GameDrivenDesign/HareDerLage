extends RigidBody2D

var proj_speed = 100

func _ready():
	linear_velocity = Vector2(0, proj_speed).rotated(transform.get_rotation())
	
