extends EnemyBase

@export var fly_speed: Vector2 = Vector2(35,15)
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var direction_timer: Timer = $DirectionTimer
@onready var shooter: Shooter = $Shooter

var _fly_direction: Vector2 = Vector2.ZERO


func fly_to_player() -> void:
	animated_sprite_2d.flip_h =  _player_ref.global_position.x > global_position.x		
	var x_dir : int = 1 if animated_sprite_2d.flip_h else -1
	_fly_direction = Vector2(x_dir, 1) * fly_speed 
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity = _fly_direction
	move_and_slide()
	shoot()

func shoot() -> void:
	if player_detector.is_colliding():
		var dir: Vector2 = global_position.direction_to(_player_ref.global_position)
		shooter.shoot(dir)
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("fly")
	direction_timer.start() # Replace with function body.



func _on_direction_timer_timeout() -> void:
	fly_to_player() # Replace with function body.
