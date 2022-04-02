extends Label

var delay = false
var wait_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func tell(msg_text, timeout, show_delay = 0):
	text = msg_text
	if show_delay > 0:
		delay = true
		wait_time = timeout + 1
		$Timer.wait_time = show_delay
		$Timer.start()
	else:
		$AnimationPlayer.play("Show")
		$Timer.wait_time = timeout + 1
		$Timer.start()


func _on_Timer_timeout():
	if delay:
		delay = false
		$Timer.wait_time = wait_time
		$Timer.start()
		$AnimationPlayer.play("Show")
	else:
		$AnimationPlayer.play_backwards("Show")
