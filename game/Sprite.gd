

var proj_speed = 10

func _ready():
	linear_velocity = Vector2(0, proj_speed).rotated(transform.get_rotation())
