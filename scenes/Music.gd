extends AudioStreamPlayer


func _ready():
	pass # Replace with function body.


func fadePlay():
	$AnimationPlayer.play("FadeIn")

func fadeStop():
	$AnimationPlayer.play_backwards("FadeIn")


func playFromPosition(s):
	volume_db = -80
	stop()
	play()
	seek(s)
	$AnimationPlayer.play("FadeIn")
