extends KinematicBody2D


var proj_basespeed = 200
var direction #auch Geschwindigkeit!
var proj_damage = 50 #-> Zwei Schüsse töten ein Huhn

var has_collided

var tween

func _ready():
	has_collided = false
	tween = Tween.new()
	add_child(tween)
	
	
func _physics_process(delta):
	if has_collided == false:
		var collided = move_and_collide(direction*delta)
		if collided:
			has_collided = true
			var explosion = preload("res://explosion/explosion.tscn").instance()
			explosion.position = position
			add_child(explosion)
			tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_completed")
			queue_free()
			
			if collided.collider and collided.collider.has_method("take_damage"):
				collided.collider.take_damage (proj_damage)
