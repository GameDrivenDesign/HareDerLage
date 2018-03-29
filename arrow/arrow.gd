extends StaticBody2D

func _ready():
	var destinations = get_tree().get_nodes_in_group("destinations")
	var destination = destinations[0]
	
	self.rotation = (destination.position - position).angle()
	
	$AnimationPlayer.play("pulse")