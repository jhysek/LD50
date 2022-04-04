extends Node

var current_level = 0
var levels = [
	"res://levels/Level1.tscn",
	#"res://levels/Level2.tscn",
	#"res://levels/Level3.tscn",
	#"res://levels/Level4.tscn",
	#"res://levels/Level5.tscn",
]
	
func _ready():
	set_process_input(true)
	
func _input(event):
	if Input.is_action_just_released("ui_restart"):
		restart_level()

func get_current_level():
	return levels[current_level]

func restart_level():
	Music.fadePlay()
	get_tree().reload_current_scene()
	
func start_level():		
	Transition.switchTo(levels[current_level])
	
func next_level():
	current_level += 1
	if current_level < levels.size():
		start_level()
	else:
		Music.stop()
		Transition.switchTo("res://scenes/EatenJedi.tscn")
