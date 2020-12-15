extends Label
onready var player = find_parent("Player")
func _process(delta) -> void:
	text = "VELOCITY.x = " + str(player.vel.x / 32)
