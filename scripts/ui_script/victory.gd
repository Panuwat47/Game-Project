extends Node2D

@onready var victory: Label = %Victory
@onready var button: Button = %Button
@export var music: AudioStream

func _ready() -> void:
	MusicPlayer.play(music, true)
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/UI/main.tscn")
