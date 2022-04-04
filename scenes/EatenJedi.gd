extends Node2D

var texts = [
	["Grandma told me this will happen...  eaten alive.", 5, 1],
	["Fortunately, she gave me this...", 5, 2],
]

func _ready():
	Transition.openScene()
	Music.playFromPosition(82)
	$Timer.start()
	$Message.tell_lines(texts)

func _on_Timer_timeout():
	$AnimationPlayer.play("Saber")

func saber():
	$lightsaber.play()
	
func switchScene():
	Transition.switchTo("res://scenes/Finished.tscn")
