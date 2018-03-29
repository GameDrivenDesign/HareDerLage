extends StaticBody2D

var target = null

const PROJECTILE_SPEED = Vector2(0, 1000)
const WEAPON_COOLDOWN = 0.2

var cooldown = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if target == null:
		$Polygon2D.rotation_degrees += 60*delta
	else:
		var turrent_top_has_aim = aim_to_target(delta)
		
		if cooldown > 0:
			cooldown -= delta
		elif turrent_top_has_aim:
			shoot_to_target()
			cooldown = WEAPON_COOLDOWN
		

func aim_to_target(delta):
	var target_rotation = position.angle_to_point(target.position)
	var turret_target_rotation = target_rotation + PI / 2

	$Polygon2D.rotation = target_rotation
	$turret_top.rotation = lerp_angle($turret_top.rotation, 
									  turret_target_rotation, 
									  delta * 4)

	return abs(normalize_angle($turret_top.rotation - turret_target_rotation)) < deg2rad(30)


func _on_vision_area_body_entered(body):
	if body is preload("res://spaceship.gd"):
		target = body

func shoot_to_target():
	$AnimationPlayer.play('knockback')
	spawn_projectile(position + Vector2(-40, -11).rotated($Polygon2D.rotation))
	spawn_projectile(position + Vector2(-40,  11).rotated($Polygon2D.rotation))

func spawn_projectile(pos):
	var projectile = preload("res://projectile.tscn").instance()
	projectile.position = pos
	projectile.rotation = position.angle_to_point(target.position) + PI / 2 + rand_range(-0.1, 0.1)
	projectile.direction = PROJECTILE_SPEED.rotated(projectile.rotation)
	projectile.add_collision_exception_with(self)
	
	get_parent().add_child(projectile)

func _on_vision_area_body_exited(body):
	if body is preload("res://spaceship.gd"):
		target = null

static func lerp_angle(a, b, t):
	a = normalize_angle(a)
	b = normalize_angle(b)
	if abs(a-b) >= PI:
		if a > b:
			a = normalize_angle(a) - 2.0 * PI
		else:
			b = normalize_angle(b) - 2.0 * PI
	return lerp(a, b, t)


static func normalize_angle(x):
	return fposmod(x + PI, 2.0*PI) - PI
