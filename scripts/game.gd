extends Node
#class_name CombatManager
#
#signal state_changed(state: String)
#
#@export var hand_size: int = 3
#@export var max_plays_per_turn: int = 2
#@export var enemy_scene: PackedScene = preload("res://scenes/enemies/EnemyActor.tscn")
#
#@onready var hand_container: HBoxContainer = $"../UI/Hand"
#@onready var dice: Dice = $"../UI/Dice"
#@onready var player_hp_label: Label = $"../UI/PlayerHP"
#@onready var plays_label: Label = $"../UI/PlaysLeft"
#@onready var player_actor: Node = $"../PlayerActor"
#@onready var player_anim: AnimationPlayer = $"../PlayerActor/AnimationPlayer"
#@onready var enemies_root: Node2D = $"../Enemies"
#
#var deck := Deck.new()
#var player := Battler.new()
#
## โครงสร้างศัตรูในด่าน
## แต่ละด่านคือ Array ของ Dict: { name, max_hp, atk, is_boss?, ult_every?, ult_damage? }
#var stages := [
	#[ # Stage 1: 1 ตัว
		#{"name":"Slime","max_hp":30,"atk":6}
	#],
	#[ # Stage 2: 2 ตัว
		#{"name":"Goblin","max_hp":28,"atk":7},
		#{"name":"Bat","max_hp":24,"atk":6}
	#],
	#[ # Stage 3: บอส
		#{"name":"Dread King","max_hp":120,"atk":10,"is_boss":true,"ult_every":3,"ult_damage":24}
	#]
#]
#var stage_index := 0
#
## ศัตรูที่ spawn แล้ว
## แต่ละตัวเป็น Dict: { actor:EnemyActor, battler:Battler, atk:int, is_boss:bool, ult_every:int, ult_cd:int, ult_damage:int, alive:bool }
#var enemies: Array = []
#
## มือ/สถานะ
#var current_hand: Array[CardData] = []
#var plays_left: int = 0
#var selected_card: CardData
#var selected_button: Button
#var selected_target_idx: int = -1
#var last_roll_value: int = 0
#var last_action_anim: String = ""
#var state: String = "idle" # "choose_card","choose_target","await_roll","animating","enemy_dying"
#
#var pending_deaths: int = 0
#
## เด็ค 12 ใบตัวอย่าง (สร้าง .tres ตาม CardData ใหม่)
#const START_CARDS := [
	#preload("res://cards/strike_single.tres"),
	#preload("res://cards/strike_single.tres"),
	#preload("res://cards/strike_single.tres"),
	#preload("res://cards/strike_single.tres"),
	#preload("res://cards/strike_single.tres"),
	#preload("res://cards/strike_all.tres"),
	#preload("res://cards/block.tres"),
	#preload("res://cards/block.tres"),
	#preload("res://cards/block.tres"),
	#preload("res://cards/heal.tres"),
	#preload("res://cards/heal.tres"),
	#preload("res://cards/heal.tres"),
#]
#
#func _ready():
	#add_child(deck)
	#player.name = "Player"
	#dice.rolled.connect(_on_dice_rolled)
	#dice.set_enabled(false)
	#player_anim.animation_finished.connect(_on_player_anim_finished)
#
	#deck.setup(START_CARDS)
	#stage_index = 0
	#_load_stage(stage_index)
	#_refill_hand()
	#_start_player_turn()
#
#func _load_stage(i: int):
	## เคลียร์ศัตรูเดิม
	#for n in enemies_root.get_children():
		#n.queue_free()
	#enemies.clear()
#
	#var defs = stages[i]
	#var count := defs.size()
	#var spacing := 220.0
	#var start_x := -((count - 1) * spacing) * 0.5
#
	#for idx in defs.size():
		#var d: Dictionary = defs[idx]
		#var actor: EnemyActor = enemy_scene.instantiate()
		#enemies_root.add_child(actor)
		#actor.position = Vector2(start_x + idx * spacing, 0)
#
		#var b := Battler.new()
		#b.name = String(d.get("name"))
		#b.max_hp = int(d.get("max_hp", 30))
		#b.hp = b.max_hp
		#b.block = 0
#
		#var is_boss := bool(d.get("is_boss", false))
		#actor.setup(b, b.name, is_boss)
