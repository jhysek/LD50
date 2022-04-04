extends Node2D

var paused = false

var texts0 = [
	["I've been walking through this forest for ages... But wolves grow bigger and bigger.", 5, 2],
	["Grandma thinks it's dangerous.", 3, 1],
	["But I have learned couple of new tricks...", 5, 2],
]


onready var player = $Player

func _ready():
	Settings.last_checkpoint = null
	if LevelSwitcher.current_level == 0:
		$Player/Message.tell_lines(texts0)
			
	Transition.openSceneLong()

func restart():
	if Settings.last_checkpoint:
		Transition.fadeOut()
		$ReviveTimer.start()
	else:
		Transition.switchLongerTo(LevelSwitcher.get_current_level())
		Music.play()
		
func checkpoint_reached(checkpoint):
	if !Settings.last_checkpoint or checkpoint.number > Settings.last_checkpoint.number:
		Settings.last_checkpoint = {
			"position": checkpoint.position,
			"number": checkpoint.number
		}

func _on_Exit_area_entered(area):
	if area.is_in_group("Player"):
		LevelSwitcher.next_level()


func _on_Zoomout_area_entered(area):
	if area.is_in_group("Player"):
		$Zoomout/AnimationPlayer.play("Zoomout")	


func _on_End_area_entered(area):
	if area.is_in_group("Player"):
		player.frozen = true
		$Player.stop()
		$Boss/Sfx/Attack.play()
		$Boss/AnimationPlayer.play("Attack")
		$Boss/AnimationPlayer2.play("Jump")
		LevelSwitcher.next_level()


func _on_ReviveTimer_timeout():
	player.position = Settings.last_checkpoint.position
	player.revive()
	Transition.fadeIn()
	Music.play()

	
