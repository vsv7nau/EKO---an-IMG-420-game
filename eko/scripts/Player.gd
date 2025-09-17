extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("move_right"): direction.x += 1
	if Input.is_action_pressed("move_left"): direction.x -= 1
	if Input.is_action_pressed("move_up"): direction.y -= 1
	if Input.is_action_pressed("move_down"): direction.y += 1
	
	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
	
	# Animation (optional, if AnimationPlayer exists)
	if has_node("AnimationPlayer"):
		if direction != Vector2.ZERO:
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.play("idle")
