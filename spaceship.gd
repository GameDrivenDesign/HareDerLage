extends RigidBody2D

var tween

var torque = 2500
var speed = 200
var handling = 20
var fire_intervall = 0.6
# Remaining space ship health
var health = 100.0
#var impulse_fuel = 100

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
	get_node('/root/game/hud_layer/hud/health').text = str(ceil(health)) + ' HP'
	get_node('/root/game/hud_layer/hud/health_bar').margin_right = 7.5*health - 400

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

func _process(delta):
	if fire_in > 0:
		fire_in -= delta
		if fire_in < 0:
			fire_in = 0

func _physics_process(delta):
	#var angle = Vector2(0, 1).rotated(transform.get_rotation()).angle_to(linear_velocity)
	
	if Input.is_action_pressed("up"):
		#applied_force = Vector2(0, speed + handling * abs(angle)).rotated(transform.get_rotation())
		applied_force = Vector2(0, speed).rotated(rotation)
	else:
		applied_force = Vector2()
		
	if Input.is_action_just_pressed("up"):
		#if impulse_fuel >= 100:
			#impulse_fuel = 0
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