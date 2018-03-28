extends RigidBody2D

var speed = 80
var super_fuel = 100
var player = null
var target = null
var old_delta = Vector2(0.0, 0.0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(dt):
	if super_fuel < 100:
		super_fuel += 1
	if target:
		var delta = target.position - position
		var movement = delta.normalized() * speed
		applied_force = movement
		if (linear_velocity.length() > 200 && (delta.length() - old_delta.length()) > 5):
			apply_impulse(Vector2(0,0), - linear_velocity/2)
		rotation = (target.position - position).angle()
		print(delta)
		old_delta = delta
	else:
		var follow = get_node("../Path2D/PathFollow2D")
		follow.loop = true
		follow.cubic_interp = true
		follow.rotate = true
		follow.offset += speed * dt
		var start = position
		position = get_node("../Path2D").position + follow.position
		rotation = follow.rotation

func _on_vision_area_body_entered(body):
	if body is preload("res://spaceship.gd"):
		target = player
