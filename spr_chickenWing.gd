extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed = 300
var target = Vector2(100, 100)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(dt):
	if target:
		var delta = target - position
		var movement = delta.normalized() * speed
		applied_force = movement
		#print("movement: " + str(movement))
		print(movement)