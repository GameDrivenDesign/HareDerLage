extends RigidBody2D

const dps = 5

func _process(delta):
	for collider in get_colliding_bodies():
		if collider.has_method('take_damage'):
			collider.take_damage(dps * delta)