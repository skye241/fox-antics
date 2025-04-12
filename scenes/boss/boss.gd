extends Node2D


@export var lives: int = 2
@export var points: int = 5

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox: Area2D = $Visuals/Hitbox
@onready var shooter: Shooter = $Visuals/Shooter
@onready var sm: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visuals: Node2D = $Visuals

var _invincible: bool = false




func activate_collision() -> void:
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)

func shoot_player() -> void:
	shooter.shoot_at_player()


func tween_hit() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(visuals, "position", Vector2.ZERO, 1.8)
	

func take_damage() -> void:
	if _invincible:
		return
	
	_invincible = true
	sm.travel("hit")
	tween_hit()
	reduce_lives()

func set_invicible (on: bool) -> void:
	_invincible = on
	
	
func reduce_lives() -> void: 
	lives -= 1
	if lives <= 0:
		SignalHub.emit_on_scored(points)
		SignalHub.emit_on_boss_killed()
		queue_free()

func _on_trigger_area_entered(area: Area2D) -> void:
	animation_tree["parameters/conditions/on_trigger"] = true# Replace with function body.
	

func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage() # Replace with function body.
