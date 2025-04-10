extends EnemyBase


@onready var jump_timer: Timer = $JumpTimer

const JUMP_VELOCITY_R: Vector2 = Vector2(100, -150)
const JUMP_VELOCITY_L: Vector2 = Vector2(-100, -150)

var _seen_player: bool = false
var _can_jump: bool = false

#func _ready() -> void:
	#start_timer()
# apply gravity
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += _gravity * delta
	
	if is_on_floor():
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	apply_jump()
	
	flip_me()
	
	move_and_slide()
# turn to face the player 
func flip_me() -> void:
	animated_sprite_2d.flip_h = _player_ref.global_position.x > global_position.x		

func apply_jump() -> void:
	if not is_on_floor() or not _can_jump or not _seen_player:
		return
	
	velocity = JUMP_VELOCITY_R if animated_sprite_2d.flip_h  else JUMP_VELOCITY_L
	_can_jump = false
	start_timer()
	animated_sprite_2d.play("jump")
	
	
func start_timer() -> void: 
	var rand_time: float = randf_range(2.0, 3.0)
	jump_timer.wait_time = rand_time
	jump_timer.start()
 #Start timer w a rand wait time between 2-3 sec


func _on_jump_timer_timeout() -> void:
	_can_jump = true

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not _seen_player:
		_seen_player = true # Replace with function body.
		print("seen player")
		start_timer()
