extends RigidBody2D

var damage = 5
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

func _process(delta):
	for collider in get_colliding_bodies():
		if collider.has_method('take_proportional_damage'):
			collider.take_proportional_damage(damage, linear_velocity)