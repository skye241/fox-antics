extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer
const HIGH_SCORE_DISPLAY = preload("res://scenes/high_score_display/high_score_display.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"): 
		GameManager.load_next_level()


func set_scores() -> void:
	var hsl: Array[HighScore] = GameManager.high_scores.get_scores_list()
	
	for i in hsl:
		var hsdi: HighScoreDisplayItem = HIGH_SCORE_DISPLAY.instantiate()
		hsdi.setup(i)
		grid_container.add_child(hsdi)

func _ready() -> void:
	get_tree().paused = false
	set_scores()
