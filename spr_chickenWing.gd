extends RigidBody2D

const WEAPON_COOLDOWN = 1.0
const PROJECTILE_SPEED = Vector2(300, 0)

var cooldown = 0
var speed = 50
var player = null
var target_ref = null
var target_candidate_ref = null
var old_delta = Vector2(0.0, 0.0)
var chicken_id = 0

#var extra_fuel = 100

var health = 100
var alive = true
var tween

func _ready():
	tween = Tween.new()
	add_child(tween)

func take_damage(damage):
	set_health(max(health - damage, 0))

func set_health(new_health):
	health = new_health
	if health == 0 and alive:
		die()

func die(): #Billige Copy-Pasta aus spaceship.gd
	alive = false
	
	var explosion = preload("res://explosion/explosion.tscn").instance()
	explosion.position = position
	add_child(explosion)
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.1, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()

func _physics_process(dt):
	var target = null if not target_ref else target_ref.get_ref()
	
	if target:
		var delta = target.position - position
		var movement = delta.normalized() * speed

		if delta.length() > 150:
			applied_force = movement
			if (linear_velocity.length() > 200 && (delta.length() - old_delta.length()) > 5):
				apply_impulse(Vector2(0,0), - linear_velocity + target.linear_velocity)
		else:
			#apply_impulse(Vector2(0,0), - delta/2)
			applied_force = -movement

		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position, target.position, [$vision_area, self], 2)
		if result:
			if result.collider is preload("res://spaceship.gd"):
				$chicken_memory.stop()
			elif $chicken_memory.is_stopped():
				$chicken_memory.start()
		elif $chicken_memory.is_stopped():
			$chicken_memory.start()

		rotation = (target.position - position).angle()
		old_delta = delta
		
		if cooldown > 0:
			cooldown -= dt
		else:
			shoot_target(target)
			cooldown = WEAPON_COOLDOWN
	else:
		var follow = get_node("../chicken_paths/Path2D_" + str(chicken_id) + "/PathFollow2D")
		if follow:
			follow.loop = true
			follow.cubic_interp = true
			follow.rotate = true
			follow.offset += speed * dt
			var start = position
			position = get_node("../chicken_paths/Path2D_" + str(chicken_id)).position + follow.position
			rotation = follow.rotation
		
		var target_candidate = null if not target_candidate_ref else target_candidate_ref.get_ref()
		if target_candidate:
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(position, target_candidate.position, [$vision_area, self], collision_layer)
			if result:
				if result.collider is preload("res://spaceship.gd"):
					target_ref = target_candidate_ref

func shoot_target(target):
	var projectile = preload("res://projectile.tscn").instance()
	projectile.position = position
	projectile.rotation = position.angle_to_point(target.position) + PI
	projectile.direction = PROJECTILE_SPEED.rotated(projectile.rotation)
	projectile.add_collision_exception_with(self)
	
	get_parent().add_child(projectile)

func _on_vision_area_body_entered(body):
	if body is preload("res://spaceship.gd"):
		target_candidate_ref = weakref(player)

func _on_vision_area_body_exited(body):
	if body is preload("res://spaceship.gd"):
		target_candidate_ref = null

func _on_chicken_memory_timeout():
	target_ref = null
