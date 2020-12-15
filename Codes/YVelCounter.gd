extends Label

onready var player = find_parent("Player")
func _process(delta):
	text = "VELOCITY.y = " + str(player.vel.y)
