class_name hand
extends HBoxContainer

func _ready() -> void:
	for child in get_children():
		var card_ui := child as cardui
		card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)

func _on_card_ui_reparent_requested(child: cardui)-> void:
	#child.disabled = true
	child.reparent(self)
	#var new_index := clampi(child.original_index, 0, get_child_count())
	#move_child.call_deferred(child, new_index)
	#child.set_deferred("disabled", false)
