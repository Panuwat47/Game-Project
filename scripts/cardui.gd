class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@export var card: Card

@onready var color: ColorRect = $Color
@onready var state: Label = $state
@onready var drop_point_detector: Area2D = $droppointdetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []

var parent: Control
var tween: Tween

func _ready() -> void:
	#Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	#Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	#Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	#Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_reparent_requested(which_card_ui: CardUI) -> void:
	pass # Replace with function body.


func _on_droppointdetector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_droppointdetector_area_exited(area: Area2D) -> void:
	targets.erase(area)
