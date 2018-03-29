extends Sprite

var target = null

const PROJECTILE_SPEED = Vector2(0, 100)
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
		if cooldown > 0:
			cooldown -= delta
		else:
			shoot_to_target()
			cooldown = WEAPON_COOLDOWN
		
		aim_to_target()

func aim_to_target():
	$Polygon2D.rotation = position.angle_to_point(target.position)

func _on_vision_area_body_entered(body):
	if body is preload("res://spaceship.gd"):
		target = body
		aim_to_target()

func shoot_to_target():
	var aimvector = target.position - position
	
	var projectile = preload("res://projectile.tscn").instance()
	#projectile.position = position + Vector2(0, 20).rotated($Polygon2D.transform.get_rotation())
	projectile.position = position
	projectile.rotation = position.angle_to_point(target.position) + PI / 2
	projectile.direction = PROJECTILE_SPEED.rotated(projectile.rotation)
	projectile.add_collision_exception_with($StaticBody2D)
	
	get_parent().add_child(projectile)

func _on_vision_area_body_exited(body):
	if body is preload("res://spaceship.gd"):
		target = null
