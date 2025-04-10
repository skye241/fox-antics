extends VBoxContainer

class_name HighScoreDisplayItem

var _high_score: HighScore = null

@onready var label_score: Label = $LabelScore
@onready var label_time: Label = $LabelTime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _high_score == null:
		queue_free()
	else: 
		label_score.text = "%05d" % _high_score.score
		label_time.text = _high_score.date_scored
		run_tween()
		
func run_tween() -> void:
		var tween: Tween = create_tween()
		tween.tween_property(self, "modulate", Color("#ffffff", 1), 0.8)
	
func setup(high_score: HighScore) -> void:
	_high_score = high_score
