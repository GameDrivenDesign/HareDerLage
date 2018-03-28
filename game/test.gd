extends RigidBody2D

const velocity = Vector2(20, 0)

func _ready():
    set_applied_force(velocity)

func _physics_process(delta):
	pass