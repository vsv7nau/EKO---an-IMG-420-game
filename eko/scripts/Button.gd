extends Area2D

@export var color: String = "red"
@export var sound: AudioStream

signal pressed(color: String)

var was_pressed: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not was_pressed:
		was_pressed = true
		pressed.emit(color)
		play_sound()
		blink()
		await get_tree().create_timer(0.5).timeout
		was_pressed = false

func blink() -> void:
	if has_node("AnimationPlayer"):
		var anim = $AnimationPlayer
		if anim.has_animation("blink"):
			anim.play("blink")
			await anim.animation_finished
			return
	var sprite = $Sprite2D
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(2, 2, 2, 1), 0.15)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.15)
		await tween.finished

func play_sound() -> void:
	var sfx = get_tree().get_root().get_node("Game/sfx_player")
	if sfx and sound:
		sfx.stream = sound
		sfx.play()
