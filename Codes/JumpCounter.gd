extends Label
onready var player = find_parent("Player")
func _process(delta):
	text = "JUMP VALUE = " + str(player.jump_change)
