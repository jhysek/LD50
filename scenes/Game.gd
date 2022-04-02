extends Node2D

var paused = false

func _ready():
	Transition.openSceneLong()
	$Player/Message.tell("Here we go again... this forrest...", 5, 3)
