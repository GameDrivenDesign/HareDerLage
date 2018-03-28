extends RigidBody2D

# The original position where the comet was placed 
var origin

# The maximum distance the comet will wobble around
# the origin
const maxWobble = 10

# The speed the comet is wobbling with
var speed

# The damage dealt to spacecrafts on collision
const damage = 42 # TODO

# The gravity emitted by this comet
const gravity = 42 # TODO


func _ready():
	#origin = self.position
	#speed = Vector2(randf(), randf()).normalized()
	pass


func _process(delta):
	#var newPosition = self.position + speed * delta * 10
	#
	#if abs(origin.distance_to(newPosition)) >= maxWobble:
	#	speed *= -1
	#
	#self.position = newPosition
	pass