#
		#var entry := {
			#"actor": actor,
			#"battler": b,
			#"atk": int(d.get("atk", 6)),
			#"is_boss": is_boss,
			#"ult_every": int(d.get("ult_every", 3)),
			#"ult_cd": is_boss ? int(d.get("ult_every", 3)) - 1 : -1,
			#"ult_damage": int(d.get("ult_damage", 20)),
			#"alive": true
		#}
		#enemies.append(entry)
#
		#actor.clicked.connect(_on_enemy_clicked)
		#actor.death_finished.connect(_on_enemy_death_finished)
#
	#_update_all_enemy_hp()
	#_update_player_ui()
#
#func _start_player_turn():
	#plays_left = max_plays_per_turn
	#dice.set_enabled(false)
	#_set_hand_enabled(true)
	#selected_target_idx = -1
	#state = "choose_card"
	#_update_player_ui()
	#emit_signal("state_changed", state)
#
#func _refill_hand():
	#var missing := hand_size - hand_container.get_child_count()
	#if missing <= 0: return
	#var drawn := deck.draw(missing)
	#for cd in drawn:
		#current_hand.append(cd)
		#var c := CardButton.new()
		#c.set_card(cd)
		#c.played.connect(_on_card_played)
		#hand_container.add_child(c)
#
#func _set_hand_enabled(enable: bool):
	#for n in hand_container.get_children():
		#if n is Button:
			#n.disabled = not enable
#
#func _on_card_played(card: CardData, button: Button):
	#if state != "choose_card": return
	#if plays_left <= 0: return
	#selected_card = card
	#selected_button = button
	#_set_hand_enabled(false)
	#if is_instance_valid(selected_button): selected_button.disabled = false
#
	## ถ้าการ์ดเป็นโจมตีเดี่ยว -> ให้เลือกเป้าหมายก่อน
	#if selected_card.type == "attack" and selected_card.target_mode == "single":
		#state = "choose_target"
		#dice.set_enabled(false)
	#else:
		## ไม่ต้องเลือกเป้าหมาย (all/self) -> รอทอย
		#state = "await_roll"
		#dice.set_enabled(true)
	#emit_signal("state_changed", state)
#
#func _on_enemy_clicked(actor: EnemyActor):
	#if state != "choose_target": return
	## หา index ของศัตรูที่คลิก
	#for i in enemies.size():
		#if enemies[i]["actor"] == actor and enemies[i]["alive"]:
			#selected_target_idx = i
			#dice.set_enabled(true)
			#state = "await_roll"
			#emit_signal("state_changed", state)
			#return
#
#func _on_dice_rolled(value: int):
	#if state != "await_roll" or selected_card == null: return
	#last_roll_value = value
	#dice.set_enabled(false)
#
	## เล่นแอนิเมชันผู้เล่นก่อน
	#if player_actor and player_actor.has_method("play_action"):
		#last_action_anim = player_actor.play_action(selected_card.type)
	#else:
		#last_action_anim = ""
	#if last_action_anim == "":
		#_resolve_after_player_anim()
	#else:
		#state = "animating"
		#emit_signal("state_changed", state)
#
#func _on_player_anim_finished(anim_name: StringName):
	#if state == "animating" and str(anim_name) == str(last_action_anim):
		#_resolve_after_player_anim()
#
#func _resolve_after_player_anim():
	## ใช้เอฟเฟกต์การ์ด
	#_apply_card_effect(selected_card, last_roll_value)
#
	## ทิ้งการ์ดที่ใช้แล้ว
	#deck.discard(selected_card)
	#current_hand.erase(selected_card)
	#if is_instance_valid(selected_button):
		#selected_button.queue_free()
#
	## รีเซ็ต
	#selected_card = null
	#selected_button = null
	#selected_target_idx = -1
	#last_action_anim = ""
	#last_roll_value = 0
	#plays_left -= 1
#
	#_update_player_ui()
#
	## ถ้ามีศัตรูตาย รอแอนิเมชันตายให้ครบก่อน
	#if pending_deaths > 0:
		#state = "enemy_dying"
		#emit_signal("state_changed", state)
		#return
#
	## ถ้าเคลียร์ด่านแล้ว -> ไปด่านถัดไป
	#if _all_enemies_dead():
		#_next_stage_or_win()
		#return
#
	## ยังสู้ต่อในด่านเดิม
	#if plays_left > 0 and hand_container.get_child_count() > 0:
		#_set_hand_enabled(true)
		#dice.set_enabled(false) # ต้องเลือกการ์ดใหม่ก่อน
		#state = "choose_card"
		#emit_signal("state_changed", state)
		#return
