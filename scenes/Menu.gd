extends Node2D

func _ready():
	Transition.openScene()

func _on_Button_pressed():
	Music.play()
	Transition.switchTo("res://scenes/Game.tscn")


func _on_ButtonBack_pressed():
	Transition.switchTo("res://scenes/Menu.tscn")
