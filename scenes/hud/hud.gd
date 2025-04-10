extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel

var _score: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_score  = GameManager.cached_score
	on_scored(0)# Replace with function body.



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"): 
		GameManager.load_main()

func _enter_tree() -> void:
	SignalHub.on_scored.connect(on_scored)

func _exit_tree() -> void:
	GameManager.try_add_new_score(_score)
	

func on_scored(points: int) -> void:
	_score += points
	score_label.text = "%05d" % _score
