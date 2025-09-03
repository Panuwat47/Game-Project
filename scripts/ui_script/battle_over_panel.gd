class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	restart_button.pressed.connect(get_tree().reload_current_scene)
	Events.battle_over_screen_requested.connect(show_screen)

func _on_continue_pressed():
	var current_scene = get_tree().current_scene
	if current_scene:
		var scene_path = current_scene.scene_file_path
		if scene_path == "res://scene/level/main.tscn":
			get_tree().change_scene_to_file("res://scene/level/level_2.tscn")
		elif scene_path == "res://scene/level/level_2.tscn":
			get_tree().change_scene_to_file("res://scene/level/boss_level.tscn")
		#else:
			#get_tree().change_scene_to_file("res://scene/UI/victory.tscn")


func show_screen(text: String, type: Type) -> void:
	var current_scene = get_tree().current_scene
	if current_scene:
		var scene_path = current_scene.scene_file_path
		if scene_path == "res://scene/level/boss_level.tscn":
			if type == Type.WIN:
				get_tree().change_scene_to_file("res://scene/UI/victory.tscn")
			else:
				label.text = text
				continue_button.visible = false
				restart_button.visible = true
				show()
		else:
			label.text = text
			continue_button.visible = type == Type.WIN
			restart_button.visible = type == Type.LOSE
			show()
	#get_tree().paused = true
