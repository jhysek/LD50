extends Node2D

var paused = false

var texts0 = [
	["I've been walking through this forest for ages... But wolves grow bigger and bigger.", 5, 2],
	["Grandma thinks it's dangerous...", 3, 1],
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

func _ready():
	Transition.openSceneLong()
	$Player/Message.tell_lines(texts0)

	
