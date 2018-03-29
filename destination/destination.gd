extends Area2D

func _on_destination_body_entered(body):
	if body is preload("res://spaceship.gd"):
		get_node("/root/game").win()