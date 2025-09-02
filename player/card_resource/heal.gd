extends Card

@export var heal_amount := 6

func apply_effects(targets: Array[Node]) -> void:
	var heal_effect := HealEffect.new()
	heal_effect.amount = heal_amount
	heal_effect.sound = sound
	heal_effect.execute(targets)
