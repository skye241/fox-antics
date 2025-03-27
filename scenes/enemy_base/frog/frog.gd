extends EnemyBase

var _seen_player: bool = false


# apply gravity
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += _gravity * delta
	flip_me()
# turn to face the player 
func flip_me() -> void:
	animated_sprite_2d.flip_h = _player_ref.global_position.x > global_position.x		


func _on_jump_timer_timeout() -> void:
	pass # Replace with function body.
