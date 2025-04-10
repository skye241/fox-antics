extends Area2D

@export var points: int = 2
@onready var anim: AnimatedSprite2D = $Anim
@onready var sound: AudioStreamPlayer2D = $Sound
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ln: Array[String] = [] 
	for an_name in anim.sprite_frames.get_animation_names():
		ln.push_back(an_name)
	
	anim.animation = ln.pick_random()
	anim.play()
	
	# Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	hide()
	set_deferred("monitoring", false)
	sound.play()
	SignalHub.emit_on_scored(points)


func _on_sound_finished() -> void:
	queue_free() # Replace with function body. # Replace with function body.
