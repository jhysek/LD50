extends Node2D

func _ready():
	Transition.openScene()

func _on_Button_pressed():
	LevelSwitcher.current_level = 0
	Settings.last_checkpoint = null
	$Click.play()
	Music.play()
	#get_tree().change_scene("res://levels/Level1.tscn")
	Transition.switchTo("res://levels/Level1.tscn")


func _on_ButtonBack_pressed():
	Transition.switchTo("res://scenes/Menu.tscn")
