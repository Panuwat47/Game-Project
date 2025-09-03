extends Control

@export var music: AudioStream
@onready var start: Button = $Start
@onready var exit: Button = $Exit

func _ready() -> void:
	MusicPlayer.play(music, true)
	start.pressed.connect(_on_button_start_pressed)
	exit.pressed.connect(_on_button_exit_pressed)

func _on_button_start_pressed():
	MusicPlayer.play(music, false)
	get_tree().change_scene_to_file("res://scene/level/main.tscn")
	
func _on_button_exit_pressed():
		MusicPlayer.play(music, false)
		get_tree().quit()
