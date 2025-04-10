extends Node2D

class_name Shooter

@export var speed: float = 50.0
@export var bullet_key: Constants.ObjectType = Constants.ObjectType.BULLET_PLAYER
@export var shoot_delay: float = 0.7
# Called when the node enters the scene tree for the first time.
var _can_shoot: bool = true

@onready var timer: Timer = $Timer
@onready var sound: AudioStreamPlayer2D = $Sound


func _ready() -> void:
	timer.wait_time = shoot_delay

func shoot(direction: Vector2) -> void:
	if _can_shoot:
		_can_shoot = false
		SignalHub.emit_on_create_bullet(
			global_position, direction, speed, bullet_key
		)
		timer.start()
		sound.play()


func _on_timer_timeout() -> void:
	_can_shoot = true # Replace with function body.
