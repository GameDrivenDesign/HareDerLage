extends KinematicBody2D


var proj_speed = 3
var direction
var proj_damage = 10

var has_collided

var tween

func _ready():
	direction = Vector2(0, proj_speed).rotated(transform.get_rotation())
	has_collided = false
	tween = Tween.new()
	add_child(tween)
	
	
func _physics_process(delta):
	if has_collided == false:
		var collided = move_and_collide(direction)
		if collided:
			has_collided = true
			var explosion = preload("res://explosion/explosion.tscn").instance()
			explosion.position = $CollisionShape2D.position
			add_child(explosion)
			tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_completed")
			queue_free()
			
			if collided.collider.has_method("take_damage"):
				collided.collider.take_damage (proj_damage)
				
				#TO DO: Wenn Projektile mit Projektilen kollidieren, stürzt das Spiel ab