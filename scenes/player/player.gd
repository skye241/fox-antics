extends CharacterBody2D

class_name Player
const JUMP = preload("res://assets/sound/jump.wav")
const DAMAGE = preload("res://assets/sound/damage.wav")

@export var fell_off_y: float = 600.0
@export var lives: int = 3
@export var camera_min: Vector2 = Vector2(-10000, 10000 )
@export var camera_max: Vector2 = Vector2(10000, -10000)


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var shooter: Shooter = $Shooter
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var hurt_timer: Timer = $HurtTimer
@onready var player_camera: Camera2D = $PlayerCamera

const GRAVITY: float = 690.0
const JUMP_FORCE: float = -300.0
const MOVE_FORCE: float = 120.0
const MAX_FALL : float = 350.0
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -130.0)

var _is_hurt: bool = false
var _invincible: bool = false

func _ready() -> void:
	call_deferred("late_init")
	set_camera_limits()
	

func set_camera_limits() -> void: 
	player_camera.limit_bottom = camera_min.y
	player_camera.limit_left = camera_min.x

	player_camera.limit_top = camera_max.y
	player_camera.limit_right = camera_max.x
	

func late_init() -> void:
	SignalHub.emit_on_player_hit(lives, false)


func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#GRAVITY
	velocity.y += delta * GRAVITY
	
	if _is_hurt:
		return
	
	if is_on_floor():
		jump()
	
	move()
	shoot()
	#setting max fall
	velocity.y = clampf(velocity.y,JUMP_FORCE, MAX_FALL,)
	
	move_and_slide()
	
	update_debug_label()
	
	fallen_off()

func play_effect(effect: AudioStream) -> void:
	sound.stop()
	sound.stream = effect
	sound.play()
	
	
func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		var dir : Vector2 = Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT
		shooter.shoot(dir)

func jump () -> void:
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		play_effect(JUMP)

func move() -> void:

	velocity.x = Input.get_axis("left","right") * MOVE_FORCE
	if not is_equal_approx(velocity.x, 0):
		sprite_2d.flip_h = velocity.x < 0

func update_debug_label() -> void:
	var ds: String = ""
	ds += "Floor: %s\n" %[is_on_floor()]
	ds += "V: %.1f, %.1f\n" % [velocity.x, velocity.y]
	ds += "P: %.1f, %.1f" % [global_position.x, global_position.y]
	
	debug_label.text = ds
	

func fallen_off() -> void:
	if global_position.y < fell_off_y:
		return
	
	reduce_lives(lives)
	
		

func go_invincible() -> void:
	if _invincible:
		return
	
	_invincible = true
	var tween: Tween = create_tween()
	
	for _i in range(3):
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 0.0), 0.5)
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 1.0), 0.5)
		
	tween.tween_property(self, "_invincible",false, 0)

func reduce_lives(reduction: int) -> bool:
	lives -= reduction
	SignalHub.emit_on_player_hit(lives, true)
	
	if lives <= 0:
		set_physics_process(false)
		return false
	else:
		return true
	
func apply_hurt_jump() -> void:
	_is_hurt = true
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()
	play_effect(DAMAGE)


func apply_hit() -> void:
	if _invincible:
		return
	
	#If you died when hit
	if not reduce_lives(1):
		return 
	
	go_invincible()
	apply_hurt_jump()

func _on_hit_box_area_entered(area: Area2D) -> void:
	call_deferred("apply_hit") # Replace with function body.


func _on_hurt_timer_timeout() -> void:
	_is_hurt = false # Replace with function body.
