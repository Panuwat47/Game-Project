extends Node2D
class_name PlayerActor

@onready var anim: AnimationPlayer = $AnimationPlayer

func play_action(card_type: String) -> String:
	var name := ""
	match card_type:
		"attack":
			name = anim.has_animation("attack") ? "attack" : name
		"block":
			name = anim.has_animation("block") ? "block" : name
		"heal":
			name = anim.has_animation("heal") ? "heal" : name
		_:
			pass
	if name == "":
		name = anim.has_animation("use") ? "use" : (anim.has_animation("idle") ? "idle" : "")
	if name != "":
		anim.play(name)
	return name

func to_idle():
	if anim.has_animation("idle"):
		anim.play("idle")
