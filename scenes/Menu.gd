extends Node2D

func _ready():
	Transition.openScene()

func _on_Button_pressed():
	Transition.switchTo("res://scenes/Game.tscn")
