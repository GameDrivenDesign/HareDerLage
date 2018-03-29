extends RigidBody2D

var speed = 100
var player = null
var target = null
var old_delta = Vector2(0.0, 0.0)
var chicken_id = 0

var extra_fuel = 100

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
	if target:
		var delta = target.position - position
		var movement = delta.normalized() * speed
		if delta.length() > 150:
			applied_force = movement
			if (linear_velocity.length() > 200 && (delta.length() - old_delta.length()) > 5):
				apply_impulse(Vector2(0,0), - linear_velocity + target.linear_velocity)
		else:
			if extra_fuel >= 100:
				extra_fuel = 0
				apply_impulse(Vector2(0,0), - delta)
			applied_force = -movement
		rotation = (target.position - position).angle()
		old_delta = delta
		if extra_fuel <= 100:
			extra_fuel += 1
	else:
		var follow = get_node("../chicken_paths/Path2D_" + str(chicken_id) + "/PathFollow2D")
		follow.loop = true
		follow.cubic_interp = true
		follow.rotate = true
		follow.offset += speed * dt
		var start = position
		position = get_node("../chicken_paths/Path2D_" + str(chicken_id)).position + follow.position
		rotation = follow.rotation

func _on_vision_area_body_entered(body):
	if body is preload("res://spaceship.gd"):
		target = player
