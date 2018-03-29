extends Sprite

# class member variables go here, for example:
var target = null
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	if target == null:
		$Polygon2D.rotation_degrees += 60*delta
	else:
		$Polygon2D.rotation = position.angle_to(target.position) + PI * 8 / 9#(position - target.position).angle()


func _on_vision_area_body_entered(body):
	if body is preload("res://spaceship.gd"):
		var projectile = preload("res://projectile.tscn").instance()
		projectile.position = position + Vector2(0, 20).rotated($Polygon2D.transform.get_rotation())
		var aimvector = body.position - projectile.position
		projectile.rotation = aimvector.angle()
		add_child(projectile)
		projectile.add_collision_exception_with($StaticBody2D)
		target = body


func _on_vision_area_body_exited(body):
	if body is preload("res://spaceship.gd"):
		target = null
