extends RigidBody2D

var tween

signal health_changed(percentage)

var torque = 5000
var speed = 200
var handling = 20
var fire_intervall = 0.6

const MAX_HEALTH = 200
var health = MAX_HEALTH

# Whether or not the player is still alive
var alive = true
var fire_in = 0

func _ready():
	tween = Tween.new()
	add_child(tween)
	set_health(health)

# This can be called by chicken wings or comets
# to make the spaceship take damage
func take_damage(damage):
	set_health(max(health - damage, 0))
	#print(damage)

func take_proportional_damage(damage, other_velocity):
	#take_damage(damage * Vector2(linear_velocity - other_velocity).length())
	#print(Vector2(linear_velocity - other_velocity).length())
	pass

func set_health(new_health):
	health = new_health
	# TODO Do something when spaceship is dead.
	
	emit_signal("health_changed", new_health / MAX_HEALTH)
	
	if health == 0 and alive:
		die()
		
func die():
	alive = false
	
	var explosion = preload("res://explosion/explosion.tscn").instance()
	explosion.position = position
	add_child(explosion)

	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()

func _draw():
	draw_line(Vector2(), linear_velocity.rotated(-rotation), Color(1, 0, 0, 1), 4, false)

func _process(delta):
	if fire_in > 0:
		fire_in -= delta
		if fire_in < 0:
			fire_in = 0

func _physics_process(delta):
	# remove to disable debug draw
	update()
	
	if Input.is_action_pressed("down") and linear_velocity.dot(Vector2(0, 1).rotated(rotation)) > 0:
		applied_force = Vector2(0, speed * 2).rotated(rotation + PI)
	elif Input.is_action_pressed("up"):
		applied_force = Vector2(0, speed).rotated(rotation)
	else:
		applied_force = Vector2()
		
	if Input.is_action_just_pressed("up"):
		apply_impulse(Vector2(), Vector2(0, speed).rotated(rotation)/3)
	
	$exhaust.emitting = Input.is_action_pressed("up")
	
	if Input.is_action_pressed("left"):
		applied_torque = -torque
	elif Input.is_action_pressed("right"):
		applied_torque = torque
	else:
		applied_torque = 0
	if Input.is_action_pressed("shoot"):
		if fire_in <= 0:
			fire_in = fire_intervall
			var projectile = preload("res://projectile.tscn").instance()
			projectile.position = position + Vector2(0, 20).rotated(transform.get_rotation())
			projectile.rotation = transform.get_rotation()
			projectile.direction = Vector2(0, projectile.proj_basespeed).rotated(transform.get_rotation()) + linear_velocity
			get_parent().add_child(projectile)
			projectile.add_collision_exception_with(self)
	
	#impulse_fuel += 1