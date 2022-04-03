extends Node2D

var paused = false

var texts0 = [
	["I've been walking through this forest for ages... But wolves grow bigger and bigger.", 5, 2],
	["Grandma thinks it's dangerous.", 3, 1],
	["Bud I have learned couple of new tricks...", 5, 2],
]

var texts1 = [
	["I have learned hiding in the bushes and behind trees.", 5, 0],
]

var texts2 = [
	["I have even learned a double jump!", 3, 0],
]

var texts3 = [
	["And in the worst case, I can defend myself...", 3, 0],
]

onready var player = $Player

func _ready():
	if Settings.last_checkpoint:
		player.paused = false
		paused = false
		player.position = Settings.last_checkpoint.position
	else:
		$Player/Message.tell_lines(texts0)
			
	Transition.openSceneLong()

func restart():
	Music.fadePlay()
	Transition.switchLongerTo(LevelSwitcher.current_level())

func checkpoint_reached(checkpoint):
	if !Settings.last_checkpoint or checkpoint.number > Settings.last_checkpoint.number:
		Settings.last_checkpoint = {
			"position": checkpoint.position,
			"number": checkpoint.number
		}


func _on_Exit_area_entered(area):
	if area.is_in_group("Player"):
		LevelSwitcher.next_level()
