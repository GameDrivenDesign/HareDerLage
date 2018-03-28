extends RigidBody2D

var torque = 100
var speed = 20
var handling = 0

func _physics_process(delta):
	
	var angle = Vector2(0, 1).rotated(transform.get_rotation()).angle_to(linear_velocity)
		
	if Input.is_action_pressed("up"):
		applied_force = Vector2(0, speed + handling * abs(angle)).rotated(transform.get_rotation())
	else:
		applied_force = Vector2()
	
	if Input.is_action_pressed("left"):
		applied_torque = - torque
	elif Input.is_action_pressed("right"):
		applied_torque = torque
	else:
		applied_torque = 0