#
	#_enemy_turn_and_next()
#
#func _apply_card_effect(card: CardData, mult: int):
	#var amt := card.base_value * mult
	#match card.type:
		#"attack":
			#if card.target_mode == "single":
				#if selected_target_idx >= 0 and selected_target_idx < enemies.size():
					#_damage_enemy(selected_target_idx, amt)
			#elif card.target_mode == "all":
				#for i in enemies.size():
					#if enemies[i]["alive"]:
						#_damage_enemy(i, amt)
			#else:
				## เผื่อกรณี target_mode อื่นๆ
				#for i in enemies.size():
					#if enemies[i]["alive"]:
						#_damage_enemy(i, amt)
		#"block":
			#player.gain_block(amt)
		#"heal":
			#player.heal(amt)
		#_:
			## ดีฟอลต์ให้ตีเป้าหมายเดี่ยว (ถ้าเลือกไว้) มิฉะนั้นไม่ทำอะไร
			#if selected_target_idx >= 0 and selected_target_idx < enemies.size():
				#_damage_enemy(selected_target_idx, amt)
#
	#_update_all_enemy_hp()
#
#func _damage_enemy(i: int, amount: int):
	#var e = enemies[i]
	#if not e["alive"]: return
	#var b: Battler = e["battler"]
	#b.take_damage(amount)
	#var actor: EnemyActor = e["actor"]
	#if actor and actor.alive:
		#actor.play_hit()
	#if b.hp <= 0 and e["alive"]:
		#e["alive"] = false
		#enemies[i] = e
		#pending_deaths += 1
		#if actor:
			#actor.play_die()
#
#func _on_enemy_death_finished(actor: EnemyActor):
	#if pending_deaths > 0:
		#pending_deaths -= 1
	## ถ้าตายครบแล้ว ค่อยไปต่อ
	#if pending_deaths == 0 and state == "enemy_dying":
		#if _all_enemies_dead():
			#_next_stage_or_win()
		#else:
			## กลับเข้าสู่เทิร์นผู้เล่นต่อ หรือถ้าหมดโควตาให้ศัตรูเล่น
			#if plays_left > 0 and hand_container.get_child_count() > 0:
				#_set_hand_enabled(true)
				#dice.set_enabled(false)
				#state = "choose_card"
				#emit_signal("state_changed", state)
			#else:
				#_enemy_turn_and_next()
#
#func _enemy_turn_and_next():
	#_enemies_act()
	#_update_player_ui()
	#if player.hp <= 0:
		#state = "lose"; emit_signal("state_changed", state); return
	#_refill_hand()
	#_start_player_turn()
#
#func _enemies_act():
	## ศัตรูทุกตัวยิงพร้อมกันทีละตัว
	#for i in enemies.size():
		#var e = enemies[i]
		#if not e["alive"]: continue
		#var actor: EnemyActor = e["actor"]
		#var b_atk: int = int(e["atk"])
		#if bool(e["is_boss"]):
			#var cd: int = int(e["ult_cd"])
			#if cd <= 0:
				#if actor: actor.play_ultimate()
				#player.take_damage(int(e["ult_damage"]))
				#e["ult_cd"] = int(e["ult_every"]) - 1
			#else:
				#if actor: actor.play_attack()
				#player.take_damage(b_atk)
				#e["ult_cd"] = cd - 1
			#enemies[i] = e
		#else:
			#if actor: actor.play_attack()
			#player.take_damage(b_atk)
#
#func _all_enemies_dead() -> bool:
	#for e in enemies:
		#if e["alive"]:
			#return false
	#return true
#
#func _next_stage_or_win():
	#stage_index += 1
	#if stage_index >= stages.size():
		#state = "win"; emit_signal("state_changed", state); return
	#_load_stage(stage_index)
	#_refill_hand()
	#_start_player_turn()
#
#func _update_all_enemy_hp():
	#for e in enemies:
		#var actor: EnemyActor = e["actor"]
		#if actor: actor.update_hp_label()
#
#func _update_player_ui():
	#player_hp_label.text = "Player HP: %d/%d  Block:%d" % [player.hp, player.max_hp, player.block]
	#if plays_label:
		#plays_label.text = "Plays Left: %d" % plays_left
