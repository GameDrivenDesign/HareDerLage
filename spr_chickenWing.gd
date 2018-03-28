extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed = 50
var player = null
var target = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(dt):
	#if target:
	#	var delta = target.position - position
	#	var movement = delta.normalized() * speed
	#	applied_force = movement
	var follow = get_node("../Path2D/PathFollow2D")
	follow.loop = true
	follow.cubic_interp = true
	follow.rotate = true
	follow.offset += speed * dt
	var start = position
	position = get_node("../Path2D").position + follow.position
	rotation = follow.rotation - PI / 2