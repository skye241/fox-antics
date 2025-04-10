extends AnimatableBody2D

class TargetDistanceTime:
	var _position_to: Vector2
	var _time: float
	
	func _init(position_from: Vector2, position_to: Vector2, speed: float) -> void:
		_time = position_from.distance_to(position_to) / speed
		_position_to = position_to
	
@export var speed: float = 150.0
@export var targets: Array[Marker2D]

var _tween: Tween
var _target_points: Array[TargetDistanceTime]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if targets.size() < 2:
		queue_free() # Replace with function body.
	else:
		#the platform position will be set at the "from" position 
		global_position = targets[0].global_position
	
	setup_points()
	get_moving()
	
	
func _exit_tree() -> void:
	if _tween:
		_tween.kill()

func setup_points(): 
	for i in range(targets.size() - 1):
		var np = TargetDistanceTime.new(targets[i].global_position, targets[i+1].global_position, speed)
		_target_points.append(np)
	
	# Last point to first point
	var np = TargetDistanceTime.new(
		targets[targets.size() - 1].global_position,
		targets[0].global_position,
		speed
	)
	
	_target_points.append(np)

func get_moving() -> void:
	_tween = get_tree().create_tween()
	_tween.set_loops()
	for tp in _target_points:
		_tween.tween_property(self, "global_position", tp._position_to, tp._time)
	#add a small delay in loop tween
	_tween.tween_interval(0.05)
