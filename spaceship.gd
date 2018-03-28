extends RigidBody2D

var torque = 400
var speed = 200
var handling = 20

# Remaining space ship health
var health = 1.0

# Whether or not the player is still alive
var alive = true

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
	get_node('/root/game/CanvasLayer/hud/health').text = str(ceil(health)) + ' HP'

	if health == 0 and alive:
		die()
		
func die():
	alive = false
	
	var explosion = preload("res://explosion/explosion.tscn").instance()
	explosion.position = $CollisionShape2D.position
	add_child(explosion)

func _ready():
	set_health(health)

func _physics_process(delta):
	var angle = Vector2(0, 1).rotated(transform.get_rotation()).angle_to(linear_velocity)
		
	if Input.is_action_pressed("up"):
		applied_force = Vector2(0, speed + handling * abs(angle)).rotated(transform.get_rotation())
	else:
		applied_force = Vector2()
	
	if Input.is_action_pressed("left"):
		applied_torque = - torque
	elif Input.is_action_pressed("right"):
		applied_torque = torque
	else:
		applied_torque = 0