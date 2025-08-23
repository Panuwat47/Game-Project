class_name cardui
extends Control

signal reparent_requested(which_card_ui: cardui)

@onready var color: ColorRect = $Color
@onready var state: Label = $state
@onready var drop_point_detector: Area2D = $droppointdetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine

func _ready() -> void:
	#Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	#Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	#Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	#Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_reparent_requested(which_card_ui: cardui) -> void:
	pass # Replace with function body.
