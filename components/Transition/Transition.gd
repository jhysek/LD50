extends Node2D

var scena: String = "";

func _ready():
	$Transition/AnimationPlayer.play_backwards("Fade")
	
func openScene():
	scena = ""
	$Transition/AnimationPlayer.play_backwards("Fade")
	
func openSceneLong():
	scena = ""
	$Transition/AnimationPlayer.play_backwards("LongFade")
	
func switchTo(cilova_scena):
	scena = cilova_scena
	$Transition/AnimationPlayer.play("Fade")
	
func switchLongerTo(target_scene):
	scena = target_scene
	$Transition/AnimationPlayer.play("LongFade")

func _on_AnimationPlayer_animation_finished(anim_name):
	if !scena.empty():
		get_tree().change_scene(scena)
