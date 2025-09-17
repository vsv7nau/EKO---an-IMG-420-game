extends Node2D

@onready var buttons: Array = [$ButtonRed, $ButtonBlue, $ButtonGreen, $ButtonYellow]
@onready var player: CharacterBody2D = $Player
@onready var replay_orb: Area2D = $ReplayOrb
@onready var simon_npc: AnimatedSprite2D = $SimonNPC
@onready var hud_score: Label = $HUD/Score
@onready var hud_round: Label = $HUD/Round
@onready var hud_lives: Label = $HUD/Lives
@onready var hud_replays: Label = $HUD/Replays
@onready var replay_button: Button = $HUD/ReplayButton
@onready var hud_countdown: Label = $HUD/Countdown
@onready var bg_music: AudioStreamPlayer = $bg_music

var pattern: Array[String] = []
var player_input: Array[String] = []
var round_num: int = 1
var score: int = 0
var lives: int = 3
var replay_uses: int = 0
var max_replays: int = 3
var is_player_turn: bool = false

func _ready() -> void:
	randomize()
	if buttons.size() != 4 or buttons.any(func(btn): return btn.color == ""):
		push_error("Button configuration error: Check colors in Game.tscn")
	if not replay_orb.is_connected("body_entered", _on_orb_collected):
		replay_orb.body_entered.connect(_on_orb_collected)
	if not replay_button.is_connected("pressed", _replay_pattern):
		replay_button.pressed.connect(_replay_pattern)
	if not $HUD.visible:
		push_error("HUD CanvasLayer is not visible! Check 'Visible' in Inspector.")
	if not hud_countdown:
		push_error("Countdown Label not found! Check 'HUD/Countdown' in Game.tscn.")
	$Camera2D.make_current()
	$Camera2D.global_position = player.global_position
	await start_countdown()
	start_round()
	if bg_music.stream:
		bg_music.play()

func _process(_delta: float) -> void:
	$Camera2D.global_position = player.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$PauseMenu.show()
		get_tree().paused = true

func start_countdown() -> void:
	is_player_turn = false
	if hud_countdown:
		hud_countdown.visible = true
		for i in range(3, 0, -1):
			hud_countdown.text = str(i)
			await get_tree().create_timer(1.0).timeout
		hud_countdown.text = "Go!"
		await get_tree().create_timer(1.0).timeout
		hud_countdown.visible = false
	else:
		push_error("Cannot start countdown: Countdown Label not found!")

func start_round() -> void:
	var random_index = randi() % 4
	var selected_button = buttons[random_index]
	if selected_button.color == "":
		push_error("Invalid button color for", selected_button.name)
		return
	pattern.append(selected_button.color)
	player_input.clear()
	is_player_turn = false
	await get_tree().create_timer(0.5).timeout
	play_pattern()
	update_hud()
	if randf() < 0.3:
		replay_orb.position = Vector2(randi_range(-200,200), randi_range(-200,200))
		replay_orb.visible = true

func play_pattern() -> void:
	if hud_countdown:
		hud_countdown.text = "Wait-"
		hud_countdown.visible = true
	if simon_npc.sprite_frames:
		simon_npc.play("demonstrate")
	for btn in buttons:
		if btn.has_node("AnimationPlayer"):
			btn.get_node("AnimationPlayer").stop()
		if btn.has_node("Sprite2D"):
			btn.get_node("Sprite2D").modulate = Color(1, 1, 1, 1)
	for col in pattern:
		var btn = get_button_by_color(col)
		if btn:
			await btn.blink()
			btn.play_sound()
			await get_tree().create_timer(1.0).timeout
		else:
			push_error("No button found for color:", col)
	is_player_turn = true
	if hud_countdown:
		hud_countdown.text = "EKO"
	if simon_npc.sprite_frames:
		simon_npc.play("idle")

func _on_button_pressed(col: String) -> void:
	if not is_player_turn:
		return
	player_input.append(col)
	if player_input.size() > pattern.size() or player_input[player_input.size()-1] != pattern[player_input.size()-1]:
		if hud_countdown:
			hud_countdown.text = "NO!"
			hud_countdown.visible = true
			await get_tree().create_timer(0.5).timeout
			hud_countdown.visible = false
		lose_life()
		return
	if player_input.size() == pattern.size():
		score += 10 * round_num
		round_num += 1
		if hud_countdown:
			hud_countdown.text = "Correct!!!"
		await get_tree().create_timer(0.3).timeout
		if hud_countdown:
			hud_countdown.visible = false
		if round_num > 10:
			win_game()
		else:
			start_round()

func lose_life() -> void:
	lives -= 1
	update_hud()
	if lives <= 0:
		lose_game()
	else:
		player_input.clear()
		is_player_turn = false
		for btn in buttons:
			if btn.has_node("AnimationPlayer"):
				btn.get_node("AnimationPlayer").stop()
			if btn.has_node("Sprite2D"):
				btn.get_node("Sprite2D").modulate = Color(1, 1, 1, 1)
		play_pattern()

func _on_orb_collected(body: Node2D) -> void:
	if body == player and replay_uses < max_replays:
		replay_uses += 1
		replay_orb.visible = false
		replay_button.disabled = false
		update_hud()

func _replay_pattern() -> void:
	if replay_uses > 0:
		replay_uses -= 1
		is_player_turn = false
		for btn in buttons:
			if btn.has_node("AnimationPlayer"):
				btn.get_node("AnimationPlayer").stop()
			if btn.has_node("Sprite2D"):
				btn.get_node("Sprite2D").modulate = Color(1, 1, 1, 1)
		play_pattern()
		update_hud()

func update_hud() -> void:
	if not hud_score or not hud_round or not hud_lives or not hud_replays:
		push_error("HUD labels not found!")
		return
	if not hud_score.visible or not hud_round.visible or not hud_lives.visible or not hud_replays.visible:
		push_error("HUD labels are not visible! Check 'Visible' in Inspector.")
	if not replay_button.visible:
		push_error("ReplayButton is not visible! Check 'Visible' in Inspector.")
	hud_score.text = "Score: " + str(score)
	hud_round.text = "Round: " + str(round_num)
	hud_lives.text = "Lives: " + str(lives)
	hud_replays.text = "Replays: " + str(replay_uses) + "/" + str(max_replays)
	if bg_music.stream:
		bg_music.pitch_scale = 1 + (round_num * 0.05)

func get_button_by_color(col: String) -> Area2D:
	for btn in buttons:
		if btn.color.to_lower() == col.to_lower():
			return btn
	push_error("No button found for color:", col)
	return null

func win_game() -> void:
	if bg_music.stream:
		bg_music.stop()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func lose_game() -> void:
	if bg_music.stream:
		bg_music.stop()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
