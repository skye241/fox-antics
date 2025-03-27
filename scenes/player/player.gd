extends CharacterBody2D

class_name Player

@export var fell_off_y: float = 800.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel

const GRAVITY: float = 690.0
const JUMP_FORCE: float = -300.0
const MOVE_FORCE: float = 120.0
const MAX_FALL : float = 350.0 

	
func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#GRAVITY
	velocity.y += delta * GRAVITY
	

	if is_on_floor():
		jump()
	
	move()
	
	#setting max fall
	velocity.y = clampf(velocity.y,JUMP_FORCE, MAX_FALL,)
	
	move_and_slide()
	
	update_debug_label()
	
	fallen_off()

func jump () -> void:
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE

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
	if global_position.y > fell_off_y:
		queue_free()
