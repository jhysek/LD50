extends CanvasModulate

var scena: String = "";

func _ready():
	$AnimationPlayer.play_backwards("Fade")
	
func openScene():
	scena = ""
	$AnimationPlayer.play_backwards("Fade")
	
func openSceneLong():
	scena = ""
	$AnimationPlayer.play_backwards("LongFade")
	
func switchTo(cilova_scena):
	scena = cilova_scena
	$AnimationPlayer.play("Fade")
	
func switchLongerTo(target_scene):
	scena = target_scene
	$AnimationPlayer.play("LongFade")

func _on_AnimationPlayer_animation_finished(anim_name):
	if !scena.empty():
		get_tree().change_scene(scena)
