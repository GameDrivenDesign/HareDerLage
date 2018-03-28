extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed = 150
var target = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(dt):
	if target:
		var delta = target.position - position
		var movement = delta.normalized() * speed
		applied_force = movement